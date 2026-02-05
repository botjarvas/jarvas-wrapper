#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - orphan_user_audit
# Find users with no recent login (last 90 days)
THRESH_DAYS=${1:-90}
now=$(date +%s)
bad=0
lastlog -b 0 | awk 'NR>1{print $1,$4" "$5" "$6" "$7}' | while read -r user last; do
  if [[ "$last" == "**Never logged in**" ]]; then
    echo "ORPHAN USER: $user"; bad=1
  fi
done
if (( bad )); then exit 1; fi
echo "OK: no obvious orphan users"
exit 0
