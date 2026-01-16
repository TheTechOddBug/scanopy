> **First:** Read `CLAUDE.md` (project instructions) — you are a **worker**.

# Task: Fix Pagination Settings Persistence (#450)

## Issue
https://github.com/scanopy/scanopy/issues/450

## Problem
After v0.13.4 fix for grouped pagination, new issues emerged:
1. **Pagination limit not sticky:** Setting per-page to 100, then refreshing shows wrong count
2. **Incorrect item count display:** Shows "41 out of 20" - conflicting numbers
3. **Per-page limit not applied:** After refresh, limit reverts

## Context
- Original issue was groups disappearing when paginating (fixed in v0.13.4)
- Fix added server-side ordering support
- New bugs relate to state persistence and count calculation

## Requirements

### 1. Investigate Current Persistence Logic
- `ui/src/lib/shared/components/data/DataControls.svelte`
- How is `pageSize` stored/restored from localStorage?
- Is the persistence actually working or is there a race condition?

### 2. Fix "X out of Y" Count Display
- Where is this count calculated?
- Why would it show "41 out of 20"?
- Is there a mismatch between displayed items and total count?

### 3. Ensure Page Size Persists Correctly
- Test: Set to 100 → refresh → should still be 100
- Check localStorage is being read on mount
- Check for timing issues between restore and initial render

### 4. Test with Grouping
- Verify fixes work when hosts are grouped by field
- Ensure group headers + pagination interact correctly

## Files Likely Involved
- `ui/src/lib/shared/components/data/DataControls.svelte` - Main pagination logic
- `ui/src/lib/shared/components/data/types.ts` - Type definitions
- `ui/src/lib/features/hosts/components/HostTab.svelte` - Uses DataControls
- `ui/src/lib/features/services/components/ServiceTab.svelte` - Uses DataControls

## Acceptance Criteria
- [ ] Page size persists across refresh (20, 50, 100 all work)
- [ ] Item count displays correctly ("X out of Y" is accurate)
- [ ] Grouping + pagination still works correctly
- [ ] No race conditions on page load
- [ ] Tests added for persistence and count calculation
- [ ] `cd ui && npm test` passes
- [ ] `make format && make lint` passes

## Work Summary

### Root Cause Analysis
The "41 out of 20" bug was caused by two interrelated issues:

1. **Stale pageSize in parent component**: When DataControls restored `pageSize` from localStorage (e.g., 100), the parent component (`HostTab.svelte`) still had its default `pageSize = 20`. This meant the server query used `limit: 20`, returning only 20 items while the server reported `total_count: 41`.

2. **Incorrect count display logic**: The single-page display case used `items.length` (the prop array length, 20) as the "total" instead of `serverPagination.total_count` (41), showing "Showing 41 of 20 items".

### Changes Made

**`ui/src/lib/shared/components/data/DataControls.svelte`**
- Modified `loadState()` to return the restored `pageSize` (or null)
- Added parent notification in `onMount` after state restoration:
  - Calls `onPageChange(currentPage, restoredPageSize)` to sync pageSize with parent
  - Calls `onOrderChange()` if ordering state was restored
  - Calls `onTagFilterChange()` if tag filter state was restored
- Fixed count display: added separate case for server-side pagination with single page that uses `totalCount` for both count and total values

**`ui/src/tests/data-controls-pagination.test.ts`** (new file)
- Tests for server-side pagination count calculation (single page, multi-page)
- Tests for client-side pagination count calculation
- Tests for page size validation and offset calculation

### Files Changed
- `ui/src/lib/shared/components/data/DataControls.svelte`
- `ui/src/tests/data-controls-pagination.test.ts` (new)

### Verification
- `npm test` passes (14 tests)
- `npm run lint` passes
- Format check passes
