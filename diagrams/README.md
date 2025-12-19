<!-- Badges (edit the links if you rename the repo/branch) -->
![Sigma](https://img.shields.io/badge/Sigma-rules-blue)
![SOC](https://img.shields.io/badge/SOC-ready-success)
![SOAR](https://img.shields.io/badge/SOAR-playbooks-important)
![MITRE](https://img.shields.io/badge/MITRE-ATT%26CK-lightgrey)
![License](https://img.shields.io/badge/License-MIT-informational)


# SOC Detection to Response - Operational Flow Diagram

---

## 🇫🇷 Version Française

### 📌 Description

Ce diagramme illustre le **cycle opérationnel complet de détection et de réponse SOC**, depuis le contexte de menace (Threat Intelligence / CVE) jusqu’au retour d’expérience post-incident.

Il représente une **chaîne réaliste Blue Team / SOC**, intégrant :
- SIEM
- règles Sigma (Hunting & Production)
- Triage SOC N1/N2
- SOAR et gestion d’incident
- Amélioration continue des règles et du durcissement

Ce flux est volontairement générique afin d’être **agnostique de l’outil** (Wazuh, Splunk, Elastic, OpenSearch, Sentinel, etc.).

---

### 🧠 Lecture du diagramme

1. **Contexte de la menace / CVE**  
   Sources externes : avis de sécurité, expositions, CTI, bulletins éditeurs.

2. **Télémétrie**  
   Collecte des logs et événements :
   - Postes de travail
   - Serveurs
   - Réseau
   - Cloud

3. **Ingestion & normalisation SIEM**  
   - Parsing  
   - Enrichissement  
   - Corrélation  

4. **Règles Sigma**  
   - **BROAD / BROADPLUS** : hunting, détection large  
   - **STRICT** : détection production à faible bruit  

5. **Alerte générée**  
   L’alerte contient :
   - Gravité  
   - Contexte  
   - Preuves techniques  

6. **Triage SOC N1 / N2**  
   - Validation  
   - Délimitation du périmètre  
   - Évaluation de l’impact  

7. **Décision**
   - **Faux positif** → Clôture + tuning (réduction du bruit)
   - **Vrai positif** → Gestion d’incident

8. **Gestion des incidents**  
   - TheHive  
   - Outils de ticketing  

9. **Playbook SOAR**  
   Actions automatisées ou semi-automatisées :
   - Enrichissement
   - Confinement
   - Notification

10. **Actions de remédiation**
    - Blocage des IoCs
    - Isolation de l’hôte
    - Réinitialisation des identifiants
    - Correction de la vulnérabilité

11. **Post-Incident**
    - Leçons retenues
    - Mise à jour des règles
    - Renforcement de la posture de sécurité

👉 La boucle de retour illustre l’**amélioration continue du SOC**.

---

### 🎯 Objectifs du diagramme

- Support pédagogique SOC / Blue Team
- Documentation d’architecture SOC
- Présentation client ou management
- Base de travail pour playbooks SOAR
- Standardisation des workflows SOC

---

## 🇬🇧 English Version

### 📌 Description

This diagram illustrates the **end-to-end SOC detection and response lifecycle**, from threat and CVE context to post-incident feedback and continuous improvement.

It represents a **real-world Blue Team / SOC workflow**, integrating:
- SIEM
- Sigma rules (Hunting & Production)
- SOC L1/L2 triage
- SOAR and incident management
- Continuous tuning and hardening

The flow is intentionally **tool-agnostic**, suitable for Wazuh, Splunk, Elastic, OpenSearch, Sentinel, and similar platforms.

---

### 🧠 Diagram Walkthrough

1. **Threat / CVE Context**  
   External sources: advisories, exposure data, CTI feeds, vendor bulletins.

2. **Telemetry**  
   Event and log collection from:
   - Endpoints
   - Servers
   - Network
   - Cloud

3. **SIEM Ingestion & Normalization**
   - Parsing  
   - Enrichment  
   - Correlation  

4. **Sigma Rules**
   - **BROAD / BROADPLUS**: hunting and wide detection
   - **STRICT**: low-noise production detection

5. **Alert Generated**
   Alerts include:
   - Severity
   - Context
   - Technical evidence

6. **SOC Triage L1 / L2**
   - Validation
   - Scoping
   - Impact assessment

7. **Decision**
   - **False Positive** → Close & tune (noise reduction)
   - **True Positive** → Incident management

8. **Incident Management**
   - TheHive
   - Ticketing systems

9. **SOAR Playbook**
   Automated or semi-automated actions:
   - Enrichment
   - Containment
   - Notification

10. **Response Actions**
    - Block IoCs
    - Isolate host
    - Reset credentials
    - Patch vulnerability

11. **Post-Incident**
    - Lessons learned
    - Rule updates
    - Security hardening

👉 The feedback loop highlights **continuous SOC improvement**.

---

### 🎯 Diagram Purpose

- SOC / Blue Team training
- SOC architecture documentation
- Client and management presentations
- SOAR playbook design
- SOC workflow standardization

---

🛡️ **Maintained as part of the `sigma-rules` project**

