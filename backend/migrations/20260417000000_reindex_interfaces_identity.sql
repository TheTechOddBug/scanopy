-- Replace the brittle UNIQUE(host_id, if_index) constraint with a partial
-- UNIQUE(host_id, if_name) WHERE if_name IS NOT NULL.
--
-- Rationale: ifIndex is only stable within a device config lifecycle; it can
-- shift on reboot or config reload on some vendors. ifName ("GigabitEthernet0/1",
-- "eth0") is far more stable when populated. Pre-existing rows written before
-- the ifName column was added have if_name = NULL; the partial predicate
-- simply doesn't apply to them, so the migration is safe for legacy data.
-- App-layer dedup falls back to if_index / MAC for NULL-if_name rows until
-- they get rescanned and if_name populates.

-- Drop original constraint (auto-generated name survived the if_entries → interfaces
-- rename unchanged: migration 20260410000000 renames indexes explicitly but not this
-- constraint, which was declared as `UNIQUE(host_id, if_index)` without a name).
ALTER TABLE interfaces DROP CONSTRAINT if_entries_host_id_if_index_key;

-- New partial unique: enforces identity where we have a strong identifier.
CREATE UNIQUE INDEX idx_interfaces_host_name
    ON interfaces(host_id, if_name)
    WHERE if_name IS NOT NULL;

-- Keep if_index as a non-unique lookup/sort index. InterfaceService::get_for_host
-- orders by if_index ASC, so this path still benefits.
CREATE INDEX idx_interfaces_host_if_index
    ON interfaces(host_id, if_index);
