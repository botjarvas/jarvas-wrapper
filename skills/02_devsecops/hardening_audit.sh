#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - hardening_audit
# Checks: PermitRootLogin, PasswordAuthentication in sshd_config
sshd_conf=/etc/ssh/sshd_config
if [[ ! -f "$sshd_conf" ]]; then echo "ERROR: sshd_config not found" >&2; exit 1; fi
root_login=$(grep -Ei '^\s*PermitRootLogin' $sshd_conf | awk '{print $2}' | tr -d '\r' || true)
pass_auth=$(grep -Ei '^\s*PasswordAuthentication' $sshd_conf | awk '{print $2}' | tr -d '\r' || true)
bad=0
if [[ -z "$root_login" ]]; then echo "WARN: PermitRootLogin not set (check default)"; else
  if [[ "$root_login" =~ ^(yes|prohibit-password)$ ]]; then
    echo "FAIL: PermitRootLogin is $root_login" >&2; bad=1
  fi
fi
if [[ -z "$pass_auth" ]]; then echo "WARN: PasswordAuthentication not set (check default)"; else
  if [[ "$pass_auth" =~ ^yes$ ]]; then
    echo "FAIL: PasswordAuthentication is enabled" >&2; bad=1
  fi
fi
if (( bad )); then echo "HARDENING AUDIT FAILED" >&2; exit 1; fi
echo "OK: sshd_config hardening checks passed"
exit 0
