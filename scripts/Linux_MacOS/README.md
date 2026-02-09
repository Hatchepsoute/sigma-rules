# Sigma Rules Validation – Linux & macOS

This document explains how to **validate all Sigma rules** in the repository on **Linux and macOS** using the portable Bash script.

👉🏾 [**Version française disponible**](README_FR.md)  
👉🏾 [**Windows version**](./scripts/Windows/README.md) 

---

## 🎯 Purpose

The script `validate_all_rules_portable.sh` enables SOC teams and contributors to:

- Validate **all Sigma rules** located in `**/rules/*.yml` and `**/rules/*.yaml`
- Automatically handle missing prerequisites
- Run validation from **any directory** inside the repository
- Ensure a consistent validation workflow across platforms

---

## 📦 What the script does

The script automatically:

1. Detects the **Git repository root** (`.git`)
2. Checks for **Python 3**
3. Checks for **pip / pipx**
4. Installs **sigma-cli** if missing (user space)
5. Collects all Sigma rules under `*/rules/`
6. Runs `sigma check` on all detected rules

---

## 🖥️ Prerequisites

- Linux or macOS
- Bash 4+
- Python 3.9 or later (recommended: 3.10+)

> ⚠️ No root privileges required.  
> Do **not** run the script with `sudo`.

---

## ▶️ How to use

### 1️⃣ Make the script executable

```bash
chmod +x scripts/Linux_MacOS/validate_all_rules_portable.sh
```

### 2️⃣ Run the script

From anywhere inside the repository:

```bash
./scripts/Linux_MacOS/validate_all_rules_portable.sh
```

---

## ✅ Expected output

- Total number of Sigma rules detected
- Validation progress
- Explicit errors if a rule is invalid

Example:

```
[*] Found 268 Sigma rule files under */rules/
[*] Running: sigma check <all rules>
[*] Done.
```

---

## 🧠 Best practices

- Run the script **before committing** new rules
- Keep rules compliant with Sigma specifications
- Use together with CI validation pipelines

---

## 📁 Script location

```
scripts/
└── Linux_MacOS/
    ├── validate_all_rules_portable.sh
    ├── README.md
    └── README_FR.md
```

---

## 👤 Author

✍🏿  Adama ASSIONGBON - SOC & CTI Consultant  
[LinkedIn Profile](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

