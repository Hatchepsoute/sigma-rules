# Sigma rules validation — Windows

[Version française](README_FR.md)

This document explains how to validate all Sigma rules in the repository on Windows using the provided PowerShell script.

---

## Purpose

The script `validate_all_rules.ps1` allows SOC teams and contributors to:

- validate all Sigma rules located in `**\rules\*.yml` and `**\rules\*.yaml`
- handle missing prerequisites automatically
- run validation from any directory inside the repository

---

## What the script does

1. Detects the Git repository root (`.git`)
2. Checks for Python 3.9+
3. Checks for pip and pipx
4. Installs sigma-cli via pipx if missing (user space, no administrator rights required)
5. Collects all Sigma rules under `*\rules\`
6. Runs `sigma check` on all rules in batches of 200

---

## Prerequisites

- Windows 10 or Windows 11
- PowerShell 5.1+ or PowerShell 7+
- Python 3.9 or later (recommended: 3.10+)

Tools are installed in user space. No administrator rights required.

---

## How to use

Open a PowerShell terminal and navigate to the repository root or any subdirectory.

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

## Manual installation

If you prefer to install sigma-cli yourself before running the script:

```powershell
pip install pipx
pipx install sigma-cli
sigma version
sigma plugin list
```

---

## Related documentation

- [scripts/README.md](../README.md) — full scripts overview
- [scripts/Linux_MacOS/README.md](../Linux_MacOS/README.md) — Linux / macOS equivalent
- [scripts/GUIDE_WAZUH_EN.md](../GUIDE_WAZUH_EN.md) — Wazuh conversion guide
- [scripts/GUIDE_QRADAR_EN.md](../GUIDE_QRADAR_EN.md) — QRadar conversion guide
