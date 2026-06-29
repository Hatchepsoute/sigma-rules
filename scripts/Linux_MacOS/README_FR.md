# Validation des règles Sigma — Linux et macOS

[English version](README.md)

Ce document explique comment valider toutes les règles Sigma du dépôt sous Linux et macOS à l'aide du script Bash portable.

---

## Objectif

Le script `validate_all_rules_portable.sh` permet aux équipes SOC et aux contributeurs de :

- valider toutes les règles Sigma situées dans `**/rules/*.yml` et `**/rules/*.yaml`
- gérer automatiquement les prérequis manquants
- lancer la validation depuis n'importe quel répertoire du dépôt

---

## Fonctionnement du script

1. Détection de la racine Git (`.git`)
2. Vérification de Python 3
3. Vérification de pip et pipx
4. Installation de sigma-cli via pipx si absent (espace utilisateur, sans root)
5. Collecte de toutes les règles sous `*/rules/`
6. Exécution de `sigma check` sur l'ensemble des règles

---

## Prérequis

- Linux ou macOS
- Bash 4+
- Python 3.9 ou supérieur (recommandé : 3.10+)

Aucun privilège root requis. Ne pas exécuter le script avec `sudo`.

---

## Utilisation

Rendre le script exécutable (première fois uniquement) :

```bash
chmod +x scripts/Linux_MacOS/validate_all_rules_portable.sh
```

Lancer depuis n'importe quel répertoire du dépôt :

```bash
bash scripts/Linux_MacOS/validate_all_rules_portable.sh
```

---

## Résultat attendu

```
[*] sigma already installed: 3.0.2
[*] Found 152 Sigma rule files under */rules/ (repo: /chemin/vers/sigma-rules)
[*] Running: sigma check <all rule files>
[*] Done.
```

sigma-cli peut remonter des avertissements de sévérité MEDIUM (`InvalidATTACKTagIssue`) pour certaines techniques MITRE ATT&CK. Ces avertissements sont non bloquants.

---

## Installation manuelle

Pour installer sigma-cli manuellement avant de lancer le script :

```bash
pipx install sigma-cli
sigma version
sigma plugin list
```

---

## Documentation associée

- [scripts/README_FR.md](../README_FR.md) — vue d'ensemble de tous les scripts
- [scripts/windows/README_FR.md](../windows/README_FR.md) — équivalent Windows
- [scripts/GUIDE_WAZUH.md](../GUIDE_WAZUH.md) — guide de conversion Wazuh
- [scripts/GUIDE_QRADAR.md](../GUIDE_QRADAR.md) — guide de conversion QRadar
