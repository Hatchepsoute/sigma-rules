# Sigma detection framework for SOC operations

[Version française](README_FR.md)

Badges and production-oriented Sigma rules for SOC analysts, detection engineers, blue teams and MSSPs.

## Purpose

This repository provides behavior-based detections for CVE exploitation, attack campaigns and post-exploitation activity. Each pack is documented with rules, triage guidance and response material.

## Detection policy

- **STRICT first**: create the smallest high-confidence rule that detects the most specific observable signal.
- **BROAD only when justified**: add it only for a distinct attack phase or log source with actionable, tunable false positives.
- **Support and correlation**: use contextual rules and telemetry to confirm an incident.

A pack does not need both BROAD and STRICT rules. One accurate STRICT rule is preferred to a noisy BROAD rule.

## Featured critical detections

| Vulnerability | Product | Coverage | Pack | Status |
| :--- | :--- | :--- | :--- | :--- |
| CVE-2026-109618 and CVE-2026-109619 | PHP | Multipart upload, OOM behavior, serialized POST probes, PHP worker execution and webshell creation | [PHP2Shell detection pack](./CVE-2026-109618_109619_PHP2Shell/) | Experimental |

PHP2Shell affects internet-facing PHP deployments and has public proof-of-concept research. Prioritize patching to a fixed vendor release, then enable the pack for hunting and post-exploitation detection. Network alerts require correlation with PHP, process and file telemetry.

The pack was reviewed on 2026-10-22 against public research, including the [CERT-EU advisory](https://cert.europa.eu/publications/security-advisories/2026-018/).

## Repository structure

Each pack may contain:

- `rules/` Sigma detections
- `labs/` private validation material
- `playbook/` SOC response guides
- `decision-table/` triage decisions
- `diagrams/` attack-to-response flows
- bilingual README and changelog

## Quick start

```bash
pipx install sigma-cli
sigma plugin list
bash scripts/validate_all_rules.sh
```

Convert a rule after checking installed targets:

```bash
sigma check path/to/rules
sigma convert -t <backend> path/to/rule.yml
```

See [INSTALLATION.md](INSTALLATION.md), [scripts/README.md](scripts/README.md) and [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License and author

Apache License 2.0. Contributions and feedback are welcome.

Adama ASSIONGBON, SOC & CTI Consultant: [LinkedIn](https://www.linkedin.com/in/adama-assiongbon-9029893a/)
