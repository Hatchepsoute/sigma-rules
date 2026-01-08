
<!-- Badges (edit the links if you rename the repo/branch) -->
![Sigma](https://img.shields.io/badge/Sigma-rules-blue)
![SOC](https://img.shields.io/badge/SOC-ready-success)
![SOAR](https://img.shields.io/badge/SOAR-playbooks-important)
![MITRE](https://img.shields.io/badge/MITRE-ATT%26CK-lightgrey)
![License](https://img.shields.io/badge/License-MIT-informational)
# 🛡️ Sigma Detection Framework for SOC Operations

![SOC Framework](diagrams/sigma_rules_global_soc_workflow_3D_EN.png)

# Sigma Rules - SOC Detection Engineering Framework

This repository provides a **production-oriented SOC Detection Engineering framework**
based on Sigma rules, CTI-driven analysis, and real-world attack campaigns.

## Detection Philosophy

This project does not rely solely on static indicators such as hashes, filenames, or IPs.
Detection logic follows a layered approach:

- **BROAD rules** for visibility and threat hunting
- **STRICT rules** for confirmation and alerting
- **Behavioral detections** resilient to payload renaming
- **Network invariants** for edge appliances without EDR
- **Correlation logic** to confirm incidents

Detection engineering should not break when attackers rename files.

## Campaign-Based Detection Packs

Beyond CVE-centric detections, this repository includes **campaign-oriented detection packs**
based on real-world threat actor activity.

These packs include:
- Full attack lifecycle coverage
- Detection of renamed or evolving payloads (v2/v3)
- Network and behavioral invariants
- SOC-ready decision tables and response playbooks

Examples:
- FortiWeb exploitation with Sliver C2 and proxy masquerading (campaign-based detection pack)
- CVE-focused detection packs designed for SOC anticipation and post-disclosure exploitation monitoring, including:
  - Windows Kernel / Graphics / Userland vulnerabilities (Patch Tuesday)
  - Microsoft Office vulnerabilities
  - WinRAR vulnerabilities
  - Azure Monitor Agent vulnerabilities
  - Microsoft Copilot vulnerabilities

CVE packs are designed to help SOC teams anticipate post-disclosure exploitation
(weaponization) using BROAD and STRICT rules, combined with SOC-ready artifacts
(decision tables, playbooks, diagrams).

## SOC & SOAR Integration

Rules are designed for production SOC environments and can be integrated with:
- SIEM platforms (Elastic, OpenSearch, Splunk, Sentinel, QRadar)
- SOAR platforms such as **TheHive**, Cortex, Shuffle

## Repository Structure

Each detection pack follows a consistent structure:
- Sigma rules
- Decision tables
- Playbooks
- Diagrams

