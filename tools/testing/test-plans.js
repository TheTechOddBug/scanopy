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
  "branch": "fix/trial-reuse-bug",
  "tests": [
    {
      "id": "first-time-trial-works",
      "category": "Trial Flow",
      "description": "First-time user can start a 14-day free trial",
      "steps": [
        "Create a new account",
        "Go to billing settings",
        "Select Starter plan",
        "Verify '14-day free trial' text is shown",
        "Click 'Start 14-day free trial'",
        "Verify trial activates without requiring credit card"
      ],
      "expected": "Trial starts successfully, plan status shows 'trialing', trial end date is 14 days from now",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "trial-messaging-hidden-after-use",
      "category": "Trial Reuse Prevention",
      "description": "After trial expires and org downgrades to Free, trial messaging is hidden",
      "steps": [
        "Go to billing settings",
        "Verify '14-day free trial' text is NOT shown on any paid plan",
        "Verify the CTA button says 'Get Started' not 'Start free trial'"
      ],
      "setup": "Use a Stripe test clock. Create account, start Starter trial, advance clock past trial expiry so org auto-downgrades to Free.",
      "expected": "No trial messaging visible. Plans show 'Get Started' and require credit card.",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "no-second-trial-after-downgrade",
      "category": "Trial Reuse Prevention",
      "description": "Re-subscribing after trial expiry does not create a new trial period",
      "steps": [
        "Go to billing settings",
        "Select a paid plan (e.g., Starter)",
        "Complete checkout with credit card",
        "Verify subscription is active (not trialing)"
      ],
      "setup": "Use a Stripe test clock. Create account, start Starter trial, advance clock past trial expiry so org auto-downgrades to Free.",
      "expected": "Subscription starts immediately as 'active', not 'trialing'. No trial period applied. trial_end_date on org preserved from original trial.",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "no-trial-after-paid-cycle",
      "category": "Trial Reuse Prevention",
      "description": "After full cycle (trial → paid → downgrade → re-subscribe), no trial is offered",
      "steps": [
        "Go to billing settings",
        "Select a paid plan",
        "Verify no trial messaging is shown",
        "Complete checkout with credit card",
        "Verify subscription is active with correct trial_end (14 days, not 401 days)"
      ],
      "setup": "Use a Stripe test clock. Create account, start trial, advance clock past trial, re-subscribe with CC, then downgrade to Free (scheduled), advance clock past billing period so downgrade completes.",
      "expected": "No trial messaging shown. Subscription starts as 'active'. trial_end_date reflects original trial, not a new one.",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    },
    {
      "id": "trial-continues-on-plan-switch",
      "category": "Trial Flow",
      "description": "Switching plans during trial preserves the trial period",
      "steps": [
        "Go to billing settings",
        "Switch from Starter to Pro plan",
        "Verify 'Your trial continues' text is shown",
        "Verify trial end date is unchanged"
      ],
      "setup": "Create account, start Starter trial (should be currently in trialing status).",
      "expected": "Plan changes to Pro, trial continues with same end date, 'Your trial continues' shown on the selected plan.",
      "flow": "setup",
      "sequence": 5,
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "fix/inspector-density",
  "tests": [
    {
      "id": "service-name-not-truncated",
      "category": "Inspector Density",
      "description": "Service names should display fully without truncation in inspector",
      "steps": [
        "Open topology in L3 view",
        "Click on an IP address node that has services bound to it",
        "Look at the Services section in the inspector panel"
      ],
      "expected": "Service names are fully visible (e.g., 'Traefik' not 'Tra...'). No category tags (e.g., 'Reverse Proxy') appear inline. Port/binding info still appears as description text below the name.",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "host-name-not-truncated",
      "category": "Inspector Density",
      "description": "Host names should display fully without service name tags in inspector",
      "steps": [
        "Open topology in Workloads view",
        "Click on a host container node",
        "Look at the Identity section in the inspector panel"
      ],
      "expected": "Host name is fully visible. No service name tags appear inline next to the host name. Hostname description still shows below.",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "dependency-type-not-shown",
      "category": "Inspector Density",
      "description": "Dependency type tag should not appear in inspector",
      "steps": [
        "Open topology in Application view",
        "Click on a dependency edge (request path or hub-and-spoke)",
        "Look at the dependency card in the inspector"
      ],
      "expected": "Dependency name is fully visible. No 'Request Path' or 'Hub and Spoke' type tag appears inline. Member count description still shows.",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "binding-address-as-description",
      "category": "Inspector Density",
      "description": "Binding address should appear as description, not tag",
      "steps": [
        "Open topology in L3 view",
        "Click on a dependency edge that uses bindings (not services)",
        "Look at the member binding cards in the Services section"
      ],
      "expected": "Service name is fully visible on the first line. Binding address (e.g., '172.17.0.1 · 443/tcp') appears as description text below the name, not as a colored tag inline.",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    },
    {
      "id": "ip-address-no-subnet-tag",
      "category": "Inspector Density",
      "description": "IP address display should not show subnet CIDR tag in inspector",
      "steps": [
        "Open topology in L3 view",
        "Click on an IP address node",
        "Look at the Identity section and Other IP Addresses section"
      ],
      "expected": "IP address label is fully visible. No subnet CIDR tag appears inline. MAC address description still shows.",
      "flow": "setup",
      "sequence": 5,
      "status": null,
      "feedback": null
    },
    {
      "id": "non-topology-tags-preserved",
      "category": "Inspector Density",
      "description": "Tags should still appear in non-topology list selects",
      "steps": [
        "Navigate to Settings or any page with entity list selects (e.g., dependency editor, host list)",
        "Look at entity cards in list/select contexts outside the topology inspector"
      ],
      "expected": "Service cards show category tags, host cards show service name tags, dependency cards show type tags -- all tags display normally in non-topology contexts.",
      "flow": "setup",
      "sequence": 6,
      "status": null,
      "feedback": null
    },
    {
      "id": "tag-picker-still-works",
      "category": "Inspector Density",
      "description": "Entity tag pickers should still work in inspector",
      "steps": [
        "Open topology in any view",
        "Click on a service or host node",
        "Check that the tag picker (user-created tags) still appears and is functional"
      ],
      "expected": "Tag picker displays and allows adding/removing user tags. Compact mode only hides metadata tags, not the tag picker UI.",
      "flow": "setup",
      "sequence": 7,
      "status": null,
      "feedback": null
    },
    {
      "id": "aggregated-edge-compact",
      "category": "Inspector Density",
      "description": "Aggregated edge inspector should show compact display",
      "steps": [
        "Open topology and find an aggregated edge (bundled connections between containers)",
        "Click on the aggregated edge",
        "Look at the dependency, service, and host cards in the inspector"
      ],
      "expected": "All entity names are fully visible without inline tags. Dependencies show name and member count. Services show name and port info. Hosts show name and hostname.",
      "flow": "setup",
      "sequence": 8,
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "fix/rule-editability-model",
  "tests": [
    {
      "id": "system-rules-locked",
      "category": "Rule Editability",
      "description": "System rules (ByTrunkPort, ByVLAN, ByPortOpStatus) show lock icon and have no action buttons",
      "steps": [
        "Open the topology panel and switch to L2 Physical perspective",
        "Look at the element grouping rules list",
        "Verify Trunk Ports, VLAN, and Port Status rules show a lock icon",
        "Verify they have no move up/down, delete, or edit buttons"
      ],
      "expected": "System rules display with lock icon and no interactive controls",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "singleton-rules-reorderable",
      "category": "Rule Editability",
      "description": "Former singleton rules (ByHypervisor, ByContainerRuntime, ByStack) are reorderable but not removable",
      "steps": [
        "Open the topology panel on Workloads perspective",
        "Find the Hypervisor and Container Runtime rules in the element grouping list",
        "Verify they have move up/down buttons but no delete button",
        "Try reordering one rule relative to another",
        "Switch to L3 Logical perspective and verify Docker Stack rule behaves the same"
      ],
      "expected": "Former singleton rules can be reordered but cannot be deleted. No lock icon shown (they are reorderable).",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "singleton-rules-not-in-dropdown",
      "category": "Rule Editability",
      "description": "Former singleton rules do not appear in the add rule dropdown",
      "steps": [
        "Open the topology panel on Workloads perspective",
        "Click the add element rule dropdown",
        "Verify ByHypervisor, ByContainerRuntime are NOT listed as options",
        "Only ByServiceCategory and ByTag should appear"
      ],
      "expected": "Add dropdown only shows removable rules (ByServiceCategory and ByTag)",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "multi-rules-fully-editable",
      "category": "Rule Editability",
      "description": "ByServiceCategory and ByTag rules can be added, removed, reordered, and configured",
      "steps": [
        "Open the topology panel",
        "Add a new ByServiceCategory rule from the dropdown",
        "Verify the edit panel opens with category pills",
        "Toggle some categories and set a title",
        "Close the editor (checkmark)",
        "Reorder the new rule relative to another",
        "Delete the rule using the trash button"
      ],
      "expected": "Multi rules support full CRUD: add, configure (title + categories/tags), reorder, and remove",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    },
    {
      "id": "infra-rule-behavior",
      "category": "Infra Rule",
      "description": "Infrastructure ByServiceCategory rule is non-removable, non-reorderable, but configurable with dedicated tooltip",
      "steps": [
        "Open the topology panel on Application or Workloads perspective",
        "Find the Infrastructure rule in the element grouping list",
        "Verify it has no delete button and no move up/down buttons",
        "Hover over the rule and verify the tooltip says something about infrastructure services (not the generic 'Group elements by service category')",
        "Click the edit button (pencil icon)",
        "Verify the edit panel shows the infra note and category pills, but no title input"
      ],
      "expected": "Infra rule shows dedicated description tooltip, has edit pencil for categories, but no delete/reorder controls and no title input",
      "flow": "setup",
      "sequence": 5,
      "status": null,
      "feedback": null
    },
    {
      "id": "container-rules-editability",
      "category": "Rule Editability",
      "description": "Container rules follow the same capability model (MergeDockerBridges is editable, others locked)",
      "steps": [
        "Open the topology panel on L3 Logical perspective",
        "Look at the container grouping rules",
        "Verify Subnet rule shows lock icon with no controls",
        "Verify Docker bridges rule has delete and reorder buttons"
      ],
      "expected": "Container rules respect the capability flags: BySubnet locked, MergeDockerBridges removable/reorderable",
      "flow": "setup",
      "sequence": 6,
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
