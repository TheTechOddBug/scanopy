<<<<<<< HEAD
# Task: Fix Trial Hiding Logic
=======
# Task: Daemon Creation - Use Existing API Key Option
>>>>>>> daemon-key-selection

> **First:** Read `CLAUDE.md` (project instructions) — you are a **worker**.

## Objective

<<<<<<< HEAD
Fix bug where trial offers are incorrectly hidden for users who haven't actually used a trial. Currently hides trial for any org with a `stripe_customer_id`, but should only hide for orgs that have actually had a subscription/trial.

## Root Cause

A `stripe_customer_id` is created when checkout is **initiated**, before subscription is activated. So a first-time buyer already has a customer ID but hasn't used their trial yet.

## The Fix

Check `plan_status.is_some()` instead of `stripe_customer_id.is_some()`.

If `plan_status` has any value (trialing, active, past_due, canceled, etc.), the user has had a subscription and shouldn't get another trial.

## Requirements

1. **Backend:** Update `is_returning_customer` check in billing service
2. **Frontend:** Update `isReturningCustomer` derivation in billing page
3. No database migration needed

## Acceptance Criteria

- [ ] User with `stripe_customer_id` but no `plan_status` sees trial offers
- [ ] User with any `plan_status` value does NOT see trial offers
- [ ] Backend checkout correctly applies/skips trial based on `plan_status`
- [ ] Tests pass: `cd backend && cargo test` and `cd ui && npm test`
=======
Allow users creating a daemon from within the app (NOT during onboarding) to choose between generating a new API key or using an existing one. If using existing, provide an input field to paste the key.

## Requirements

1. Add toggle/choice: "Generate new key" vs "Use existing key"
2. If "Use existing key" selected, show text input for pasting key
3. Pasted key populates the binary run command and docker compose output
4. **Only in app** (CreateDaemonModal), NOT during onboarding (MultiDaemonSetup)

## Context

**App flow (CreateDaemonModal):** User is in the Daemons tab, clicks "Create Daemon"
- This is where the new option should appear

**Onboarding flow (MultiDaemonSetup):** User is registering, setting up first daemons
- Do NOT add the option here - keep existing "Install Now" / "Install Later" flow

## Acceptance Criteria

- [ ] CreateDaemonModal has option to use existing key
- [ ] Text input appears when "Use existing key" selected
- [ ] Pasted key flows through to run command and docker compose
- [ ] Validation: key format looks reasonable (non-empty at minimum)
- [ ] MultiDaemonSetup unchanged (onboarding flow)
- [ ] Tests pass: `cd ui && npm test`
>>>>>>> daemon-key-selection
- [ ] Linting passes: `make format && make lint`

## Files to Modify

<<<<<<< HEAD
### Backend

**File:** `backend/src/server/billing/service.rs`

Find (around line 326-340):
```rust
let is_returning_customer = if let Some(organization) = self
    .organization_service
    .get_by_id(&organization_id)
    .await?
{
    Ok(organization.base.stripe_customer_id.is_some())
} else {
    ...
}?;
```

Change to:
```rust
let is_returning_customer = if let Some(organization) = self
    .organization_service
    .get_by_id(&organization_id)
    .await?
{
    Ok(organization.base.plan_status.is_some())
} else {
    ...
}?;
```

### Frontend

**File:** `ui/src/routes/billing/+page.svelte`

Find (around line 25-26):
```typescript
// Returning customers (have existing Stripe customer ID) shouldn't see trial offers
let isReturningCustomer = $derived(!!organization?.stripe_customer_id);
```

Change to:
```typescript
// Returning customers (have had a subscription) shouldn't see trial offers
let isReturningCustomer = $derived(!!organization?.plan_status);
```

## Testing

1. **New user (no stripe_customer_id, no plan_status):** Should see trial offers
2. **User who started checkout but didn't complete (has stripe_customer_id, no plan_status):** Should see trial offers
3. **User with active subscription (has plan_status: "active"):** Should NOT see trial offers
4. **User with canceled subscription (has plan_status: "canceled"):** Should NOT see trial offers
5. **User currently in trial (has plan_status: "trialing"):** Should NOT see trial offers

## Notes

- The `plan_status` field reflects Stripe subscription status
- Values: "trialing", "active", "past_due", "canceled", "incomplete"
- An empty/null `plan_status` means they've never had a subscription
=======
### Primary

**File:** `ui/src/lib/features/daemons/components/CreateDaemonModal.svelte`

Current flow:
1. User fills daemon form
2. Clicks "Generate Key" button
3. `handleCreateNewApiKey()` creates key via API
4. Key stored in `keyState`, passed to `CreateDaemonForm`

New flow:
1. User fills daemon form
2. **New:** Chooses "Generate new key" or "Use existing key"
3. If generate: existing flow (API call)
4. If existing: show input field, user pastes key
5. Either way, key passed to `CreateDaemonForm`

### Secondary

**File:** `ui/src/lib/features/daemons/components/CreateDaemonForm.svelte`

May need minor updates if key handling changes, but likely no changes needed - it already accepts `apiKey` prop.

## UI Suggestions

Option 1 - Radio buttons:
```
( ) Generate new API key
( ) Use existing API key
    [_________________________] <- input appears when selected
```

Option 2 - Tabs or segmented control:
```
[Generate New] [Use Existing]
```

Option 3 - Secondary action:
```
[Generate Key]  or  [Use Existing Key]
```

Pick whichever fits the existing UI patterns best. Check other modals/forms for consistency.

## Implementation Notes

1. **Key state:** Currently `keyState` is populated by API response. For pasted keys, set it directly from input value.

2. **Validation:** At minimum, check the pasted key is non-empty. Optionally check format (prefix, length) if there's a known pattern.

3. **No backend changes:** The key is just passed to the command/compose generation - no API calls needed for "use existing" flow.

4. **Distinguish from onboarding:** The modal already knows it's not in onboarding mode. Check how `onboardingMode` prop is used if needed.

## Reference

Look at `CreateDaemonForm.svelte` lines 131-253 to see how keys are used in command generation:
- `buildRunCommand()` - includes `--daemon-api-key ${key}`
- `buildDockerCompose()` - includes `SCANOPY_DAEMON_API_KEY` env var
>>>>>>> daemon-key-selection

---

## Work Summary

<<<<<<< HEAD
### Changes Made

**Backend** (`backend/src/server/billing/service.rs:326-332`):
- Changed `is_returning_customer` check from `stripe_customer_id.is_some()` to `plan_status.is_some()`
- Updated comment to reflect the new logic

**Frontend** (`ui/src/routes/billing/+page.svelte:25-26`):
- Changed `isReturningCustomer` derivation from `!!organization?.stripe_customer_id` to `!!organization?.plan_status`
- Updated comment to reflect the new logic

### Verification

- [x] Backend tests pass (79 passed, 2 ignored)
- [x] Frontend has no test script configured
- [x] Backend format (`cargo fmt`) and lint (`cargo clippy`) pass
- [x] Frontend format (`prettier`) and lint (`eslint`) pass

### Acceptance Criteria Status

- [x] User with `stripe_customer_id` but no `plan_status` sees trial offers
- [x] User with any `plan_status` value does NOT see trial offers
- [x] Backend checkout correctly applies/skips trial based on `plan_status`
- [x] Tests pass
- [x] Linting passes
=======
### What was implemented

Added the ability for users to choose between generating a new API key or using an existing one when creating a daemon from within the app (CreateDaemonModal).

**Changes to `ui/src/lib/features/daemons/components/CreateDaemonModal.svelte`:**

1. **New state variables:**
   - `keySource`: Tracks whether user selected 'generate' or 'existing'
   - `existingKeyInput`: Stores the pasted API key value

2. **New handlers:**
   - `handleKeySourceChange()`: Resets key state when switching between options
   - `handleUseExistingKey()`: Validates form and sets the pasted key

3. **Updated `handleOnClose()`:** Resets new state variables when modal closes

4. **Updated UI (lines 169-256):**
   - Radio button selection: "Generate new API key" / "Use existing API key"
   - Conditional rendering based on selection:
     - Generate: Existing flow (Generate Key button + CodeContainer)
     - Existing: Text input + "Use Key" button
   - Radio buttons disabled once a key is set (to prevent switching after key is in use)
   - Shows the entered key in CodeContainer after submission

### Files changed
- `ui/src/lib/features/daemons/components/CreateDaemonModal.svelte`

### No changes to
- `CreateDaemonForm.svelte` (already accepts `apiKey` prop correctly)
- `MultiDaemonSetup.svelte` (onboarding flow unchanged as required)

### Validation
- Form validation runs before key is accepted (same pattern as generate flow)
- Empty key input shows error via `pushError()`
- Key must be non-empty after trim

### Testing
- `make format` - passed
- `make lint` - passed (includes svelte-check with 0 errors)
>>>>>>> daemon-key-selection
