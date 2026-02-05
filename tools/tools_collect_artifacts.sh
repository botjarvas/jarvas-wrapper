#!/usr/bin/env bash
set -euo pipefail
RUN_DIR=${1:-/home/ubuntu/.openclaw/workspace/runs}
OUT=/tmp/artifacts-$(date -u +%Y%m%dT%H%M%SZ).tar.gz
if [ -d "$RUN_DIR" ]; then
tar -czf "$OUT" -C "$RUN_DIR" .
echo "$OUT"
else
 echo "No runs dir: $RUN_DIR" >&2
 exit 1
fi
