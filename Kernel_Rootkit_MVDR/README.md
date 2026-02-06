
# Kernel Rootkit MVDR – Scenario-Based Explanation

 [👉🏾  **French version favailable here**](README_FR.md)

## 1. Attack Scenario (Attacker Perspective)

This detection pack addresses kernel-mode rootkit attacks on Windows systems.

Typical attack flow:
1. Attacker gains local administrator privileges
2. Drops a malicious kernel driver (.sys)
3. Registers the driver as a kernel service (Type=1)
4. Loads the driver into the kernel (Ring-0)
5. Rootkit hides activity and persists across reboots

Once the driver is loaded, operating system trust is broken.

[mvdr-01-kernel-driver-load.yml](./rules/mvdr-01-kernel-driver-load.yml)
---

## 2. Detection Logic (SOC Perspective)

Each rule maps to a critical attack stage.

### Rule mvdr-01-kernel-driver-load
Detects kernel driver loading.
- False positives: legitimate drivers (updates, hardware)
- True positives: unexpected driver load outside change window
Usage: signal / hunting

[mvdr-02-kernel-service.yml](./rules/mvdr-02-kernel-service.yml)

### Rule mvdr-02-kernel-service
Detects kernel driver persistence via service creation.
- False positives: rare legitimate driver installs
- True positives: unknown kernel services
Usage: high severity alert

### Rule mvdr-03-kernel-rootkit-correlation
Correlates execution + persistence.
- False positives: extremely unlikely
- True positives: confirmed kernel rootkit
Usage: critical incident

[mvdr-03-kernel-rootkit-correlation.yml](./rules/mvdr-03-kernel-rootkit-correlation.yml)
---

## 3. Pentest & Purple Team Scenarios

Scenario A: Deploy test kernel driver in lab
Expected: all three rules triggered

Scenario B: Legitimate signed driver install
Expected: rule 1/2 may trigger, rule 3 should not

Scenario C: Purple Team
Red Team simulates kernel persistence
Blue Team validates detection and response

---

## 4. Key SOC Message

A kernel alert is a major incident.
The operating system can no longer be trusted.

[Why MVDR – Minimum Viable Detection Rules](./README_Why_MVDR.md)

✍🏿 **Auteur :** Adama ASSIONGBON – SOC & CTI Consultant  
[LinkedIn Profile](https://www.linkedin.com/in/adama-assiongbon-9029893a/)


