# 📊 Decision Table – Security Tool Impairment (Sigma Rules)
[👉🏾 **French version available here**](./README_FR.md)

This decision table explains **how and when to use each Sigma rule** in the *Defense Evasion – Security Tool Impairment* pack.

The rules are designed to be **complementary** and should ideally be **correlated together** for higher confidence detection.

---

## 🧩 Rules Overview

| ID | Rule Name | Detection Focus |
|----|----------|----------------|
| R1 | Termination of Security Processes | Effect / outcome |
| R2 | Disable Security Tools via Command Line (BROAD) | Suspicious intent |
| R3 | Disable Security Tools via Command Line (STRICT) | Explicit malicious action |

---

## 🎯 Decision Matrix

| Scenario | R1<br>Process Termination | R2<br>CLI Disable (BROAD) | R3<br>CLI Disable (STRICT) | SOC Interpretation | Recommended Action |
|--------|---------------------------|--------------------------|---------------------------|--------------------|-------------------|
| Legitimate admin maintenance | ✅ | ❌ / ⚠️ | ❌ | Likely benign | Log / monitor |
| Suspicious admin abuse | ❌ / ⚠️ | ✅ | ❌ | Early warning | Investigate user & host |
| Ransomware preparation | ⚠️ | ✅ | ⚠️ | High risk | Contain endpoint |
| Active defense evasion | ✅ | ⚠️ | ✅ | Confirmed malicious | Isolate host immediately |
| EDR kill before encryption | ✅ | ✅ | ✅ | Critical compromise | IR + containment |

Legend:  
- ✅ = Detected  
- ⚠️ = Possibly detected  
- ❌ = Not detected

---

## 🧠 Correlation Guidance

Recommended correlation logic:
- **R2 followed by R1** → strong indication of defense evasion
- **R3 alone** → high confidence malicious activity
- **R1 alone** → contextual signal, do not alert alone

Time window recommendation:
- **5–15 minutes**

---

## 🚨 Alerting Strategy

| Rule | Alert Severity | Usage |
|----|---------------|------|
| R1 | Medium | Context / enrichment |
| R2 | Medium–High | Hunting / early detection |
| R3 | Critical | Alert & response |

---

## 🧩 SOC Best Practices

- Do not rely on a single rule in isolation
- Correlate with:
  - LSASS access
  - Credential dumping
  - Lateral movement
  - Scheduled task creation
- Align alerts with change management windows

---

## 📌 Notes

These rules are SIEM-agnostic and must be adapted to local logging schemas.
## Author

✍🏿  Adama ASSIONGBON - SOC & CTI Consultant  
[LinkedIn Profile](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

