# Sigma rules validation - Windows

[Version française](README_FR.md)

---

## Prerequisites

Before running any script in this repository, complete the installation steps below.

### Python 3.9+

Download from [python.org](https://www.python.org/downloads/) or install via `winget`:

```powershell
winget install Python.Python.3.12
```

Verify:

```powershell
python --version   # should be 3.9 or later
```

### pipx

```powershell
pip install pipx
pipx ensurepath
```

Restart your PowerShell terminal after running `pipx ensurepath`.

### sigma-cli 3.x

```powershell
pipx install sigma-cli
sigma version        # should print 3.x.x
```

### Sigma plugins (required for conversion scripts)

```powershell
sigma plugin install opensearch       # OpenSearch / Wazuh backend
sigma plugin install elasticsearch    # Elasticsearch / EQL / ES|QL / ElastAlert backends
sigma plugin install splunk           # Splunk SPL and SPL2 backends
sigma plugin install sysmon           # Sysmon pipeline (used by almost all conversions)
sigma plugin install windows          # Windows log source pipelines
sigma plugin install kusto            # Kusto/KQL + Sentinel, Defender XDR, Azure Monitor
sigma plugin install netwitness       # RSA NetWitness backend
```

Verify:

```powershell
sigma plugin list
sigma list targets
```

### QRadar AQL (optional, requires sigma 2.x)

Both QRadar plugins are Compatible = no with sigma-cli 3.x. Native AQL requires sigma-cli 2.x. On Windows, set up a separate virtualenv:

```powershell
python -m venv .venv-sigma2
.venv-sigma2\Scripts\Activate.ps1
pip install "sigma-cli<3"
sigma plugin install qradar
deactivate
```

See [scripts/GUIDE_QRADAR_EN.md](../GUIDE_QRADAR_EN.md) for details. The conversion scripts (`convert_to_qradar.sh`) are Bash-only; run them under WSL or Git Bash on Windows.

---

## Purpose

The script `validate_all_rules.ps1` validates all Sigma rules in the repository on Windows. It auto-installs sigma-cli via pipx if missing, and processes rules in batches of 200 to stay within PowerShell argument limits.

---

## What the script does

1. Detects the Git repository root (`.git`)
2. Checks for Python 3.9+
3. Checks for pip and pipx
4. Installs sigma-cli via pipx if missing (user space, no administrator rights required)
5. Collects all Sigma rules under `*\rules\`
6. Runs `sigma check` on all rules in batches of 200

---

## How to use

Run the script:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\validate_all_rules.ps1
```

Run without installing missing tools:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\validate_all_rules.ps1 -InstallIfMissing:$false
```

Specify the repository root manually:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\validate_all_rules.ps1 -RepoRoot "C:\path\to\sigma-rules"
```

---

## Expected output

```
[*] Repo root: C:\path\to\sigma-rules
[*] sigma already installed.
[*] Found 152 Sigma rule files under **\rules\
[*] Running: sigma check (batch size=200)
[*] Done.
```

sigma-cli may report MEDIUM-severity warnings (`InvalidATTACKTagIssue`) for certain MITRE ATT&CK tags. These are non-blocking.

---

## Related documentation

- [scripts/README.md](../README.md) - full scripts overview and installation guide
- [scripts/Linux_MacOS/README.md](../Linux_MacOS/README.md) - Linux / macOS equivalent
- [scripts/GUIDE_WAZUH_EN.md](../GUIDE_WAZUH_EN.md) - Wazuh conversion guide
- [scripts/GUIDE_QRADAR_EN.md](../GUIDE_QRADAR_EN.md) - QRadar conversion guide
