![Sigma](https://img.shields.io/badge/Format-SIGMA-orange)
![Validation](https://img.shields.io/badge/Sigma_Check-Passed-green)
![Incident Response](https://img.shields.io/badge/IR-TheHive_Playbook-red)
![Infostealer](https://img.shields.io/badge/Infostealer-red)

# 🛡️ Infostealers_FULL_SOC --- Detection Pack

👉🏾 [**French version available here**](README_FR.md)

## 🎯 Overview

This repository contains **four high-confidence detection rules** designed to identify Windows-based infostealer activity using behavioral correlation.

The pack is structured in two complementary detection models:

------------------------------------------------------------------------

# 📂 1️⃣ Infostealer_STRICT (Single High-Confidence Rule)

This folder contains a **single consolidated detection rule**:

[`infostealer_STRICT_credential_access_and_exfiltration.yml`](./Infostealer_STRICT/rules/infostealer_STRICT_credential_access_and_exfiltration.yml) 

### 🔎 Detection Logic

The rule triggers only when the following 3 behaviors occur together:

1.  Suspicious LOLBIN execution from user-writable path\
2.  Browser credential store access\
3.  Network exfiltration indicators

Logical condition:

    selection_exec AND selection_creds AND selection_net

### 📦 Included Artifacts

-   MITRE ATT&CK Navigator mapping\
-   Decision tables (EN / FR)\
-   Mermaid diagrams\
-   TheHive playbooks (EN / FR)

### 🎯 Usage

Recommended for environments that prefer **single-rule high-confidence detection**.

------------------------------------------------------------------------

# 📂 2️⃣ Infostealer_STRICT_Correlated (Step-Based Model)

This folder contains **three modular rules**:

-   Step 1 --- Suspicious Execution\   [`infostealer_STRICTv2_step1_suspicious_exec.yml`](./Infostealer_STRICT_Correlated/rules/infostealer_STRICTv2_step1_suspicious_exec.yml)
-   Step 2 --- Browser Credential Access\   [`infostealer_STRICTv2_step2_browser_cred_access.yml`](./Infostealer_STRICT_Correlated/rules/infostealer_STRICTv2_step2_browser_cred_access.yml)
-   Step 3 --- Public Network Egress   [`infostealer_STRICTv2_step3_public_egress.yml`](./Infostealer_STRICT_Correlated/rules/infostealer_STRICTv2_step3_public_egress.yml)

These rules are designed to be correlated using:

-   Elastic EQL sequence\
-   OpenSearch pivot logic\
-   SIEM-native correlation engine

### 🧠 Correlation Model

    Step1 → Step2 → Step3 (≤10 minutes)

This model provides:

-   Earlier detection (partial signals)
-   Flexible SOC tuning
-   Advanced correlation capability

### 📦 Included Artifacts

-   Correlation queries (Elastic EQL / OpenSearch)\
-   Decision tables\
-   Kill Chain diagram\
-   TheHive playbooks\
-   Mermaid diagrams

------------------------------------------------------------------------

# 🔴 Severity & Strategy

  Model                  Confidence             Flexibility   SOC Effort
  ---------------------- ---------------------- ------------- ------------
  STRICT (single rule)   Very High              Medium        Low
  STRICT Correlated      Very High (when 3/3)   High          Medium

Both models use **behavioral detection** rather than static IoCs.

------------------------------------------------------------------------

# 📊 Strategic Value

-   Reduces false positives\
-   Detects credential theft campaigns\
-   Aligns with MITRE ATT&CK techniques\
-   Production-ready for SOC environments

------------------------------------------------------------------------
