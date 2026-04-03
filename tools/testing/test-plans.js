var TEST_PLANS = [
{
  "branch": "refactor/topology-legacy-cleanup",
  "tests": []
}
,
{
  "branch": "feat/topology-filter-unification",
  "tests": []
}
,
{
  "branch": "feat/topology-open-ports-summary",
  "tests": [
    {
      "id": "node-resize-on-category-filter",
      "category": "Node Sizing",
      "description": "Verify leaf nodes resize when services are hidden/shown by category filter",
      "steps": [
        "Open the topology page with default options (OpenPorts hidden)",
        "Note the size of a leaf node with many services",
        "Unhide OpenPorts in the category filter options",
        "Check the same leaf node"
      ],
      "setup": "Ensure at least one host has both regular services and OpenPorts services.",
      "expected": "The leaf node should be taller when OpenPorts are visible (more services shown) and shorter when they are hidden. The node size should tightly match the visible content.",
      "flow": "setup",
      "sequence": 1,
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
    }
  ]
}
,
{
  "branch": "feat/topology-container-layout",
  "tests": [
    {
      "id": "columnar-layout-basic",
      "category": "Container Layout",
      "description": "Verify leaf nodes within subnet containers are arranged in columns instead of rows",
      "steps": [
        "Navigate to the Topology page",
        "Observe the layout of leaf nodes within subnet containers (especially LAN subnets with 5+ nodes)",
        "Verify nodes are arranged in vertical columns rather than horizontal rows",
        "Verify similarly-sized nodes are grouped together within columns"
      ],
      "expected": "Leaf nodes within containers should be in columnar layout. Nodes of similar height should be visually grouped together in clean columns.",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "edge-aware-placement",
      "category": "Edge Awareness",
      "description": "Verify nodes with external edges are positioned near container boundaries",
      "steps": [
        "Navigate to the Topology page",
        "Identify nodes that have edges connecting to other subnets (cross-container edges)",
        "Check whether those nodes are positioned near the top or bottom of their container",
        "Nodes with upward edges (to subnets higher in the hierarchy like Gateway) should be near the top",
        "Nodes with downward-only edges (to subnets lower like DockerBridge) should be near the bottom"
      ],
      "expected": "Nodes with cross-container edges should be positioned near the container boundary in the direction of their edge. This should reduce visual edge crossing within containers.",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "subgroup-consistent-position",
      "category": "Sub-group Placement",
      "description": "Verify sub-group containers (TagGroup, ServiceCategoryGroup) have consistent placement",
      "steps": [
        "Navigate to the Topology page",
        "Enable leaf rules that create sub-groups (e.g., Infrastructure service category grouping)",
        "Observe where sub-group containers appear within their parent subnet containers",
        "Refresh the page and verify sub-groups appear in the same position"
      ],
      "setup": "Ensure the topology has at least one subnet with both sub-group containers and regular leaf nodes. Default leaf rules (Infrastructure ByServiceCategory) should produce sub-groups if DNS or ReverseProxy services exist.",
      "expected": "Sub-group containers should appear in a consistent, deterministic position within their parent container across page loads.",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "single-node-container",
      "category": "Edge Cases",
      "description": "Verify containers with a single node render correctly",
      "steps": [
        "Navigate to the Topology page",
        "Find a subnet container with only 1 leaf node",
        "Verify it renders correctly with proper padding and sizing"
      ],
      "expected": "Single-node containers should render cleanly with the node properly padded inside the container.",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    },
    {
      "id": "large-container-layout",
      "category": "Container Layout",
      "description": "Verify large containers (20+ nodes) pack well",
      "steps": [
        "Navigate to the Topology page",
        "Find or set up a subnet with 20+ leaf nodes",
        "Verify the columnar layout produces a compact, visually balanced container",
        "Verify no excessive whitespace or overflow"
      ],
      "setup": "Create at least 20 hosts on a single LAN subnet via the API to produce a large container.",
      "expected": "Large containers should produce a balanced multi-column layout without excessive whitespace. Columns should have roughly similar heights.",
      "flow": "setup",
      "sequence": 5,
      "status": null,
      "feedback": null
    },
    {
      "id": "inter-container-layout-preserved",
      "category": "No Regression",
      "description": "Verify inter-container layout (root graph) still works correctly",
      "steps": [
        "Navigate to the Topology page",
        "Verify containers are still arranged in vertical layers by subnet type (Internet/Remote at top, Gateway/VPN below, LAN in middle, Docker at bottom)",
        "Verify edges between containers route properly",
        "Verify collapsed containers still work"
      ],
      "expected": "Root-level container layout should be unchanged. Containers should respect their layer ordering and edges should route correctly between containers.",
      "flow": "setup",
      "sequence": 6,
      "status": null,
      "feedback": null
    },
    {
      "id": "collapsed-container",
      "category": "Edge Cases",
      "description": "Verify collapsed containers still render correctly",
      "steps": [
        "Navigate to the Topology page",
        "Collapse a subnet container by clicking its collapse toggle",
        "Verify it collapses to the minimum size (200x80)",
        "Expand it again and verify children reappear with columnar layout"
      ],
      "expected": "Collapsed containers should render as compact boxes. Expanding should restore the columnar layout.",
      "flow": "setup",
      "sequence": 7,
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
      "id": "bysubnet-locked",
      "category": "Container Rules",
      "description": "BySubnet rule is locked and cannot be removed or reordered — including rules below it cannot move above it",
      "steps": [
        "Open topology options panel, expand 'Group by'",
        "Verify BySubnet has no reorder arrows",
        "Verify ByVirtualizingService below it cannot move above it (up arrow disabled)"
      ],
      "expected": "BySubnet is always first. No rule can be moved above it.",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "reorder-leaf-rules-priority",
      "category": "Leaf Rules",
      "description": "First rule in list takes priority for overlapping nodes",
      "steps": [
        "Add ByServiceCategory rule with ReverseProxy selected",
        "Add ByTag rule with a tag assigned to the ReverseProxy host",
        "Verify the ReverseProxy node appears in the service category group (first rule wins)",
        "Reorder: move the ByTag rule above ByServiceCategory",
        "Rebuild topology",
        "Verify the ReverseProxy node now appears in the tag group (first rule wins)"
      ],
      "setup": "Create a tag and assign it to a host that also runs a ReverseProxy service",
      "expected": "Node appears in whichever group's rule is listed first.",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "group-headers-show-names",
      "category": "Visual",
      "description": "Leaf group container headers show category/tag names",
      "steps": [
        "Create a ByServiceCategory rule with DNS and ReverseProxy, title 'Infrastructure'",
        "Create a ByTag rule with 2 tags selected, no custom title",
        "Rebuild topology"
      ],
      "setup": "Ensure hosts exist with DNS/ReverseProxy services and tags",
      "expected": "Service category group header shows 'Infrastructure: DNS, ReverseProxy'. Tag group header shows 'Tag1, Tag2'.",
      "status": null,
      "feedback": null
    },
    {
      "id": "empty-groups-not-rendered",
      "category": "Visual",
      "description": "Groups with no matched nodes should not render at all",
      "steps": [
        "Create a ByServiceCategory rule selecting a category no hosts have",
        "Rebuild topology"
      ],
      "expected": "No empty group container appears in the topology.",
      "status": null,
      "feedback": null
    }
  ]
}
];
