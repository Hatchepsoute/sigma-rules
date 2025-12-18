# 🛡️ sigma-rules
### Community Sigma Rules for CVE Detection & Blue Team Operations

## 🎯 Objectif du dépôt
Ce dépôt fournit une collection de règles Sigma orientées Blue Team, organisées par CVE,
afin de détecter l’exploitation de vulnérabilités connues et les comportements post-exploitation
observés en environnement SOC.

Approche : comportementale, agnostique SIEM (ELK, OpenSearch, Splunk, Sentinel, Wazuh, EDR).

## 🧠 Philosophie
❌ Signatures statiques uniquement  
✅ Détection comportementale et contextuelle

## 📦 Organisation
Chaque CVE est traitée comme un pack indépendant.

```
sigma-rules/
├── README.md
├── packs/
│   ├── CVE-2025-6218_WinRAR/
│   └── CVE-2025-50165_WindowsGraphics/
└── diagrams/
```

## 🧩 Packs disponibles
- CVE-2025-6218 – WinRAR (Path Traversal / Persistence)
- CVE-2025-50165 – Windows Graphics Component (weaponized images)

## 🛡️ Niveaux de règles
- BROAD : hunting, couverture maximale
- STRICT : production SOC, faible bruit

## 🔁 Conversion Sigma → SIEM
Utiliser sigma-cli :
```bash
pip install sigma-cli
sigma convert -t splunk rule.yml
sigma convert -t elasticsearch rule.yml
sigma convert -t sentinel rule.yml
```

## 🤝 Contribution
Chaque nouvelle CVE doit être ajoutée sous le dossier packs/.

## ⚠️ Disclaimer
Usage défensif uniquement. Tester avant production.

---

# 🛡️ sigma-rules
### Community Sigma Rules for CVE Detection & Blue Team Operations

## 🎯 Repository Objective
This repository provides a collection of **Blue Team–oriented Sigma rules**, organized by CVE,
to detect the exploitation of known vulnerabilities and **post-exploitation behaviors**
observed in SOC environments.

Approach: **behavior-based**, **SIEM-agnostic** (ELK, OpenSearch, Splunk, Microsoft Sentinel, Wazuh, EDR).

## 🧠 Detection Philosophy
❌ Static signature-based detection only  
✅ **Behavioral and contextual detection**

## 📦 Repository Organization
Each vulnerability is treated as an **independent CVE pack**.

```
sigma-rules/
├── README.md
├── packs/
│   ├── CVE-2025-6218_WinRAR/
│   └── CVE-2025-50165_WindowsGraphics/
└── diagrams/
```

## 🧩 Available CVE Packs
- **CVE-2025-6218** – WinRAR (Path Traversal / Persistence)
- **CVE-2025-50165** – Windows Graphics Component (weaponized images)

## 🛡️ Rule Levels
- **BROAD**: threat hunting, maximum coverage
- **STRICT**: production SOC, low noise

## 🔁 Sigma → SIEM Conversion
Use `sigma-cli`:

```bash
pip install sigma-cli
sigma convert -t splunk rule.yml
sigma convert -t elasticsearch rule.yml
sigma convert -t sentinel rule.yml
```

## 🤝 Contribution
Each new CVE must be added under the `packs/` directory.

## ⚠️ Disclaimer
Defensive use only.
Rules must be tested and adapted to each environment before production deployment.
