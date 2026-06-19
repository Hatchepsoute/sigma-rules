# 📊 Diagrams --- Infostealer STRICT High Confidence

 [👉🏾  **English version available here**](README.md)

This directory contains styled Mermaid diagrams for the rule:

**Infostealer High-Confidence Credential Access and Exfiltration**\
ID: `50f27880-01d7-42b2-9368-0939504fa162`

------------------------------------------------------------------------

## Diagramme


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
H1["🛡️ Infostealer STRICT, High Confidence"]:::header
H2["🏷️ Badges:  ✅ Correlation 3/3  |  🔴 P1 Incident  |  🟠 P2 Investigate  |  🔵 P3 Triage"]:::header
H1 --> H2

%% --- Inputs / Conditions ---
subgraph S0["🧩 Conditions (toutes nécessaires)"]
  direction TB
  E1{"E1, Exécution suspecte\nLOLBIN + chemin user-writable ?"}:::p3
  E2{"E2, Accès credentials navigateur ?\n(Login Data / Cookies / CryptUnprotectData)"}:::p3
  E3{"E3, Indicateurs d'exfiltration ?\n(http/https, IWR, curl, wget)"}:::p3
end

H2 --> E1
E1 -->|Non| N1["❌ Pas de déclenchement\n(Enrichir / surveiller)"]:::no
E1 -->|Oui| E2
E2 -->|Non| N2["❌ Pas de déclenchement\n(Vol creds non confirmé)"]:::no
E2 -->|Oui| E3
E3 -->|Non| N3["❌ Pas de déclenchement\n(Exfil non observée)"]:::no
E3 -->|Oui| TRIG["✅ Déclenchement Règle\nChaîne complète infostealer"]:::p1

%% --- Response Playbook ---
subgraph IR["🚨 Réponse SOC (P1)"]
  direction TB
  A1["1) Isoler l’hôte (EDR)"]:::p1
  A2["2) Collecter: process tree, cmdline, hash, user, parent"]:::p1
  A3["3) Bloquer: IP/Domaine/URL (proxy/SWG/DNS)"]:::p1
  A4["4) Reset creds: navigateur, SSO, comptes à privilèges"]:::p1
  A5["5) Hunting: mêmes patterns sur endpoints voisins"]:::p1
end

TRIG --> A1 --> A2 --> A3 --> A4 --> A5

%% --- Optional investigation paths (non-trigger) ---
subgraph INV["🟠 P2 / 🔵 P3, Pistes d’investigation (si signal partiel)"]
  direction TB
  P2a["🟠 P2: Si E1+E2 sans E3 → vérifier proxy/DNS, egress bloqué, tenter de retrouver la destination"]:::p2
  P2b["🟠 P2: Si E1+E3 sans E2 → possible downloader/staging, vérifier artefacts déposés"]:::p2
  P3a["🔵 P3: Si E1 seul → valider signature, outil IT, RMM, parent process attendu"]:::p3
end

N2 --> P2a
N3 --> P2a
N1 --> P3a
N3 --> P2b
```

------------------------------------------------------------------------
