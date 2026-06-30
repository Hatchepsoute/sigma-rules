# Guide de conversion des règles Sigma pour IBM QRadar

[English version](GUIDE_QRADAR_EN.md)

---

## Situation actuelle

sigma-cli 3.x est installé. Les deux plugins QRadar sont **Compatible = no** avec sigma-cli 3.x :

| Plugin | Compatible sigma-cli 3.x | Notes |
| :--- | :--- | :--- |
| `qradar` | non | Ecrit pour l'API sigma-cli 2.x |
| `ibm-qradar-aql` | non | Ecrit pour l'API sigma-cli 2.x |

IBM n'a pas encore publié de version compatible sigma-cli 3.x de ces plugins.

Pour vérifier l'état à tout moment :

```bash
sigma plugin list | grep -i qradar
```

---

## Option A - Fallback Lucene (sigma 3.x, disponible immédiatement)

Le script `convert_to_qradar.sh` utilise automatiquement `opensearch_lucene` en fallback quand les plugins QRadar ne sont pas disponibles. Les requêtes Lucene peuvent être utilisées immédiatement via :

- **QRadar on Cloud (QRoC) :** utilise un backend Elasticsearch natif
- **QRadar + intégration Elasticsearch/OpenSearch :** transmettre les événements vers OpenSearch ou Elasticsearch en parallèle de QRadar (architecture courante avec Wazuh ou Logstash), puis utiliser les requêtes Lucene dans OpenSearch Dashboards
- **Traduction AQL manuelle :** voir le tableau de correspondance ci-dessous

```bash
bash scripts/convert_to_qradar.sh
```

Sortie : `scripts/conversions/QRadar_Lucene_Fallback/`

---

## Option B - AQL natif (virtualenv sigma 2.x)

### Installation

Créer un virtualenv séparé pour que sigma 2.x et sigma 3.x coexistent sur la même machine sans conflit :

```bash
python3 -m venv .venv-sigma2
source .venv-sigma2/bin/activate

pip install "sigma-cli<3"
sigma version                   # confirmer : 2.x.x

sigma plugin install qradar
sigma plugin list | grep qradar # confirmer : Compatible = yes

deactivate
```

### Lancer la conversion

```bash
source .venv-sigma2/bin/activate
bash scripts/convert_to_qradar.sh
deactivate
```

Le script détecte la version active de sigma-cli. Sous sigma 2.x avec le plugin qradar il génère automatiquement de l'AQL natif.

Sortie : `scripts/conversions/QRadar_AQL/`

### Conversion manuelle (règle unique)

```bash
source .venv-sigma2/bin/activate
sigma convert -t qradar CVE-2025-21298_Windows_OLE_RTF_RCE/rules/proc_creation_win_office_rtf_ole_lolbin_strict.yml
deactivate
```

### Revenir à sigma 3.x

La commande `deactivate` restaure automatiquement le shell sur sigma 3.x. Les deux versions ne s'interfèrent pas car elles vivent dans des environnements séparés.

---

## Lancer le script de conversion

```bash
# Détection automatique de la version (Lucene avec sigma 3.x, AQL avec sigma 2.x)
bash scripts/convert_to_qradar.sh

# Afficher l'état de la version et les options AQL, puis quitter
bash scripts/convert_to_qradar.sh --upgrade

# Forcer Lucene quelle que soit la version sigma active
bash scripts/convert_to_qradar.sh --force-lucene

# Convertir un seul pack CVE
bash scripts/convert_to_qradar.sh --input CVE-2025-21298_Windows_OLE_RTF_RCE

# Afficher la liste des fichiers générés à la fin
bash scripts/convert_to_qradar.sh --show
```

---

## Structure de sortie

```
scripts/conversions/QRadar_Lucene_Fallback/   <- sigma 3.x (défaut actuel)
├── Windows/
│   ├── raw/         <- requête Lucene, sortie sigma exacte
│   └── one-line/    <- même requête sur une seule ligne
├── Web_Network/
├── Linux/
├── Other/
└── QRADAR_USAGE.md

scripts/conversions/QRadar_AQL/               <- sigma 2.x + plugin qradar
├── Windows/
│   ├── raw/         <- requête AQL
│   └── one-line/
├── Web_Network/
├── Linux/
├── Other/
└── QRADAR_USAGE.md
```

---

## Utiliser les requêtes dans QRadar

### Requêtes Lucene - QRadar on Cloud

1. Ouvrir QRadar on Cloud → Log Activity → Search
2. Coller la requête Lucene depuis `raw/` dans la barre de recherche
3. Ajuster la plage temporelle

### Requêtes AQL - Log Activity

1. QRadar → Log Activity → Advanced Search
2. Coller la requête AQL depuis `raw/`
3. Ajuster les plages `START` et `STOP`
4. Cliquer sur Search

### Requêtes AQL - Custom Rule Engine (CRE)

1. QRadar → Offenses → Rules → Actions → Add Rule
2. Type de règle : **Event**
3. Condition : "when an event matches"
4. Construire un filtre à partir de la clause `WHERE` de la requête AQL
5. Définir la sévérité et l'action (créer une offense, envoyer un email, etc.)

### Requêtes AQL - Saved searches

1. Log Activity → Advanced Search → saisir la requête AQL
2. Actions → Save Criteria
3. Planifier une exécution automatique si besoin

---

## Tableau de correspondance Lucene vers AQL

Pour traduire manuellement les requêtes Lucene du fallback en AQL :

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
SELECT * FROM events
WHERE
    <conditions>
    START '%s' STOP '%s'
```

---

## Correspondance des champs dans QRadar

Les noms de champs dépendent du DSM (Device Support Module) et des custom properties configurés dans l'environnement.

### Windows (via agent Wazuh ou transfert syslog)

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

Consulter Administration → System Configuration → Custom Properties pour les noms exacts dans l'environnement.

---

## Vérifier l'installation

```bash
# sigma 3.x (environnement courant)
sigma version
sigma plugin list | grep -i qradar    # doit afficher Compatible = no

# virtualenv sigma 2.x
source .venv-sigma2/bin/activate
sigma version                          # doit afficher 2.x.x
sigma plugin list | grep -i qradar    # doit afficher Compatible = yes
deactivate
```
