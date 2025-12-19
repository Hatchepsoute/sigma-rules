# 📊 CVE – Global Diagrams

This directory contains **high-level, generic diagrams** illustrating how
CVE-based detections are handled across a Security Operations Center (SOC).

These diagrams are **not specific to a single vulnerability**.
They describe the **global methodology** used for detection, analysis, and response,
which is then adapted inside each individual CVE pack.

CVE-specific attack flows and exploitation chains are documented inside:
`CVE/<CVE-ID>/diagrams/`

---

## 🧩 Diagrams Overview (EN)

### 01 – CVE Detection to Response Flow
This diagram illustrates the **end-to-end lifecycle of a CVE** in a SOC environment:
- CVE publication
- Asset exposure
- Sigma rule detection
- SIEM alert generation
- SOC triage
- SOAR playbook execution
- Containment, remediation, and lessons learned

Purpose:
- Explain how a vulnerability becomes an actionable security incident
- Standardize SOC response across all CVE packs

---

### 02 – Sigma to SOAR Global Workflow
This diagram explains the **technical workflow** between detection and response tools:
- Log sources and endpoints
- SIEM ingestion
- Sigma rule execution
- Alert creation
- Case management (TheHive)
- SOAR orchestration (Shuffle / TheHive responders)

Purpose:
- Clarify the role of Sigma vs SOAR
- Show how automation supports SOC analysts, not replaces them

---

### 03 – MITRE ATT&CK × CVE Response Model
This diagram maps **CVE exploitation paths** to:
- MITRE ATT&CK tactics and techniques
- Detection opportunities (Sigma)
- Response actions (SOAR)

Purpose:
- Demonstrate ATT&CK-aligned detection
- Link vulnerabilities to real adversary behavior
- Support threat-informed defense and Purple Teaming

---

## 🛡️ Scope
These diagrams apply to:
- All CVE packs in this repository
- Any Sigma-compatible SIEM
- Any SOAR platform with case management and orchestration capabilities

---

---

# 📊 CVE – Diagrammes globaux

Ce répertoire contient des **diagrammes génériques de haut niveau** décrivant
la manière dont les vulnérabilités CVE sont prises en charge dans un SOC.

Ces diagrammes **ne sont pas liés à une CVE spécifique**.
Ils décrivent la **méthodologie globale de détection, d’analyse et de réponse**,
qui est ensuite déclinée dans chaque pack CVE.

Les diagrammes spécifiques à une vulnérabilité se trouvent dans :
`CVE/<ID-CVE>/diagrams/`

---

## 🧩 Vue d’ensemble des diagrammes (FR)

### 01 – Flux CVE : Détection → Réponse
Ce diagramme présente le **cycle de vie complet d’une CVE** dans un SOC :
- Publication de la CVE
- Exposition des actifs
- Détection via règles Sigma
- Génération d’alertes SIEM
- Qualification SOC
- Exécution de playbooks SOAR
- Contention, remédiation et amélioration continue

Objectif :
- Montrer comment une vulnérabilité devient un incident de sécurité
- Uniformiser la réponse SOC pour toutes les CVE

---

### 02 – Workflow global Sigma → SOAR
Ce diagramme explique le **flux technique** entre les outils de détection et de réponse :
- Sources de logs / endpoints
- Ingestion SIEM
- Déclenchement des règles Sigma
- Création d’alertes
- Gestion de cas (TheHive)
- Orchestration SOAR (Shuffle / responders)

Objectif :
- Clarifier le rôle de Sigma et du SOAR
- Montrer comment l’automatisation assiste l’analyste SOC

---

### 03 – Modèle CVE × MITRE ATT&CK
Ce diagramme établit un lien entre :
- l’exploitation d’une CVE
- les tactiques et techniques MITRE ATT&CK
- les points de détection (Sigma)
- les actions de réponse (SOAR)

Objectif :
- Aligner la détection sur MITRE ATT&CK
- Relier vulnérabilités et comportements adverses
- Faciliter le Threat-Informed Defense et le Purple Team

---

## 🛡️ Périmètre
Ces diagrammes s’appliquent :
- à tous les packs CVE du dépôt
- à tout SIEM compatible Sigma
- à toute plateforme SOAR disposant de capacités d’orchestration et de gestion d’incidents

---

