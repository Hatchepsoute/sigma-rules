# Sigma rules conversion guide for IBM QRadar

[Version française](GUIDE_QRADAR.md)

## Current situation

sigma-cli 3.0.2 is installed. Both QRadar backends are currently marked **Compatible = no**:

| Backend | State | Compatible with sigma-cli 3.x |
| :--- | :--- | :--- |
| `qradar` | stable | no |
| `ibm-qradar-aql` | stable | no |

The `convert_to_qradar.sh` script detects this automatically and falls back to Lucene output. The fallback is fully usable today via QRadar on Cloud or via an Elasticsearch/OpenSearch integration.

To check the current status at any time:

```bash
sigma plugin list | grep -i qradar
```

When one of these plugins becomes compatible, the script will switch to native AQL automatically without any code change.

---

## Running the conversion

From the repository root:

```bash
bash scripts/convert_to_qradar.sh
```

Available options:

```bash
# Entire repository (default)
bash scripts/convert_to_qradar.sh

# Print plugin status and exit
bash scripts/convert_to_qradar.sh --upgrade

# Force Lucene fallback even if a QRadar plugin becomes compatible
bash scripts/convert_to_qradar.sh --force-lucene

# Single CVE pack only
bash scripts/convert_to_qradar.sh --input CVE-2025-21298_Windows_OLE_RTF_RCE

# Print the list of generated files at the end
bash scripts/convert_to_qradar.sh --show
```

---

## Conversion output

### Current output (Lucene fallback)

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

### Future output (native AQL, when plugin becomes compatible)

```
scripts/conversions/QRadar_AQL/
├── Windows/
├── Web_Network/
├── Linux/
├── Other/
└── QRADAR_USAGE.md
```

---

## Using Lucene queries in QRadar

### Option 1 — QRadar on Cloud (QRoC)

QRadar on Cloud uses a native Elasticsearch backend. The Lucene queries from `raw/` can be used directly in the QRoC search interface.

### Option 2 — QRadar + Elasticsearch / OpenSearch integration

If your organisation forwards logs to an Elasticsearch or OpenSearch cluster alongside QRadar (common architecture with Wazuh, Elastic SIEM, or Logstash):

1. Use the queries from `raw/` in OpenSearch Dashboards or Kibana
2. Correlate with QRadar offenses using source IP or host identifier

### Option 3 — Manual Lucene to AQL translation

To manually convert a Lucene query to AQL:

| Lucene | AQL |
| :--- | :--- |
| `process.executable:*cmd.exe` | `"process_path" ILIKE '%cmd.exe'` |
| `process.command_line:*-enc*` | `"command_args" ILIKE '%-enc%'` |
| `winlog.event_id:4688` | `"EventID" = '4688'` |
| `A AND B` | `A AND B` |
| `A OR B` | `(A OR B)` |
| `NOT A` | `NOT A` |
| `field:(val1 OR val2)` | `"field" ILIKE '%val1%' OR "field" ILIKE '%val2%'` |

Typical AQL structure:

```sql
SELECT *
FROM events
WHERE
    <conditions translated from Lucene>
    START '%s' STOP '%s'
```

---

## Using AQL queries in QRadar (when available)

### Option 1 — Log Activity (manual search)

1. QRadar → Log Activity → Advanced Search
2. Paste the AQL query from `raw/`
3. Adjust the `START` / `STOP` time range
4. Run and analyse results

### Option 2 — Custom Rule Engine (CRE)

1. QRadar → Offenses → Rules → Actions → Add Rule
2. Rule type: **Event**
3. Condition: "when an event matches"
4. Build a filter from the `WHERE` clause of the AQL query
5. Set severity level and action (create offense, send email, etc.)

### Option 3 — Saved searches

1. Log Activity → Advanced Search → enter the AQL query
2. Actions → Save Criteria
3. Schedule automatic execution if needed

---

## Field mapping in QRadar

Field names depend on the DSM (Device Support Module) used to parse the logs. Adapt to your configuration.

### Windows (Wazuh agent → QRadar via syslog or Universal DSM)

| Sigma / ECS field | Likely QRadar field |
| :--- | :--- |
| `process.executable` | Custom property (Windows DSM) |
| `process.command_line` | Custom property / Command |
| `winlog.event_id` | Custom property EventID |
| `user.name` | Username |
| `host.name` | Source Host Name |
| `source.ip` | Source IP |

### Web and network

| Sigma field | Likely QRadar field |
| :--- | :--- |
| `cs-method` | Method (HTTP DSM) |
| `sc-status` | Response Code |
| `cs-uri-stem` | URL |
| `c-ip` | Source IP |
| `UserAgent` | User Agent (custom property) |

Exact QRadar field names depend on the DSM and custom properties defined in your environment. Check Administration → System Configuration → Custom Properties for available names.

---

## Verify installation

```bash
sigma version
sigma plugin list | grep -i qradar
```

To upgrade sigma-cli:

```bash
pipx upgrade sigma-cli
sigma plugin list | grep -i qradar
```
