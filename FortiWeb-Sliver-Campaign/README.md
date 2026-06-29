![Sigma](https://img.shields.io/badge/Format-SIGMA-orange)
![Validation](https://img.shields.io/badge/Sigma_Check-Passed-green)
![Incident Response](https://img.shields.io/badge/IR-TheHive_Playbook-red)
![Fortinet](https://img.shields.io/badge/Fortinet-FortiWeb-red)

# 🛡️ FortiWeb Sliver C2 Campaign Detection

👉🏾 [French version available here](README_FR.md)

## 📝 Overview
This repository provides a comprehensive detection suite (Sigma Rules, IoCs, and Playbooks) to mitigate sophisticated attack campaigns targeting **FortiWeb appliances**. It standardizes the detection of the **Sliver C2 framework** and network masquerading techniques.

## 🚀 Key features
- 🔍 **Full Lifecycle Detection**: From initial payload drop to active C2 tunneling.
- 🛡️ **Anti-Evasion**: Behavioral logic designed to unmask tools like `microsocks` or `frp`.
- ⚖️ **Operational Readiness**: Integrated **TheHive Playbooks** and decision matrices for SOC analysts.
- ⚙️ **Quality Assured**: All rules have passed strict `sigma-cli` validation.

## 🔍 Technical analysis (ruleset)
1.  **Implant Deployment** ([lnx_sliver_implant_deployment.yml](./rules/lnx_sliver_implant_deployment.yml)): Targets hidden binary drops in `/.root/`.
2.  **Systemd Persistence** ([persist_lnx_sliver_systemd_service.yml](./rules/persist_lnx_sliver_systemd_service.yml)): Detects malicious service configurations.
3.  **Proxy Masquerading** ([proc_lnx_microsocks_lpd_masquerade.yml](./rules/proc_lnx_microsocks_lpd_masquerade.yml)): Spots disguised proxies via command-line flags.
4.  **FRP Tunneling** ([lnx_frp_reverse_proxy_activity.yml](./rules/lnx_frp_reverse_proxy_activity.yml)): Monitors reverse proxy client activity.
5.  **Network Listener** ([lnx_lpd_listener_printer_service_masquerade.yml](./rules/lnx_lpd_listener_printer_service_masquerade.yml)): Detects unauthorized listeners on **TCP port 515**.

## 🔗 Rule chaining and correlation
The pack is structured as a detection chain rather than a single BROAD/STRICT pair. Each rule covers one observable stage of the campaign and the `related` metadata links companion rules together. SOC analysts should treat an implant drop or masquerading alert as context, then use the persistence, FRP, and listener rules to confirm the campaign.

## 🛡️ Future-Proofing & Resilience
These rules focus on **Behavioral Indicators** (CLI arguments, network ports, and restricted paths) to ensure detection even if attackers rename their binaries or modify their "V2" payloads.

## ⚖️ Incident response & decision making
* **Decision Table**: Step-by-step triage guide located in `/decision-table/`.
* **TheHive Playbook**: Automated workflow mapping in `TheHive_Playbook_Sliver_FortiWeb.yml`.
## 🛠️ How to Use

### 1. Automated Validation & Conversion ⚙️
* **Option A: Local Automation (Recommended)**
    * Run `./scripts/validate_all_rules.sh` for syntax and quality checks.
    * Run `./scripts/convert_all_rules.sh` to generate queries for Splunk, Sentinel, Elastic, etc.
* **Option B: Online Validation (Quick Test)**
    * You can manually verify rules via [**Uncoder.io**](https://uncoder.io/).

### 2. Integrating IoCs
* Import `artifacts/iocs.csv` into your SIEM Watchlists for automated correlation.

## 📁 Repository structure
```text
├── rules/ # 5 Sigma Rules
│   ├── lnx_sliver_implant_deployment.yml
│   ├── lnx_sliver_persistence_systemd.yml
│   ├── lnx_microsocks_masqueraded_lpd.yml
│   ├── lnx_lpd_listener_printer_service_masquerade.yml 
│   └── lnx_frp_reverse_proxy_activity.yml
├── artifacts/  # IoC lists (TXT/CSV)
│   ├── iocs.txt
│   └── iocs.csv
├── decision-table/ # Playbooks IR, Mapping TheHive et Matrice de décision
│    ├── Decision_Table_Sliver_SOC.xlsx
│    ├── TheHive_Decision_Mapping.yml
│    ├── TheHive_Playbook_Sliver_FortiWeb.yml
│    └── Sliver_KillChain_Detection.png
├── README_FR.md
└── README.md
```
## ✍🏿 Author
[Adama ASSIONGBON – SOC & CTI Consultant](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

## Rule relationships
When a pack contains more than one detection, use `related` metadata to link companion rules.
Treat the broader alert as the hunt signal and the stricter alert as the confirmation signal when both exist.
Correlate on the same host, user, or short time window.

