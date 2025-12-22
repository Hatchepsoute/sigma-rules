# Release v0.2.0 – Patch Tuesday Detection Pack Update (2025-12-22)

## Highlights
- ✅ Added full SOC pack for **CVE-2025-54100 (Windows Userland RCE)**:
  - BROAD + STRICT Sigma rules
  - SOC analyst L1/L2 decision tables (EN/FR) + PDF
  - Attack flow diagrams (SVG + 3D PNG)
  - SOAR-ready TheHive playbook YAML

## Recommended Deployment
- Enable **STRICT** rule for alerting/actioning
- Keep **BROAD** rule for hunting and context enrichment
- Use decision table for standardized SOC analyst L1/L2 triage
- Automate containment via TheHive YAML (adapt integrations)

## Contents
- `CVE-2025-54100_WindowsUserland/` (new)

See `CHANGELOG.md` for full details.
