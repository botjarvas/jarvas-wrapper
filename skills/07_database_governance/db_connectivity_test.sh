#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - db_connectivity_test
# Usage: db_connectivity_test.sh host port
HOST=${1:-localhost}
PORT=${2:-5432}
if ! command -v nc >/dev/null 2>&1; then echo "nc not installed; cannot test TCP connectivity" >&2; exit 1; fi
if nc -z -w5 $HOST $PORT; then echo "OK: DB connectivity to $HOST:$PORT"; exit 0; else echo "FAIL: cannot connect to DB $HOST:$PORT" >&2; exit 1; fi
