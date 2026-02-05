#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - resource_invariants
# Check disk usage < 90% on /
THRESH=90
usage=$(df -h / | awk 'NR==2{print $5}' | tr -d '%')
if (( usage >= THRESH )); then
  echo "FAIL: root partition usage ${usage}% >= ${THRESH}%" >&2; exit 1
fi
# check load average < number of CPUs * 2
load=$(cat /proc/loadavg | awk '{print $1}')
cpus=$(nproc)
max=$(awk "BEGIN{print $cpus*2}")
awk -v l=$load -v m=$max 'BEGIN{if (l>m) {print "FAIL: load " l " > " m; exit 1} else {print "OK: load within invariants"}}'
