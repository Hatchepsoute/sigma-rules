# Validation des règles Sigma – Linux & macOS

Ce document explique comment **valider toutes les règles Sigma** du dépôt sous **Linux et macOS** à l’aide du script Bash portable.

👉 **English version available**: [README.md](README.md)  
👉 **Version Windows** : `scripts/Windows/README_FR.md`

---

## 🎯 Objectif

Le script `validate_all_rules_portable.sh` permet aux équipes SOC et aux contributeurs de :

- Valider **toutes les règles Sigma** situées dans `**/rules/*.yml` et `**/rules/*.yaml`
- Gérer automatiquement les prérequis manquants
- Lancer la validation depuis **n’importe quel répertoire** du dépôt
- Harmoniser la validation entre Linux, macOS et Windows

---

## 📦 Fonctionnement du script

Le script effectue automatiquement :

1. La détection de la **racine Git** (`.git`)
2. La vérification de **Python 3**
3. La vérification de **pip / pipx**
4. L’installation de **sigma-cli** si absent (espace utilisateur)
5. La collecte de toutes les règles sous `*/rules/`
6. L’exécution de `sigma check` sur l’ensemble des règles

---

## 🖥️ Prérequis

- Linux ou macOS
- Bash 4+
- Python 3.9 ou supérieur (recommandé : 3.10+)

> ⚠️ Aucun privilège root requis.  
> Ne pas exécuter le script avec `sudo`.

---

## ▶️ Utilisation

### 1️⃣ Rendre le script exécutable

```bash
chmod +x scripts/Linux_MacOS/validate_all_rules_portable.sh
```

### 2️⃣ Lancer le script

Depuis n’importe quel répertoire du dépôt :

```bash
./scripts/Linux_MacOS/validate_all_rules_portable.sh
```

---

## ✅ Résultat attendu

- Nombre total de règles Sigma détectées
- Progression de la validation
- Messages d’erreur explicites en cas de règle invalide

Exemple :

```
[*] Found 268 Sigma rule files under */rules/
[*] Running: sigma check <all rules>
[*] Done.
```

---

## 🧠 Bonnes pratiques

- Lancer le script **avant chaque commit**
- Maintenir la conformité Sigma des règles
- Combiner avec une validation CI/CD

---

## 📁 Emplacement du script

```
scripts/
└── Linux_MacOS/
    ├── validate_all_rules_portable.sh
    ├── README.md
    └── README_FR.md
```

---

## 👤 Auteur

Adama ASSIONGBON  
Analyste SOC & CTI

---
