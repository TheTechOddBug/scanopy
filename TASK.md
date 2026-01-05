# Task: Pricing Table "Gimme Features" Research & Implementation

> **First:** Read `CLAUDE.md` (project instructions) — you are a **worker**.

## Objective

Research how successful SaaS companies position "value reinforcement" features in pricing tables, then propose and implement features that highlight Scanopy's value—even if they're included in all plans.

## Context

Many SaaS pricing pages list features that are the same across all plans to reinforce value. Examples:
- "Unlimited Scans"
- "Docker Integration"
- "Real-time Updates"
- "Secure by Default"

These aren't differentiators between plans, but they help users understand what they're getting and justify the price.

## Approach

**Phase 1: Research** (report findings before implementing)
- Study 5-10 SaaS pricing pages (network monitoring, DevOps, infrastructure tools)
- Identify patterns for "included in all plans" features
- Note what resonates for Scanopy's use case

**Phase 2: Propose**
- List 5-10 candidate features for Scanopy
- Recommend which to add and how to display them

**Phase 3: Implement**
- Add features to backend definitions
- Update frontend pricing table display
- Regenerate website fixtures

## Research Targets

Look at pricing pages for:
- Network/infrastructure monitoring: Datadog, New Relic, Zabbix, PRTG, Auvik
- DevOps/scanning tools: Snyk, Qualys, Tenable
- Similar indie/SMB tools: Tailscale, Netdata, Uptime Kuma (if commercial)

Questions to answer:
1. What "universal features" do they highlight?
2. How are they displayed (checkmarks, badges, separate section)?
3. What categories do they use?
4. What language/phrasing works well?

## Current Feature System

### Backend Definitions

**Features enum:** `backend/src/server/billing/types/features.rs`
```rust
pub enum Feature {
    ShareViews,
    RemoveCreatedWith,
    AuditLogs,
    Webhooks,
    ApiAccess,
    // ... etc
}
```

Each feature has:
- ID (snake_case string)
- Name (human readable)
- Description
- Category (Support, Licensing, Enterprise, Integrations, Sharing)
- Coming soon flag

**Plan features:** `backend/src/server/billing/types/base.rs`
```rust
pub struct BillingPlanFeatures {
    pub share_views: bool,
    pub webhooks: bool,
    pub api_access: bool,
    // ... etc
}
```

**Plan definitions:** `backend/src/server/billing/plans.rs`
- `get_default_plans()` - SaaS plans
- `get_website_fixture_plans()` - All plans for website

### Frontend Display

**Component:** `ui/src/lib/features/billing/BillingPlanForm.svelte`
- Displays plans in grid
- Shows features by category (collapsible sections)
- Checkmarks for included features

### Fixtures

**Generated files:** `ui/static/billing-plans.json`, `ui/static/features-next.json`
**Generator:** `backend/tests/integration/fixtures.rs` → `generate_billing_plans_json()`

These fixtures are used by the marketing website.

## Implementation Notes

### Adding a New Universal Feature

1. **Add to Feature enum** (`features.rs`):
```rust
UnlimitedScans, // or whatever
```

2. **Implement TypeMetadataProvider** for it:
```rust
Feature::UnlimitedScans => TypeMetadata {
    id: "unlimited_scans",
    name: "Unlimited Scans",
    description: "No limits on network discovery scans",
    category: Some("Core"), // may need new category
    coming_soon: false,
}
```

3. **Add to BillingPlanFeatures struct** (`base.rs`):
```rust
pub unlimited_scans: bool,
```

4. **Set to true for all plans** in `features()` method

5. **Regenerate fixtures**:
```bash
cd backend && cargo test generate_billing_plans_json -- --ignored
```

### Display Considerations

- May want a separate "Included in all plans" section vs per-plan checkmarks
- Could use badges/pills instead of checkmarks for universal features
- Consider a "Core Features" category that appears first

## Deliverables

1. **Research summary** in this file (Phase 1)
2. **Feature proposal** with recommendations (Phase 2)
3. **Implementation** with tests passing (Phase 3)
4. **Regenerated fixtures** committed

## Acceptance Criteria

- [ ] Research documented with examples from 5+ competitors
- [ ] 5-10 features proposed with rationale
- [ ] Features implemented in backend (Feature enum, BillingPlanFeatures)
- [ ] Frontend displays new features appropriately
- [ ] Fixtures regenerated (`ui/static/billing-plans.json`, `ui/static/features-next.json`)
- [ ] Tests pass: `cd backend && cargo test` and `cd ui && npm test`
- [ ] Linting passes: `make format && make lint`

## Important

**Report back after Phase 1 & 2** (research + proposal) before implementing. The specific features to add should be reviewed before coding.

---

## Research Findings

### Competitors Analyzed (8)

| Company | Category | Notable Universal Features |
|---------|----------|---------------------------|
| **Datadog** | Monitoring | 1,000+ integrations, unlimited alerting, out-of-box dashboards |
| **New Relic** | Monitoring | 750+ integrations, unlimited hosts/agents/containers, 100GB free data |
| **Snyk** | Security | IDE plugins, data encryption (transit + rest), SOC 2/GDPR/ISO compliance |
| **Tailscale** | Networking | End-to-end encryption (WireGuard), UI/CLI/API access, IPv4 & IPv6 |
| **Netdata** | Monitoring | Unlimited metrics, customizable charts |
| **Auvik** | Network mgmt | Unlimited users, unlimited sites, out-of-box alerts, no maintenance fees |
| **Tenable** | Security | Continuous discovery, fully documented API, real-time visualization |
| **Grafana** | Observability | 100+ pre-built solutions, 20+ data source plugins |

### Key Patterns Identified

**1. "Unlimited" Language**
Most competitors emphasize unlimited quantities for core functionality:
- Unlimited users/seats (Auvik, New Relic)
- Unlimited hosts/agents/containers (New Relic)
- Unlimited integrations/metrics (Datadog, Netdata)

**2. Integration/Ecosystem Numbers**
Specific counts reinforce breadth of value:
- "1,000+ integrations" (Datadog)
- "750+ integrations" (New Relic)
- "200+ service definitions" (Scanopy already has this!)

**3. Security as Baseline**
Security features positioned as universal, not premium:
- Data encryption in transit and at rest (Snyk)
- End-to-end encryption (Tailscale)
- SOC 2/GDPR compliance certifications (Snyk)

**4. "Always-on" / Real-time**
Continuous operation emphasized:
- "Continuous, always-on discovery" (Tenable)
- "Real-time visualization" (Tenable)
- Peer-to-peer connections (Tailscale)

**5. API Access as Value**
Programmatic access highlighted universally:
- "UI, CLI, and API access" (Tailscale)
- "Fully documented API and pre-built integrations" (Tenable)

**6. Pre-built / Out-of-box**
Instant value without configuration:
- "Out-of-the-box dashboards" (Datadog)
- "Out-of-box alerts" (Auvik)
- "100+ pre-built solutions" (Grafana)

### Display Methods Observed

| Method | Used By | Description |
|--------|---------|-------------|
| Checkmark tables | Datadog, Snyk | Traditional feature grid |
| "All plans include" section | Auvik | Separate callout box |
| Inline statements | New Relic | "Unlimited X at no extra cost" |
| Category headers | Tailscale, Snyk | Group features logically |

### Language That Resonates for Scanopy's Use Case

- "Automatic discovery" - core value prop
- "Zero maintenance" / "one-time setup"
- "200+ service definitions" - already a differentiator
- "Docker integration" - DevOps appeal
- "Real-time updates" - live topology
- "Self-hosted option" - privacy/control

## Feature Proposal

### Recommended Universal Features (8)

These features are true for all plans and reinforce Scanopy's core value:

| # | Feature ID | Display Name | Description | Rationale |
|---|------------|--------------|-------------|-----------|
| 1 | `unlimited_scans` | Unlimited Scans | No limits on network discovery scans | Mirrors "unlimited" language from Auvik/New Relic |
| 2 | `unlimited_hosts` | Unlimited Hosts | Monitor as many hosts as your network has | New Relic pattern - removes anxiety about scaling |
| 3 | `service_definitions` | 200+ Service Definitions | Auto-detect databases, containers, web servers, and more | Already a key differentiator - make it visible |
| 4 | `docker_integration` | Docker Integration | Automatic discovery of containerized services | DevOps appeal, mentioned in README |
| 5 | `real_time_updates` | Real-time Updates | Live topology updates as your network changes | Tenable pattern - "always-on" value |
| 6 | `data_encryption` | Data Encryption | All data encrypted in transit and at rest | Security baseline per Snyk pattern |
| 7 | `ipv4_ipv6` | IPv4 & IPv6 Support | Full support for modern dual-stack networks | Tailscale pattern - network feature |
| 8 | `self_hosted` | Self-hosted Available | Deploy on your own infrastructure | Privacy/control differentiator |

### Proposed Category

Create a new **"Core"** category that displays first, before plan differentiators.

### Display Recommendation

Option A (Preferred): **"Included in all plans" callout section** at top of pricing table, using badge/pill style rather than checkmarks. This follows the Auvik pattern and draws attention to universal value.

Option B: Add to feature grid with checkmarks, but group under "Core" category that appears first.

### Features NOT Recommended

| Feature | Reason |
|---------|--------|
| Open Source / AGPL | Licensing messaging is complex; could confuse pricing |
| Multi-user support | Already exists as org management - don't duplicate |
| Scheduled discovery | Already a core feature - not a "gimme" |

### Implementation Impact

- **New Category:** "Core" - appears first in feature list
- **5 new Feature enum variants** in `features.rs`
- **5 new fields** in `BillingPlanFeatures` (all set to `true`)
- **Frontend:** May need styling for "all plans" badge treatment

## Work Summary

### Implemented

Added 5 new "Core" features that are included in all plans:

| Feature ID | Display Name | Description |
|------------|--------------|-------------|
| `unlimited_scans` | Unlimited Scans | No limits on network discovery scans |
| `unlimited_hosts` | Unlimited Hosts | Monitor as many hosts as your network has |
| `service_definitions` | 200+ Service Definitions | Auto-detect databases, containers, web servers, and more |
| `docker_integration` | Docker Integration | Automatic discovery of containerized services |
| `real_time_updates` | Real-time Updates | Live topology updates as your network changes |

### Files Changed

**Backend:**
- `backend/src/server/billing/types/features.rs` - Added 5 Feature enum variants, HasId, category, name, description implementations
- `backend/src/server/billing/types/base.rs` - Added 5 fields to BillingPlanFeatures, set all to `true` for all 8 plan types, updated Into<Vec<Feature>> impl

**Frontend Fixtures:**
- `ui/static/features.json` - Added 5 new feature definitions under "Core" category
- `ui/static/billing-plans.json` - Added 5 new feature fields (all true) to all 14 plan entries

### Deviations from Proposal

3 features were removed at user request:
- `self_hosted` - Skipped
- `ipv4_ipv6` - Skipped
- `data_encryption` - Skipped

### Verification

- `cargo test --lib` - 79 passed, 2 ignored
- `cargo test feature_ids` - Verifies Feature IDs match BillingPlanFeatures fields
- `make format && make lint` - All pass
