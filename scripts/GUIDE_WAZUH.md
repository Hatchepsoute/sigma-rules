# Guide de conversion des règles Sigma pour Wazuh

[English version](GUIDE_WAZUH_EN.md)

## Prérequis

- sigma-cli 3.x installé via pipx :

```bash
pipx install sigma-cli
```

- Plugins nécessaires (vérifier avec `sigma plugin list`) :
  - `sysmon` : pipeline — Compatible = yes
  - `windows` : pipeline — Compatible = yes
  - `opensearch` : backend — Compatible = yes

---

## Lancer la conversion

Depuis la racine du dépôt :

```bash
bash scripts/convert_to_wazuh.sh
```

Options disponibles :

```bash
# Tout le dépôt (par défaut)
bash scripts/convert_to_wazuh.sh

# Pipeline Windows Security logs (EventID 4688) plutôt que Sysmon
bash scripts/convert_to_wazuh.sh --windows-pipeline windows

# Un seul pack CVE
bash scripts/convert_to_wazuh.sh --input CVE-2025-21298_Windows_OLE_RTF_RCE

# Afficher la liste des fichiers générés à la fin
bash scripts/convert_to_wazuh.sh --show
```

---

## Fonctionnement de la classification par logsource

Le script classe chaque règle par logsource avant d'appliquer un pipeline :

| Type de règle | Pipeline appliqué | Dossier de sortie |
| :--- | :--- | :--- |
| `product: windows` | `sysmon` (ou `windows` avec `--windows-pipeline windows`) | `Windows_Sysmon/` ou `Windows_Windows/` |
| `product: linux` | aucun | `Linux/` |
| `category: webserver`, `firewall`, `proxy`, `dns` | aucun | `Web_Network/` |
| Autre | aucun | `Other/` |

Ce mécanisme évite les mauvais mappings de champs sur les règles Linux et web.

---

## Résultat de la conversion

Les fichiers sont générés dans `scripts/conversions/Wazuh/` :

```
scripts/conversions/Wazuh/
├── Windows_Sysmon/
│   ├── raw/         <- requête Lucene (formatage d'origine)
│   └── one-line/    <- même requête sur une seule ligne
├── Web_Network/
│   ├── raw/
│   └── one-line/
├── Linux/
│   ├── raw/
│   └── one-line/
├── Other/
│   ├── raw/
│   └── one-line/
└── WAZUH_FIELD_MAPPING.md
```

Un fichier `.txt` par règle Sigma. Le nom encode le chemin de la règle :

```
CVE-2025-21298_Windows_OLE_RTF_RCE__rules__proc_creation_win_office_rtf_ole_lolbin_strict.txt
```

Utiliser `raw/` par défaut. Utiliser `one-line/` uniquement si le SIEM exige une query string sur une seule ligne.

---

## Quelle pipeline choisir ?

| Déploiement Wazuh | Option recommandée |
| :--- | :--- |
| Wazuh 4.x avec agent Sysmon | `--windows-pipeline sysmon` (défaut) |
| Wazuh + Windows Security Event logs (EventID 4688) | `--windows-pipeline windows` |
| Les deux en parallèle | Lancer le script deux fois avec les deux options |

---

## Règles ignorées

Le script affiche `[skip] no output:` pour les règles que sigma-cli ne peut pas convertir avec le pipeline sélectionné. Causes courantes :

- Logsource spécifique à un produit non couvert par les pipelines disponibles (Fortinet, Palo Alto, HPE)
- Règle utilisant une syntaxe sigma non supportée par le backend `opensearch_lucene`

Ces règles ne sont pas perdues. Les convertir individuellement :

```bash
sigma convert -t opensearch_lucene CVE-XXXX/rules/ma_regle.yml
```

---

## Utiliser les requêtes dans Wazuh

### Option 1 — OpenSearch Dashboards (Discover)

1. Ouvrir Wazuh → Threat Intelligence → Discover
2. Sélectionner l'index pattern `wazuh-alerts-*`
3. Coller la requête depuis `raw/` dans la barre de recherche
4. Adapter les noms de champs si nécessaire (voir section ci-dessous)

### Option 2 — OpenSearch Alerting (monitor automatique)

1. OpenSearch Dashboards → Alerting → Monitors → Create monitor
2. Choisir **Per query monitor** → **Extraction query editor**
3. Coller la valeur de la requête dans `query.query_string.query`
4. Index cible : `wazuh-alerts-*`
5. Configurer le canal de notification (Slack, email, webhook)

Exemple de monitor JSON :

```json
{
  "name": "CVE-2025-21298 - Office RCE STRICT",
  "type": "query",
  "inputs": [{
    "search": {
      "indices": ["wazuh-alerts-*"],
      "query": {
        "query": {
          "query_string": {
            "query": "<COLLER ICI LE CONTENU DU FICHIER raw/>"
          }
        }
      }
    }
  }],
  "triggers": [{
    "name": "alert",
    "severity": "1",
    "condition": { "script": { "source": "ctx.results[0].hits.total.value > 0" } }
  }]
}
```

### Option 3 — Saved search Wazuh dashboard

1. Discover → saisir la requête → Save
2. La saved search peut être ajoutée à un dashboard Wazuh

---

## Adaptation des noms de champs

Le pipeline `sysmon` génère des noms de champs ECS. Wazuh stocke les événements différemment selon la version et la configuration.

### Windows — pipeline sysmon

| Champ sigma / ECS | Wazuh 4.x + module ECS | Wazuh < 4.x (agent brut) |
| :--- | :--- | :--- |
| `process.executable` | `winlog.event_data.Image` | `data.win.eventdata.image` |
| `process.command_line` | `winlog.event_data.CommandLine` | `data.win.eventdata.commandLine` |
| `process.parent.executable` | `winlog.event_data.ParentImage` | `data.win.eventdata.parentImage` |
| `process.parent.command_line` | `winlog.event_data.ParentCommandLine` | `data.win.eventdata.parentCommandLine` |
| `winlog.event_id` | `winlog.event_id` | `data.win.system.eventID` |
| `winlog.channel` | `winlog.channel` | `data.win.system.channel` |
| `file.path` | `winlog.event_data.TargetFilename` | `data.win.eventdata.targetFilename` |
| `registry.path` | `winlog.event_data.TargetObject` | `data.win.eventdata.targetObject` |
| `user.name` | `user.name` | `data.win.eventdata.user` |
| `host.name` | `agent.name` | `agent.name` |

### Windows — pipeline windows (Security logs)

| Champ sigma | Wazuh / Windows Security log |
| :--- | :--- |
| `SubjectUserName` | `data.win.eventdata.subjectUserName` |
| `TargetUserName` | `data.win.eventdata.targetUserName` |
| `NewProcessName` | `data.win.eventdata.newProcessName` |
| `ProcessCommandLine` | `data.win.eventdata.processCommandLine` |

### Linux

| Champ sigma | Wazuh / auditd |
| :--- | :--- |
| `Image` | `data.audit.exe` |
| `CommandLine` | `data.audit.command` |
| `User` | `data.audit.auid` / `data.audit.uid` |
| `ProcessId` | `data.audit.pid` |

### Web et réseau

Les règles web et firewall sont converties sans pipeline. Les noms de champs sont les noms génériques sigma bruts. Adapter selon le module Wazuh utilisé pour ingérer les logs web :

| Champ sigma | Nginx (module Wazuh) | Apache (module Wazuh) |
| :--- | :--- | :--- |
| `cs-method` | `data.nginx.method` | `data.apache2.method` |
| `sc-status` | `data.nginx.status` | `data.apache2.status` |
| `cs-uri-stem` | `data.nginx.url` | `data.apache2.url` |
| `c-ip` | `data.nginx.remoteip` | `data.apache2.remoteip` |

---

## Vérifier l'installation de sigma-cli

```bash
sigma version
sigma plugin list | grep -E "sysmon|windows|opensearch"
```

Pour mettre à jour :

```bash
pipx upgrade sigma-cli
sigma plugin list
```
