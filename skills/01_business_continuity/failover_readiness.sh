#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - failover_readiness
# Checks if critical services are enabled and a failover target exists (simple checks)
SERVICES=("nginx" "postgresql" "sshd")
missing=0
for svc in "${SERVICES[@]}"; do
  if systemctl list-unit-files | grep -q "^${svc}\.service"; then
    enabled=$(systemctl is-enabled $svc 2>/dev/null || echo disabled)
    echo "$svc enabled: $enabled"
    if [[ "$enabled" != "enabled" ]]; then missing=1; fi
  else
    echo "WARN: service $svc not installed"; missing=1
  fi
done
# Check for known failover host file
if [[ ! -f /etc/jarvas/failover_hosts ]]; then
  echo "WARN: /etc/jarvas/failover_hosts missing"; missing=1
else
  echo "Found failover hosts file";
fi
if (( missing )); then echo "FAIL: failover readiness checks failed" >&2; exit 1; fi
echo "OK: failover readiness checks passed"
exit 0
