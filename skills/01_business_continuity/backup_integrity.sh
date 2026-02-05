#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - backup_integrity
# Verify backup files exist and check checksum if provided
BACKUP_DIR=${1:-/var/backups}
PATTERN=${2:-"*.tar.gz"}
if [[ ! -d "$BACKUP_DIR" ]]; then echo "FAIL: backup dir $BACKUP_DIR not found" >&2; exit 1; fi
files=$(find "$BACKUP_DIR" -maxdepth 1 -type f -name "$PATTERN" -printf "%p\n" | sort -r)
if [[ -z "$files" ]]; then echo "FAIL: no backup files found in $BACKUP_DIR matching $PATTERN" >&2; exit 1; fi
# check latest file age
latest=$(echo "$files" | head -n1)
age=$(( ( $(date +%s) - $(stat -c %Y "$latest") ) / 86400 ))
if (( age > 30 )); then echo "FAIL: latest backup $latest is $age days old" >&2; exit 1; fi
# optional checksum verification if .sha256 exists
if [[ -f "$latest.sha256" ]]; then
  (cd "$BACKUP_DIR" && sha256sum -c "$(basename $latest).sha256") || (echo "FAIL: checksum mismatch for $latest" >&2; exit 1)
fi
echo "OK: backup integrity checks passed for $latest"
exit 0
