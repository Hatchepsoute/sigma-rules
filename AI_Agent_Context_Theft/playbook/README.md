# 🚨 TheHive Playbook - AI Agent Context Theft 
[👉🏾 French version available here: ](./README_FR.md)
## Objective
Guide SOC and IR teams in responding to alerts indicating identity or context theft of a local AI agent (e.g., OpenClaw).

---

## 🔎 Trigger
- Any of the following Sigma rules fires:
  - AI_Agent_Secrets_Exfiltration_STRICT
  - AI_Agent_Crypto_Identity_Compromise_STRICT
  - AI_Agent_MultiFile_Exfiltration_STRICT

Severity: **High / Critical**

---

## 🧭 Phase 1 – Initial Triage (SOC L2/L3)

1. Validate alert source and rule name
2. Identify impacted host and user
3. Determine accessed file(s):
   - `openclaw.json`
   - `device.json`, `.pem`
   - `SOUL.md`, `MEMORY.md`, `AGENTS.md`
4. Identify suspicious process (path, hash, parent)

Decision:
- If crypto identity involved → skip to Phase 3
- Otherwise continue Phase 2

---

## 🚧 Phase 2 – Containment

1. Isolate endpoint from network
2. Block suspicious process hash (EDR)
3. Preserve volatile data (process tree, network connections)
4. Prevent further access to AI agent directories

---

## 🔐 Phase 3 – Credential & Identity Remediation

1. Revoke AI agent gateway tokens
2. Regenerate device identity (keys / certificates)
3. Invalidate paired cloud services
4. Rotate any secrets stored in AI agent memory

---

## 🧪 Phase 4 – Investigation

1. Timeline reconstruction:
   - file access
   - process execution
   - outbound connections
2. Check for data exfiltration
3. Review AI agent logs/actions for misuse
4. Assess lateral movement risk

---

## 🧹 Phase 5 – Recovery

1. Rebuild or clean endpoint if required
2. Re-deploy AI agent securely
3. Restore minimal trusted memory only
4. Monitor for re-infection

---

## 📌 Phase 6 – Lessons Learned

1. Classify AI agent data as privileged
2. Enable encryption at rest
3. Monitor access to agent directories
4. Update SOC detection & playbooks

---

## 🧠 Key Message
A compromised AI agent represents **identity theft**, not just malware infection.
## ✍🏿 Author
[Adama ASSIONGBON – SOC & CTI Consultant](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

