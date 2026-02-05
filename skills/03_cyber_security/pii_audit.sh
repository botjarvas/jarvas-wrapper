#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - pii_audit
ROOT=${1:-.}
# Simple patterns for SSN-like and email addresses in data files
fail=0
if grep -RIn --exclude-dir=.git -E "[0-9]{3}-[0-9]{2}-[0-9]{4}" "$ROOT"; then echo "FOUND: SSN-like pattern" >&2; fail=1; fi
if grep -RIn --exclude-dir=.git -E "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}" "$ROOT"; then echo "FOUND: email-like pattern" >&2; fail=1; fi
if (( fail )); then echo "PII AUDIT FAILED" >&2; exit 1; fi
echo "OK: no obvious PII patterns found under $ROOT"
exit 0
