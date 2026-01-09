> **First:** Read `CLAUDE.md` (project instructions) — you are a **worker**.

# Task: External Service Authentication

## Objective

Refactor the metrics endpoint authentication to follow the standard auth middleware pattern, adding a new `ExternalService` auth method for Prometheus and similar external systems.

## Background

Currently, `backend/src/server/metrics/handlers.rs` implements custom bearer token authentication that bypasses the standard auth middleware:

```rust
pub async fn get_metrics(
    State(state): State<Arc<AppState>>,
    headers: HeaderMap,
) -> impl IntoResponse {
    let Some(expected_token) = &state.config.metrics_token else {
        return (StatusCode::NOT_FOUND, "Metrics not enabled").into_response();
    };

    let provided = headers
        .get("Authorization")
        .and_then(|v| v.to_str().ok())
        .and_then(|v| v.strip_prefix("Bearer "));

    match provided {
        Some(token) if token == expected_token => { /* render metrics */ }
        _ => (StatusCode::UNAUTHORIZED, "Invalid or missing token").into_response(),
    }
}
```

This approach:
- Doesn't integrate with the auth middleware pattern
- Can't log/audit which external service accessed the endpoint
- Doesn't fit the `AuthMethod`/`AuthenticatedEntity` model

## Requirements

### 1. Add ExternalService to AuthMethod Enum

In `backend/src/server/auth/middleware/auth.rs`:

```rust
#[derive(Debug, Clone, Copy, Serialize, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum AuthMethod {
    Session,
    UserApiKey,
    DaemonApiKey,
    ExternalService,  // NEW
    System,
    Anonymous,
}
```

### 2. Add ExternalService to AuthenticatedEntity Enum

```rust
pub enum AuthenticatedEntity {
    // ... existing variants
    ExternalService {
        name: String,  // From X-Service-Name header, or "unknown"
    },
}
```

### 3. Add IsExternalService Permission Requirement

In `backend/src/server/auth/middleware/permissions.rs`:

```rust
pub struct IsExternalService;

impl PermissionRequirement for IsExternalService {
    fn check(entity: &AuthenticatedEntity) -> Result<(), ApiError> {
        match entity {
            AuthenticatedEntity::ExternalService { .. } => Ok(()),
            _ => Err(ApiError::forbidden(Self::description())),
        }
    }

    fn description() -> &'static str {
        "External service authentication required"
    }
}
```

### 4. Extend Auth Extraction Logic

Modify `AuthenticatedEntity::from_request_parts` to check for external service token:

- Check for Bearer token with a specific prefix (e.g., `scp_ext_`) OR match against configured `metrics_token`
- If matched, extract service name from `X-Service-Name` header (default to "unknown")
- Return `AuthenticatedEntity::ExternalService { name }`

**Note:** Keep backward compatibility with the existing `SCANOPY_METRICS_TOKEN` config.

### 5. Update Metrics Handler

```rust
pub async fn get_metrics(
    auth: Authorized<IsExternalService>,
    State(state): State<Arc<AppState>>,
) -> impl IntoResponse {
    // Metrics rendering logic
    // auth.entity gives us ExternalService { name } for logging
}
```

### 6. Move Metrics Route Inside Protected Layer

Currently registered outside protected middleware (in `backend/src/bin/server.rs` around line 249). Consider whether to:
- Keep it outside but manually extract auth, OR
- Move inside protected layer with the new extractor

The second option is cleaner but requires the metrics endpoint to go through all middleware layers.

## Files Likely Involved

- `backend/src/server/auth/middleware/auth.rs` - AuthMethod, AuthenticatedEntity, extraction logic
- `backend/src/server/auth/middleware/permissions.rs` - IsExternalService requirement
- `backend/src/server/metrics/handlers.rs` - Update to use Authorized<IsExternalService>
- `backend/src/bin/server.rs` - Route registration (may need to move metrics route)
- `backend/src/server/config.rs` - Existing metrics_token config (keep for backward compat)
- `backend/src/server/shared/events/types.rs` - May need to handle ExternalService in event serialization

## Acceptance Criteria

- [ ] `AuthMethod::ExternalService` variant added
- [ ] `AuthenticatedEntity::ExternalService { name }` variant added
- [ ] `IsExternalService` permission requirement implemented
- [ ] Auth extraction handles external service tokens (backward compatible with existing config)
- [ ] Metrics handler uses `Authorized<IsExternalService>`
- [ ] Service name captured from `X-Service-Name` header (or defaults to "unknown")
- [ ] Existing `SCANOPY_METRICS_TOKEN` config still works
- [ ] `cargo test` passes
- [ ] `make format && make lint` passes

## Design Decisions

- **Global scope:** ExternalService auth is global (not org-scoped). These are self-hosted services needing full application access.
- **No database table:** Keep it simple - token configured via env var, no rotation/management UI needed.
- **Service name via header:** Optional `X-Service-Name: prometheus` header for audit logging.

## Notes

- The external service token should be distinguishable from user/daemon API keys
- Consider using a prefix like `scp_ext_` for external service tokens, OR just match the raw `metrics_token` value
- Event logging should work automatically once ExternalService is in AuthenticatedEntity

## Work Summary

### What was implemented

1. **AuthMethod enum** - Added `ExternalService` variant to `AuthMethod` enum and updated `Display` impl (`auth.rs:46-60`)

2. **AuthenticatedEntity enum** - Added `ExternalService { name: String }` variant with:
   - `Display` impl
   - `entity_id()` returns `external_service:<name>`
   - `network_ids()` returns empty vec (global scope)
   - `is_external_service()` helper method
   (`auth.rs:90-204`)

3. **Generic IsExternalService<T> permission** - Created a flexible permission system:
   - `ExternalServiceType` trait with `required_name()` method
   - `AnyService`, `Prometheus`, `Grafana` marker types
   - `IsExternalService<T>` generic permission that can require any or specific service
   - Usage: `Authorized<IsExternalService>` or `Authorized<IsExternalService<Prometheus>>`
   (`permissions.rs:228-299`)

4. **IP restriction config** - Added per-service IP restrictions:
   - `external_service_allowed_ips: HashMap<String, Vec<String>>` config field
   - Env var format: `SCANOPY_EXTERNAL_SERVICE_PROMETHEUS_ALLOWED_IPS=192.168.1.0/24,10.0.0.1`
   - Custom config loading in `ServerConfig::load_external_service_allowed_ips()`
   (`config.rs:135-139, 286-320`)

5. **Auth extraction logic** - Extended to handle external service tokens:
   - Checks Bearer token against `metrics_token` config before User/Daemon key detection
   - Extracts service name from `X-Service-Name` header (defaults to "unknown")
   - Validates IP against configured restrictions using `IpCidr` from cidr crate
   (`auth.rs:309-335, 615-648`)

6. **Updated metrics handler** - Now uses `Authorized<IsExternalService<Prometheus>>`:
   - Requires `X-Service-Name: prometheus` header
   - Removed manual token validation (handled by auth middleware)
   (`handlers.rs:1-33`)

7. **Route and rate limiting**:
   - Moved route from `/metrics` to `/api/metrics` in exempt routes (`factory.rs:105-109`)
   - Removed standalone route from `server.rs`
   - Added `external_service` rate limiter: 60 requests/min with burst of 10
   (`rate_limit.rs:39, 59-64, 180-202, 247`)

8. **Logging middleware** - Added match arm for `ExternalService` variant (`logging.rs:42-44`)

### Files changed

- `backend/src/server/auth/middleware/auth.rs` - AuthMethod, AuthenticatedEntity, extraction logic, IP validation
- `backend/src/server/auth/middleware/permissions.rs` - IsExternalService generic permission
- `backend/src/server/auth/middleware/rate_limit.rs` - External service rate limiting
- `backend/src/server/auth/middleware/logging.rs` - ExternalService match arm
- `backend/src/server/metrics/handlers.rs` - Updated to use Authorized extractor
- `backend/src/server/config.rs` - IP restriction config
- `backend/src/server/shared/handlers/factory.rs` - Route registration at /api/metrics
- `backend/src/bin/server.rs` - Removed standalone /metrics route

### Permission requirement used

`Authorized<IsExternalService<Prometheus>>` - Requires:
- Valid Bearer token matching `SCANOPY_METRICS_TOKEN`
- `X-Service-Name: prometheus` header
- Request IP passes configured restrictions (if any)

### Tenant isolation verification

External services are global scope (not org/network scoped):
- `network_ids()` returns empty vec
- No organization_id
- Intended for system-level monitoring services

### Testing

- All tests pass (`cargo test`)
- `make format` passes (Rust formatting)
- `cargo clippy` passes (only pre-existing warnings)

### Notes for merge

- Route changed from `/metrics` to `/api/metrics` - Prometheus scrape configs need updating
- New required header: `X-Service-Name: prometheus`
- Optional IP restrictions via `SCANOPY_EXTERNAL_SERVICE_PROMETHEUS_ALLOWED_IPS` env var
- Backward compatible with existing `SCANOPY_METRICS_TOKEN` config
