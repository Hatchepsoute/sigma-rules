![Sigma](https://img.shields.io/badge/Format-SIGMA-orange)
![Validation](https://img.shields.io/badge/Sigma_Check-Passed-green)
![Incident Response](https://img.shields.io/badge/IR-Playbook_TheHive-red)
![Fortinet](https://img.shields.io/badge/Fortinet-FortiWeb-red)

# 🛡️ Détection de la Campagne Sliver C2 sur FortiWeb
[👉🏾 English version available here: ](./README.md)

## 📝 Présentation
Ce dépôt fournit un arsenal complet (règles Sigma, IoCs et Playbooks) conçu pour contrer les attaques sophistiquées ciblant les appliances **FortiWeb**. Il permet d'industrialiser la détection du framework **Sliver C2** et des techniques de masquage réseau.

## 🚀 Points Forts
- 🔍 **Détection Multi-étapes** : Couverture totale (dépôt de fichier, persistance, listeners et tunneling).
- 🛡️ **Anti-Évasion** : Logique de détection comportementale pour démasquer les outils renommés.
- ⚖️ **Réponse aux Incidents** : Intégration de playbooks **TheHive** et d'une matrice de décision SOC.
- ⚙️ **Qualité Gate** : Validation syntaxique confirmée via `sigma-cli`.

## 🔍 Analyse Technique des Règles (Résumé)
Cinq règles spécialisées couvrent le cycle de vie de l'attaque :
1.  **Déploiement de l'implant** ([lnx_sliver_implant_deployment.yml](./rules/lnx_sliver_implant_deployment.yml)) : Surveillance des répertoires suspects (`/.root/`, `/app/web/`).
2.  **Persistance Systemd** ([persist_lnx_sliver_systemd_service.yml](./rules/persist_lnx_sliver_systemd_service.yml) ) : Détection du service malveillant "Updater Service".
3.  **Masquage de Proxy** ( [proc_lnx_microsocks_lpd_masquerade.yml](./rules/proc_lnx_microsocks_lpd_masquerade.yml)) : Identification des arguments `microsocks` camouflés en `cups-lpd`.
4.  **Tunneling FRP** ( [lnx_frp_reverse_proxy_activity.yml ](./rules/lnx_frp_reverse_proxy_activity.yml) ) : Surveillance de l'activité du client `frpc` et ses fichiers de conf.
5.  **Écoute Réseau Suspecte** ([lnx_lpd_listener_printer_service_masquerade.yml](./rules/lnx_lpd_listener_printer_service_masquerade.yml)) : Détection de listeners non-CUPS sur le **port TCP 515**.
## 🛡️ Résilience et Anticipation
Ces règles anticipent les évolutions de l'attaque (**Payloads V2**) en privilégiant les **comportements** (arguments CLI et ports réseau) plutôt que les noms de fichiers statiques ou les hashs. La surveillance du port 515 et des chemins cachés garantit la détection même si l'attaquant change ses outils.

## ⚖️ Aide à la Décision et Réponse (IR)
* **Table de Décision** : Située dans `/decision-table/`, elle guide le triage rapide.
* **TheHive Playbook** : Utilisez `TheHive_Playbook_Sliver_FortiWeb.yml` pour automatiser vos investigations.

## 🛠️ Guide d'Utilisation

### 1. Validation et Conversion ⚙️
* **Option A : Automatisation Locale (Recommandé)**
    * Exécutez `./scripts/validate_all_rules.sh` pour valider la qualité.
    * Exécutez `./scripts/convert_all_rules.sh` pour générer les requêtes SIEM (Splunk, Sentinel, etc.).
* **Option B : Validation en Ligne (Test Rapide)**
    * Utilisez [**Uncoder.io**](https://uncoder.io/) pour une conversion rapide par copier-coller.

### 2. Intégration des IoCs
* Importez `artifacts/iocs.csv` dans vos tables de correspondance (Lookups) SIEM.

## 📁 Repository Structure
```text
├── rules/      # Les 5 règles de détection
│   ├── lnx_sliver_implant_deployment.yml
│   ├── lnx_sliver_persistence_systemd.yml
│   ├── lnx_microsocks_masqueraded_lpd.yml
│   ├── lnx_lpd_listener_printer_service_masquerade.yml 
│   └── lnx_frp_reverse_proxy_activity.yml
├── artifacts/      # Liste des IoCs (TXT/CSV)
│   ├── iocs.txt
│   └── iocs.csv
├── decision-table/         # Playbooks IR, Mapping TheHive et Matrice de décision
│    ├── Decision_Table_Sliver_SOC.xlsx
│    ├── TheHive_Decision_Mapping.yml
│    ├── TheHive_Playbook_Sliver_FortiWeb.yml
│    └── Sliver_KillChain_Detection.png
├── README_FR.md
└── README.md 
```

## ✍🏿 Auteur
[Adama ASSIONGBON – Consultant SOC & CTI](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

