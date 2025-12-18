# 🛠️ Sigma CLI – Installation & Rule Conversion Guide
## Avoid Common Errors When Converting Sigma Rules (Blue Team / SOC)

---

## 🎯 Purpose of This Guide

This document explains **how to correctly install Sigma CLI**, manage plugins, and **convert Sigma rules into SIEM queries** (OpenSearch, Elasticsearch, Splunk, Sentinel, Wazuh, etc.).

It is based on **real-world SOC experience** and aims to **prevent common mistakes** related to:
- missing backends
- wrong target names
- pipeline confusion (Sysmon, Windows)
- pipx vs venv issues

---

## 🧠 Key Concepts (Important)

| Element | Meaning |
|------|------|
| **Backend / Target (`-t`)** | The SIEM query language (Splunk, OpenSearch, KQL, Lucene…) |
| **Pipeline (`-p`)** | Field mapping & normalization (Sysmon, Windows, ECS…) |
| **Plugin** | Package that provides a backend or pipeline |
| **Sigma rule** | SIEM-agnostic detection logic |

⚠️ Most errors come from mixing backend names and pipelines.

---

## 1️⃣ Install Sigma CLI (Recommended Method)

### ✅ Using pipx (recommended)

```bash
sudo apt install pipx -y
pipx ensurepath
pipx install sigma-cli
```

Verify:
```bash
which sigma
sigma version
```

---

## 2️⃣ Install Required Plugins

```bash
sigma plugin install opensearch
sigma plugin install elasticsearch
sigma plugin install splunk
sigma plugin install kusto
sigma plugin install sysmon
sigma plugin install windows
```

Verify:
```bash
sigma plugin list
sigma plugin list --plugin-type backend
sigma plugin list --plugin-type pipeline
```

---

## 3️⃣ Understand Target Names

Always check valid targets:

```bash
sigma convert -h
```

Example valid targets:
- `opensearch_lucene`
- `lucene`
- `elasticsearch`
- `splunk`
- `kusto`

❌ Invalid example:
```
opensearch
```

---

## 4️⃣ Correct Conversion Commands

### OpenSearch
```bash
sigma convert -t opensearch_lucene -p sysmon rule.yml
```

### Elasticsearch
```bash
sigma convert -t elasticsearch -p sysmon rule.yml
```

### Wazuh / Guardome / Generic Lucene
```bash
sigma convert -t lucene -p sysmon rule.yml
```

### Splunk
```bash
sigma convert -t splunk -p sysmon rule.yml
```

### Microsoft Sentinel (KQL)
```bash
sigma convert -t kusto -p sysmon rule.yml
```

---

## 5️⃣ Common Errors & Fixes

### ❌ No backends installed
✔️ Fix:
```bash
sigma plugin install <backend>
```

### ❌ Invalid target
✔️ Fix:
```bash
sigma convert -h
```

### ❌ YAML parsing error
✔️ Fix: Quote special characters
```yaml
- "[FR] Texte en français"
```

### ❌ Pipeline confusion
❌ Wrong:
```bash
-t sysmon
```
✅ Correct:
```bash
-p sysmon
```

---

## 6️⃣ Validate Rules First

```bash
sigma check *.yml
```

---

## 7️⃣ Recommended SOC Workflow

1. Write Sigma rule (BROAD / STRICT)
2. Validate
3. Convert
4. Tune in SIEM
5. Deploy

---

## ⚠️ Disclaimer

Defensive use only. Always test before production.

---

## 🤝 Contribution

Share improvements, pitfalls, and SIEM-specific tuning.
