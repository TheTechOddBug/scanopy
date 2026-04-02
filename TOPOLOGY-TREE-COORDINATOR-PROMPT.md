# Topology Refactor: Tree Layout Coordinator

## Your Role

You are the coordinator for the topology visualization refactor. Your job is to assess the current state of the codebase, plan the implementation, and break it into parallelizable worktree tasks.

## Background

Read these documents first:

1. **UX Design Doc**: `/Users/maya/.claude/projects/-Users-maya-dev-scanopy/planned-work/topology-visualization-redesign.md` — The approved UX design. Defines perspectives, primitives, grouping rules, zoom levels, etc.
2. **Project Instructions**: `/Users/maya/dev/scanopy/CLAUDE.md` — Coding conventions, worktree workflow, coordinator responsibilities.

There is also a Phase 1 spec at `/Users/maya/.claude/projects/-Users-maya-dev-scanopy/planned-work/topology-redesign-phase1.md` — **this is partially stale**. The architectural decisions about node type generalization (Decision 1), infra zone as grouping rule (Decision 2), GroupingConfig (Decision 3), client-side collapse (Decision 4), and cross-cutting hulls (Decision 6) are still valid. Decision 5 (force-directed layout) is superseded by the technical direction below. Use the Phase 1 spec as reference for the still-valid decisions, but do not follow it as a task plan.

## What happened so far

Previous work attempted to implement this refactor on the `dev` branch. Some foundational work was done (node type generalization, GroupingConfig, etc.), then significant iteration was spent trying to make force-directed layout (d3-force) work for L3 topology. Force-directed produced hairballs because L3 data is hierarchical (subnets → categories → interfaces), not a peer network. That approach has been abandoned.

**Your first job is to assess the current state of `dev` vs `main`** and decide whether to salvage the foundational refactor work or start clean from `main`. See "Step 1" below.

## Technical Direction: Tree Layout for L3

This is the approach to implement. It was not in the original Phase 1 spec and supersedes the force-directed layout plan.

### Core insight

L3 topology data is a hierarchy: External → Gateway → LAN → Infrastructure, with hosts on subnets and services on hosts. Tree layout renders hierarchies cleanly, deterministically, and instantly. No simulation, no tuning, no hairballs.

### How the tree is built

The tree structure comes from entities + grouping rules:

```
Network (root)
├── Internet (SubnetType vertical_order=0)
├── Gateway (vertical_order=1)
│   └── [interfaces on this subnet]
├── LAN (vertical_order=2)
│   ├── IoT Devices (ByTag grouping rule)
│   │   ├── smart-thermostat
│   │   └── security-camera
│   ├── Docker on server-1 (ByVirtualizingService grouping rule)
│   │   ├── bridge-172.17 (nested subnet)
│   │   │   ├── nginx
│   │   │   └── certbot
│   │   └── bridge-172.18
│   │       └── postgres
│   └── [ungrouped interfaces]
├── Management (vertical_order=3)
└── Storage (vertical_order=3)
```

- **Tree depth** comes from `SubnetType::vertical_order()` for the top level, then grouping rules add intermediate levels
- **Sibling order** comes from `SubnetType::horizontal_order()` at the subnet level
- **Grouping rules** (`ByServiceCategory`, `ByVirtualizingService`, `ByTag`, etc.) create sub-branches within a subnet. These are the same composable `GroupingRule` primitives from the Phase 1 spec — they add nesting depth, never cycles. The structure is always a tree.
- **Each node belongs to exactly one parent** at each level. No DAGs.

### Layout algorithm

Use **d3-hierarchy** (Reingold-Tilford or similar tree layout). It's deterministic, synchronous (single pass, no simulation), and handles arbitrary depth.

- Server provides: graph structure (nodes, edges, container membership via GroupingConfig) + layout hints (vertical_order, horizontal_order per container)
- Client runs: d3-hierarchy positions the tree. Containers are rendered as visual boundaries (SvelteFlow `parentId` mechanism) with children inside.
- Result: subnets as visual boxes with children inside, arranged in a tree. Looks similar to the current layout (external top, infrastructure bottom) but produced by a general-purpose tree algorithm, not bespoke Sugiyama.

### Edges are overlays, not structure

Cross-cutting edges do NOT affect tree positioning. The tree is positioned purely by hierarchy. Edges are routed after positioning:

- **Interface edges** (same host on multiple subnets) — curved lines crossing branches
- **PhysicalLink edges** (SNMP LLDP/CDP) — curved lines between branches
- **Group edges** (RequestPath, HubAndSpoke) — curved lines showing service flow
- **User-defined edges** (future) — same treatment

Edge clutter is managed by:
- **Edge bundling**: multiple edges between same container pair → single thick line with count badge, click to expand
- **Edge filtering**: toggle edge types on/off
- **Container collapse** (C4-1 zoom): collapsed containers hide internal detail and aggregate edges

### What's still valid from the Phase 1 spec

These decisions/designs carry forward unchanged:

1. **Pure primitive nodes** (Decision 1): `ContainerNode { container_type }` and `LeafNode { container_id, leaf_type }`. No domain fields on nodes. Frontend resolves via entity collections + type-safe exhaustive resolvers.

2. **Infra zone = ByServiceCategory grouping rule** (Decision 2): `is_infra` and `infra_width` replaced by a `ByServiceCategory` sub-container. Deferred until tree layout handles nesting (which it does naturally).

3. **GroupingConfig** (Decision 3): `TopologyRequestOptions` translated to `GroupingConfig { primary, cross_cutting, filters }` at the top of `build_graph()`. Same composable rules.

4. **Client-side collapse** (Decision 4): Frontend transforms node/edge arrays. Layout-engine-agnostic.

5. **Client-side edge bundling**: Same as specced.

6. **Cross-cutting hull overlays** (Decision 6): Visual-only colored hulls wrapping member nodes across primary containers.

7. **Serde aliases + SQL migration**: Same backward-compatibility approach for stored JSONB.

### What changes from the Phase 1 spec

- **No force-directed for L3.** Tree layout is the L3 default. Force-directed is deferred to Phase 3 (L2 perspective) where the graph genuinely is peer-to-peer.
- **No WebWorker wrapper needed.** Tree layout is synchronous and fast (single pass, O(n)).
- **No simulation lifecycle.** No animated settlement, no alpha decay, no re-simulation on drag. Tree layout is compute-once. Drag moves the node; other nodes stay put (or the sub-tree moves, TBD).
- **d3-hierarchy is the dependency**, not d3-force.
- **Sugiyama code**: Freeze it, move to `service/legacy/`. Existing topologies with stored positions load as view-only.
- **Layout is now simpler.** Tree layout removes the most complex part of the Phase 1 spec (force tuning, container boundary forces, simulation management). This should result in fewer tasks and less risk.

## Step 1: Assess Current State

Before planning tasks, you must understand what exists:

1. Check all active worktrees: `git worktree list`
2. Check what's on `dev` vs `main`: `git log main..dev --oneline`
3. Read the diffs to understand what refactor work was done
4. Run `cd backend && cargo test --lib` and `cd ui && npm test` on dev — do they pass?
5. Determine: is the foundational work (node type generalization, GroupingConfig, frontend resolvers, edge handle generalization) clean and working? Or is it entangled with force-directed-specific code?

**Then recommend one of:**

- **Option A: Start clean from main.** Reset dev to main, re-implement the foundational refactor alongside tree layout from scratch. Choose this if the existing work is broken, entangled, or would take more effort to clean up than to redo.
- **Option B: Salvage foundations, remove force-directed.** Keep the clean foundational work, revert/remove force-directed code, build tree layout on top. Choose this if the foundations are solid and separable.

**Present your recommendation with evidence to the user and wait for approval before proceeding.**

## Step 2: Foundational Refactor (Coordinator-managed)

After the user approves the direction from Step 1, break the **foundational work** into worktree tasks following CLAUDE.md coordinator workflow. Foundational work is everything that generalizes the internal model without changing the visual output:

- Backend node type generalization + SQL migration (if not already done)
- Frontend node type update + entity resolvers (if not already done)
- GroupingConfig translation layer (if not already done)
- Edge handle generalization (if not already done)
- Sugiyama freeze + legacy gating
- Infra zone as sub-container (if tree layout is needed for nesting, defer to Step 3)

Some of these may already be done on dev (Step 1 will tell you). Don't re-do completed work.

**After all foundational tasks are complete: STOP.** Merge foundational work to dev. Present to the user for review. The user will verify that existing topology rendering still works exactly as before — same visual output, same interactions, no regressions. **Do not proceed to Step 3 until the user confirms the foundational work is solid.**

## Step 3: Tree Layout Implementation (Specialized worker)

Once the user approves the foundational work, the tree layout implementation is handled by a **dedicated specialized worker** — likely independent from you (the coordinator). This worker will:

1. Implement tree layout for L3 using d3-hierarchy
2. Implement client-side container collapse (C4-1 zoom)
3. Implement client-side edge bundling
4. Implement cross-cutting hull overlays
5. Iterate on layout quality using an automated evaluation harness

**The evaluation harness** is critical. The worker should build a Playwright-based test script that evaluates layout quality by extracting node positions from the DOM and computing metrics (overlap count, group cohesion, hierarchy flow, edge crossings, etc.). This creates a feedback loop where the worker can iterate on layout without needing the user to review screenshots manually. Full details are at:

`/Users/maya/.claude/projects/-Users-maya-dev-scanopy/memory/reference_topology_eval_harness.md`

The worker should build the harness first, then iterate on layout until metrics pass, then the user reviews visually.

**Dependency approved:** `d3-hierarchy` (or the `d3` module that includes it). MIT licensed, battle-tested. Pre-approved by the user — no need to ask.
