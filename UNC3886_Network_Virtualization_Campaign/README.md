![Status](https://img.shields.io/badge/status-experimental-orange?style=flat-square)
![Campaign](https://img.shields.io/badge/Campaign-UNC3886-red?style=flat-square)
![MITRE](https://img.shields.io/badge/MITRE-T1190%20%7C%20T1059%20%7C%20T1070.004%20%7C%20T1562.001-red?style=flat-square)
![Rules](https://img.shields.io/badge/rules-2%20(BROAD%20%2B%20STRICT)-blue?style=flat-square)
![Level](https://img.shields.io/badge/level-medium%20%2F%20high-yellow?style=flat-square)
![Author](https://img.shields.io/badge/author-ASSIONGBON%20Adama-purple?style=flat-square)

# 🛡️ Sigma Rules : UNC3886 | Network & Virtualization Campaign

👉🏾 [French version available here](README_FR.md)

## Quick reference

- Threat: UNC3886-style espionage activity against network security appliances and virtualization infrastructure
- Detection focus: BROAD for external management probing, STRICT for log tampering and suspicious shelling on appliance hosts
- SOC assets: `playbook/`, `decision-table/`, `diagrams/`, `labs/`
- Rule files:
  - [`unc3886_management_probe_broad.yml`](./rules/unc3886_management_probe_broad.yml)
  - [`unc3886_appliance_log_tamper_strict.yml`](./rules/unc3886_appliance_log_tamper_strict.yml)

## Detection summary

UNC3886 has been publicly associated with long-running intrusions against critical infrastructure, including virtualized environments, routers and telecom sectors. This pack turns that campaign profile into two SOC-friendly rules: one for exposure and one for post-exploitation behavior.

## Why two rules

| Rule | Goal | Typical signal |
| --- | --- | --- |
| BROAD | Early warning | External probing of admin surfaces with automation-like clients |
| STRICT | High confidence | Appliance-side shelling, log tampering or persistence behavior |

## Logs to prefer

- Reverse proxy, WAF or firewall HTTP logs with URL, method, source IP and user agent
- Linux process creation or audit logs from routers, hypervisors or appliance hosts
- Syslog or EDR telemetry that exposes `ParentImage`, `Image`, `CommandLine` and service context

> Note: field names vary by SIEM and parser. Map `Url`, `HttpMethod`, `UserAgent`, `SourceIp`, `ParentImage`, `Image` and `CommandLine` before production rollout.

## References

- https://www.cve.org/CVERecord?id=CVE-2023-20867
- https://www.cve.org/CVERecord?id=CVE-2023-34048
- https://www.techradar.com/pro/security/singapore-says-its-four-largest-phone-companies-were-hit-by-chinese-hackers
- https://www.techradar.com/pro/security/cisa-warns-hackers-are-actively-exploiting-critical-citrixbleed-2

---

*Detection rules authored for defensive security research purposes. Use responsibly within your authorized security perimeter.*
