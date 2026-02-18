![Release](https://img.shields.io/badge/release-v1.0.0-blue?style=flat-square)
![Sigma](https://img.shields.io/badge/Sigma-compatible-success?style=flat-square)
![MITRE ATT&CK](https://img.shields.io/badge/MITRE_ATT%26CK-mapped-red?style=flat-square)

# 🧠 AI Agent Context Theft - Sigma Detection Pack

![Release](https://img.shields.io/badge/release-v1.0.0-blue?style=flat-square)

👉🏾 [**French version available here**](README_FR.md)

## Overview
This repository contains a Sigma detection pack designed to identify identity and context theft targeting local AI agents such as OpenClaw and similar frameworks.

Unlike traditional credential theft, this threat model focuses on the exfiltration of:
- persistent authentication tokens,
- cryptographic device identities (private keys),
- long-term memory and behavioral context of AI agents.

Based on a real-world infostealer infection observed in February 2026.

---

## Detection Layers

| Layer | Rule | Purpose |
|-------|------|---------|
| 🟡 BROAD | Config & Memory Access | Early anomaly detection |
| 🔴 STRICT | Auth Secrets Exfiltration | Token theft |
| 🔴🔴 CRITICAL | Crypto Identity Compromise | Device impersonation |
| 🔴🔴 CRITICAL | Multi-File Access | Full agent takeover |

All rules are behavioral and Sigma-portable.

---

## SOC Response

If STRICT or CRITICAL triggers:
1. Isolate endpoint
2. Revoke AI tokens
3. Regenerate device identity
4. Audit agent activity
5. Assume full impersonation risk

---

## ✍🏿 Author
[Adama ASSIONGBON – SOC & CTI Consultant](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

