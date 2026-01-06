> **First:** Read `CLAUDE.md` (project instructions) — you are a **worker**.

# Task: Investigate Discovery Duplicate Entity Bug (#425, #426)

## Objective

Exhaustively investigate why Docker discovery creates duplicate entities (interfaces, ports, services) that should be deduplicated. Propose the root cause with evidence.

## Issues

### Issue #426: Interface/Bridge Duplicates
- Docker bridges and interfaces being rediscovered as new entries
- Same IP (`172.18.0.2`), same MAC (`6A:70:CD:AF:DC:D3`), same name (`garage`)
- But different interface IDs and different subnet IDs
- Violates documented "upsert behavior"

### Issue #425: Port Duplicates
- Ports that were manually assigned to services get rediscovered as "Unclaimed"
- Creates duplicate port entries with conflicting states
- Warnings during discovery about duplicate ports/services being dropped
- Interfaces show identical IP/MAC but different internal IDs

**Both issues:**
- First appeared in v0.12.8
- Involve Docker discovery
- Create duplicates despite identical identifying properties

## Investigation Requirements

**This is an investigation task, not an implementation task.** Your deliverable is a root cause analysis, not a fix.

### Phase 1: Understand the Discovery Flow

Trace the complete end-to-end flow. Document your findings as you go.

1. **Discovery initiation**
   - Where does Docker discovery start?
   - What parameters/context does it receive?

2. **Interface enumeration**
   - How are Docker interfaces discovered?
   - What identifies an interface as "the same" (IP? MAC? name? combination?)

3. **Entity creation/upsert logic**
   - Where is the deduplication logic?
   - What fields are used for matching existing entities?
   - Is there a sync method for interfaces like there is for other entities?

4. **Subnet association**
   - How are interfaces associated with subnets?
   - Could different subnet IDs cause the same interface to appear as "new"?

5. **Port/service assignment**
   - How are ports associated with interfaces?
   - What happens to port assignments when interface IDs change?

### Phase 2: Identify the Failure Point

Based on your understanding, identify WHERE the deduplication fails:

1. **Is the matching query wrong?**
   - Does it match on the right fields?
   - Is network_id/org_id part of the match incorrectly?

2. **Is there a race condition?**
   - Could discovery create duplicates before checking for existing?

3. **Is the subnet association the culprit?**
   - If subnets get recreated, do interfaces lose their identity?
   - Is interface identity tied to subnet_id when it shouldn't be?

4. **Is there missing sync logic?**
   - Compare interface sync to other entity sync methods
   - Are interfaces missing a sync pattern that other entities have?

### Phase 3: Document Root Cause

Write up your findings in this TASK.md under "## Investigation Findings":

1. **Data flow diagram** - How discovery data flows through the system
2. **Root cause** - The specific code path that causes duplicates
3. **Evidence** - Code references (file:line) supporting your conclusion
4. **Proposed fix** - High-level approach to fix (don't implement yet)
5. **Risk assessment** - What else might break if we change this?

## Key Files to Investigate

Start with these, but follow the code wherever it leads:

| Area | Likely Files |
|------|--------------|
| Discovery entry point | `backend/src/daemon/` or `backend/src/server/discovery/` |
| Interface handling | `backend/src/server/interfaces/` |
| Host handling | `backend/src/server/hosts/` |
| Subnet handling | `backend/src/server/subnets/` |
| Port handling | `backend/src/server/ports/` |
| Service handling | `backend/src/server/services/` |
| Sync/upsert logic | Look for `sync_*`, `upsert`, `find_or_create` patterns |

## Questions to Answer

- [ ] What uniquely identifies an interface in the DB? (IP? MAC? name? host_id + name?)
- [ ] What uniquely identifies a port? (interface_id + port_number? something else?)
- [ ] When does discovery "create new" vs "update existing"?
- [ ] Is there a sync method for interfaces? If not, why not?
- [ ] How does subnet recreation affect interface identity?
- [ ] What changed in v0.12.8 that might have caused this?

## Acceptance Criteria

- [ ] Full discovery flow documented
- [ ] Root cause identified with code references
- [ ] Proposed fix outlined (not implemented)
- [ ] Findings written in TASK.md "Investigation Findings" section
- [ ] No code changes (this is investigation only)

## DO NOT

- Do not implement a fix yet
- Do not make code changes
- Do not create migrations

Your job is to understand and document. The fix will come after review of your findings.

---

## Investigation Findings

### 1. Data Flow Diagram

```
Docker Discovery Flow:
═══════════════════════════════════════════════════════════════════════════════

DAEMON SIDE                              SERVER SIDE
───────────────────────────────────────  ──────────────────────────────────────

1. DiscoveryRunner::discover()
   │
   ├─► discover_create_subnets()
   │   ├─► get_own_interfaces()
   │   │   └─► Creates Subnet objects     ─────► POST /api/v1/subnets
   │   │       with DiscoveryType::Docker         │
   │   │       metadata                           ▼
   │   │                                   SubnetService::create()
   │   │                                   ├─► find(|s| subnet.eq(s))
   │   │                                   │   (matches by CIDR+network_id)
   │   │                                   ├─► Check metadata for Docker host_id
   │   │                                   └─► Return existing OR create new
   │   │                                          │
   │   └─► get_subnets_from_docker_networks()    │
   │       └─► Returns server-confirmed subnets ◄─┘
   │
   ├─► Update interface subnet_ids
   │   to match server-returned subnets
   │
   ├─► get_container_interfaces()
   │   └─► Create Interface objects
   │       with subnet_id from confirmed subnets
   │
   └─► create_host()                      ─────► POST /api/v1/hosts/discovery
       (host + interfaces + ports + services)     │
                                                  ▼
                                           HostService::discover_host()
                                           └─► create_with_children()
                                               │
                                               ├─► find_matching_host_by_interfaces()
                                               │   Uses Interface::eq() which supports:
                                               │   - (ip + subnet_id) match
                                               │   - MAC address match  ✓
                                               │   - ID match
                                               │
                                               └─► Interface deduplication (lines 501-513)
                                                   Query: host_id + subnet_id + ip_address
                                                   ⚠️ NO MAC FALLBACK - ROOT CAUSE
```

### 2. Root Cause

**The interface deduplication in `create_with_children` queries by `(host_id, subnet_id)` without MAC address fallback.**

When subnet_id differs between runs (due to subnet recreation, different discovery ordering, or daemon re-registration), the existing interface is not found, causing duplicates.

#### Critical Code Path (`hosts/service.rs:501-513`):

```rust
// Check by unique constraint (host_id, subnet_id, ip_address)
let filter = EntityFilter::unfiltered()
    .host_id(&interface.base.host_id)
    .subnet_id(&interface.base.subnet_id);  // ⚠️ PROBLEM
let existing_by_key: Vec<Interface> =
    self.interface_service.get_all(filter).await?;
if let Some(existing_iface) = existing_by_key
    .into_iter()
    .find(|i| i.base.ip_address == interface.base.ip_address)
{
    // Match found - reuse existing
    created_interfaces.push(existing_iface);
    continue;
}
// No match - creates NEW interface (DUPLICATE!)
```

#### Inconsistency with Host Matching:

The `Interface::PartialEq` implementation (`interfaces/impl/base.rs:91-99`) DOES support MAC matching:

```rust
impl PartialEq for Interface {
    fn eq(&self, other: &Self) -> bool {
        (self.base.ip_address == other.base.ip_address
            && self.base.subnet_id == other.base.subnet_id)
        || (self.base.mac_address == other.base.mac_address  // MAC fallback exists
            && self.base.mac_address.is_some()
            && other.base.mac_address.is_some())
        || (self.id == other.id)
    }
}
```

This `PartialEq` is used for **host matching** (`find_matching_host_by_interfaces`), so hosts are deduplicated correctly. But the **interface creation** step uses a database query that doesn't include MAC matching, causing the discrepancy.

### 3. Evidence

| Location | Issue |
|----------|-------|
| `hosts/service.rs:501-513` | Interface dedup query filters by `subnet_id`, no MAC fallback |
| `hosts/service.rs:1055-1067` | Host matching uses `Interface::eq()` which HAS MAC fallback |
| `interfaces/impl/base.rs:91-99` | `PartialEq` supports MAC matching but isn't used during creation |
| Commit `94133132` (v0.12.7→v0.12.8) | Changed subnet filter precedence, may trigger subnet_id mismatches |

#### Scenario That Causes Duplicates:

1. **First discovery**: Interface created with `subnet_id: S1`
2. **Subnet changes**: Due to re-discovery ordering, daemon re-registration, or subnet recreation
3. **Second discovery**: Same interface discovered with `subnet_id: S2`
4. **Query**: `host_id=H AND subnet_id=S2` returns NOTHING (existing has S1)
5. **Result**: New interface created → **DUPLICATE**

### 4. Why It May Have Started in v0.12.8

Commit `94133132` in v0.12.7→v0.12.8 changed subnet filter precedence:

**Before**: Docker subnets overrode host subnets with same CIDR
**After**: Host subnets take precedence, Docker subnets filtered out

This change could cause:
- Container interfaces to be associated with host subnets instead of Docker subnets
- Different subnet assignments between SelfReport and Docker discoveries
- More frequent subnet_id mismatches during rediscovery

### 5. Answers to Investigation Questions

| Question | Answer |
|----------|--------|
| What uniquely identifies an interface in DB? | `(host_id, subnet_id, ip_address)` - but this is fragile if subnet_id changes |
| What uniquely identifies a port? | `(host_id, port_number, protocol)` - not dependent on subnet_id |
| When does discovery "create new" vs "update existing"? | Create new if ID doesn't match AND (host_id, subnet_id, ip_address) query returns nothing |
| Is there a sync method for interfaces? | No dedicated sync; relies on dedup query in `create_with_children` |
| How does subnet recreation affect interface identity? | **Critically** - different subnet_id breaks the dedup query |
| What changed in v0.12.8? | Subnet filter precedence flip in commit `94133132` |

### 6. Proposed Fix

**Option A: Add MAC fallback to interface deduplication (Recommended)**

Add a third check after the `(host_id, subnet_id, ip_address)` query fails:

```rust
// Existing: Check by (host_id, subnet_id, ip_address)
// ...

// NEW: Fallback - check by (host_id, mac_address) if MAC is available
if interface.base.mac_address.is_some() {
    let mac_filter = EntityFilter::unfiltered()
        .host_id(&interface.base.host_id);
    let all_host_interfaces: Vec<Interface> =
        self.interface_service.get_all(mac_filter).await?;
    if let Some(existing_iface) = all_host_interfaces
        .into_iter()
        .find(|i| i.base.mac_address == interface.base.mac_address)
    {
        // Found by MAC - update subnet_id if needed
        created_interfaces.push(existing_iface);
        continue;
    }
}
```

**Option B: Add IP fallback across subnets**

If MAC isn't available, match by `(host_id, ip_address)` regardless of subnet:

```rust
// Fallback - check by (host_id, ip_address) across all subnets
let ip_filter = EntityFilter::unfiltered()
    .host_id(&interface.base.host_id);
let all_host_interfaces: Vec<Interface> =
    self.interface_service.get_all(ip_filter).await?;
if let Some(existing_iface) = all_host_interfaces
    .into_iter()
    .find(|i| i.base.ip_address == interface.base.ip_address)
{
    created_interfaces.push(existing_iface);
    continue;
}
```

**Option C: Stabilize subnet_ids**

Ensure subnet deduplication is more robust so subnet_ids never change. This addresses the symptom's trigger but not the underlying fragility.

### 7. Risk Assessment

| Fix | Risk Level | Notes |
|-----|------------|-------|
| Option A (MAC fallback) | **Low** | Only affects discovery upsert path; MAC is authoritative for physical identity |
| Option B (IP fallback) | **Medium** | Could match wrong interface if IPs are reassigned (DHCP); safer with MAC first |
| Option C (Stabilize subnets) | **High** | Subnet logic is complex; may have side effects on tenant isolation |

**Recommendation**: Implement Option A with Option B as secondary fallback.

### 8. Port/Service Duplicate Explanation (Issue #425)

Once interfaces duplicate:

1. Service bindings reference old interface IDs
2. `reassign_service_interface_bindings()` (`hosts/service.rs:566-577`) tries to remap
3. If interface IDs changed, binding reassignment fails to find matches
4. Services fall back to creating "OpenPorts" (unclaimed ports)
5. Original bindings orphaned, new ports created → **duplicates**

The fix for interface deduplication will cascade to fix port/service issues.

---

## Work Summary

### What Was Investigated

1. **Discovery flow**: Traced daemon-side discovery through server-side entity creation
2. **Interface deduplication**: Found the critical gap in MAC address matching
3. **Subnet association**: Confirmed subnet_id dependency is the trigger for duplicates
4. **v0.12.8 changes**: Identified commit `94133132` as potential trigger
5. **Port/service cascade**: Understood how interface duplicates cause port duplicates

### Files Analyzed

- `backend/src/daemon/discovery/service/docker.rs` - Docker discovery logic
- `backend/src/daemon/discovery/service/self_report.rs` - SelfReport discovery
- `backend/src/daemon/utils/base.rs` - Interface/subnet creation utilities
- `backend/src/server/hosts/service.rs` - Host creation and interface deduplication
- `backend/src/server/interfaces/impl/base.rs` - Interface equality logic
- `backend/src/server/subnets/service.rs` - Subnet deduplication logic
- `backend/src/server/daemons/handlers.rs` - Daemon registration flow

### Key Finding

**Interface deduplication at `hosts/service.rs:501-513` is inconsistent with interface equality at `interfaces/impl/base.rs:91-99`.** The equality check supports MAC matching, but the deduplication query doesn't. Adding MAC fallback to the deduplication query will fix the issue.

---

## Implementation Work Summary

### What Was Implemented

Added MAC address fallback to interface deduplication in `create_with_children`. When the existing `(host_id, subnet_id, ip_address)` query fails to find a match, a second query by `(host_id, mac_address)` is attempted. This prevents duplicate interfaces when subnet_id changes between discovery runs.

### Files Changed

| File | Change |
|------|--------|
| `backend/src/server/shared/storage/traits.rs` | Added `SqlValue::MacAddress(MacAddress)` variant |
| `backend/src/server/shared/storage/generic.rs` | Added binding case for `MacAddress` in `bind_value()` |
| `backend/src/server/shared/storage/filter.rs` | Added `EntityFilter::mac_address()` method |
| `backend/src/server/hosts/service.rs` | Added MAC fallback after line 513 in interface deduplication |
| `backend/migrations/20260106000000_interface_mac_index.sql` | New partial index on `(host_id, mac_address)` |

### Design Decisions

- **Reuse existing interface as-is**: When found by MAC, don't update the existing interface's subnet_id
- **No IP-only fallback**: IP + subnet_id remains authoritative; IP-only matching risks DHCP mismatches
- **Partial index**: Index excludes NULL mac_address values for efficiency

### Testing

- 84 unit tests passed
- No new clippy warnings introduced
- Integration tests skipped (require full Docker environment)
