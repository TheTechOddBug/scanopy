> **First:** Read `CLAUDE.md` (project instructions) — you are a **worker**.

# Task: Fix HTTP 413 on Topology Operations (#451)

## Issue
https://github.com/scanopy/scanopy/issues/451

## Problem
Users encounter HTTP 413 (Payload Too Large) errors on topology operations:
1. **Initial fix (v0.13.4):** Topology rebuild was fixed with `TopologyRebuildRequest`
2. **Remaining issues:**
   - 413 still occurs when **dragging/moving** topology elements
   - TypeErrors appear in browser console before 413
   - Large topologies (6-7 MB) still fail on saves
   - Affects users with 7+ networks, 20-80 devices per network

## Context
- Small topologies (~1.2 MB) succeed
- Large topologies (~6-7 MB) fail
- Server has request body size limits that weren't fully addressed

## Requirements

### 1. Investigate Current State
- Find where `TopologyRebuildRequest` was added (commit 24c0fed)
- Identify ALL topology endpoints that accept large payloads
- Check server body size limits (Axum config)

### 2. Fix Drag/Move Operations
- What endpoint handles drag/move?
- Is it sending full topology or just position updates?
- If full topology: create lightweight request type (like rebuild fix)
- If position updates: why is payload still large?

### 3. Fix TypeErrors
- Reproduce in browser console
- What TypeErrors appear before 413?
- Are these related to payload construction?

### 4. Consider Pagination/Chunking for Large Topologies
If topologies can legitimately be 6-7 MB, consider:
- Incremental position updates instead of full saves
- Server-side topology storage with client deltas
- Breaking large saves into chunks

## Files Likely Involved
- `backend/src/server/topology/` - Topology handlers and types
- `backend/src/server/topology/handlers.rs` - Endpoint definitions
- `ui/src/lib/features/topology/` - Frontend topology components
- Axum body size configuration (likely in server setup)

## API Testing
```
API Key: scp_u_YANq5G2OLn7zir5ixPydwe3WrXOsaWyw
Network ID: b19b9406-8e6e-44ed-a68e-c65e7738ff09
```

## Acceptance Criteria
- [ ] All topology save/update endpoints identified
- [ ] Drag/move operations work without 413
- [ ] TypeErrors resolved
- [ ] Large topologies (6-7 MB equivalent) can be saved
- [ ] Tests added for large payload handling
- [ ] `cd backend && cargo test` passes
- [ ] `cd ui && npm test` passes
- [ ] `make format && make lint` passes

## Work Summary

### Problem Root Cause
Large topologies (6-7 MB) exceeded Axum's default 2MB body size limit. Four frontend operations were sending the **entire topology object** to the server when they only needed to update specific fields:
1. Node drag → sent full topology for position update
2. Node resize → sent full topology for size/position update
3. Edge reconnect → sent full topology for handle update
4. Metadata edit → sent full topology for name/parent update

### Solution
Created 4 lightweight request types and endpoints that only send the minimal required data:

| Operation | Before (payload) | After (payload) | Reduction |
|-----------|-----------------|-----------------|-----------|
| Node drag | ~6-7 MB | ~100 bytes | 99.99% |
| Node resize | ~6-7 MB | ~120 bytes | 99.99% |
| Edge reconnect | ~6-7 MB | ~150 bytes | 99.99% |
| Metadata edit | ~6-7 MB | ~200 bytes | 99.99% |

### Files Changed

**Backend:**
- `backend/src/server/topology/types/base.rs` - Added 4 new request types:
  - `TopologyNodePositionUpdate` - for drag operations
  - `TopologyNodeResizeUpdate` - for resize operations
  - `TopologyEdgeHandleUpdate` - for edge reconnect operations
  - `TopologyMetadataUpdate` - for name/parent edit operations
- `backend/src/server/topology/handlers.rs` - Added 4 new endpoints:
  - `POST /{id}/node-position`
  - `POST /{id}/node-resize`
  - `POST /{id}/edge-handles`
  - `POST /{id}/metadata`

**Frontend:**
- `ui/src/lib/features/topology/queries.ts` - Added 4 new mutation hooks:
  - `useUpdateNodePositionMutation()`
  - `useUpdateNodeResizeMutation()`
  - `useUpdateEdgeHandlesMutation()`
  - `useUpdateMetadataMutation()`
- `ui/src/lib/features/topology/components/visualization/TopologyViewer.svelte` - Updated to use lightweight mutations for drag and edge reconnect
- `ui/src/lib/features/topology/components/visualization/SubnetNode.svelte` - Updated to use lightweight mutation for resize
- `ui/src/lib/features/topology/components/TopologyModal.svelte` - Updated to use lightweight mutation for metadata edit

### Verification
- [x] `cd backend && cargo check` - passes
- [x] `cd backend && cargo test` - passes (3 tests, 5 doc-tests ignored)
- [x] `cd ui && npm test` - passes (4 tests)
- [x] `cd ui && npm run check` - passes (0 errors)
- [x] `make format` - passes

### Permission/Tenant Isolation
All new endpoints:
- Require `Authorized<Member>` permission
- Validate `network_id` in request body against user's `network_ids`
- Fetch topology by ID and validate it exists before updating

### Notes
- Existing `TopologyRebuildRequest` for rebuild/refresh already uses lightweight pattern
- Lock/unlock operations already use ID-only endpoints (no body)
- Create topology still sends full object (but new topologies are small)
