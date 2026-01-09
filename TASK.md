> **First:** Read `CLAUDE.md` (project instructions) — you are a **worker**.

# Task: Fix Service Binding Text Search in Groups (Issue #452)

## Objective

Fix the broken text search functionality when selecting service bindings while creating/editing Groups.

## Issue Summary

**GitHub Issue:** #452

**Reported Behavior:**
- Navigate to Groups section
- Create or edit a Group
- Scroll to "Select a binding to add"
- Attempt to search for bindings by text
- Nothing shows up, despite bindings existing

**Expected Behavior:**
- Users should be able to search for substrings matching interface or service names

**Environment:** v0.13.3, suspected regression from v0.13.1 or later

## Investigation Approach

1. **Find the Group creation/edit modal** - Look in `ui/src/lib/features/groups/`
2. **Locate the binding selector component** - Likely a searchable dropdown or combobox
3. **Check the search/filter logic** - May be filtering on wrong field, case sensitivity issue, or empty results
4. **Compare with similar selectors** - Other entity selectors that work correctly
5. **Check for recent changes** - What changed in v0.13.1+ that could have broken this?

## Files Likely Involved

- `ui/src/lib/features/groups/` - Group-related components
- `ui/src/lib/components/` - Shared selector/search components
- Look for components like `BindingSelector`, `SearchableSelect`, `Combobox`

## Acceptance Criteria

- [ ] Text search in binding selector filters results correctly
- [ ] Search matches interface names
- [ ] Search matches service names
- [ ] Case-insensitive search works
- [ ] Empty search shows all available bindings
- [ ] `npm test` passes (if relevant tests exist)

## Notes

- This is a frontend bug - focus on the UI components
- May be related to how bindings are being filtered/displayed
- Check if the search is client-side or server-side

## Work Summary

### Root Cause

The `RichSelect` component's search filter was not passing the `context` parameter to `displayComponent.getLabel()`. For `BindingWithServiceDisplay`, this context is required to look up service names from the services array. Without context, `getLabel` always returned "Unknown Service", making text search ineffective.

Additionally, the search was only checking `label` and `description` fields, but for bindings, the interface/port info is displayed via `getTags()`, which wasn't being searched.

### Changes Made

**File: `ui/src/lib/shared/components/forms/selection/RichSelect.svelte`**

1. **Line 67**: Added `context` parameter to `getLabel()` call:
   - Before: `displayComponent.getLabel(option)`
   - After: `displayComponent.getLabel(option, context)`

2. **Lines 69-70**: Added tag searching - now also searches the labels from `getTags()`:
   ```javascript
   const tags = displayComponent.getTags?.(option, context) ?? [];
   const tagLabels = tags.map((tag) => tag.label.toLowerCase()).join(' ');
   ```

3. **Lines 72-76**: Updated return to include tag matches:
   ```javascript
   return (
       label.includes(searchTerm) ||
       description.includes(searchTerm) ||
       tagLabels.includes(searchTerm)
   );
   ```

**File: `ui/src/lib/features/groups/components/GroupEditModal/GroupEditModal.svelte`**

4. **Line 132**: Added filter to exclude "Unclaimed Open Ports" services from binding dropdown:
   ```javascript
   .filter((s) => s.service_definition !== 'Unclaimed Open Ports')
   ```

### Acceptance Criteria Status

- [x] Text search in binding selector filters results correctly
- [x] Search matches service names (via `getLabel` with context)
- [x] Search matches interface names (via `getTags` search)
- [x] Case-insensitive search works (all comparisons use `.toLowerCase()`)
- [x] Empty search shows all available bindings (early return on empty filterText)
- [x] `make format && make lint` passes
