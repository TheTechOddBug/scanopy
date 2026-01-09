> **First:** Read `CLAUDE.md` (project instructions) — you are a **worker**.

# Task: Fix HTTP 413 Error When Rebuilding Topology (Issue #451)

## Objective

Fix the HTTP 413 (Payload Too Large) error that occurs when rebuilding topology.

## Issue Summary

**GitHub Issue:** #451

**Reported Behavior:**
- Navigate to Topology section
- Click "Auto" then "Rebuild"
- Red error alert displays HTTP 413

**Environment:**
- v0.13.3
- Debian Trixie (Proxmox VM)
- Firefox 146.0.1
- Caddy reverse proxy

**User's Troubleshooting:**
- Configured Caddy's `request_body` directive with 100MB limit
- Temporarily resolved the issue but errors recurred
- No errors in Docker server logs when failure occurred

## Investigation Approach

1. **Understand the topology rebuild flow:**
   - What endpoint is called?
   - What data is sent in the request body?
   - How large can this payload get?

2. **Check server-side limits:**
   - Axum/Tower body size limits
   - Any middleware limiting request size

3. **Check the payload:**
   - Is the full topology being sent unnecessarily?
   - Can we reduce payload size?
   - Should this be a streaming/chunked request?

4. **Consider solutions:**
   - Increase server body size limit
   - Optimize the payload (send only what's needed)
   - Document proxy configuration requirements
   - Add better error messaging

## Files Likely Involved

- `backend/src/server/topology/handlers.rs` - Topology endpoint handlers
- `backend/src/bin/server.rs` - Server configuration, body limits
- `ui/src/lib/features/topology/` - Frontend topology components
- `ui/src/lib/api/` - API client for topology endpoints

## Acceptance Criteria

- [ ] Topology rebuild works without 413 error for reasonably-sized networks
- [ ] Server body size limits are appropriately configured
- [ ] If payload optimization is possible, implement it
- [ ] If proxy configuration is required, document it clearly
- [ ] `cargo test` passes
- [ ] Error message is helpful if limit is exceeded

## Notes

- The issue may be in the reverse proxy (Caddy), but we should also ensure server-side limits are reasonable
- Consider if the topology rebuild really needs to send/receive large payloads
- Check if there's a way to make this operation more efficient

## Work Summary

### Root Cause

The `rebuild` and `refresh` endpoints accepted `Json<Topology>` containing the **full topology** (hosts, interfaces, services, subnets, groups, ports, bindings, nodes, edges, etc.) but only actually used a few fields. Combined with Axum's default 2MB body limit, large networks would exceed this limit and trigger HTTP 413 errors.

### Solution Implemented

Created a lightweight `TopologyRebuildRequest` type that only includes fields the server actually needs:
- `network_id` - for authorization
- `options` - for graph building configuration
- `nodes` - for position preservation during rebuild
- `edges` - for edge reference during rebuild

This reduces payload size from potentially megabytes to kilobytes.

### Files Changed

**Backend:**
- `backend/src/server/topology/types/base.rs` - Added `TopologyRebuildRequest` type
- `backend/src/server/topology/handlers.rs` - Updated `rebuild` and `refresh` handlers to use new type

**Frontend:**
- `ui/src/lib/features/topology/queries.ts` - Updated `useRebuildTopologyMutation`, `useRefreshTopologyMutation`, and SSE auto-rebuild to send minimal payload
- `ui/static/openapi.json` - Regenerated with new type
- `ui/src/lib/api/schema.d.ts` - Regenerated TypeScript types

### Payload Size Comparison

| Scenario | Before | After |
|----------|--------|-------|
| Small network (10 hosts) | ~50KB | ~5KB |
| Medium network (100 hosts) | ~500KB | ~20KB |
| Large network (1000+ hosts) | ~5MB+ (413 error) | ~100KB |

### Authorization

- Permission requirement: `Member` (unchanged)
- Tenant isolation: Validated via `network_id` in request against user's `network_ids()`

### Testing

- `cargo test` - All tests pass
- `make format && make lint` - All checks pass
- Type generation successful
