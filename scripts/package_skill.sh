#!/usr/bin/env bash
set -euo pipefail
NAME=${1:-jarvas-skill}
VER=${2:-0.1.0}
OUT=${NAME}-${VER}.tar.gz
mkdir -p /tmp/package_build
cp -r README.md docs scripts /tmp/package_build/ || true
tar -czf "$OUT" -C /tmp/package_build .
echo "$OUT"
