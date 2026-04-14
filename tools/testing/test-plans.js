var TEST_PLANS = [
{
  "branch": "research/nudge-alignment",
  "tests": [
    {
      "id": "nudge-dependencies-navigates-topology",
      "category": "Feature Nudges",
      "description": "Dependencies nudge navigates to Workloads view (or Application if app tags exist)",
      "steps": [
        "On the Home tab, find the 'Create a Dependency' nudge",
        "Click its action button"
      ],
      "setup": "Ensure org has FirstTopologyRebuild but NOT FirstDependencyCreated. Clear localStorage for nudge-dismissed:dependencies. Test both cases: (a) without app tags, (b) with at least one application tag created.",
      "expected": "Without app tags: user lands on topology Workloads view. With app tags: user lands on topology Application view.",
      "status": null,
      "feedback": null
    },
    {
      "id": "dependency-tutorial-trigger",
      "category": "In-Topology Guided",
      "description": "Dependencies nudge triggers the dependency tutorial overlay",
      "steps": [
        "On the Home tab, click the 'Create a Dependency' nudge action button",
        "Observe the topology tab"
      ],
      "setup": "Ensure org has FirstTopologyRebuild but NOT FirstDependencyCreated. Clear localStorage for nudge-dismissed:dependencies.",
      "expected": "A tutorial overlay appears over the topology canvas with 3 pseudo-nodes (Web App, API Server, Database), a step checklist, and a skip button. The options panel is expanded and locked open.",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "dependency-tutorial-node-selection",
      "category": "In-Topology Guided",
      "description": "Clicking pseudo-nodes updates selection and checklist steps",
      "steps": [
        "Click the 'Web App' pseudo-node",
        "Observe step 1 checks off and progress dot fills",
        "Click the 'API Server' pseudo-node",
        "Observe the options panel now shows the dependency builder (2+ nodes selected)",
        "Click the 'Database' pseudo-node",
        "Observe step 2 checks off and all 3 progress dots are filled"
      ],
      "expected": "Each click adds to selection, progress dots fill green, checklist steps auto-complete. After 2+ nodes selected, the real InspectorMultiSelect panel shows dependency type toggle, name field, and edge style options.",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "dependency-tutorial-type-toggle",
      "category": "In-Topology Guided",
      "description": "Toggling dependency type in the panel auto-checks step 3",
      "steps": [
        "In the options panel, click the Hub & Spoke toggle in the dependency type segmented control",
        "Observe the tutorial checklist"
      ],
      "expected": "Step 3 in the checklist auto-checks. Step 4 becomes enabled.",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "dependency-tutorial-dismiss",
      "category": "In-Topology Guided",
      "description": "Tutorial can be dismissed via Got it button or Skip",
      "steps": [
        "Click the 'Got it' button in the options panel",
        "Observe the topology view"
      ],
      "expected": "Tutorial overlay closes. Options panel returns to normal (collapsible, tabs visible). Real topology is shown. No dependency was created.",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    },
    {
      "id": "dependency-tutorial-skip",
      "category": "In-Topology Guided",
      "description": "Skip button dismisses tutorial immediately",
      "steps": [
        "Trigger the tutorial again via the nudge",
        "Click 'Skip tutorial' at the bottom of the overlay"
      ],
      "expected": "Tutorial closes immediately, real topology shown, no artifacts left.",
      "status": null,
      "feedback": null
    },
    {
      "id": "view-switcher-hint-trigger",
      "category": "In-Topology Guided",
      "description": "Explore Views nudge shows a callout near the view switcher",
      "steps": [
        "On the Home tab, click the 'Explore Topology Views' nudge action button",
        "Observe the topology toolbar"
      ],
      "setup": "Ensure org has FirstTopologyRebuild. Clear localStorage for nudge-dismissed:explore-perspectives.",
      "expected": "A tooltip/callout appears near the view switcher dropdown with text about trying different views.",
      "status": null,
      "feedback": null
    },
    {
      "id": "view-switcher-hint-dismiss-on-change",
      "category": "In-Topology Guided",
      "description": "View switcher hint dismisses when user changes view",
      "steps": [
        "With the hint visible, click the view switcher dropdown",
        "Select a different view (e.g., L2 Physical)"
      ],
      "expected": "The hint/callout disappears after the view is changed.",
      "status": null,
      "feedback": null
    },
    {
      "id": "no-tutorial-without-nudge",
      "category": "In-Topology Guided",
      "description": "Normal topology usage shows no tutorial or hint",
      "steps": [
        "Navigate directly to the topology tab (not via a nudge)",
        "Observe the topology view"
      ],
      "expected": "No tutorial overlay, no view switcher hint. Everything works as normal.",
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "refactor/topology-node-model",
  "tests": [
    {
      "id": "topology-l3-renders",
      "category": "Topology Views",
      "description": "L3 Infrastructure view renders correctly after node model changes",
      "steps": [
        "Navigate to Topology page",
        "Select the L3 Infrastructure view",
        "Verify subnet containers render with correct icons and colors",
        "Verify elements (IP addresses) appear inside their subnet containers",
        "Verify edges connect between elements correctly"
      ],
      "expected": "L3 view renders identically to before the refactor — no visual regressions",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "topology-l2-renders",
      "category": "Topology Views",
      "description": "L2 Physical view renders correctly",
      "steps": [
        "Select the L2 Physical view",
        "Verify Host containers appear with device names",
        "Verify Interface elements appear inside Host containers",
        "Verify physical link edges connect between hosts"
      ],
      "expected": "L2 view renders correctly with Host containers and Interface elements",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "topology-application-renders",
      "category": "Topology Views",
      "description": "Application view renders correctly",
      "steps": [
        "Select the Application view",
        "Verify Application containers appear with tag names and colors",
        "Verify Service elements appear inside their application containers",
        "Verify dependency edges connect services"
      ],
      "expected": "Application view renders with correct grouping and styling",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "topology-workloads-renders",
      "category": "Topology Views",
      "description": "Workloads view renders correctly with Hypervisor/ContainerRuntime subcontainers",
      "steps": [
        "Select the Workloads view",
        "Verify Host containers appear for bare metal hosts",
        "Verify Hypervisor subcontainers nest inside host containers",
        "Verify VM elements appear inside Hypervisor subcontainers",
        "Verify ContainerRuntime subcontainers appear for Docker hosts"
      ],
      "setup": "Requires hosts with Proxmox VMs and/or Docker containers discovered",
      "expected": "Workloads view shows correct nesting hierarchy with subcontainers",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    },
    {
      "id": "topology-element-rules-subcontainers",
      "category": "Element Rules",
      "description": "Element rules create subcontainers with correct element_rule_id and will_accept_edges",
      "steps": [
        "Open topology with ByTag or ByServiceCategory element rules configured",
        "Verify NestedTag or NestedServiceCategory subcontainers appear",
        "Verify elements are grouped inside the subcontainers",
        "Collapse a subcontainer and verify it collapses correctly"
      ],
      "setup": "Configure element rules (ByTag with a tag, or ByServiceCategory) on a perspective that has matching elements",
      "expected": "Subcontainers render, elements are grouped, collapse/expand works",
      "flow": "setup",
      "sequence": 5,
      "status": null,
      "feedback": null
    },
    {
      "id": "topology-edge-elevation",
      "category": "Edge Behavior",
      "description": "Edges with will_target_container still elevate to container boundaries",
      "steps": [
        "Open L3 view with Docker bridge grouping enabled",
        "Verify edges targeting consolidated Docker bridge subnets attach at the container boundary, not at individual elements"
      ],
      "setup": "Requires a topology with Docker bridge subnets that are consolidated (multiple Docker bridges on one host)",
      "expected": "Edges visually attach to the consolidated subnet container, not individual elements inside",
      "flow": "setup",
      "sequence": 6,
      "status": null,
      "feedback": null
    },
    {
      "id": "topology-container-metadata",
      "category": "Container Metadata",
      "description": "Container type metadata renders correctly (icons, colors, title styles)",
      "steps": [
        "Open any topology view",
        "Verify top-level containers have External title style (title above container)",
        "Verify subcontainers have Inline title style (title inside container)",
        "Verify PortOpStatus containers are collapsed by default with filled circle icon"
      ],
      "expected": "All container types display with correct visual styling from metadata",
      "flow": "setup",
      "sequence": 7,
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "refactor/edge-naming-audit",
  "tests": []
}
,
{
  "branch": "feat/starter-trial",
  "tests": []
}
,
{
  "branch": "fix/workloads-empty-hosts-openports",
  "tests": [
    {
      "id": "l3-docker-bridge-positioning",
      "category": "L3 View",
      "description": "Docker Bridge containers should be positioned near their host's subnet",
      "steps": [
        "Navigate to the Topology page and select the L3 Logical view",
        "Find a host running Docker with the MergeDockerBridges grouping rule enabled",
        "Observe the Docker Bridge container's position relative to the subnet containing the host's IP"
      ],
      "setup": "Ensure a host with Docker and containerized services exists, and the MergeDockerBridges container rule is active in L3 grouping.",
      "expected": "The Docker Bridge container is positioned adjacent to or near the subnet containing the Docker host, not far away in a disconnected position.",
      "status": null,
      "feedback": null
    }
  ]
}
];
