# 🛠️ Sigma CLI - Installation, Conversion & SOC Usage Guide

## 🎯 Document Purpose
This guide explains **how to install Sigma CLI**, **convert Sigma rules**, and **use them operationally in a SOC**, especially with:
- **ELK / OpenSearch**
- **Splunk**
- Lucene-based SIEMs

---

## 🧠 Key Concept
- **Sigma = detection logic**
- **Conversion = SIEM language**
- **SOC always works on converted queries**

---

## 🖥️ Installation by OS

### Linux
```bash
pipx install sigma-cli
```

### Windows
```powershell
pip install sigma-cli
```

---

## 🔌 Plugins
```bash
sigma plugin install splunk
sigma plugin install elasticsearch
sigma plugin install opensearch
sigma plugin install sysmon
sigma plugin install windows
sigma plugin install kusto
```
---

## 🔄 Rule Conversion Examples

### ELK / OpenSearch
```bash
sigma convert -t opensearch_lucene -p sysmon rule.yml
```
### Splunk
```bash
sigma convert -t splunk -p sysmon rule.yml
```
### Elasticsearch
```bash
sigma convert -t elastalert -p windows-logsources <rule.yml>
```
---

## 👨‍💻 SOC Analyst Usage Flow
1. Write Sigma rule
2. Convert
3. Deploy in SIEM
4. Tune
5. Alert & respond

---

## ⚠️ Disclaimer
Defensive usage only.  Test before production.

---

**Author:** Adama Assiongbon  
**Role:** SOC / CTI Analyst Consultant  
**Last update:** 2025-12-19
