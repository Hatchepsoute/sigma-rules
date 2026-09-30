# Adobe Campaign Classic server-side execution detection

[Version française](./README_FR.md)

## At a glance

| Item | Value |
| :--- | :--- |
| Product | Adobe Campaign Classic v7, on-premise and on-premise components of hybrid deployments |
| Security context | APSB26-142 includes multiple critical code-execution issues; CVE-2026-75703 is listed by Adobe as application denial-of-service |
| Fix | Upgrade affected Campaign Classic v7 systems to 7.4.4 build 9402 or later |
| Windows rule | [`rules/windows_adobe_campaign_web_suspicious_child_process_strict.yml`](./rules/windows_adobe_campaign_web_suspicious_child_process_strict.yml), Windows process creation |
| Linux rule | [`rules/linux_adobe_campaign_web_suspicious_child_process_strict.yml`](./rules/linux_adobe_campaign_web_suspicious_child_process_strict.yml), Linux process creation |

## The threat

Adobe Campaign Classic is an enterprise marketing platform whose `nlserver web` module serves application, console, report, and SOAP API traffic. Adobe bulletin APSB26-142 fixes several critical vulnerabilities in Campaign Classic v7 build 9401 and earlier, including code injection, command injection, authorization, SQL injection, and server-side request forgery issues. Adobe states that hosted instances were remediated, while on-premise and on-premise hybrid components must be upgraded to build 9402. Public information does not expose reliable request patterns for CVE-2026-75703, so this pack detects server-side process execution rather than claiming exploit-specific attribution.

## The attack and what the rules detect

1. An attacker or unauthorized operator reaches the Campaign application server. No rule in this pack triggers because Adobe has not published a stable malicious endpoint or payload pattern.
2. If the Windows `nlserver.exe web` process starts a shell, script interpreter, selected proxy-execution or delayed-execution binary, or an executable from a temporary directory, [`rules/windows_adobe_campaign_web_suspicious_child_process_strict.yml`](./rules/windows_adobe_campaign_web_suspicious_child_process_strict.yml) triggers. Transfer utilities require a download or URL marker, which avoids alerting on an unrelated child process that merely contains an URL.
3. If the Linux `nlserver web` process starts a shell, script interpreter, selected delayed-execution utility, or an executable from a temporary directory, [`rules/linux_adobe_campaign_web_suspicious_child_process_strict.yml`](./rules/linux_adobe_campaign_web_suspicious_child_process_strict.yml) triggers. Transfer utilities likewise require a download or URL marker.
4. In-process code execution, a crash without child-process creation, a renamed child outside temporary paths with an innocuous command line, or missing parent telemetry remains outside this pack's visibility.

| Criterion | No existing rule | Proposed Windows STRICT rule | Proposed Linux STRICT rule |
| :--- | :--- | :--- | :--- |
| **Detects the modeled child-process behavior?** | ❌ No | ✅ Yes | ✅ Yes |
| **Estimated FP rate** | Not applicable | Low after environment-specific allowlisting | Low after environment-specific allowlisting |
| **Key logic** | No coverage | `ParentImage=nlserver.exe` + web module + execution child, delayed execution, or temporary-path child | `ParentImage=/nlserver` + web module + execution child, delayed execution, or temporary-path child |

## Required telemetry

| Rule | Log source | Minimum fields |
| :--- | :--- | :--- |
| [`rules/windows_adobe_campaign_web_suspicious_child_process_strict.yml`](./rules/windows_adobe_campaign_web_suspicious_child_process_strict.yml) | Sysmon Event ID 1 or equivalent Windows EDR process creation | `Computer`, `User`, `Image`, `CommandLine`, `ParentImage`, `ParentCommandLine`, process identifiers |
| [`rules/linux_adobe_campaign_web_suspicious_child_process_strict.yml`](./rules/linux_adobe_campaign_web_suspicious_child_process_strict.yml) | auditd, eBPF, Sysmon for Linux, or equivalent EDR process creation | `Computer`, `User`, `Image`, `CommandLine`, `ParentImage`, `ParentCommandLine`, process identifiers |

## References

- https://helpx.adobe.com/security/products/campaign/apsb26-142.html
- https://experienceleague.adobe.com/en/docs/campaign-classic/using/monitoring-campaign-classic/updating-adobe-campaign/introduction
- https://experienceleague.adobe.com/en/docs/campaign-classic/using/monitoring-campaign-classic/production-procedures/log-files
- https://experienceleague.adobe.com/en/docs/campaign-classic/using/installing-campaign-classic/install-campaign-on-prem/installing-campaign-in-windows/installing-the-server
- https://attack.mitre.org/techniques/T1059/
- https://attack.mitre.org/techniques/T1105/
- https://attack.mitre.org/techniques/T1218/
