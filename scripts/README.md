# 📘 Sigma Rules Repository - SOC & CTI Automation

This repository provides **enterprise-grade Sigma rules** and **automation scripts** for SOC and CTI teams.
Its goal is to standardize **validation**, **conversion**, and **deployment** of detection rules across multiple SIEM platforms.

---

## 🛠️ Sigma Automation Scripts

Two Bash scripts are provided and must be executed from the `scripts/` directory.

### 1️⃣ `validate_all_rules.sh` – Sigma Quality Gate

**Purpose**
- Validate all Sigma rules in the repository
- Detect:
  - syntax errors
  - invalid detection conditions
  - invalid tags (MITRE ATT&CK, custom tags)

**Behavior**
- Recursively scans all `**/rules/*.yml`
- Executes `sigma check`
- Returns a **non‑zero exit code** if issues are detected
- Designed to be used as a **CI/CD blocking gate**

---

### 2️⃣ `convert_all_rules.sh` – Multi‑SIEM Conversion

**Purpose**
- Convert validated Sigma rules into **SIEM‑specific queries**
- Produce copy/paste‑ready detection queries for SOC analysts

**Supported SIEM targets**
- OpenSearch / Lucene
- Splunk
- Elastic / ElastAlert (legacy)
- Elastic EQL
- RSA NetWitness
- Microsoft Sentinel (KQL)

**Output structure**
```text
scripts/conversions/<SIEM>/
├── raw/
└── one-line/
```

---

## ▶️ Execution

```bash
cd scripts
chmod +x validate_all_rules.sh convert_all_rules.sh
./validate_all_rules.sh
./convert_all_rules.sh
```

---

## 📂 Understanding `raw/` vs `one-line/`

### `raw/` – Native Sigma Output (default)
- Exact output from `sigma convert`
- Preserves original formatting
- Often already single‑line depending on backend
- Recommended for:
  - Splunk
  - Microsoft Sentinel (KQL)
  - Elastic EQL
  - RSA NetWitness

### `one-line/` – Single‑Line Safety Variant
- All line breaks collapsed into spaces
- Required by engines enforcing strict single‑line queries
- Typical use cases:
  - OpenSearch / Elasticsearch `query_string`
  - Lucene‑only engines
  - Custom or legacy SIEM parsers

**Note**
For many backends, `raw/` and `one-line/` may be identical.
This is expected and reflects Sigma’s native output.

**SOC Rule of Thumb**
- SIEM accepts multi‑line → use `raw/`
- SIEM requires single‑line → use `one-line/`

---

## 💻 Supported Environments

- Linux - **recommended**
- macOS (limited testing)
- Windows via **WSL only**

**Requirements**
- Bash 4+
- Python 3.9+
- `sigma-cli`

Install:
```bash
pip install sigma-cli
```

---

## 🧠 SOC Best Practices

- Always run validation before conversion
- Never deploy rules with Sigma issues
- Use `validate_all_rules.sh` as a CI (Continuous Integration) quality gate
- Treat conversion outputs as **production artifacts**
