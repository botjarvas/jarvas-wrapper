#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - dns_integrity
HOST=${1:-example.com}
if ! command -v dig >/dev/null 2>&1; then echo "dig not installed; using host lookup"; host $HOST >/dev/null 2>&1 || (echo "FAIL: DNS lookup failed for $HOST" >&2; exit 1); echo "OK: DNS lookup via host"; exit 0; fi
res=$(dig +short $HOST | grep -v '^$' || true)
if [[ -z "$res" ]]; then echo "FAIL: DNS lookup returned empty for $HOST" >&2; exit 1; fi
echo "OK: DNS records for $HOST: $res"
exit 0
