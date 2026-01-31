<!-- Badges -->
![Sigma](https://img.shields.io/badge/Sigma-rules-blue)
![SOC](https://img.shields.io/badge/SOC-ready-success)
![SOAR](https://img.shields.io/badge/SOAR-playbooks-important)
![MITRE](https://img.shields.io/badge/MITRE-ATT%26CK-lightgrey)
![License](https://img.shields.io/badge/License-Apache%202.0-informational)

👉🏾 **English version available here:** [README.md](README.md)

# 🛡️ Framework Sigma de Détection pour les SOC

![SOC Framework](diagrams/sigma_rules_vue_globale_soc_3D_FR.png)

## Sigma Rules – Framework de Detection Engineering SOC

Ce dépôt fournit un **framework de Detection Engineering SOC orienté production**
basé sur des règles Sigma, une approche CTI et des campagnes réelles observées sur le terrain.

---

## Philosophie de détection

Ce projet ne repose pas uniquement sur des indicateurs statiques (hashs, noms de fichiers, IP).
La logique de détection suit une approche multicouche et résiliente :

- **Règles BROAD** pour la visibilité et le threat hunting
- **Règles STRICT** pour la confirmation et l’alerte à forte confiance
- **Détections comportementales** résistantes au renommage
- **Invariants réseau** pour les équipements et appliances sans EDR
- **Logique de corrélation** pour confirmer et contextualiser les incidents

Chaque pack de détection CVE est documenté dans son propre répertoire et inclut
les règles Sigma, les tables de décision et les playbooks SOC.

> La détection ne doit pas casser lorsque l’attaquant renomme ses fichiers.

---

## Détection orientée campagne

Au-delà des détections centrées sur les CVE, ce dépôt inclut des
**packs de détection orientés campagne**, basés sur des attaques réelles.

Ces packs couvrent :
- L’ensemble du cycle d’attaque
- Les payloads renommés ou évolutifs (v2 / v3)
- Les invariants réseau et comportementaux
- Des tables de décision et playbooks exploitables en SOC

### Exemples
- Exploitation FortiWeb avec Sliver C2 et masquage de proxy
- Packs de détection orientés vulnérabilités (CVE), conçus pour l’anticipation SOC   et le suivi de l’exploitation post-publication :
  - Vulnérabilités Windows Kernel / Graphics / Userland (Patch Tuesday)
  - Vulnérabilités Microsoft Office
  - Vulnérabilités WinRAR
  - Vulnérabilités Azure Monitor Agent
  - Vulnérabilités Microsoft Copilot

Les packs CVE visent à anticiper la phase de **weaponization**
à l’aide de règles BROAD et STRICT combinées à des artefacts SOC
(tables de décision, playbooks, diagrammes).

---

## Intégration SOC & SOAR

Les règles sont conçues pour des SOC de production et peuvent être intégrées avec :
- Des SIEM (Elastic, OpenSearch, Splunk, Sentinel, QRadar)
- Des plateformes SOAR comme **TheHive**, Cortex et Shuffle

---

## Structure du dépôt

Chaque pack de détection suit une structure cohérente et réutilisable :
- Règles Sigma
- Tables de décision
- Playbooks
- Diagrammes

---

## Licence

Ce projet est distribué sous licence **Apache 2.0**.
- Texte officiel de la licence : https://www.apache.org/licenses/LICENSE-2.0
- Copie dans le dépôt : [LICENSE](LICENSE)

Les règles Sigma peuvent être utilisées, modifiées et redistribuées, y compris dans un cadre commercial (SOC, MSSP, éditeurs SIEM), sous réserve de mentionner l’auteur.
---
**Auteur :** Adama ASSIONGBON – SOC & CTI Consultant  
[LinkedIn Profile](https://www.linkedin.com/in/adama-assiongbon-9029893a/)



