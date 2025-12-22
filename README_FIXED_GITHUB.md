# 🛡️ sigma-rules
### Sigma Rules for CVE Detection & SOC / Blue Team Operations

<!-- Badges -->
![Sigma](https://img.shields.io/badge/Sigma-rules-blue)
![SOC](https://img.shields.io/badge/SOC-ready-success)
![SOAR](https://img.shields.io/badge/SOAR-playbooks-important)
![MITRE](https://img.shields.io/badge/MITRE-ATT%26CK-lightgrey)
![License](https://img.shields.io/badge/License-MIT-informational)

---
This document is bilingual (French and English).  The French version appears first, followed by the English version.

---

# 🚨 WinRAR CVE-2025-6218 – Sigma Detection Rules (Blue Team)

## 🇫🇷 Version Française

## 🎯 Objectif du pack

Ce dépôt fournit **deux règles Sigma complémentaires** conçues pour détecter **l’exploitation réelle** de la vulnérabilité **CVE-2025-6218 affectant WinRAR sous Windows**.

L’objectif n’est pas de détecter une archive malveillante en soi, mais de **détecter le comportement d’exploitation et de persistance**, tel qu’observé dans des **scénarios d’attaque réels**.

Ces règles sont pensées pour :
- les équipes **SOC**
- les analystes **Blue Team**
- les cas d’usage **CTI / Threat Hunting**
- une intégration **SIEM / SOAR**

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

1. L’attaquant distribue une **archive piégée** (email, web, téléchargement).
2. L’archive contient des chemins de type `../` (path traversal).
3. La victime ouvre l’archive avec WinRAR.
4. WinRAR extrait un fichier **hors du dossier cible**.
5. Le fichier est écrit dans un **emplacement de persistance Windows**.
6. À la reconnexion ou au redémarrage, le code malveillant s’exécute.

👉 **Les deux règles Sigma couvrent deux étapes distinctes de ce scénario.**

---

## 🛡️ Rôle des règles Sigma dans le scénario

### 🔹 Règle 1 – Path Traversal Extraction
**`WinRAR_Path_Traversal_Extraction_CVE-2025-6218.yml`**

**Rôle :** détection de la **phase d’exploitation initiale**.

**Ce que la règle détecte :**
- Exécution de `WinRAR.exe`
- Utilisation de motifs de traversée (`../`, `..\\`, encodage URL)
- Commandes d’extraction (`x`, `e`, `-o+`, etc.)

**Pourquoi c’est important :**  
Cette règle signale une **tentative d’exploitation** et un comportement **anormal** dans un usage WinRAR standard.  
Elle constitue un **signal faible mais précoce**, idéal pour le **threat hunting** et la **corrélation SOAR**.

---

### 🔹 Règle 2 – Persistence File Write
**`WinRAR_Persistence_Startup_Write_CVE-2025-6218.yml`**

**Rôle :** détection de la **phase post‑exploitation et de persistance**.

**Ce que la règle détecte :**
- Écriture de fichiers par WinRAR dans :
  - dossiers **Startup**
  - répertoires de **tâches planifiées**
- Écriture directe depuis le processus WinRAR

**Pourquoi c’est critique :**  
Indique une **exploitation réussie**, une **persistance active** et un risque élevé d’**exécution automatique**.  
Cette règle est **hautement fiable** et adaptée à la **production SOC**.

---

## 🔗 Puissance de la corrélation

| Signal | Interprétation |
|----|----|
| Règle 1 seule | Tentative suspecte |
| Règle 2 seule | Persistance suspecte |
| **Règle 1 + Règle 2** | 🚨 **Exploitation confirmée** |

La corrélation est volontairement laissée au **SIEM / SOAR** afin de préserver la portabilité des règles.

---

## 🧬 Mapping MITRE ATT&CK

- Initial Access : **T1566**
- Execution : **T1204**
- Persistence : **T1547**

---

## 👥 Public cible
- SOC L1 / L2 (détection, triage)
- SOC L3 / IR (confirmation exploitation)
- Blue Team / CTI
- Déploiements SIEM multi‑clients

---

## ⚠️ Avertissement
Ces règles sont fournies **à des fins défensives uniquement**.  
Toujours tester et adapter les règles avant déploiement en production.

---

### 🇬🇧 English Version

## 🎯 Pack Objective

This repository provides **two complementary Sigma rules** designed to detect **real‑world exploitation** of **CVE‑2025‑6218 affecting WinRAR on Windows**.

The goal is **not** to detect a malicious archive itself, but to detect **exploitation and persistence behaviors** observed in real attack scenarios.

Designed for:
- **SOC teams**
- **Blue Team analysts**
- **CTI / Threat Hunting**
- **SIEM / SOAR integration**

---

## 🧬 Attack Scenario (Blue Team View)

The attacker delivers a weaponized archive containing traversal paths.  
When extracted by WinRAR, files are written outside the intended directory, enabling **persistence and execution**.

👉🏿 Each Sigma rule maps to a **distinct stage of the attack chain**.

---

## 🧬 MITRE ATT&CK Mapping

- Initial Access: **T1566**
- Execution: **T1204**
- Persistence: **T1547**

---

## ⚠️ Disclaimer
These rules are provided **for defensive purposes only**.  
Always test and tune before production deployment.

---

**Author:** Adama Assiongbon  
SOC / CTI Analyst Consultant  
LinkedIn: https://www.linkedin.com/in/adama-assiongbon-9029893a/
