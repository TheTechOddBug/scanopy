var TEST_PLANS = [
{
  "branch": "refactor/topology-legacy-cleanup",
  "tests": [
    {
      "id": "topology-renders-after-cleanup",
      "category": "Topology Rendering",
      "description": "Verify topology renders correctly after backend cleanup",
      "steps": [
        "Navigate to a network's topology page",
        "Verify the topology loads and displays nodes (subnets as containers, interfaces as leaf nodes)",
        "Verify edges appear between nodes connecting different subnets",
        "Verify container nodes (subnets) are properly sized to fit their children"
      ],
      "expected": "Topology renders identically to before the refactor — ELK handles all layout, so removing backend position/size computation should have zero visual impact",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "topology-docker-bridge-grouping",
      "category": "Topology Rendering",
      "description": "Verify Docker Bridge subnet consolidation still works",
      "setup": "Ensure the network has a host with multiple Docker Bridge subnets and the 'Group Docker Bridges' option is enabled",
      "steps": [
        "Navigate to the topology page",
        "Enable 'Group Docker Bridges' if not already enabled",
        "Verify Docker Bridge subnets for the same host are consolidated into a single container node",
        "Verify the consolidated container header shows 'Docker Bridge: (cidr1, cidr2)'"
      ],
      "expected": "Docker bridge consolidation works as before, with correct header text showing CIDRs",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "topology-nested-grouping",
      "category": "Topology Rendering",
      "description": "Verify nested grouping containers (ByServiceCategory, ByTag) still render",
      "setup": "Ensure grouping rules are configured with at least one ByServiceCategory or ByTag rule that matches hosts in the topology",
      "steps": [
        "Navigate to the topology page",
        "Verify nested group containers appear within subnet containers",
        "Verify leaf nodes are correctly parented to their group container"
      ],
      "expected": "Nested grouping works as before — group containers appear inside subnets with correct child assignment",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "topology-rebuild",
      "category": "Topology Operations",
      "description": "Verify topology rebuild works after refactor",
      "steps": [
        "Navigate to the topology page",
        "Click the rebuild/refresh button to trigger a topology rebuild",
        "Verify the topology reloads and renders correctly"
      ],
      "expected": "Topology rebuilds successfully with no errors",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    },
    {
      "id": "topology-layer-hints",
      "category": "Topology Rendering",
      "description": "Verify subnet layer hints (vertical ordering) are preserved",
      "steps": [
        "Navigate to the topology page for a network with multiple subnet types (e.g., Internet, Gateway, LAN, Docker Bridge)",
        "Verify subnets are arranged in the expected vertical order based on their type"
      ],
      "expected": "Subnets maintain correct vertical ordering: Internet/Remote at top, Gateway/DMZ next, LAN/WiFi in middle, Docker/Management at bottom",
      "flow": "setup",
      "sequence": 5,
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "feat/topology-filter-unification",
  "tests": [
    {
      "id": "filters-section-layout",
      "category": "Layout",
      "description": "Verify the unified Filters section has correct hierarchy: Hosts > By Tag, Services > By Tag + By Category, Subnets > By Tag, Edges > By Type",
      "steps": [
        "Open a topology",
        "Open the options panel",
        "Expand the Filters section"
      ],
      "setup": "Ensure the topology has hosts, services, and subnets with tags, and multiple service categories and edge types.",
      "expected": "A single 'Filters' section with help text. Four entity subsections with uppercase headers (HOSTS, SERVICES, SUBNETS, EDGES). Hosts has 'By Tag' pills, Services has 'By Tag' and 'By Category' pills, Subnets has 'By Tag' pills, Edges has 'By Type' pills. No 'Tag Filter' or 'Hide Stuff' sections exist.",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "hide-ports-in-visual",
      "category": "Layout",
      "description": "Verify Hide Ports toggle is in the Visual section",
      "steps": [
        "Expand the Visual section in the options panel"
      ],
      "expected": "The 'Hide Ports' toggle appears in the Visual section alongside Bundle Edges, Don't Fade Edges, etc.",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "tag-filter-hosts",
      "category": "Filter Interaction",
      "description": "Verify host tag filtering works under Hosts > By Tag",
      "steps": [
        "In the Filters section under HOSTS, click a tag pill"
      ],
      "setup": "Ensure the topology has at least 2 hosts with different tags.",
      "expected": "The tag pill becomes faded. Hosts with that tag are faded/hidden in the topology.",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "tag-filter-services",
      "category": "Filter Interaction",
      "description": "Verify service tag filtering works under Services > By Tag",
      "steps": [
        "Under SERVICES, click a tag pill in the By Tag sub-group"
      ],
      "setup": "Ensure the topology has services with tags.",
      "expected": "Services with that tag are faded/hidden in the topology.",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    },
    {
      "id": "category-filter",
      "category": "Filter Interaction",
      "description": "Verify service category filtering works under Services > By Category",
      "steps": [
        "Under SERVICES, click a category pill in the By Category sub-group"
      ],
      "expected": "The category pill becomes faded. Services in that category disappear from the topology after rebuild.",
      "flow": "setup",
      "sequence": 5,
      "status": null,
      "feedback": null
    },
    {
      "id": "edge-type-filter",
      "category": "Filter Interaction",
      "description": "Verify edge type filtering works under Edges > By Type",
      "steps": [
        "Under EDGES, click an edge type pill in the By Type sub-group"
      ],
      "expected": "The edge type pill becomes faded. Edges of that type are hidden from the topology.",
      "flow": "setup",
      "sequence": 6,
      "status": null,
      "feedback": null
    },
    {
      "id": "edge-type-hover",
      "category": "Filter Interaction",
      "description": "Verify edge type hover highlighting still works",
      "steps": [
        "Hover over an edge type pill under EDGES (without clicking)"
      ],
      "expected": "Edges of that type are highlighted in the topology. Moving mouse away removes the highlight.",
      "flow": "setup",
      "sequence": 7,
      "status": null,
      "feedback": null
    },
    {
      "id": "filters-section-collapse",
      "category": "Layout",
      "description": "Verify the Filters section collapses and expands",
      "steps": [
        "Click the Filters section header to collapse it",
        "Click again to expand it"
      ],
      "expected": "The section collapses hiding all entity sub-groups, and expands showing them again.",
      "flow": "setup",
      "sequence": 8,
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "feat/topology-open-ports-summary",
  "tests": [
    {
      "id": "services-not-filtered-by-backend",
      "category": "Backend Returns All Services",
      "description": "Verify that OpenPorts services are included in the topology response even when hide_service_categories includes OpenPorts",
      "steps": [
        "Open the topology page",
        "Open browser dev tools Network tab",
        "Trigger a topology rebuild (e.g. change an option and change it back)",
        "Inspect the topology API response JSON"
      ],
      "setup": "Ensure at least one host has OpenPorts services discovered (run a discovery scan with port scanning enabled).",
      "expected": "The topology response should contain services with OpenPorts category in the services array, even though the default options hide OpenPorts.",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "category-filtering-frontend",
      "category": "Frontend Category Filtering",
      "description": "Verify that hidden service categories are not displayed on leaf nodes",
      "steps": [
        "Open the topology page with default options (OpenPorts hidden by default)",
        "Look at leaf nodes that have regular services (DNS, HTTP, etc.)"
      ],
      "setup": "Ensure hosts have both regular services and OpenPorts services.",
      "expected": "Leaf nodes should show regular services but NOT show individual OpenPorts services directly. OpenPorts should only appear as a summary pill.",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "open-ports-pill-displayed",
      "category": "Open Ports Summary Pill",
      "description": "Verify the +N open ports pill appears on nodes with hidden OpenPorts services",
      "steps": [
        "Open the topology page with default options",
        "Find a leaf node that has OpenPorts services"
      ],
      "setup": "Ensure at least one host has OpenPorts services discovered.",
      "expected": "A small pill/badge reading '+N open ports' (where N is the count) should appear at the bottom of the service list on that leaf node.",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "open-ports-pill-expand",
      "category": "Open Ports Summary Pill",
      "description": "Verify clicking the pill expands to show individual open port services",
      "steps": [
        "Find a leaf node with the '+N open ports' pill",
        "Click the pill"
      ],
      "expected": "The pill should expand to show individual open port service rows (with icons and names), plus a 'Hide open ports' link at the bottom.",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    },
    {
      "id": "open-ports-pill-collapse",
      "category": "Open Ports Summary Pill",
      "description": "Verify clicking 'Hide open ports' collapses back to the pill",
      "steps": [
        "With open ports expanded on a card, click 'Hide open ports'"
      ],
      "expected": "The individual port services should disappear and the '+N open ports' pill should reappear.",
      "flow": "setup",
      "sequence": 5,
      "status": null,
      "feedback": null
    },
    {
      "id": "open-ports-per-card-state",
      "category": "Open Ports Summary Pill",
      "description": "Verify that expanding open ports on one card does not affect other cards",
      "steps": [
        "Find two leaf nodes that both have the open ports pill",
        "Click to expand on one card only",
        "Check the other card"
      ],
      "setup": "Ensure at least two hosts have OpenPorts services.",
      "expected": "Only the clicked card should show expanded open ports. The other card should still show the collapsed pill.",
      "flow": "setup",
      "sequence": 6,
      "status": null,
      "feedback": null
    },
    {
      "id": "no-pill-when-no-open-ports",
      "category": "Open Ports Summary Pill",
      "description": "Verify the pill does not appear on nodes without OpenPorts services",
      "steps": [
        "Find a leaf node that only has regular services (no OpenPorts)"
      ],
      "expected": "No open ports pill should be shown. Only regular services should be displayed.",
      "status": null,
      "feedback": null
    },
    {
      "id": "vm-header-suppression",
      "category": "VM Header Suppression",
      "description": "Verify hide_vm_title_on_docker_container works from the frontend",
      "steps": [
        "Open topology with a Docker container that runs on a VM",
        "Verify VM header text is shown (e.g. 'VM: Proxmox')",
        "Toggle 'Hide VM provider on containers' option ON",
        "Check the same container node"
      ],
      "setup": "Ensure there is a host that is both a Docker host and a VM, so it shows a VM header on its container nodes.",
      "expected": "With the option OFF, the VM header (starting with 'VM:') should be visible. With the option ON, the VM header should be hidden but other headers (like 'Docker @...') should remain.",
      "status": null,
      "feedback": null
    },
    {
      "id": "unhide-open-ports-category",
      "category": "Category Unhide",
      "description": "Verify that unhiding the OpenPorts category shows them as normal services (no pill)",
      "steps": [
        "Open topology options panel",
        "In the category filter section, unhide the OpenPorts category",
        "Check leaf nodes that had the open ports pill"
      ],
      "expected": "The pill should disappear and open port services should render as normal service rows, just like other services.",
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "feat/topology-grouping-split",
  "tests": [
    {
      "id": "container-grouping-section-visible",
      "category": "UI Layout",
      "description": "Container grouping section appears in options panel",
      "steps": [
        "Open topology options panel",
        "Expand the 'Group by' section"
      ],
      "expected": "Two sections visible: 'Container grouping' with BySubnet (locked) and ByVirtualizingService, and 'Leaf grouping' with the default ByServiceCategory rule",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "bysubnet-locked",
      "category": "Container Rules",
      "description": "BySubnet rule is locked and cannot be removed or reordered",
      "steps": [
        "Open topology options panel",
        "Expand 'Group by' section",
        "Look at the BySubnet item in the Container grouping list"
      ],
      "expected": "BySubnet shows a lock icon and has no remove button. It cannot be deleted.",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "remove-add-container-rule",
      "category": "Container Rules",
      "description": "Can remove and re-add ByVirtualizingService container rule",
      "steps": [
        "Open topology options panel, expand 'Group by'",
        "Remove the ByVirtualizingService rule using its delete button",
        "Verify the add dropdown now shows 'Docker bridges' as an option",
        "Add 'Docker bridges' back from the dropdown"
      ],
      "expected": "ByVirtualizingService is removed, then re-appears in dropdown, and can be added back to the list",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "collapsed-rule-shows-title-or-type",
      "category": "UI Layout",
      "description": "Collapsed leaf rule shows custom title or type name, not both",
      "steps": [
        "Open topology options panel, expand 'Group by'",
        "Look at the default ByServiceCategory rule in Leaf grouping",
        "Click to expand it, set the title to 'Infra'",
        "Click to collapse it"
      ],
      "expected": "Collapsed state shows 'Infra' (custom title) — no type badge, no inline input, no config summary visible",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    },
    {
      "id": "expand-service-category-rule",
      "category": "Leaf Rules",
      "description": "Expanding ByServiceCategory rule shows title input and toggleable category pills",
      "steps": [
        "Open topology options panel, expand 'Group by'",
        "Click on the ByServiceCategory leaf rule to expand it"
      ],
      "setup": "Ensure topology has hosts with services in multiple categories (DNS, ReverseProxy, etc.)",
      "expected": "Expanded view shows a title text input (with 'Optional title' placeholder) and colored category pills below. Selected categories are highlighted, unselected are dimmed.",
      "flow": "setup",
      "sequence": 5,
      "status": null,
      "feedback": null
    },
    {
      "id": "toggle-category-pill",
      "category": "Leaf Rules",
      "description": "Toggling a category pill updates the rule and triggers rebuild",
      "steps": [
        "Expand ByServiceCategory rule",
        "Click on an unselected category pill to select it",
        "Click on a selected category pill to deselect it"
      ],
      "setup": "Ensure topology has hosts with services in multiple categories",
      "expected": "Category pills toggle between highlighted/dimmed states. Topology rebuilds after debounce.",
      "flow": "setup",
      "sequence": 6,
      "status": null,
      "feedback": null
    },
    {
      "id": "add-tag-leaf-rule",
      "category": "Leaf Rules",
      "description": "Can add a ByTag leaf rule and select tags as pills",
      "steps": [
        "Open topology options panel, expand 'Group by'",
        "Add a 'Tag' rule from the Leaf grouping dropdown",
        "Verify it auto-expands to show title input and tag pills",
        "Toggle some tags on and off"
      ],
      "setup": "Create at least 3 tags and assign them to various hosts",
      "expected": "New tag rule appears, expanded with all existing tags shown as toggleable pills. Selected tags are highlighted. No search input is shown.",
      "flow": "setup",
      "sequence": 7,
      "status": null,
      "feedback": null
    },
    {
      "id": "reorder-leaf-rules",
      "category": "Leaf Rules",
      "description": "Leaf rules can be reordered with up/down arrows",
      "steps": [
        "Add a second leaf rule (ByTag) in addition to ByServiceCategory",
        "Use the up/down arrows to reorder them"
      ],
      "expected": "Rules swap positions when arrows are clicked. First rule has no up arrow disabled, last rule has down arrow disabled.",
      "flow": "setup",
      "sequence": 8,
      "status": null,
      "feedback": null
    },
    {
      "id": "virtualization-edge-inspector",
      "category": "Inspector",
      "description": "Service virtualization edge inspector detects container grouping correctly",
      "steps": [
        "Open a topology with Docker containers",
        "Click on a service virtualization edge",
        "Verify it shows 'Containerized Services' (plural, grouped mode)",
        "Remove ByVirtualizingService from container rules",
        "Rebuild the topology",
        "Click on a service virtualization edge again"
      ],
      "setup": "Ensure network has a host running Docker with multiple containers",
      "expected": "With ByVirtualizingService: shows 'Containerized Services' (plural). Without: shows 'Containerized Service' (singular).",
      "status": null,
      "feedback": null
    },
    {
      "id": "persistence-across-reload",
      "category": "Persistence",
      "description": "Container and leaf rule changes persist across page reload",
      "steps": [
        "Modify container rules (remove ByVirtualizingService)",
        "Add a ByTag leaf rule with some tags selected",
        "Reload the page",
        "Open the options panel and check grouping sections"
      ],
      "expected": "All changes are preserved — ByVirtualizingService still removed, ByTag rule still present with same tags selected",
      "status": null,
      "feedback": null
    }
  ]
}
];
