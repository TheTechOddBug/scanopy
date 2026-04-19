-- Timestamp of the most recent standby → active transition. Granted by
-- `/startup` when a standby daemon restarts, and by the discovery auto-wake
-- path. The nightly inactivity check skips daemons within the grace window
-- (STANDBY_GRACE_PERIOD_DAYS, currently 30 days) after this timestamp,
-- letting scheduled discoveries fire and refresh `last_finished` before
-- re-evaluating inactivity.
ALTER TABLE daemons ADD COLUMN standby_cleared_at TIMESTAMPTZ;
