
<!-- Badges (edit the links if you rename the repo/branch) -->
![Sigma](https://img.shields.io/badge/Sigma-rules-blue)
![SOC](https://img.shields.io/badge/SOC-ready-success)
![SOAR](https://img.shields.io/badge/SOAR-playbooks-important)
![MITRE](https://img.shields.io/badge/MITRE-ATT%26CK-lightgrey)
![License](https://img.shields.io/badge/License-MIT-informational)

# 🛡️ Framework Sigma de Détection pour les SOC

![SOC Framework](diagrams/sigma_rules_vue_globale_soc_3D_FR.png)

## 🎯 Objectif

Ce dépôt fournit un **framework de détection orienté SOC**, basé sur des **règles Sigma**, enrichi par :
- Des règles de détection (BROAD & STRICT),
- Des tables décisionnelles des analystes SOC (N1/N2),
- Des playbooks SOAR (TheHive, Shuffle),
- Des diagrammes d’attaque et workflows,
- Des stratégies de détection réalistes basées sur des CVE.

Il s’adresse aux **SOC**, **Blue Teams** et **ingénieurs détection** recherchant des détections exploitables en production.

---

## 🧠 Stratégie de Détection (Doctrine SOC)

Toutes les détections reposent sur un **modèle à deux niveaux** :

### 🔍 Règles BROAD - Visibilité & Threat Hunting
- Couverture comportementale large
- Détection précoce d’activités suspectes
- Adaptées à :
  - La chasse aux menaces
  - La détection de signaux faibles
  - L’analyse des écarts de comportement

### 🎯 Règles STRICT — Confirmation & Alerte
- Détection à forte confiance
- Axée sur :
  - Les lignes de commande malveillantes
  - L’abus de LOLBins
  - Les chaînes d’exploitation
- Adaptées à :
  - L’alerte SOC
  - La réponse à incident
  - L’automatisation SOAR

➡️ **Bonne pratique SOC**  
Les règles BROAD déclenchent l’analyse.  
Les règles STRICT confirment la compromission et justifient l’escalade.

---

## 🔗 Logique de Corrélation

Une détection efficace repose sur la **corrélation** :

- BROAD ➜ signal comportemental
- STRICT ➜ confirmation malveillante
- Table décisionnelle ➜ action analystes SOC (N1/N2)
- Playbook ➜ réponse automatisée

Ce modèle réduit fortement les **faux positifs** tout en conservant une **visibilité précoce**.

---

## 🧩 Structure du Dépôt

Chaque CVE ou thématique suit une structure standardisée :

```
CVE-XXXX-YYYY/
├── rules/              # Règles Sigma BROAD & STRICT
├── diagrams/           # Diagrammes d’attaque & vue SOC
├── decision-table/     # Décision SOC L1/L2
├── playbook/           # Playbooks SOAR / TheHive
├── README.md           # Guide technique & SOC
```

---

## ⚙️ Compatibilité & Validation Sigma

Toutes les règles sont :
- Validées via `sigma check`
- Convertibles vers plusieurs SIEM :
  - OpenSearch / ELK
  - Splunk
  - Elastic (Lucene, EQL, ElastAlert)
  - NetWitness
  - SentinelOne (si applicable)

Un script de validation est fourni :
```bash
scripts/validate_all_rules.sh
```

---

## 🧠 Public Cible

- Analystes SOC (N1 / N2 / N3)
- Blue Team
- Ingénieurs détection
- Threat Hunters
- Consultants sécurité

---

### ✍️ Auteur

**Adama Assiongbon**  
Consultant SOC / CTI  
LinkedIn : https://www.linkedin.com/in/adama-assiongbon-9029893a/

---

### 📜 Licence & Usage

Ce dépôt est destiné exclusivement à des **opérations de sécurité défensive**.
À utiliser dans un cadre légal et éthique.

