var TEST_PLANS = [
{
  "branch": "feat/application-builder",
  "tests": [
    {
      "id": "application-perspective-request-path-edges",
      "category": "Application Perspective",
      "description": "Request path dependency edges connect services in order",
      "steps": [
        "In the Application perspective, verify that request path group edges are visible between service nodes",
        "Verify edges follow the order defined in the group (e.g., Nginx → App → Database)"
      ],
      "setup": "Create a RequestPath group with bindings from 3 different services (e.g., Nginx binding → App binding → Database binding). Each service must have at least one binding.",
      "expected": "Edges connect service nodes in chain order (Nginx→App, App→Database). Edges are displayed as primary edges with arrows.",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "application-perspective-hub-spoke-edges",
      "category": "Application Perspective",
      "description": "Hub and spoke dependency edges connect hub to spokes",
      "steps": [
        "In the Application perspective, verify that hub-and-spoke group edges are visible",
        "Verify the first service in the group acts as the hub with edges to all other services"
      ],
      "setup": "Create a HubAndSpoke group with bindings from 3 services (e.g., Load Balancer, App1, App2). The first binding's service should be the hub.",
      "expected": "Hub service has edges to each spoke service. No edges between spokes.",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "application-perspective-no-unbound-services",
      "category": "Application Perspective",
      "description": "Services without bindings are excluded from the topology",
      "steps": [
        "In the Application perspective, verify that services without any bindings do not appear as nodes"
      ],
      "setup": "Ensure at least one service exists without any bindings alongside services that have bindings.",
      "expected": "Only services with bindings appear in the topology. The unbound service is not shown.",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    },
    {
      "id": "application-perspective-docker-virtualization-edges",
      "category": "Application Perspective",
      "description": "Docker virtualization edges show containerization relationships",
      "steps": [
        "In the Application perspective, verify that dashed edges connect Docker engine services to their containerized services"
      ],
      "setup": "Ensure a host has a Docker service that containerizes other services (e.g., Docker → Nginx, Docker → Redis). All services must have bindings.",
      "expected": "ServiceVirtualization edges (dashed) connect the Docker service to each containerized service.",
      "flow": "setup",
      "sequence": 5,
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "refactor/topology-perspective-frontend",
  "tests": [
    {
      "id": "l3-topology-unchanged",
      "category": "Visual Regression",
      "description": "L3 topology renders identically after refactoring",
      "steps": [
        "Navigate to the topology page",
        "Select a network with hosts/subnets",
        "Verify the topology renders with correct node positions, edge routing, and container layout",
        "Toggle edge visibility options (e.g., hide/show HostVirtualization edges)",
        "Collapse and expand containers",
        "Verify minimap, controls, and zoom work correctly"
      ],
      "setup": "Ensure at least one network has a topology with multiple subnets, hosts, and edges.",
      "expected": "Topology should render identically to before the refactoring. No visual differences in node placement, edge routing, container sizing, or UI controls.",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "options-persist-across-sessions",
      "category": "Options Store",
      "description": "Topology options persist in localStorage and survive page reload",
      "steps": [
        "Open the topology options panel",
        "Toggle some options (e.g., hide minimap, change edge visibility, add/remove a grouping rule)",
        "Refresh the page",
        "Open the options panel again"
      ],
      "expected": "All toggled options should be preserved after page reload.",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "localstorage-migration",
      "category": "Options Store",
      "description": "Existing flat localStorage options migrate to per-perspective format",
      "steps": [
        "Navigate to the topology page",
        "Open browser DevTools > Application > Local Storage",
        "Check the value of scanopy_topology_options"
      ],
      "setup": "Before navigating, manually set localStorage key 'scanopy_topology_options' to a flat TopologyOptions JSON object (e.g., {\"local\":{\"hide_edge_types\":[\"RequestPath\"],\"no_fade_edges\":true,\"hide_resize_handles\":false,\"bundle_edges\":true,\"show_minimap\":false},\"request\":{\"hide_ports\":false,\"hide_vm_title_on_docker_container\":false,\"hide_service_categories\":[\"OpenPorts\"],\"container_rules\":[],\"element_rules\":[]}})",
      "expected": "After page load, the localStorage value should be a per-perspective object with 'l2_physical', 'l3_logical', 'infrastructure', 'application' keys. The l3_logical entry should contain the migrated flat options (e.g., no_fade_edges: true, show_minimap: false). Other perspectives should have default values.",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "grouping-rules-available",
      "category": "Grouping Rules",
      "description": "All grouping rules are available in L3 perspective",
      "steps": [
        "Open the topology options panel",
        "In Container Grouping, click the add button",
        "Verify BySubnet and ByVirtualizingService are available (if not already added)",
        "In Element Grouping, click the add button",
        "Verify ByServiceCategory and ByTag are available"
      ],
      "expected": "All container and element rule types should be visible for the L3 perspective. No rules should be filtered out.",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    },
    {
      "id": "option-toggles-work",
      "category": "Options Panel",
      "description": "Option toggles (edge types, categories, tags) function correctly",
      "steps": [
        "Open the topology options panel",
        "Toggle edge type visibility (e.g., show PhysicalLink edges)",
        "Toggle a service category visibility",
        "Toggle bundle edges on/off",
        "Toggle minimap on/off"
      ],
      "expected": "Each toggle should take effect immediately on the topology visualization. Edge visibility, category visibility, bundling, and minimap all respond to changes.",
      "flow": "setup",
      "sequence": 5,
      "status": null,
      "feedback": null
    },
    {
      "id": "reset-options",
      "category": "Options Store",
      "description": "Reset options restores all defaults",
      "steps": [
        "Open topology options panel",
        "Change several options",
        "Trigger options reset (if reset button exists in UI)",
        "Verify options return to defaults"
      ],
      "expected": "All options should return to their default values for all perspectives.",
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "refactor/topology-perspective-backend",
  "tests": [
    {
      "id": "l3-topology-unchanged",
      "category": "Topology Rendering",
      "description": "L3 topology renders identically after refactoring",
      "steps": [
        "Navigate to a network with discovered hosts and services",
        "Open the topology view",
        "Verify all subnet containers, element nodes, and edges render correctly",
        "Verify nested group containers (service category groups) appear correctly",
        "Verify Docker bridge consolidation works if applicable"
      ],
      "expected": "Topology looks identical to before the refactor — same nodes, edges, containers, and layout",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "rebuild-preserves-edge-handles",
      "category": "Handle Preservation",
      "description": "Edge handles are preserved when rebuilding with same perspective",
      "steps": [
        "Open topology view",
        "Drag an edge handle to a different connection point on a node",
        "Trigger a topology rebuild (e.g., refresh or modify options)",
        "Verify the edge handle position is preserved after rebuild"
      ],
      "expected": "Edge handles remain at the user-edited positions after rebuild",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "grouping-rules-metadata-perspectives",
      "category": "Grouping Rules",
      "description": "Rule metadata endpoint includes perspectives field",
      "steps": [
        "Open the topology rule configuration UI (grouping rules panel)",
        "Inspect the rule metadata (via browser devtools network tab or UI display)"
      ],
      "setup": "Ensure the topology metadata endpoint is accessible. Check the response payload for container and element rule metadata.",
      "expected": "Each rule's metadata JSON includes a 'perspectives' array listing applicable perspectives",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "feat/service-flow-rework",
  "tests": [
    {
      "id": "dependencies-tab-loads",
      "category": "Dependencies Tab",
      "description": "Dependencies tab renders correctly with renamed labels",
      "steps": [
        "Navigate to the Dependencies tab in the sidebar",
        "Verify the tab header says 'Dependencies' not 'Groups'",
        "Verify the subtitle text references dependencies"
      ],
      "expected": "Tab loads with 'Dependencies' title and correct subtitle text",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "dependency-create-modal",
      "category": "Dependencies Tab",
      "description": "Create Dependency modal opens and has renamed labels",
      "steps": [
        "Click 'Create' button on Dependencies tab",
        "Verify modal title says 'Create Dependency'",
        "Verify the type selector says 'Dependency Type' not 'Group Type'",
        "Verify the name field label says 'Dependency Name'",
        "Navigate through all wizard steps (Details, Service Bindings, Edge Appearance)"
      ],
      "expected": "All modal labels use 'Dependency' terminology, wizard steps work correctly",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "dependency-card-display",
      "category": "Dependencies Tab",
      "description": "Dependency cards display correctly with renamed type labels",
      "steps": [
        "View existing dependencies in the Dependencies tab",
        "Verify cards show 'Dependency Type' label (not 'Group Type')",
        "Verify service members are displayed correctly"
      ],
      "setup": "Create at least one dependency with services via the API",
      "expected": "Cards render with correct dependency terminology and show service members",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "topology-dependency-edges",
      "category": "Topology",
      "description": "Dependency edges render correctly on topology view",
      "steps": [
        "Navigate to the Topology tab",
        "Verify dependency edges are visible (if dependencies exist)",
        "Click on a dependency edge to open the inspector",
        "Verify inspector shows 'Dependency' label (not 'Group')"
      ],
      "setup": "Create a dependency with at least 2 service members and rebuild topology",
      "expected": "Dependency edges render and inspector shows correct terminology",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    },
    {
      "id": "topology-multiselect-create-dependency",
      "category": "Topology",
      "description": "Multi-select action bar allows creating dependencies",
      "steps": [
        "Select multiple nodes on the topology",
        "Verify the action bar shows 'Create Dependency' button (not 'Create Group')",
        "Click 'Create Dependency' and fill in the name",
        "Confirm creation"
      ],
      "setup": "Ensure topology has at least 2 hosts with services",
      "expected": "Dependency is created successfully from multi-select, button labels say 'Dependency'",
      "flow": "setup",
      "sequence": 5,
      "status": null,
      "feedback": null
    },
    {
      "id": "sidebar-dependencies-navigation",
      "category": "Navigation",
      "description": "Sidebar shows 'Dependencies' tab with correct icon and navigation",
      "steps": [
        "Look at the sidebar navigation",
        "Verify 'Dependencies' appears as a tab (not 'Groups')",
        "Click the Dependencies tab",
        "Verify it navigates to the dependencies view"
      ],
      "expected": "Sidebar shows 'Dependencies' label and navigates correctly",
      "status": null,
      "feedback": null
    },
    {
      "id": "feature-nudge-dependency",
      "category": "Home",
      "description": "Feature nudge for dependency creation uses correct labels",
      "steps": [
        "Navigate to the Home tab",
        "If the dependency creation nudge is visible, verify it says 'Create a Dependency' (not 'Create a Group')",
        "Click the nudge action button",
        "Verify it navigates to dependencies tab and opens the editor"
      ],
      "setup": "Ensure a topology has been rebuilt but no dependency has been created yet (FirstDependencyCreated onboarding step not completed)",
      "expected": "Nudge shows 'Dependency' terminology and navigates to dependency editor",
      "status": null,
      "feedback": null
    },
    {
      "id": "api-endpoint-dependencies",
      "category": "API",
      "description": "API calls use /api/v1/dependencies endpoint",
      "steps": [
        "Open browser dev tools Network tab",
        "Navigate to Dependencies tab",
        "Observe the API request URLs"
      ],
      "expected": "All API calls go to /api/v1/dependencies, not /api/v1/groups",
      "status": null,
      "feedback": null
    },
    {
      "id": "existing-dependencies-backward-compat",
      "category": "Backward Compatibility",
      "description": "Existing dependencies (migrated from groups) still load correctly",
      "steps": [
        "Navigate to Dependencies tab",
        "View existing dependencies that were migrated from groups",
        "Open one for editing"
      ],
      "setup": "Run the migration on a database with existing groups that have binding_ids. The migration backfills service_id and sets member_type to 'Bindings'.",
      "expected": "Migrated dependencies display correctly with their binding members intact and can be edited",
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "fix/session-rehydration",
  "tests": [
    {
      "id": "discovery-card-after-restart",
      "category": "Session Rehydration",
      "description": "Discovery card shows session progress after server restart",
      "steps": [
        "Navigate to the Discovery page",
        "Start a discovery session on any configured discovery",
        "Wait until the Discovery card shows scanning progress (phase: Scanning, progress > 0%)",
        "Restart the server process",
        "Return to the Discovery page after server is back up",
        "Observe the Discovery card for the same discovery"
      ],
      "setup": "Ensure at least one discovery is configured with a daemon connected and a scannable network.",
      "expected": "The Discovery card should show the active session progress (phase, percentage) after the server restarts and the daemon sends its next update.",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "duplicate-session-blocked-after-restart",
      "category": "Session Rehydration",
      "description": "Cannot start a duplicate session after server restart",
      "steps": [
        "Navigate to the Discovery page",
        "Start a discovery session",
        "Wait until the session is actively scanning",
        "Restart the server process",
        "Wait for the Discovery card to show the active session again",
        "Try to start another session for the same discovery"
      ],
      "setup": "Ensure at least one discovery is configured with a daemon connected and a scannable network.",
      "expected": "The server should reject the second session start with a conflict error ('A session is already running for this discovery').",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "homepage-active-discoveries-after-restart",
      "category": "Session Rehydration",
      "description": "Homepage active discoveries widget works after server restart",
      "steps": [
        "Start a discovery session",
        "Wait until actively scanning",
        "Restart the server process",
        "Navigate to the homepage after server is back up"
      ],
      "setup": "Ensure at least one discovery is configured with a daemon connected.",
      "expected": "The ActiveDiscoveries widget on the homepage should show the in-progress discovery session.",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "fix/l3-ui-bugs",
  "tests": []
}
,
{
  "branch": "feat/perspective-selector",
  "tests": []
}
];
