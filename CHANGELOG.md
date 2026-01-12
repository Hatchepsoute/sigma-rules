# CHANGELOG

This file documents **framework-level changes** to the `sigma-rules` repository. It focuses on detection philosophy, repository structure, CI/CD, and the addition of new detection families.

Detailed changes for individual detection packs are documented in each pack’s own `CHANGELOG.md`.

Versioning follows **Semantic Versioning (MAJOR.MINOR.PATCH)**.

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
