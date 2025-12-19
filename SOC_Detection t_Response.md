<!-- Badges (edit the links if you rename the repo/branch) -->
![Sigma](https://img.shields.io/badge/Sigma-rules-blue)
![SOC](https://img.shields.io/badge/SOC-ready-success)
![SOAR](https://img.shields.io/badge/SOAR-playbooks-important)
![MITRE](https://img.shields.io/badge/MITRE-ATT%26CK-lightgrey)
![License](https://img.shields.io/badge/License-MIT-informational)


# SOC Detection to Response – MITRE ATT&CK Mapping

---

## 🇫🇷 Version Française — Cartographie MITRE ATT&CK

### 🎯 Objectif du mapping

Cette section établit la **correspondance entre les étapes du diagramme SOC**
et les **tactiques & techniques MITRE ATT&CK** afin de :

- contextualiser les alertes Sigma
- améliorer le triage SOC N1/N2
- faciliter le threat hunting
- aligner détection, réponse et CTI

Le mapping est **générique** et applicable à plusieurs CVE et campagnes.

---

## 🧩 Mapping Diagramme SOC ↔ MITRE ATT&CK

### 1️⃣ Contexte Menace / CVE
**(Threat / CVE Context)**

| Tactique | Description |
|--------|-------------|
| Reconnaissance (TA0043) | Collecte d’informations sur la cible |
| Resource Development (TA0042) | Préparation d’outils / payloads |
| Initial Access (TA0001) | Exploitation de vulnérabilités |

📌 Sources : advisories CVE, CTI, bulletins éditeurs, OSINT.

---

### 2️⃣ Télémétrie
**(Endpoints · Servers · Network · Cloud)**

| Tactique | Techniques courantes |
|--------|---------------------|
| Initial Access | Exploit Public-Facing App (T1190) |
| Execution | Command and Scripting Interpreter (T1059) |
| Persistence | Registry Run Keys / Startup Folder (T1547) |

📌 Phase d’observation des traces techniques.

---

### 3️⃣ Ingestion & Normalisation SIEM

| Tactique | Usage SOC |
|--------|-----------|
| Defense Evasion (TA0005) | Détection d’obfuscation, contournement |
| Discovery (TA0007) | Corrélation des comportements |

📌 Étape clé pour la **détection comportementale**.

---

### 4️⃣ Règles Sigma
**(BROAD / BROADPLUS / STRICT)**

| Mode | MITRE ATT&CK |
|----|--------------|
| BROAD / BROADPLUS | Détection multi-tactiques (Hunting) |
| STRICT | Techniques spécifiques à forte confiance |

📌 Exemples :
- T1055 – Process Injection
- T1105 – Ingress Tool Transfer
- T1218 – Signed Binary Proxy Execution (LOLbins)

---

### 5️⃣ Alerte Générée

| Tactique | Indicateurs |
|--------|-------------|
| Any | Sévérité, contexte, preuves |

📌 L’alerte Sigma est **le point de jonction** entre SIEM et SOC.

---

### 6️⃣ Triage SOC N1 / N2

| Niveau | Rôle |
|------|------|
| N1 | Qualification MITRE (tactique/technique) |
| N2 | Chaînage ATT&CK (kill chain) |

📌 Validation de la **chaîne d’attaque**.

---

### 7️⃣ Faux Positif → Tuning

| Objectif | MITRE |
|--------|-------|
| Réduction du bruit | Amélioration de la couverture |

📌 Ajustement des règles sans perte de visibilité.

---

### 8️⃣ Vrai Positif → Gestion d’incident

| Tactique | Exemples |
|--------|----------|
| Lateral Movement (TA0008) | T1021 |
| Command and Control (TA0011) | T1071 |
| Exfiltration (TA0010) | T1041 |

📌 Cas documenté dans TheHive.

---

### 9️⃣ Playbook SOAR

| Action | MITRE |
|------|-------|
| Enrichissement | Mapping automatique ATT&CK |
| Containment | Limiter la progression |
| Notification | Coordination IR |

---

### 🔟 Actions de Réponse

| Action | Impact ATT&CK |
|------|---------------|
| Blocage IoCs | C2 / Exfiltration |
| Isolation hôte | Lateral Movement |
| Reset credentials | Credential Access |
| Patch | Initial Access |

---

### 1️⃣1️⃣ Post-Incident

| Phase | MITRE |
|----|-------|
| Lessons Learned | Amélioration de la couverture |
| Rule Update | Détection proactive |
| Hardening | Réduction de surface d’attaque |

📌 Boucle de **cyber résilience**.

---

## 🇬🇧 English Version — MITRE ATT&CK Mapping

### 🎯 Mapping Purpose

This section maps each SOC workflow step to **MITRE ATT&CK tactics and techniques** in order to:

- contextualize Sigma alerts
- support SOC L1/L2 triage
- enable threat hunting
- align detection, response, and CTI

---

## 🧩 SOC Diagram ↔ MITRE ATT&CK Mapping

### 1️⃣ Threat / CVE Context
- Reconnaissance (TA0043)
- Resource Development (TA0042)
- Initial Access (TA0001)

---

### 2️⃣ Telemetry Collection
- Exploit Public-Facing Application (T1190)
- Command and Scripting Interpreter (T1059)
- Startup Persistence (T1547)

---

### 3️⃣ SIEM Ingestion & Correlation
- Defense Evasion (TA0005)
- Discovery (TA0007)

---

### 4️⃣ Sigma Rules
- BROAD/BROADPLUS: multi-tactic hunting
- STRICT: high-confidence techniques  
Examples: T1055, T1105, T1218

---

### 5️⃣ Alert Generation
- Contextualized ATT&CK-based alerting

---

### 6️⃣ SOC Triage L1 / L2
- L1: technique identification
- L2: attack chain validation

---

### 7️⃣ False Positive → Tuning
- Coverage optimization

---

### 8️⃣ True Positive → Incident Management
- Lateral Movement (TA0008)
- C2 (TA0011)
- Exfiltration (TA0010)

---

### 9️⃣ SOAR Playbook
- Automated enrichment
- Containment
- Notification

---

### 🔟 Response Actions
- Block IoCs
- Isolate hosts
- Reset credentials
- Patch vulnerabilities

---

### 1️⃣1️⃣ Post-Incident
- Lessons learned
- Rule updates
- Security hardening

---

🛡️ **MITRE ATT&CK–aligned SOC workflow – sigma-rules project**

