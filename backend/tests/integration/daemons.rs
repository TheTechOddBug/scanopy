//! Daemon service-level integration tests.

use crate::infra::{BASE_URL, exec_sql};
use uuid::Uuid;

pub async fn run_daemon_tests(daemon_id: Uuid, daemon_api_key: &str) -> Result<(), String> {
    println!("\n=== Testing Daemon Service Behaviour ===\n");

    test_startup_clears_standby_and_grants_grace(daemon_id, daemon_api_key).await?;

    println!("\n✅ All daemon service tests passed!");
    Ok(())
}

/// A daemon that's been put on standby by the inactivity sweep should have
/// standby cleared and the grace timestamp set when it re-runs its
/// `/startup` handshake (which happens on every daemon restart).
async fn test_startup_clears_standby_and_grants_grace(
    daemon_id: Uuid,
    daemon_api_key: &str,
) -> Result<(), String> {
    println!("Testing /startup clears standby + grants grace...");

    exec_sql(&format!(
        "UPDATE daemons SET standby = true, standby_cleared_at = NULL WHERE id = '{}';",
        daemon_id
    ))?;
    println!("  ✓ Marked daemon as standby via SQL");

    let client = reqwest::Client::new();
    let response = client
        .post(format!("{}/api/daemons/{}/startup", BASE_URL, daemon_id))
        .header("X-Daemon-ID", daemon_id.to_string())
        .header("Authorization", format!("Bearer {}", daemon_api_key))
        .json(&serde_json::json!({ "daemon_version": env!("CARGO_PKG_VERSION") }))
        .send()
        .await
        .map_err(|e| format!("Failed to POST /startup: {}", e))?;

    let status = response.status();
    if !status.is_success() {
        let body: serde_json::Value = response.json().await.unwrap_or_default();
        return Err(format!(
            "Startup returned non-2xx: status={} body={}",
            status,
            serde_json::to_string_pretty(&body).unwrap_or_default()
        ));
    }
    println!("  ✓ POST /startup returned {}", status);

    let standby_out = exec_sql(&format!(
        "SELECT standby FROM daemons WHERE id = '{}';",
        daemon_id
    ))?;
    if !standby_out.contains(" f\n") && !standby_out.contains(" f ") {
        return Err(format!(
            "Expected standby=f after /startup, got:\n{}",
            standby_out
        ));
    }
    println!("  ✓ standby == false after /startup");

    let cleared_out = exec_sql(&format!(
        "SELECT standby_cleared_at IS NOT NULL AS has_ts FROM daemons WHERE id = '{}';",
        daemon_id
    ))?;
    if !cleared_out.contains(" t\n") && !cleared_out.contains(" t ") {
        return Err(format!(
            "Expected standby_cleared_at IS NOT NULL after /startup, got:\n{}",
            cleared_out
        ));
    }
    println!("  ✓ standby_cleared_at is set");

    Ok(())
}
