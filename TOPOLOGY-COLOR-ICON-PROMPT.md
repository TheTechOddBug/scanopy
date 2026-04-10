# Topology: Color, Icon & Infrastructure→Compute Rename

## Your Role

You are implementing a color/icon update and perspective rename across the concept and entity metadata systems. The decisions are made — apply them.

## Background

Read the project instructions: `/Users/maya/dev/scanopy/CLAUDE.md`

The color/icon system works through two files:
- **Concepts:** `backend/src/server/shared/concepts.rs` — abstract semantic anchors that provide color/icon to related domain types via `EntityMetadataProvider`
- **Entities:** `backend/src/server/shared/entities.rs` — concrete entity types with their own color/icon via `EntityMetadataProvider`

After updating the backend, run `make generate-types` to propagate to the frontend, then update the fixture files in `ui/src/lib/data/` to match.

## Design rationale (for context, not implementation)

Each perspective owns a color family. Entities primary to that perspective use colors from the family, gradient from deep (higher hierarchy) to light (detail level):

| Perspective | Primary color | Entity gradient (deep → light) |
|---|---|---|
| L3 (Blue) | Blue | Vlan=Violet → Subnet=Indigo → IPAddress=Blue → Port=Sky → Binding=Cyan |
| L2 (Green) | Green | Interface=Teal |
| Application (Purple) | Purple | Service=Fuchsia → Dependency=Rose |
| Compute (Orange) | Orange | Host=Amber |

Entity colors are consistent everywhere — a Host is always Amber whether it's an element in Compute or a container in L2. Perspective color shows up in tabs/chrome, not on entities.

Entity variant colors (SubnetType variants, ServiceCategory variants, ApplicationGroup tag colors) remain independent for maximum contrast within a perspective.

---

## Changes to apply

### 1. Perspective rename: Infrastructure → Compute

Rename everywhere:
- `Concept::Infrastructure` → `Concept::Compute`
- `TopologyPerspective::Infrastructure` → `TopologyPerspective::Compute`
- All PerspectiveBuilder references (InfrastructureBuilder → ComputeBuilder, or whatever the current name is)
- All `applicable_perspectives()` returns that reference Infrastructure
- Frontend perspective selector labels, component names, file names
- i18n keys in `messages/en.json`
- Any test files referencing Infrastructure

### 2. New concepts to add

Add these new variants to the `Concept` enum:

| Concept | Color | Icon |
|---|---|---|
| Workloads | Amber | Boxes |
| Containerization | Fuchsia | Container |

### 3. Split Virtualization concept

The existing `Concept::Virtualization` now covers only hardware virtualization (Proxmox, VMware — HostVirtualization). Docker/Podman/K8s containerization is covered by the new `Concept::Containerization`.

Update references:
- Anywhere `Concept::Virtualization` is used for Docker/ServiceVirtualization → change to `Concept::Containerization`
- `Concept::Virtualization` stays for HostVirtualization, Proxmox, VMware references

### 4. Concept color/icon updates

Apply to `EntityMetadataProvider for Concept` in `concepts.rs`:

| Concept | Color | Icon |
|---|---|---|
| L2 | Green | Cable |
| L3 | Blue | Globe |
| Application | Purple | Workflow |
| Compute (was Infrastructure) | Orange | Cpu |
| Virtualization | Orange | MonitorCog |
| Containerization (new) | Fuchsia | Container |
| Workloads (new) | Amber | Boxes |
| DNS | Emerald | Search |
| VPN | Green | VenetianMask |
| Gateway | Teal | Router |
| ReverseProxy | Cyan | Split |
| IoT | Yellow | CircuitBoard |
| Storage | Green | HardDrive |
| SNMP | Pink | Activity |

### 5. Entity color/icon updates

Apply to `EntityMetadataProvider for EntityDiscriminants` in `entities.rs`. Only network asset entities are changing:

| Entity | Color | Icon |
|---|---|---|
| Host | Amber | Server |
| Service | Fuchsia | Layers |
| IPAddress | Blue | MapPin |
| Port | Sky | EthernetPort |
| Interface | Teal | Cable |
| Subnet | Indigo | Network |
| Vlan | Violet | CircleDashed |
| Dependency | Rose | Waypoints |
| Binding | Cyan | Link |

All other entities (Organization, User, Tag, Credential, etc.) are unchanged.

### 6. New Color and Icon enum variants

Check that these exist in the Color and Icon enums. Add any that are missing:

**Colors needed:** Blue, Green, Purple, Orange, Indigo, Emerald, Teal, Cyan, Sky, Fuchsia, Rose, Violet, Amber, Yellow, Pink, Gray, Lime

**Icons needed:** Globe, Workflow, Cpu, MonitorCog, Container, Boxes, CircuitBoard, MapPin, CircleDashed, EthernetPort (plus all existing icons that aren't changing)

### 7. Frontend: Host virtualization tab rename

The host modal has a tab currently called "Virtualization" that shows both Proxmox VMs and Docker containers. Rename this tab to **"Workloads"** — it covers both virtualization and containerization. Update the i18n key.

---

## Steps

1. Add missing Color and Icon enum variants
2. Add new Concept variants (Workloads, Containerization)
3. Update `concepts.rs` — rename Infrastructure to Compute, split Virtualization/Containerization, apply all color/icon changes
4. Update `entities.rs` — apply all entity color/icon changes
5. Rename Infrastructure → Compute across the entire codebase (TopologyPerspective, builders, applicable_perspectives, frontend components, file names)
6. Split Virtualization references — Docker/ServiceVirtualization → Containerization concept, Proxmox/HostVirtualization → Virtualization concept
7. Rename host modal "Virtualization" tab → "Workloads"
8. `make generate-types`
9. Update frontend fixture files (`concepts.json`, entity type JSONs in `ui/src/lib/data/`)
10. Update all i18n keys in `messages/en.json`
11. `cd backend && cargo test --lib` and `cd ui && npm test`
12. `make format && make lint`
