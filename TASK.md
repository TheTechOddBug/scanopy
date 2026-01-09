> **First:** Read `CLAUDE.md` (project instructions) — you are a **worker**.

# Task: Fix Host Icon from Best Service (Issue #449)

## Objective

Fix the regression where host icons no longer display the icon from the "best" or "top" service.

## Issue Summary

**GitHub Issue:** #449

**Reported Behavior:**
- Navigate to Hosts section
- Observe host icons
- Question marks appear instead of service icons

**Expected Behavior:**
- Icons should display for the top-performing/best service
- Matches behavior from v0.12.x

**Additional Context:**
- In v0.12.x, a dropdown existed on host details page to select icon display strategy
- This configuration option is no longer available in current version
- Reporter unsure if removal was intentional

**Environment:** v0.13.3, regression since v0.13.2

---

## Work Summary

### Root Cause

The issue was a race condition combined with incorrect fallback logic in `HostCard.svelte`.

**The problematic code:**
```javascript
Icon:
    serviceDefinitions.getIconComponent(hostServices[0]?.service_definition) ||
    entities.getIconComponent('Host'),
```

**What happened:**
1. On initial render, services haven't loaded yet → `hostServices` is `[]`
2. `hostServices[0]?.service_definition` evaluates to `undefined`
3. `getIconComponent(undefined)` returns `HelpCircle` (question mark icon)
4. `HelpCircle` is truthy, so the `|| entities.getIconComponent('Host')` fallback never triggers
5. When services load, the derived block should re-run, but the initial `HelpCircle` was being shown inconsistently

The inconsistency occurred because:
- Sometimes TanStack Query had cached data → services available immediately → correct icon
- Sometimes cache miss → initial render shows `HelpCircle` → re-render timing issues

### Fix

Changed the fallback logic to explicitly check if services exist:

```javascript
Icon:
    hostServices.length > 0
        ? serviceDefinitions.getIconComponent(hostServices[0].service_definition)
        : entities.getIconComponent('Host'),
```

This ensures:
- If no services (yet or ever) → Host icon is shown (not HelpCircle)
- If services exist → first service's icon is shown

### Files Changed

1. **`ui/src/lib/features/hosts/components/HostCard.svelte`** (lines 94-97)
   - Changed from `||` fallback to explicit ternary with `hostServices.length > 0` check

### Regarding Icon Strategy Dropdown

No evidence of an "icon strategy" dropdown exists in the current codebase. The implementation uses the first service (sorted by position) to determine the host icon. This appears to be the intended behavior.

### Verification

- `npm run check` (svelte-check): 0 errors, 0 warnings
- `npm run format && npm run lint`: Passes
