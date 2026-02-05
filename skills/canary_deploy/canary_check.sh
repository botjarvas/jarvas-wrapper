#!/usr/bin/env bash
set -euo pipefail
# Canary deploy check: verify Docker and service status
echo "Starting execution: canary_check"
if command -v docker >/dev/null 2>&1; then
  echo "Docker status:"
  docker --version || true
  docker ps --format '{{.Names}}: {{.Status}}' || true
else
  echo "Docker not installed"
fi
if systemctl list-units --type=service >/dev/null 2>&1; then
  echo "Listing active services (sample):"
  systemctl list-units --type=service --state=running | head -n 20 || true
fi
echo "Completed: canary_check"
