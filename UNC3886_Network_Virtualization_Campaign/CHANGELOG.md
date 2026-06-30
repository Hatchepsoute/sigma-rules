# Changelog

## 2026-06-25 (v1.1.0 - challenge session)

### Changed
- BROAD rule: removed `Mozilla` from `filter_legit_admin_clients` (critical bypass - attacker using `curl -A "Mozilla/5.0 curl/7.68.0"` was filtered); removed redundant `selection_method`; added `selection_appliance_uri` covering VMware (`/vsphere-client/`, `/vsphere/`, `/vmrc/`, `/ui/login`), Ivanti Pulse Secure (`/dana-na/`, `/dana/`), FortiGate (`/remote/login`, `/remote/fgt_lang`), Cisco AnyConnect (`/+CSCOE+/`, `/webvpn/`), Juniper (`/junos/`, `/restconf/`, `/rpc/api/`); these URIs trigger without UA requirement; added `nuclei`, `masscan`, `BurpSuite`, `ZAP`, `naabu`, `libwww-perl`, `Java/`, `Scrapy` to `selection_automation_ua`; added `attack.t1595.002` and `attack.reconnaissance`; added `related` link to STRICT rule.
- STRICT rule: added VMware ESXi/vCenter parents: `/hostd`, `/vpxa`, `/vmware-hostd`, `/rhttpproxy`, `/sfcbd`, `/jsvc`, `/vmsyslogd`; added Juniper daemons `/mgd`, `/dcd`; added FortiGate `/sslvpnd`; split `selection_child` into `selection_high_risk_child` (python3, python2, perl, nc, ncat, socat - no CLI required) and `selection_shell_or_download_child` (bash, sh, wget, curl - require CLI indicator); added log-clearing patterns: `truncate -s`, `shred -`, `dd if=/dev/null`, `systemctl disable rsyslog`, `| base64 -d`, `| bash`, `bash -c "$(echo`; added `attack.t1059.004` and `attack.t1543.002`; added `related` link to BROAD rule.

### Fixed
- BROAD: Mozilla in the filter allowed `curl -A "Mozilla/5.0 curl/7.68.0"` to bypass detection entirely (AM1).
- BROAD: VMware vSphere, Juniper, FortiGate, Ivanti Pulse Secure, Cisco AnyConnect appliance-specific URIs were absent - reconnaissance with a browser UA was invisible (AM2).
- STRICT: VMware ESXi daemons `hostd`, `vpxa` were not in `selection_parent` - post-exploitation from CVE-2023-34048 was invisible (AM3).
- STRICT: `python3` was absent from `selection_child` - VirtualPie (UNC3886 Python backdoor) was undetectable (AM4).
- STRICT: `truncate -s0` and `shred -u` were not in `selection_cli` - in-place log wiping was undetectable (AM5).

### Added
- Labs fully updated: `README_ANGLES_MORTS.md` (5 blind spots), `logs_simules.json` (14 events), `poc_evasion.py` (5 evasion functions), `poc_evasion.ps1` (BROAD + STRICT simulation), `poc_evasion.md` (full 10-section SOC guide), `scenario.md` (5-step UNC3886 attack chain).

### Known residual blind spots
- memfd-based python3 payload without /tmp/ in CommandLine: requires auditd syscall enrichment.
- Log deletion via /proc/PID/fd/ descriptor manipulation: not detectable via process_creation.
- ESXi process_creation visibility for hostd/vpxa: requires a dedicated monitoring module.

## 2026-06-25 (v1.0.0 - initial release)

- Added the UNC3886 network and virtualization campaign detection pack.
- Added BROAD and STRICT Sigma rules.
- Added SOC playbook, decision table, diagrams and a local validation lab.
