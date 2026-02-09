# 🛡️ Defense Evasion – Security Tool Impairment (Sigma Rules Pack)
[👉🏾 **French version available here**](./README_FR.md)

This open-source Sigma pack detects attempts to **impair, disable, or terminate security tools** (EDR, AV, Microsoft Defender) on Windows systems.

Such behaviors are commonly observed during:
- ransomware pre-encryption phases
- post-exploitation activities
- defense evasion operations (MITRE ATT&CK T1562.001)

The rules are **behavioral**, **SIEM-agnostic**, and designed for **conversion to any backend** (Splunk, Elastic, OpenSearch, QRadar, ArcSight, Wazuh, Sentinel, etc.).

---

## 📂 Included Sigma Rules

### 1️⃣ Termination of Security Processes
**File:**  [`proc_termination_security_processes.yml`](./rules/proc_termination_security_processes.yml)

**Purpose:**  
Detects the termination of known security or EDR processes.

**Detection logic:**
- Observes process termination events
- Matches against common security process names
- Intended as a **contextual signal**, not standalone proof

**Use case:**  
Correlation, investigation pivot, ransomware kill-chain analysis

---

### 2️⃣ Disable Security Tools via Command Line (BROAD)
**File:**   [`proc_creation_disable_security_tools_broad.yml`](./rules/proc_creation_disable_security_tools_broad.yml)

**Purpose:**  
Broad detection of attempts to disable or manipulate security tools using command-line utilities.

**Detection logic:**
- Command-line tools (taskkill, sc, net, PowerShell, wmic)
- Generic stop / disable / exclusion patterns
- Defender and security-related targets

**Use case:**  
Threat hunting, early warning, detection of suspicious administrative abuse

---

### 3️⃣ Disable Security Tools via Command Line (STRICT)
**File:**   [`proc_creation_disable_security_tools_strict.yml`](./rules/proc_creation_disable_security_tools_strict.yml)

**Purpose:**  
High-confidence detection of explicit security tool disabling.

**Detection logic:**
- Strong patterns such as:
  - `taskkill /F /IM <security_process>`
  - `sc stop WinDefend`
  - `Set-MpPreference -DisableRealtimeMonitoring`
- Explicit tool + action + target combinations

**Use case:**  
SOC alerting, automated response, ransomware containment

---

## 🎯 Detection Strategy

| Rule | Confidence | SOC Usage |
|---|---|---|
| Process termination | Medium | Correlation / context |
| CLI disable (BROAD) | Medium | Hunting / early detection |
| CLI disable (STRICT) | High | Alerting / response |

**Best practice:**  
Correlate multiple rules within a short time window to increase confidence.

---

## 🧠 MITRE ATT&CK Mapping

- `T1562` – Impair Defenses  
- `T1562.001` – Disable or Modify Security Tools

---

## ⚠️ False Positives & Tuning

Possible benign scenarios:
- Legitimate maintenance by administrators
- Endpoint provisioning or hardening scripts
- Incident response containment actions

➡️ Recommended tuning:
- Allowlist known admin scripts
- Exclude golden image build processes
- Correlate with change management windows

---

## 📌 Disclaimer

These rules are provided for defensive purposes only.  
They are generic by design and must be adapted to each environment.

---

## 🤝 Contributions

Improvements, additional vendors, and correlation ideas are welcome via pull requests.
## Author

✍🏿  Adama ASSIONGBON - SOC & CTI Consultant  
[LinkedIn Profile](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

