<!-- Badges (edit the links if you rename the repo/branch) -->
![Sigma](https://img.shields.io/badge/Sigma-rules-blue)
![SOC](https://img.shields.io/badge/SOC-ready-success)
![SOAR](https://img.shields.io/badge/SOAR-playbooks-important)
![MITRE](https://img.shields.io/badge/MITRE-ATT%26CK-lightgrey)
![License](https://img.shields.io/badge/License-MIT-informational)
 **English version available here:** [README.md](README.md)

# SOC Detection to Response - Operational Flow Diagram

---

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
![SOC Framework](sigma_rules_global_soc_workflow_3D_FR.png)
