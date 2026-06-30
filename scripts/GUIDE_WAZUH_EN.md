# Sigma rules conversion guide for Wazuh

[Version française](GUIDE_WAZUH.md)

## Prerequisites

### sigma-cli 3.x

```bash
pip install pipx
pipx ensurepath          # restart your terminal after this
pipx install sigma-cli
sigma version            # should print 3.x.x
```

### Required plugins

```bash
sigma plugin install opensearch    # OpenSearch / Wazuh backend
sigma plugin install sysmon        # Sysmon pipeline (field mapping)
sigma plugin install windows       # Windows log source pipeline (Security logs variant)
```

Verify:

```bash
sigma plugin list | grep -E "opensearch|sysmon|windows"
sigma list targets | grep opensearch
```

---

## Running the conversion

From the repository root:

```bash
bash scripts/convert_to_wazuh.sh
```

Available options:

```bash
# Entire repository (default)
bash scripts/convert_to_wazuh.sh

# Windows Security log pipeline (EventID 4688) instead of Sysmon
bash scripts/convert_to_wazuh.sh --windows-pipeline windows

# Single CVE pack only
bash scripts/convert_to_wazuh.sh --input CVE-2025-21298_Windows_OLE_RTF_RCE

# Print the list of generated files at the end
bash scripts/convert_to_wazuh.sh --show
```

---

## How logsource classification works

The script classifies each rule by logsource before applying a pipeline:

| Rule type | Pipeline applied | Output folder |
| :--- | :--- | :--- |
| `product: windows` | `sysmon` (or `windows` with `--windows-pipeline windows`) | `Windows_Sysmon/` or `Windows_Windows/` |
| `product: linux` | none | `Linux/` |
| `category: webserver`, `firewall`, `proxy`, `dns` | none | `Web_Network/` |
| Other | none | `Other/` |

This prevents incorrect field mappings on Linux and web rules.

---

## Conversion output

Files are generated in `scripts/conversions/Wazuh/`:

```
scripts/conversions/Wazuh/
├── Windows_Sysmon/
│   ├── raw/         <- Lucene query (original formatting)
│   └── one-line/    <- same query collapsed to a single line
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

One `.txt` file per Sigma rule. The filename encodes the full rule path:

```
CVE-2025-21298_Windows_OLE_RTF_RCE__rules__proc_creation_win_office_rtf_ole_lolbin_strict.txt
```

Use `raw/` by default. Use `one-line/` only if your SIEM requires a single-line query string.

---

## Which pipeline to choose?

| Wazuh deployment | Recommended option |
| :--- | :--- |
| Wazuh 4.x with Sysmon agent | `--windows-pipeline sysmon` (default) |
| Wazuh + native Windows Security Event logs (EventID 4688) | `--windows-pipeline windows` |
| Both in parallel | Run the script twice with each option |

---

## Skipped rules

The script prints `[skip] no output:` for rules that sigma-cli cannot convert with the selected pipeline. Common causes:

- Logsource specific to a product not covered by any pipeline (Fortinet, Palo Alto, HPE)
- Rule using a Sigma syntax feature not supported by the `opensearch_lucene` backend

These rules are not lost. Convert them individually:

```bash
sigma convert -t opensearch_lucene CVE-XXXX/rules/my_rule.yml
```

---

## Using the queries in Wazuh

### Option 1 - OpenSearch Dashboards (Discover)

1. Open Wazuh → Threat Intelligence → Discover
2. Select the `wazuh-alerts-*` index pattern
3. Paste the query from `raw/` into the search bar
4. Adapt field names if needed (see field mapping section below)

### Option 2 - OpenSearch Alerting (automatic monitor)

1. OpenSearch Dashboards → Alerting → Monitors → Create monitor
2. Choose **Per query monitor** → **Extraction query editor**
3. Paste the query value into `query.query_string.query`
4. Target index: `wazuh-alerts-*`
5. Configure a notification channel (Slack, email, webhook)

Example monitor JSON:

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
            "query": "<PASTE THE CONTENT OF raw/ HERE>"
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

### Option 3 - Wazuh dashboard saved search

1. Discover → enter the query → Save
2. The saved search can then be added to a Wazuh dashboard

---

## Field name mapping

The `sysmon` pipeline generates ECS field names. Wazuh stores events differently depending on version and pipeline configuration.

### Windows - sysmon pipeline

| Sigma / ECS field | Wazuh 4.x + ECS module | Wazuh < 4.x (raw agent) |
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

### Windows - windows pipeline (Security logs)

| Sigma field | Wazuh / Windows Security log |
| :--- | :--- |
| `SubjectUserName` | `data.win.eventdata.subjectUserName` |
| `TargetUserName` | `data.win.eventdata.targetUserName` |
| `NewProcessName` | `data.win.eventdata.newProcessName` |
| `ProcessCommandLine` | `data.win.eventdata.processCommandLine` |

### Linux

| Sigma field | Wazuh / auditd |
| :--- | :--- |
| `Image` | `data.audit.exe` |
| `CommandLine` | `data.audit.command` |
| `User` | `data.audit.auid` / `data.audit.uid` |
| `ProcessId` | `data.audit.pid` |

### Web and network

Web and firewall rules are converted without a pipeline. Field names are the raw Sigma generic names. Adapt based on your Wazuh web log ingestion module:

| Sigma field | Nginx (Wazuh module) | Apache (Wazuh module) |
| :--- | :--- | :--- |
| `cs-method` | `data.nginx.method` | `data.apache2.method` |
| `sc-status` | `data.nginx.status` | `data.apache2.status` |
| `cs-uri-stem` | `data.nginx.url` | `data.apache2.url` |
| `c-ip` | `data.nginx.remoteip` | `data.apache2.remoteip` |

---

## Verify sigma-cli installation

```bash
sigma version
sigma plugin list | grep -E "sysmon|windows|opensearch"
```

To upgrade:

```bash
pipx upgrade sigma-cli
sigma plugin list
```
