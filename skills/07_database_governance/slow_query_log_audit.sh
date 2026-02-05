#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - slow_query_log_audit
# Check for presence of slow query log entries in /var/log/mysql or postgres logs (heuristic)
LOGS=("/var/log/mysql/mysql-slow.log" "/var/log/postgresql/postgresql-*-main.log")
found=0
for f in "${LOGS[@]}"; do
  for file in $(ls $f 2>/dev/null || true); do
    if [[ -s "$file" ]]; then
      if grep -qi "slow query" "$file" || grep -qi "duration:" "$file"; then
        echo "FOUND slow query entries in $file"; found=1
      fi
    fi
  done
done
if (( found )); then exit 1; fi
echo "OK: no obvious slow query entries found in standard logs"
exit 0
