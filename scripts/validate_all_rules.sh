#!/bin/bash
set -euo pipefail

# Resolve repo root (script executed from scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT_DIR"

shopt -s globstar nullglob

RULES=(**/rules/*.yml)

echo "[*] Sigma syntax validation"
sigma check "${RULES[@]}"

