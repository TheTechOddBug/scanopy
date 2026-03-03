# Scanopy PostHog Analytics & Dashboard Strategy

## Context

Scanopy tracks 60+ PostHog events across frontend and backend, covering onboarding, entity CRUD, billing, discovery, and feature adoption. This document provides a complete event inventory, dashboard designs for PostHog AI to build, a metrics framework, and an actionable playbook — all designed to help the founder understand onboarding friction, engagement depth, and churn risk so she can take targeted action to grow the business.

---

## 1. Complete Event Inventory

### Frontend Events (20 types)

| Event | Trigger | Key Properties | Importance |
|---|---|---|---|
| `onboarding_use_case_selected` | User selects homelab/company/msp | `use_case`, `role`, `company_size`, `referral_source` | **Critical** — first qualification signal |
| `onboarding_compatibility_os_selected` | User checks daemon compatibility | `os`, `install_method`, `result` | High — platform friction signal |
| `onboarding_org_networks_selected` | User completes org/network form | `networks_count`, `snmp_enabled_count`, `use_case` | High — setup intent |
| `onboarding_modal_completed` | User finishes setup modal | `network_count` | **Critical** |
| `org_created` | Organization created | `org_id` | **Critical** |
| `onboarding_registration_completed` | Full registration done | `use_case` | **Critical** |
| `daemon_install_os_selected` | User picks OS for daemon install | `os` | High — platform distribution |
| `daemon_os_support_requested` | User requests unsupported OS | `os` | Medium — demand signal |
| `billing_tab_viewed` | User opens billing settings | `plan_type`, `plan_status` | Medium — purchase intent |
| `billing_completed` | Subscription activated (frontend) | `plan`, `amount`, `plan_status` | **Critical** — revenue |
| `billing_portal_opened` | User opens Stripe portal | `plan_type` | Low |
| `payment_method_setup_initiated` | User starts adding payment | `plan_status`, `trial_days_left` | High — conversion signal |
| `payment_method_setup_completed` | Payment method added | `plan_type`, `plan_status` | High |
| `plan_inquiry_submitted` | User submits enterprise inquiry | `planType`, `success` | Medium |
| `plan_selected` | User selects a plan pre-checkout | `plan`, `is_commercial` | High |
| `upgrade_button_clicked` | User clicks upgrade CTA | `feature`, `external` | High — which features drive upgrades |

### Backend Events (~45 types)

**Entity CRUD** (auto-generated, Created + Deleted only):
`network`, `host`, `subnet`, `discovery`, `group`, `tag`, `share`, `user_api_key`, `daemon_api_key`, `daemon`, `snmp_credential`, `invite`, `user` — each with `_created` / `_deleted` suffix.

**Auth:** `login`

**Billing:** `checkout_started`, `checkout_completed`, `trial_started`, `trial_ended`, `trial_will_end`, `subscription_cancelled`, `plan_changed`, `payment_failed`, `payment_action_required`, `payment_recovered`

**Onboarding milestones** (first-time events):
`org_created`, `onboarding_modal_completed`, `plan_selected`, `first_daemon_registered`, `first_topology_rebuild`, `first_discovery_completed`, `first_host_discovered`, `second_network_created`, `first_tag_created`, `first_group_created`, `first_user_api_key_created`, `first_snmp_credential_created`, `invite_sent`, `invite_accepted`

**Discovery lifecycle:** `discovery_started`, `discovery_completed`, `discovery_failed` (+ `error_reason`), `discovery_cancelled`

**Auto-captured:** `$pageview`, `$pageleave`

**Person properties:** `email`, `organization_id`, `plan_type`, `plan_status`, `has_payment_method`
**Group properties (organization):** `plan_type`, `plan_status`, `name`, `created_at`

---

## 2. North Star Metric & Key Metrics Framework

> **Key framing: Scanopy is a "guardian" product.** Unlike daily-use SaaS (Slack, Notion), Scanopy works in the background — daemons scan automatically on a schedule, and users check in periodically to view their topology. This means:
> - **Discovery running ≠ engagement.** Scheduled discovery is infrastructure, not user action. Its *absence* (daemon deleted, discovery stopped) is a strong churn signal, but its *presence* is neutral.
> - **Login and topology viewing = engagement.** The real signal is whether users come back to consume the output.
> - **"Set it and forget it" is the success case**, not a failure mode. The question is whether they set it up properly in the first place (activation), and whether they reference it periodically (retention).
> - **Filter out SelfReport discoveries** everywhere — these are daemon self-registration events, not real scans. Network discovery (primary value driver) and Docker discovery (secondary) are both meaningful.
> - **Scheduled discovery is automatic** for paid orgs when a daemon is registered. No user action required. This means "discovery adoption" isn't a useful metric — focus on what users do with the *output* instead.

### North Star Metric: Weekly Active Organizations

**Definition:** Unique organizations with at least one `login` event in the trailing 7 days.

**Why this metric:** Scanopy is a "set it and forget it" infrastructure tool — discovery runs on a schedule, so `discovery_completed` is really just a heartbeat signal (absence = churn, presence ≠ engagement). The real engagement signal is whether humans are coming back to *consume* the output: viewing topology, customizing, sharing, referencing their network map. Login captures this. It's simple, directly measurable, and actionable.

**Why not discovery_completed:** Scheduled discovery runs automatically. Its presence tells you the daemon is alive, not that the user is engaged. It belongs in the Operational Health dashboard as a health metric, not as the North Star. `daemon_deleted` or discovery stopping is a strong *negative* signal (likely churn), but discovery running is a neutral signal.

**PostHog:** Trend → event `login` → count unique groups (organization) → rolling 7-day.

**Target:** 15% WoW growth early stage, stabilizing to 5% as base grows.

**Future evolution:** As the user base matures, consider shifting to Monthly Active Organizations — infrastructure tools naturally have longer check-in cycles than daily-use SaaS. But at early stage, weekly is the right cadence to detect problems quickly.

**Complement with:** Once the topology view events are implemented (see Section 7), the strongest North Star candidate becomes **Weekly Topology Consumers** — orgs where their topology was viewed by anyone (in-app, share link, or embed) in the trailing 7 days. This directly measures value consumption. Track three tiers:
- **Tier 1 (core):** `topology_viewed` — the org's own team is looking at their network map
- **Tier 2 (distribution):** `share_link_viewed` — external stakeholders are viewing via public links
- **Tier 3 (integration):** `share_embed_viewed` — topology is embedded in another tool (strongest stickiness signal)

For the North Star, count an org as "active" if ANY of these fire. But break down by tier to understand engagement quality — an org with embed views is far stickier than one with only in-app views.

### Leading Indicators (predict future success)

| Metric | Definition | Target | Review | If below target |
|---|---|---|---|---|
| **Activation rate** | % of new orgs reaching `first_topology_rebuild` within 7 days | >50% | Daily | Investigate daemon install UX, check `discovery_failed` errors |
| **Time to daemon install** | Median time from `org_created` to `first_daemon_registered` | <30 min | Weekly | Simplify daemon setup, consider Docker one-liner with pre-filled key |
| **Registration completion** | % of `onboarding_use_case_selected` → `onboarding_registration_completed` | >35% | Weekly | Reduce onboarding form fields, simplify setup flow |
| **Trial start rate** | % of free orgs starting a trial within 30 days | >15% | Weekly | Improve upgrade prompts, ensure users hit feature gates |
| **Feature adoption breadth** | Avg count of milestone events per org in first 30 days (tags, groups, shares, SNMP, API keys, invites) | >2 features | Weekly | If orgs stop at "daemon + topology" without adopting secondary features, push nudges for tags/groups/sharing |

### Lagging Indicators (confirm success happened)

| Metric | Definition | Target | Review | If below target |
|---|---|---|---|---|
| **Trial-to-paid conversion** | % of `trial_started` → `checkout_completed` within trial | >35% | Monthly | Check if trial users reach aha; if yes, pricing issue; if no, activation issue |
| **30-day retention** | % of orgs with `login` 30 days after `org_created` | >15% | Monthly | Engagement/value problem — are users finding reasons to return? |
| **Monthly churn rate** | `subscription_cancelled` / total active subscriptions | <5% | Monthly | Investigate dormant orgs, review cancellation reasons |
| **Payment recovery rate** | `payment_recovered` / `payment_failed` | >70% | Weekly | Check Stripe dunning config, add in-app past_due banners |

### Health Metrics (operational)

| Metric | Definition | Target | Action trigger |
|---|---|---|---|
| **Discovery success rate** | `discovery_completed` / `discovery_started` (filter: exclude `discovery_type = SelfReport`) | >95% | <90% → investigate `error_reason` breakdown |
| **Daemon registration rate** | `first_daemon_registered` / `org_created` (same cohort) | >60% | <50% → installation UX is broken |
| **Daily login volume** | `login` unique users per day | Stable/growing | >20% day-over-day drop → check auth system |

---

## 3. Dashboard Designs (for PostHog AI)

### Dashboard 1: Acquisition & Registration Funnel

**Purpose:** Where do prospective users drop off before becoming registered accounts?

**Insights to create:**

1. **Registration Funnel** (Funnel)
   - Steps: `$pageview` (URL contains `/onboarding`) → `onboarding_use_case_selected` → `onboarding_modal_completed` → `org_created` → `onboarding_registration_completed`
   - Conversion window: 7 days
   - Breakdown by: `use_case`
   - **Interpret:** >40% end-to-end = good. <20% = significant friction. Biggest single drop = highest-leverage fix.

2. **Use Case Distribution** (Trend, pie/bar)
   - Event: `onboarding_use_case_selected`, breakdown by `use_case`
   - **Interpret:** If >80% homelab, B2B GTM needs work. Rising company/msp share = B2B traction growing.

3. **Referral Source Breakdown** (Trend, bar)
   - Event: `onboarding_use_case_selected`, breakdown by `referral_source`
   - **Interpret:** Which channels deliver users. Cross-reference with funnel conversion by referral source to find highest-quality channels.

4. **Platform Compatibility** (Trend, stacked bar)
   - Event: `onboarding_compatibility_os_selected`, breakdown by `result`
   - **Interpret:** >90% compatible = good. >15% incompatible = platform support is a hard ceiling. Cross-reference with `os` to see which platforms fail.

---

### Dashboard 2: Activation & Aha Moment

**Purpose:** The most important dashboard. How many registered users reach the moment they see their network topology for the first time?

**Insights to create:**

1. **Activation Funnel** (Funnel)
   - Steps: `org_created` → `first_daemon_registered` → `first_host_discovered` → `first_discovery_completed` → `first_topology_rebuild`
   - Filter: For discovery events, exclude `discovery_type = SelfReport` (daemon self-registration, not real scans). Both Network and Docker discovery types are meaningful.
   - Conversion window: 14 days
   - Breakdown by: person property `use_case` (or `plan_type`)
   - **Interpret:**
     - >50% reaching `first_topology_rebuild` within 14 days = good. <25% = critical problem.
     - **Drop at daemon:** Installation friction. Review install UX, documentation quality, Docker one-liner.
     - **Drop at host discovered:** Daemon is registered but scan isn't finding anything. Could be network config issue, firewall blocking, or empty subnet. Check `discovery_failed` errors.
     - **Drop at discovery completed → topology:** User's scan finished but they never viewed the result. UX issue — consider auto-navigating to topology after first discovery.

2. **Activation Rate by Weekly Cohort** (Trend)
   - Numerator: unique orgs with `first_topology_rebuild` this week (who were created this week)
   - Denominator: unique orgs with `org_created` this week
   - **Interpret:** Trend should be rising. If it plateaus, onboarding improvements aren't landing.

3. **Discovery Success Rate** (Trend with formula)
   - Series A: `discovery_completed` count; Series B: `discovery_started` count
   - Filter: exclude `discovery_type = SelfReport` (daemon self-registration events that always succeed and would inflate the metric)
   - Formula: A / B × 100
   - **Interpret:** >95% = healthy. <85% = engineering priority.

4. **Discovery Failure Reasons** (Trend, table)
   - Event: `discovery_failed`, breakdown by `error_reason`
   - **Interpret:** Top errors become engineering tickets. Track trend — errors should decrease over time.

5. **Daemon Platform Distribution** (Trend, pie)
   - Event: `daemon_install_os_selected`, breakdown by `os`
   - **Interpret:** Shows what platforms activated users are deploying daemons to (Docker vs Linux vs macOS), directly informing where to invest install UX effort.

6. **Activation Retention** (Retention)
   - Cohort entry: `first_topology_rebuild`
   - Return event: `login`
   - **Interpret:** Shows retention for *activated* users. Compare to overall retention (Dashboard 5) — the gap quantifies how much activation matters.

---

### Dashboard 3: Revenue & Monetization

**Purpose:** Track conversion from free to paid, trial performance, and revenue health.

**Insights to create:**

1. **Monetization Funnel** (Funnel)
   - Steps: `org_created` → (`billing_tab_viewed` OR `upgrade_button_clicked`) → `checkout_started` → `checkout_completed`
   - Conversion window: 90 days
   - **Interpret:** >5% of free orgs reaching `checkout_completed` within 90 days = good early-stage. <2% = pricing or value perception issue.

2. **Trial Conversion Funnel** (Funnel)
   - Steps: `trial_started` → `payment_method_setup_initiated` → `payment_method_setup_completed` → `billing_completed`
   - Conversion window: 30 days
   - **Interpret:** >35% trial-to-paid = good. <20% = critical. **Cross-reference with activation:** if trial users don't reach aha, the problem is activation, not pricing.

3. **Upgrade Intent by Feature** (Trend, table sorted by count)
   - Event: `upgrade_button_clicked`, breakdown by `feature`
   - **Interpret:** Directly tells you which paywalled features drive purchase intent. The top features should stay behind the paywall. Features with zero clicks may not be discoverable.
   - **Action:** If a feature drives high intent but low conversion, the pricing step has friction. If intent is low, the feature gate isn't visible enough.

4. **Plan Distribution** (Trend, stacked bar)
   - Event: `checkout_completed`, breakdown by plan (from metadata)
   - **Interpret:** Which plans sell. If Starter dominates and Pro/Team are rare, the step-up value prop needs work.

5. **Payment Health** (Trend, multi-series)
   - Events: `payment_failed`, `payment_action_required`, `payment_recovered`
   - **Interpret:** `payment_recovered / payment_failed` should be >70%. If <50%, dunning is broken.

6. **Feature Limit → Upgrade Pipeline** (Funnel)
   - Steps: `feature_limit_hit` → `upgrade_button_clicked` → `checkout_started` → `checkout_completed`
   - Breakdown: `limit_type` (hosts, networks)
   - **Interpret:** Measures whether hitting plan limits actually drives upgrades. If users hit limits but don't click upgrade, the limit messaging isn't compelling. If they click upgrade but don't complete checkout, the pricing page or checkout flow has friction. This directly tells you whether your plan limits are set at the right levels.

7. **Cancellations** (Trend)
   - Event: `subscription_cancelled`, count per week
   - **Interpret:** Trend should be flat or declining relative to total subscriber base. Spikes warrant immediate investigation.

---

### Dashboard 4: Feature Adoption & Engagement Depth

**Purpose:** Which features do users actually use after activation? Who are the power users vs the dormant accounts?

**Insights to create:**

1. **Feature Adoption Ladder** (Trend, multi-series, cumulative)
   - Events (each as separate series, unique organizations):
     - `first_tag_created`, `first_group_created`, `first_snmp_credential_created`, `second_network_created`, `first_user_api_key_created`, `invite_sent`, `share_created`
   - **Interpret:** Tells you which features have real adoption vs which are ignored. Low adoption = discoverability problem OR the feature doesn't solve a real need.

2. **Feature Adoption by Plan** (Trend, table)
   - Same events as above, breakdown by person property `plan_type`
   - **Interpret:** Do paid users use more features? If free users match paid users in feature breadth, you're leaving money on the table (those features should gate upgrades). If paid users barely use advanced features, the paid value prop is weak.

3. **Feature Adoption Breadth** (Trend)
   - Count of distinct milestone events per organization: `first_tag_created`, `first_group_created`, `first_snmp_credential_created`, `share_created`, `first_user_api_key_created`, `invite_sent`, `second_network_created`
   - **Interpret:** Since daemon registration auto-sets up scheduled discovery for paid orgs, the core loop (daemon → discover → topology) is essentially automatic. The differentiator between retained and churned orgs is likely how much they *customize and operationalize* the output — tags, groups, shares, SNMP, API keys. Track avg features adopted per org over time; if it's flat at 0-1, nudges aren't working.

4. **Topology Consumption** (Trend, multi-series)
   - Events: `topology_viewed` (in-app views), `share_link_viewed` (public link views), `share_embed_viewed` (iframe embed views), `topology_exported` (downloads)
   - Count unique organizations per week for each
   - **Interpret:** This is the clearest picture of value consumption. If `topology_viewed` is flat while signups grow, users aren't finding the topology tab. If `share_link_viewed` is near zero despite `share_created` being nonzero, shares are being created but not accessed by recipients — the sharer isn't getting the social proof value. If `share_embed_viewed` exists at all, those orgs are deeply integrated and very unlikely to churn. `topology_exported` indicates users putting Scanopy output into docs/presentations — strong value signal.

5. **Engagement Depth** (Trend, multi-series)
   - Events: `host_inspected` (drilling into device details), `topology_customized` (filters, hide, layout changes), `api_request_made` (programmatic usage)
   - Count unique organizations per week
   - **Interpret:** Distinguishes shallow usage (just viewing topology) from deep engagement (inspecting hosts, customizing layout, automating via API). If most orgs only view but never inspect/customize, the topology is useful as a glance but not as a working tool — consider surfacing more actionable data on the topology itself.

6. **API Utilization** (Trend)
   - Event: `api_request_made`, count per unique organization per week
   - Filter: only organizations with `first_user_api_key_created`
   - **Interpret:** Of orgs that created an API key, what % actually use it? "Created but never used" suggests the API doesn't solve a real workflow need, or documentation is lacking. Active API usage is the strongest retention signal — it means Scanopy is integrated into automated workflows.

7. **Engagement Lifecycle** (Lifecycle)
   - Event: `topology_viewed` (preferred) or `login` (fallback if topology_viewed not yet implemented)
   - Shows: New, Returning, Resurrecting, Dormant
   - **Interpret:** Healthy = Returning segment is larger than Dormant. If Dormant grows faster than New, the product has a leaky bucket.

8. **Weekly Active Organizations** (Trend)
   - Event: `login`, count unique organizations per week
   - **Interpret:** The simplest engagement metric. Should trend upward.

9. **Entity Growth** (Trend, stacked area)
   - Events: `host_created`, `network_created`, `share_created`, `tag_created`, `group_created`
   - **Interpret:** Overall platform growth trajectory. Hosts growing = networks expanding. Tags/groups growing = users customizing.

---

### Dashboard 5: Retention & Churn Risk

**Purpose:** Identify at-risk users before they churn. Early warning systems.

**Insights to create:**

1. **N-Day Retention Curve** (Retention)
   - Cohort entry: `org_created`
   - Return event: `topology_viewed` (preferred) or `login` (fallback)
   - Periods: Day 1, 3, 7, 14, 30
   - **Targets:** D1 >40%, D7 >20%, D30 >12% (guardian product benchmarks — lower than daily-use SaaS is normal and healthy)
   - **Interpret:** If D1 is good but D7 drops sharply, users saw the topology but didn't find a reason to return. Key question: is the topology updating between visits? Without scheduled discovery (auto-configured for paid), nothing changes, so there's no reason to come back. The "pull-back" mechanism is topology changes surfaced via email or in-app notification.

2. **Retention: Activated vs All Users** (Retention, two series)
   - Series A: Cohort entry `first_topology_rebuild`, return event `topology_viewed` or `login`
   - Series B: Cohort entry `org_created`, return event `topology_viewed` or `login`
   - **Interpret:** The gap between A and B quantifies activation's impact on retention. If A >> B, activation is the #1 lever to pull. If A ≈ B, the aha moment isn't sticky enough — post-activation engagement needs work.

3. **Retention by Use Case** (Retention, breakdown)
   - Cohort entry: `org_created`, return event: `topology_viewed` or `login`
   - Breakdown: `use_case`
   - **Interpret:** Homelab vs company vs msp may retain very differently. If one segment retains far better, double down on that ICP.

4. **Topology Distribution Value** (Trend)
   - Events: `share_link_viewed`, `share_embed_viewed`, count per week
   - Breakdown: by organization (group)
   - **Interpret:** Measures whether shared topologies get external eyeballs. High share views for an org means their stakeholders rely on Scanopy — this org is extremely unlikely to churn. Orgs with embed views are the stickiest (Scanopy is part of their infrastructure). If shares are created but never viewed, the share feature isn't delivering value.

5. **Churn Correlation** (Correlation on `subscription_cancelled`)
   - Include these events in correlation: `topology_viewed`, `topology_exported`, `topology_customized`, `host_inspected`, `share_link_viewed`, `tag_created`, `group_created`, `api_request_made`
   - **Interpret:** Surfaces what churning users did NOT do that retained users did. E.g., "users who never customized their topology are 3x more likely to cancel" or "users whose shares were never viewed are 2x more likely to cancel."

---

### Dashboard 6: Onboarding Quality (Deep Dive)

**Purpose:** Micro-conversions within the onboarding flow. Every percentage point here compounds.

**Insights to create:**

1. **Single-Session Onboarding Funnel** (Funnel)
   - Steps: `$pageview` (URL contains `/onboarding`) → `onboarding_use_case_selected` → `onboarding_org_networks_selected` → `onboarding_modal_completed` → `org_created` → `onboarding_registration_completed`
   - Conversion window: 1 hour
   - **Interpret:** Within one sitting, where do people give up? Short window isolates in-session friction from "I'll come back later" drop-off.

2. **Getting Started Checklist Funnel** (Funnel)
   - Steps: `org_created` → `first_daemon_registered` → `first_host_discovered` → `first_discovery_completed` (filter: exclude `discovery_type = SelfReport`) → `first_topology_rebuild`
   - Conversion window: 7 days
   - **Interpret:** Mirrors the in-app checklist. >50% completing all steps within 7 days = good. <25% = the checklist isn't driving action. Note: conversion window is generous because network size affects discovery duration — a /12 scan could take a day or two, which doesn't indicate disengagement.

3. **Checklist Completion vs Dismissal** (Trend, multi-series)
   - Events: `checklist_dismissed` (breakdown by `completed_count`), `first_topology_rebuild` (checklist fully completed)
   - **Interpret:** If most users dismiss at 0/3 completed steps, the checklist isn't helpful and should be redesigned. If most dismiss at 2/3, the last step (topology view) has a UX gap. If most complete all 3, the checklist is working.

4. **Nudge Effectiveness** (Trend with formula)
   - Events: `nudge_action_clicked`, `nudge_dismissed` — both broken down by `nudge_id`
   - Formula: `nudge_action_clicked / (nudge_action_clicked + nudge_dismissed)` per nudge
   - **Interpret:** Nudge conversion rate. If a nudge has >30% action rate, it's working well. If <10%, the nudge is either poorly timed, irrelevant, or annoying. Remove or redesign low-performing nudges.

5. **Onboarding Email Effectiveness** (Trend, multi-series)
   - Track `first_daemon_registered` volume on days when nudge emails fire (A2 at +24h, A4 at +48h)
   - **Interpret:** If daemon registrations spike 24-48h after signup, the emails are working.

---

### Dashboard 7: Operational Health

**Purpose:** Ensure the product works. Daily check for technical issues.

**Insights to create:**

1. **Discovery Health** (Trend, multi-series)
   - `discovery_started`, `discovery_completed`, `discovery_failed`, `discovery_cancelled`
   - **Alert:** `discovery_failed / discovery_started > 10%` on any day.

2. **Discovery Error Breakdown** (Trend, table)
   - Event: `discovery_failed`, breakdown by `error_reason`

3. **Daemon Fleet** (Trend)
   - `daemon_created` vs `daemon_deleted` — net active daemons over time

4. **Login Volume** (Trend)
   - Event: `login`, daily unique users
   - **Alert:** >20% day-over-day drop = potential outage.

---

## 4. Critical Funnels Summary

| Funnel | Steps | Target End-to-End | Biggest Lever |
|---|---|---|---|
| **Registration** | Page visit → use case → setup → org → registered | >40% | Reduce form fields, simplify setup flow |
| **Activation** | Registered → daemon → hosts found → discovery complete → topology viewed | >50% in 14 days | Daemon install UX (one-liner) |
| **Trial conversion** | Trial started → payment method → paid | >35% | Ensure trial users activate first |
| **Monetization** | Free → intent → checkout → paid | >5% in 90 days | Feature gate visibility |
| **Team expansion** | Team plan → invite sent → invite accepted | >60% accept rate | Invite UX, clear value for invitees |

---

## 5. Cohorts to Create in PostHog

### Behavioral Cohorts (highest priority)

| Cohort | Definition | Use For |
|---|---|---|
| **Activated** | Has done `first_topology_rebuild` | Compare retention/monetization vs non-activated |
| **Setup incomplete** | Has `org_created` but NOT `first_daemon_registered`, >3 days ago | Re-engagement targeting |
| **Power users** | Org with 3+ of: `tag_created`, `group_created`, `share_created`, `second_network_created`, `invite_sent` | Expansion candidates, case study outreach |
| **Upgrade-curious** | Free plan, `upgrade_button_clicked` >1x, NOT `checkout_completed` | Targeted trial offers or discounts |
| **Trial at risk** | `trial_started` but NOT `payment_method_setup_completed`, and `trial_will_end` fired | Immediate intervention needed |
| **Dormant paid** | `plan_status = active`, no `login` in 14+ days | Re-engagement before cancellation |
| **Multi-feature adopters** | 3+ of: tag, group, snmp, share, invite created | Stickiest segment — study and replicate |

### Plan-Based Cohorts

| Cohort | Use For |
|---|---|
| **Free tier** | Activation rate, upgrade triggers |
| **Trialing** | Highest-leverage revenue cohort |
| **Starter** | Churn risk, Pro upgrade potential |
| **Pro/Team** | Feature utilization, expansion revenue |

---

## 6. Actionable Playbook

### When activation rate drops below 40%

1. Check `daemon_install_os_selected` breakdown — new OS dominating with install issues?
2. Check `discovery_failed` by `error_reason` — new error type spiking?
3. Intervention: A/B test Docker one-liner with pre-filled API key in install step
4. Intervention: Auto-navigate to topology after first discovery completes
5. Measure: 2-week cohort comparison on activation funnel

### When trial conversion drops below 25%

1. Check if trial users reach aha moment — if <50% activate during trial, that's the problem, not pricing
2. Intervention: "X days left" emails at days 3 and 5 (with payment setup link)
3. Intervention: "Extend trial 7 days if you add payment method now"
4. Intervention: If time-to-aha > trial length, trial is too short
5. Measure: Trial-to-paid rate for cohorts before/after

### When a paywalled feature shows high intent but low conversion

1. Check `upgrade_button_clicked` by `feature` — which feature drives clicks
2. Check funnel: `upgrade_button_clicked` → `checkout_started` → `checkout_completed` — where's the drop?
3. Intervention: If drop at checkout, simplify Stripe flow or offer in-app trial activation
4. Intervention: If the feature has high intent volume, make sure the upgrade CTA leads directly to the right plan
5. Measure: Conversion rate on that specific feature's upgrade path

### When dormant paid orgs exceed 20% of subscriber base

1. Day 7 dormant: Email "Your network may have changed — here's what's new"
2. Day 14 dormant: Personal founder email "Is everything working?"
3. Day 21 dormant: Offer pause option instead of cancel
4. For orgs WITHOUT scheduled discovery: "Turn on scheduled scans so your data stays fresh"
5. Measure: Resurrection rate (% of dormant orgs that log in within 7 days of intervention)

### When onboarding funnel drops between use case and modal completion

1. Check `onboarding_compatibility_os_selected` — are users hitting incompatible platforms?
2. Check nudge effectiveness — are checklist/nudge events showing low action rates?
3. Intervention: Reduce form fields — defer network naming to post-registration
4. Intervention: Allow "skip setup, explore with demo data" flow
5. Measure: Weekly cohort comparison of registration completion rate

### When topology views are flat despite growing signups

1. Check activation funnel — are users reaching `first_topology_rebuild`?
2. Check `topology_viewed` vs `login` ratio — are users logging in but not viewing topology? If so, the home/dashboard page isn't directing them there
3. Intervention: Make topology the default landing page for activated orgs (instead of home/dashboard)
4. Intervention: "Your network changed" email after discovery finds new hosts — creates a reason to revisit
5. Measure: `topology_viewed` unique orgs per week

### When shares are created but never viewed externally

1. Check `share_created` vs `share_link_viewed` — if ratio is <10%, shares aren't being distributed
2. Check `share_embed_viewed` — if zero, embedding isn't being used
3. Intervention: After share creation, prompt user with a "copy link" + suggested places to share (Slack, wiki, email)
4. Intervention: Add "share views" counter visible to the sharer (social proof that their share is being used)
5. Measure: `share_link_viewed / share_created` ratio improvement

### When nudge conversion rate drops below 10%

1. Check `nudge_action_clicked / (nudge_action_clicked + nudge_dismissed)` per `nudge_id`
2. Identify worst-performing nudges — are they poorly timed, irrelevant, or repetitive?
3. Intervention: Remove or redesign lowest-performing nudges
4. Intervention: Improve nudge timing — trigger nudges contextually (e.g., after 3rd topology view, not on first login)
5. Measure: Per-nudge conversion rate and overall `nudge_dismissed` volume

### When payment recovery rate drops below 60%

1. Verify Stripe Smart Retries and dunning are configured (retry at days 1, 3, 5, 7)
2. Verify in-app `past_due` banner is prominent
3. Intervention: Email on `payment_failed` with one-click card update link
4. Intervention: Offer annual billing at discount to chronic failers
5. Measure: `payment_recovered / payment_failed` ratio

---

## 7. Event Gaps — Missing Events (Prioritized)

### Priority 1 — High impact, implement first

| Event | Where | Properties | Why |
|---|---|---|---|
| `topology_viewed` | Topology component on mount | `network_id`, `node_count`, `view_type: "app"` | The aha moment lives here. We know when topology is *first rebuilt* (backend) but not how often users *view* it. View frequency is the strongest engagement signal. `$pageview` captures URL hashes but a dedicated event with properties is far more actionable. This is the **app view** — authenticated users viewing their own topology. |
| `topology_exported` | Export button after download | `format` | Users who export are getting real value — using Scanopy output in docs. Power user signal. |
| `share_link_viewed` | Share route (`/share/[id]`) on load | `share_id`, `organization_id`, `has_password`, `view_type: "share"` | Tracks external viewers accessing a shared topology via public link. This is a **different signal** from `topology_viewed` — it means the *sharer's stakeholders* find the topology valuable, which reinforces the sharer's reason to keep paying. High share views = the org is getting external value from Scanopy. |
| `share_embed_viewed` | Embed route (`/share/[id]/embed`) on load | `share_id`, `organization_id`, `referrer_domain`, `view_type: "embed"` | Tracks iframe embed views. Strongest stickiness signal — if Scanopy is embedded in another tool (wiki, dashboard, NOC), it becomes part of the org's infrastructure. Track `referrer_domain` to understand where embeds live. |
| `nudge_dismissed` / `nudge_action_clicked` | FeatureNudges component | `nudge_id` | Currently nudge dismissals only go to localStorage. Without this, you can't measure nudge conversion rate (action vs dismiss). |
| `checklist_dismissed` | GettingStartedChecklist | `completed_count` | How many users dismiss at 0/3 vs 2/3? Tells you if the checklist drives action. |

### Priority 2 — Medium impact

| Event | Where | Properties | Why |
|---|---|---|---|
| `host_inspected` | Host detail/inspector panel | `host_id`, `network_id` | Measures engagement depth. Users inspecting hosts get deeper value. |
| `topology_customized` | Topology options interactions | `action` (filter, hide, layout change) | Customization = ownership = retention. |
| `api_request_made` | Backend API key middleware | `endpoint`, `method` | Pro+ users — are API keys created but never used? Track actual utilization. |
| `feature_limit_hit` | Backend enforcement | `limit_type`, `current_count`, `plan_type` | Know exactly when users hit limits. Combine with `upgrade_button_clicked` to measure limit-driven upgrades. |

### Priority 3 — Nice to have

| Event | Why |
|---|---|
| `error_displayed` | Track user-facing errors; spikes correlate with engagement drops |
| `cookie_consent_given/denied` | Know what % opt out — if >40%, analytics accuracy is compromised |

---

## 8. How to Interpret Key Dashboards — A Cheat Sheet

### Reading the Activation Funnel

```
org_created: 100 → first_daemon: 55 → first_host: 48 → discovery_complete: 45 → first_topology: 40
```

- **55% installed daemon:** Decent. If this drops below 50%, daemon install is the bottleneck.
- **48/55 = 87% found hosts:** Good — most daemons can see the network.
- **45/48 = 94% completed discovery:** Good — scans that find hosts almost always finish. Note: large networks (/12 or bigger) can take a day or two to complete. Slow completion ≠ disengagement.
- **40/45 = 89% viewed topology:** Great — the UX auto-directs them.
- **40% overall activation:** Solid. Focus on the 45 users who never installed a daemon — that's where the biggest absolute drop is.

**The single highest-leverage optimization is always the step with the biggest absolute drop.** In this example, 45 users dropped between registration and daemon install. That's where to focus.

### Reading Retention Curves

- **D1 50%, D7 20%, D30 8%:** Steep early drop = users don't find reason to return after first visit. They saw the topology, thought "cool," and left. Fix: ensure they set up scheduled discovery (so topology changes over time) and send "your network changed" emails to pull them back.
- **D1 50%, D7 40%, D30 25%:** Gradual decline = healthy for a guardian product. Users who make it past day 1 tend to stick. Focus on D1 activation.
- **D1 30%, D7 28%, D30 25%:** Low start, flat curve = a small loyal audience. The product works for those who try it, but first experience isn't compelling enough. Fix: first-run experience.

**Important for guardian products:** Retention curves will naturally be lower than daily-use SaaS. A 15% D30 retention for an infrastructure tool is healthy — users check in weekly or bi-weekly, not daily. Don't benchmark against Slack-style D30 targets (>40%). Compare against monitoring/infrastructure tools instead.

### Reading the Lifecycle Chart

- **Growing "New" + stable "Returning":** Healthy growth.
- **Shrinking "New" + growing "Dormant":** Acquisition is slowing and existing users are leaving. Leaky bucket.
- **Large "Resurrecting" segment:** Your re-engagement emails are working, but something is also pushing users away. Investigate what triggers dormancy.

### Reading Upgrade Intent

If `upgrade_button_clicked` shows:
- `feature: scheduled_discovery` = 45%
- `feature: share` = 30%
- `feature: multi_network` = 15%
- `feature: api` = 10%

**Scheduled discovery is your #1 upgrade driver.** Make sure the free→paid upgrade path for this feature is buttery smooth. Consider making the upgrade CTA appear right when they try to schedule (not just a generic "upgrade" page).

---

## 9. Implementation Notes

This plan is a **strategy and reference document** — no code changes are included. To implement:

1. **Dashboards:** Copy each dashboard section into PostHog AI and ask it to create the insights
2. **Cohorts:** Create each behavioral cohort in PostHog using the definitions above
3. **Event gaps:** Implement Priority 1 events as a separate task (code changes in frontend components and backend subscriber)
4. **Alerts:** Set up PostHog alerts for: discovery failure rate >10%, login volume drop >20%, dormant paid orgs >20%
5. **Review cadence:** Daily check of Activation + Operational Health; Weekly review of all dashboards; Monthly deep dive on Retention + Revenue
