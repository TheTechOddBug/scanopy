# Topology: Cross-Cutting — Inspector Panel + Application Wizard

## Your Role

You are the coordinator for two cross-cutting pieces of topology work: a perspective-aware inspector panel and the Application perspective setup wizard. These need to land before individual perspectives are built.

## Background

Read these documents first:

1. **UX Design Doc**: `/Users/maya/.claude/projects/-Users-maya-dev-scanopy/planned-work/topology-visualization-redesign.md` — Key sections: "Inspector Panel (C4-3 / C4-4)" and "Perspective 4: Application / Service" (especially the setup wizard and application group tags).
2. **Project Instructions**: `/Users/maya/dev/scanopy/CLAUDE.md`
3. **Status Tracker**: `/Users/maya/.claude/projects/-Users-maya-dev-scanopy/memory/project_topology_perspectives_status.md` — What's done, what's planned.

## Work Item 1: Perspective-Aware Inspector Panel

### The problem

The inspector panel currently shows the same information regardless of perspective. When we have multiple perspectives, the same underlying entity needs to show different facets depending on context. A service inspected in the Application perspective should lead with its dependencies. The same service's interface inspected in L3 should lead with IP/subnet info.

### The approach

The inspector should NOT have per-perspective component trees. Instead, the existing entity resolver pattern should be extended so that perspective determines which sections appear and in what order.

Think of it as: the inspector resolves the clicked node to its underlying entity, then renders an ordered list of **sections**. Each section is a reusable component (host info, network info, service list, dependency list, port status, etc.). The perspective determines which sections to show and in what priority.

### What to evaluate and build

**Step 1: Audit the current inspector.** What components exist? What information do they show? How are they structured? What entity data do they access?

**Step 2: Define sections for L3 and Application perspectives.** Based on the UX design doc's inspector tables:

**L3 Logical — inspecting an element (interface node):**
- Primary: Host name, IP address, MAC
- Secondary: Services + port bindings on this interface
- Tertiary: Tags, entity source

**L3 Logical — inspecting a container (subnet):**
- Primary: Subnet CIDR, gateway, subnet type
- Secondary: Host count, element summary

**L3 Logical — inspecting an edge:**
- Interface edge: Host name, both interfaces, both subnets
- Dependency edge (overlay): Type, source/target services, pinned bindings

**Application — inspecting an element (service):**
- Primary: Service name, category, host it runs on
- Secondary: **Inbound + outbound dependencies** (this is the key differentiator — dependencies are the primary info here)
- Tertiary: Port bindings, tags, virtualization status

**Application — inspecting a container (application group or service category):**
- Primary: Group/category name, service count
- Secondary: Summary of dependency edges crossing this container boundary

**Application — inspecting an edge (Dependency):**
- RequestPath: Full ordered chain (all services), type label
- HubAndSpoke: Hub service, spoke count, list of spokes
- Both: Pinned bindings if any

**Step 3: Design the abstraction.** Propose how the section-based inspector works:
- How does a perspective declare its section ordering?
- How do sections get the data they need?
- How is this extensible for Infrastructure and L2 perspectives later (without building those now)?

**Step 4: Implement.** Refactor the inspector to the section-based model. Implement sections for L3 and Application. Ensure the abstraction is clean enough that adding Infrastructure/L2 sections later is straightforward.

### Multi-select behavior

The inspector also handles multi-select (multiple nodes selected). This needs to be perspective-aware:

**Bulk tagging:** When multiple nodes are selected, the inspector offers bulk tagging. The rule is: **you tag what you're looking at.** Each perspective's elements resolve to one entity type for tagging:
- **L3:** Elements are interfaces → tag the underlying **hosts**.
- **Application:** Elements are services → tag **services**.
- **Infrastructure:** Elements are VMs/containers → tag the underlying **hosts**. (Not implemented now, but the abstraction must support it.)
- **L2:** Elements are ports → tag the underlying **hosts** (switches). (Not implemented now.)

After bulk tagging, offer a one-click "Create grouping rule from this tag" action — this creates a ByTag element rule using the tag that was just applied. Reduces the friction from "I tagged these" to "now I can see them grouped."

**Bug: Dependency creation from multi-select is currently broken.** Creating a dependency from multi-select returns a 422 — the JSON body doesn't match the expected backend type (`invalid type: map, expected variant identifier at line 1 column 534`). This is likely a serialization mismatch after the Groups → Dependencies rename. The crosscutting worker should diagnose and fix this as part of the inspector refactor since the multi-select flow is being reworked anyway. The error comes from `InspectorMultiSelect.svelte:confirmGroupCreation` → `queries.ts` → `POST /api/v1/dependencies`.

**Dependency creation from multi-select (after fix):** When multiple nodes are selected, the inspector can offer "Create Dependency" between the selected services. This must be perspective-aware:
- **Application:** Create Dependency at service level. No binding selection.
- **L3:** Create Dependency with binding selection (all-or-nothing — either pin bindings for all services in the chain, or none).
- **L2 / Infrastructure:** Dependency creation not available.

### Extensibility requirement

The inspector refactor must be designed so that future agents adding Infrastructure and L2 perspectives can easily add their own configuration of both single-select and multi-select behavior. This means:

1. **Self-documenting abstractions:** A perspective declares its inspector config — which sections to show for single-select (ordered by priority), what entity types are available for bulk tagging in multi-select, whether Dependency creation is available and at what granularity. This should be a clear trait/interface, not scattered conditionals.

2. **Written documentation:** After implementing the refactor, write a short guide (as a code comment block or a doc at the top of the inspector module) explaining: "To add inspector support for a new perspective, implement X trait/interface with these methods, add your sections here, register bulk tag entity types here." A future agent reading the code should be able to add a new perspective's inspector config without reading this prompt.

### Constraints

- Don't build Infrastructure or L2 inspector sections — just make sure the abstraction supports them.
- The inspector should gracefully handle perspectives that don't have full section definitions yet (fall back to a generic view or show available entity data).

---

## Work Item 2: Application Perspective Setup Wizard

### The problem

The Application perspective is empty until users define application groups. Without onboarding, users see a blank canvas and don't know what to do.

### What to build

A wizard that appears when the user navigates to the Application perspective for the first time (no application group tags exist).

**Step 1: Define application groups.**

- Show suggested groups based on `Organization.use_case`:
  - **Homelab**: Media Stack, Home Automation, Monitoring, Network Infrastructure, Development, Smart Home
  - **Company**: Production, Staging, Internal Tools, Monitoring, CI/CD, Shared Services
  - **MSP**: Per-client groups, Shared Infrastructure, Monitoring
- One-click add for suggestions, plus "Create custom" for user-defined groups
- Each group creates a Tag with `is_application_group: true`
- Target: users end up with 3-7 groups

**Step 2: Assign services to groups.**

Two-pass approach:

1. **Host-level quick assign:** Show hosts with a dropdown to assign an application group. Include smart defaults — if a host runs Plex + Sonarr + Radarr, suggest "Media Stack". The recommendation maps ServiceCategory → likely application group.
2. **Service-level overrides (optional):** After host assignment, surface services that might be miscategorized — "scanopy-postgres runs on your automation server but looks like a shared database. Move to Shared Services?" This catches shared-service-on-dedicated-host cases.

**Tag inheritance model:** If a service has an application group tag, use it. If not, inherit from its host. If neither, ungrouped.

### Data model changes

- **Tag entity:** Add `is_application_group: bool` field (default false). This flag makes a tag usable as an Application perspective container rule.
- **Application perspective container rule:** A new `ByApplicationGroup` container rule type that groups elements by their application group tag (with host inheritance). This is the default container rule for Application perspective.
- **Generic service filtering:** Application perspective hides `is_generic` services by default. This should be a perspective-scoped default filter, not hardcoded.

### Wizard UX details

- The wizard appears as a full-page overlay or inline empty state within the topology view when the Application perspective is selected and no application group tags exist.
- After completing the wizard, the Application perspective renders with the assigned groups as containers and services as elements.
- Users can re-enter the wizard or edit assignments at any time from the Application perspective options panel.
- The wizard should be skippable ("Set up later") — the perspective shows the empty state again next time.

### Constraints

- The wizard does NOT need to create Dependencies (edges) — that's a separate user action after groups are set up.
- The `ByApplicationGroup` container rule and `is_application_group` tag flag need to work with the existing tag system — no separate entity for application groups.
- Smart defaults (ServiceCategory → suggested group) should be a mapping, not ML. A simple static map is fine.

---

## Work Item 3: UI Fixes

These are independent fixes that can be parallelized with the cross-cutting work above.

### 3a. Layout flicker on rebuild

When the topology rebuilds, there's a ~100-200ms flicker where all nodes appear stacked in the upper-left corner before ELK layout completes. This needs to be smoothed out.

Approach: don't render nodes (or render them invisible/off-screen) until ELK layout has computed positions. The flow should be: rebuild triggered → old nodes stay visible → ELK computes → swap to new positions in one frame. Investigate whether this is a matter of hiding SvelteFlow nodes until `applyElkResult()` completes, or double-buffering the node state so the old layout persists until the new one is ready.

### 3b. Edge handle selection

Edge handles (top/bottom/left/right attachment points) need to be determined more intelligently. Currently this may be split between frontend and backend — assess where the logic lives and consolidate.

The rule is simple: if a node has an edge going upward (target is above source), use the top handle. If the edge goes downward, use the bottom handle. Left/right for horizontal edges. This should be computed **after** ELK layout determines positions, since handle selection depends on relative node positions. If the backend is currently computing handles without knowing positions, that logic needs to move to the frontend post-layout pass.

### 3c. Perspective selector: icon-only segmented control

The segmented control for perspective switching should use an icon-only mode:
- Each perspective option shows only its icon (no text label)
- The text becomes a tooltip on hover
- Icons should be sized larger to match other icons in the topology toolbar
- This may require adding an icon-only mode to the SegmentedControl component if one doesn't exist — check before building, the component may already support it

---

## Work Item 4: Collapse / Rebuild Bugs

### 4a. Rebuild resets collapsed state

When all containers are collapsed and the user presses rebuild: first rebuild shows subcontainers correctly collapsed, second rebuild shows them expanded. Rebuild should have **no effect on collapse state** — the user's expand/collapse choices must persist across rebuilds.

### 4b. Collapsed container width

When a container with subcontainers is collapsed, the width is far too wide (see screenshot — the container spans the full canvas width). The container should size to fit its collapsed summary content (title + count + subcontainer summaries), with a minimum width applied so containers with just an element count aren't tiny.

### 4c. Collapsed container element counts are ambiguous

Screenshot shows "26 hosts" at the top, then subcontainer summaries showing "(3 hosts)" and "(3 hosts)". It's unclear whether the total is 32 (26 + 3 + 3) or 26 (with 6 of those being in subcontainers). 

Fix: the top-level count should be the **total** including subcontainer children, and subcontainer summaries should clarify they're a subset. E.g., "26 hosts" total, with subcontainer lines reading "including 3 in Infrastructure" and "including 3 in Test". Or: show only the ungrouped count at the top ("20 hosts") plus the subcontainer breakdowns ("Infrastructure: 3", "Test: 3").

Decide which is clearest and implement consistently.

### 4d. Collapsed element count label must be perspective-aware

The badge currently says "hosts" but this needs to match the perspective:
- **L3:** "host interfaces" (not "hosts" — the same host can appear on multiple subnets, so summing "hosts" across subnets would give an inaccurate total)
- **Application:** "services"
- **Infrastructure:** "hosts" (VMs/containers are hosts)
- **L2:** "ports"

This label should come from perspective metadata, not be hardcoded.

---

## Work Item 5: Edge Visibility Defaults

### 5a. Dependencies on by default in L3

Dependencies (RequestPath/HubAndSpoke) should be **on by default** in L3, not hidden. Dependencies without pinned bindings won't render in L3 anyway (no edge to draw), so there's no clutter concern. Users who take the time to add bindings to a Dependency should see it immediately.

### 5b. ServiceVirtualization edges removed from L3

ServiceVirtualization edges (Docker bridge → host interface) should **not be shown** in L3, not even as a toggleable overlay. The edge connects a Docker bridge subnet to a specific host interface, but this connection is nonsensical — the bridge isn't inherently related to any particular interface on the host.

Instead, the Docker bridge → host relationship should be communicated via the **container label**. Docker bridge subnet containers should show which host virtualizes them in their header, e.g., "Docker Bridge: 172.17.0.0/16 — on server-1". The ByVirtualizingService container rule (when enabled) groups bridges under their host, and this label reinforces the relationship.

The ServiceVirtualization relationship is properly represented as containment in the Infrastructure perspective — that's where it belongs.

---

## Step 1: Assess

1. Check `dev` branch state, worktrees, test status
2. Audit the current inspector panel components and data flow
3. Read the Tag entity model and understand how tags are currently applied to hosts/services
4. Check how `Organization.use_case` is stored and accessible from the frontend
5. Determine if `is_application_group` on Tag requires a migration or just a new field

**Present assessment and task breakdown to user. Wait for approval before creating worktrees.**

## Step 2: Plan Tasks

Likely decomposition:

- **Backend: Tag `is_application_group` field + ByApplicationGroup container rule + generic service filter** — migration, rule implementation, perspective-scoped default filter
- **Frontend: Inspector refactor** — section-based model, perspective-aware section ordering, implement L3 and Application sections
- **Frontend: Application wizard** — empty state detection, two-step wizard UI, use_case-based suggestions, host assignment with smart defaults, service override pass

These may have some parallelism (backend tag work is independent of inspector refactor; wizard depends on both tag work and inspector being perspective-aware).

**Present task breakdown with dependencies and wait for approval before creating worktrees.**
