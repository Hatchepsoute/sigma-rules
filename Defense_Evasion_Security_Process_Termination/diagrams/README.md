
```mermaid
flowchart TD
  %% Defense Evasion - Security Tool Impairment (BROAD vs STRICT)

  A[Telemetry Ingested<br/>Windows Process Creation + Process Termination] --> B{Suspicious Activity Detected?}

  %% BROAD path
  B -->|Yes| C[BROAD (R2)<br/>Attempt to Disable Security Tools via CLI<br/>Hunting / Early Warning]
  C --> D{Tuning / Exclusions Applied?}
  D -->|Yes| E[Generate Medium/High Alert<br/>Investigate Host + User Context]
  D -->|No| F[Expect More Noise<br/>Add Allowlist for Admin Scripts / Build Images]

  %% STRICT path
  B -->|Yes| G[STRICT (R3)<br/>High Confidence Disable Security Tools<br/>Tool + Action + Explicit Target]
  G --> H[Generate Critical Alert<br/>Immediate Containment Recommended]

  %% Termination correlation
  C --> I{R1 Triggered?<br/>Termination of Security Processes}
  G --> I
  I -->|Yes| J[Correlated Detection<br/>Very High Confidence Defense Evasion]
  I -->|No| K[Single Signal<br/>Continue Investigation / Add Context]

  %% Response actions
  J --> L[Response Playbook<br/>Isolate Host + Collect Triage Evidence<br/>Validate Change Window]
  E --> L
  H --> L
  K --> M[Enrichment & Pivot<br/>Check LSASS Access, Lateral Movement, Persistence]

  %% Notes
  M --> N[Feedback Loop<br/>Tune Filters + Update Allowlist + Improve Coverage]
  L --> N
```
