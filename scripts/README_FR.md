# 📘 Dépôt Sigma Rules – Automatisation SOC & CTI (FR)

# 🛠️ Scripts d’Automatisation Sigma - Guide SOC (FR)

Ce dépôt fournit **deux scripts Bash** pour les équipes SOC / CTI afin de **valider** et **convertir des règles Sigma** vers plusieurs SIEM.

Les scripts sont conçus pour être exécutés depuis le répertoire `scripts/`.

---

## 📄 Présentation

### 1️⃣ `validate_all_rules.sh` - Contrôle Qualité

- Vérification syntaxique et logique des règles Sigma
- Détection des erreurs et issues de tagging
- Utilisable comme barrière CI

---

### 2️⃣ `convert_all_rules.sh` - Conversion Multi‑SIEM

- Conversion des règles vers plusieurs SIEM
- Génération de requêtes prêtes à l’emploi

**Sortie**
```
scripts/conversions/<SIEM>/{raw,one-line}
```

---

## ▶️ Exécution

```bash
cd scripts
chmod +x validate_all_rules.sh convert_all_rules.sh
./validate_all_rules.sh
./convert_all_rules.sh
```

---

## 💻 Environnements supportés

- Linux (recommandé)
- macOS (partiel)
- Windows via WSL

**Prérequis**
- Bash 4+
- Python 3.9+
- sigma-cli



---

# 🛠️ Scripts d’Automatisation Sigma – Guide SOC (FR)

Ce dépôt fournit **deux scripts Bash** pour les équipes SOC / CTI afin de **valider** et **convertir des règles Sigma** vers plusieurs SIEM.

Les scripts sont conçus pour être exécutés depuis le répertoire `scripts/`.

---

## 📄 Présentation

### 1️⃣ `validate_all_rules.sh` – Contrôle Qualité

- Vérification syntaxique et logique des règles Sigma
- Détection des erreurs et issues de tagging
- Utilisable comme barrière CI

---

### 2️⃣ `convert_all_rules.sh` – Conversion Multi‑SIEM

- Conversion des règles vers plusieurs SIEM
- Génération de requêtes prêtes à l’emploi

**Sortie**
```
scripts/conversions/<SIEM>/{raw,one-line}
```

---

## ▶️ Exécution

```bash
cd scripts
chmod +x validate_all_rules.sh convert_all_rules.sh
./validate_all_rules.sh
./convert_all_rules.sh
```

---

## 💻 Environnements supportés

- Linux (recommandé)
- macOS (partiel)
- Windows via WSL

**Prérequis**
- Bash 4+
- Python 3.9+
- sigma-cli

---


## 📂 Différence entre les répertoires `raw/` et `one-line/`

Lors de l’exécution de `convert_all_rules.sh`, deux répertoires peuvent être générés pour chaque cible SIEM :

### 🔹 `raw/` – Sortie Sigma native (par défaut)
- Sortie exacte produite par `sigma convert`
- Respecte le format d’origine
- Souvent déjà **sur une seule ligne**, selon le backend
- Recommandé pour :
  - Splunk
  - Microsoft Sentinel (KQL)
  - Elastic EQL
  - RSA NetWitness

### 🔹 `one-line/` - Variante de sécurité sur une seule ligne
- Tous les retours à la ligne sont remplacés par des espaces
- Destiné aux moteurs qui **n’acceptent qu’une requête mono-ligne**
- Cas typiques :
  - OpenSearch / Elasticsearch `query_string`
  - Lucene strict
  - SIEM ou parseurs legacy

### ℹ️ Point important
Pour de nombreux backends Sigma (Splunk, KQL, Lucene), la sortie `raw/` est **déjà sur une seule ligne**.  
Il est donc normal que les fichiers `raw/` et `one-line/` soient **identiques** dans ces cas.

Le répertoire `one-line/` est conservé par **choix défensif**, afin d’anticiper :
- des backends générant du multi-ligne
- des contraintes SIEM plus strictes
- des évolutions futures de Sigma

**Règle simple pour les analystes SOC :**
- SIEM compatible multi-ligne → utiliser `raw/`
- SIEM exigeant une seule ligne → utiliser `one-line/`

