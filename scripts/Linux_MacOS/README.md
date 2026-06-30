# Sigma rules validation - Linux and macOS

[Version française](README_FR.md)

---

## Prerequisites

Before running any script in this repository, complete the installation steps below.

### Python 3.9+

```bash
python3 --version   # should be 3.9 or later
```

Install from your package manager if missing:

```bash
# Debian / Ubuntu
sudo apt install python3 python3-pip

# macOS
brew install python3
```

### pipx

```bash
pip install pipx
pipx ensurepath
```

Restart your terminal after running `pipx ensurepath`.

### sigma-cli 3.x

```bash
pipx install sigma-cli
sigma version        # should print 3.x.x
```

### Sigma plugins (required for conversion scripts)

```bash
sigma plugin install opensearch       # OpenSearch / Wazuh backend
sigma plugin install elasticsearch    # Elasticsearch / EQL / ES|QL / ElastAlert backends
sigma plugin install splunk           # Splunk SPL and SPL2 backends
sigma plugin install sysmon           # Sysmon pipeline (used by almost all conversions)
sigma plugin install windows          # Windows log source pipelines
sigma plugin install kusto            # Kusto/KQL + Sentinel, Defender XDR, Azure Monitor
sigma plugin install netwitness       # RSA NetWitness backend
```

Verify:

```bash
sigma plugin list
sigma list targets
```

### QRadar AQL (optional, requires sigma 2.x)

Both QRadar plugins are Compatible = no with sigma-cli 3.x. For native AQL output, set up a separate virtualenv:

```bash
python3 -m venv .venv-sigma2
source .venv-sigma2/bin/activate
pip install "sigma-cli<3"
sigma plugin install qradar
deactivate
```

See [scripts/GUIDE_QRADAR_EN.md](../GUIDE_QRADAR_EN.md) for details.

---

## Purpose

The script `validate_all_rules_portable.sh` validates all Sigma rules in the repository. It auto-installs sigma-cli via pipx if missing, which makes it suitable for first-time setup without any prior configuration.

---

## What the script does

1. Detects the Git repository root (`.git`)
2. Checks for Python 3
3. Checks for pip and pipx
4. Installs sigma-cli via pipx if missing (user space, no root required)
5. Collects all Sigma rules under `*/rules/`
6. Runs `sigma check` on all detected rules

---

## How to use

Make the script executable (first time only):

```bash
chmod +x scripts/Linux_MacOS/validate_all_rules_portable.sh
```

Run from anywhere inside the repository:

```bash
bash scripts/Linux_MacOS/validate_all_rules_portable.sh
```

---

## Expected output

```
[*] sigma already installed: 3.0.2
[*] Found 152 Sigma rule files under */rules/ (repo: /path/to/sigma-rules)
[*] Running: sigma check <all rule files>
[*] Done.
```

sigma-cli may report MEDIUM-severity warnings (`InvalidATTACKTagIssue`) for certain MITRE ATT&CK tags. These are non-blocking.

---

## Related documentation

- [scripts/README.md](../README.md) - full scripts overview and installation guide
- [scripts/windows/README.md](../windows/README.md) - Windows equivalent
- [scripts/GUIDE_WAZUH_EN.md](../GUIDE_WAZUH_EN.md) - Wazuh conversion guide
- [scripts/GUIDE_QRADAR_EN.md](../GUIDE_QRADAR_EN.md) - QRadar conversion guide
