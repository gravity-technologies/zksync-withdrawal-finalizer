-- New withdrawals are withheld by default. When withhold mode is enabled
-- (WITHHOLD_WITHDRAWALS), only withdrawals explicitly released (withheld = FALSE)
-- are finalized.
ALTER TABLE withdrawals ADD COLUMN withheld BOOLEAN NOT NULL DEFAULT TRUE;
