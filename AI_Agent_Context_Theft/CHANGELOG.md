# Changelog - AI Agent Context Theft

All notable changes to this project are documented in this file.

The format follows **Keep a Changelog** principles.

---

## [1.0.0] - 2026-02-17

### Added
- Initial release of the AI Agent Context Theft Sigma detection pack
- BROAD rule for AI agent configuration and memory access
- STRICT rule for authentication token exfiltration
- CRITICAL rule for cryptographic identity compromise
- CRITICAL multi-file access rule indicating full agent takeover

### Fixed
- Corrected Sigma condition naming issues
- Removed unsupported correlation syntax
- Ensured full sigma-cli compatibility

### Security
- Detection aligned with real-world infostealer activity targeting OpenClaw
- Behavioral detection without static IoCs

---

## Planned
- Linux and macOS variants
- Elastic / OpenSearch native translations
- SOC playbooks (TheHive)
- Mermaid attack flow diagrams

