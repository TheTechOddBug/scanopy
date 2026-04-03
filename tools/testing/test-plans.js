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
      "id": "open-ports-pill-displayed",
      "category": "Open Ports Summary Pill",
      "description": "Verify the +N open ports pill appears on nodes with hidden OpenPorts services, with proper spacing and clickable appearance",
      "steps": [
        "Open the topology page with default options",
        "Find a leaf node that has OpenPorts services"
      ],
      "setup": "Ensure at least one host has OpenPorts services discovered.",
      "expected": "A small underlined pill/badge reading '+N open ports' should appear at the bottom of the service list, with clear spacing from the footer IP address.",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
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
      "expected": "The leaf node should be taller when OpenPorts are visible (more services shown) and shorter when they are hidden. The node size should match the visible content.",
      "flow": "setup",
      "sequence": 2,
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
  "branch": "feat/topology-grouping-split",
  "tests": [
    {
      "id": "bysubnet-locked",
      "category": "Container Rules",
      "description": "BySubnet rule is locked and cannot be removed or reordered",
      "steps": [
        "Open topology options panel",
        "Expand 'Group by' section",
        "Look at the BySubnet item in the Container grouping list",
        "Verify no reorder arrows or delete button on BySubnet"
      ],
      "expected": "BySubnet shows a lock icon, no reorder arrows, no remove button. Cannot be moved or deleted.",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "expand-service-category-rule",
      "category": "Leaf Rules",
      "description": "Clicking Edit expands rule; clicking Check collapses; edits don't collapse",
      "steps": [
        "Open topology options panel, expand 'Group by'",
        "Click the Edit button on the ByServiceCategory leaf rule",
        "Verify it expands showing title input and category pills",
        "Type a title, toggle some category pills",
        "Verify the rule stays expanded during edits",
        "Click the Check button to collapse"
      ],
      "setup": "Ensure topology has hosts with services in multiple categories (DNS, ReverseProxy, etc.)",
      "expected": "Edit button expands, changes to Check icon. Editing title and toggling pills does NOT collapse. Clicking Check collapses. Clicking the card text does NOT expand.",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "toggle-category-pill",
      "category": "Leaf Rules",
      "description": "Toggling a category pill updates the rule and triggers rebuild",
      "steps": [
        "Expand ByServiceCategory rule via Edit button",
        "Click on an unselected category pill to select it",
        "Click on a selected category pill to deselect it"
      ],
      "setup": "Ensure topology has hosts with services in multiple categories",
      "expected": "Category pills toggle between highlighted/dimmed states without closing the editor. Topology rebuilds after debounce.",
      "flow": "setup",
      "sequence": 3,
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
      "expected": "New tag rule appears, expanded with all existing tags shown as toggleable pills. Selected tags are highlighted. No search input is shown. Toggling tags does not collapse.",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    },
    {
      "id": "reorder-leaf-rules-priority",
      "category": "Leaf Rules",
      "description": "First rule in list takes priority for overlapping nodes",
      "steps": [
        "Add ByServiceCategory rule with DNS selected",
        "Add ByTag rule with a tag assigned to a DNS host",
        "Verify the DNS host appears in the service category group (first rule wins)",
        "Reorder: move the ByTag rule above ByServiceCategory",
        "Rebuild topology",
        "Verify the DNS host now appears in the tag group (first rule wins)"
      ],
      "setup": "Create a tag and assign it to a host that also runs a DNS service",
      "expected": "Node appears in whichever group's rule is listed first. Helptext explains priority order.",
      "flow": "setup",
      "sequence": 5,
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
      "expected": "Service category group header shows 'Infrastructure: DNS, ReverseProxy'. Tag group header shows 'Tag1, Tag2' (just the tag names, no prefix since no custom title).",
      "status": null,
      "feedback": null
    }
  ]
}
];
