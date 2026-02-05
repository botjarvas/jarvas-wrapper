#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - drift_detection
# Heuristic: compare live package list to baseline if baseline exists
BASELINE=${1:-/etc/jarvas/package_baseline.txt}
if [[ ! -f "$BASELINE" ]]; then echo "WARN: baseline $BASELINE not found; create baseline with 'dpkg --get-selections > $BASELINE'"; exit 0; fi
current=/tmp/current_pkgs_$$.txt
dpkg --get-selections | awk '{print $1}' | sort > "$current"
added=$(comm -13 "$BASELINE" "$current" | wc -l)
removed=$(comm -23 "$BASELINE" "$current" | wc -l)
if (( added > 0 || removed > 0 )); then
  echo "FAIL: drift detected - added:$added removed:$removed" >&2
  comm -13 "$BASELINE" "$current" || true
  comm -23 "$BASELINE" "$current" || true
  rm -f "$current"
  exit 1
fi
rm -f "$current"
echo "OK: no package drift detected"
exit 0
