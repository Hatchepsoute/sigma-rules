# Infostealer Sysmon Detection - BROAD / STRICT / SUPPORT

## Overview
This set of three Sigma rules implements a progressive and correlated detection model for infostealer activity on Windows endpoints using Sysmon telemetry.

The rules are designed to work together:
- BROAD provides early warning execution signals
- STRICT detects high-confidence credential harvesting
- SUPPORT confirms suspicious external network communication

Together, they enable SOC teams to move from suspicion to confirmed infostealer activity.

## Rule Roles

### Rule 1 – BROAD (Execution – Early Warning)
Detects execution of common loaders or LOLBins (PowerShell, cmd, mshta, rundll32, etc.) from user-writable directories such as AppData, Temp, Downloads and Users.

**SOC usage:**
- Weak signal when isolated
- Ideal for hunting and context building
- Used as Step 1 in correlation

MITRE ATT&CK: T1059

### Rule 2 - STRICT (Credential Harvesting)
Detects non-browser processes accessing browser credential stores:
- Chrome / Edge: Login Data, Cookies
- Firefox: key4.db, logins.json

This behavior is a strong indicator of credential theft.

SOC usage:
- High-confidence detection
- Critical when correlated with execution or network activity

MITRE ATT&CK: T1555

### Rule 3 - SUPPORT (Network Egress)
Detects public (Internet-facing) network connections initiated by common LOLBins,
excluding private IP ranges.

**SOC usage:**
- Indicates potential data exfiltration or C2 communication
- Used to confirm malicious activity when correlated

MITRE ATT&CK: T1071.001

## Recommended Correlation Logic

- BROAD only: Suspicious execution, monitor
- STRICT only: Likely credential theft, investigate
- STRICT + SUPPORT: High-confidence infostealer
- BROAD + STRICT + SUPPORT: Confirmed infostealer activity

## SOC & Incident Response
When all three rules are observed within a short time window, treat the host as compromised:
- Isolate the endpoint
- Reset exposed credentials
- Assess data exfiltration
- Perform threat hunting

