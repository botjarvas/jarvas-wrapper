#!/usr/bin/env bash
set -euo pipefail
# PixelX DevSecOps - ai_policy_check
# Heuristic checks for AI policy compliance in repo files: look for disallowed model endpoints or open API keys
ROOT=${1:-.}
fail=0
# check for model endpoint patterns (example: api.openai.com)
if grep -RIn --exclude-dir=.git -E "api\.openai\.com|huggingface\.co" "$ROOT"; then
  echo "FOUND: potential external AI model endpoint references" >&2; fail=1
fi
# check for keys patterns
if grep -RIn --exclude-dir=.git -E "sk-[A-Za-z0-9_-]{16,}" "$ROOT"; then
  echo "FOUND: potential OpenAI secret key pattern" >&2; fail=1
fi
if (( fail )); then echo "AI policy checks FAILED" >&2; exit 1; fi
echo "OK: AI policy heuristics passed"
exit 0
