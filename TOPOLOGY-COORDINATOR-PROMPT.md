# Topology Refactor: Coordinator Prompt

## Your Role

You are the coordinator for the topology visualization refactor. Your job is to assess the current state of the codebase, re-evaluate the phased implementation plan given new technical direction, and break work into parallelizable worktree tasks.

## Background

Read these documents first:

1. **UX Design Doc**: `/Users/maya/.claude/projects/-Users-maya-dev-scanopy/planned-work/topology-visualization-redesign.md` — The approved UX design. Pay special attention to the new sections: "Edge Classification: Primary vs Overlay", the updated "Layout Engine" section, the "Perspective × Grouping × Layout × Primary Edge Matrix", and the "Layout & Edge Research" appendix.
2. **Project Instructions**: `/Users/maya/dev/scanopy/CLAUDE.md` — Coding conventions, worktree workflow, coordinator responsibilities.

There is also a Phase 1 spec at `/Users/maya/.claude/projects/-Users-maya-dev-scanopy/planned-work/topology-redesign-phase1.md` — **this is partially stale**. The architectural decisions about node type generalization (Decision 1), infra zone as grouping rule (Decision 2), GroupingConfig (Decision 3), client-side collapse (Decision 4), and cross-cutting hulls (Decision 6) are still valid. Decision 5 (force-directed layout) is superseded. The task plan in the Phase 1 spec should NOT be followed directly — you are re-planning based on the current state and new technical direction.

## What happened so far

### Previous implementation work (on `dev` branch)

Foundational refactor work was done on the `dev` branch:
- Node type generalization (ContainerNode/LeafNode, serde aliases, SQL migration)
- Frontend entity resolvers
- GroupingConfig translation layer
- Edge handle generalization

Then significant iteration was spent trying to make force-directed layout (d3-force) work for L3 topology. That produced hairballs. Then the direction shifted to pure tree layout (d3-hierarchy). That was also wrong — see below.

### New technical direction (just decided)

Two key insights emerged from visualization research that change the approach:

#### 1. Compound layered layout (elkjs), not tree or force-directed

L3 topology is NOT a pure tree. Multi-homed hosts (one host on two subnets) have two parents, which breaks the tree assumption. L3 is a **layered compound graph**: subnet containers have a natural layer ordering (`SubnetType::vertical_order` = Sugiyama layer assignment), and interface edges connect nodes across containers.

**ELK (Eclipse Layout Kernel)** via `elkjs` is the right algorithm. It implements compound Sugiyama layout (Sander 1996):
- Recursive compound layout: lays out nodes within each container, then containers relative to each other
- Layer constraints: `vertical_order` maps directly to Sugiyama layer assignment
- Edge crossing minimization for inter-container edges
- Orthogonal edge routing across container boundaries
- Deterministic, single-pass, no simulation

This is NOT a return to the old bespoke Sugiyama hybrid. It's replacing a hand-rolled implementation with a battle-tested library (ELK, developed at Kiel University, MIT licensed) that handles compound graphs natively.

#### 2. Primary/overlay edge classification

The hairball problem was not just the wrong algorithm — it was also too many edge types competing for layout attention. Research (Ghoniem et al. 2004, Holten 2006) shows that each perspective should have **one primary edge type** that drives layout, with everything else as overlays drawn after positioning.

For L3, this means:
- **PRIMARY (affects layout):** Interface edges only — "how are my subnets connected?"
- **OVERLAY (drawn after layout, off by default):** RequestPath, HubAndSpoke — "why are subnets connected?"
- **NOT SHOWN by default:** PhysicalLink (belongs to L2), ServiceVirtualization (belongs to Infrastructure), HostVirtualization (belongs to Infrastructure)

This reduces L3's layout-affecting edges from 5-6 types to ONE. The layout engine only optimizes for Interface edge crossings. Everything else is visual annotation.

The full edge classification matrix is in the UX design doc under "Edge Classification: Primary vs Overlay."

## Step 1: Assess Current State

Before planning, understand what exists:

1. Check all active worktrees: `git worktree list`
2. Check what's on `dev` vs `main`: `git log main..dev --oneline`
3. Read the diffs to understand what refactor work was done
4. Run `cd backend && cargo test --lib` and `cd ui && npm test` on dev — do they pass?
5. Determine: is the foundational work (node type generalization, GroupingConfig, frontend resolvers, edge handle generalization) clean and working? Or is it entangled with force-directed/tree-specific code?

**Recommend one of:**

- **Option A: Start clean from main.** Reset dev to main. Choose this if the existing work is broken, entangled, or would take more effort to clean up than to redo.
- **Option B: Salvage foundations, remove layout-specific code.** Keep the clean foundational work, revert/remove force-directed and tree layout code, build elkjs layout on top. Choose this if the foundations are solid and separable.

**Present your recommendation with evidence to the user and wait for approval before proceeding.**

## Step 2: Re-evaluate the Phase 1 Plan

After the user approves the direction from Step 1, **re-plan Phase 1** based on the updated UX design doc. The implementation sequence in the UX doc lists these Phase 1 items:

1. Generalize the container model (ContainerNode/LeafNode primitives)
2. Generalize grouping (TopologyRequestOptions → GroupingConfig)
3. Edge perspective classification (primary/overlay distinction)
4. Compound layered layout (elkjs, replacing bespoke Sugiyama)
5. C4-1 zoom (container collapse)
6. Edge bundling

Some of these may already be done on `dev` (Step 1 will tell you). Don't re-do completed work.

**Key questions to answer when re-planning:**

- Which items are already done and clean?
- Which items are partially done but need cleanup?
- What's the dependency order? (e.g., elkjs layout depends on generalized container model; edge classification depends on the edge types being defined)
- Which items can be parallelized as worktree tasks?
- Is there a natural checkpoint where we should stop, merge, and verify before continuing? (The coordinator prompt for the previous approach had a checkpoint after foundational work and before layout — is that still the right boundary, or should the boundary move?)
- **Does `elkjs` change the server/client boundary?** Currently the server runs layout (bespoke Sugiyama). With elkjs, layout moves client-side. What does the server still need to provide? (Answer: graph structure, container membership, layer hints, edge classification. No pixel positions.)

**Present the re-planned Phase 1 as a task breakdown with dependencies, parallelism opportunities, and recommended checkpoints. Wait for user approval before creating worktrees.**

## Step 3: Execute

After the user approves the plan from Step 2, break work into worktree tasks following CLAUDE.md coordinator workflow. Create worktrees, write TASK.md files, provide initiation commands.

**After each checkpoint: STOP.** Merge completed work to dev. Present to the user for review. Do not proceed to the next batch until the user confirms.

## Pre-approved Dependency

`elkjs` — ELK Java compiled to JavaScript via GWT. MIT licensed, maintained by Kiel University + Eclipse Foundation. ~2MB bundle size (mitigate with Web Worker loading). Install: `npm install elkjs`

## Reference: Evaluation Harness

For iterating on layout quality, a Playwright-based evaluation harness can extract node positions from the DOM and compute quality metrics (overlap, cohesion, hierarchy flow, edge crossings). Details at:

`/Users/maya/.claude/projects/-Users-maya-dev-scanopy/memory/reference_topology_eval_harness.md`

The worker implementing the elkjs layout should build this harness to iterate without requiring the user to review screenshots manually.
