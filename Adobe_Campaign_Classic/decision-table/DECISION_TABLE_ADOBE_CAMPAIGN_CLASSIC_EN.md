# Adobe Campaign Classic SOC decision table

[Version française](./DECISION_TABLE_ADOBE_CAMPAIGN_CLASSIC_FR.md)

| Alert and evidence | Severity | Confidence | L1 triage | Escalation condition | Likely false positive | Recommended response | Evidence to collect |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `nlserver web` starts a shell, interpreter, proxy-execution binary, or delayed-execution utility with an encoded or download command | Critical | High | Validate parent path and web module; capture command, user, hash, destination, and build | Always escalate unless the exact action is covered by an approved change | Authorized security validation or documented custom extension | Isolate according to policy, restrict application access, preserve volatile evidence | Process tree, command lines, binary, EDR network, `web.log`, `watchdog.log`, proxy and WAF logs |
| `nlserver web` starts a known shell or interpreter with a simple local command | High | Medium to high | Confirm the module, command purpose, asset owner, and maintenance window | Escalate when no exact approved use case exists or the build is vulnerable and exposed | Documented troubleshooting or a custom web extension | Contain if unexplained; otherwise create a narrow allowlist using path and full command | Process tree, change ticket, Campaign build, user, child hash and signer |
| `nlserver web` starts `curl`, `wget`, `certutil`, `bitsadmin`, `ftp`, `ssh`, `nc`, or `socat` with a transfer marker | High | High | Identify source and destination, transferred object, protocol, and child binary integrity | Escalate for any unapproved external destination or unknown transferred object | Approved integration using an external transfer client | Block destination where authorized, isolate host if transfer is unexplained | DNS, firewall, proxy, EDR network, command line, downloaded file and hash |
| Parent is `nlserver`, but the parent command line shows `wfserver`, `mta`, or another non-web module | Informational for these rules | Low for this detection hypothesis | Review under the module-specific baseline | Escalate only if the child behavior is independently malicious | Legitimate Campaign workflow or delivery processing | Do not force this web-module rule to cover the event; investigate with a separate use case | Module name, workflow owner, execution history, command and file evidence |
| Child is renamed outside a temporary path or code executes in-process with no suspicious child event | No alert expected | Not applicable | Hunt using application, EDR memory, crash, file, and network evidence | Escalate when independent malicious evidence exists | Not applicable | Improve telemetry; do not weaken the strict rule with every child process | Campaign logs, memory alerts, module loads, file writes, network events |

## Tuning guardrails

- Allowlist only a verified child path together with its expected full command pattern and responsible change process.
- Do not exclude the Campaign service account globally.
- Do not exclude all activity during maintenance windows.
- Keep parent command-line collection enabled because the module name separates the web server from workflow execution.
- Review allowlists after Campaign upgrades or custom-extension changes.
