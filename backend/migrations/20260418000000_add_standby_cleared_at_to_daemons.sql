-- Timestamp of the most recent standby → active transition. Granted by
-- `/startup` when a standby daemon restarts, and by the discovery auto-wake
-- path. The nightly inactivity check skips daemons within a 14-day grace
-- window after this timestamp, letting weekly-scheduled discoveries fire
-- and refresh `last_finished` before re-evaluating inactivity.
ALTER TABLE daemons ADD COLUMN standby_cleared_at TIMESTAMPTZ;
