![Sigma](https://img.shields.io/badge/Sigma-Rules-blue)
![Windows](https://img.shields.io/badge/Platform-Windows-informational)
![SOC](https://img.shields.io/badge/Use--case-SOC%20%7C%20Detection%20Engineering-blueviolet)
![License](https://img.shields.io/badge/License-MIT-green)

# 🛠️ Sigma CLI – Installation, Conversion & SOC Usage Guide

## 🎯 Purpose of This Document

This document provides a **practical and professional guide** to:
- Install **Sigma CLI**
- Validate Sigma rules
- Convert Sigma rules into **SIEM‑specific detection queries**
- Apply Sigma rules operationally in a **SOC environment**

The guide is intended for **SOC analysts, Detection Engineers, and CTI teams**.

---

## 🧠 Core Concepts (SOC Perspective)

- **Sigma** defines *detection logic* in a SIEM‑agnostic format  
- **Sigma CLI** converts Sigma rules into *SIEM‑specific queries*  
- **SOC operations always rely on converted queries**, not raw Sigma YAML

---

## 🖥️ Sigma CLI Installation

### Linux (Recommended)

```bash
pipx install sigma-cli
```

### Windows

```powershell
pip install sigma-cli
```

### Verify Installation

```bash
sigma --version
```

---

## 🔌 Sigma Plugins Installation

Sigma uses plugins to translate rules into SIEM‑specific syntaxes.

```bash
sigma plugin install splunk
sigma plugin install elasticsearch
sigma plugin install opensearch
sigma plugin install sysmon
sigma plugin install windows
sigma plugin install kusto
sigma plugin install netwitness
sigma plugin install sentinelone
sigma plugin install sentinelone-pq
```

Verify installed plugins:

```bash
sigma plugin list
```

---

## ✅ Rule Validation (Mandatory Step)

Before any conversion, **always validate** the rule:

```bash
sigma check rule.yml
```

This step detects:
- YAML errors
- Invalid fields
- Unsupported selections
- Tag or syntax issues

---

## 🔄 Sigma Rule Conversion Examples

### OpenSearch / ELK (Sysmon)

```bash
sigma convert -t opensearch_lucene -p sysmon rule.yml
```

### Elastic (ECS / Winlogbeat)

```bash
sigma convert -t lucene -p sysmon rule.yml
sigma convert -t elastalert -p windows-logsources rule.yml
```
### Sentinelone 
```bash
sigma convert -t sentinel_one -p sysmon rule.yml
sigma convert -t sentinel_one_pq -p sysmon rule.yml
```
### Elastic Security (EQL)

```bash
sigma convert -t eql -p ecs_windows rule.yml
```

### Splunk

```bash
sigma convert -t splunk -p splunk_windows rule.yml
```

### NetWitness

```bash
sigma convert -t net_witness -p sysmon rule.yml
```

---

## 👨‍💻 SOC Operational Workflow

Recommended SOC workflow when using Sigma:

1. Write or adapt a Sigma rule  
2. Validate the rule (`sigma check`)  
3. Convert to SIEM syntax  
4. Deploy query in SIEM  
5. Tune to reduce false positives  
6. Enable alerting  
7. Respond and iterate  

---

## ⚠️ Important Notes

- Sigma rules **must be adapted** to your log source schema
- Field mappings may vary between environments
- Always test converted queries **before production deployment**
- Sigma rules are **detection hypotheses**, not guarantees

---

## 📜 Disclaimer

This content is provided for **defensive and educational purposes only**.  
The author assumes no responsibility for misuse or misconfiguration.

---

**Author:** Adama Assiongbon  
**Role:** SOC / CTI Analyst Consultant  
**LinkedIn:** https://www.linkedin.com/in/adama-assiongbon-9029893a/

