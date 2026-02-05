#!/usr/bin/env bash
set -euo pipefail
# Smart cleanup: remove temp files and docker system prune (non-destructive prompts skipped)
echo "Starting execution: smart_cleanup"
# remove temp files older than 7 days in /tmp (dry-run)
find /tmp -type f -mtime +7 -print | head -n 20 || true
# docker prune (only if docker exists)
if command -v docker >/dev/null 2>&1; then
  echo "Pruning docker system (dry-run):"
  docker system df || true
fi
echo "Completed: smart_cleanup"
