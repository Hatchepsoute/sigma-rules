# Scripts - automatisation des règles Sigma

[English version](README.md)

Ce répertoire contient les scripts de validation et de conversion des règles Sigma du dépôt vers des formats exploitables par les SIEM.

---

## Démarrage - installation

### Etape 1 - Python 3.9 ou supérieur

```bash
python3 --version
```

Installer via le gestionnaire de paquets si absent (`apt install python3`, `brew install python3`, etc.).

### Etape 2 - pipx

```bash
pip install pipx
pipx ensurepath
```

Redémarrer le terminal après `pipx ensurepath`.

### Etape 3 - sigma-cli 3.x

```bash
pipx install sigma-cli
sigma version        # doit afficher 3.x.x
```

### Etape 4 - plugins sigma

Installer les plugins nécessaires aux scripts de conversion :

```bash
sigma plugin install opensearch       # backend OpenSearch / Wazuh
sigma plugin install elasticsearch    # backends Elasticsearch / EQL / ES|QL / ElastAlert
sigma plugin install splunk           # backends Splunk SPL et SPL2
sigma plugin install sysmon           # pipeline sysmon (utilisé par presque toutes les conversions)
sigma plugin install windows          # pipelines logsources Windows
sigma plugin install kusto            # backend Kusto/KQL + pipelines Sentinel, Defender XDR, Azure Monitor
sigma plugin install netwitness       # backend RSA NetWitness
```

Vérifier l'installation :

```bash
sigma plugin list
sigma list targets
sigma list pipelines
```

### Etape 5 (optionnel) - QRadar AQL natif

Les deux plugins QRadar (`qradar`, `ibm-qradar-aql`) sont **Compatible = no** avec sigma-cli 3.x. L'AQL natif nécessite sigma-cli 2.x dans un virtualenv séparé :

```bash
python3 -m venv .venv-sigma2
source .venv-sigma2/bin/activate
pip install "sigma-cli<3"
sigma plugin install qradar
sigma version                         # doit afficher 2.x.x
```

Pour utiliser le virtualenv :

```bash
source .venv-sigma2/bin/activate
sigma convert -t qradar rules/ma_regle.yml
deactivate
```

Le script `convert_to_qradar.sh` détecte la version de sigma-cli automatiquement. Sous sigma 3.x il génère un fallback Lucene. Sous sigma 2.x avec le plugin qradar il génère de l'AQL natif.

Voir [GUIDE_QRADAR.md](GUIDE_QRADAR.md) pour tous les détails.

---

## Vue d'ensemble des scripts

| Script | Plateforme | Rôle |
| :--- | :--- | :--- |
| [`validate_all_rules.sh`](validate_all_rules.sh) | Linux / macOS | CI gate : valide toutes les règles avec `sigma check` |
| [`Linux_MacOS/validate_all_rules_portable.sh`](Linux_MacOS/validate_all_rules_portable.sh) | Linux / macOS | Portable : installe sigma-cli automatiquement si absent |
| [`windows/validate_all_rules.ps1`](windows/validate_all_rules.ps1) | Windows | Équivalent PowerShell avec auto-installation |
| [`convert_all_rules.sh`](convert_all_rules.sh) | Linux / macOS | Convertit toutes les règles vers 11 cibles SIEM en une seule exécution |
| [`convert_to_wazuh.sh`](convert_to_wazuh.sh) | Linux / macOS | Conversion dédiée Wazuh avec classification par logsource |
| [`convert_to_qradar.sh`](convert_to_qradar.sh) | Linux / macOS | Conversion QRadar (AQL avec sigma 2.x, fallback Lucene avec sigma 3.x) |

---

## Validation

### `validate_all_rules.sh` - CI gate

Scanne tous les `**/rules/*.yml` récursivement et exécute `sigma check`. Retourne un code d'erreur non nul en cas d'échec.

```bash
bash scripts/validate_all_rules.sh
```

sigma-cli peut remonter des avertissements MEDIUM (`InvalidATTACKTagIssue`) pour certaines techniques MITRE ATT&CK. Ces avertissements sont non bloquants.

### `Linux_MacOS/validate_all_rules_portable.sh` - usage local

Identique, avec installation automatique de sigma-cli si absent. Se lance depuis n'importe quel répertoire du dépôt.

```bash
bash scripts/Linux_MacOS/validate_all_rules_portable.sh
```

Voir [`Linux_MacOS/README_FR.md`](Linux_MacOS/README_FR.md) pour les détails.

### `windows/validate_all_rules.ps1` - Windows

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\validate_all_rules.ps1
```

Voir [`windows/README_FR.md`](windows/README_FR.md) pour les détails.

---

## Conversion

### `convert_all_rules.sh` - toutes les cibles SIEM

Valide puis convertit toutes les règles vers 11 cibles SIEM en une seule exécution.

```bash
bash scripts/convert_all_rules.sh
bash scripts/convert_all_rules.sh --show    # affiche aussi les chemins des fichiers générés
```

Sortie : `scripts/conversions/<label>/raw/` et `scripts/conversions/<label>/one-line/`.

#### Cibles de conversion

| Label | Backend | Pipeline | Plugins requis | Notes |
| :--- | :--- | :--- | :--- | :--- |
| `OpenSearch_ECS` | `opensearch_lucene` | `sysmon` | opensearch, sysmon | Wazuh / OpenSearch |
| `Lucene_Sysmon` | `lucene` | `sysmon` | elasticsearch, sysmon | Elasticsearch brut |
| `Elastic_EQL` | `eql` | `sysmon` | elasticsearch, sysmon | Elastic Security EQL |
| `Elastic_ESQL` | `esql` | `sysmon` | elasticsearch, sysmon | Elastic Security 8.11+ |
| `Elastic_ElastAlert` | `elastalert` | `windows-logsources` | elasticsearch, windows | ElastAlert 2 |
| `Splunk_Windows` | `splunk` | `splunk_windows` | splunk | Splunk Enterprise Security |
| `Splunk_SPL2` | `splunk_spl2` | `splunk_windows` | splunk | Splunk ES 7+ / SPL2 |
| `RSA_NetWitness` | `net_witness` | `sysmon` | netwitness, sysmon | Règles Windows uniquement |
| `Microsoft_Sentinel_KQL` | `kusto` | `sentinel_asim` | kusto | Tables ASIM Sentinel |
| `Microsoft_Defender_XDR_KQL` | `kusto` | `microsoft_xdr` | kusto | Tables Defender XDR |
| `Azure_Monitor_KQL` | `kusto` | `azure_monitor` | kusto | Azure Monitor / Log Analytics |
| `QRadar_AQL` | `qradar` | aucun | sigma 2.x + qradar | Généré uniquement si sigma 2.x actif |

Tous les backends avec `Processing Pipeline Required = yes` reçoivent le pipeline sur toutes les règles quelle que soit la logsource. Linux et web passent en transparence sans transformation de champ, ce qui satisfait l'exigence du backend. Pour les cibles kusto, les règles web sans mapping ASIM/XDR/Azure sont automatiquement retraitées avec `--without-pipeline`.

#### Structure de sortie

```
scripts/conversions/
├── OpenSearch_ECS/raw/        <- requête Lucene, sortie sigma exacte
├── OpenSearch_ECS/one-line/   <- même requête sur une seule ligne
├── Lucene_Sysmon/raw/
├── Elastic_EQL/raw/
├── Elastic_ESQL/raw/
├── Elastic_ElastAlert/raw/
├── Splunk_Windows/raw/
├── Splunk_SPL2/raw/
├── RSA_NetWitness/raw/        <- uniquement si plugin netwitness installé
├── Microsoft_Sentinel_KQL/raw/
├── Microsoft_Defender_XDR_KQL/raw/
├── Azure_Monitor_KQL/raw/
└── QRadar_AQL/raw/            <- uniquement si sigma 2.x + plugin qradar actif
```

Un fichier `.txt` par règle Sigma. Le nom encode le chemin complet de la règle :

```
CVE-2025-21298_Windows_OLE_RTF_RCE__rules__proc_creation_win_office_rtf_ole_lolbin_strict.txt
```

Utiliser `raw/` par défaut. Utiliser `one-line/` uniquement si le SIEM exige une query string sur une seule ligne.

---

### `convert_to_wazuh.sh` - Wazuh / OpenSearch

Conversion dédiée Wazuh. Classe les règles par logsource (Windows, Linux, Web, Other) et écrit des dossiers de sortie séparés par catégorie. Applique le pipeline `sysmon` à toutes les logsources (pass-through pour les règles non-Windows, requis par le backend opensearch_lucene).

```bash
bash scripts/convert_to_wazuh.sh
bash scripts/convert_to_wazuh.sh --windows-pipeline windows   # champs Security logs (EventID 4688)
bash scripts/convert_to_wazuh.sh --input CVE-2025-21298_Windows_OLE_RTF_RCE
bash scripts/convert_to_wazuh.sh --show
```

Sortie : `scripts/conversions/Wazuh/{Windows_Sysmon,Web_Network,Linux,Other}/`.

Voir [`GUIDE_WAZUH.md`](GUIDE_WAZUH.md) pour le mapping de champs et l'intégration Wazuh.

---

### `convert_to_qradar.sh` - QRadar

Détecte automatiquement la version de sigma-cli active et adapte la sortie :

| sigma-cli actif | Sortie | Dossier |
| :--- | :--- | :--- |
| 3.x (installation par défaut) | Fallback Lucene | `QRadar_Lucene_Fallback/` |
| 2.x virtualenv + plugin qradar | AQL natif | `QRadar_AQL/` |

```bash
bash scripts/convert_to_qradar.sh                # détection automatique de la version
bash scripts/convert_to_qradar.sh --upgrade      # afficher l'état et les options AQL
bash scripts/convert_to_qradar.sh --force-lucene # forcer Lucene quelle que soit la version
bash scripts/convert_to_qradar.sh --input CVE-2025-21298_Windows_OLE_RTF_RCE
```

Pour utiliser sigma 2.x et obtenir de l'AQL natif :

```bash
source .venv-sigma2/bin/activate
bash scripts/convert_to_qradar.sh
deactivate
```

Voir [`GUIDE_QRADAR.md`](GUIDE_QRADAR.md) pour tous les détails.

---

## Bonnes pratiques SOC

- Toujours valider avant de convertir : `bash scripts/validate_all_rules.sh`.
- Ne pas déployer de règles qui échouent à `sigma check`.
- Utiliser `validate_all_rules.sh` comme CI gate bloquant.
- Réviser les mappings de champs avant tout déploiement en production.
- Après toute mise à jour de sigma-cli, exécuter `sigma plugin list` pour vérifier la compatibilité des plugins.
- N'activer le virtualenv sigma 2.x que pour les conversions QRadar ; le désactiver ensuite (`deactivate`).
