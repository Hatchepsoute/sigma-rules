# Infostealer STRICT v2 (Correlated) – SOC Pack

**Author:** Adama ASSINGBON SOC & CTI Analyst Consultant | https://www.linkedin.com/in/adama-assiongbon-9029893a/

## What this pack does
This is a **3-step correlated detection** for infostealers:
1) Suspicious LOLBin execution from user-writable paths (process creation)
2) Non-browser access to browser credential stores (file access)
3) Public egress by LOLBins/loaders (network connection)

## How to confirm
Confirm as **incident** when **Step 2** is correlated with **Step 1** and **Step 3** within **<=10 minutes** on the same Host/User.

## References
- https://www.dexpose.io/deep-dive-into-arkanix-stealer-and-its-infrastructure/
- MITRE ATT&CK: T1059, T1555, T1071.001, T1041
