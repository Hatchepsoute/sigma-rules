# Using these queries in QRadar (Lucene fallback)

These queries were generated with the `opensearch_lucene` backend.
Native AQL output is not available because both QRadar plugins
(qradar, ibm-qradar-aql) are Compatible=no with sigma-cli 3.x.
They were written for the sigma-cli 2.x API.

Run `./convert_to_qradar.sh --upgrade` to see the options.

## Using Lucene queries in QRadar

### Option 1 — QRadar on Cloud (QRoC)
QRadar on Cloud uses an Elasticsearch backend. Lucene queries
can be used directly in the QRoC search interface.

### Option 2 — QRadar + Elasticsearch/OpenSearch integration
If you forward events to an OpenSearch or Elasticsearch cluster
alongside QRadar (common with Wazuh or Logstash):
1. Use the Lucene queries from `raw/` in OpenSearch Dashboards.
2. Correlate with QRadar offenses via source IP or host name.

### Option 3 — Manual AQL translation
The Lucene query syntax translates approximately to AQL as follows:

| Lucene                                     | QRadar AQL                                      |
| :----------------------------------------- | :---------------------------------------------- |
| `process.executable:*cmd.exe`              | `"process_path" ILIKE '%cmd.exe'`               |
| `process.command_line:*-enc*`              | `"command_args" ILIKE '%-enc%'`                 |
| `winlog.event_id:4688`                     | `"EventID" = '4688'`                            |
| `event.category:process`                   | `devicetype = <Windows log source ID>`          |
| `A AND B`                                  | `A AND B`                                       |
| `A OR B`                                   | `(A OR B)`                                      |
| `NOT A`                                    | `NOT A`                                         |

AQL structure:
```sql
SELECT * FROM events WHERE
  <translated condition>
  START '%s' STOP '%s'
```

## To get native AQL output

Option A — sigma-cli 2.x in a separate virtualenv:
```bash
python3 -m venv .venv-sigma2
source .venv-sigma2/bin/activate
pip install "sigma-cli<3"
sigma plugin install qradar
sigma convert -t qradar <rule.yml>
```

Option B — wait for IBM to publish a sigma 3.x-compatible plugin:
```bash
sigma plugin list | grep -i qradar   # watch for Compatible = yes
```
