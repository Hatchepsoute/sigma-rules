# Validation des règles Sigma - Linux et macOS

[English version](README.md)

---

## Prérequis

Avant de lancer un script de ce dépôt, effectuer les étapes d'installation ci-dessous.

### Python 3.9 ou supérieur

```bash
python3 --version   # doit afficher 3.9 ou supérieur
```

Installer via le gestionnaire de paquets si absent :

```bash
# Debian / Ubuntu
sudo apt install python3 python3-pip

# macOS
brew install python3
```

### pipx

```bash
pip install pipx
pipx ensurepath
```

Redémarrer le terminal après `pipx ensurepath`.

### sigma-cli 3.x

```bash
pipx install sigma-cli
sigma version        # doit afficher 3.x.x
```

### Plugins sigma (requis pour les scripts de conversion)

```bash
sigma plugin install opensearch       # backend OpenSearch / Wazuh
sigma plugin install elasticsearch    # backends Elasticsearch / EQL / ES|QL / ElastAlert
sigma plugin install splunk           # backends Splunk SPL et SPL2
sigma plugin install sysmon           # pipeline sysmon (utilisé par presque toutes les conversions)
sigma plugin install windows          # pipelines logsources Windows
sigma plugin install kusto            # backend Kusto/KQL + pipelines Sentinel, Defender XDR, Azure Monitor
sigma plugin install netwitness       # backend RSA NetWitness
```

Vérifier :

```bash
sigma plugin list
sigma list targets
```

### QRadar AQL (optionnel, nécessite sigma 2.x)

Les deux plugins QRadar sont Compatible = no avec sigma-cli 3.x. Pour obtenir de l'AQL natif, créer un virtualenv séparé :

```bash
python3 -m venv .venv-sigma2
source .venv-sigma2/bin/activate
pip install "sigma-cli<3"
sigma plugin install qradar
deactivate
```

Voir [scripts/GUIDE_QRADAR.md](../GUIDE_QRADAR.md) pour les détails.

---

## Objectif

Le script `validate_all_rules_portable.sh` valide toutes les règles Sigma du dépôt. Il installe automatiquement sigma-cli via pipx si absent, ce qui le rend adapté à une première utilisation sans configuration préalable.

---

## Fonctionnement du script

1. Détection de la racine Git (`.git`)
2. Vérification de Python 3
3. Vérification de pip et pipx
4. Installation de sigma-cli via pipx si absent (espace utilisateur, sans root)
5. Collecte de toutes les règles sous `*/rules/`
6. Exécution de `sigma check` sur l'ensemble des règles

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

## Documentation associée

- [scripts/README_FR.md](../README_FR.md) - vue d'ensemble complète et guide d'installation
- [scripts/windows/README_FR.md](../windows/README_FR.md) - équivalent Windows
- [scripts/GUIDE_WAZUH.md](../GUIDE_WAZUH.md) - guide de conversion Wazuh
- [scripts/GUIDE_QRADAR.md](../GUIDE_QRADAR.md) - guide de conversion QRadar
