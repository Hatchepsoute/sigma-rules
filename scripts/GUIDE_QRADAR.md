# Guide de conversion des règles Sigma pour IBM QRadar

[English version](GUIDE_QRADAR_EN.md)

## Situation actuelle

sigma-cli 3.0.2 est installé. Les deux backends QRadar sont actuellement marqués **Compatible = no** :

| Backend | Etat | Compatible sigma-cli 3.x |
| :--- | :--- | :--- |
| `qradar` | stable | non |
| `ibm-qradar-aql` | stable | non |

Le script `convert_to_qradar.sh` détecte cela automatiquement et bascule en sortie Lucene. Ce fallback est pleinement exploitable dès maintenant via QRadar on Cloud ou via une intégration Elasticsearch/OpenSearch.

Pour vérifier l'état des plugins à tout moment :

```bash
sigma plugin list | grep -i qradar
```

Lorsque l'un de ces plugins deviendra compatible, le script passera automatiquement en mode AQL sans aucune modification.

---

## Lancer la conversion

Depuis la racine du dépôt :

```bash
bash scripts/convert_to_qradar.sh
```

Options disponibles :

```bash
# Tout le dépôt (par défaut)
bash scripts/convert_to_qradar.sh

# Afficher l'état des plugins et quitter
bash scripts/convert_to_qradar.sh --upgrade

# Forcer le fallback Lucene même si un plugin QRadar devient compatible
bash scripts/convert_to_qradar.sh --force-lucene

# Un seul pack CVE
bash scripts/convert_to_qradar.sh --input CVE-2025-21298_Windows_OLE_RTF_RCE

# Afficher la liste des fichiers générés
bash scripts/convert_to_qradar.sh --show
```

---

## Résultat de la conversion

### Sortie actuelle (fallback Lucene)

```
scripts/conversions/QRadar_Lucene_Fallback/
├── Windows/
│   ├── raw/
│   └── one-line/
├── Web_Network/
│   ├── raw/
│   └── one-line/
├── Linux/
│   ├── raw/
│   └── one-line/
├── Other/
│   ├── raw/
│   └── one-line/
└── QRADAR_USAGE.md
```

### Sortie future (AQL natif, quand le plugin deviendra compatible)

```
scripts/conversions/QRadar_AQL/
├── Windows/
├── Web_Network/
├── Linux/
├── Other/
└── QRADAR_USAGE.md
```

---

## Utiliser les requêtes Lucene dans QRadar

### Option 1 — QRadar on Cloud (QRoC)

QRadar on Cloud utilise un backend Elasticsearch natif. Les requêtes Lucene du dossier `raw/` peuvent être utilisées directement dans l'interface de recherche QRoC.

### Option 2 — QRadar + intégration Elasticsearch / OpenSearch

Si l'organisation envoie les logs vers un cluster Elasticsearch ou OpenSearch en parallèle de QRadar (architecture courante avec Wazuh, Elastic SIEM ou Logstash) :

1. Utiliser les requêtes du dossier `raw/` dans OpenSearch Dashboards ou Kibana
2. Corréler avec les offenses QRadar via l'adresse IP ou l'identifiant d'hôte

### Option 3 — Traduction manuelle Lucene vers AQL

Pour convertir une requête Lucene en AQL à la main :

| Lucene | AQL |
| :--- | :--- |
| `process.executable:*cmd.exe` | `"process_path" ILIKE '%cmd.exe'` |
| `process.command_line:*-enc*` | `"command_args" ILIKE '%-enc%'` |
| `winlog.event_id:4688` | `"EventID" = '4688'` |
| `A AND B` | `A AND B` |
| `A OR B` | `(A OR B)` |
| `NOT A` | `NOT A` |
| `field:(val1 OR val2)` | `"field" ILIKE '%val1%' OR "field" ILIKE '%val2%'` |

Structure AQL type :

```sql
SELECT *
FROM events
WHERE
    <conditions traduites depuis le Lucene>
    START '%s' STOP '%s'
```

---

## Utiliser les requêtes AQL dans QRadar (quand disponibles)

### Option 1 — Log Activity (recherche manuelle)

1. QRadar → Log Activity → Advanced Search
2. Coller la requête AQL depuis `raw/`
3. Ajuster les plages temporelles `START` / `STOP`
4. Exécuter et analyser les résultats

### Option 2 — Custom Rule Engine (CRE)

1. QRadar → Offenses → Rules → Actions → Add Rule
2. Type de règle : **Event**
3. Condition : "when an event matches"
4. Construire un filtre à partir de la clause `WHERE` de la requête AQL
5. Définir le niveau de sévérité et l'action (créer une offense, envoyer un email, etc.)

### Option 3 — Saved searches

1. Log Activity → Advanced Search → saisir la requête AQL
2. Actions → Save Criteria
3. Planifier une exécution automatique si besoin

---

## Correspondance des champs dans QRadar

Les noms de champs dépendent du DSM (Device Support Module) utilisé pour parser les logs. Adapter selon la configuration.

### Windows (agent Wazuh → QRadar via syslog ou Universal DSM)

| Champ sigma / ECS | Champ QRadar probable |
| :--- | :--- |
| `process.executable` | Custom property (DSM Windows) |
| `process.command_line` | Custom property / Command |
| `winlog.event_id` | Custom property EventID |
| `user.name` | Username |
| `host.name` | Source Host Name |
| `source.ip` | Source IP |

### Web et réseau

| Champ sigma | Champ QRadar probable |
| :--- | :--- |
| `cs-method` | Method (HTTP DSM) |
| `sc-status` | Response Code |
| `cs-uri-stem` | URL |
| `c-ip` | Source IP |
| `UserAgent` | User Agent (custom property) |

Les noms de champs QRadar exacts dépendent du DSM et des custom properties définis dans l'environnement. Consulter Administration → System Configuration → Custom Properties pour vérifier les noms disponibles.

---

## Vérifier l'installation

```bash
sigma version
sigma plugin list | grep -i qradar
```

Pour mettre à jour sigma-cli :

```bash
pipx upgrade sigma-cli
sigma plugin list | grep -i qradar
```
