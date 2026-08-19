#!/usr/bin/env bash
#
# Runs the withdrawal-finalizer DB upgrade: create the database if it does not
# exist, then apply all pending migrations. Equivalent to the manual steps
# documented in the repo README:
#
#   sqlx database create --database-url $DATABASE_URL
#   sqlx migrate run    --database-url $DATABASE_URL
#
# Both steps are idempotent and roll-forward only (never runs *.down.sql).
set -euo pipefail

: "${DATABASE_URL:?DATABASE_URL must be set (e.g. postgres://user:pass@host:5432/withdrawal_finalizer)}"

echo ">> Creating database if it does not exist..."
sqlx database create --database-url "$DATABASE_URL"

echo ">> Applying pending migrations..."
sqlx migrate run --database-url "$DATABASE_URL" --source /app/migrations

echo ">> Withdrawal-finalizer DB upgrade complete."
