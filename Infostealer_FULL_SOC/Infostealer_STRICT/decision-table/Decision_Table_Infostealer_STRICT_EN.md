# 📊 Decision Table – Confirmed Infostealer Activity (STRICT)

## Detection Scope
High-confidence, multi-stage correlated detection of infostealer activity.

## Detection Logic
Correlation of:
- Suspicious LOLBin execution from user-writable paths
- Browser credential store access
- External network exfiltration

## Analyst Decision Matrix

| Observed Conditions | SOC Decision | Action |
|-------------------|-------------|--------|
| LOLBin execution only | Monitor | No escalation |
| LOLBin + credential access | Suspicious | Correlate events |
| LOLBin + credential access + exfiltration | **Confirmed Infostealer Activity** | Trigger IR playbook |

## Severity
Critical

## SOC Standard Statement
This alert represents a confirmed infostealer activity based on multi-stage behavioral correlation.
