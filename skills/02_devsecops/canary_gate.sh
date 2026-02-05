#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - canary_gate
# Simple canary gate: check a service health endpoint returns HTTP 200
URL=${1:-http://localhost:8080/health}
rc=0
status=$(curl -s -o /dev/null -w "%{http_code}" "$URL" || echo "000")
if [[ "$status" != "200" ]]; then
  echo "FAIL: health check returned $status for $URL" >&2; rc=1
else
  echo "OK: health check $URL returned 200"
fi
exit $rc
