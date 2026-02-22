#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT_DIR"

echo "[*] Sigma syntax validation"

# Collect all yml/yaml under any rules/** (including rules/web, rules/host, etc.)
mapfile -d '' RULES < <(
  find . -type f \( -name '*.yml' -o -name '*.yaml' \) -path '*/rules/*' -print0
)

if (( ${#RULES[@]} == 0 )); then
  echo "[!] No Sigma rule files found under */rules/*"
  exit 0
fi

# 1) Fast path: run global check (keeps your current verbose output style)
if sigma check "${RULES[@]}"; then
  exit 0
fi

echo
echo "[!] Global sigma check failed. Locating the failing file..."

# 2) Fallback: identify the exact file causing the first error
for f in "${RULES[@]}"; do
  if ! sigma check "$f"; then
    echo
    echo "[FAIL] Offending file: $f"
    exit 1
  fi
done

# Should not reach here normally
echo "[!] Global failed but no individual failing file was found (unexpected)."
exit 1
