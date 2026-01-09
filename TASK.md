> **First:** Read `CLAUDE.md` (project instructions) — you are a **worker**.

# Task: Fix Grouped Hosts Pagination UX (Issue #450)

## Objective

Fix the unintuitive pagination behavior when hosts are grouped (e.g., by "Virtualized by").

## Issue Summary

**GitHub Issue:** #450

**Reported Behavior:**
- Navigate to Hosts section
- Apply grouping by "Virtualized by"
- Change the page number
- Groups with no additional pages disappear from the display
- Pagination applies globally to all groups simultaneously

**Expected Behavior (per reporter):**
- Individual paginators for each group
- Option to view all pages simultaneously
- Groups shouldn't vanish when paginating

**Environment:** v0.13.3

## Investigation Approach

1. **Understand current pagination implementation:**
   - Is pagination server-side or client-side?
   - How does grouping interact with pagination?
   - What determines which groups are visible?

2. **Analyze the UX problem:**
   - Global pagination + grouping = confusing results
   - Items from one group may be on page 1, items from another on page 2

3. **Consider solutions:**
   - **Option A:** Per-group pagination (more complex, best UX)
   - **Option B:** When grouped, show all items (no pagination)
   - **Option C:** When grouped, increase page size significantly
   - **Option D:** "Expand all" option within groups

4. **Check similar implementations:**
   - How do other tables/lists handle grouped pagination in this codebase?

## Files Likely Involved

- `ui/src/lib/features/hosts/` - Host list components
- `ui/src/lib/components/` - Shared table/list/pagination components
- Look for `DataTable`, `Pagination`, `GroupedList` type components

## Acceptance Criteria

- [ ] Grouped hosts display has intuitive pagination behavior
- [ ] Groups don't disappear unexpectedly when paginating
- [ ] Users can navigate through grouped data effectively
- [ ] Solution is consistent with other grouped displays in the app
- [ ] `npm test` passes

## Design Considerations

This is a UX improvement, so consider:
- What's the simplest solution that fixes the confusion?
- What do users actually need when viewing grouped hosts?
- Is per-group pagination worth the complexity, or is disabling pagination when grouped sufficient?

## Notes

- This is a frontend UX bug/improvement
- May require changes to shared pagination components
- Consider performance implications of showing all items when grouped

## Work Summary

### Solution Implemented

Added **server-side ordering** support to the hosts and services list endpoints. When grouping is active, the server returns items sorted by the group field, keeping groups contiguous across pages. This prevents groups from appearing/disappearing as users paginate.

**Example:** When grouped by "Virtualized By":
- Page 1: All VMware hosts (sorted by group field)
- Page 2: Remaining VMware hosts + start of KVM hosts
- Page 3: Remaining KVM hosts + Bare Metal hosts

### Backend Changes

**`backend/src/server/shared/storage/filter.rs`**
- Extended `EntityFilter` with `joins` field and `join()`, `to_join_clause()`, `has_joins()` methods

**`backend/src/server/shared/storage/generic.rs`**
- Updated `get_all_ordered` and `get_paginated` to use JOIN clauses from filter
- Uses table-qualified SELECT when JOINs are present to avoid column conflicts

**`backend/src/server/shared/handlers/query.rs`**
- Added `OrderDirection` enum (asc/desc) with `to_sql()` method

**`backend/src/server/hosts/handlers.rs`**
- Added `HostOrderField` enum with `to_sql()` and `join_sql()` methods
- Added `HostFilterQuery` struct with `group_by`, `order_by`, `order_direction` params
- Updated `get_all_hosts` handler to use new query struct

**`backend/src/server/hosts/service.rs`**
- Updated `get_all_host_responses_paginated` to accept `order_by` parameter

**`backend/src/server/services/handlers.rs`**
- Added `ServiceOrderField` enum with `to_sql()` and `join_sql()` methods
- Added `ServiceFilterQuery` struct (same pattern as hosts)
- Replaced generated handler with custom `get_all_services` handler

**`backend/src/server/openapi.rs`**
- Registered `OrderDirection`, `HostOrderField`, `ServiceOrderField` schemas

### Frontend Changes

**`ui/src/lib/shared/components/data/DataControls.svelte`**
- Added `onOrderChange` callback prop that exposes group/sort state changes
- Effect that tracks ordering changes and resets pagination to page 1

**`ui/src/lib/features/hosts/queries.ts`**
- Updated `HostQueryOptions` to include `group_by`, `order_by`, `order_direction`
- Updated `useHostsQuery` to pass ordering params to API

**`ui/src/lib/features/hosts/components/HostTab.svelte`**
- Added ordering state (`groupBy`, `orderBy`, `orderDirection`)
- Added `handleOrderChange` handler with field key to backend enum mapping
- Wired up `onOrderChange` to DataControls

**`ui/src/lib/features/services/queries.ts`**
- Updated `ServicesQueryParams` to include ordering parameters
- Updated `useServicesQuery` to pass ordering params to API

**`ui/src/lib/features/services/components/ServiceTab.svelte`**
- Same pattern as HostTab (ordering state, handler, mapping)

### Key Design Decisions

1. **Rust enums as source of truth:** `HostOrderField` and `ServiceOrderField` define orderable fields, generating TypeScript union types via OpenAPI
2. **EntityFilter handles JOINs:** JOINs flow through the existing query builder via `filter.join()` method
3. **Consolidated `join_sql()` method:** Returns `Option<&str>` - if Some, the JOIN is needed
4. **Separate `group_by` and `order_by` params:** Enables compound ORDER BY (group first ASC, then sort with configurable direction)
5. **Reset to page 1 on order change:** Per user preference

### Verification

- [x] Backend unit tests pass (84 passed)
- [x] Frontend type checking passes (svelte-check: 0 errors)
- [x] `make format && make lint` passes
- [x] TypeScript types generated correctly with new enum types

### Files Changed

| File | Change Type |
|------|-------------|
| `backend/src/server/shared/storage/filter.rs` | Modified |
| `backend/src/server/shared/storage/generic.rs` | Modified |
| `backend/src/server/shared/handlers/query.rs` | Modified |
| `backend/src/server/hosts/handlers.rs` | Modified |
| `backend/src/server/hosts/service.rs` | Modified |
| `backend/src/server/services/handlers.rs` | Modified |
| `backend/src/server/openapi.rs` | Modified |
| `ui/src/lib/shared/components/data/DataControls.svelte` | Modified |
| `ui/src/lib/features/hosts/queries.ts` | Modified |
| `ui/src/lib/features/hosts/components/HostTab.svelte` | Modified |
| `ui/src/lib/features/services/queries.ts` | Modified |
| `ui/src/lib/features/services/components/ServiceTab.svelte` | Modified |
| `ui/src/lib/api/schema.d.ts` | Auto-generated |
