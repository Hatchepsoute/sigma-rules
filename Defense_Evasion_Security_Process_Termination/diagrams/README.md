# 📊 Attack Flow Diagram (Mermaid)
[👉🏾 **French version available here**](./README_FR.md)

flowchart TD
  %% Defense Evasion - Security Tool Impairment (BROAD vs STRICT) - Styled (GitHub compatible)

  A([Telemetry ingested]):::start --> B{Suspicious activity detected}:::decision

  subgraph BROAD["🟡 BROAD (R2) - Hunting / Early Warning"]
    direction TB
    C[BROAD: Attempt to disable security tools via CLI]:::broad
    D{Tuning exclusions applied}:::decision
    E[Alert: Medium to High\nInvestigate host and user context]:::action
    F[Expect noise\nAdd allowlist for admin scripts and build images]:::note
    C --> D
    D -->|Yes| E
    D -->|No| F
  end

  subgraph STRICT["🔴 STRICT (R3) - High Confidence / Low FP"]
    direction TB
    G[STRICT: High confidence security tool disable\nTool + action + explicit target]:::strict
    H[Alert: Critical\nImmediate containment recommended]:::critical
    G --> H
  end

  subgraph CORR["🟣 Correlation (R1) - Termination Signal"]
    direction TB
    I{R1 triggered\nTermination of security processes}:::decision
    J[Correlated detection\nVery high confidence defense evasion]:::corr
    K[Single signal\nContinue investigation and enrich context]:::note
    I -->|Yes| J
    I -->|No| K
  end

  subgraph RESP["🔵 SOC Response & Improvement Loop"]
    direction TB
    L[Response playbook\nIsolate host, triage, validate change window]:::action
    M[Enrichment pivot\nLSASS access, lateral movement, persistence]:::action
    N[Feedback loop\nTune filters, update allowlists, improve coverage]:::note
    L --> N
    M --> N
  end

  B -->|Yes| C
  B -->|Yes| G

  C --> I
  G --> I

  J --> L
  E --> L
  H --> L
  K --> M

  classDef start fill:#111827,stroke:#6b7280,color:#ffffff,stroke-width:1px;
  classDef decision fill:#f3f4f6,stroke:#6b7280,color:#111827,stroke-width:1px;
  classDef broad fill:#fef08a,stroke:#ca8a04,color:#111827,stroke-width:1px;
  classDef strict fill:#fecaca,stroke:#b91c1c,color:#111827,stroke-width:1px;
  classDef critical fill:#ef4444,stroke:#7f1d1d,color:#ffffff,stroke-width:2px;
  classDef corr fill:#e9d5ff,stroke:#7c3aed,color:#111827,stroke-width:1px;
  classDef action fill:#dbeafe,stroke:#2563eb,color:#111827,stroke-width:1px;
  classDef note fill:#e5e7eb,stroke:#374151,color:#111827,stroke-dasharray: 4 3;

