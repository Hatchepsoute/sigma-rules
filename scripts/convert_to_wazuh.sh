#!/usr/bin/env bash
# ============================================================
# convert_to_wazuh.sh
# Generates Lucene/OpenSearch queries for Wazuh from all Sigma rules
# in this repository.
#
# Compatible with sigma-cli 3.x (target: opensearch_lucene)
#
# Applies the correct pipeline per logsource category:
#   product: windows       ->  --pipeline sysmon (or --windows-pipeline windows)
#   product: linux         ->  --pipeline sysmon (pass-through, required by opensearch_lucene)
#   category: webserver,
#   category: firewall,
#   category: proxy, etc.  ->  --pipeline sysmon (pass-through, required by opensearch_lucene)
#   other                  ->  --pipeline sysmon (pass-through, required by opensearch_lucene)
#
# Note: opensearch_lucene requires a pipeline for every rule (Processing Pipeline Required = Yes).
# The sysmon pipeline acts as a no-op / pass-through for non-Windows logsources.
#
# Usage:
#   ./convert_to_wazuh.sh [OPTIONS]
#
# Options:
#   --windows-pipeline [sysmon|windows]
#       Pipeline to apply for Windows rules (default: sysmon)
#       Use 'sysmon' if your Wazuh agents use the Sysmon integration
#       Use 'windows' if you rely on native Windows Security Event logs
#   --input PATH
#       Restrict conversion to a specific CVE folder or rule file
#       (default: entire repository)
#   --show
#       Print per-group summary at the end
#   -h, --help
#       Show this help
#
# Output: scripts/conversions/Wazuh/
# ============================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT_DIR"

shopt -s globstar nullglob

# ─────────────────────────────────────────────
# Defaults
# ─────────────────────────────────────────────
WIN_PIPELINE="sysmon"
INPUT_PATH=""
SHOW=0

usage() {
  grep '^#' "$0" | grep -v '^#!/' | sed 's/^# \?//'
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --windows-pipeline)
      WIN_PIPELINE="$2"
      if [[ "$WIN_PIPELINE" != "sysmon" && "$WIN_PIPELINE" != "windows" ]]; then
        echo "[!] --windows-pipeline must be 'sysmon' or 'windows'"
        exit 1
      fi
      shift 2
      ;;
    --input)
      INPUT_PATH="$2"
      shift 2
      ;;
    --show) SHOW=1; shift ;;
    -h|--help) usage ;;
    *) echo "[!] Unknown argument: $1"; usage ;;
  esac
done

OUTROOT="$SCRIPT_DIR/conversions/Wazuh"

# ─────────────────────────────────────────────
# Collect rules
# ─────────────────────────────────────────────
if [[ -n "$INPUT_PATH" ]]; then
  if [[ -f "$INPUT_PATH" ]]; then
    RULES=("$INPUT_PATH")
  elif [[ -d "$INPUT_PATH" ]]; then
    RULES=("$INPUT_PATH"/**/rules/*.yml "$INPUT_PATH"/rules/*.yml)
    # Remove duplicates / non-existing
    RULES=($(printf '%s\n' "${RULES[@]}" | sort -u | xargs -I{} sh -c 'test -f {} && echo {}'))
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

echo "[*] convert_to_wazuh.sh - sigma-cli $(sigma version 2>/dev/null | awk '{print $1}')"
echo "[*] Windows pipeline : $WIN_PIPELINE"
echo "[*] Rules found      : ${#RULES[@]}"
echo "[*] Output           : $OUTROOT"
echo

mkdir -p "$OUTROOT"

# ─────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────
safe_name() {
  # CVE-2025-xxxx/rules/my_rule.yml -> CVE-2025-xxxx__my_rule
  echo "$1" | sed 's#^\./##; s#/#__#g; s#\.yml$##'
}

to_one_line() {
  sed ':a;N;$!ba;s/\r//g;s/\n/ /g' | \
    sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//'
}

convert_rule() {
  local rule="$1"
  local outdir="$2"
  local pipeline="$3"   # empty = no pipeline

  local fname
  fname="$(safe_name "$rule")"
  local out_raw="$outdir/raw/${fname}.txt"
  local out_one="$outdir/one-line/${fname}.txt"

  mkdir -p "$outdir/raw" "$outdir/one-line"

  local pipeline_args=()
  if [[ -n "$pipeline" ]]; then
    pipeline_args=("-p" "$pipeline")
  fi

  # Capture stdout (query) and stderr (warnings) separately
  local stderr_tmp
  stderr_tmp="$(mktemp)"
  sigma convert -t opensearch_lucene "${pipeline_args[@]}" "$rule" \
    > "$out_raw" 2>"$stderr_tmp" || true

  # Success = output file has content (query produced), regardless of exit code.
  # sigma-cli exits non-zero with a warning when no pipeline mapping exists,
  # but still writes a valid Lucene query to stdout.
  if [[ -s "$out_raw" ]]; then
    to_one_line < "$out_raw" > "$out_one"
    rm -f "$stderr_tmp"
    return 0
  else
    # Empty output = real failure (unsupported logsource or syntax error)
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

echo "[*] Classifying and converting..."

for r in "${RULES[@]}"; do
  [[ ! -f "$r" ]] && continue

  if grep -qE "^\s+product: windows" "$r"; then
    group="windows"
    pipeline="$WIN_PIPELINE"
    outdir="$OUTROOT/Windows_${WIN_PIPELINE^}"
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
# Field mapping guide for Wazuh
# ─────────────────────────────────────────────
cat > "$OUTROOT/WAZUH_FIELD_MAPPING.md" << 'EOF'
# Field mapping guide for Wazuh

The Lucene queries in this folder use Sigma field names (or the ECS
field names produced by the `sysmon` pipeline). Wazuh stores event
data differently depending on version and pipeline configuration.
Adapt the field names in each query to match your Wazuh deployment.

## Windows rules (sysmon pipeline)

| Sigma / ECS field          | Wazuh 4.x + ECS module       | Wazuh < 4.x (raw agent)            |
| :------------------------- | :---------------------------- | :---------------------------------- |
| `process.executable`       | `winlog.event_data.Image`     | `data.win.eventdata.image`          |
| `process.command_line`     | `winlog.event_data.CommandLine` | `data.win.eventdata.commandLine`  |
| `process.parent.executable`| `winlog.event_data.ParentImage` | `data.win.eventdata.parentImage`  |
| `process.parent.command_line` | `winlog.event_data.ParentCommandLine` | `data.win.eventdata.parentCommandLine` |
| `winlog.channel`           | `winlog.channel`              | `data.win.system.channel`           |
| `winlog.event_id`          | `winlog.event_id`             | `data.win.system.eventID`           |
| `file.path`                | `winlog.event_data.TargetFilename` | `data.win.eventdata.targetFilename` |
| `registry.path`            | `winlog.event_data.TargetObject` | `data.win.eventdata.targetObject` |
| `user.name`                | `user.name`                   | `data.win.eventdata.user`           |
| `host.name`                | `agent.name`                  | `agent.name`                        |

## Windows rules (windows pipeline)

| Sigma field              | Wazuh / Windows Security log     |
| :----------------------- | :-------------------------------- |
| `SubjectUserName`        | `data.win.eventdata.subjectUserName` |
| `TargetUserName`         | `data.win.eventdata.targetUserName`  |
| `NewProcessName`         | `data.win.eventdata.newProcessName`  |
| `ProcessCommandLine`     | `data.win.eventdata.processCommandLine` |

## Web / network rules

These rules use the webserver / proxy / firewall logsource and are
converted without a pipeline. Field names in the output match the
Sigma generic names (`cs-uri-stem`, `cs-method`, `sc-status`).

If you ingest web logs into Wazuh via the filebeat/nginx module or
similar, adapt the field path prefix:
  - Nginx via Wazuh module: `data.nginx.*` or `nginx.access.*` (ECS)
  - Apache: `data.apache2.*` or `apache.access.*` (ECS)

## Linux rules

| Sigma field   | Wazuh / auditd field              |
| :------------ | :-------------------------------- |
| `Image`       | `data.audit.exe`                  |
| `CommandLine` | `data.audit.command`              |
| `User`        | `data.audit.auid` / `data.audit.uid` |

## How to use these queries in Wazuh

### Option 1 - OpenSearch Dashboards Discover
1. Open Wazuh → Threat Intelligence → Dashboards → Discover
2. Select the `wazuh-alerts-*` index pattern
3. Paste the Lucene query from `raw/` into the search bar
4. Adapt field names according to the mapping table above

### Option 2 - OpenSearch Alerting monitor
1. In OpenSearch Dashboards, go to Alerting → Monitors → Create monitor
2. Select "Per query monitor" and "Extraction query editor"
3. Use the query from `raw/` as the `query.query_string.query` value
4. Set the index to `wazuh-alerts-*`

### Option 3 - Wazuh custom rules (XML)
Sigma cannot generate Wazuh XML rules directly. The Lucene queries
in this folder serve as the detection logic reference. To write a
native Wazuh XML rule, use the query fields as `<field>` conditions
and refer to the Wazuh documentation on custom rules.

## Re-generating these queries

```bash
cd scripts
./convert_to_wazuh.sh
# Or for native Windows Security log field names:
./convert_to_wazuh.sh --windows-pipeline windows
# Or for a specific CVE pack:
./convert_to_wazuh.sh --input ../CVE-2025-XXXX_ProductName
```
EOF

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────
total_ok=$(( ${COUNTERS[windows]} + ${COUNTERS[web]} + ${COUNTERS[linux]} + ${COUNTERS[other]} ))
total_err=$(( ${ERRORS[windows]} + ${ERRORS[web]} + ${ERRORS[linux]} + ${ERRORS[other]} ))

echo
echo "────────────────────────────────────────────────────"
echo "  Wazuh conversion - summary"
echo "────────────────────────────────────────────────────"
printf "  %-30s %4d OK  %4d skipped\n" "Windows (pipeline: $WIN_PIPELINE)" "${COUNTERS[windows]}" "${ERRORS[windows]}"
printf "  %-30s %4d OK  %4d skipped\n" "Web / Network" "${COUNTERS[web]}" "${ERRORS[web]}"
printf "  %-30s %4d OK  %4d skipped\n" "Linux" "${COUNTERS[linux]}" "${ERRORS[linux]}"
printf "  %-30s %4d OK  %4d skipped\n" "Other" "${COUNTERS[other]}" "${ERRORS[other]}"
echo "  ──────────────────────────────────────────────"
printf "  %-30s %4d OK  %4d skipped\n" "TOTAL" "$total_ok" "$total_err"
echo
echo "  Output : $OUTROOT"
echo "  Guide  : $OUTROOT/WAZUH_FIELD_MAPPING.md"

if [[ "$SHOW" -eq 1 ]]; then
  echo
  echo "  Generated files:"
  find "$OUTROOT" -name "*.txt" | sort | sed 's/^/    /'
fi

echo "────────────────────────────────────────────────────"
