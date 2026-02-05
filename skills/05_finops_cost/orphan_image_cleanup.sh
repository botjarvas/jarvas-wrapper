#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - orphan_image_cleanup (dry-run report)
if ! command -v docker >/dev/null 2>&1; then echo "Docker not installed; skipping"; exit 0; fi
# List dangling images
dangling=$(docker images -f dangling=true -q || true)
if [[ -z "$dangling" ]]; then
  echo "OK: no dangling images"
  exit 0
fi
echo "Dangling images found:" >&2
docker images -f dangling=true
# Do not delete automatically; require --apply
if [[ "${1:-}" == "--apply" ]]; then
  docker image prune -f
  echo "Pruned dangling images"
else
  echo "Run with --apply to remove (dry-run)"
  exit 1
fi
