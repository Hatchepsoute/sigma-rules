# SOC Decision Table - UNC3886 Network & Virtualization Campaign

| Alert | Severity | Confidence | L1 Triage | Escalate When | Probable False Positives | Recommended Response | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| BROAD management probe | Medium | Medium | Check source IP, URL and user agent | Public exposure or repeated hits | Authorized scans, admin jump hosts | Confirm exposure and patch level | Access logs, source IP, URL, UA |
| STRICT shelling/log tamper | High | High | Verify parent process and command line | Shell, log cleanup or persistence changes | Maintenance scripts, vendor support | Isolate host and investigate compromise | Syslog, process telemetry, EDR timeline |
