var TEST_PLANS = [
{
  "branch": "feat/topology-edge-classification",
  "tests": []
}
,
{
  "branch": "feat/topology-grouping-backend",
  "tests": [
    {
      "id": "default-topology-loads",
      "category": "Topology Loading",
      "description": "Default topology loads and renders without errors after migration",
      "steps": [
        "Navigate to a topology page",
        "Verify the topology renders with subnets and nodes visible",
        "Check browser console for no deserialization errors"
      ],
      "setup": "Run the DB migration (20260403120000_topology_grouping_rules.sql) against a database with existing topologies.",
      "expected": "Topology renders correctly. No errors in console. Nodes and edges display as before.",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "topology-rebuild-works",
      "category": "Topology Building",
      "description": "Triggering a topology rebuild produces correct graph with new grouping_rules format",
      "steps": [
        "Open a topology page",
        "Click refresh/rebuild button",
        "Verify the topology rebuilds and displays nodes grouped by subnet"
      ],
      "expected": "Topology rebuilds without errors. Nodes appear in correct subnets. Layout looks reasonable.",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "new-topology-default-options",
      "category": "Topology Creation",
      "description": "Creating a new topology uses default grouping_rules (BySubnet, ByVirtualizingService, ByServiceCategory)",
      "steps": [
        "Create a new topology",
        "Verify it builds correctly with default grouping rules"
      ],
      "expected": "New topology has default grouping_rules. Docker bridges are grouped by host. DNS/ReverseProxy services would be grouped if present.",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "migrated-topology-preserves-options",
      "category": "Migration",
      "description": "Migrated topology preserves previous grouping behavior",
      "steps": [
        "Open a topology that existed before migration",
        "Verify docker bridge grouping still works",
        "Verify infrastructure service grouping still works"
      ],
      "setup": "Ensure at least one topology existed before running the migration, ideally one with docker bridges and DNS/ReverseProxy services.",
      "expected": "Previously configured grouping behavior is preserved. Docker bridges still grouped. Infrastructure services still grouped with 'Infrastructure' title.",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "feat/topology-c4-zoom",
  "tests": []
}
,
{
  "branch": "feat/topology-grouping-ui",
  "tests": [
    {
      "id": "docker-left-zone-removed",
      "category": "Options Panel",
      "description": "Docker and Left Zone sections no longer appear in topology options",
      "steps": [
        "Open a topology",
        "Open the options panel",
        "Verify there is no 'Docker' section",
        "Verify there is no 'Left Zone' section",
        "Verify 'Hide VM title on Docker container' toggle is now in the Visual section"
      ],
      "expected": "Docker and Left Zone sections are gone. VM title toggle moved to Visual.",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "grouping-rule-editor-visible",
      "category": "Options Panel",
      "description": "Group by section appears with default rules",
      "steps": [
        "Open a topology",
        "Open the options panel",
        "Look for the 'Group by' collapsible section",
        "Verify it shows a fixed 'Subnet' badge at the top",
        "Verify there are two default rules: Docker bridges and a Service category rule with 'Infrastructure' title"
      ],
      "expected": "Group by section visible with Subnet header and two default editable rules",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "add-service-category-rule",
      "category": "Grouping Rules",
      "description": "Add a ByServiceCategory rule with category selection",
      "steps": [
        "In the Group by section, use the dropdown to select 'Service category'",
        "Verify a new rule appears in the list with a 'Service category' badge",
        "Click on the new rule to expand the category selector",
        "Toggle some service categories on/off",
        "Verify the config summary updates to show selected categories"
      ],
      "expected": "Service category rule added with inline category toggle picker",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "add-tag-rule",
      "category": "Grouping Rules",
      "description": "Add a ByTag rule with tag selection",
      "steps": [
        "In the Group by section, use the dropdown to select 'Tag'",
        "Verify a new rule appears with a 'Tag' badge",
        "Click on the new rule to expand the tag picker",
        "Select one or more tags",
        "Verify the config summary shows selected tag names"
      ],
      "setup": "Ensure at least 2 tags exist in the organization",
      "expected": "Tag rule added with inline tag picker showing selected tag names",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    },
    {
      "id": "add-virtualizing-service-rule",
      "category": "Grouping Rules",
      "description": "Add a ByVirtualizingService rule (no config needed)",
      "steps": [
        "In the Group by section, use the dropdown to select 'Docker bridges'",
        "Verify a new rule appears with a 'Docker bridges' badge",
        "Verify no additional config picker opens (just title input)"
      ],
      "expected": "Docker bridges rule added with no extra configuration UI",
      "flow": "setup",
      "sequence": 5,
      "status": null,
      "feedback": null
    },
    {
      "id": "edit-rule-title",
      "category": "Grouping Rules",
      "description": "Rule titles are editable inline",
      "steps": [
        "Find a rule in the Group by list",
        "Type a custom title in the title text input field",
        "Verify the title is reflected in the rule item"
      ],
      "expected": "Title text input accepts text and updates the rule",
      "flow": "setup",
      "sequence": 6,
      "status": null,
      "feedback": null
    },
    {
      "id": "reorder-rules",
      "category": "Grouping Rules",
      "description": "Rules can be reordered with up/down arrows",
      "steps": [
        "Ensure at least 2 editable rules exist in the list",
        "Click the up arrow on the second rule",
        "Verify it moves above the first rule",
        "Click the down arrow to move it back"
      ],
      "expected": "Rules reorder correctly via arrow buttons",
      "flow": "setup",
      "sequence": 7,
      "status": null,
      "feedback": null
    },
    {
      "id": "remove-rule",
      "category": "Grouping Rules",
      "description": "Rules can be removed with the trash button",
      "steps": [
        "Click the remove (trash) button on a rule",
        "Verify the rule is removed from the list"
      ],
      "expected": "Rule removed from the list",
      "flow": "setup",
      "sequence": 8,
      "status": null,
      "feedback": null
    },
    {
      "id": "infra-gradient-removed",
      "category": "Container Rendering",
      "description": "Infrastructure zone gradient no longer appears on subnet containers",
      "steps": [
        "Open a topology that previously showed an infrastructure gradient on subnets",
        "Verify no gradient background or 'Infrastructure' title overlay appears on any subnet container"
      ],
      "expected": "Subnet containers render with plain background, no gradient",
      "status": null,
      "feedback": null
    },
    {
      "id": "inspector-no-old-toggles",
      "category": "Inspector Panel",
      "description": "Container inspector no longer shows deprecated option toggles",
      "steps": [
        "Click on a subnet container in the topology",
        "Verify the inspector panel does not show 'Show gateways in left zone' toggle",
        "Verify no 'Group Docker Bridges' toggle appears"
      ],
      "expected": "Inspector shows subnet info without the old toggle options",
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "feat/topology-elkjs-layout",
  "tests": [
    {
      "id": "overlay-edge-styling",
      "category": "Overlay Edges",
      "description": "Visible overlay edges have distinct visual styling from primary edges",
      "steps": [
        "Navigate to the topology page",
        "Enable all edge types in the options panel",
        "Compare the visual appearance of Interface edges vs overlay edges (e.g., HostVirtualization)"
      ],
      "expected": "Interface edges should be solid, 2px width, full opacity. Overlay edges should be dashed (4 4 pattern), 1.5px width, and ~50% opacity when not hovered/selected.",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "node-dragging-works",
      "category": "Interaction",
      "description": "Node dragging still works after elkjs layout and position is saved",
      "steps": [
        "Navigate to the topology page",
        "Click and drag a host/interface node to a new position",
        "Release the node",
        "Refresh the page and verify the node is in the dragged position"
      ],
      "expected": "The node should move smoothly to the new position. After refresh, the node position should be persisted (not reset to elkjs-computed position).",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "feat/topology-edge-bundling",
  "tests": []
}
];
