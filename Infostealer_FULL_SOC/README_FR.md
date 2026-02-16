![Sigma](https://img.shields.io/badge/Format-SIGMA-orange)
![Validation](https://img.shields.io/badge/Sigma_Check-Passed-green)
![Incident Response](https://img.shields.io/badge/IR-TheHive_Playbook-red)
![Infostealer](https://img.shields.io/badge/Infostealer-red)

# Infostealer FULL SOC Package – STRICT  & STRICT Correlated
 [👉🏾  **English version available here**](README.md)
 
Ce document explique le comportement de détection du framework Infostealer STRICT.

STRICT fournit une détection monolithique à haute confiance lorsque l’exécution, l’accès aux identifiants et l’exfiltration sont observés simultanément.

STRICT_Correlated fournit un modèle de détection corrélé par étapes, permettant aux analystes SOC de valider progressivement une activité infostealer via l’exécution, le vol d’identifiants et l’exfiltration réseau.

Les deux approches sont complémentaires et conçues pour un SOC en production.
```text
Infostealers_FULL_SOC/
.
├── Infostealer_STRICT
│   ├── decision-table
│   │   ├── Decision_Table_Infostealer_STRICT_EN.md
│   │   ├── Decision_Table_Infostealer_STRICT_FR.md
│   │   └── README.md
│   ├── diagrams
│   │   ├── DIAGRAM_INFOSTEALER_STRICT_HIGH_CONFIDENCE_EN.mmd
│   │   ├── DIAGRAM_INFOSTEALER_STRICT_HIGH_CONFIDENCE_FR.mmd
│   │   ├── README_FR.md
│   │   └── README.md
│   ├── Infostealer_STRICT_v2_MITRE_ATT&CK_Navigator.json
│   ├── playbook
│   │   ├── TheHive_Playbook_Infostealer_STRICT_EN.yml
│   │   └── TheHive_Playbook_Infostealer_STRICT_FR.yml
│   ├── README_FR.md
│   ├── README.md
│   └── rules
│       └── infostealer_STRICT_credential_access_and_exfiltration.yml
├── Infostealer_STRICT_Correlated
│   ├── correlation
│   │   ├── infostealer_strict_v2_elastic_eql_sequence.eql
│   │   └── infostealer_strict_v2_opensearch_pivot.md
│   ├── decision-table
│   │   ├── README_FR.md
│   │   └── README.md
│   ├── diagrams
│   │   ├── README_FR.md
│   │   └── README.md
│   ├── Infostealer_STRICT_v2_KillChain.png
│   ├── playbook
│   │   ├── TheHive_Playbook_Infostealer_STRICT_v2_EN.yml
│   │   └── TheHive_Playbook_Infostealer_STRICT_v2_FR.yml
│   ├── README_FR.md
│   ├── README.md
│   └── rules
│       ├── infostealer_STRICTv2_step1_suspicious_exec.yml
│       ├── infostealer_STRICTv2_step2_browser_cred_access.yml
│       └── infostealer_STRICTv2_step3_public_egress.yml
├── README_FR.md
└── README.md
```
