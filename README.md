# 🛡️ sigma-rules
### Sigma Rules for CVE Detection & SOC / Blue Team Operations

<!-- Badges (edit the links if you rename the repo/branch) -->
![Sigma](https://img.shields.io/badge/Sigma-rules-blue)
![SOC](https://img.shields.io/badge/SOC-ready-success)
![SOAR](https://img.shields.io/badge/SOAR-playbooks-important)
![MITRE](https://img.shields.io/badge/MITRE-ATT%26CK-lightgrey)
![License](https://img.shields.io/badge/License-MIT-informational)

---
This document is bilingual (French and English).  The French version appears first, followed by the English version.

## 🚨 WinRAR CVE-2025-6218 - Sigma detection rules (Blue Team)

🇫🇷 Version Française
### 🎯 Objectif 

Ce dépôt fournit **deux règles Sigma complémentaires** conçues pour détecter **l’exploitation réelle** de la vulnérabilité **CVE-2025-6218 affectant WinRAR sous Windows**.

L’objectif n’est pas de détecter une archive malveillante en soi, mais de **détecter le comportement d’exploitation et de persistance**, tel qu’observé dans des **scénarios d’attaque réels**.

Ces règles sont pensées pour :
 - 🟢 les équipes **SOC**
 - 🟢 les analystes **Blue Team**
 - 🟢 les cas d’usage **CTI / Threat Hunting**
 - 🟢 une intégration **SIEM / SOAR**

---

## 📌 Vulnérabilité concernée

| Élément | Détail |
|------|------|
| CVE | **CVE-2025-6218** |
| Logiciel | WinRAR |
| Type | Traversée de répertoires |
| Impact | Écriture de fichiers arbitraires |
| Objectif attaquant | Persistance + exécution |

La vulnérabilité permet à un attaquant de **forcer WinRAR à extraire des fichiers en dehors du répertoire prévu**, menant directement à une **persistance système**.

---

## 🧬 Scénario d’attaque (vision Blue Team)

- 1️⃣  L’attaquant distribue une **archive piégée** (email, web, téléchargement).
- 2️⃣  L’archive contient des chemins de type `../` (path traversal).
- 3️⃣  La victime ouvre l’archive avec WinRAR.
- 4️⃣  WinRAR extrait un fichier **hors du dossier cible**.
- 5️⃣  Le fichier est écrit dans un **emplacement de persistance Windows**.
- 6️⃣  À la reconnexion ou au redémarrage, le code malveillant s’exécute.

👉🏿 **Les deux règles Sigma couvrent deux étapes distinctes de ce scénario.**

---

## 🛡️ Rôle des règles Sigma dans le scénario

### 🔹 Règle 1 - *Path Traversal Extraction*
**`WinRAR_Path_Traversal_Extraction_CVE-2025-6218.yml`**

#### 🎯 Rôle
Détecter **la phase d’exploitation initiale**.

#### 🔍 Ce que la règle détecte
- 🟢 L’exécution de `WinRAR.exe`
- 🟢 L’utilisation de motifs de traversée (`../`, `..\\`, encodage URL)
- 🟢 Des commandes d’extraction (`x`, `e`, `-o+`, etc.)

#### 🧠 Pourquoi c’est important
Cette règle signale :
- 🟢 une **tentative d’exploitation**
- 🟢 un comportement anormal impossible dans un usage WinRAR légitime standard

👉🏿 Elle constitue un **signal faible mais précoce**, idéal pour :
- le **threat hunting**
- l’enrichissement CTI
- la corrélation SOAR

---

### 🔹 Règle 2  -  *Persistence File Write*
**`WinRAR_Persistence_Startup_Write_CVE-2025-6218.yml`**

#### 🎯 Rôle
Détecter **la phase post-exploitation et de persistance**.

#### 🔍 Ce que la règle détecte
- WinRAR écrivant des fichiers dans :
  - dossiers **Startup**
  - répertoires de **tâches planifiées**
- Écriture directe depuis le processus WinRAR

#### 🧠 Pourquoi c’est critique
Ce comportement indique :
- une **exploitation réussie**
- une **tentative de persistance active**
- un risque élevé d’exécution automatique

👉🏿 Cette règle est **hautement fiable** et adaptée à la **production SOC**.

---

## 🔗 Puissance de la corrélation

| Signal | Interprétation |
|----|----|
| Règle 1 seule | Tentative suspecte |
| Règle 2 seule | Persistance suspecte |
| **Règle 1 + Règle 2** | 🚨 **Exploitation confirmée** |

⚠️ La corrélation volontairement **n’est pas codée dans Sigma** afin de :
- préserver la portabilité
- laisser le contrôle au SIEM / SOAR (Elastic, OpenSearch, TheHive, etc.)

## 🧬 Mapping MITRE ATT&CK

-▪️Initial Access : **T1566** (Archive piégée)
-▪️ Execution : **T1204** (User Execution)
-▪️ Persistence : **T1547** (Startup / Scheduled Task)

---

## 👥 Public cible
Ces règles sont utiles pour :
- ▪️SOC N1 / N2 (détection et triage)
- ▪️SOC N3 / IR (confirmation exploitation)
- ▪️Blue Team / CTI
- ▪️Déploiements SIEM multi-clients

### ⚠️ Avertissement

Ces règles sont fournies **à des fins défensives uniquement**.  Toujours tester et adapter les règles à votre environnement avant déploiement en production.
---
 🇬🇧 English Version

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
- 🔹 SOC L1 / L2 (detection and triage)
- 🔹 SOC L3 / IR (exploitation confirmation)
- 🔹 Blue Team / CTI analysts
- 🔹 Multi-tenant SIEM deployments

---

### ⚠️ Disclaimer

These rules are provided **for defensive purposes only**.  Always test and tune the rules for your environment before deploying them in production.

#### 🙎🏾‍♂️ Author: |
  Adama Assiongbon (SOC/CTI Analyst Consultant)
  LinkedIn: https://www.linkedin.com/in/adama-assiongbon-9029893a/
