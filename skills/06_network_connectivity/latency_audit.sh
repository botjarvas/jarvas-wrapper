#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - latency_audit
HOST=${1:-8.8.8.8}
COUNT=${2:-5}
THRESH_MS=${3:-200}
if ! command -v ping >/dev/null 2>&1; then echo "Ping not available" >&2; exit 0; fi
res=$(ping -c $COUNT -q $HOST 2>/dev/null)
if [[ -z "$res" ]]; then echo "FAIL: ping failed to $HOST" >&2; exit 1; fi
avg=$(echo "$res" | tail -1 | awk -F'/' '{print $5}')
avg_int=${avg%.*}
if (( avg_int > THRESH_MS )); then echo "FAIL: avg latency ${avg}ms > ${THRESH_MS}ms" >&2; exit 1; fi
echo "OK: avg latency ${avg}ms to $HOST"
exit 0
