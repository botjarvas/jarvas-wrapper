#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - unused_volume_check
# Check for block devices with no mount and not root device
EXCLUDE_PATTERN=${1:-"/dev/loop"}
found=0
lsblk -o NAME,MOUNTPOINT | awk '$2==""{print "/dev/"$1}' | while read -r dev; do
  if echo "$dev" | grep -q "$EXCLUDE_PATTERN"; then continue; fi
  echo "UNMOUNTED: $dev"; found=1
done
if (( found )); then echo "FAIL: unmounted block devices exist" >&2; exit 1; fi
echo "OK: no unmounted block devices found"
exit 0
