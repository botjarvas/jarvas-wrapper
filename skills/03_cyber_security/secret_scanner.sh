#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - secret_scanner
# Usage: secret_scanner.sh <path>
ROOT=${1:-.}

# Patterns to search (quoted properly)
patterns=(
  'AKIA[0-9A-Z]{16}'
  '-----BEGIN (RSA|DSA|EC|OPENSSH|PRIVATE) KEY-----'
  'AIza[0-9A-Za-z_-]{35}'
  'ssh-rsa [A-Za-z0-9+/=]+'
)

COUNT=0
for p in "${patterns[@]}"; do
  # use grep -rE, exclude runs dir, silence errors
  matches=$(grep -RInE --exclude-dir=runs "$p" "$ROOT" 2>/dev/null || true)
  if [[ -n "$matches" ]]; then
    echo "FOUND pattern: $p" >&2
    echo "$matches" >&2
    # increment count by number of lines
    n=$(echo "$matches" | wc -l)
    COUNT=$((COUNT + n))
  fi
done

if (( COUNT > 0 )); then
  echo "SECRET SCAN: found $COUNT potential secret(s)" >&2
  exit 1
fi

echo "OK: no obvious secrets found under $ROOT"
exit 0
