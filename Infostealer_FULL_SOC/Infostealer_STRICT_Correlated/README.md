# Infostealer STRICT v2 (Correlated) – SOC Pack
[👉🏾  **French version available here**](README_FR.md)
🏗️ Detection Architecture (Step-by-Step)

To minimize false positives and increase alert confidence, these rules are divided into three critical stages. Correlating these three events on a single host within a 10-minute window indicates a high-probability compromise.
## 1️⃣ Step 1: Suspicious Execution (LOLBins) 🚀

    File:  [infostealer_STRICTv2_step1_suspicious_exec.yml](./rules/infostealer_STRICTv2_step1_suspicious_exec.yml)

    Logic: Detects the execution of legitimate Windows binaries (PowerShell, CMD, Rundll32, etc.) from user-writable directories like \Downloads\, \AppData\, or \Temp\.

    Indicator: Use of encoded commands (Base64), Invoke-Expression, or direct downloads via CLI.

    Level: High

## 2️⃣ Step 2: Browser Credential Access 🔑

    File:[infostealer_STRICTv2_step2_browser_cred_access.yml](./rules/infostealer_STRICTv2_step2_browser_cred_access.yml)

    Logic: Identifies any non-browser process attempting to read database files containing passwords, cookies, or session data from Chrome, Edge, or Firefox.

    Targets: Files such as Login Data, key4.db, cookies.sqlite, and Local State.

    **Level: Critical**

## 3️⃣ Step 3: Public Network Egress 🌐

    File: [infostealer_STRICTv2_step3_public_egress.yml](./rules/ infostealer_STRICTv2_step3_public_egress.yml)

    Logic: Detects outbound network connections to public IP addresses initiated by common LOLBins (PowerShell, Cscript, Mshta, etc.).

    Filter: Automatically excludes private IP ranges (RFC 1918) to focus on external exfiltration.

    **Level: High**

## Common False Positives
- Step 1: Legitimate IT administration scripts (validate digital signatures and parent processes).
- Step 2: Enterprise password managers or browser security/forensic tools.
- Step 3: Legitimate automation or software updates reaching public endpoints.

###👤 Author

Adama ASSIONGBON SOC & CTI Consultant 🔗 [LinkedIn Profile](https://www.linkedin.com/in/adama-assiongbon-9029893a)

### 📜 References
- www.dexpose.io/deep-dive-into-arkanix-stealer-and-its-infrastructure/
- https://attack.mitre.org/techniques/T1555/
- https://attack.mitre.org/techniques/T1059/
## Author
**Author:** Adama ASSINGBON SOC & CTI Analyst Consultant | https://www.linkedin.com/in/adama-assiongbon-9029893a/
