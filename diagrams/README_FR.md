<!-- Badges -->
![Sigma](https://img.shields.io/badge/Sigma-rules-blue)
![SOC](https://img.shields.io/badge/SOC-ready-success)
![SOAR](https://img.shields.io/badge/SOAR-playbooks-important)
![MITRE](https://img.shields.io/badge/MITRE-ATT%26CK-lightgrey)
![License](https://img.shields.io/badge/License-MIT-informational)

# Sigma-Rules – Philosophie d’ingénierie de détection
👉🏾 [English version available here](README.md)



**Menace → Detecter → Repondre → Ameliorer**

Ce diagramme represente la philosophie operationnelle du projet **sigma-rules**.

Ce dépôt n'est pas une simple collection de règles Sigma. Il s agit d un framework structure d'ingénierie de détection conçu pour des environnements SOC réels.

---

## Philosophie fondamentale

Le projet repose sur cinq principes :

1. **Ingenierie pilotée par la menace**  
   Les CVE, campagnes réelles, tendances d'exploitation et analyses CTI sont le point de départ.

2. **Strategie de détection en couches**  
   - Règles **BROAD** pour la visibilité et le hunting  
   - Règles **STRICT** pour des alertes production a forte confiance  

3. **Prêt pour l'opérationnel**  
   Tables décisionnelles, aide au triage et playbooks de réponse inclus.

4. **Intégration de l'automatisation**  
   Conçu pour fonctionner avec SIEM et SOAR (TheHive, Elastic, OpenSearch, Splunk, Sentinel etc).

5. **Amélioration continue**  
   Boucle de feedback pour le tuning, la réduction du bruit et l'augmentation de la maturité.

---

## Diagramme du framework exécutive

```mermaid
flowchart LR

A["MENACE<br/>CVE - Ransomware - Exploits - TTPs<br/>Surface d attaque reelle"]

B["DETECTER<br/>Regles Sigma BROAD et STRICT<br/>Detection comportementale et correlation<br/>Integration SIEM"]

C["REPONDRE<br/>Tables decisionnelles - Playbooks - TheHive<br/>Confinement - Investigation - Remediation"]

D["AMELIORER<br/>Tuning - Durcissement - Versioning<br/>Maturite de detection en hausse"]

A --> B
B --> C
C --> D
D --> B

classDef menace fill:#0b1220,stroke:#334155,color:#e2e8f0;
classDef detect fill:#0b2a1a,stroke:#10b981,color:#ecfdf5;
classDef respond fill:#2a0b0b,stroke:#ef4444,color:#fff1f2;
classDef improve fill:#1f2937,stroke:#a3e635,color:#ecfccb;

class A menace;
class B detect;
class C respond;
class D improve;
```

---

## Valeur opérationnelle

- Reduction du MTTD  
- Reduction du MTTR  
- Standardisation des workflows SOC  
- Maturite de detection mesurable  
- Modele d ingenierie reproductible  

---

Maintenu dans le cadre du projet d'ingénierie de détection **sigma-rules**

## ✍🏿 Auteur

[Adama ASSIONGBON – Consultant SOC & CTI ](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

