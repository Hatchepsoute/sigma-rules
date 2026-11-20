#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT_DIR"

# Prefer the repository-local Sigma CLI when available. This keeps validation
# reproducible when a system/pipx launcher points to a broken environment.
if [[ -x "$ROOT_DIR/.venv/bin/sigma" ]]; then
  export PATH="$ROOT_DIR/.venv/bin:$PATH"
fi

# Pre-flight: install sigma-cli if missing (no SIEM plugins needed for validation)
# shellcheck source=lib/prerequisites.sh
source "$SCRIPT_DIR/lib/prerequisites.sh"
ensure_prerequisites

echo "[*] Sigma syntax validation"

# Collect each rules directory. Passing directories keeps correlation rules and
# their referenced base rules in the same Sigma collection.
mapfile -d '' RULE_DIRS < <(
  find . -type d -path '*/rules' -print0
)

if (( ${#RULE_DIRS[@]} == 0 )); then
  echo "[!] No Sigma rule files found under */rules/*"
  exit 0
fi

# 1) Fast path: run global check (keeps your current verbose output style)
if sigma check "${RULE_DIRS[@]}"; then
  exit 0
fi

echo
echo "[!] Global sigma check failed. Locating the failing file..."

# 2) Fallback: identify the exact file causing the first error
for d in "${RULE_DIRS[@]}"; do
  if ! sigma check "$d"; then
    echo
    echo "[FAIL] Offending rules directory: $d"
    exit 1
  fi
done

# Should not reach here normally
echo "[!] Global failed but no individual failing file was found (unexpected)."
exit 1
