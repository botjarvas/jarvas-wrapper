#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - sudoers_audit
# Check for NOPASSWD entries in /etc/sudoers and /etc/sudoers.d/*
bad=0
grep -RIn --exclude-dir=.git "NOPASSWD:" /etc/sudoers /etc/sudoers.d 2>/dev/null || true | while read -r line; do
  echo "WARN: NOPASSWD found: $line" >&2; bad=1
done
if (( bad )); then echo "FAIL: sudoers contains NOPASSWD entries" >&2; exit 1; fi
echo "OK: sudoers check passed"
exit 0
