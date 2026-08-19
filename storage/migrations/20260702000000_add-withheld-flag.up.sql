-- Per-withdrawal hold flag. Defaults to FALSE so existing withdrawals and normal
-- inserts are finalized as usual. When WITHHOLD_NEW_WITHDRAWALS is enabled the
-- watcher records new withdrawals with withheld = TRUE; the finalizer skips
-- withheld rows unless IGNORE_WITHHOLD is set.
ALTER TABLE withdrawals ADD COLUMN withheld BOOLEAN NOT NULL DEFAULT FALSE;
