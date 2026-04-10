var TEST_PLANS = [
{
  "branch": "refactor/entity-naming",
  "tests": [
    {
      "id": "host-ip-addresses-tab",
      "category": "IP Address Management",
      "description": "Verify IP Addresses tab works in host editor",
      "steps": [
        "Open a host with IP addresses in the edit modal",
        "Navigate to the 'IP Addresses' tab",
        "Verify IP addresses are listed with correct data",
        "Select an IP address to view its config panel"
      ],
      "expected": "IP addresses display correctly with subnet, IP, MAC data. Tab is labeled 'IP Addresses'.",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "host-interfaces-tab",
      "category": "Interface Management",
      "description": "Verify Interfaces tab (SNMP data) works in host editor",
      "steps": [
        "Open a host that has SNMP interface data in the edit modal",
        "Navigate to the 'Interfaces' tab (only visible for existing hosts)",
        "Verify SNMP interfaces are listed with if_descr, status, MAC",
        "Select an interface to view its details card"
      ],
      "setup": "Ensure at least one host has SNMP interface data (run an SNMP discovery scan).",
      "expected": "SNMP interfaces display correctly with operational status, speed, LLDP/CDP neighbor data. Tab is labeled 'Interfaces'.",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "topology-l2-interfaces",
      "category": "Topology Visualization",
      "description": "Verify L2 Physical view shows Interface elements (was Port/IfEntry)",
      "steps": [
        "Navigate to topology view",
        "Switch to L2 Physical perspective",
        "Click on a physical link between two devices",
        "Verify the inspector shows interface details"
      ],
      "setup": "Ensure SNMP discovery has run and L2 physical links exist.",
      "expected": "L2 view shows Interface elements with correct SNMP data. Inspector displays interface details card.",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "topology-l3-ip-addresses",
      "category": "Topology Visualization",
      "description": "Verify L3 Logical view shows IPAddress elements (was Interface)",
      "steps": [
        "Navigate to topology view",
        "Switch to L3 Logical perspective",
        "Click on a host's IP address element in the topology",
        "Verify the inspector shows IP address details"
      ],
      "expected": "L3 view shows IPAddress elements correctly grouped by subnet. Inspector shows IP address data.",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    },
    {
      "id": "service-bindings-ip-address",
      "category": "Service Bindings",
      "description": "Verify service bindings reference IP addresses correctly",
      "steps": [
        "Open a service that has IP address bindings",
        "Verify binding displays show 'IP Address' type correctly",
        "Edit a binding and verify the IP address selector works",
        "Verify 'All IP Addresses' option works for port bindings"
      ],
      "expected": "Bindings display and edit correctly with IPAddress terminology.",
      "flow": "setup",
      "sequence": 5,
      "status": null,
      "feedback": null
    },
    {
      "id": "host-card-display",
      "category": "Host Display",
      "description": "Verify host cards show both IP Addresses and Interfaces sections",
      "steps": [
        "Navigate to the hosts list",
        "Find a host with both IP addresses and SNMP interfaces",
        "Expand the host card",
        "Verify separate 'IP Addresses' and 'Interfaces' sections exist"
      ],
      "setup": "Ensure at least one host has both IP addresses and SNMP interface data.",
      "expected": "Host card shows IP Addresses section with IPs and Interfaces section with SNMP data. Both sections are separate.",
      "flow": "setup",
      "sequence": 6,
      "status": null,
      "feedback": null
    },
    {
      "id": "api-paths-correct",
      "category": "API",
      "description": "Verify API paths are renamed correctly",
      "steps": [
        "Open browser dev tools network tab",
        "Navigate through the app to trigger API calls",
        "Verify /api/v1/ip-addresses is called for IP address data",
        "Verify /api/v1/interfaces is called for SNMP interface data"
      ],
      "expected": "API calls use the new paths. No 404s from old paths.",
      "flow": "setup",
      "sequence": 7,
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "fix/topology-view-persist",
  "tests": []
}
,
{
  "branch": "feat/app-irrelevant-category-group",
  "tests": [
    {
      "id": "infra-services-grouped",
      "category": "Infrastructure Grouping",
      "description": "Irrelevant categories are grouped into Infrastructure Services container",
      "steps": [
        "Open a topology in the Application perspective",
        "Look for a container labeled 'Infrastructure Services' inside host containers"
      ],
      "setup": "Ensure the network has hosts with services in infrastructure categories (DNS, DHCP, NTP, etc.) and application categories (Database, Storage, etc.)",
      "expected": "Infrastructure categories (NetworkCore, NetworkAccess, RemoteAccess, etc.) appear inside an 'Infrastructure Services' subcontainer. Application-relevant services remain outside it.",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "infra-services-collapsed",
      "category": "Infrastructure Grouping",
      "description": "Infrastructure Services container is collapsed by default",
      "steps": [
        "Open a topology in the Application perspective",
        "Observe the Infrastructure Services containers"
      ],
      "expected": "Infrastructure Services containers are collapsed (showing only the header, not expanded with child services visible)",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "infra-services-expandable",
      "category": "Infrastructure Grouping",
      "description": "Infrastructure Services container can be expanded to show grouped services",
      "steps": [
        "Open a topology in the Application perspective",
        "Click on a collapsed Infrastructure Services container to expand it"
      ],
      "expected": "Container expands to reveal the individual infrastructure services inside",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "infra-services-user-editable",
      "category": "Infrastructure Grouping",
      "description": "ByServiceCategory rule is user-editable (can be removed)",
      "steps": [
        "Open the topology options panel",
        "Navigate to the element rules / grouping section",
        "Attempt to remove the ByServiceCategory rule"
      ],
      "expected": "The rule can be removed by the user (not locked/greyed out)",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    },
    {
      "id": "infra-services-use-case-aware",
      "category": "Use Case Awareness",
      "description": "Different org use cases result in different categories being grouped",
      "steps": [
        "Open Application perspective for an org with 'homelab' use case",
        "Note which categories are in the Infrastructure Services container",
        "Switch to or create an org with 'msp' use case",
        "Note which categories are in the Infrastructure Services container"
      ],
      "setup": "Have two organizations with different use cases (e.g., homelab and msp). Both should have services in NetworkAppliance category.",
      "expected": "For homelab, NetworkAppliance services are grouped into Infrastructure Services. For MSP, NetworkAppliance services are NOT in Infrastructure Services (since they're application-relevant for MSPs).",
      "status": null,
      "feedback": null
    },
    {
      "id": "infra-services-first-match-wins",
      "category": "Rule Composition",
      "description": "Services claimed by ByTag or ByStack are not re-grouped into Infrastructure Services",
      "steps": [
        "Open Application perspective",
        "Verify that services in a tag group or stack group remain in their group even if their category is irrelevant"
      ],
      "setup": "Create a tag and assign it to a service whose category is infrastructure-irrelevant (e.g., a DNS service). Configure ByTag rule with that tag.",
      "expected": "The tagged DNS service appears in its tag group, not in Infrastructure Services",
      "flow": "setup",
      "sequence": 5,
      "status": null,
      "feedback": null
    },
    {
      "id": "categories-no-longer-hidden",
      "category": "Category Hiding Removal",
      "description": "Infrastructure categories are no longer hidden in Application view — they're grouped instead",
      "steps": [
        "Open Application perspective",
        "Check that services from previously-hidden categories (DNS, DHCP, etc.) are visible inside the collapsed Infrastructure Services container, not completely hidden"
      ],
      "expected": "No categories are hidden in Application view except OpenPorts. Infrastructure categories appear inside the collapsed subcontainer.",
      "flow": "setup",
      "sequence": 6,
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "refactor/shares-modal",
  "tests": []
}
,
{
  "branch": "feat/vlan-entity",
  "tests": []
}
,
{
  "branch": "fix/topo-visual-consistency",
  "tests": [
    {
      "id": "collapsed-edge-handles-match-expanded",
      "category": "Collapsed Edge Handles",
      "description": "Collapsed subcontainer edges use same handle directions as expanded child elements",
      "steps": [
        "Open a topology with multiple containers that have cross-container edges",
        "Note the handle directions (left/right/top/bottom) on edges between elements in different containers",
        "Collapse one of the containers",
        "Observe the aggregated edge handle directions on the collapsed container"
      ],
      "setup": "Ensure a topology exists with at least 2 containers and cross-container edges between their child elements.",
      "expected": "The collapsed container's aggregated edge handles should use the same direction (e.g., left side) as the original element edges.",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "collapsed-edge-handles-multiple-directions",
      "category": "Collapsed Edge Handles",
      "description": "When original edges have mixed directions, each aggregated edge keeps its original direction",
      "steps": [
        "Open a topology where a container has child elements with edges going in different directions (some left, some bottom)",
        "Collapse the container",
        "Check the aggregated edge handle directions"
      ],
      "setup": "Ensure a topology with a container whose children have edges in at least 2 different handle directions.",
      "expected": "Each aggregated edge should keep the handle direction of its original element edge.",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "tag-hide-fade-application-services",
      "category": "Tag Hide Consistency",
      "description": "Tag-hidden services in Application perspective fade instead of disappearing",
      "steps": [
        "Open topology in Application perspective",
        "Apply a tag filter that hides some services",
        "Observe the filtered service elements"
      ],
      "setup": "Ensure services have tags. Application perspective should show service elements.",
      "expected": "Hidden service elements should fade to 30% opacity but remain visible.",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "tag-hide-containers-also-fade",
      "category": "Tag Hide Consistency",
      "description": "Containers with hidden tags also fade consistently, including subcontainers and their children",
      "steps": [
        "Open topology in L3 perspective",
        "Apply a tag filter that hides a subnet container that has subcontainers",
        "Observe the container, subcontainers, and child elements"
      ],
      "expected": "Container, subcontainers, and all descendant elements should all fade to 30% opacity.",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "feat/topology-url-params",
  "tests": []
}
,
{
  "branch": "fix/edge-label-deselect",
  "tests": []
}
];
