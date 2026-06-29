
# SOC Decision Table – Kernel_Rootkit_MVDR
👉🏾 [French version available here](README_FR.md)


 
## Purpose
Guide SOC analysts in decision-making when Kernel_Rootkit_MVDR rules trigger.

## Rules
- R1: Kernel driver load (visibility)
- R2: Kernel driver service creation (persistence)
- R3: Kernel rootkit correlation (confirmation)

## Decision Table

| R1 | R2 | R3 | Risk Level | SOC Decision | Immediate Action |
|----|----|----|------------|--------------|------------------|
| ❌ | ❌ | ❌ | None | Ignore | None |
| ✅ | ❌ | ❌ | Low | Monitor | Check context |
| ❌ | ✅ | ❌ | High | Investigate | Identify service |
| ✅ | ✅ | ❌ | Very High | Potential incident | Escalate to Tier 2 |
| ❌ | ❌ | ✅ | Critical | Confirmed incident | Immediate IR |
| ✅ | ❌ | ✅ | Critical | Confirmed incident | Immediate IR |
| ❌ | ✅ | ✅ | Critical | Confirmed incident | Immediate IR |
| ✅ | ✅ | ✅ | Critical | Confirmed incident | Immediate IR |

## Interpretation
- R1 only: weak signal
- R2 only: strong suspicion
- R3: OS trust is broken

✍🏿 **Author :** Adama ASSIONGBON – SOC & CTI Consultant  
[LinkedIn Profile](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

## Detection chain and rule relationships
When a pack contains multiple detections, `related` links the companion rules so SOC analysts can pivot from context to confirmation.
Use the broader alert as the hunt signal and the stricter alert as the confirmation signal when both exist.

