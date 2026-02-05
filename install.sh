#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR=$(pwd)
. .env.example || true
mkdir -p "${CONFIG_DIR:-$ROOT_DIR/config}" "${RUNS_DIR:-$ROOT_DIR/runs}" "${DATA_DIR:-$ROOT_DIR/data}"
cat > ${CONFIG_DIR:-config}/config.yaml <<YAML
control_url: ${CONTROL_URL:-http://localhost:5000}
agent_port: ${AGENT_PORT:-8081}
YAML
echo "Wrote config to ${CONFIG_DIR:-config}/config.yaml"
