![Sigma](https://img.shields.io/badge/Format-SIGMA-orange)
![Validation](https://img.shields.io/badge/Sigma_Check-Passed-green)
![Incident Response](https://img.shields.io/badge/IR-TheHive_Playbook-red)
![Infostealer](https://img.shields.io/badge/Infostealer-red)


# 🕵️‍♂️ Infostealer STRICT – High-Confidence Credential Access & Exfiltration Detection

[👉🏾  **French version available here**](README_FR.md)

## 📌 Overview

This Sigma rule is designed to **detect infostealer activity with high confidence** by correlating **three critical behaviors** commonly observed during real-world infostealer campaigns:

1️⃣ Suspicious execution of LOLBins or loaders from user-writable directories  
2️⃣ Access to browser credential storage artifacts  
3️⃣ Network-based data exfiltration using common command-line tools  

🎯 The objective is to provide **SOC-ready detection with minimal false positives**, suitable for alert correlation and incident escalation.

---

## 🔍 Detection Logic

The rule triggers **only when all three behaviors occur within the same process context**, ensuring a strong malicious signal.

### 1️⃣ Suspicious Execution (LOLBins)

Monitors execution of abused Windows binaries:

- `powershell.exe`, `pwsh.exe`
- `cmd.exe`
- `mshta.exe`
- `rundll32.exe`

🚨 When launched from user-writable locations:
- `\Users\`
- `\AppData\`
- `\Temp\`
- `\Downloads\`

This pattern is typical of **infostealer loaders and fileless malware**.

---

### 2️⃣ Credential Store Access

Detects command-line access to sensitive browser artifacts:

- Browser credential databases (`Login Data`, `Cookies`)
- Windows DPAPI decryption (`CryptUnprotectData`)

🔐 Strong indicator of **credential harvesting activity**.

---

### 3️⃣ Network Exfiltration

Requires evidence of outbound communication such as:

- `http://` / `https://`
- `Invoke-WebRequest`
- `curl`, `wget`

🌍 Confirms **exfiltration to attacker-controlled infrastructure**.

---

## 🔗 Correlation Condition

```
selection_exec AND selection_creds AND selection_net
```

✅ Ensures detection of **complete infostealer execution chains**.

---

## 🧭 MITRE ATT&CK Mapping

- **Execution**: T1059 - Command and Scripting Interpreter
- **Credential Access**: T1555 – Credentials from Password Stores
- **Exfiltration**: T1041 – Exfiltration Over C2 Channel

---

## ⚠️ False Positives

Rare, but may include:
- Authorized forensic or IR tools
- Legitimate security testing scripts

📝 Always validate context and asset ownership.

---

## 🔥 Severity

**CRITICAL**  
🚑 Immediate SOC investigation required.

---

## 📚 Threat Intelligence Reference

This rule is based on real-world infostealer tradecraft described here:

🔗 https://www.dexpose.io/deep-dive-into-arkanix-stealer-and-its-infrastructure/

---

## 👤 Author

**Adama ASSIONGBON**  SOC & CTI  Consultant  
**Contact:** 🔗[linkedin profile](https://www.linkedin.com/in/adama-assiongbon-9029893a)


