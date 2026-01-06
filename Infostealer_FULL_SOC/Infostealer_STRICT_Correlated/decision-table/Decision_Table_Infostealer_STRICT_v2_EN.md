# 📊 Decision Table – Infostealer STRICT v2 (Correlated)

## Correlation Model
Step-based correlated detection across a short time window (≤10 minutes).

### Steps
1. Suspicious LOLBin / loader execution
2. Browser credential store access
3. External network egress

## Analyst Decision Matrix

| Steps Observed | Decision | Action |
|---------------|----------|--------|
| Step 1 only | Monitor | Collect context |
| Step 1 + Step 2 | High suspicion | Escalate for correlation |
| Step 1 + Step 2 + Step 3 | **Confirmed Infostealer Activity** | Trigger IR playbook |
