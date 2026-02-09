# 📊 Attack Flow Diagram (Mermaid)
[👉🏾 **French version available here**](./README_FR.md)

flowchart TD
  %% Defense Evasion - Security Tool Impairment (BROAD vs STRICT)

  A[Telemetry ingested: Windows process creation and process termination] --> B{Suspicious activity detected}

  %% BROAD path (R2)
  B -->|Yes| C[BROAD (R2): Attempt to disable security tools via CLI]
  C --> D{Tuning exclusions applied}
  D -->|Yes| E[Alert: Medium to High. Investigate host and user context]
  D -->|No| F[Expect noise. Add allowlist for admin scripts and build images]

  %% STRICT path (R3)
  B -->|Yes| G[STRICT (R3): High confidence security tool disable]
  G --> H[Alert: Critical. Immediate containment recommended]

  %% Correlation with termination (R1)
  C --> I{R1 triggered: termination of security processes}
  G --> I
  I -->|Yes| J[Correlated detection: very high confidence defense evasion]
  I -->|No| K[Single signal: continue investigation and enrich context]

  %% Response actions
  J --> L[Response playbook: isolate host, triage, validate change window]
  E --> L
  H --> L
  K --> M[Enrichment pivot: LSASS access, lateral movement, persistence]

  %% Feedback loop
  M --> N[Feedback loop: tune filters, update allowlists, improve coverage]
  L --> N

