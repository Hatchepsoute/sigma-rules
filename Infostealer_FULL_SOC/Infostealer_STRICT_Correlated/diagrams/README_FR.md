# 🛡️ Infostealer STRICT v2, Table de Décision

## 🎯 Objectif

Cette table de décision structure l’analyse SOC pour les trois règles STRICT v2 :

- **Step 1 (E1)**, Exécution suspecte depuis un chemin user-writable via LOLBin  
- **Step 2 (E2)**, Accès aux stockages d’identifiants navigateur par un processus non-browser  
- **Step 3 (E3)**, Communication sortante vers Internet depuis LOLBin/loader  

🕒 **Fenêtre de corrélation recommandée : ≤ 10 minutes**

---

## 🧭 Diagramme (Mermaid)

```mermaid
flowchart TD
  A([Début]) --> B{Alerte Step 1 (E1)\nExec suspecte ?}
  B -->|Oui| C{Alerte Step 2 (E2)\nAccès creds navigateur ?}
  B -->|Non| D{Alerte Step 2 (E2)\nAccès creds navigateur ?}

  C -->|Oui| E{Alerte Step 3 (E3)\nEgress public ?}
  C -->|Non| F{Alerte Step 3 (E3)\nEgress public ?}

  D -->|Oui| G{Alerte Step 3 (E3)\nEgress public ?}
  D -->|Non| H{Alerte Step 3 (E3)\nEgress public ?}

  E -->|Oui| I[[Cas 1\nE1+E2+E3\n🔴 P1 Incident]]
  E -->|Non| J[[Cas 2\nE1+E2\n🟠 P1/P2 Surveiller E3]]

  F -->|Oui| K[[Cas 3\nE1+E3\n🟡 P2 Valider dest]]
  F -->|Non| L[[Cas 5\nE1 seul\n🟡 P3 Triage]]

  G -->|Oui| M[[Cas 4\nE2+E3\n🟠 P1/P2]]
  G -->|Non| N[[Cas 6\nE2 seul\n🟡 P2/P3]]

  H -->|Oui| O[[Cas 7\nE3 seul\n🟡 P3 Tuning]]
  H -->|Non| P[[Cas 8\nAucun signal\n-]]

  I --> Q([Actions: isoler, collecter, bloquer, reset creds])
  J --> R([Actions: proxy/DNS, monitor 30–60 min])
  K --> S([Actions: réputation, parent, artefacts])
  M --> T([Actions: identifier process, signature, persistence])
```

---

## 🔎 Table de Décision

| Cas | E1 | E2 | E3 | Niveau de confiance | Interprétation SOC | Priorité | Actions recommandées |
|-----|----|----|----|--------------------|-------------------|----------|---------------------|
| 1 | ✅ | ✅ | ✅ | 🔴 Très élevée | Chaîne complète typique d’infostealer (exec → vol creds → exfil) | P1 | Isoler la machine, collecter process tree & hash, bloquer IP/domain, reset credentials navigateur/SSO |
| 2 | ✅ | ✅ | ❌ | 🟠 Élevée | Vol d’identifiants probable, exfil non observée ou bloquée | P1/P2 | Vérifier proxy/DNS, surveiller E3 |
| 3 | ✅ | ❌ | ✅ | 🟡 Moyenne | Loader ou downloader possible | P2 | Valider destination, vérifier parent process |
| 4 | ❌ | ✅ | ✅ | 🟠 Moyenne à élevée | Accès creds + exfil, outil potentiellement furtif | P1/P2 | Identifier processus, hunting persistence |
| 5 | ✅ | ❌ | ❌ | 🟡 Faible à moyenne | Suspicious LOLBin seul | P3 | Triage rapide |
| 6 | ❌ | ✅ | ❌ | 🟡 Moyenne | Accès aux stores sans exfil visible | P2/P3 | Vérifier password managers / EDR |
| 7 | ❌ | ❌ | ✅ | 🟡 Faible à moyenne | Egress LOLBin isolé | P3 | Valider réputation IP/domain |
| 8 | ❌ | ❌ | ❌ |, | Aucun signal |, |, |

---

_Generated on: 2026-02-16 17:11:37 UTC_
