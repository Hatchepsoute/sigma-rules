This document is bilingual (French and English).  The French version appears first, followed by the English version.
# 📁 CVE – Règles Sigma & Playbooks SOAR

Ce répertoire contient des **packs organisés par vulnérabilité CVE**, destinés aux équipes **SOC, CTI, Blue Team et Purple Team**.

Chaque dossier CVE fournit :
- des **règles Sigma de détection**
- des **playbooks SOAR de réponse à incident**
- des **diagrammes de chaîne d’attaque et de workflow**

L’objectif est de proposer une approche **détection → analyse → réponse**, directement exploitable en environnement SOC.

---

## 🗂️ Structure d’un pack CVE

Chaque vulnérabilité est isolée dans son propre dossier :

```
CVE/
└── CVE-YYYY-XXXX_<Produit_ou_Contexte>/
    ├── README_EN.md
    ├── README_FR.md
    ├── rules/
    │   ├── *_BROAD*.yml
    │   └── *_STRICT*.yml
    ├── playbook/
    │   ├── SOAR_Playbook_*.md
    │   └── implementations/
    │       ├── thehive/
    │       ├── shuffle/
    │       └── diagrams/
    └── diagrams/
```
---
## 🎯 Philosophie de détection
Les règles Sigma sont volontairement proposées à plusieurs niveaux :

- **BROAD / BROADPLUS**
  - Détection comportementale large
  - Threat hunting
  - Détection précoce ou post-exploitation

- **STRICT**
  - Détection à forte confiance
  - Réduction des faux positifs
  - Adaptée aux environnements SOC de production
---

## 🧠 Contenu SOAR

Les playbooks SOAR incluent :
- enrichissement automatique (CTI, IoCs, MITRE ATT&CK)
- qualification faux positif / vrai positif
- évaluation de l’impact
- recommandations de remédiation
- intégrations possibles avec :
  - TheHive
  - Shuffle
  - SIEM compatibles Sigma (Elastic, OpenSearch, Sentinel, Splunk via conversion)

---

## 🔗 Références techniques

- CVE / NVD
- MITRE ATT&CK
- SigmaHQ
- CISA & Bulletins éditeurs

Chaque pack CVE référence explicitement les sources utilisées.

---

## 👥 Public cible

- Analystes SOC (N1 à N3)
- Analystes CTI
- Blue / Purple Team
- Ingénieurs sécurité
- Étudiants et chercheurs en cybersécurité

---

## 📌 Note

Ce dépôt est conçu pour être :
- Modulaire
- Scalable
- Orienté opérations SOC réelles

Les contributions et améliorations sont encouragées.
---
# 📁 CVE – Sigma Rules & SOAR Playbooks

This directory contains **CVE-based packs** designed for **SOC, CTI, Blue Team, and Purple Team** operations.

Each CVE directory provides:
- **Sigma detection rules**
- **SOAR incident response playbooks**
- **Attack flow and workflow diagrams**

The objective is to deliver an **end-to-end approach: detection → analysis → response**, directly usable in real SOC environments.

---

## 🗂️ CVE Pack Structure

Each vulnerability is isolated in its own directory:

```
CVE/
└── CVE-YYYY-XXXX_<Product_or_Context>/
    ├── README_EN.md
    ├── README_FR.md
    ├── rules/
    │   ├── *_BROAD*.yml
    │   └── *_STRICT*.yml
    ├── playbook/
    │   ├── SOAR_Playbook_*.md
    │   └── implementations/
    │       ├── thehive/
    │       ├── shuffle/
    │       └── diagrams/
    └── diagrams/
```

