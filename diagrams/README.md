<!-- Badges -->
![Sigma](https://img.shields.io/badge/Sigma-rules-blue)
![SOC](https://img.shields.io/badge/SOC-ready-success)
![SOAR](https://img.shields.io/badge/SOAR-playbooks-important)
![MITRE](https://img.shields.io/badge/MITRE-ATT%26CK-lightgrey)
![License](https://img.shields.io/badge/License-MIT-informational)

# Sigma-Rules – Detection Engineering Philosophy

👉🏾 [**French version available here**](README_FR.md)

**Threat → Detect → Respond → Improve**

This diagram represents the operational philosophy behind the **sigma-rules** project.

Unlike a simple collection of Sigma rules, this repository follows a structured Detection Engineering framework designed for real-world SOC environments.

---

## Core Philosophy

The project is built on five principles:

1. **Threat-Driven Engineering**  
   CVEs, real-world campaigns, exploit trends, and CTI analysis are the starting point.

2. **Layered Detection Strategy**  
   - **BROAD** rules for visibility and hunting  
   - **STRIC**T rules for high-confidence production alerts  

3. **Operational Readiness**  
   Decision tables, triage guidance, and response playbooks are included.

4. **Automation Integration**  
   Designed to work with SIEM and SOAR platforms (TheHive, Elastic, OpenSearch, Splunk, Sentinel).

5. **Continuous Improvement**  
   Feedback loop for tuning, false positive reduction, and detection maturity growth.

---

## Executive Framework Diagram

```mermaid
flowchart LR

A["THREAT<br/>CVE - Ransomware - Exploits - TTPs<br/>Real World Attack Surface"]

B["DETECT<br/>Sigma Rules BROAD and STRICT<br/>Behavioral Detection and Correlation<br/>SIEM Integration"]

C["RESPOND<br/>Decision Tables - Playbooks - TheHive<br/>Containment - Investigation - Remediation"]

D["IMPROVE<br/>Tuning - Hardening - Versioning<br/>Detection Maturity Increase"]

A --> B
B --> C
C --> D
D --> B

classDef threat fill:#0b1220,stroke:#334155,color:#e2e8f0;
classDef detect fill:#0b2a1a,stroke:#10b981,color:#ecfdf5;
classDef respond fill:#2a0b0b,stroke:#ef4444,color:#fff1f2;
classDef improve fill:#1f2937,stroke:#a3e635,color:#ecfccb;

class A threat;
class B detect;
class C respond;
class D improve;
```

---

## Operational Value

- Reduced MTTD  
- Reduced MTTR  
- Standardized SOC workflows  
- Measurable detection maturity  
- Repeatable detection engineering model  

---

Maintained as part of the **sigma-rules Detection Engineering Project**
---
## ✍🏿 Author
[Adama ASSIONGBON – SOC & CTI Consultant](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

