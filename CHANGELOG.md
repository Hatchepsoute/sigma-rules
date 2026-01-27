# CHANGELOG

This file documents **framework-level changes** to the `sigma-rules` repository. It focuses on detection philosophy, repository structure, CI/CD, and the addition of new detection families.

Detailed changes for individual detection packs are documented in each pack’s own `CHANGELOG.md`.

Versioning follows **Semantic Versioning (MAJOR.MINOR.PATCH)**.

## v1.0.3 – 2026-01-27
- Initial release
- STRICT rule for CVE-2026-24061 exploitation
- BROAD hunting rule for Telnet post-exploitation
- SOC decision table (EN/FR)
- Generic IR playbooks (EN/FR)
---
## [v1.0.2] – 2026-01-25
### Added
- **New Detection Pack**: `CVE-2025-59718_Fortigate_bypass`
  - Multi-layer detection for Fortinet FortiCloud SAML SSO bypass vulnerability (CVE-2025-59718)
  - Includes the following structured artefacts:
    - `rules/`: 3 Sigma rules (BROAD & STRICT variants + admin/config event fusion)
    - `correlation/`: 5-minute correlation logic (EN/FR)
    - `decision-table/`: L1/L2 analyst decision tables (EN/FR)
    - `diagrams/`: visual flow from attack to detection
    - `playbook/`: SOAR + TheHive playbooks (EN/FR)
    - `README.md` / `README_FR.md`: analyst-facing documentation

> Detection logic covers: web-level exploit attempt, admin role injection via SAMLResponse, and post-auth configuration export.

---
## [v1.0.1] – 2026-01-11
- Added CVE-2025-37164 HPE OneView detection pack (see pack-level documentation)


## [v1.0.0] – 2026-01-09
### Added
- Minimum Viable Detection Rules (MVDR) detection philosophy
- Kernel_Rootkit_MVDR detection pack (with dedicated pack-level CHANGELOG)
- BROAD / STRICT detection engineering model
- SOC-oriented documentation (technical & management, EN/FR)
- Incident Response playbooks aligned with detection packs
- Red Team / Purple Team validation scenarios

### Changed
- Repository structure aligned with SOC detection engineering best practices
- Detection documentation standardized across packs
- Clear separation between framework-level and pack-level artefacts

---

## [v0.3.0] – 2025-12-24
### Added
- Campaign-based detection packs derived from real-world intrusions
- CVE-focused detection packs with full SOC artefacts
- Network-level invariant detections for WAF, VPN, and firewall logs
- SOC decision tables (L1 / L2)

### Changed
- Main README upgraded to framework-level documentation
- Harmonized bilingual documentation (EN / FR)

---

## [v0.2.0] – 2025-11-15
### Added
- Initial Sigma detection rules and CVE-based packs
- Multi-backend Sigma validation and conversion scripts
- First SOAR playbooks (TheHive / Cortex)

---

## [v0.1.0] – 2025-11-12
### Added
- Initial repository structure
- First experimental Sigma rules
