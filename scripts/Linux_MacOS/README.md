# Sigma rules validation — Linux and macOS

[Version française](README_FR.md)

This document explains how to validate all Sigma rules in the repository on Linux and macOS using the portable Bash script.

---

## Purpose

The script `validate_all_rules_portable.sh` allows SOC teams and contributors to:

- validate all Sigma rules located in `**/rules/*.yml` and `**/rules/*.yaml`
- handle missing prerequisites automatically
- run validation from any directory inside the repository

---

## What the script does

1. Detects the Git repository root (`.git`)
2. Checks for Python 3
3. Checks for pip and pipx
4. Installs sigma-cli via pipx if missing (user space, no root required)
5. Collects all Sigma rules under `*/rules/`
6. Runs `sigma check` on all detected rules

---

## Prerequisites

- Linux or macOS
- Bash 4+
- Python 3.9 or later (recommended: 3.10+)

No root privileges required. Do not run the script with `sudo`.

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

## Manual installation

If you prefer to install sigma-cli yourself before running the script:

```bash
pipx install sigma-cli
sigma version
sigma plugin list
```

---

## Related documentation

- [scripts/README.md](../README.md) — full scripts overview
- [scripts/windows/README.md](../windows/README.md) — Windows equivalent
- [scripts/GUIDE_WAZUH_EN.md](../GUIDE_WAZUH_EN.md) — Wazuh conversion guide
- [scripts/GUIDE_QRADAR_EN.md](../GUIDE_QRADAR_EN.md) — QRadar conversion guide
