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
  "branch": "fix/credential-assignment-regression",
  "tests": [
    {
      "id": "credential-assignment-snmp-network-scan",
      "category": "Credential Assignment",
      "description": "SNMP credential assigned to host after network discovery",
      "steps": [
        "Navigate to the network's discovery settings",
        "Ensure an SNMP credential is assigned to the network",
        "Run a discovery scan",
        "Wait for the scan to complete",
        "Open a discovered host that responded to SNMP",
        "Check the host's credential assignments section"
      ],
      "setup": "Create a network with an SNMP credential assigned. Ensure at least one host on the network responds to SNMP.",
      "expected": "The host should show the SNMP credential in its credential assignments after discovery completes.",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "credential-assignment-persists-rescan",
      "category": "Credential Assignment",
      "description": "Credential assignment persists after re-scan",
      "steps": [
        "Run a second discovery scan on the same network",
        "Wait for the scan to complete",
        "Open the same host from the first test",
        "Check the host's credential assignments section"
      ],
      "expected": "The SNMP credential assignment should still be present after the re-scan (not lost during upsert).",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "credential-assignment-docker-host",
      "category": "Credential Assignment",
      "description": "Docker credential assigned to daemon host after discovery",
      "steps": [
        "Navigate to the daemon host in the hosts list",
        "Check the host's credential assignments section"
      ],
      "setup": "Configure a Docker Socket or Docker Proxy credential on the network. Run a discovery scan with a daemon that has Docker available.",
      "expected": "The daemon host should show the Docker credential in its credential assignments.",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "credential-assignment-banner-matches-persisted",
      "category": "Credential Assignment",
      "description": "Discovery banner credential matches actually persist",
      "steps": [
        "Run a discovery scan",
        "Check the daemon logs for the discovery completion banner",
        "Note which credentials were matched to which IPs",
        "Open each matched host and verify the credential assignment exists"
      ],
      "expected": "Every credential match shown in the banner should have a corresponding persisted host-credential assignment.",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "fix/trial-reuse-bug",
  "tests": []
}
,
{
  "branch": "fix/inspector-density",
  "tests": []
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
  "branch": "fix/discovery-credential-visibility",
  "tests": [
    {
      "id": "credentials-visible-after-save",
      "category": "Credential Visibility",
      "description": "Credentials added to a discovery are visible when reopening the modal",
      "steps": [
        "Open the discovery edit modal for an existing Unified discovery",
        "Go to the Credentials tab",
        "Add a new SNMP credential with a target IP",
        "Save the discovery",
        "Reopen the same discovery modal",
        "Navigate to the Credentials tab"
      ],
      "expected": "The SNMP credential added in step 3 is visible in the credentials list as an existing credential",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "credential-removal-persisted",
      "category": "Credential Visibility",
      "description": "Removing all credentials from a discovery is persisted",
      "steps": [
        "Open the discovery modal that has credentials from the previous test",
        "Go to the Credentials tab",
        "Remove the credential",
        "Save the discovery",
        "Reopen the discovery modal",
        "Navigate to the Credentials tab"
      ],
      "expected": "The credentials tab is empty — no credentials listed",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "credentials-cleared-after-scan",
      "category": "Credential Lifecycle",
      "description": "Pending credentials are cleared after a scan completes",
      "setup": "Add an SNMP credential to a Unified discovery and save. Then trigger a scan and wait for it to complete.",
      "steps": [
        "Open the discovery modal after the scan has completed",
        "Navigate to the Credentials tab"
      ],
      "expected": "The credentials tab is empty — pending credentials were cleared after the scan ran",
      "status": null,
      "feedback": null
    },
    {
      "id": "lifecycle-messaging",
      "category": "Communication",
      "description": "The credentials tab explains the ephemeral lifecycle",
      "steps": [
        "Open the discovery edit modal for a Unified discovery",
        "Navigate to the Credentials tab"
      ],
      "expected": "The description text explains that credentials will be tried during the next scan, automatically assigned to responding hosts, and not retried after that",
      "status": null,
      "feedback": null
    },
    {
      "id": "daemon-modal-no-regression",
      "category": "No Regression",
      "description": "Daemon creation modal credential wizard still works",
      "steps": [
        "Open the Create Daemon modal",
        "Navigate to the Credentials step",
        "Add an SNMP credential",
        "Complete the daemon creation"
      ],
      "expected": "Credential wizard works normally — adding and creating credentials in the daemon flow is unaffected",
      "status": null,
      "feedback": null
    },
    {
      "id": "network-credentials-still-shown",
      "category": "No Regression",
      "description": "Network-level credentials still displayed as info tags",
      "setup": "Ensure the network has at least one network-level credential assigned.",
      "steps": [
        "Open the discovery edit modal for a Unified discovery on that network",
        "Navigate to the Credentials tab"
      ],
      "expected": "Network-level credentials appear as informational tags in the help section, separate from pending credentials",
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "fix/billing-plan-features",
  "tests": [
    {
      "id": "onboarding-starter-no-free-reference",
      "category": "Billing Plan Features",
      "description": "Starter plan in onboarding mode should not reference hidden Free plan",
      "steps": [
        "Open the onboarding billing modal (non-dismissible)",
        "Look at the Starter plan card's feature section"
      ],
      "setup": "Ensure user has no active subscription so onboarding modal appears with Free plan filtered out.",
      "expected": "Starter plan does NOT show 'Everything in Free, plus:'. Features are listed without a header label.",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "onboarding-starter-merged-features",
      "category": "Billing Plan Features",
      "description": "Starter plan in onboarding shows merged feature list from Free + Starter",
      "steps": [
        "Open the onboarding billing modal (non-dismissible)",
        "Count and review features listed under the Starter plan card"
      ],
      "setup": "Ensure user has no active subscription so onboarding modal appears with Free plan filtered out.",
      "expected": "Starter plan shows ~9 features: Free's features (Automated Network Mapping, Discovery Integrations, PNG Export, CSV Export) merged with Starter's incremental features (SVG Export, Scheduled Discovery, Email Support, Shareable Diagrams, Remove Watermark). No category sub-headers.",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "settings-starter-everything-in-free",
      "category": "Billing Plan Features",
      "description": "Starter plan in settings modal shows 'Everything in Free, plus:'",
      "steps": [
        "Open the settings/billing modal (dismissible mode)",
        "Look at the Starter plan card's feature section"
      ],
      "setup": "User must have an active subscription so the settings billing modal can be opened.",
      "expected": "Starter plan shows 'Everything in Free, plus:' header with only its 5 incremental features listed. Free plan card is visible with its 4 features.",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "consolidated-features-display",
      "category": "Billing Plan Features",
      "description": "Consolidated features show correct names and tooltips",
      "steps": [
        "Open any billing modal",
        "Hover over 'Automated Network Mapping' in a plan card",
        "Hover over 'Discovery Integrations' in a plan card"
      ],
      "expected": "Automated Network Mapping tooltip describes discovery, topology, and service identification. Discovery Integrations tooltip mentions Docker and SNMP.",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    },
    {
      "id": "billed-yearly-inline",
      "category": "Billing Card Layout",
      "description": "Yearly pricing shows 'billed yearly' inline with price",
      "steps": [
        "Open billing modal with Yearly toggle selected",
        "Check the price line on Starter, Pro, Business cards"
      ],
      "expected": "Price shows as '$X/mo, billed yearly' on a single line. No separate 'billed yearly' text below.",
      "flow": "setup",
      "sequence": 5,
      "status": null,
      "feedback": null
    },
    {
      "id": "cta-trial-text",
      "category": "Billing Card Layout",
      "description": "Trial CTA button includes 'no card required' text",
      "steps": [
        "Open onboarding billing modal as a new user (not returning customer)",
        "Check the CTA button text on trial-eligible plans"
      ],
      "setup": "Ensure user/org has never had a paid plan or trial (isReturningCustomer=false).",
      "expected": "CTA button reads 'Start free trial — no card required'. No separate line below the button.",
      "flow": "setup",
      "sequence": 6,
      "status": null,
      "feedback": null
    },
    {
      "id": "plan-descriptions-alignment",
      "category": "Billing Card Layout",
      "description": "Plan descriptions are similar length and break consistently",
      "steps": [
        "Open billing modal",
        "Compare description text across all visible plan cards"
      ],
      "expected": "All descriptions are roughly the same character length (~37-44 chars) and break to a similar number of lines.",
      "status": null,
      "feedback": null
    },
    {
      "id": "comparison-grid-individual-features",
      "category": "Billing Plan Features",
      "description": "Full comparison grid shows consolidated features, not old individual ones",
      "steps": [
        "Open billing modal",
        "Click 'Compare all features'",
        "Scroll through the feature grid"
      ],
      "expected": "Grid shows 'Automated Network Mapping' and 'Discovery Integrations' instead of the old individual features (Network Discovery, Topology Visualization, Service Definitions, Docker Discovery, SNMP Discovery, DaemonPoll, Community Support). All plans show checkmarks for the consolidated features.",
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
