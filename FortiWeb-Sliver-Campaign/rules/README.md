![Threat Intelligence](https://img.shields.io/badge/Focus-CTI%20%26%20SOC-blue)
![Sigma](https://img.shields.io/badge/Format-SIGMA-orange)
![License](https://img.shields.io/badge/License-MIT-green)
![Fortinet](https://img.shields.io/badge/Fortinet-FortiOS-red)

# 📂 Sigma Detection Rules Index
[👉🏾 French version available here: ](./README_FR.md)

This directory contains the core detection logic for the **FortiWeb Sliver C2 Campaign**. Rules are provided in **Sigma** format for SIEM-agnostic deployment.

## 📋 Rules Summary

| File Name | Detection Focus | Severity |
| :--- | :--- | :--- |
| `lnx_sliver_implant_deployment.yml` | Initial binary drop in hidden paths (`/.root/`, `/app/web/`). | Critical |
| `PERSIST_LNX_Sliver_Systemd_Service.yml` | Persistence via "Updater Service" systemd creation. | High |
| `PROC_LNX_Microsocks_LPD_Masquerade.yml` | Process masquerading (Microsocks running as `cups-lpd`). | High |
| `lnx_frp_reverse_proxy_activity.yml` | FRP client execution for remote access tunneling. | Medium |
| `lnx_lpd_listener_printer_service_masquerade.yml` | Unauthorized network listeners on TCP port 515. | High |

## 🔍 Technical Deep Dive

### 1. Implant & Persistence
* **Target:** Sliver framework delivery and survival.
* **Strategy:** Monitors file system events. We focus on structural anomalies (execution from hidden system directories) and metadata consistency (Systemd service descriptions).

### 2. Masquerading & C2 Tunneling
* **Process Level:** Detecting unique flags (`-p 515`, `-1`, `-w`) specific to `microsocks` behavior, ensuring detection even if the tool is renamed to a legitimate service name.
* **Network Level:** Monitoring the LPD port (515) for non-printing traffic. This is a high-fidelity indicator of a compromised edge appliance.

## 🛠️ Validation & Usage
All rules in this folder have passed syntax and quality checks via `sigma-cli`.

**To deploy these rules:**
* **Automated:** Use the root script `./scripts/convert_all_rules.sh` to generate queries for Splunk, Sentinel, or Elastic.
* **Manual/Web:** Copy-paste YAML content into [Uncoder.io](https://uncoder.io) or [Sigma Live Configurator](https://sigmaconfig.io).

## 🛡️ Anti-Evasion (V2 Payloads)
These rules focus on **Behavioral Indicators** (CLI arguments, network ports, and restricted system paths) to ensure detection even if attackers rename their binaries or modify their campaign infrastructure in the future.

## ✍🏿 Author
[Adama ASSIONGBON – Consultant SOC & CTI](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

