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
## 🇫🇷 FR — Présentation

### 🎯 Objectif
Ce dépôt fournit une collection de **règles Sigma orientées Blue Team**, organisées par **vulnérabilité CVE**, afin de détecter :
- l’exploitation de vulnérabilités connues
- les comportements post-exploitation observés en environnement SOC

L’approche est :
- **comportementale**
- **agnostique SIEM** (Elastic, OpenSearch, Splunk, Sentinel, Wazuh, etc.)
- pensée pour des **opérations SOC réelles**

---

### 🧠 Philosophie de détection
❌ Signatures statiques uniquement  
✅ Détection comportementale et contextuelle  
✅ Alignement MITRE ATT&CK  
✅ Détection + Réponse (Sigma + SOAR)

---

### 📦 Structure du dépôt
```
sigma-rules/
├── README.md                     # (ce fichier – FR / EN)
├── CHANGELOG.md
├── CVE/
│   ├── README_CVE.md              # Convention des packs CVE
│   ├── diagrams/                 # Diagrammes globaux (SOC / méthode)
│   ├── CVE-2025-6218_WinRAR/
│   │   ├── rules/
│   │   ├── playbook/
│   │   └── diagrams/
│   └── CVE-2025-50165_WindowsGraphics/
│       ├── rules/
│       ├── playbook/
│       └── diagrams/
└── diagrams/
```
👉 Chaque **CVE est autonome** (règles, playbooks, diagrammes).

---

### 🔗 Liens rapides (repo)
- 📁 Packs CVE : `CVE/`
- 📄 Guide structure packs : `CVE/README_CVE.md`
- 🖼️ Diagrammes globaux : `CVE/diagrams/`
- 🧾 Changelog : `CHANGELOG.md`

---

### 🧩 Packs CVE disponibles
- **CVE-2025-6218** — WinRAR (*Path Traversal, Persistence*)
- **CVE-2025-50165** — Windows Graphics Component (*Weaponized images, renderer exploitation*)

---

### 🛡️ Niveaux de règles Sigma
- **BROAD / BROADPLUS** : threat hunting, couverture maximale
- **STRICT** : production SOC, faible bruit / haute confiance

---

### 🔁 Conversion Sigma → SIEM
```bash
pip install sigma-cli
sigma convert -t elasticsearch rule.yml
sigma convert -t opensearch_lucene rule.yml
sigma convert -t splunk rule.yml
sigma convert -t sentinel rule.yml
```

---

### 🤝 Contribution
- **1 dossier = 1 CVE**
- Documentation **FR + EN** recommandée
- Diagrammes fortement encouragés (attaque + points de détection)

---

### ⚠️ Avertissement
Usage **défensif uniquement**.  
Tester et adapter les règles avant déploiement en production.

---

## 🇬🇧 EN - Overview

### 🎯 Objective
This repository provides a collection of **Blue Team–oriented Sigma rules**, organized by **CVE**, designed to detect:
- exploitation of known vulnerabilities
- post-exploitation behaviors in SOC environments

The approach is:
- **behavior-based**
- **SIEM-agnostic**
- designed for **real-world SOC operations**

---

### 🧠 Detection Philosophy
❌ Static signatures only  
✅ Behavioral and contextual detection  
✅ MITRE ATT&CK aligned  
✅ Detection + Response (Sigma + SOAR)

---

### 📦 Repository Structure
```
sigma-rules/
├── README.md                     
├── CHANGELOG.md
├── CVE/
│   ├── README.md
│   ├── diagrams/
│   ├── CVE-2025-6218_WinRAR/
│   │   ├── rules/
│   │   ├── playbook/
│   │   └── diagrams/
│   └── CVE-2025-50165_WindowsGraphics/
│       ├── rules/
│       ├── playbook/
│       └── diagrams/
└── diagrams/
```

---

### 🔗 Quick Links
- 📁 CVE Packs: `CVE/`
- 📄 Pack structure guide: `CVE/README_CVE.md`
- 🖼️ Global diagrams: `CVE/diagrams/`
- 🧾 Changelog: `CHANGELOG.md`

---

### 🧩 Available CVE Packs
- **CVE-2025-6218** — WinRAR (*Path Traversal, Persistence*)
- **CVE-2025-50165** — Windows Graphics Component (*Weaponized images, renderer exploitation*)

---

### 🛡️ Sigma Rule Levels
- **BROAD / BROADPLUS**: threat hunting, maximum coverage
- **STRICT**: production SOC, low noise / high confidence

---

### 🔁 Sigma → SIEM Conversion
```bash
pip install sigma-cli
sigma convert -t elasticsearch rule.yml
sigma convert -t opensearch_lucene rule.yml
sigma convert -t splunk rule.yml
sigma convert -t sentinel rule.yml
```

---

### 🤝 Contribution
- **One folder = one CVE**
- FR + EN documentation recommended
- Diagrams strongly encouraged (attack flow + detection points)

---

### ⚠️ Disclaimer
Defensive use only.  
Rules must be tested and adapted before production deployment.

### 🧾 Suivi des changements
Toutes les évolutions du dépôt (nouvelles CVE, règles ajoutées, améliorations, corrections)
sont documentées dans le fichier :

👉 **[CHANGELOG.md](CHANGELOG.md)**

### 🧾 Change Tracking
All notable changes to this repository (new CVEs, rules, improvements, fixes)
are documented in:

👉 **[CHANGELOG.md](CHANGELOG.md)**
## 🧾 Changelog
➡️ See: [CHANGELOG.md](./CHANGELOG.md)


