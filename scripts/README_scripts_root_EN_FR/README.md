# Sigma Automation Scripts

This directory contains **portable, cross‑platform automation scripts** used to validate and convert Sigma rules for SOC & CTI operations.

👉 **Version française**: [README_FR.md](README_FR.md)

---

## 📂 Directory structure

```text
scripts/
├── convert_all_rules.sh
├── validate_all_rules.sh
├── Linux_MacOS/
│   ├── validate_all_rules_portable.sh
│   ├── README.md
│   └── README_FR.md
└── windows/
    ├── validate_all_rules.ps1
    ├── README.md
    └── README_FR.md
```

---

## 🧪 Validation scripts

### Linux / macOS (recommended)

Portable Bash script:

```bash
./scripts/Linux_MacOS/validate_all_rules_portable.sh
```

📖 Documentation:
- English: `scripts/Linux_MacOS/README.md`
- Français: `scripts/Linux_MacOS/README_FR.md`

---

### Windows (PowerShell)

Portable PowerShell script:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\validate_all_rules.ps1
```

📖 Documentation:
- English: `scripts/windows/README.md`
- Français: `scripts/windows/README_FR.md`

---

## 🔁 Conversion script (multi‑SIEM)

```bash
./scripts/convert_all_rules.sh
```

This script converts validated Sigma rules into SIEM‑specific queries
(OpenSearch, Splunk, Sentinel, Elastic, etc.).

---

## 🧠 SOC best practices

- Always validate rules before conversion
- Use validation scripts as **CI/CD quality gates**
- Do not run scripts with elevated privileges
- Treat converted rules as production artefacts

---

## 👤 Author

Adama ASSIONGBON  
SOC & CTI Analyst

---
