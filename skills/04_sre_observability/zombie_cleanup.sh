#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - zombie_cleanup
# Identify defunct (zombie) processes and show parent info
zombies=$(ps -eo pid,stat,ppid,cmd | awk '$2=="Z" {print $1":"$4":"$3}')
if [[ -z "$zombies" ]]; then
  echo "OK: no zombie (defunct) processes found"
  exit 0
fi
echo "FOUND zombie processes:"
echo "$zombies"

# show parent info
echo "\nParent process info (ppid -> cmd):"
for entry in $zombies; do
  pid=$(echo "$entry" | cut -d: -f1)
  ppid=$(echo "$entry" | cut -d: -f3)
  ps -p "$ppid" -o pid,cmd --no-headers || true
done
exit 1
