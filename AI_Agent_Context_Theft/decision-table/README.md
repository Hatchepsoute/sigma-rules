# 🧠 Decision Table - AI Agent Context Theft
👉🏾 [**French version available here**](README_FR.md)

## Purpose
Guide SOC analysts in triaging alerts related to AI agent identity and context theft (OpenClaw and similar agents).

---

## 🟡 BROAD - Suspicious Access to AI Agent Files

| Condition | Yes | No |
|---------|-----|----|
| Access to `.openclaw` directory | Continue | Close |
| Sensitive file accessed (`openclaw.json`, `SOUL.md`, `MEMORY.md`) | Continue | Close |
| Process non-interactive / unexpected | Escalate L2 | Monitor |
| Repeated access in short time | Increase confidence | Monitor |

Action:
- Hunting alert
- Correlate with process + network activity

---

## 🔴 STRICT – Authentication Secrets Exfiltration

| Condition | Yes | No |
|---------|-----|----|
| `openclaw.json` accessed | Continue | Close |
| Process from Temp/AppData/Downloads | Escalate L3 | Monitor |
| Process not legitimate agent | Incident | Monitor |
| Outbound network activity | Confirm compromise | Pending |

Action:
- Isolate host
- Revoke tokens
- Audit AI agent actions

---

## 🔴🔴 CRITICAL - Cryptographic Identity Compromise

| Condition | Yes | No |
|---------|-----|----|
| `device.json` / `.pem` accessed | Incident | Close |
| Private key present | Confirm incident | Investigate |
| Unexpected process | Immediate IR | Investigate |

Action:
- Rotate keys
- Regenerate agent identity
- Full IR workflow

---

## 🔴🔴 CRITICAL - Multi‑File Access

| Condition | Yes | No |
|---------|-----|----|
| Auth + Crypto + Memory files accessed | Full compromise | Investigate |
| Same process involved | Immediate IR | Investigate |

Action:
- Assume full agent takeover

## ✍🏿 Author
[Adama ASSIONGBON – SOC & CTI Consultant](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

