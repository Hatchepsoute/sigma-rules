# Installation and usage

This guide explains how to install sigma-cli, how to validate the rules, and how to convert them to your SIEM format.

---

## Requirements

- Python 3.9 or later
- Bash 4+ (Linux / macOS) or PowerShell 5+ (Windows)
- Internet access to install packages

---

## Step 1 — Clone the repository

```bash
git clone https://github.com/Hatchepsoute/sigma-rules.git
cd sigma-rules
```

---

## Step 2 — Install pipx

pipx installs sigma-cli in an isolated environment and avoids conflicts with your global Python packages. Do not use `pip install sigma-cli` directly.

```bash
pip install pipx
pipx ensurepath
```

Restart your terminal after running `pipx ensurepath`.

On macOS with Homebrew:

```bash
brew install pipx
pipx ensurepath
```

On Windows (PowerShell):

```powershell
pip install pipx
pipx ensurepath
```

---

## Step 3 — Install sigma-cli

```bash
pipx install sigma-cli
sigma version   # should print 3.x.x
```

---

## Step 4 — Install the plugins

Each SIEM backend requires a plugin. Install all of them to use the full conversion script:

```bash
sigma plugin install opensearch       # Wazuh / OpenSearch / Lucene
sigma plugin install elasticsearch    # Elasticsearch / EQL / ES|QL / ElastAlert
sigma plugin install splunk           # Splunk SPL and SPL2
sigma plugin install sysmon           # Sysmon pipeline (field mapping, required by most backends)
sigma plugin install windows          # Windows Security log pipeline
sigma plugin install kusto            # Microsoft Sentinel, Defender XDR, Azure Monitor
sigma plugin install netwitness       # RSA NetWitness
```

Verify:

```bash
sigma plugin list
sigma list targets
```

---

## Step 5 — Validate all rules

Before converting anything, check that all rules are syntactically valid:

```bash
bash scripts/validate_all_rules.sh
```

sigma-cli may report MEDIUM warnings (`InvalidATTACKTagIssue`) for some MITRE ATT&CK tags. These are non-blocking.

The script auto-installs sigma-cli via pipx if it is not already in your PATH.

Windows users: run from a WSL terminal.

---

## Step 6 — Convert rules to your SIEM

### All SIEM targets at once

Converts all rules to 11 SIEM formats in one run:

```bash
bash scripts/convert_all_rules.sh
```

Output is written to `scripts/conversions/<target>/raw/`. One `.txt` file per rule.

Targets produced:

| Folder | SIEM |
| :--- | :--- |
| `OpenSearch_ECS/` | Wazuh / OpenSearch |
| `Lucene_Sysmon/` | Elasticsearch (raw Lucene) |
| `Elastic_EQL/` | Elastic Security (EQL) |
| `Elastic_ESQL/` | Elastic Security 8.11+ (ES\|QL) |
| `Elastic_ElastAlert/` | ElastAlert 2 |
| `Splunk_Windows/` | Splunk Enterprise Security |
| `Splunk_SPL2/` | Splunk ES 7+ (SPL2) |
| `RSA_NetWitness/` | RSA NetWitness (Windows rules only) |
| `Microsoft_Sentinel_KQL/` | Microsoft Sentinel (ASIM tables) |
| `Microsoft_Defender_XDR_KQL/` | Microsoft Defender XDR |
| `Azure_Monitor_KQL/` | Azure Monitor / Log Analytics |

### Wazuh only

Converts all rules with logsource classification (Windows, Linux, Web, Other):

```bash
bash scripts/convert_to_wazuh.sh
```

Options:

```bash
bash scripts/convert_to_wazuh.sh --windows-pipeline windows   # Security log fields instead of Sysmon
bash scripts/convert_to_wazuh.sh --input CVE-2025-21298_Windows_OLE_RTF_RCE
bash scripts/convert_to_wazuh.sh --show
```

See [scripts/GUIDE_WAZUH_EN.md](scripts/GUIDE_WAZUH_EN.md) for field mapping and integration details.

### QRadar

With sigma-cli 3.x (default), the script produces a Lucene fallback compatible with QRadar on Cloud:

```bash
bash scripts/convert_to_qradar.sh
```

For native AQL output, create a sigma 2.x virtualenv first (one-time setup):

```bash
python3 -m venv .venv-sigma2
source .venv-sigma2/bin/activate
pip install "sigma-cli<3"
sigma plugin install qradar
deactivate
```

Then run:

```bash
source .venv-sigma2/bin/activate
bash scripts/convert_to_qradar.sh
deactivate
```

See [scripts/GUIDE_QRADAR_EN.md](scripts/GUIDE_QRADAR_EN.md) for full details.

---

## Step 7 — Convert a single rule (optional)

```bash
# OpenSearch / Wazuh
sigma convert -t opensearch_lucene -p sysmon CVE-2025-21298_Windows_OLE_RTF_RCE/rules/proc_creation_win_office_rtf_ole_lolbin_strict.yml

# Splunk
sigma convert -t splunk -p splunk_windows CVE-2025-21298_Windows_OLE_RTF_RCE/rules/proc_creation_win_office_rtf_ole_lolbin_strict.yml

# Microsoft Sentinel
sigma convert -t kusto -p sentinel_asim CVE-2025-21298_Windows_OLE_RTF_RCE/rules/proc_creation_win_office_rtf_ole_lolbin_strict.yml

# RSA NetWitness
sigma convert -t net_witness -p sysmon CVE-2025-21298_Windows_OLE_RTF_RCE/rules/proc_creation_win_office_rtf_ole_lolbin_strict.yml
```

---

## Windows users

All Bash scripts require WSL (Windows Subsystem for Linux) or Git Bash. The PowerShell script handles validation only.

Install WSL if needed:

```powershell
wsl --install
```

Then run the Bash scripts from inside the WSL terminal.

---

## Full documentation

| Document | Purpose |
| :--- | :--- |
| [scripts/README.md](scripts/README.md) | Scripts overview, all options, output structure |
| [scripts/README_FR.md](scripts/README_FR.md) | French version |
| [scripts/GUIDE_WAZUH_EN.md](scripts/GUIDE_WAZUH_EN.md) | Wazuh field mapping and integration |
| [scripts/GUIDE_WAZUH.md](scripts/GUIDE_WAZUH.md) | French version |
| [scripts/GUIDE_QRADAR_EN.md](scripts/GUIDE_QRADAR_EN.md) | QRadar AQL and Lucene fallback |
| [scripts/GUIDE_QRADAR.md](scripts/GUIDE_QRADAR.md) | French version |
