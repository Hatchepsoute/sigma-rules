# Sigma rules conversion guide for IBM QRadar

[Version française](GUIDE_QRADAR.md)

---

## Situation overview

sigma-cli 3.x is installed. Both QRadar plugins are **Compatible = no** with sigma-cli 3.x:

| Plugin | Compatible with sigma-cli 3.x | Notes |
| :--- | :--- | :--- |
| `qradar` | no | Written for sigma-cli 2.x API |
| `ibm-qradar-aql` | no | Written for sigma-cli 2.x API |

IBM has not yet released a sigma-cli 3.x-compatible version of these plugins.

To check the current status at any time:

```bash
sigma plugin list | grep -i qradar
```

---

## Option A - Lucene fallback (sigma 3.x, works now)

The `convert_to_qradar.sh` script automatically uses `opensearch_lucene` as a fallback when the QRadar plugins are not available. The Lucene queries can be used immediately via:

- **QRadar on Cloud (QRoC):** uses an Elasticsearch backend natively
- **QRadar + Elasticsearch/OpenSearch integration:** forward events to OpenSearch or Elasticsearch alongside QRadar (common with Wazuh or Logstash), then use the Lucene queries in OpenSearch Dashboards
- **Manual AQL translation:** see the translation table below

```bash
bash scripts/convert_to_qradar.sh
```

Output: `scripts/conversions/QRadar_Lucene_Fallback/`

---

## Option B - Native AQL (sigma 2.x virtualenv)

### Installation

Create a separate virtualenv so sigma 2.x and sigma 3.x coexist on the same machine without conflict:

```bash
python3 -m venv .venv-sigma2
source .venv-sigma2/bin/activate

pip install "sigma-cli<3"
sigma version                   # confirm: 2.x.x

sigma plugin install qradar
sigma plugin list | grep qradar # confirm: Compatible = yes

deactivate
```

### Running the conversion

```bash
source .venv-sigma2/bin/activate
bash scripts/convert_to_qradar.sh
deactivate
```

The script detects the active sigma-cli version. Under sigma 2.x with the qradar plugin it generates native AQL output automatically.

Output: `scripts/conversions/QRadar_AQL/`

### Manual conversion (single rule)

```bash
source .venv-sigma2/bin/activate
sigma convert -t qradar CVE-2025-21298_Windows_OLE_RTF_RCE/rules/proc_creation_win_office_rtf_ole_lolbin_strict.yml
deactivate
```

### Switching back to sigma 3.x

The `deactivate` command restores your shell to sigma 3.x automatically. The two versions never interfere because they live in separate environments.

---

## Running the conversion script

```bash
# Auto-detect version (Lucene with sigma 3.x, AQL with sigma 2.x)
bash scripts/convert_to_qradar.sh

# Print version status and available options, then exit
bash scripts/convert_to_qradar.sh --upgrade

# Always produce Lucene regardless of sigma version
bash scripts/convert_to_qradar.sh --force-lucene

# Convert a single CVE pack only
bash scripts/convert_to_qradar.sh --input CVE-2025-21298_Windows_OLE_RTF_RCE

# Print the list of generated files at the end
bash scripts/convert_to_qradar.sh --show
```

---

## Output structure

```
scripts/conversions/QRadar_Lucene_Fallback/   <- sigma 3.x (current default)
├── Windows/
│   ├── raw/         <- Lucene query, exact sigma output
│   └── one-line/    <- same, collapsed to a single line
├── Web_Network/
├── Linux/
├── Other/
└── QRADAR_USAGE.md

scripts/conversions/QRadar_AQL/               <- sigma 2.x + qradar plugin
├── Windows/
│   ├── raw/         <- AQL query
│   └── one-line/
├── Web_Network/
├── Linux/
├── Other/
└── QRADAR_USAGE.md
```

---

## Using the queries in QRadar

### Lucene queries - QRadar on Cloud

1. Open QRadar on Cloud → Log Activity → Search
2. Paste the Lucene query from `raw/` into the search bar
3. Adjust the time range

### AQL queries - QRadar Log Activity

1. QRadar → Log Activity → Advanced Search
2. Paste the AQL query from `raw/`
3. Adjust `START` and `STOP` time range
4. Click Search

### AQL queries - Custom Rule Engine (CRE)

1. QRadar → Offenses → Rules → Actions → Add Rule
2. Rule type: **Event**
3. Condition: "when an event matches"
4. Build a filter from the `WHERE` clause of the AQL query
5. Set severity and action (create offense, send email, etc.)

### AQL queries - Saved searches

1. Log Activity → Advanced Search → enter the AQL query
2. Actions → Save Criteria
3. Schedule automatic execution if needed

---

## Lucene to AQL translation reference

When translating Lucene fallback queries to AQL manually:

| Lucene | AQL |
| :--- | :--- |
| `process.executable:*cmd.exe` | `"process_path" ILIKE '%cmd.exe'` |
| `process.command_line:*-enc*` | `"command_args" ILIKE '%-enc%'` |
| `winlog.event_id:4688` | `"EventID" = '4688'` |
| `A AND B` | `A AND B` |
| `A OR B` | `(A OR B)` |
| `NOT A` | `NOT A` |
| `field:(val1 OR val2)` | `"field" ILIKE '%val1%' OR "field" ILIKE '%val2%'` |

AQL query structure:

```sql
SELECT * FROM events
WHERE
    <conditions>
    START '%s' STOP '%s'
```

---

## Field mapping in QRadar

Field names depend on the DSM (Device Support Module) and custom properties configured in your environment.

### Windows (via Wazuh agent or syslog forwarding)

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

Check Administration → System Configuration → Custom Properties for the exact names in your environment.

---

## Verify installation

```bash
# sigma 3.x (current environment)
sigma version
sigma plugin list | grep -i qradar    # should show Compatible = no

# sigma 2.x virtualenv
source .venv-sigma2/bin/activate
sigma version                          # should show 2.x.x
sigma plugin list | grep -i qradar    # should show Compatible = yes
deactivate
```
