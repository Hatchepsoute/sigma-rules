## Diagram 

[👉🏾 French version available here: ](./README_FR.md)

📁 Source file: `DIAGRAM_INFOSTEALER_STRICT_HIGH_CONFIDENCE_EN.mmd`

``` mermaid
flowchart TD
%% =========================
%% Infostealer STRICT (High Confidence)
%% Decision Flow (E1 + E2 + E3)
%% =========================

%% --- Styles (GitHub Mermaid compatible) ---
classDef p1 fill:#ffdddd,stroke:#cc0000,color:#000,stroke-width:2px;
classDef p2 fill:#fff2cc,stroke:#b8860b,color:#000,stroke-width:2px;
classDef p3 fill:#e7f3ff,stroke:#1f6feb,color:#000,stroke-width:2px;
classDef ok fill:#e6ffed,stroke:#2da44e,color:#000,stroke-width:2px;
classDef no fill:#f6f8fa,stroke:#57606a,color:#000,stroke-width:1px;
classDef header fill:#f2f2f2,stroke:#8c8c8c,color:#000,stroke-width:1px;

%% --- Header / Badges ---
H1["🛡️ Infostealer STRICT — High Confidence"]:::header
H2["🏷️ Badges:  ✅ 3/3 Correlation  |  🔴 P1 Incident  |  🟠 P2 Investigate  |  🔵 P3 Triage"]:::header
H1 --> H2

%% --- Inputs / Conditions ---
subgraph S0["🧩 Conditions (all required)"]
  direction TB
  E1{"E1 — Suspicious execution\nLOLBIN + user-writable path ?"}:::p3
  E2{"E2 — Browser credential access ?\n(Login Data / Cookies / CryptUnprotectData)"}:::p3
  E3{"E3 — Exfiltration indicators ?\n(http/https, IWR, curl, wget)"}:::p3
end

H2 --> E1
E1 -->|No| N1["❌ No trigger\n(Enrich / monitor)"]:::no
E1 -->|Yes| E2
E2 -->|No| N2["❌ No trigger\n(Cred theft not confirmed)"]:::no
E2 -->|Yes| E3
E3 -->|No| N3["❌ No trigger\n(Exfil not observed)"]:::no
E3 -->|Yes| TRIG["✅ Rule Triggered\nFull infostealer chain"]:::p1

%% --- Response Playbook ---
subgraph IR["🚨 SOC Response (P1)"]
  direction TB
  A1["1) Isolate host (EDR)"]:::p1
  A2["2) Collect: process tree, cmdline, hash, user, parent"]:::p1
  A3["3) Block: IP/Domain/URL (proxy/SWG/DNS)"]:::p1
  A4["4) Reset creds: browser, SSO, privileged accounts"]:::p1
  A5["5) Hunt: same patterns across nearby endpoints"]:::p1
end

TRIG --> A1 --> A2 --> A3 --> A4 --> A5

%% --- Optional investigation paths (non-trigger) ---
subgraph INV["🟠 P2 / 🔵 P3 — Investigation paths (partial signal)"]
  direction TB
  P2a["🟠 P2: If E1+E2 without E3 → review proxy/DNS, blocked egress, recover destination"]:::p2
  P2b["🟠 P2: If E1+E3 without E2 → possible downloader/staging, check dropped artefacts"]:::p2
  P3a["🔵 P3: If E1 only → validate signer, IT tool/RMM, expected parent process"]:::p3
end

N2 --> P2a
N3 --> P2a
N1 --> P3a
N3 --> P2b
```

------------------------------------------------------------------------

## 🧠 Legend

-   🔴 **P1** → Confirmed high-confidence infostealer chain (Immediate
    incident)
-   🟠 **P2** → Investigate (partial signal correlation)
-   🔵 **P3** → Triage / validation (single signal)

------------------------------------------------------------------------

