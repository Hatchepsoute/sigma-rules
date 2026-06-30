#!/usr/bin/env bash
# ============================================================
# convert_to_qradar.sh
# Generates IBM QRadar queries from Sigma rules.
#
# Native AQL output requires sigma-cli 2.x + qradar plugin.
# Both QRadar plugins (qradar, ibm-qradar-aql) are Compatible=no
# with sigma-cli 3.x - they were written for the 2.x API.
#
# This script:
#   1. Checks the installed sigma-cli version.
#   2. If sigma 2.x with a compatible qradar plugin: converts to AQL.
#   3. If sigma 3.x (or plugin not available): generates a Lucene
#      fallback usable via QRadar on Cloud or Elasticsearch integration.
#
# Usage:
#   ./convert_to_qradar.sh [OPTIONS]
#
# Options:
#   --upgrade
#       Print upgrade instructions and exit (no conversion)
#   --force-lucene
#       Skip version check and always generate Lucene fallback
#   --input PATH
#       Restrict to a specific CVE folder or rule file
#   --show
#       Print per-group summary at the end
#   -h, --help
#       Show this help
#
# Output (Lucene fallback):  scripts/conversions/QRadar_Lucene_Fallback/
# Output (AQL, if sigma 3.x): scripts/conversions/QRadar_AQL/
# ============================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT_DIR"

shopt -s globstar nullglob

# ─────────────────────────────────────────────
# Defaults
# ─────────────────────────────────────────────
INPUT_PATH=""
SHOW=0
FORCE_LUCENE=0
UPGRADE_ONLY=0

usage() {
  grep '^#' "$0" | grep -v '^#!/' | sed 's/^# \?//'
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --upgrade)     UPGRADE_ONLY=1; shift ;;
    --force-lucene) FORCE_LUCENE=1; shift ;;
    --input)       INPUT_PATH="$2"; shift 2 ;;
    --show)        SHOW=1; shift ;;
    -h|--help)     usage ;;
    *) echo "[!] Unknown argument: $1"; usage ;;
  esac
done

# ─────────────────────────────────────────────
# AQL availability notice (shown when native AQL is not possible)
# ─────────────────────────────────────────────
print_aql_notice() {
  cat << 'EOF'

  ┌──────────────────────────────────────────────────────────────┐
  │  Native AQL output not available with sigma-cli 3.x          │
  │                                                              │
  │  Both QRadar plugins (qradar, ibm-qradar-aql) are marked    │
  │  Compatible = no with sigma-cli 3.x. They were written for   │
  │  the sigma-cli 2.x API and have not yet been ported.         │
  │                                                              │
  │  Options to get native AQL output:                           │
  │                                                              │
  │  Option A - Use sigma-cli 2.x in a separate virtualenv:      │
  │                                                              │
  │       python3 -m venv .venv-sigma2                           │
  │       source .venv-sigma2/bin/activate                       │
  │       pip install "sigma-cli<3"                              │
  │       sigma plugin install qradar                           │
  │       sigma convert -t qradar <rule.yml>                    │
  │                                                              │
  │  Option B - Wait for IBM to release a sigma 3.x-compatible   │
  │  plugin. Check: sigma plugin list | grep -i qradar           │
  │  When Compatible = yes, re-run this script.                  │
  │                                                              │
  │  In the meantime, a Lucene fallback is generated below.      │
  │  These queries can be used via:                              │
  │    - QRadar on Cloud: native Elasticsearch backend           │
  │    - QRadar + Elasticsearch/OpenSearch integration           │
  │    - Manual translation to AQL (see QRADAR_USAGE.md)        │
  └──────────────────────────────────────────────────────────────┘

EOF
}

if [[ "$UPGRADE_ONLY" -eq 1 ]]; then
  SIGMA_VER=$(sigma version 2>/dev/null | awk '{print $1}')
  echo "[i] Installed sigma-cli: $SIGMA_VER"
  echo "[i] QRadar plugin status:"
  sigma plugin list 2>/dev/null | grep -i qradar || echo "    (no qradar plugin installed)"
  print_aql_notice
  exit 0
fi

# ─────────────────────────────────────────────
# Version check
# sigma 2.x + qradar plugin = AQL output
# sigma 3.x                 = Compatible=no → Lucene fallback
# ─────────────────────────────────────────────
SIGMA_VER=$(sigma version 2>/dev/null | awk '{print $1}')
SIGMA_MAJOR=$(echo "$SIGMA_VER" | cut -d. -f1)

echo "[*] convert_to_qradar.sh - sigma-cli $SIGMA_VER"

AQL_TARGET=""
if [[ "$FORCE_LUCENE" -eq 1 ]]; then
  BACKEND_MODE="lucene"
elif [[ "$SIGMA_MAJOR" -le 2 ]]; then
  # sigma 2.x: qradar plugins are compatible
  if sigma plugin list 2>/dev/null | grep -qE "(qradar|ibm-qradar-aql).*\|\s*yes"; then
    AQL_TARGET=$(sigma plugin list 2>/dev/null \
      | grep -E "(qradar|ibm-qradar-aql).*\|\s*yes" \
      | awk -F'|' '{gsub(/ /,"",$2); print $2}' | head -1)
    echo "[*] QRadar backend available: $AQL_TARGET"
    BACKEND_MODE="aql"
  else
    echo "[!] sigma 2.x detected but no compatible qradar plugin found."
    echo "    Install one with: sigma plugin install qradar"
    print_aql_notice
    BACKEND_MODE="lucene"
  fi
else
  # sigma 3.x: both qradar plugins are Compatible=no
  echo "[!] sigma-cli $SIGMA_VER: QRadar plugins are Compatible=no with sigma 3.x."
  print_aql_notice
  BACKEND_MODE="lucene"
fi

# ─────────────────────────────────────────────
# Collect rules
# ─────────────────────────────────────────────
if [[ -n "$INPUT_PATH" ]]; then
  if [[ -f "$INPUT_PATH" ]]; then
    RULES=("$INPUT_PATH")
  elif [[ -d "$INPUT_PATH" ]]; then
    mapfile -d '' RULES < <(find "$INPUT_PATH" -path "*/rules/*.yml" -print0 2>/dev/null)
  else
    echo "[!] --input path not found: $INPUT_PATH"
    exit 1
  fi
else
  RULES=(**/rules/*.yml)
fi

if [[ ${#RULES[@]} -eq 0 ]]; then
  echo "[!] No Sigma rules found."
  exit 1
fi

echo "[*] Rules found: ${#RULES[@]}"

# ─────────────────────────────────────────────
# Set output directory and target
# ─────────────────────────────────────────────
if [[ "$BACKEND_MODE" == "aql" ]]; then
  OUTROOT="$SCRIPT_DIR/conversions/QRadar_AQL"
  TARGET="$AQL_TARGET"
  WIN_PIPELINE="sysmon"
  echo "[*] Mode: AQL - output → $OUTROOT"
else
  OUTROOT="$SCRIPT_DIR/conversions/QRadar_Lucene_Fallback"
  TARGET="opensearch_lucene"
  WIN_PIPELINE="sysmon"
  echo "[*] Mode: Lucene fallback - output → $OUTROOT"
fi

mkdir -p "$OUTROOT"

# ─────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────
safe_name() {
  echo "$1" | sed 's#^\./##; s#/#__#g; s#\.yml$##'
}

to_one_line() {
  sed ':a;N;$!ba;s/\r//g;s/\n/ /g' | \
    sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//'
}

convert_rule() {
  local rule="$1"
  local outdir="$2"
  local pipeline="$3"

  local fname
  fname="$(safe_name "$rule")"
  local out_raw="$outdir/raw/${fname}.txt"
  local out_one="$outdir/one-line/${fname}.txt"

  mkdir -p "$outdir/raw" "$outdir/one-line"

  local pipeline_args=()
  if [[ -n "$pipeline" ]]; then
    pipeline_args=("-p" "$pipeline")
  fi

  local stderr_tmp
  stderr_tmp="$(mktemp)"
  sigma convert -t "$TARGET" "${pipeline_args[@]}" "$rule" \
    > "$out_raw" 2>"$stderr_tmp" || true

  if [[ -s "$out_raw" ]]; then
    to_one_line < "$out_raw" > "$out_one"
    rm -f "$stderr_tmp"
    return 0
  else
    cat "$stderr_tmp" >> "$out_raw"
    rm -f "$stderr_tmp"
    echo "    [skip] no output: $(basename "$rule")"
    return 1
  fi
}

# ─────────────────────────────────────────────
# Classify and convert each rule
# ─────────────────────────────────────────────
declare -A COUNTERS=([windows]=0 [web]=0 [linux]=0 [other]=0)
declare -A ERRORS=([windows]=0 [web]=0 [linux]=0 [other]=0)

echo "[*] Converting..."

for r in "${RULES[@]}"; do
  [[ ! -f "$r" ]] && continue

  if grep -qE "^\s+product: windows" "$r"; then
    group="windows"
    pipeline="$WIN_PIPELINE"
    outdir="$OUTROOT/Windows"
  elif grep -qE "^\s+product: linux" "$r"; then
    group="linux"
    pipeline="sysmon"
    outdir="$OUTROOT/Linux"
  elif grep -qE "^\s+category: webserver|^\s+category: firewall|^\s+category: proxy|^\s+category: dns|^\s+product: fortinet|^\s+product: palo_alto|^\s+product: hpe" "$r"; then
    group="web"
    pipeline="sysmon"
    outdir="$OUTROOT/Web_Network"
  else
    group="other"
    pipeline="sysmon"
    outdir="$OUTROOT/Other"
  fi

  if convert_rule "$r" "$outdir" "$pipeline"; then
    COUNTERS[$group]=$((${COUNTERS[$group]}+1))
  else
    ERRORS[$group]=$((${ERRORS[$group]}+1))
  fi
done

# ─────────────────────────────────────────────
# QRadar usage guide
# ─────────────────────────────────────────────
if [[ "$BACKEND_MODE" == "lucene" ]]; then
  cat > "$OUTROOT/QRADAR_USAGE.md" << 'EOF'
# Using these queries in QRadar (Lucene fallback)

These queries were generated with the `opensearch_lucene` backend.
Native AQL output is not available because both QRadar plugins
(qradar, ibm-qradar-aql) are Compatible=no with sigma-cli 3.x.
They were written for the sigma-cli 2.x API.

Run `./convert_to_qradar.sh --upgrade` to see the options.

## Using Lucene queries in QRadar

### Option 1 - QRadar on Cloud (QRoC)
QRadar on Cloud uses an Elasticsearch backend. Lucene queries
can be used directly in the QRoC search interface.

### Option 2 - QRadar + Elasticsearch/OpenSearch integration
If you forward events to an OpenSearch or Elasticsearch cluster
alongside QRadar (common with Wazuh or Logstash):
1. Use the Lucene queries from `raw/` in OpenSearch Dashboards.
2. Correlate with QRadar offenses via source IP or host name.

### Option 3 - Manual AQL translation
The Lucene query syntax translates approximately to AQL as follows:

| Lucene                                     | QRadar AQL                                      |
| :----------------------------------------- | :---------------------------------------------- |
| `process.executable:*cmd.exe`              | `"process_path" ILIKE '%cmd.exe'`               |
| `process.command_line:*-enc*`              | `"command_args" ILIKE '%-enc%'`                 |
| `winlog.event_id:4688`                     | `"EventID" = '4688'`                            |
| `event.category:process`                   | `devicetype = <Windows log source ID>`          |
| `A AND B`                                  | `A AND B`                                       |
| `A OR B`                                   | `(A OR B)`                                      |
| `NOT A`                                    | `NOT A`                                         |

AQL structure:
```sql
SELECT * FROM events WHERE
  <translated condition>
  START '%s' STOP '%s'
```

## To get native AQL output

Option A - sigma-cli 2.x in a separate virtualenv:
```bash
python3 -m venv .venv-sigma2
source .venv-sigma2/bin/activate
pip install "sigma-cli<3"
sigma plugin install qradar
sigma convert -t qradar <rule.yml>
```

Option B - wait for IBM to publish a sigma 3.x-compatible plugin:
```bash
sigma plugin list | grep -i qradar   # watch for Compatible = yes
```
EOF
else
  cat > "$OUTROOT/QRADAR_USAGE.md" << 'EOF'
# Using AQL queries in QRadar

These queries were generated with the `qradar` backend and are
formatted as IBM QRadar AQL (Ariel Query Language).

## Import into QRadar

### Option 1 - Log Activity search
1. Open QRadar → Log Activity → Advanced Search
2. Paste the AQL query from `raw/`
3. Adjust the time range (START / STOP clauses)

### Option 2 - Custom Rule Engine (CRE)
1. QRadar → Offenses → Rules → Add Rule
2. Choose "Event" rule type
3. In the test condition, use "when an event matches" and build a
   Filter from the AQL WHERE clause.

### Option 3 - Reference Set rule
For rules that match on a list of values (contains), consider
populating a QRadar Reference Set and using "when an event matches
a reference set" rule condition.

## Field mapping notes

QRadar field names depend on the Log Source Extension (LSE) and
the Device Support Module (DSM) used for parsing. Common mappings:

| AQL generated field       | Typical QRadar normalized field       |
| :------------------------ | :------------------------------------ |
| `process_path`            | Application Name / Custom field (DSM) |
| `command_args`            | Source Payload / Command              |
| `sourceip`                | Source IP                             |
| `destinationip`           | Destination IP                        |
| `destinationport`         | Destination Port                      |
| `EventID`                 | Custom property (Windows DSM)         |
| `username`                | Username                              |

Adapt field names to match your QRadar DSM configuration and
custom property definitions.
EOF
fi

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────
total_ok=$(( ${COUNTERS[windows]} + ${COUNTERS[web]} + ${COUNTERS[linux]} + ${COUNTERS[other]} ))
total_err=$(( ${ERRORS[windows]} + ${ERRORS[web]} + ${ERRORS[linux]} + ${ERRORS[other]} ))

echo
echo "────────────────────────────────────────────────────"
echo "  QRadar conversion - summary (mode: $BACKEND_MODE)"
echo "────────────────────────────────────────────────────"
printf "  %-30s %4d OK  %4d skipped\n" "Windows (pipeline: $WIN_PIPELINE)" "${COUNTERS[windows]}" "${ERRORS[windows]}"
printf "  %-30s %4d OK  %4d skipped\n" "Web / Network" "${COUNTERS[web]}" "${ERRORS[web]}"
printf "  %-30s %4d OK  %4d skipped\n" "Linux" "${COUNTERS[linux]}" "${ERRORS[linux]}"
printf "  %-30s %4d OK  %4d skipped\n" "Other" "${COUNTERS[other]}" "${ERRORS[other]}"
echo "  ──────────────────────────────────────────────"
printf "  %-30s %4d OK  %4d skipped\n" "TOTAL" "$total_ok" "$total_err"
echo
echo "  Output : $OUTROOT"
echo "  Guide  : $OUTROOT/QRADAR_USAGE.md"

if [[ "$BACKEND_MODE" == "lucene" ]]; then
  echo
  echo "  [!] Lucene fallback - to get real AQL output:"
  echo "      ./scripts/convert_to_qradar.sh --upgrade"
fi

if [[ "$SHOW" -eq 1 ]]; then
  echo
  echo "  Generated files:"
  find "$OUTROOT" -name "*.txt" | sort | sed 's/^/    /'
fi

echo "────────────────────────────────────────────────────"
