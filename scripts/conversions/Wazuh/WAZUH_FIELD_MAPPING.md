# Field mapping guide for Wazuh

The Lucene queries in this folder use Sigma field names (or the ECS
field names produced by the `sysmon` pipeline). Wazuh stores event
data differently depending on version and pipeline configuration.
Adapt the field names in each query to match your Wazuh deployment.

## Windows rules (sysmon pipeline)

| Sigma / ECS field          | Wazuh 4.x + ECS module       | Wazuh < 4.x (raw agent)            |
| :------------------------- | :---------------------------- | :---------------------------------- |
| `process.executable`       | `winlog.event_data.Image`     | `data.win.eventdata.image`          |
| `process.command_line`     | `winlog.event_data.CommandLine` | `data.win.eventdata.commandLine`  |
| `process.parent.executable`| `winlog.event_data.ParentImage` | `data.win.eventdata.parentImage`  |
| `process.parent.command_line` | `winlog.event_data.ParentCommandLine` | `data.win.eventdata.parentCommandLine` |
| `winlog.channel`           | `winlog.channel`              | `data.win.system.channel`           |
| `winlog.event_id`          | `winlog.event_id`             | `data.win.system.eventID`           |
| `file.path`                | `winlog.event_data.TargetFilename` | `data.win.eventdata.targetFilename` |
| `registry.path`            | `winlog.event_data.TargetObject` | `data.win.eventdata.targetObject` |
| `user.name`                | `user.name`                   | `data.win.eventdata.user`           |
| `host.name`                | `agent.name`                  | `agent.name`                        |

## Windows rules (windows pipeline)

| Sigma field              | Wazuh / Windows Security log     |
| :----------------------- | :-------------------------------- |
| `SubjectUserName`        | `data.win.eventdata.subjectUserName` |
| `TargetUserName`         | `data.win.eventdata.targetUserName`  |
| `NewProcessName`         | `data.win.eventdata.newProcessName`  |
| `ProcessCommandLine`     | `data.win.eventdata.processCommandLine` |

## Web / network rules

These rules use the webserver / proxy / firewall logsource and are
converted without a pipeline. Field names in the output match the
Sigma generic names (`cs-uri-stem`, `cs-method`, `sc-status`).

If you ingest web logs into Wazuh via the filebeat/nginx module or
similar, adapt the field path prefix:
  - Nginx via Wazuh module: `data.nginx.*` or `nginx.access.*` (ECS)
  - Apache: `data.apache2.*` or `apache.access.*` (ECS)

## Linux rules

| Sigma field   | Wazuh / auditd field              |
| :------------ | :-------------------------------- |
| `Image`       | `data.audit.exe`                  |
| `CommandLine` | `data.audit.command`              |
| `User`        | `data.audit.auid` / `data.audit.uid` |

## How to use these queries in Wazuh

### Option 1 - OpenSearch Dashboards Discover
1. Open Wazuh → Threat Intelligence → Dashboards → Discover
2. Select the `wazuh-alerts-*` index pattern
3. Paste the Lucene query from `raw/` into the search bar
4. Adapt field names according to the mapping table above

### Option 2 - OpenSearch Alerting monitor
1. In OpenSearch Dashboards, go to Alerting → Monitors → Create monitor
2. Select "Per query monitor" and "Extraction query editor"
3. Use the query from `raw/` as the `query.query_string.query` value
4. Set the index to `wazuh-alerts-*`

### Option 3 - Wazuh custom rules (XML)
Sigma cannot generate Wazuh XML rules directly. The Lucene queries
in this folder serve as the detection logic reference. To write a
native Wazuh XML rule, use the query fields as `<field>` conditions
and refer to the Wazuh documentation on custom rules.

## Re-generating these queries

```bash
cd scripts
./convert_to_wazuh.sh
# Or for native Windows Security log field names:
./convert_to_wazuh.sh --windows-pipeline windows
# Or for a specific CVE pack:
./convert_to_wazuh.sh --input ../CVE-2025-XXXX_ProductName
```
