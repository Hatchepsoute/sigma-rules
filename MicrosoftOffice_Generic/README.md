# Microsoft Office → LOLBins Detection (Sigma Rules)
➡️ **[French version available here](./README_FR.md)**
## Status
- **Experimental**
- Intended for SOC detection, triage, and threat hunting
---

## Overview

This directory contains **two correlated Sigma rules** designed to detect **malicious Microsoft Office exploitation behaviors** observed across multiple Office-related CVEs and real-world attack campaigns.

These rules are **generic by design** and not tied to a single CVE.  
They focus on **post-execution behaviors** that reliably indicate malicious activity.

The rules follow the **official sigma-rules detection philosophy**:
- A **BROAD rule** for visibility and hunting
- A **STRICT rule** for high-confidence detection

They are intended to be **deployed together**.

---

## Threat Context

Microsoft Office documents are frequently abused as an **initial execution vector**:

- User opens a malicious document
- Office spawns system tools (**LOLBins**)
- Payloads are downloaded or executed
- Attacker transitions to post-exploitation

Office applications **should not normally spawn command interpreters or download utilities**.

---

## Rule 1 - BROAD

### Name
**Microsoft Office spawns LOLBIN or script engine (BROAD)**
[office_spawn_lolbin_broad.yml](./rules/office_spawn_lolbin_broad.yml)
### Purpose
Detect abnormal **parent-child process relationships** where Microsoft Office launches a LOLBin or script engine.

### Detection Logic
- **Parent process**: Microsoft Office applications
- **Child process**: Common LOLBins or script engines
- **No command-line inspection**

### SOC Interpretation
- Suspicious but **not sufficient alone** to confirm compromise
- Provides **early visibility** into potential exploitation attempts

### Recommended Usage
- SOC analyst L1 / L2 triage
- Threat hunting
- Baseline correlation rule

---

## Rule 2 - STRICT

### Name
**Microsoft Office spawns LOLBIN with download/execute or obfuscation patterns (STRICT)**
[office_download_execute_strict.yml](./rules/office_download_execute_strict.yml)
### Purpose
Detect **explicit malicious intent** following Office execution.

### Detection Logic
- Office parent process
- LOLBin or script engine child process
- **AND** command-line indicators such as:
  - Remote payload download (HTTP, curl, bitsadmin, certutil)
  - Obfuscation or in-memory execution (`-enc`, Base64, IEX)

### SOC Interpretation
- **High-confidence malicious activity**
- Strong indicator of active exploitation or post-exploitation

### Recommended Usage
- SOC analyst L2 / L3 escalation
- Incident declaration
- SOAR / automated response

---

## Correlation Strategy (Required)

These rules are designed to be **correlated**.

### Recommended Detection Flow

1. **BROAD rule triggers**
   - Suspicious Office behavior detected
   - Analyst awareness raised

2. **STRICT rule triggers**
   - Malicious intent confirmed
   - Incident escalated

This approach:
- Reduces false positives
- Preserves early detection capability

---

## SOC Comparison Table

| Criteria | BROAD | STRICT |
|------|------|------|
| Detection scope | Broad | Narrow |
| False positives | Possible | Rare |
| Confidence level | Medium | High |
| Command-line analysis | ❌ | ✅ |
| Payload download detection | ❌ | ✅ |
| Obfuscation detection | ❌ | ✅ |
| SOC usage | L1 / L2 | L2 / L3 |
| Incident-ready | ❌ | ✅ |

---

## Best Practice

> Always deploy **both rules together**.
>
> - BROAD = visibility & hunting  
> - STRICT = confirmation & response  
>
> This pairing provides **robust detection coverage** for Microsoft Office-based attack chains.
---
✍🏿  Author: **Adama ASSIONGBON** - SOC & CTI Consultant  
**Contact:** [LinkedIn Profile](https://www.linkedin.com/in/adama-assiongbon-9029893a/)
