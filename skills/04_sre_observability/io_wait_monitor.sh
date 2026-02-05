#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - io_wait_monitor
# Check iowait percentage from /proc/stat over short interval
INTERVAL=${1:-2}
if ! grep -q '^cpu ' /proc/stat; then echo "ERROR: /proc/stat not found" >&2; exit 1; fi
read -r cpu a b c d iowait rest < /proc/stat
sleep $INTERVAL
read -r cpu2 a2 b2 c2 d2 iowait2 rest2 < /proc/stat
iowait_diff=$((iowait2 - iowait))
total_diff=$(( (a2-a) + (b2-b) + (c2-c) + (d2-d) + (iowait2 - iowait) ))
if (( total_diff == 0 )); then echo "OK: no CPU activity"; exit 0; fi
iowait_pct=$(( iowait_diff * 100 / total_diff ))
THRESH=${2:-20}
if (( iowait_pct > THRESH )); then
  echo "FAIL: iowait ${iowait_pct}% > ${THRESH}%" >&2; exit 1
fi
echo "OK: iowait ${iowait_pct}% within threshold ${THRESH}%"
exit 0
