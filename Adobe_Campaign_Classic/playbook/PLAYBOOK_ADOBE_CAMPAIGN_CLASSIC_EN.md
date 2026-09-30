# Adobe Campaign Classic suspicious child process response playbook

[Version française](./PLAYBOOK_ADOBE_CAMPAIGN_CLASSIC_FR.md)

## Objective

Provide a repeatable SOC response when the Adobe Campaign Classic `nlserver web` module starts a suspicious child process on Windows or Linux. The alert is a high-confidence server-side execution signal, but it does not prove which vulnerability, account, or request caused the activity.

## Scope

This playbook applies to Adobe Campaign Classic v7 servers deployed on-premise or as on-premise components of hybrid environments. Adobe-hosted instances are outside host-level customer visibility. The rules require process-creation telemetry that preserves the parent image and parent command line.

## Alert triggers

- Windows `nlserver.exe web` starts a shell, script interpreter, selected proxy-execution or delayed-execution binary, or an executable from a temporary directory.
- Linux `nlserver web` starts a shell, script interpreter, selected delayed-execution utility, or an executable from a temporary directory.
- A known transfer utility has a download or URL marker, or any child command contains an encoded-command marker.

## L1 triage

1. Confirm that `ParentImage` resolves to the installed Adobe Campaign `nlserver` binary and is not a renamed unrelated executable.
2. Confirm that `ParentCommandLine` identifies the `web` module rather than `wfserver`, `mta`, or another Campaign module.
3. Review the complete child `Image` and `CommandLine`, process identifiers, user, integrity level, current directory, hashes, signer, and start time.
4. Check the installed Campaign version and build. Systems at 7.4.4 build 9401 or earlier require the APSB26-142 update; build status is context, not proof of exploitation.
5. Search `web.log`, `watchdog.log`, reverse-proxy, WAF, and load-balancer telemetry for requests to the same server during the five minutes before process creation.
6. Determine whether a documented maintenance action or approved custom extension intentionally launched the exact child command.

## Evidence collection

- Export the process tree with parent and child process identifiers.
- Preserve the complete command lines and environment information where available.
- Acquire the child binary hash, signer, path, file timestamps, and a copy under the incident-response evidence policy.
- Export Adobe Campaign `web.log` and `watchdog.log` covering at least 15 minutes before and after the alert.
- Export reverse-proxy, WAF, firewall, DNS, and EDR network events for the affected host.
- Record the Campaign build, operating system, exposed interfaces, service account, and asset owner.
- Preserve memory or a process dump only under approved forensic procedures.

## Containment

- For an unexplained shell, encoded command, external download, or outbound callback, isolate the host through the approved EDR or network process.
- Restrict access to the Campaign application interface at the reverse proxy or firewall while preserving evidence.
- Disable or rotate credentials only when the incident commander confirms the affected identities and business impact.
- Do not stop Campaign services before volatile evidence is collected unless ongoing execution creates an immediate risk.

## Eradication

- Upgrade affected Adobe Campaign Classic v7 systems to build 9402 or a later supported build.
- Remove unauthorized files, scheduled tasks, services, accounts, SSH keys, web content, and configuration changes identified during investigation.
- Restore modified Campaign components from trusted media where integrity cannot be established.
- Review custom extensions and workflows that can execute operating-system commands.

## Recovery

- Validate the installed build and component integrity.
- Re-enable access gradually and monitor `nlserver web` descendants, outbound connections, authentication, and Campaign logs.
- Confirm normal campaign execution with the application owner.
- Maintain enhanced monitoring for at least one complete business campaign cycle or the period required by the incident policy.

## Escalation criteria

Escalate immediately when any of the following is present:

- encoded or obfuscated command execution;
- download from or connection to an unapproved external destination;
- an unsigned or newly created executable;
- persistence, credential access, discovery, or lateral-movement behavior;
- a vulnerable Campaign build exposed to an untrusted network;
- no approved maintenance record explaining the exact command.

Close as an authorized activity only when the asset owner provides a valid change record and the full command, binary, destination, timing, and user match the approved action.

## Communication notes

- Describe the finding as suspicious server-side child-process execution from Adobe Campaign.
- Do not state that CVE-2026-75703 or another APSB26-142 issue was exploited without request-level or forensic evidence.
- Notify the Campaign service owner, infrastructure owner, incident-response lead, and data-protection function when customer data exposure is plausible.

## MITRE ATT&CK mapping

| Technique | Relevance |
| :--- | :--- |
| T1059, Command and Scripting Interpreter | Direct shell or interpreter execution is detected. |
| T1053, Scheduled Task/Job | Selected delayed-execution utilities are detected as direct descendants. |
| T1218, System Binary Proxy Execution | The Windows rule covers selected proxy-execution binaries. |
| T1105, Ingress Tool Transfer | The rules cover selected transfer utilities when their command contains a transfer marker. |
