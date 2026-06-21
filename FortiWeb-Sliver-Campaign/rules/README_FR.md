![Threat Intelligence](https://img.shields.io/badge/Focus-CTI%20%26%20SOC-blue)
![Sigma](https://img.shields.io/badge/Format-SIGMA-orange)
![License](https://img.shields.io/badge/License-MIT-green)
![Fortinet](https://img.shields.io/badge/Fortinet-FortiWeb-red)

# 📂 Index des Règles de Détection (Sigma)
👉🏾 [English version available here](README.md)


Ce répertoire contient la logique de détection cœur pour la campagne **Sliver C2 ciblant FortiWeb**. Ces règles sont au format **Sigma**, permettant un déploiement sur n'importe quel SIEM (Splunk, Sentinel, ELK, etc.).

## 📋 Inventaire des Détections

| Nom du Fichier | Focus de Détection | Gravité |
| :--- | :--- | :--- |
| [lnx_sliver_implant_deployment.yml](./lnx_sliver_implant_deployment.yml) | Dépôt du binaire initial dans des répertoires cachés (`/.root/`). | Critique |
| [persist_lnx_sliver_systemd_service.yml](./persist_lnx_sliver_systemd_service.yml) | Création de persistance via un service système factice. | Élevée |
| [proc_lnx_microsocks_lpd_masquerade.yml](./proc_lnx_microsocks_lpd_masquerade.yml)| Masquage de processus (Microsocks lancé en tant que `cups-lpd`). | Élevée |
| [lnx_frp_reverse_proxy_activity.yml ](./lnx_frp_reverse_proxy_activity.yml) | Utilisation de FRP pour le tunneling et l'accès distant. | Moyenne |
| [lnx_lpd_listener_printer_service_masquerade.yml](./lnx_lpd_listener_printer_service_masquerade.yml) | Écoute réseau non autorisée sur le port TCP 515 (LPD). | Élevée |

## 🔍 Détails Techniques

### 1. Phase d'Implantation et de Persistance
* **Cible :** Installation du framework Sliver.
* **Stratégie :** Surveillance des événements de fichiers. Nous ne nous fions pas aux hashs, mais aux anomalies structurelles (répertoires cachés sur une appliance) et aux métadonnées (descriptions de services "Updater Service").

### 2. Phase de Command & Control (C2) et Evasion
* **Masquage Processus :** Détection des arguments spécifiques (`-p 515`, `-1`, `-w`) utilisés par `microsocks`, même si le binaire est renommé.
* **Anomalie Réseau :** Surveillance du port d'impression (515). Tout trafic sortant de ce port qui ne provient pas d'un démon CUPS légitime est considéré comme un tunnel C2 actif.

## 🛠️ Validation et Conversion
Toutes les règles de ce dossier ont été validées avec `sigma-cli`.

**Pour convertir ces règles :**
1. **Localement :** Utilisez le script `./scripts/convert_all_rules.sh` à la racine du projet.
2. **En ligne :** Copiez le contenu YAML dans [Uncoder.io](https://uncoder.io).

## 🛡️ Résilience (Payloads V2)
Ces règles sont conçues pour être **comportementales**. En ciblant les arguments de commande, les ports réseau et les chemins d'exécution plutôt que de simples hashs, elles restent efficaces même si l'attaquant modifie ses outils ou renomme ses fichiers.

## ✍🏿 Auteur
[Adama ASSIONGBON – Consultant SOC & CTI](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

