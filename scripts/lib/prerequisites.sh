#!/usr/bin/env bash
# scripts/lib/prerequisites.sh
#
# Sourced by conversion scripts to ensure sigma-cli and its plugins
# are installed before running any conversion.
#
# Usage:
#   source "$SCRIPT_DIR/lib/prerequisites.sh"
#   ensure_prerequisites opensearch sysmon windows   # plugin names needed
#
# What this does:
#   1. Checks Python 3.9+          (cannot auto-install, exits with instructions)
#   2. Installs pipx if missing    (via pip --user)
#   3. Installs sigma-cli if missing (via pipx)
#   4. For each plugin passed as argument: installs it if not already present

_prereq_info()  { echo "[*] $*"; }
_prereq_warn()  { echo "[!] $*"; }
_prereq_error() { echo "[X] $*" >&2; exit 1; }

# ─────────────────────────────────────────────
# Python 3.9+
# ─────────────────────────────────────────────
_ensure_python() {
  local py=""
  if command -v python3 >/dev/null 2>&1; then
    py="python3"
  elif command -v python >/dev/null 2>&1; then
    py="python"
  fi

  if [[ -z "$py" ]]; then
    _prereq_error "Python 3.9+ not found. Install Python first then rerun.
    Linux  : sudo apt install python3
    macOS  : brew install python3
    Windows: winget install Python.Python.3.12"
  fi

  local ver
  ver=$("$py" -c "import sys; print(sys.version_info.major * 10 + sys.version_info.minor)" 2>/dev/null || echo "0")
  if [[ "$ver" -lt 39 ]]; then
    _prereq_error "Python 3.9+ required (found $($py --version 2>&1)). Please upgrade."
  fi

  PYTHON_BIN="$py"
}

# ─────────────────────────────────────────────
# pipx
# ─────────────────────────────────────────────
_ensure_pipx() {
  if command -v pipx >/dev/null 2>&1; then
    return 0
  fi

  _prereq_info "pipx not found — installing via pip..."
  if ! "$PYTHON_BIN" -m pip install --user -U pipx 2>/dev/null; then
    _prereq_error "pip install pipx failed. Install pip first:
    sudo apt install python3-pip   # Debian/Ubuntu
    python3 -m ensurepip --upgrade # macOS / fallback"
  fi

  # Make pipx available in current session
  export PATH="$HOME/.local/bin:$PATH"
  "$PYTHON_BIN" -m pipx ensurepath >/dev/null 2>&1 || true

  if ! command -v pipx >/dev/null 2>&1; then
    _prereq_error "pipx installed but not found in PATH. Run: pipx ensurepath, restart terminal, then rerun."
  fi

  _prereq_info "pipx installed."
}

# ─────────────────────────────────────────────
# sigma-cli
# ─────────────────────────────────────────────
_ensure_sigma() {
  if command -v sigma >/dev/null 2>&1; then
    _prereq_info "sigma-cli $(sigma version 2>/dev/null | awk '{print $1}') found."
    return 0
  fi

  _prereq_info "sigma-cli not found — installing via pipx..."
  if ! pipx install sigma-cli 2>/dev/null; then
    _prereq_warn "pipx install failed — trying pipx upgrade..."
    pipx upgrade sigma-cli 2>/dev/null || true
  fi

  # pipx puts binaries in ~/.local/bin
  export PATH="$HOME/.local/bin:$PATH"

  if ! command -v sigma >/dev/null 2>&1; then
    _prereq_error "sigma-cli installed but 'sigma' command not found in PATH.
    Run: pipx ensurepath
    Then restart your terminal and rerun."
  fi

  _prereq_info "sigma-cli $(sigma version 2>/dev/null | awk '{print $1}') installed."
}

# ─────────────────────────────────────────────
# Plugin detection
# Maps plugin names to the artifact they expose.
# ─────────────────────────────────────────────
_plugin_installed() {
  local plugin="$1"
  local targets pipelines
  targets=$(sigma list targets 2>/dev/null)
  pipelines=$(sigma list pipelines 2>/dev/null)

  case "$plugin" in
    opensearch)    echo "$targets"   | grep -q "opensearch_lucene" ;;
    elasticsearch) echo "$targets"   | grep -q "^| lucene " ;;
    splunk)        echo "$targets"   | grep -q "^| splunk " ;;
    kusto)         echo "$targets"   | grep -q "^| kusto " ;;
    netwitness)    echo "$targets"   | grep -q "net_witness" ;;
    sysmon)        echo "$pipelines" | grep -qw "sysmon" ;;
    windows)       echo "$pipelines" | grep -q "windows-logsources" ;;
    *)             return 1 ;;
  esac
}

# ─────────────────────────────────────────────
# Install a single plugin if missing
# ─────────────────────────────────────────────
_ensure_plugin() {
  local plugin="$1"

  if _plugin_installed "$plugin"; then
    _prereq_info "Plugin '$plugin' already installed."
    return 0
  fi

  _prereq_info "Plugin '$plugin' not found — installing..."
  if sigma plugin install "$plugin" 2>/dev/null; then
    _prereq_info "Plugin '$plugin' installed."
  else
    _prereq_warn "sigma plugin install $plugin failed. Try manually: sigma plugin install $plugin"
  fi
}

# ─────────────────────────────────────────────
# Main entry point
# Usage: ensure_prerequisites [plugin1] [plugin2] ...
# ─────────────────────────────────────────────
ensure_prerequisites() {
  local plugins=("$@")

  echo "[*] Checking prerequisites..."

  _ensure_python
  _ensure_pipx
  _ensure_sigma

  if [[ ${#plugins[@]} -gt 0 ]]; then
    for p in "${plugins[@]}"; do
      _ensure_plugin "$p"
    done
  fi

  echo "[*] Prerequisites OK."
  echo ""
}
