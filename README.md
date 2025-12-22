# 🛡️ sigma-rules
### Sigma Rules for CVE Detection & SOC / Blue Team Operations

<!-- Badges (edit the links if you rename the repo/branch) -->
![Sigma](https://img.shields.io/badge/Sigma-rules-blue)
![SOC](https://img.shields.io/badge/SOC-ready-success)
![SOAR](https://img.shields.io/badge/SOAR-playbooks-important)
![MITRE](https://img.shields.io/badge/MITRE-ATT%26CK-lightgrey)
![License](https://img.shields.io/badge/License-MIT-informational)


##  🚨 WinRAR CVE-2025-6218 – Sigma detection rules (Blue Team)

### 🎯 Pack Objective

This repository provides **two complementary Sigma rules** designed to detect **real-world exploitation** of **CVE-2025-6218 affecting WinRAR on Windows**.
The goal is **not** to detect a malicious archive itself, but to **detect exploitation and persistence behaviors**, as observed in **real attack scenarios**.

These rules are designed for:
- 🟢  **SOC teams**
- 🟢  **Blue Team analysts**
- 🟢  **CTI / Threat Hunting use cases**
- 🟢  **SIEM / SOAR integration**

---

## 📌 Targeted Vulnerability

| Item | Details |
|------|--------|
| CVE | **CVE-2025-6218** |
| Software | WinRAR |
| Type | Directory Traversal |
| Impact | Arbitrary file write |
| Attacker goal | Persistence + execution |

This vulnerability allows an attacker to **force WinRAR to extract files outside the intended directory**, directly leading to **system persistence**.

---

## 🧬 Attack Scenario (Blue Team View)

1️⃣ .  The attacker distributes a **weaponized archive** (email, web, download).
2️⃣ .  The archive contains `../` path traversal sequences.
3️⃣ . The victim opens the archive using WinRAR.
4️⃣ . WinRAR extracts a file **outside the target directory**.
5️⃣ . The file is written to a **Windows persistence location**.
6️⃣ . On user logon or system reboot, the malicious code executes.

👉🏿 **The two Sigma rules cover two distinct stages of this scenario.**

----

## 🛡️ Role of the Sigma Rules in the Scenario

### 🔹 Rule 1 - *Path Traversal Extraction*
**`WinRAR_Path_Traversal_Extraction_CVE-2025-6218.yml`**

#### 🎯 Role
Detect the **initial exploitation phase**.

#### 🔍 What the rule detects
- 🟢 Execution of `WinRAR.exe`
- 🟢 Use of traversal patterns (`../`, `..\\`, URL-encoded variants)
- 🟢 Extraction commands (`x`, `e`, `-o+`, etc.)

#### 🧠 Why it matters

This rule indicates:
-  🟢 an **exploitation attempt**
-  🟢 an abnormal behavior not consistent with standard legitimate WinRAR usage

👉🏿 It provides a **low-signal but early indicator**, ideal for:
- ▪️ **threat hunting**
- ▪️ CTI enrichment
- ▪️ SOAR correlation
---
### 🔹 Rule 2 — *Persistence File Write*
**`WinRAR_Persistence_Startup_Write_CVE-2025-6218.yml`**

#### 🎯 Role
Detect the **post-exploitation persistence phase**.

#### 🔍 What the rule detects
- WinRAR writing files to:
  - **Startup** folders
  - **Scheduled Tasks** directories
- Direct file write actions originating from the WinRAR process

#### 🧠 Why it is critical
This behavior indicates:
-  🟢 a **successful exploitation**
-  🟢 an **active persistence attempt**
-  🟢 a high risk of automatic execution

👉🏿 This rule is **high-confidence** and suitable for **SOC production environments**.

---

## 🔗 Correlation Value

| Signal | Interpretation |
|------|----------------|
| Rule 1 only | Suspicious attempt |
| Rule 2 only | Suspicious persistence |
| **Rule 1 + Rule 2** | 🚨 **Confirmed exploitation** |

⚠️ Correlation is **intentionally not implemented within Sigma** in order to:
- preserve portability
- allow full control at the SIEM / SOAR layer (Elastic, OpenSearch, TheHive, etc.)

---

## 🧬 MITRE ATT&CK Mapping

- ▪️ Initial Access: **T1566** (Phishing / Weaponized Archive)
- ▪️ Execution: **T1204** (User Execution)
- ▪️ Persistence: **T1547** (Startup Folder / Scheduled Task)

---

## 👥 Target Audience

These rules are valuable for:
- 🔹 SOC analyst  L1 / L2 (detection and triage)
- 🔹 SOC analyst L3 / IR (exploitation confirmation)
- 🔹 Blue Team / CTI analysts
- 🔹 Multi-tenant SIEM deployments

---

### ⚠️ Disclaimer

These rules are provided **for defensive purposes only**.  Always test and tune the rules for your environment before deploying them in production.

#### 🙎🏾‍♂️ Author: |
  Adama Assiongbon (SOC/CTI Analyst Consultant)
  LinkedIn: https://www.linkedin.com/in/adama-assiongbon-9029893a/
