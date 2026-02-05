#!/usr/bin/env bash
set -euo pipefail
URL=${1:-http://localhost:8080/}
timeout 5 curl -fsS "$URL" >/dev/null && echo "OK: $URL" || { echo "FAIL: $URL"; exit 2; }
