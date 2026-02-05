#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - ssh_key_rotation_check
# Check ~/.ssh/authorized_keys for keys older than X days is non-trivial; instead verify key comment timestamps if present
AUTH=${1:-/root/.ssh/authorized_keys}
if [[ ! -f "$AUTH" ]]; then echo "WARN: authorized_keys not found: $AUTH"; exit 0; fi
# Heuristic: flag keys without a timestamp comment (user should include rotated-YYYYMMDD)
missing=0
while read -r line; do
  if [[ -z "$line" ]]; then continue; fi
  if echo "$line" | grep -qE 'rotated-[0-9]{8}'; then
    continue
  else
    echo "WARN: key missing rotation tag: $line"; missing=1
  fi
done < "$AUTH"
if (( missing )); then exit 1; fi
echo "OK: all keys have rotation tags (heuristic)"
exit 0
