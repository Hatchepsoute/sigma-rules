# 🛡️ Infostealer STRICT v2 — Decision Table

## 🎯 Objective

This decision table structures SOC analysis for the three STRICT v2 rules:

- **Step 1 (E1)** — Suspicious execution from user-writable path via LOLBin  
- **Step 2 (E2)** — Non-browser process accessing browser credential stores  
- **Step 3 (E3)** — Public network egress from LOLBin/loader  

🕒 **Recommended correlation window: ≤ 10 minutes**

---

## 🧭 Diagram (Mermaid)

```mermaid
flowchart TD
  A([Start]) --> B{Step 1 (E1) alert?\nSuspicious exec?}
  B -->|Yes| C{Step 2 (E2) alert?\nBrowser cred access?}
  B -->|No| D{Step 2 (E2) alert?\nBrowser cred access?}

  C -->|Yes| E{Step 3 (E3) alert?\nPublic egress?}
  C -->|No| F{Step 3 (E3) alert?\nPublic egress?}

  D -->|Yes| G{Step 3 (E3) alert?\nPublic egress?}
  D -->|No| H{Step 3 (E3) alert?\nPublic egress?}

  E -->|Yes| I[[Case 1\nE1+E2+E3\n🔴 P1 Incident]]
  E -->|No| J[[Case 2\nE1+E2\n🟠 P1/P2 Monitor E3]]

  F -->|Yes| K[[Case 3\nE1+E3\n🟡 P2 Validate dest]]
  F -->|No| L[[Case 5\nE1 only\n🟡 P3 Quick triage]]

  G -->|Yes| M[[Case 4\nE2+E3\n🟠 P1/P2]]
  G -->|No| N[[Case 6\nE2 only\n🟡 P2/P3]]

  H -->|Yes| O[[Case 7\nE3 only\n🟡 P3 Tuning]]
  H -->|No| P[[Case 8\nNo signal\n—]]

  I --> Q([Actions: isolate, collect, block, reset creds])
  J --> R([Actions: proxy/DNS, monitor 30–60 min])
  K --> S([Actions: reputation, parent, artefacts])
  M --> T([Actions: identify process, signature, persistence])
```

---

## 🔎 Decision Table

| Case | E1 | E2 | E3 | Confidence | SOC Interpretation | Priority | Recommended Actions |
|------|----|----|----|------------|-------------------|----------|--------------------|
| 1 | ✅ | ✅ | ✅ | 🔴 Very High | Typical infostealer chain | P1 | Isolate host, collect hashes, block IP/domain, reset credentials |
| 2 | ✅ | ✅ | ❌ | 🟠 High | Likely credential theft | P1/P2 | Review proxy/DNS logs, monitor E3 |
| 3 | ✅ | ❌ | ✅ | 🟡 Medium | Possible loader/downloader | P2 | Validate destination reputation |
| 4 | ❌ | ✅ | ✅ | 🟠 Medium to High | Credential access + exfil | P1/P2 | Identify process, hunt persistence |
| 5 | ✅ | ❌ | ❌ | 🟡 Low to Medium | Suspicious LOLBin only | P3 | Quick triage |
| 6 | ❌ | ✅ | ❌ | 🟡 Medium | Credential access without exfil | P2/P3 | Check password managers |
| 7 | ❌ | ❌ | ✅ | 🟡 Low to Medium | Isolated LOLBin egress | P3 | Validate IP/domain reputation, tune exclusions |
| 8 | ❌ | ❌ | ❌ | — | No signal | — | — |

---

_Generated on: 2026-02-16 17:11:37 UTC_
