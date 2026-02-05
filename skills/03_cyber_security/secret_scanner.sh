#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - secret_scanner (redaction enabled)
# Usage: secret_scanner.sh <path>
ROOT=${1:-.}

declare -A patterns
patterns["AKIA[0-9A-Z]{16}"]="AWS_KEY"
patterns["-----BEGIN (RSA|DSA|EC|OPENSSH|PRIVATE) KEY-----"]="PRIVATE_KEY_HEADER"
patterns["AIza[0-9A-Za-z_-]{35}"]="GOOGLE_API_KEY"
patterns["ssh-rsa [A-Za-z0-9+/=]{100,}"]="SSH_PUBKEY_LONG"

COUNT=0
for p in "${!patterns[@]}"; do
  name=${patterns[$p]}
  # find files with matches, output filename:matched_string (use grep -o)
  # Use LC_ALL=C to stabilize regex behavior
  while IFS= read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    match=$(echo "$line" | cut -d: -f2-)
    # mask match: keep first 4 and last 4 chars if length sufficient
    cleaned=$(echo "$match" | tr -d '\n' | sed -E 's/^(.{4}).*(.{4})$/\1...\2/')
    if [[ -z "$cleaned" ]]; then cleaned="[redacted]"; fi
    echo "[CRITICAL] Secret found in file: $file (Pattern: $name)" >&2
    echo "[REDACTED] $cleaned" >&2
    COUNT=$((COUNT+1))
  done < <(grep -RInE --exclude-dir=runs -o --line-number "$p" "$ROOT" 2>/dev/null || true)
done

if (( COUNT > 0 )); then
  echo "SECRET SCAN: found $COUNT potential secret(s)" >&2
  exit 1
fi

echo "OK: no obvious secrets found under $ROOT"
exit 0
