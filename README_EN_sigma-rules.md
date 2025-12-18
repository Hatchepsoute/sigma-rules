# 🛡️ sigma-rules
### Community Sigma Rules for CVE Detection & Blue Team Operations

## 🎯 Repository Objective
This repository provides a collection of **Blue Team–oriented Sigma rules**, organized by CVE,
to detect the exploitation of known vulnerabilities and **post-exploitation behaviors**
observed in SOC environments.

Approach: **behavior-based**, **SIEM-agnostic** (ELK, OpenSearch, Splunk, Microsoft Sentinel, Wazuh, EDR).

## 🧠 Detection Philosophy
❌ Static signature-based detection only  
✅ **Behavioral and contextual detection**

## 📦 Repository Organization
Each vulnerability is treated as an **independent CVE pack**.

```
sigma-rules/
├── README.md
├── packs/
│   ├── CVE-2025-6218_WinRAR/
│   └── CVE-2025-50165_WindowsGraphics/
└── diagrams/
```

## 🧩 Available CVE Packs
- **CVE-2025-6218** – WinRAR (Path Traversal / Persistence)
- **CVE-2025-50165** – Windows Graphics Component (weaponized images)

## 🛡️ Rule Levels
- **BROAD**: threat hunting, maximum coverage
- **STRICT**: production SOC, low noise

## 🔁 Sigma → SIEM Conversion
Use `sigma-cli`:

```bash
pip install sigma-cli
sigma convert -t splunk rule.yml
sigma convert -t elasticsearch rule.yml
sigma convert -t sentinel rule.yml
```

## 🤝 Contribution
Each new CVE must be added under the `packs/` directory.

## ⚠️ Disclaimer
Defensive use only.
Rules must be tested and adapted to each environment before production deployment.
