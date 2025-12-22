# Changelog

All notable changes to this repository will be documented in this file.

The format is based on *Keep a Changelog*, and this project follows semantic-ish versioning for content releases:
- **v0.X.0** = new pack / major content addition
- **v0.X.Y** = fixes / tuning / documentation updates

---

## [v0.2.0] – 2025-12-22

### Added
- New detection pack: **CVE-2025-54100 – Windows Userland RCE**
  - Sigma rule (BROAD): `windows_userland_rce_lolbin_execution_broad.yml`
  - Sigma rule (STRICT): `windows_powershell_iwr_child_process_execution_strict.yml`
  - Decision tables SOC analyst L1/L2 (EN/FR): Markdown + 1‑page PDF
  - Attack flow diagrams (EN/FR): SVG + 3D PNG
  - SOAR-ready playbook (TheHive): `TheHive_Playbook_CVE-2025-54100.yaml`
  - Playbook documentation (EN/FR)

### Changed
- Standardized pack layout across CVEs (rules / diagrams / playbook / decision-table when relevant).
- Documentation convention: **English as default** (`README.md`) with **French companion** (`README_FR.md`).

### Fixed
- N/A (content release)

### Notes (SOC)
- This release provides **end-to-end coverage** for CVE‑2025‑54100 from detection (Sigma) to triage (decision table) and response (TheHive playbook).
- Recommended operational approach: enable **STRICT** for actioning and keep **BROAD** for hunting/tuning.
