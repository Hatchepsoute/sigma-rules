![Sigma](https://img.shields.io/badge/Sigma-Rules-blue)
![Windows](https://img.shields.io/badge/Platform-Windows-informational)
![CVE](https://img.shields.io/badge/CVE-2025--6218-critical)
![License](https://img.shields.io/badge/License-MIT-green)
![SOC](https://img.shields.io/badge/Use--case-SOC%20%7C%20CTI-blueviolet)

# 🚨 WinRAR CVE-2025-6218 — Sigma Detection Pack

This repository provides **Sigma detection rules** to identify exploitation attempts of the **WinRAR directory traversal vulnerability (CVE-2025-6218)**, actively exploited and added to the **CISA Known Exploited Vulnerabilities (KEV)** catalog.

---

## 🧩 📌 CVE Overview

- **CVE:** CVE-2025-6218  
- **Vulnerability Type:** Directory Traversal during archive extraction  
- **Affected Software:** WinRAR (Windows)  
- **Impact:** Arbitrary file write → Payload drop → Persistence  
- **Threat Context:** Actively exploited in the wild (CISA KEV)

---

## 📂 Repository Content

| File | Description |
|----|----|
| `WinRAR_Path_Traversal_Extraction_CVE-2025-6218.yml` | 🧠 Detects WinRAR executions abusing path traversal during extraction |
| `WinRAR_Persistence_Startup_Write_CVE-2025-6218.yml` | 🧠 Detects file writes by WinRAR into Windows persistence locations |
| `README.md` | 📘 Documentation and SOC usage guide |
| `README_FR.md` | 📘 Documentation et guide SOC (français) |

---

## 🔍 Detection Strategy

🧠 The detection approach is **atomic and modular**:

- Each Sigma rule focuses on **one specific malicious behavior**
- **High-confidence detection** is achieved through **correlation at the SIEM / SOAR level**
- Rules are intentionally **portable and backend-agnostic**

---

## 🔗 🧠 Correlation Logic (SIEM / SOAR)

### 🇬🇧 English

Although Sigma CLI has limited support for `type: correlation`, these rules are **designed to be correlated downstream**.

✅ Trigger a **high-severity alert** when:

1️⃣ WinRAR is executed with **path traversal patterns** during extraction  
2️⃣ WinRAR writes files into **Windows persistence locations**

⏱️ Time window: **10 minutes**  
🔑 Correlation keys: **Hostname, User**

---

### 🇫🇷 Français

✅ Déclencher une **alerte critique** lorsque :

1️⃣ WinRAR est exécuté avec des **motifs de traversée de répertoires**  
2️⃣ WinRAR écrit des fichiers dans des **emplacements de persistance Windows**

⏱️ Fenêtre temporelle : **10 minutes**  
🔑 Clés : **Machine, Utilisateur**

---

## 🧭 🛠️ Pipeline Selection Guide

⚠️ Choosing the correct pipeline is critical.  
An incorrect pipeline may result in queries that do not match any events.

| SIEM | Logs | Pipeline | Target |
|----|----|----|----|
| OpenSearch | Sysmon | `sysmon` | `opensearch_lucene` |
| Elastic | Winlogbeat ECS | `ecs_windows` | `lucene`, `eql` |
| Splunk | Windows | `splunk_windows` | `splunk` |
| SentinelOne | Endpoint | none | `sentinel_one` |
| NetWitness | Windows | none | `net_witness` |

---

## 🧠 ⚠️ False Positives Management

Possible false positives include:

- Legitimate WinRAR extraction of developer archives
- Administrative scripts using WinRAR with advanced options
- Software deployment using archives

🛡️ **Mitigation tips:**
- Correlate with persistence write detection
- Exclude trusted users or signed archives
- Apply allowlists for known extraction paths

---

## 🛡️ 🚑 Response & Triage Recommendations

**Immediate actions:**
- Isolate affected endpoint
- Inspect extracted archive and dropped files
- Review Startup folders & Scheduled Tasks
- Validate WinRAR version

**Mitigation:**
- Patch WinRAR immediately
- Restrict archive execution from email/web downloads
- Enable Sysmon command-line & file write logging

---

## 🔗 📚 References

- https://nvd.nist.gov/vuln/detail/CVE-2025-6218  
- https://www.cisa.gov/news-events/alerts/2025/12/09/cisa-adds-two-known-exploited-vulnerabilities-catalog  
- https://thehackernews.com/2025/12/warning-winrar-vulnerability-cve-2025.html  
- https://foresiet.com/blog/apt-c-08-winrar-directory-traversal-exploit/  
- https://www.secpod.com/blog/archive-terror-dissecting-the-winrar-cve-2025-6218-exploit-apt-c-08s-stealth-move/

---

## 👤 ✍️ Author

**Adama Assiongbon**  
SOC / CTI Analyst Consultant  

- GitHub: https://github.com/Hatchepsoute  
- LinkedIn: https://www.linkedin.com/in/adama-assiongbon-9029893a/

---

### ⚠️ Disclaimer

These rules are provided **for defensive security purposes only**.  
They do **not** include exploit code or offensive payloads and must be tested before production deployment.
