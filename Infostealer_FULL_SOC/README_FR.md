# Infostealer FULL SOC Package – STRICT  & STRICT Correlated

Ce document explique le comportement de détection du framework Infostealer STRICT.

STRICT fournit une détection monolithique à haute confiance lorsque l’exécution, l’accès aux identifiants et l’exfiltration sont observés simultanément.

STRICT_Correlated fournit un modèle de détection corrélé par étapes, permettant aux analystes SOC de valider progressivement une activité infostealer via l’exécution, le vol d’identifiants et l’exfiltration réseau.

Les deux approches sont complémentaires et conçues pour un SOC en production.

Infostealers/
├── Infostealer_STRICT/
│   ├── rules/
│   ├── decision-table/
│   ├── playbook/
│   ├── README.md
│   └── README_FR.md
│
├── Infostealer_STRICT_Correlated/
│   ├── rules/
│   ├── correlation/
│   ├── decision-table/
│   ├── playbook/
│   ├── README.md
│   └── README_FR.md

