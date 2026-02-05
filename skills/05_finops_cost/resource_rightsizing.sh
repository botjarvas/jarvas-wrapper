#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - resource_rightsizing
# Heuristic: find containers using < 10% CPU and < 50MB memory over short sample (docker required)
if ! command -v docker >/dev/null 2>&1; then echo "Docker not installed; skipping"; exit 0; fi
candidates=()
while read -r id; do
  stats=$(docker stats --no-stream --format "{{.CPUPerc}} {{.MemUsage}}" $id)
  cpu=$(echo $stats | awk '{print $1}' | tr -d '%')
  mem=$(echo $stats | awk '{print $2}' | sed 's/[^0-9.]//g')
  mem_unit=$(echo $stats | awk '{print $2}' | sed 's/[0-9.]//g')
  mem_mb=$mem
  case "$mem_unit" in
    GiB) mem_mb=$(awk "BEGIN{print $mem*1024}");;
    KiB) mem_mb=$(awk "BEGIN{print $mem/1024}");;
  esac
  cpu_int=${cpu%.*}
  if (( cpu_int < 10 )) && (( mem_mb < 50 )); then
    echo "Candidate for rightsizing: container $id CPU ${cpu}% MEM ${mem_mb}MB"
    candidates+=("$id")
  fi
done < <(docker ps -q)
if (( ${#candidates[@]} > 0 )); then exit 1; fi
echo "OK: no obvious rightsizing candidates"
exit 0
