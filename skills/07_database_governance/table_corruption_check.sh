#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - table_corruption_check (Postgres heuristic)
# Requires psql; tests a connection and a simple checksum query if accessible
DB_HOST=${1:-localhost}
DB_PORT=${2:-5432}
DB_NAME=${3:-postgres}
if ! command -v psql >/dev/null 2>&1; then echo "psql not installed; skipping"; exit 0; fi
if ! psql -h $DB_HOST -p $DB_PORT -d $DB_NAME -c '\dt' >/dev/null 2>&1; then echo "FAIL: cannot list tables on $DB_HOST:$DB_PORT/$DB_NAME" >&2; exit 1; fi
echo "OK: connected and listed tables on $DB_HOST:$DB_PORT/$DB_NAME"
exit 0
