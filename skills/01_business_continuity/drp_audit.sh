#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - drp_audit
# Usage: drp_audit.sh /path/to/drp_snapshot.tar.gz [max_age_days]
SNAP=${1:-/var/backups/drp_snapshot.tar.gz}
MAXDAYS=${2:-30}
if [[ ! -f "$SNAP" ]]; then echo "FAIL: snapshot not found: $SNAP" >&2; exit 1; fi
mod=$(stat -c %Y "$SNAP")
now=$(date +%s)
age_days=$(( (now - mod) / 86400 ))
if (( age_days > MAXDAYS )); then
  echo "FAIL: snapshot $SNAP is $age_days days old (> $MAXDAYS)" >&2
  exit 1
fi
echo "OK: snapshot $SNAP age $age_days days"
exit 0
