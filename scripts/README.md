# Scripts — sigma rules automation

[Version française](README_FR.md)

This directory contains automation scripts for validating and converting the Sigma rules in this repository.

---

## Scripts overview

| Script | Platform | Purpose |
| :--- | :--- | :--- |
| [`validate_all_rules.sh`](validate_all_rules.sh) | Linux / macOS | Fast CI gate: validates all rules with `sigma check` |
| [`Linux_MacOS/validate_all_rules_portable.sh`](Linux_MacOS/validate_all_rules_portable.sh) | Linux / macOS | Portable version: auto-installs sigma-cli if missing |
| [`windows/validate_all_rules.ps1`](windows/validate_all_rules.ps1) | Windows (PowerShell) | Same as portable, for Windows environments |
| [`convert_all_rules.sh`](convert_all_rules.sh) | Linux / macOS | Converts all rules to 7 SIEM targets |
| [`convert_to_wazuh.sh`](convert_to_wazuh.sh) | Linux / macOS | Wazuh-specific conversion with logsource classification |
| [`convert_to_qradar.sh`](convert_to_qradar.sh) | Linux / macOS | QRadar conversion (Lucene fallback; see note below) |

---

## Requirements

sigma-cli 3.x, installed via pipx (recommended):

```bash
pipx install sigma-cli
```

Verify:

```bash
sigma version
sigma plugin list
```

The Bash scripts require Bash 4+ and Python 3.9+. The portable scripts (`validate_all_rules_portable.sh`, `validate_all_rules.ps1`) handle installation automatically.

---

## Validation

### `validate_all_rules.sh` — CI gate

Scans all `**/rules/*.yml` and `**/rules/*.yaml` files recursively and runs `sigma check` on them. Returns a non-zero exit code on failure. Designed for CI/CD pipelines.

```bash
bash scripts/validate_all_rules.sh
```

On success, sigma-cli may report MEDIUM-severity warnings (`InvalidATTACKTagIssue`) for some MITRE ATT&CK tags. These are non-blocking and expected for rules using custom or draft techniques.

### `Linux_MacOS/validate_all_rules_portable.sh` — local use

Same validation with automatic sigma-cli installation if missing. Run from anywhere inside the repository.

```bash
bash scripts/Linux_MacOS/validate_all_rules_portable.sh
```

See [`Linux_MacOS/README.md`](Linux_MacOS/README.md) for details.

### `windows/validate_all_rules.ps1` — Windows

PowerShell equivalent. Run from any directory inside the repository.

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\validate_all_rules.ps1
```

See [`windows/README.md`](windows/README.md) for details.

---

## Conversion

### `convert_all_rules.sh` — multi-SIEM

Converts all rules to 7 SIEM targets in a single run. Always run validation first.

```bash
bash scripts/validate_all_rules.sh
bash scripts/convert_all_rules.sh
```

Output is written to `scripts/conversions/<SIEM>/raw/` and `scripts/conversions/<SIEM>/one-line/`.

#### Conversion targets and pipelines

| Label | Target | Windows pipeline | Scope | Notes |
| :--- | :--- | :--- | :--- | :--- |
| `OpenSearch_ECS` | `opensearch_lucene` | `sysmon` | all rules | Required by backend |
| `Lucene_Sysmon` | `lucene` | `sysmon` | all rules | Required by backend |
| `Splunk_Windows` | `splunk` | `splunk_windows` | all rules | Required by backend |
| `Elastic_ElastAlert` | `elastalert` | `windows-logsources` | all rules | Required by backend |
| `Elastic_EQL` | `eql` | `sysmon` | all rules | Required by backend |
| `RSA_NetWitness` | `net_witness` | `sysmon` | Windows rules only | Pipeline optional |
| `Microsoft_Sentinel_KQL` | `kusto` | `sentinel_asim` | all rules | Fallback to `--without-pipeline` for web rules |

Backends marked "all rules" require a pipeline for every conversion regardless of logsource. The pipeline has no effect on Linux and web rules and simply satisfies the backend requirement.

For the `kusto` target, Windows and Linux rules produce proper ASIM KQL (table `imProcessCreate`, field `TargetProcessName`, etc.). Web rules that use field names not yet mapped in ASIM are retried automatically with `--without-pipeline`.

#### Output structure

```
scripts/conversions/
├── OpenSearch_ECS/
│   ├── raw/          <- exact sigma convert output
│   └── one-line/     <- same query collapsed to a single line
├── Lucene_Sysmon/
├── Splunk_Windows/
├── Elastic_ElastAlert/
├── Elastic_EQL/
├── RSA_NetWitness/
└── Microsoft_Sentinel_KQL/
```

One `.txt` file per Sigma rule. The filename encodes the rule path:

```
CVE-2025-21298_Windows_OLE_RTF_RCE__rules__proc_creation_win_office_rtf_ole_lolbin_strict.txt
```

Use `raw/` by default. Use `one-line/` only if your SIEM requires a single-line query string (some OpenSearch and Lucene-only parsers).

---

### `convert_to_wazuh.sh` — Wazuh / OpenSearch

Dedicated script for Wazuh. Classifies each rule by logsource before applying a pipeline, which avoids incorrect field mappings on Linux and web rules.

```bash
bash scripts/convert_to_wazuh.sh
bash scripts/convert_to_wazuh.sh --windows-pipeline windows   # Security log fields (EventID 4688)
bash scripts/convert_to_wazuh.sh --input CVE-2025-21298_Windows_OLE_RTF_RCE
bash scripts/convert_to_wazuh.sh --show
```

Output: `scripts/conversions/Wazuh/Windows_Sysmon/`, `Web_Network/`, `Linux/`, `Other/`.

See [`GUIDE_WAZUH_EN.md`](GUIDE_WAZUH_EN.md) for field mapping and Wazuh integration details.

---

### `convert_to_qradar.sh` — QRadar

Attempts to produce QRadar AQL queries. The `qradar` and `ibm-qradar-aql` plugins are currently marked `Compatible = no` with sigma-cli 3.x, so the script falls back to Lucene output, which can be used via QRadar on Cloud or via an Elasticsearch integration.

```bash
bash scripts/convert_to_qradar.sh
bash scripts/convert_to_qradar.sh --force-lucene
bash scripts/convert_to_qradar.sh --input CVE-2025-21298_Windows_OLE_RTF_RCE
bash scripts/convert_to_qradar.sh --upgrade      # print plugin status and exit
```

Output: `scripts/conversions/QRadar_Lucene_Fallback/` (current) or `scripts/conversions/QRadar_AQL/` (when plugins become compatible).

See [`GUIDE_QRADAR_EN.md`](GUIDE_QRADAR_EN.md) for QRadar integration details.

---

## SOC best practices

- Always validate before converting.
- Do not deploy rules that fail `sigma check`.
- Use `validate_all_rules.sh` as a blocking CI gate.
- Treat conversion outputs as production artifacts: review field name mappings before deployment.
- Run `sigma plugin list` after any sigma-cli upgrade to verify plugin compatibility.
