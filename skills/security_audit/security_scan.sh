#!/usr/bin/env bash
set -euo pipefail
# Basic security audit: SSH and open ports (using ss/netstat)
echo "Starting execution: security_scan"
if command -v ss >/dev/null 2>&1; then
  echo "Listening ports (ss -tuln):"
  ss -tuln || true
else
  echo "ss not available; try netstat"
  netstat -tuln || true
fi
if [ -f /etc/ssh/sshd_config ]; then
  echo "ssh_config summary:"
  grep -E 'PermitRootLogin|PasswordAuthentication' /etc/ssh/sshd_config || true
fi
echo "Completed: security_scan"
