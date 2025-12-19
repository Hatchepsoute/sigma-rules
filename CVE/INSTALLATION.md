# 🛠️ Sigma CLI — Installation, Conversion & SOC Usage Guide

---

## 🌍 Language Notice / Avis de langue

🇫🇷 **Français**  
Ce document commence par la **version française**, suivie de la **version anglaise**.

🇬🇧 **English**  
This document starts with the **French version**, followed by the **English version**.

---

# 🇫🇷 VERSION FRANÇAISE

## 🎯 Objectif du document
Ce guide explique **comment installer Sigma CLI**, **convertir des règles Sigma**
et **les exploiter concrètement en SOC** après conversion, notamment dans :
- **ELK / OpenSearch**
- **Splunk**
- autres SIEM basés sur Lucene

Il s’adresse aux **analystes SOC / Blue Team** travaillant sur **Windows ou Linux**.

---

## 🧠 Principe clé (à retenir)
- **Sigma = langage de détection agnostique**
- **Conversion = adaptation au SIEM**
- **Le SOC travaille toujours sur la règle convertie**, pas sur le YAML Sigma brut

---

## 🖥️ Installation selon l’OS

### ▶️ Linux (recommandé SOC)

#### Installation avec pipx
```bash
sudo apt install pipx -y
pipx ensurepath
pipx install sigma-cli
```

Vérification :
```bash
sigma version
```

---

### ▶️ Windows (poste analyste)

#### Prérequis
- Python ≥ 3.9
- pipx ou pip

#### Installation simple
```powershell
pip install sigma-cli
```

Vérification :
```powershell
sigma version
```

💡 **Bonnes pratiques SOC** :  
➡️ conversion sur Linux (serveur SOC)  
➡️ lecture / tuning sur Windows possible

---

## 🔌 Installation des plugins Sigma

```bash
sigma plugin install opensearch
sigma plugin install elasticsearch
sigma plugin install splunk
sigma plugin install kusto
sigma plugin install sysmon
sigma plugin install windows
```

Vérifier :
```bash
sigma plugin list
```

---

## 🔄 Conversion des règles Sigma

### 🟢 ELK / OpenSearch (SOC le plus courant)

```bash
sigma convert -t opensearch_lucene -p sysmon rule.yml
```

➡️ Résultat : **requête Lucene**

Utilisation :
- Kibana / OpenSearch Dashboards
- règle d’alerte
- règle de détection SOC

---

### 🟡 Elasticsearch pur
```bash
sigma convert -t elasticsearch -p sysmon rule.yml
```

---

### 🔵 Splunk
```bash
sigma convert -t splunk -p sysmon rule.yml
```

➡️ Résultat : **SPL**
- à coller dans :
  - Correlation Search
  - Saved Search
  - Detection Rule

---

## 🧑‍💻 Comment un analyste SOC l’utilise concrètement

### Étape 1 — Écriture Sigma
- Détection BROAD ou STRICT
- Pensée détection, pas SIEM

### Étape 2 — Conversion
- Choix du backend (`-t`)
- Choix du pipeline (`-p sysmon`)

### Étape 3 — Déploiement SIEM
- Coller la requête convertie
- Ajuster index / timeframe
- Ajouter seuils et exceptions

### Étape 4 — Tuning
- Réduction des faux positifs
- Ajout de exclusions métier

---

## ⚠️ Erreurs courantes à éviter

❌ Utiliser Sigma directement dans le SIEM  
❌ Confondre backend et pipeline  
❌ Déployer sans validation

✔️ Toujours :
```bash
sigma check *.yml
```

---

## 🧠 Workflow SOC recommandé

```text
Sigma Rule
   ↓
Validation
   ↓
Conversion
   ↓
SIEM (ELK / Splunk)
   ↓
Alerting
   ↓
SOAR / IR
```

---

## ⚠️ Avertissement
Usage défensif uniquement.  
Toujours tester avant mise en production.

---

# 🇬🇧 ENGLISH VERSION

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
sigma plugin install sysmon
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

---

## 👨‍💻 SOC Analyst Usage Flow
1. Write Sigma rule
2. Convert
3. Deploy in SIEM
4. Tune
5. Alert & respond

---

## ⚠️ Disclaimer
Defensive usage only.  
Test before production.

---

**Author:** Adama Assiongbon  
**Role:** SOC / CTI Analyst Consultant  
**Last update:** 2025-12-19
