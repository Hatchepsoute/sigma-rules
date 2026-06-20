# CHANGELOG, Thegentlemen ransomware EDR Killer detection pack

## [1.0.0], 2026-06-19

### Added
- `windows_gentlemen_edr_security_process_termination_broad.yml`, BROAD rule detecting forced
  termination of 30+ security product processes via taskkill/sc/net across 48 vendors
- `windows_gentlemen_edr_killer_impersonation_strict.yml`, STRICT rule detecting GentleKiller
  impersonation of security/gaming product names from user-writable paths, plus explicit
  EDR killer tool names (GentleKiller, HexKiller, ThrottleBlood, HavocKiller, OxideHarvest)
- `windows_gentlemen_byovd_invalid_signature_driver_strict.yml`, STRICT rule detecting BYOVD
  kernel driver loads with stolen/revoked/expired signatures from non-system paths
- `README.md` and `README_FR.md`, bilingual documentation
- `CHANGELOG.md`

### Intelligence source
- BleepingComputer article on Gentlemen ransomware EDR killer operation (June 2026)
