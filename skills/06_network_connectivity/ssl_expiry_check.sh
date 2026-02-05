#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - ssl_expiry_check
# Usage: ssl_expiry_check.sh <host:port> [threshold_days]
HOSTPORT=${1:-"localhost:443"}
THRESHOLD=${2:-30}

host=$(echo "$HOSTPORT" | cut -d: -f1)
port=$(echo "$HOSTPORT" | cut -d: -f2)
if [[ -z "$port" ]]; then port=443; fi

enddate=$(openssl s_client -servername "$host" -connect "$host:$port" -showcerts </dev/null 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | sed 's/notAfter=//')
if [[ -z "$enddate" ]]; then echo "ERROR: could not fetch certificate for $HOSTPORT"; exit 1; fi
endepoch=$(date -d "$enddate" +%s)
now=$(date +%s)
diff_days=$(( (endepoch - now) / 86400 ))
if (( diff_days < 0 )); then
  echo "CERT EXPIRED: $HOSTPORT expired $((-diff_days)) days ago"
  exit 1
fi
if (( diff_days < THRESHOLD )); then
  echo "CERT WARNING: $HOSTPORT expires in $diff_days days (< $THRESHOLD)"
  exit 1
fi
echo "OK: $HOSTPORT certificate valid for $diff_days days"
exit 0
