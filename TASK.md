> **First:** Read `CLAUDE.md` (project instructions) — you are a **worker**.

# Fix: ServerPoll daemon sends completed discovery updates forever

## Objective

Fix a bug where a ServerPoll daemon that completed Network Discovery causes the server to repeatedly log "Auto-creating session from daemon update" every poll cycle, indefinitely.

## Root Cause (already investigated)

In ServerPoll mode, the **server** polls the **daemon's** `/api/poll` endpoint. When discovery completes:

1. The daemon stores a `terminal_payload` in `DaemonState` that persists until a new session starts (`daemon/runtime/state.rs:169`).
2. Every poll cycle, the server gets this terminal payload (phase=Complete, progress=100).
3. The server calls `update_session()` (`server/discovery/service.rs:622`).
4. The session was already removed from the in-memory `sessions` map after the first terminal processing (line 738).
5. So the auto-create logic triggers (line 632) — creates the session, processes terminal (creates duplicate historical Discovery record), removes it.
6. Repeat forever.

### Normal flow (first completion — works correctly):
- Session IS in `sessions` map → `update_session()` updates it → processes terminal → removes it. No auto-create.

### Bug flow (every subsequent poll):
- Session NOT in `sessions` map → auto-create → process terminal → remove → infinite loop with duplicate historical records.

## Fix

Two changes needed:

### 1. Server: Don't auto-create sessions with terminal phase (`server/discovery/service.rs`)

In `update_session()`, inside the `Vacant` branch (line 632), check if `update.phase.is_terminal()`. If so, log a debug message and return `Ok(())` early instead of auto-creating. The first completion is always handled while the session is still in memory — only redundant repeats hit the auto-create path.

### 2. Server: Clean up `session_last_updated` on terminal removal (`server/discovery/service.rs`)

At line 738, `sessions.remove(&update.session_id)` removes from `sessions` but not from `session_last_updated`. Add `last_updated.remove(&update.session_id)` to prevent unbounded growth. Note: `last_updated` is already acquired as a write lock at line 627.

## Key Files

| File | What |
|------|------|
| `backend/src/server/discovery/service.rs:622-756` | `update_session()` — auto-create logic + terminal processing |
| `backend/src/daemon/runtime/state.rs:140-181` | `get_progress()` — returns terminal payload indefinitely |
| `backend/src/server/daemons/service.rs:1265-1279` | Server-side poll loop that calls `process_discovery_progress` |

## Acceptance Criteria

- [ ] Server no longer repeatedly logs "Auto-creating session" for completed sessions
- [ ] Normal discovery completion still works (session is in memory when first terminal update arrives)
- [ ] No duplicate historical Discovery records are created
- [ ] `session_last_updated` doesn't leak entries for completed sessions
- [ ] Existing tests pass (`cd backend && cargo test`)

## Out of Scope

- Persisting sessions to database (larger architectural change)

## Work Summary

### Approach (revised from original task)

The original task proposed server-only fixes. During implementation, the approach was revised to fix the root cause at the daemon and add a server-side fallback for old daemon versions.

### Changes

**1. Daemon: Clear terminal payload after serving it (`daemon/shared/handlers.rs`)**

In `get_discovery_poll()`, after reading the progress, clear the terminal payload if it's terminal. This means the daemon only serves the terminal state once — the next poll returns `None` for progress. Same delivery guarantee as DaemonPoll mode (single delivery attempt).

**2. Daemon: Add `clear_terminal_payload()` method (`daemon/runtime/state.rs`)**

Simple method that writes `None` to the `terminal_payload` lock. Called by the poll handler above.

**3. Server fallback: `last_updated` tombstone for old daemons (`server/discovery/service.rs`)**

Old daemons won't have the clearing behavior, so the server needs protection. Uses `session_last_updated` as a tombstone: before inserting into `last_updated`, check if the session was already tracked. If a terminal update arrives for a session that's not in `sessions` but IS in `last_updated`, it was already processed — skip it.

This correctly handles server restarts: both `sessions` and `last_updated` are in-memory, so after restart both are empty, and the terminal auto-create path works as intended.

Note: `last_updated` entries for completed sessions are intentionally NOT cleaned up — they serve as tombstones. Growth is negligible (one UUID+DateTime per session for server process lifetime).

### Files Changed

| File | Change |
|------|--------|
| `backend/src/daemon/shared/handlers.rs` | Clear terminal payload after serving in poll handler |
| `backend/src/daemon/runtime/state.rs` | Add `clear_terminal_payload()` method |
| `backend/src/server/discovery/service.rs` | Add `already_seen` tombstone check in `update_session()` |

### Acceptance Criteria Status

- [x] Server no longer repeatedly logs "Auto-creating session" for completed sessions
- [x] Normal discovery completion still works (session is in memory when first terminal update arrives)
- [x] No duplicate historical Discovery records are created
- [x] `session_last_updated` entries for completed sessions are kept as tombstones (not leaked — bounded by server lifetime)
- [x] Existing tests pass (114/114)
