#!/usr/bin/env bash
set -euo pipefail

# Operational runner for Jarvas Wrapper
# Modes:
#  - agent: simple polling agent (stub)
#  - run: execute command, collect artifacts and logs, emit summary.json

case "${1:-}" in
  agent)
    echo "Starting agent mode"
    CONTROL_URL=${CONTROL_URL:-http://localhost:5000}
    AGENT_ID=$(hostname)-agent
    while true; do
      curl -s -X GET "$CONTROL_URL/task" || true
      sleep 10
    done
    ;;

  run)
    shift || true
    ACTION=""
    RUN_ID=""
    COMMAND=""

    while [[ $# -gt 0 ]]; do
      case "$1" in
        --action)
          ACTION="$2"; shift 2;;
        --run-id)
          RUN_ID="$2"; shift 2;;
        --command)
          COMMAND="$2"; shift 2;;
        --)
          shift; break;;
        *)
          echo "Unknown argument: $1" >&2; exit 2;;
      esac
    done

    if [[ -z "$ACTION" ]]; then
      echo "--action is required" >&2
      exit 2
    fi
    if [[ -z "$RUN_ID" ]]; then
      RUN_ID="run-$(date -u +%Y%m%dT%H%M%SZ)"
    fi
    if [[ -z "$COMMAND" ]]; then
      echo "--command is required" >&2
      exit 2
    fi

    BASE_DIR="${RUNS_DIR:-$(pwd)/runs}/$RUN_ID"
    ARTIFACTS_DIR="$BASE_DIR/artifacts"
    LOGS_DIR="$BASE_DIR/logs"
    mkdir -p "$ARTIFACTS_DIR" "$LOGS_DIR"

    OUTPUT_RAW="$ARTIFACTS_DIR/output.raw"
    SUMMARY_JSON="$ARTIFACTS_DIR/summary.json"
    STEP_LOG="$LOGS_DIR/step_${ACTION}.log"

    echo "PHASE: STARTING_EXECUTION" | tee -a "$STEP_LOG"
    echo "Run ID: $RUN_ID" | tee -a "$STEP_LOG"
    echo "Action: $ACTION" | tee -a "$STEP_LOG"
    echo "Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee -a "$STEP_LOG"

    set +e
    # Execute command via eval for flexibility; capture output
    eval "$COMMAND" >"$OUTPUT_RAW" 2>&1
    RC=$?
    echo "--- COMMAND OUTPUT BEGIN ---" >> "$STEP_LOG"
    cat "$OUTPUT_RAW" >> "$STEP_LOG"
    echo "--- COMMAND OUTPUT END ---" >> "$STEP_LOG"

    if [[ $RC -eq 0 ]]; then
      STATUS="SUCCESS"
    else
      STATUS="FAILED"
    fi
    echo "PHASE: COMPLETED" | tee -a "$STEP_LOG"
    echo "EXIT:$RC" >> "$STEP_LOG"

    python3 - <<PY
import json,os
summary={'run_id': os.path.basename('$RUN_ID'),'action':'$ACTION','timestamp': '$(date -u +%Y-%m-%dT%H:%M:%SZ)','exit_code': $RC,'status':'$STATUS'}
with open('$SUMMARY_JSON','w') as f:
    json.dump(summary,f)
PY

    exit $RC
    ;;

  *)
    echo "Usage: $0 {agent|run --action ACTION --run-id RUN_ID --command '<cmd>'}"
    exit 1
    ;;
esac
