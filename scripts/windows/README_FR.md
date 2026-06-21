# Validation des règles Sigma – Windows

👉🏾 [English version available here](README.md)

Ce document explique comment **valider toutes les règles Sigma** du dépôt sous **Windows** à l’aide du script PowerShell fourni.

---

## 🎯 Objectif

Le script `validate_all_rules.ps1` permet aux équipes SOC et aux contributeurs de :

- Valider **toutes les règles Sigma** situées dans `**/rules/*.yml` et `**/rules/*.yaml`
- Éviter les erreurs liéeses aux prérequis manquants
- Lancer la validation depuis **n’importe quel répertoire** du dépôt
- Offrir une expérience **clone → run** fluide à la communauté

---

## 📦 Fonctionnement du script

Le script effectue automatiquement :

1. La détection de la **racine Git** (`.git`)
2. La vérification de **Python (3.9+)**
3. La vérification de **pip**
4. La vérification de **pipx** (recommandé)
5. L’installation de **sigma-cli** si absent
6. La collecte de toutes les règles sous `*/rules/`
7. L’exécution de `sigma check` sur l’ensemble des règles (par lots)

---

## 🖥️ Prérequis

- Windows 10 / Windows 11
- PowerShell 5.1+ ou PowerShell 7+
- Python 3.9 ou supérieur (recommandé : 3.10+)

> ⚠️ Les outils sont installés **dans l’espace utilisateur** (aucun droit administrateur requis).

---

## ▶️ Utilisation

### 1️⃣ Ouvrir PowerShell

Ouvrez un terminal PowerShell et placez-vous dans le dépôt (ou un sous-dossier).

### 2️⃣ Lancer le script

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Windows\validate_all_rules.ps1
```

### 3️⃣ Paramètres optionnels

Exécuter sans installer les outils manquants :

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Windows\validate_all_rules.ps1 -InstallIfMissing:$false
```

Forcer manuellement la racine du dépôt :

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Windows\validate_all_rules.ps1 -RepoRoot "C:\chemin\vers\sigma-rules"
```

---

## ✅ Résultat attendu

- Nombre de règles Sigma détectées
- Progression de la validation par lots
- Messages d’erreur clairs en cas de règle invalide

Exemple :

```
[*] Found 268 Sigma rule files under **\rules\
[*] Running: sigma check (batch size=200)
[*] Done.
```

---

## 🧠 Bonnes pratiques

- Lancer le script **avant chaque commit**
- Ne pas exécuter en administrateur
- Utiliser ce script en local et en CI

---

## 📁 Emplacement du script

```
scripts/
└── Windows/
    └── validate_all_rules.ps1
```

---

## Auteur

✍🏿  Adama ASSIONGBON - SOC & CTI Consultant  
[LinkedIn Profile](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

