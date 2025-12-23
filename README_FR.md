# 🛡️ sigma-rules — Packs de détection SOC (Sigma + Réponse)
### Sigma Rules for CVE Detection & SOC / Blue Team Operations

<!-- Badges (edit the links if you rename the repo/branch) -->
![Sigma](https://img.shields.io/badge/Sigma-rules-blue)
![SOC](https://img.shields.io/badge/SOC-ready-success)
![SOAR](https://img.shields.io/badge/SOAR-playbooks-important)
![MITRE](https://img.shields.io/badge/MITRE-ATT%26CK-lightgrey)
![License](https://img.shields.io/badge/License-MIT-informational)

Un dépôt de **packs de détection SOC** pour des vulnérabilités à fort impact (Patch Tuesday, avis éditeurs),
basé sur des **règles Sigma**, des **diagrammes d’attaque**, des **tables décisionnelles des analystes SOC N1/N2** et des **playbooks SOAR**.

🌍 English version: [README.md](README.md)

---

## 🎯 Contenu d’un pack
- ✅ Règles Sigma (**BROAD** + **STRICT** lorsque pertinent)
- 🧭 Diagrammes (SVG + PNG)
- 📋 Tables décisionnelles analystes SOC N1/N2  (Markdown + PDF lorsque pertinent)
- 🐝 Playbooks SOAR (templates YAML TheHive)
- 📘 READMEs du pack (EN par défaut + FR)

---

## 📦 Packs disponibles

| Pack | Focus | Artefacts |
|---|---|---|
| **CVE-2025-54100 – RCE Windows (Userland)** | Patterns PowerShell/IWR + exécution enfant | Règles + Diagrammes + Table décisionnelle + Playbook TheHive |
| **CVE-2025-62221 – EoP Kernel Windows** | Anomalie User→SYSTEM + post‑EoP | Règles + Diagrammes + Table décisionnelle + Playbook TheHive |
| **CVE-2025-50165 – Windows Graphics** | Exploitation documents/renderer | Règles + Diagrammes + Playbook |
| **CVE-2025-6218 – WinRAR** | Exploitation archive + post‑exécution | Règles + Diagrammes + Playbook |

---

## 🗂️ Structure du dépôt

```text
sigma-rules/
├── CVE-2025-54100_WindowsUserland/
├── CVE-2025-62221_WindowsKernel/
├── CVE-2025-50165_WindowsGraphics/
├── CVE-2025-6218_WinRAR/
├── diagrams/                  # diagrammes globaux (overview, réutilisables)
├── INSTALLATION.md            # guide d'installation / tooling Sigma
├── CHANGELOG.md               # historique des releases
├── README.md                  # EN (par défaut)
└── README_FR.md               # FR
```

---

## 🚀 Démarrage rapide

### 1) Valider une règle
```bash
sigma check <rule.yml>
```

### 2) Convertir vers un backend (ex: ElastAlert)
```bash
sigma convert -t elastalert -p windows-logsources <rule.yml>
```

> Pour OpenSearch Lucene, un processing pipeline peut être requis :
> `sigma list pipelines opensearch_lucene`

---

## 🧩 Conventions

### Nommage
- Packs : `CVE-YYYY-NNNNN_Contexte/`
- Règles : nommées par comportement (pas uniquement la CVE), suffixes `_broad` / `_strict`
- Docs : `README.md` (EN par défaut) + `README_FR.md`

### Sévérité
- BROAD : Medium (triage/hunting)
- STRICT : High (action/containment)

---
## 🧠 Règles Sigma du SOC : Vue d'ensemble opérationnelle

![Diagramme SOC ](diagrams/sigma_rules_vue_globale_soc_3D_FR.png)

## 📌 Release v0.2.0
- Ajout du pack complet **CVE-2025-54100** (règles + diagrammes + table décisionnelle + playbook TheHive).
Voir : [CHANGELOG.md](CHANGELOG.md)
