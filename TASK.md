> **First:** Read `CLAUDE.md` (project instructions) — you are a **worker**.

# Task: Implement Prometheus Metrics Endpoint

## Objective

Add a `/metrics` endpoint to Scanopy that exposes Prometheus-format metrics for monitoring request rates, latencies, error rates, and system events.

## Design Summary

### Architecture
- Prometheus pull model - Scanopy maintains in-memory counters, Prometheus scrapes `/metrics`
- Token-based auth via `SCANOPY_METRICS_TOKEN` environment variable
- Hook into existing request_logging_middleware for HTTP metrics
- Hook into existing EventBus for system event metrics

### Metrics to Expose

| Metric | Type | Labels | Source |
|--------|------|--------|--------|
| `http_requests_total` | Counter | method, path, status, entity_type | request_logging_middleware |
| `http_request_duration_seconds` | Histogram | method, path | request_logging_middleware |
| `scanopy_events_total` | Counter | entity, operation | MetricsService (EventBus subscriber) |

### Authentication
- If `SCANOPY_METRICS_TOKEN` not set: `/metrics` returns 404 (disabled)
- If token invalid/missing in request: 401 Unauthorized
- If valid: 200 + metrics text

### Dependencies to Add
```toml
metrics = "0.24"
metrics-exporter-prometheus = "0.16"
```

## Requirements

1. Add `metrics` and `metrics-exporter-prometheus` dependencies
2. Create `backend/src/server/metrics/` module with:
   - `mod.rs` - module exports
   - `service.rs` - MetricsService struct holding PrometheusHandle
   - `subscriber.rs` - EventSubscriber impl for event metrics
   - `handlers.rs` - `/metrics` endpoint handler
3. Add `metrics_token: Option<String>` to server config
4. Modify `request_logging_middleware` to record HTTP metrics
5. Register MetricsService as EventBus subscriber in service factory
6. Add `/metrics` route to server

## Implementation Details

### MetricsService Pattern
Follow the exact pattern of LoggingService:
```rust
pub struct MetricsService {
    pub handle: PrometheusHandle,
}

impl EventSubscriber for MetricsService {
    fn event_filter(&self) -> EventFilter {
        EventFilter::all()
    }

    async fn handle_events(&self, events: Vec<Event>) -> Result<()> {
        for event in events {
            metrics::counter!(
                "scanopy_events_total",
                "entity" => event.entity_discriminant(),
                "operation" => event.operation().to_string()
            ).increment(1);
        }
        Ok(())
    }

    fn name(&self) -> &str { "metrics" }
}
```

### Request Middleware Metrics
In request_logging_middleware, add:
```rust
metrics::counter!(
    "http_requests_total",
    "method" => method,
    "path" => matched_path,  // Route pattern, not actual path
    "status" => status_code,
    "entity_type" => entity_type
).increment(1);

metrics::histogram!("http_request_duration_seconds", "method" => method, "path" => matched_path)
    .record(duration_secs);
```

### Handler
```rust
pub async fn get_metrics(
    State(state): State<Arc<AppState>>,
    headers: HeaderMap,
) -> impl IntoResponse {
    let Some(expected_token) = &state.config.metrics_token else {
        return (StatusCode::NOT_FOUND, "Metrics not enabled").into_response();
    };

    let provided = headers.get("Authorization")
        .and_then(|v| v.to_str().ok())
        .and_then(|v| v.strip_prefix("Bearer "));

    match provided {
        Some(token) if token == expected_token => {
            let metrics = state.services.metrics_service.handle.render();
            (StatusCode::OK, [(header::CONTENT_TYPE, "text/plain")], metrics).into_response()
        }
        _ => (StatusCode::UNAUTHORIZED, "Invalid or missing token").into_response()
    }
}
```

## Files to Create/Modify

| File | Change |
|------|--------|
| `backend/Cargo.toml` | Add dependencies |
| `backend/src/server/mod.rs` | Add `pub mod metrics` |
| `backend/src/server/config.rs` | Add `metrics_token: Option<String>` |
| `backend/src/server/metrics/mod.rs` | New module |
| `backend/src/server/metrics/service.rs` | MetricsService struct |
| `backend/src/server/metrics/subscriber.rs` | EventSubscriber impl |
| `backend/src/server/metrics/handlers.rs` | `/metrics` endpoint |
| `backend/src/server/auth/middleware/logging.rs` | Add HTTP metrics |
| `backend/src/server/shared/services/factory.rs` | Init recorder, register subscriber |
| `backend/src/bin/server.rs` | Add `/metrics` route |

## Acceptance Criteria

- [ ] `/metrics` returns 404 when `SCANOPY_METRICS_TOKEN` not set
- [ ] `/metrics` returns 401 without valid Bearer token
- [ ] `/metrics` returns Prometheus text format with valid token
- [ ] `http_requests_total` increments on each request
- [ ] `http_request_duration_seconds` records request durations
- [ ] `scanopy_events_total` increments on entity CRUD operations
- [ ] `cd backend && cargo test` passes
- [ ] `make format && make lint` passes

## Testing

```bash
# Set token and start server
SCANOPY_METRICS_TOKEN=test-token cargo run --bin server

# Test disabled (no token)
curl http://localhost:60072/metrics  # Should 404

# Test unauthorized
curl http://localhost:60072/metrics  # Should 401

# Test authorized
curl -H "Authorization: Bearer test-token" http://localhost:60072/metrics
# Should return prometheus format metrics
```

## Notes

- Keep label cardinality bounded - use route patterns not actual paths
- Don't add database metrics (Phase 2)
- Don't add business metrics like host counts (Phase 2)

---

## Work Summary

### What was implemented

Implemented Prometheus metrics endpoint as specified. All acceptance criteria met.

### Files changed

| File | Change |
|------|--------|
| `backend/Cargo.toml` | Added `metrics = "0.24"` and `metrics-exporter-prometheus = "0.16"` dependencies |
| `backend/src/server/mod.rs` | Added `pub mod metrics` |
| `backend/src/server/config.rs` | Added `metrics_token: Option<String>` field to `ServerConfig` |
| `backend/src/server/metrics/mod.rs` | **New** - Module exports |
| `backend/src/server/metrics/service.rs` | **New** - `MetricsService` struct holding `PrometheusHandle` |
| `backend/src/server/metrics/subscriber.rs` | **New** - `EventSubscriber` impl for event metrics |
| `backend/src/server/metrics/handlers.rs` | **New** - `/metrics` endpoint handler with token auth |
| `backend/src/server/auth/middleware/logging.rs` | Added HTTP metrics recording (`http_requests_total`, `http_request_duration_seconds`) |
| `backend/src/server/shared/services/factory.rs` | Initialize Prometheus recorder (using `OnceLock` for test compatibility), create and register `MetricsService` |
| `backend/src/bin/server.rs` | Added `/metrics` route outside protected middleware |

### Deviations and rationale

1. **Global `OnceLock` for Prometheus handle**: The Prometheus recorder can only be installed once per process. Tests create multiple `ServiceFactory` instances, which caused failures. Used `OnceLock` to ensure the recorder is installed exactly once and the handle is shared.

2. **Event entity label**: The task specified `event.entity_discriminant()` but `Event` doesn't have that method directly. Implemented by matching on event type:
   - `Event::Entity(e)` → uses `e.entity_type.discriminant().to_string()`
   - `Event::Auth(_)` → uses `"auth"`
   - `Event::Telemetry(_)` → uses `"telemetry"`

3. **Content-Type header**: Set to `text/plain; version=0.0.4` per Prometheus exposition format spec.

### Verification

- `cd backend && cargo test` - All 72 tests pass (69 passed, 3 integration, 5 doc-tests ignored)
- `cargo fmt && cargo clippy` - No warnings or errors

### Notes for coordinator

- The `/metrics` endpoint is exposed outside the protected middleware stack (like `/api/health`) since it uses its own Bearer token authentication via `SCANOPY_METRICS_TOKEN` env var
- No permissions middleware needed - endpoint handles its own auth
- No tenant isolation concerns - metrics are global server metrics, not user-specific data
