<!-- Badges (edit the links if you rename the repo/branch) -->
![Sigma](https://img.shields.io/badge/Sigma-rules-blue)
![SOC](https://img.shields.io/badge/SOC-ready-success)
![SOAR](https://img.shields.io/badge/SOAR-playbooks-important)
![MITRE](https://img.shields.io/badge/MITRE-ATT%26CK-lightgrey)
![License](https://img.shields.io/badge/License-MIT-informational)


# SOC Detection to Response - Operational Flow Diagram

 [👉🏾  **French version favailable here**](README_FR.md)
 
### 📌 Description

This diagram illustrates the **end-to-end SOC detection and response lifecycle**, from threat and CVE context to post-incident feedback and continuous improvement.

It represents a **real-world Blue Team / SOC workflow**, integrating:
- SIEM
- Sigma rules (Hunting & Production)
- SOC L1/L2 triage
- SOAR and incident management
- Continuous tuning and hardening

The flow is intentionally **tool-agnostic**, suitable for Wazuh, Splunk, Elastic, OpenSearch, Sentinel, and similar platforms.

---

### 🧠 Diagram Walkthrough

1. **Threat / CVE Context**  
   External sources: advisories, exposure data, CTI feeds, vendor bulletins.

2. **Telemetry**  
   Event and log collection from:
   - Endpoints
   - Servers
   - Network
   - Cloud

3. **SIEM Ingestion & Normalization**
   - Parsing  
   - Enrichment  
   - Correlation  

4. **Sigma Rules**
   - **BROAD / BROADPLUS**: hunting and wide detection
   - **STRICT**: low-noise production detection

5. **Alert Generated**
   Alerts include:
   - Severity
   - Context
   - Technical evidence

6. **SOC Triage L1 / L2**
   - Validation
   - Scoping
   - Impact assessment

7. **Decision**
   - **False Positive** → Close & tune (noise reduction)
   - **True Positive** → Incident management

8. **Incident Management**
   - TheHive
   - Ticketing systems

9. **SOAR Playbook**
   Automated or semi-automated actions:
   - Enrichment
   - Containment
   - Notification

10. **Response Actions**
    - Block IoCs
    - Isolate host
    - Reset credentials
    - Patch vulnerability

11. **Post-Incident**
    - Lessons learned
    - Rule updates
    - Security hardening

👉🏾 The feedback loop highlights **continuous SOC improvement**.

---

### 🎯 Diagram Purpose

- SOC / Blue Team training
- SOC architecture documentation
- Client and management presentations
- SOAR playbook design
- SOC workflow standardization

---

🛡️ **Maintained as part of the `sigma-rules` project**
![SOC Framework](sigma_rules_global_soc_workflow_3D_EN.png)
