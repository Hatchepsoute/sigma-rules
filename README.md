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
