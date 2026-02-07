> **First:** Read `CLAUDE.md` (project instructions) — you are a **worker**.

# Task: Fix Ghost Printing on JetDirect Printers (Issue #496)

## Problem

Scanopy's network discovery causes ghost printing on JetDirect-enabled printers. When a network scan detects port 9100 is open, it probes `GET /metrics HTTP/1.1` (looking for Prometheus Node Exporter). JetDirect printers listen on port 9100 for raw print jobs — they have no HTTP parser, so the HTTP request headers are interpreted as printer control codes, causing garbage pages to print.

**Affected users:** Anyone with network printers (Canon, HP, etc.) on their scanned subnet.

## Root Cause

The endpoint probing mechanism in `backend/src/daemon/utils/scanner.rs` (function `scan_endpoints()`, ~line 699) sends HTTP GET requests to all registered service endpoints when a matching port is found open. The Prometheus Node Exporter service definition (`backend/src/server/services/definitions/prometheus_node_exporter.rs`) registers `Pattern::Endpoint(PortType::new_tcp(9100), "/metrics", "node_exporter", None)`, which triggers an HTTP GET to port 9100.

**Flow:**
1. Network discovery TCP-scans host, finds port 9100 open
2. `scan_endpoints()` collects all registered endpoints, including `TCP 9100 → /metrics`
3. Sends `GET http://[IP]:9100/metrics HTTP/1.1\r\nHost: ...\r\n\r\n`
4. JetDirect printer receives raw bytes, interprets as print data → ghost print

## Fix Required

Port 9100 is a **dual-use port**: JetDirect (raw socket, no HTTP) and Prometheus Node Exporter (HTTP). The scanner must distinguish between them before sending HTTP requests.

### Approach: Pre-probe Protocol Detection

Before sending an HTTP request to a port that has known non-HTTP protocol conflicts, perform a lightweight check to determine if the service speaks HTTP:

1. **Identify conflicting ports.** Add a concept of "cautious ports" or "protocol-ambiguous ports" to the endpoint probing system. Port 9100 is the primary one (JetDirect vs Node Exporter), but there may be others (e.g., port 515 LPD, port 631 IPP). Check the service definitions for other ports that could conflict with raw-socket protocols.

2. **For cautious ports, do a safe pre-check before HTTP probing.** Options (pick the best one):
   - **TCP banner read:** Connect, wait briefly (~1-2 seconds) for the service to send a banner. JetDirect printers typically send no banner or send `@PJL` commands. Node Exporter sends nothing (it's HTTP, waits for request). This alone may not distinguish them.
   - **Minimal HTTP probe:** Send a very small, harmless request like `HEAD / HTTP/1.0\r\n\r\n` and check if the response starts with `HTTP/`. If yes → HTTP service, safe to probe further. If no response or non-HTTP response → skip. The concern is that even this small request might trigger a print job — test whether `HEAD` is safer than `GET` (it sends less data, but the headers are still interpreted as raw data by JetDirect).
   - **Port exclusion with opt-in:** Don't probe port 9100 by default. Add a configuration option to enable Node Exporter detection on port 9100. This is the safest approach but loses auto-detection.
   - **Response-based bailout:** Connect, send the HTTP request, but read the response immediately. If the response doesn't start with `HTTP/`, close immediately and flag the port as non-HTTP. This doesn't prevent the ghost print since the request is already sent.

   The safest approach is probably **port exclusion with opt-in** — mark 9100 as a known JetDirect port and skip HTTP probing unless explicitly enabled. Node Exporter users can opt in.

3. **Implementation location:** The check should happen in `scan_endpoints()` in `scanner.rs` before the HTTP GET is sent (around line 699). Or it can happen earlier when collecting endpoints — skip endpoints on known-dangerous ports.

### Service Definition Changes

Consider adding a field to service definitions or endpoint patterns to flag protocol ambiguity:
- `Pattern::Endpoint` could gain an `is_safe_to_probe: bool` or `requires_http_precheck: bool` flag
- Or maintain a static list of ports known to have non-HTTP services that react to raw TCP data

### Alternative: JetDirect Service Definition

Consider adding a JetDirect/RAW printing service definition that detects printers on port 9100 via `Pattern::Port` only (no endpoint probe). This way printers are identified correctly as printers without sending any data.

Check if one already exists — search for "jetdirect", "printer", "9100", "raw printing" in the service definitions.

## Key Files

- `backend/src/daemon/utils/scanner.rs` — `scan_endpoints()` function (~line 622-761), the HTTP probing logic
- `backend/src/server/services/definitions/prometheus_node_exporter.rs` — port 9100 endpoint definition
- `backend/src/server/services/definitions/mod.rs` — service definition registry
- `backend/src/server/services/impl/patterns.rs` — Pattern types (Endpoint, Port, etc.)
- `backend/src/server/services/impl/base.rs` — `all_discovery_endpoints()` (~line 315)
- `backend/src/daemon/discovery/service/network.rs` — calls `scan_endpoints()` (~line 923)

## Acceptance Criteria

- [ ] Network discovery does not cause ghost printing on JetDirect printers (port 9100)
- [ ] Prometheus Node Exporter can still be detected (either by default with safe probing, or via opt-in config)
- [ ] Solution handles other potentially conflicting ports if they exist (e.g., LPD 515)
- [ ] No regression in service detection for non-conflicting ports
- [ ] Tests pass, format/lint clean

---

## Work Summary

### Approach: Port Exclusion with Opt-in Toggle

Chose the safest approach — skip HTTP probing on raw socket ports (9100-9107) by default, matching nmap's `Exclude T:9100-9107`. Users without printers can opt in via a toggle on Network discovery to re-enable detection of services like Prometheus Node Exporter.

### What was implemented

**Core fix — port exclusion:**
- Expanded `PortType::is_raw_socket()` to cover range 9100-9107 (was only 9100)
- Added `probe_raw_socket_ports: bool` parameter to `scan_endpoints()` in `scanner.rs`
- Endpoints on raw socket ports are now filtered out unless the opt-in flag is set
- `scan_ports_and_endpoints()` (self-report path) passes `false`
- Docker discovery passes `false`

**Opt-in toggle on Network discovery:**
- Added `#[serde(default)] probe_raw_socket_ports: bool` field to `DiscoveryType::Network`
- Piped through: `manager.rs` → `NetworkScanDiscovery` → `DeepScanParams` → `scan_endpoints()`
- Updated all files that construct/destructure `DiscoveryType::Network` (9 files total)

**JetDirect service definition:**
- New `jetdirect.rs` — detects printers on port 9100 via `Pattern::Port(PortType::JetDirect)` (no HTTP probe)
- Category: `ServiceCategory::Printer`, `is_generic: true`

**Service metadata for UI:**
- Added `has_raw_socket_endpoint()` on `Pattern` and `ServiceDefinitionExt`
- Exposed in metadata JSON so UI can dynamically show affected services
- Updated `prometheus_node_exporter.rs` to use `PortType::JetDirect` instead of `PortType::new_tcp(9100)`

**UI toggle:**
- Added checkbox in `DiscoveryTypeForm.svelte` for `probe_raw_socket_ports`
- Help text dynamically lists services that require the toggle (currently: Prometheus Node Exporter)
- Warning: "May cause ghost printing on JetDirect printers"

### Files changed

| File | Change |
|------|--------|
| `backend/src/server/ports/impl/base.rs` | `is_raw_socket()` → range 9100-9107 |
| `backend/src/server/services/definitions/jetdirect.rs` | **New** — JetDirect service definition |
| `backend/src/server/services/definitions/mod.rs` | Register `jetdirect` module |
| `backend/src/server/services/definitions/prometheus_node_exporter.rs` | Use `PortType::JetDirect` |
| `backend/src/daemon/utils/scanner.rs` | `probe_raw_socket_ports` param + filter |
| `backend/src/server/discovery/impl/types.rs` | Add field to `DiscoveryType::Network` |
| `backend/src/daemon/discovery/manager.rs` | Extract + pass field |
| `backend/src/daemon/discovery/service/network.rs` | Store + pipe through to scanner |
| `backend/src/daemon/discovery/service/docker.rs` | Pass `false` |
| `backend/src/server/discovery/service.rs` | Preserve field during SNMP hydration |
| `backend/src/server/daemons/service.rs` | Add field to Network construction |
| `backend/src/server/services/impl/patterns.rs` | `has_raw_socket_endpoint()` helper |
| `backend/src/server/services/impl/definitions.rs` | Expose in `ServiceDefinitionExt` + metadata |
| `backend/src/server/shared/types/entities.rs` | Add field to default |
| `backend/src/server/shared/types/examples.rs` | Add field to example |
| `backend/tests/integration/crud.rs` | Add field to test fixture |
| `backend/tests/integration/discovery.rs` | Add field to test fixture |
| `ui/src/lib/shared/stores/metadata.ts` | `has_raw_socket_endpoint` in TS interface |
| `ui/src/lib/features/discovery/components/DiscoveryModal/DiscoveryTypeForm.svelte` | Checkbox toggle |

### Deviations from plan

- Updated `prometheus_node_exporter.rs` to use `PortType::JetDirect` instead of `PortType::new_tcp(9100)` — required because an existing test enforces that named port types are used when available.
- Updated `discovery/service.rs` (SNMP hydration path) — not in original plan, but required to preserve the field when reconstructing the Network variant.
- Updated `daemons/service.rs`, `entities.rs`, `examples.rs` — not in original plan, but required for all `DiscoveryType::Network` construction sites.

### Status

- `make format` — clean
- `make lint` — clippy clean; UI prettier warnings in `project.inlang/` are pre-existing
- `make generate-types` — regenerated successfully
- Tests — not run (skipped per user request)
