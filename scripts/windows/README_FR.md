# Validation des règles Sigma — Windows

[English version](README.md)

Ce document explique comment valider toutes les règles Sigma du dépôt sous Windows à l'aide du script PowerShell fourni.

---

## Objectif

Le script `validate_all_rules.ps1` permet aux équipes SOC et aux contributeurs de :

- valider toutes les règles Sigma situées dans `**\rules\*.yml` et `**\rules\*.yaml`
- gérer automatiquement les prérequis manquants
- lancer la validation depuis n'importe quel répertoire du dépôt

---

## Fonctionnement du script

1. Détection de la racine Git (`.git`)
2. Vérification de Python 3.9+
3. Vérification de pip et pipx
4. Installation de sigma-cli via pipx si absent (espace utilisateur, sans droits administrateur)
5. Collecte de toutes les règles sous `*\rules\`
6. Exécution de `sigma check` sur l'ensemble des règles par lots de 200

---

## Prérequis

- Windows 10 ou Windows 11
- PowerShell 5.1+ ou PowerShell 7+
- Python 3.9 ou supérieur (recommandé : 3.10+)

Les outils sont installés dans l'espace utilisateur. Aucun droit administrateur requis.

---

## Utilisation

Ouvrir un terminal PowerShell et se placer dans le dépôt ou un sous-dossier.

Lancer le script :

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\validate_all_rules.ps1
```

Exécuter sans installer les outils manquants :

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\validate_all_rules.ps1 -InstallIfMissing:$false
```

Forcer manuellement la racine du dépôt :

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\validate_all_rules.ps1 -RepoRoot "C:\chemin\vers\sigma-rules"
```

---

## Résultat attendu

```
[*] Repo root: C:\chemin\vers\sigma-rules
[*] sigma already installed.
[*] Found 152 Sigma rule files under **\rules\
[*] Running: sigma check (batch size=200)
[*] Done.
```

sigma-cli peut remonter des avertissements de sévérité MEDIUM (`InvalidATTACKTagIssue`) pour certaines techniques MITRE ATT&CK. Ces avertissements sont non bloquants.

---

## Installation manuelle

Pour installer sigma-cli manuellement avant de lancer le script :

```powershell
pip install pipx
pipx install sigma-cli
sigma version
sigma plugin list
```

---

## Documentation associée

- [scripts/README_FR.md](../README_FR.md) — vue d'ensemble de tous les scripts
- [scripts/Linux_MacOS/README_FR.md](../Linux_MacOS/README_FR.md) — équivalent Linux / macOS
- [scripts/GUIDE_WAZUH.md](../GUIDE_WAZUH.md) — guide de conversion Wazuh
- [scripts/GUIDE_QRADAR.md](../GUIDE_QRADAR.md) — guide de conversion QRadar
