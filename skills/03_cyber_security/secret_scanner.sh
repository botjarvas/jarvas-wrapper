#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - secret_scanner
# Usage: secret_scanner.sh <path>
ROOT=${1:-.}
# patterns: private key headers, AWS keys, generic token patterns
fail=0
# Search for private key blocks
if grep -RIn --exclude-dir=.git -E "-----BEGIN (RSA|DSA|EC|OPENSSH) PRIVATE KEY-----" "$ROOT"; then
  echo "FOUND: Private key material" >&2; fail=1
fi
# AWS Access Key ID
if grep -RIn --exclude-dir=.git -E "AKIA[0-9A-Z]{16}" "$ROOT"; then
  echo "FOUND: AWS Access Key ID pattern" >&2; fail=1
fi
# Generic token (very heuristic)
if grep -RIn --exclude-dir=.git -E "[A-Za-z0-9-_]{20,}\.[A-Za-z0-9-_]{20,}" "$ROOT"; then
  echo "FOUND: token-like pattern" >&2; fail=1
fi
if (( fail == 1 )); then
  echo "SECRET SCAN FAILED" >&2
  exit 1
fi
echo "OK: no obvious secrets found under $ROOT"
exit 0
