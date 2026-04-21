var TEST_PLANS = [
{
  "branch": "fix/topology-overlap-during-discovery",
  "tests": [
    {
      "id": "discovery-sse-no-overlap",
      "category": "Discovery + topology layout",
      "description": "Newly-discovered hosts arriving via SSE during an active discovery session do not overlap existing host cards.",
      "setup": "Open the app against a dev backend. Select a network with an expanded LAN container that contains at least 8 existing hosts. Kick off a discovery run that will add 4+ new hosts to that LAN (e.g. via the Discovery tab — start a new SNMP/SSH/etc. discovery against a range known to contain more hosts than are currently in the topology).",
      "steps": [
        "Navigate to the topology view with the target LAN container visible and expanded.",
        "Verify the existing hosts are laid out cleanly (no overlaps).",
        "Trigger the discovery run.",
        "Watch the LAN container as new host cards fade in over the course of the session.",
        "After each batch of new cards appears, scan the LAN for any overlapping cards (one card drawn on top of or bleeding into another)."
      ],
      "expected": "No overlaps at any point. New cards fade in, existing cards shift to make room, and every card has its own non-overlapping bounding box. If a brief overlap ever appears mid-animation, it self-corrects within one additional layout pass (<1s) without user action.",
      "flow": "setup",
      "sequence": 1,
      "status": null,
      "feedback": null
    },
    {
      "id": "rebuild-clears-overlap",
      "category": "Discovery + topology layout",
      "description": "If an overlap somehow appears during discovery, the Rebuild button clears it (previously it did not).",
      "setup": "If test 1 passes cleanly, this test can be performed by reverting only the cacheCollapsedSizes-in-animation-branch part of the fix locally and re-running discovery until an overlap appears. Otherwise: skip if no overlap can be reproduced.",
      "steps": [
        "With an overlap visible in the topology, click the Rebuild button in the topology toolbar.",
        "Wait for the rebuild to complete (SSE-delivered update repaints the topology)."
      ],
      "expected": "After rebuild, the overlap is gone. All cards have their own non-overlapping bounding box. Hard browser reload is not needed.",
      "flow": "setup",
      "sequence": 2,
      "status": null,
      "feedback": null
    },
    {
      "id": "collapse-expand-animation-intact",
      "category": "Topology animation",
      "description": "The collapse/expand fade animation still plays smoothly — no regression from the animation-path refactor.",
      "setup": "Open the topology view with a mix of expanded and collapsed containers (e.g. several LANs, at least one with expanded subgroups).",
      "steps": [
        "Click a container's collapse chevron to collapse it. Observe the transition.",
        "Click again to expand it. Observe the transition.",
        "Repeat on a nested subgroup.",
        "Do the same while a discovery session is actively streaming SSE updates."
      ],
      "expected": "Collapse/expand animates smoothly (width/height transition, new children fade in on expand). No jitter, no jump to (0,0), no overlap after the animation settles. Behavior during an active discovery session is the same as when idle.",
      "flow": "setup",
      "sequence": 3,
      "status": null,
      "feedback": null
    },
    {
      "id": "view-switch-during-discovery",
      "category": "Topology views",
      "description": "Switching between topology perspectives (L2Physical, Workloads, Application, Infrastructure) during an active discovery session remains correct.",
      "setup": "Start a discovery session that streams SSE updates. Use a topology that has data in at least two views.",
      "steps": [
        "On the topology view, switch perspectives via the view switcher (e.g. from the default view to Workloads, then to L2Physical).",
        "Observe the layout after each switch.",
        "Switch back and forth a few times while discovery continues streaming updates."
      ],
      "expected": "Each view lays out cleanly with no overlapping nodes. The viewport fits the content. No flicker or nodes stuck at (0,0).",
      "flow": "setup",
      "sequence": 4,
      "status": null,
      "feedback": null
    },
    {
      "id": "l3-new-service-reflows-siblings",
      "category": "Inline-content re-layout",
      "description": "In L3, adding a new service to an existing host causes the IPAddress card to grow AND its sibling cards to shift to make room — no overlap.",
      "setup": "Open the app against a dev backend on a network that has at least a few hosts with IP addresses laid out in a row inside a LAN container. Have the backend ready to accept a new service for an existing host (via API or a discovery run targeting a port that will add a new service to an existing IP).",
      "steps": [
        "Switch to the L3 Logical view.",
        "Identify an IPAddress element card that has exactly one service row currently rendered and that has at least one sibling card directly below it in the same container column.",
        "Note the visual positions of that card and its immediate siblings.",
        "Trigger the add-service action (API call or discovery run) that causes a second service to appear on the chosen host.",
        "Watch the card — it should grow vertically to accommodate the new service row.",
        "Verify the sibling card below shifts downward so it does not overlap."
      ],
      "expected": "Card grows, siblings reflow cleanly, no overlap. The new service row appears with its port (e.g. '80/tcp').",
      "flow": "setup",
      "sequence": 5,
      "status": null,
      "feedback": null
    },
    {
      "id": "l3-new-port-binding-reflows-siblings",
      "category": "Inline-content re-layout",
      "description": "In L3, a new port binding added to an already-rendered service grows the card's port line; siblings reflow.",
      "setup": "Open L3 view on a network where at least one service on a visible IPAddress element already has a single Port binding. Have the backend ready to add a second Port binding to that service (via API or discovery).",
      "steps": [
        "In L3, locate a service row inside an IPAddress card showing a single port (e.g. '80/tcp').",
        "Note the card's height and its neighbour below.",
        "Trigger the action that adds a second Port binding to that service.",
        "Watch the card — the port line should lengthen (e.g. '80/tcp, 443/tcp'). Depending on width, the card may grow vertically.",
        "Verify neighbouring cards reflow if the card height changes — no overlap."
      ],
      "expected": "Port line updates in place, and if the card grows, siblings reflow to maintain non-overlapping layout.",
      "flow": "setup",
      "sequence": 6,
      "status": null,
      "feedback": null
    },
    {
      "id": "workloads-ports-still-hidden",
      "category": "View-config rendering",
      "description": "Workloads view still does not show ports on any element card (explicit by config now, not accidental).",
      "setup": "Open the app with a topology that has at least one host with services, and open Workloads view.",
      "steps": [
        "Switch to Workloads view.",
        "Inspect each Service element card and each Host element card (if any VMs are rendered as Host elements inside hypervisor containers).",
        "Confirm no port line ('80/tcp'-style text) is visible on any card."
      ],
      "expected": "No port rendering in Workloads. Services render on Host cards (where applicable); service names render on Service cards. `hide_ports` toggle state does not matter — ports are gated off by view config regardless.",
      "flow": "setup",
      "sequence": 7,
      "status": null,
      "feedback": null
    },
    {
      "id": "filters-and-inspector-unchanged",
      "category": "View-config rendering",
      "description": "Filter chips in the options panel, and the element-summary inspector, render correctly under the new per-element inline config.",
      "setup": "Open the topology view in each of L3 Logical, L2 Physical, Workloads, and Application.",
      "steps": [
        "In each view, open the options panel and confirm the filter chips (Host / Service / Subnet, as applicable) appear as before.",
        "Select an element node in each view. Confirm the element-summary inspector lists entity counts for the correct entity types: L3 IPAddress should list both Services and Ports; Workloads Host (if available) should list Services; Workloads Service should list only Service-level stats; Application Service similarly."
      ],
      "expected": "Filter chips unchanged across all views. Element-summary inspector surfaces the correct entity types per element, including Ports in L3 IPAddress inspectors (new).",
      "flow": "setup",
      "sequence": 8,
      "status": null,
      "feedback": null
    }
  ]
}
,
{
  "branch": "fix/free-plan-visibility",
  "tests": []
}
,
{
  "branch": "fix/limit-create-buttons-visible",
  "tests": []
}
,
{
  "branch": "feat/org-deletion-flow",
  "tests": []
}
,
{
  "branch": "fix/daemon-volume-path",
  "tests": []
}
,
{
  "branch": "fix/openapi-tag-descriptions",
  "tests": []
}
,
{
  "branch": "chore/migration-safety-guardrails",
  "tests": []
}
,
{
  "branch": "feat/share-access-tokens",
  "tests": []
}
,
{
  "branch": "fix/crypto-random-uuid-http",
  "tests": []
}
,
{
  "branch": "fix/topology-defaults",
  "tests": []
}
,
{
  "branch": "fix/container-summary-counts",
  "tests": []
}
,
{
  "branch": "fix/shares-modal-create-flow",
  "tests": []
}
];
