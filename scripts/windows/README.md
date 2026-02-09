# Sigma Rules Validation – Windows

This document explains how to **validate all Sigma rules** in the repository on **Windows** using the provided PowerShell script.

👉🏾 [**Version française disponible**](README_FR.md)

---

## 🎯 Purpose

The script `validate_all_rules.ps1` allows SOC teams and contributors to:

- Validate **all Sigma rules** located in `**/rules/*.yml` and `**/rules/*.yaml`
- Avoid common errors related to missing prerequisites
- Run validation from **any directory** inside the repository
- Ensure a smooth **clone → run** experience for the community

---

## 📦 What the script does

The script automatically:

1. Detects the **Git repository root** (`.git`)
2. Checks for **Python (3.9+)**
3. Checks for **pip**
4. Checks for **pipx** (recommended)
5. Installs **sigma-cli** if missing
6. Collects all Sigma rules under `*/rules/`
7. Runs `sigma check` on all rules (in batches)

---

## 🖥️ Prerequisites

- Windows 10 / Windows 11
- PowerShell 5.1+ or PowerShell 7+
- Python 3.9 or later (recommended: 3.10+)

> ⚠️ The script installs tools **in user space** (no administrator rights required).

---

## ▶️ How to use

### 1️⃣ Open PowerShell

Open a PowerShell terminal and navigate to the repository root or any subdirectory.

### 2️⃣ Run the script

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Windows\validate_all_rules.ps1
```

### 3️⃣ Optional parameters

Run without installing missing tools:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Windows\validate_all_rules.ps1 -InstallIfMissing:$false
```

Specify the repository root manually:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Windows\validate_all_rules.ps1 -RepoRoot "C:\path\to\sigma-rules"
```

---

## ✅ Expected output

- Number of Sigma rules detected
- Validation progress per batch
- Clear error messages if a rule is invalid

Example:

```
[*] Found 268 Sigma rule files under **\rules\
[*] Running: sigma check (batch size=200)
[*] Done.
```

---

## 🧠 Best practices

- Run the script **before committing** changes
- Do not run as Administrator (to avoid environment mismatch)
- Use this script locally and in CI pipelines

---

## 📁 Script location

```
scripts/
└── Windows/
    └── validate_all_rules.ps1
```

---
## Author
✍🏿  Adama ASSIONGBON - SOC & CTI Consultant  
[LinkedIn Profile](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

