#!/usr/bin/env bash
set -euo pipefail

# ---------------- Config ----------------
SIGMA_PIPX_PKG="sigma-cli"
PYTHON_BIN="${PYTHON_BIN:-python3}"

info() { echo -e "[*] $*"; }
warn() { echo -e "[!] $*"; }
err()  { echo -e "[X] $*" >&2; exit 1; }
has_cmd() { command -v "$1" >/dev/null 2>&1; }

# --------------- Find repo root ---------------
find_repo_root() {
  local d
  d="$(pwd)"
  while true; do
    if [ -d "$d/.git" ]; then
      echo "$d"
      return 0
    fi
    if [ "$d" = "/" ]; then
      return 1
    fi
    d="$(dirname "$d")"
  done
}

# --------------- Install sigma-cli if needed ---------------
ensure_sigma() {
  if has_cmd sigma; then
    info "sigma already installed: $(sigma --version 2>/dev/null || true)"
    info "sigma path: $(command -v sigma || true)"
    return 0
  fi

  info "sigma not found. Installing prerequisites and sigma-cli..."

  if ! has_cmd "$PYTHON_BIN"; then
    err "Python3 not found. Install Python 3.9+ (recommended 3.10+), then rerun."
  fi

  if ! "$PYTHON_BIN" -m pip --version >/dev/null 2>&1; then
    err "pip is not available for $PYTHON_BIN. Fix pip, then rerun."
  fi

  # Prefer pipx (isolated install)
  if ! has_cmd pipx; then
    info "pipx not found. Installing pipx (user install)..."
    "$PYTHON_BIN" -m pip install --user -U pipx
    "$PYTHON_BIN" -m pipx ensurepath >/dev/null 2>&1 || true
    export PATH="$HOME/.local/bin:$PATH"
    [ -f "$HOME/.profile" ] && source "$HOME/.profile" || true
  fi

  if has_cmd pipx; then
    info "Installing sigma-cli with pipx..."
    pipx install "$SIGMA_PIPX_PKG" >/dev/null 2>&1 || pipx upgrade "$SIGMA_PIPX_PKG" >/dev/null 2>&1 || true
    export PATH="$HOME/.local/bin:$PATH"
  else
    warn "pipx still not available. Falling back to pip --user install."
    "$PYTHON_BIN" -m pip install --user -U "$SIGMA_PIPX_PKG"
    export PATH="$HOME/.local/bin:$PATH"
  fi

  if has_cmd sigma; then
    info "sigma installed: $(sigma --version 2>/dev/null || true)"
    info "sigma path: $(command -v sigma || true)"
  else
    warn "sigma command still not found in PATH; module fallback will be used."
  fi
}

# --------------- Collect all Sigma rule files ---------------
collect_rule_files() {
  local repo_root="$1"
  local out_file="$2"

  find "$repo_root" \
    -type d \( -name .git -o -name .venv -o -name venv -o -name __pycache__ -o -name node_modules \) -prune -o \
    -type f \( -path "*/rules/*.yml" -o -path "*/rules/*.yaml" \) -print0 \
    | sort -z > "$out_file"
}

# --------------- Main ---------------
ensure_sigma

repo_root="$(find_repo_root 2>/dev/null || true)"
if [ -z "${repo_root:-}" ]; then
  err "Git repo root not found (.git). Run this script inside your sigma-rules repository."
fi

tmp_list="$(mktemp)"
trap 'rm -f "$tmp_list"' EXIT

collect_rule_files "$repo_root" "$tmp_list"

rule_count="$(
python3 - "$tmp_list" <<'PY'
import sys
p = sys.argv[1]
data = open(p, "rb").read()
items = [x for x in data.split(b"\0") if x]
print(len(items))
PY
)"

if [ "$rule_count" -eq 0 ]; then
  err "No Sigma rule files found under */rules/*.yml or */rules/*.yaml (repo: $repo_root)"
fi

info "Found $rule_count Sigma rule files under */rules/ (repo: $repo_root)"

if has_cmd sigma; then
  info "Running: sigma check <all rule files>"
  xargs -0 sigma check < "$tmp_list"
else
  warn "sigma not in PATH. Using python module fallback..."
  xargs -0 "$PYTHON_BIN" -m sigma.cli.main check < "$tmp_list"
fi

info "Done."
