# Claude Instructions – Sigma Rules Repository

## Objective
Generate high-quality Sigma rules aligned with SOC detection engineering best practices.

---

## Detection Strategy

- Always generate two rules:
  - BROAD (hunting, low confidence, wider detection)
  - STRICT (alerting, high confidence)

- Do NOT include static IoCs (IP, domain, hash) in Sigma rules.
- IoCs must be stored separately in /ioc/*.csv

---

## Log Sources

- Prioritize:
  - Windows Sysmon
  - Windows Security logs
  - Firewall logs (Fortigate)
  - Web logs

- Use only fields that exist in the environment:
  - EventID
  - SourceIp
  - DestinationIp
  - Image
  - User
  - CommandLine

---

## Rule Quality

- Avoid false positives
- Prefer behavioral detection over signatures
- Ensure rules are compatible with SIEM (OpenSearch / Wazuh)

---

## Output Structure

For each CVE or threat:

- /sigma/broad.yml
- /sigma/strict.yml
- /ioc/ioc.csv
- README.md (EN)
- README_FR.md (FR)
- CHANGELOG.md

---

## Naming Convention

- CVE-YYYY-XXXX_<Technique>_<Target>
- Example: CVE-2026-23669_PrintSpooler_RCE

---

## MITRE ATT&CK Mapping

- Always include:
  - Tactic
  - Technique ID
  - Description

---

## Language

- Generate outputs in English and French when requested.

---

## Constraints

- query_string must be on one line (for SIEM compatibility)
- No assumptions about unknown fields
- Always explain detection logic clearly in README

---

## Behavior

- Analyze existing rules before generating new ones
- Reuse patterns and improve them when possible
