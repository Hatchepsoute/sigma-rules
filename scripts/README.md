# Scripts - sigma rules automation

[Version française](README_FR.md)

This directory contains scripts for validating and converting the Sigma rules in this repository into SIEM-ready query formats.

---

## Getting started - installation

### Step 1 - Python 3.9 or later

```bash
python3 --version
```

Install from your package manager if missing (`apt install python3`, `brew install python3`, etc.).

### Step 2 - pipx

```bash
pip install pipx
pipx ensurepath
```

Restart your terminal after running `pipx ensurepath`.

### Step 3 - sigma-cli 3.x

```bash
pipx install sigma-cli
sigma version        # should print 3.x.x
```

### Step 4 - sigma plugins

Install the plugins required by the conversion scripts:

```bash
sigma plugin install opensearch       # OpenSearch / Wazuh backend
sigma plugin install elasticsearch    # Elasticsearch / EQL / ES|QL / ElastAlert backends
sigma plugin install splunk           # Splunk SPL and SPL2 backend
sigma plugin install sysmon           # Sysmon pipeline (used by almost all conversions)
sigma plugin install windows          # Windows log source pipelines
sigma plugin install kusto            # Kusto/KQL backend + Sentinel, Defender XDR, Azure Monitor pipelines
sigma plugin install netwitness       # RSA NetWitness backend
```

Verify everything is installed:

```bash
sigma plugin list
sigma list targets
sigma list pipelines
```

### Step 5 (optional) - QRadar native AQL

Both QRadar plugins (`qradar`, `ibm-qradar-aql`) are **Compatible = no** with sigma-cli 3.x. Native AQL output requires sigma-cli 2.x in a separate virtualenv:

```bash
python3 -m venv .venv-sigma2
source .venv-sigma2/bin/activate
pip install "sigma-cli<3"
sigma plugin install qradar
sigma version                         # should print 2.x.x
```

When you want to use the virtualenv:

```bash
source .venv-sigma2/bin/activate
sigma convert -t qradar rules/my_rule.yml
deactivate
```

The script `convert_to_qradar.sh` detects the sigma-cli version automatically. Under sigma 3.x it generates a Lucene fallback. Under sigma 2.x with the qradar plugin it generates native AQL.

See [GUIDE_QRADAR_EN.md](GUIDE_QRADAR_EN.md) for full details.

---

## Scripts overview

| Script | Platform | Purpose |
| :--- | :--- | :--- |
| [`validate_all_rules.sh`](validate_all_rules.sh) | Linux / macOS | CI gate: validates all rules with `sigma check` |
| [`Linux_MacOS/validate_all_rules_portable.sh`](Linux_MacOS/validate_all_rules_portable.sh) | Linux / macOS | Portable: auto-installs sigma-cli if missing |
| [`windows/validate_all_rules.ps1`](windows/validate_all_rules.ps1) | Windows | PowerShell equivalent with auto-install |
| [`convert_all_rules.sh`](convert_all_rules.sh) | Linux / macOS | Converts all rules to 11 SIEM targets in one run |
| [`convert_to_wazuh.sh`](convert_to_wazuh.sh) | Linux / macOS | Wazuh-specific conversion with logsource classification |
| [`convert_to_qradar.sh`](convert_to_qradar.sh) | Linux / macOS | QRadar conversion (AQL with sigma 2.x, Lucene fallback with sigma 3.x) |

---

## Validation

### `validate_all_rules.sh` - CI gate

Scans all `**/rules/*.yml` recursively and runs `sigma check`. Returns a non-zero exit code on failure.

```bash
bash scripts/validate_all_rules.sh
```

sigma-cli may report MEDIUM warnings (`InvalidATTACKTagIssue`) for some MITRE ATT&CK tags. These are non-blocking.

### `Linux_MacOS/validate_all_rules_portable.sh` - local use

Same as above with automatic sigma-cli installation if missing. Run from anywhere inside the repository.

```bash
bash scripts/Linux_MacOS/validate_all_rules_portable.sh
```

See [`Linux_MacOS/README.md`](Linux_MacOS/README.md) for details.

### `windows/validate_all_rules.ps1` - Windows

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\validate_all_rules.ps1
```

See [`windows/README.md`](windows/README.md) for details.

---

## Conversion

### `convert_all_rules.sh` - all SIEM targets

Validates then converts all rules to 11 SIEM targets in a single run.

```bash
bash scripts/convert_all_rules.sh
bash scripts/convert_all_rules.sh --show    # also print generated file paths
```

Output: `scripts/conversions/<label>/raw/` and `scripts/conversions/<label>/one-line/`.

#### Conversion targets

| Label | Backend | Pipeline | Plugins required | Notes |
| :--- | :--- | :--- | :--- | :--- |
| `OpenSearch_ECS` | `opensearch_lucene` | `sysmon` | opensearch, sysmon | Wazuh / OpenSearch |
| `Lucene_Sysmon` | `lucene` | `sysmon` | elasticsearch, sysmon | Elasticsearch raw |
| `Elastic_EQL` | `eql` | `sysmon` | elasticsearch, sysmon | Elastic Security EQL |
| `Elastic_ESQL` | `esql` | `sysmon` | elasticsearch, sysmon | Elastic Security 8.11+ |
| `Elastic_ElastAlert` | `elastalert` | `windows-logsources` | elasticsearch, windows | ElastAlert 2 |
| `Splunk_Windows` | `splunk` | `splunk_windows` | splunk | Splunk Enterprise Security |
| `Splunk_SPL2` | `splunk_spl2` | `splunk_windows` | splunk | Splunk ES 7+ / SPL2 |
| `RSA_NetWitness` | `net_witness` | `sysmon` | netwitness, sysmon | Windows rules only |
| `Microsoft_Sentinel_KQL` | `kusto` | `sentinel_asim` | kusto | Sentinel ASIM tables |
| `Microsoft_Defender_XDR_KQL` | `kusto` | `microsoft_xdr` | kusto | Defender XDR tables |
| `Azure_Monitor_KQL` | `kusto` | `azure_monitor` | kusto | Azure Monitor / Log Analytics |
| `QRadar_AQL` | `qradar` | none | sigma 2.x + qradar | Generated only if sigma 2.x active |

All backends with `Processing Pipeline Required = yes` receive the pipeline on every rule regardless of logsource (Linux and web rules pass through the pipeline untransformed, which satisfies the backend requirement without breaking field names). For kusto targets, web rules that have no ASIM/XDR/Azure mapping are retried with `--without-pipeline` automatically.

#### Output structure

```
scripts/conversions/
├── OpenSearch_ECS/raw/        <- Lucene query, exact sigma output
├── OpenSearch_ECS/one-line/   <- same, collapsed to a single line
├── Lucene_Sysmon/raw/
├── Elastic_EQL/raw/
├── Elastic_ESQL/raw/
├── Elastic_ElastAlert/raw/
├── Splunk_Windows/raw/
├── Splunk_SPL2/raw/
├── RSA_NetWitness/raw/        <- only if netwitness plugin installed
├── Microsoft_Sentinel_KQL/raw/
├── Microsoft_Defender_XDR_KQL/raw/
├── Azure_Monitor_KQL/raw/
└── QRadar_AQL/raw/            <- only if sigma 2.x + qradar plugin active
```

One `.txt` file per Sigma rule. Filename encodes the full rule path:

```
CVE-2025-21298_Windows_OLE_RTF_RCE__rules__proc_creation_win_office_rtf_ole_lolbin_strict.txt
```

Use `raw/` by default. Use `one-line/` only if your SIEM requires a single-line query string.

---

### `convert_to_wazuh.sh` - Wazuh / OpenSearch

Dedicated Wazuh conversion. Classifies rules by logsource (Windows, Linux, Web, Other) and writes separate output folders per category. Applies the `sysmon` pipeline to all logsources (pass-through for non-Windows rules, required by the opensearch_lucene backend).

```bash
bash scripts/convert_to_wazuh.sh
bash scripts/convert_to_wazuh.sh --windows-pipeline windows   # Security log fields (EventID 4688)
bash scripts/convert_to_wazuh.sh --input CVE-2025-21298_Windows_OLE_RTF_RCE
bash scripts/convert_to_wazuh.sh --show
```

Output: `scripts/conversions/Wazuh/{Windows_Sysmon,Web_Network,Linux,Other}/`.

See [`GUIDE_WAZUH_EN.md`](GUIDE_WAZUH_EN.md) for field mapping and Wazuh integration.

---

### `convert_to_qradar.sh` - QRadar

Detects the active sigma-cli version and adjusts output automatically:

| Active sigma-cli | Output | Folder |
| :--- | :--- | :--- |
| 3.x (default install) | Lucene fallback | `QRadar_Lucene_Fallback/` |
| 2.x virtualenv + qradar plugin | Native AQL | `QRadar_AQL/` |

```bash
bash scripts/convert_to_qradar.sh                # auto-detect version
bash scripts/convert_to_qradar.sh --upgrade      # print version status and AQL options
bash scripts/convert_to_qradar.sh --force-lucene # always produce Lucene regardless of version
bash scripts/convert_to_qradar.sh --input CVE-2025-21298_Windows_OLE_RTF_RCE
```

To use sigma 2.x for native AQL:

```bash
source .venv-sigma2/bin/activate
bash scripts/convert_to_qradar.sh
deactivate
```

See [`GUIDE_QRADAR_EN.md`](GUIDE_QRADAR_EN.md) for QRadar integration details.

---

## SOC best practices

- Always validate before converting: `bash scripts/validate_all_rules.sh`.
- Do not deploy rules that fail `sigma check`.
- Use `validate_all_rules.sh` as a blocking CI gate.
- Review field name mappings before deploying converted queries in production.
- After any sigma-cli upgrade, run `sigma plugin list` to verify plugin compatibility.
- Keep the sigma 2.x virtualenv active only when running QRadar conversions; deactivate it when using sigma 3.x scripts.
