#!/usr/bin/env bash
set -euo pipefail
case "${1:-}" in
  agent)
    echo "Starting agent mode"
    # simple polling loop to /task
    CONTROL_URL=${CONTROL_URL:-http://localhost:5000}
    AGENT_ID=$(hostname)-agent
    while true; do
      curl -s -X GET "$CONTROL_URL/task" || true
      sleep 10
    done
    ;;
  run)
    shift || true
    echo "Run mode: $@"
    # fallback to original behaviour if present
    if command -v /bin/bash >/dev/null 2>&1; then
      echo "No run implementation here — this is a stub"
    fi
    ;;
  *)
    echo "Usage: $0 {agent|run} ..."
    exit 1
    ;;
esac
