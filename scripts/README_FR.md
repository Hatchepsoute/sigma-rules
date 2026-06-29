# Scripts : automatisation des règles Sigma

[English version](README.md)

Ce répertoire contient les scripts d'automatisation pour la validation et la conversion des règles Sigma du dépôt.

---

## Vue d'ensemble

| Script | Plateforme | Rôle |
| :--- | :--- | :--- |
| [`validate_all_rules.sh`](validate_all_rules.sh) | Linux / macOS | Barrière CI : valide toutes les règles avec `sigma check` |
| [`Linux_MacOS/validate_all_rules_portable.sh`](Linux_MacOS/validate_all_rules_portable.sh) | Linux / macOS | Version portable : installe sigma-cli automatiquement si absent |
| [`windows/validate_all_rules.ps1`](windows/validate_all_rules.ps1) | Windows (PowerShell) | Équivalent portable pour les environnements Windows |
| [`convert_all_rules.sh`](convert_all_rules.sh) | Linux / macOS | Convertit toutes les règles vers 7 cibles SIEM |
| [`convert_to_wazuh.sh`](convert_to_wazuh.sh) | Linux / macOS | Conversion dédiée Wazuh avec classification par logsource |
| [`convert_to_qradar.sh`](convert_to_qradar.sh) | Linux / macOS | Conversion QRadar (fallback Lucene ; voir note ci-dessous) |

---

## Prérequis

sigma-cli 3.x, installé via pipx (recommandé) :

```bash
pipx install sigma-cli
```

Vérification :

```bash
sigma version
sigma plugin list
```

Les scripts Bash requièrent Bash 4+ et Python 3.9+. Les scripts portables (`validate_all_rules_portable.sh`, `validate_all_rules.ps1`) gèrent l'installation automatiquement.

---

## Validation

### `validate_all_rules.sh` : barrière CI

Parcourt récursivement tous les `**/rules/*.yml` et `**/rules/*.yaml` et exécute `sigma check`. Retourne un code d'erreur non nul en cas d'échec. Conçu pour les pipelines CI/CD.

```bash
bash scripts/validate_all_rules.sh
```

En cas de succès, sigma-cli peut remonter des avertissements de sévérité MEDIUM (`InvalidATTACKTagIssue`) pour certaines techniques MITRE ATT&CK. Ces avertissements sont non bloquants et attendus pour les règles utilisant des techniques personnalisées ou en cours de validation.

### `Linux_MacOS/validate_all_rules_portable.sh` : usage local

Même validation avec installation automatique de sigma-cli si absent. Peut être lancé depuis n'importe quel répertoire du dépôt.

```bash
bash scripts/Linux_MacOS/validate_all_rules_portable.sh
```

Voir [`Linux_MacOS/README_FR.md`](Linux_MacOS/README_FR.md) pour les détails.

### `windows/validate_all_rules.ps1` : Windows

Équivalent PowerShell. Peut être lancé depuis n'importe quel sous-dossier du dépôt.

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\validate_all_rules.ps1
```

Voir [`windows/README_FR.md`](windows/README_FR.md) pour les détails.

---

## Conversion

### `convert_all_rules.sh` : multi-SIEM

Convertit toutes les règles vers 7 cibles SIEM en une seule exécution. Toujours lancer la validation en premier.

```bash
bash scripts/validate_all_rules.sh
bash scripts/convert_all_rules.sh
```

La sortie est écrite dans `scripts/conversions/<SIEM>/raw/` et `scripts/conversions/<SIEM>/one-line/`.

#### Cibles de conversion et pipelines

| Label | Cible | Pipeline Windows | Portée | Notes |
| :--- | :--- | :--- | :--- | :--- |
| `OpenSearch_ECS` | `opensearch_lucene` | `sysmon` | toutes les règles | Requis par le backend |
| `Lucene_Sysmon` | `lucene` | `sysmon` | toutes les règles | Requis par le backend |
| `Splunk_Windows` | `splunk` | `splunk_windows` | toutes les règles | Requis par le backend |
| `Elastic_ElastAlert` | `elastalert` | `windows-logsources` | toutes les règles | Requis par le backend |
| `Elastic_EQL` | `eql` | `sysmon` | toutes les règles | Requis par le backend |
| `RSA_NetWitness` | `net_witness` | `sysmon` | règles Windows uniquement | Pipeline optionnel |
| `Microsoft_Sentinel_KQL` | `kusto` | `sentinel_asim` | toutes les règles | Fallback `--without-pipeline` pour les règles web |

Les backends marqués "toutes les règles" exigent un pipeline pour chaque conversion quelle que soit la logsource. Le pipeline n'a aucun effet sur les règles Linux et web ; il satisfait simplement l'exigence du backend.

Pour la cible `kusto`, les règles Windows et Linux produisent du KQL ASIM propre (table `imProcessCreate`, champ `TargetProcessName`, etc.). Les règles web dont les champs ne sont pas encore mappés dans ASIM sont automatiquement retraitées avec `--without-pipeline`.

#### Structure de sortie

```
scripts/conversions/
├── OpenSearch_ECS/
│   ├── raw/          <- sortie exacte de sigma convert
│   └── one-line/     <- même requête sur une seule ligne
├── Lucene_Sysmon/
├── Splunk_Windows/
├── Elastic_ElastAlert/
├── Elastic_EQL/
├── RSA_NetWitness/
└── Microsoft_Sentinel_KQL/
```

Un fichier `.txt` par règle Sigma. Le nom encode le chemin de la règle :

```
CVE-2025-21298_Windows_OLE_RTF_RCE__rules__proc_creation_win_office_rtf_ole_lolbin_strict.txt
```

Utiliser `raw/` par défaut. Utiliser `one-line/` uniquement si le SIEM exige une query string sur une seule ligne (certains parseurs OpenSearch ou Lucene legacy).

---

### `convert_to_wazuh.sh` : Wazuh / OpenSearch

Script dédié à Wazuh. Classe chaque règle par logsource avant d'appliquer un pipeline, ce qui évite les mauvais mappings de champs sur les règles Linux et web.

```bash
bash scripts/convert_to_wazuh.sh
bash scripts/convert_to_wazuh.sh --windows-pipeline windows   # champs Security log (EventID 4688)
bash scripts/convert_to_wazuh.sh --input CVE-2025-21298_Windows_OLE_RTF_RCE
bash scripts/convert_to_wazuh.sh --show
```

Sortie : `scripts/conversions/Wazuh/Windows_Sysmon/`, `Web_Network/`, `Linux/`, `Other/`.

Voir [`GUIDE_WAZUH.md`](GUIDE_WAZUH.md) pour le mapping de champs et les détails d'intégration Wazuh.

---

### `convert_to_qradar.sh` : QRadar

Tente de produire des requêtes AQL QRadar. Les plugins `qradar` et `ibm-qradar-aql` sont actuellement marqués `Compatible = no` avec sigma-cli 3.x : le script bascule automatiquement en sortie Lucene, utilisable via QRadar on Cloud ou une intégration Elasticsearch.

```bash
bash scripts/convert_to_qradar.sh
bash scripts/convert_to_qradar.sh --force-lucene
bash scripts/convert_to_qradar.sh --input CVE-2025-21298_Windows_OLE_RTF_RCE
bash scripts/convert_to_qradar.sh --upgrade      # afficher l'état des plugins et quitter
```

Sortie : `scripts/conversions/QRadar_Lucene_Fallback/` (actuellement) ou `scripts/conversions/QRadar_AQL/` (quand les plugins deviendront compatibles).

Voir [`GUIDE_QRADAR.md`](GUIDE_QRADAR.md) pour les détails d'intégration QRadar.

---

## Bonnes pratiques SOC

- Toujours valider avant de convertir.
- Ne jamais déployer des règles qui échouent au `sigma check`.
- Utiliser `validate_all_rules.sh` comme barrière bloquante en CI.
- Traiter les sorties de conversion comme des artefacts de production : vérifier les mappings de champs avant déploiement.
- Lancer `sigma plugin list` après chaque mise à jour de sigma-cli pour vérifier la compatibilité des plugins.
