# Validation des règles Sigma - Windows

[English version](README.md)

---

## Prérequis

Avant de lancer un script de ce dépôt, effectuer les étapes d'installation ci-dessous.

### Python 3.9 ou supérieur

Télécharger depuis [python.org](https://www.python.org/downloads/) ou installer via `winget` :

```powershell
winget install Python.Python.3.12
```

Vérifier :

```powershell
python --version   # doit afficher 3.9 ou supérieur
```

### pipx

```powershell
pip install pipx
pipx ensurepath
```

Redémarrer le terminal PowerShell après `pipx ensurepath`.

### sigma-cli 3.x

```powershell
pipx install sigma-cli
sigma version        # doit afficher 3.x.x
```

### Plugins sigma (requis pour les scripts de conversion)

```powershell
sigma plugin install opensearch       # backend OpenSearch / Wazuh
sigma plugin install elasticsearch    # backends Elasticsearch / EQL / ES|QL / ElastAlert
sigma plugin install splunk           # backends Splunk SPL et SPL2
sigma plugin install sysmon           # pipeline sysmon (utilisé par presque toutes les conversions)
sigma plugin install windows          # pipelines logsources Windows
sigma plugin install kusto            # backend Kusto/KQL + Sentinel, Defender XDR, Azure Monitor
sigma plugin install netwitness       # backend RSA NetWitness
```

Vérifier :

```powershell
sigma plugin list
sigma list targets
```

### QRadar AQL (optionnel, nécessite sigma 2.x)

Les deux plugins QRadar sont Compatible = no avec sigma-cli 3.x. L'AQL natif nécessite sigma-cli 2.x. Sous Windows, créer un virtualenv séparé :

```powershell
python -m venv .venv-sigma2
.venv-sigma2\Scripts\Activate.ps1
pip install "sigma-cli<3"
sigma plugin install qradar
deactivate
```

Voir [scripts/GUIDE_QRADAR.md](../GUIDE_QRADAR.md) pour les détails. Les scripts de conversion (`convert_to_qradar.sh`) sont en Bash ; les exécuter sous WSL ou Git Bash sous Windows.

---

## Objectif

Le script `validate_all_rules.ps1` valide toutes les règles Sigma du dépôt sous Windows. Il installe automatiquement sigma-cli via pipx si absent et traite les règles par lots de 200 pour rester dans les limites d'arguments de PowerShell.

---

## Fonctionnement du script

1. Détection de la racine Git (`.git`)
2. Vérification de Python 3.9+
3. Vérification de pip et pipx
4. Installation de sigma-cli via pipx si absent (espace utilisateur, sans droits administrateur)
5. Collecte de toutes les règles sous `*\rules\`
6. Exécution de `sigma check` sur l'ensemble des règles par lots de 200

---

## Utilisation

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

## Documentation associée

- [scripts/README_FR.md](../README_FR.md) - vue d'ensemble complète et guide d'installation
- [scripts/Linux_MacOS/README_FR.md](../Linux_MacOS/README_FR.md) - équivalent Linux / macOS
- [scripts/GUIDE_WAZUH.md](../GUIDE_WAZUH.md) - guide de conversion Wazuh
- [scripts/GUIDE_QRADAR.md](../GUIDE_QRADAR.md) - guide de conversion QRadar
