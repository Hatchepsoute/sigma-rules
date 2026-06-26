![Status](https://img.shields.io/badge/status-experimental-orange?style=flat-square)
![Campaign](https://img.shields.io/badge/Campaign-UNC3886-red?style=flat-square)
![MITRE](https://img.shields.io/badge/MITRE-T1190%20%7C%20T1059%20%7C%20T1070.004%20%7C%20T1562.001-red?style=flat-square)
![Rules](https://img.shields.io/badge/rules-2%20(BROAD%20%2B%20STRICT)-blue?style=flat-square)
![Level](https://img.shields.io/badge/level-medium%20%2F%20high-yellow?style=flat-square)
![Author](https://img.shields.io/badge/author-ASSIONGBON%20Adama-purple?style=flat-square)

# 🛡️ Sigma Rules : UNC3886 | Campagne réseau & virtualisation

👉🏾 [English version available here](README.md)

> Note lab et SIEM : /labs contient uniquement des PoC bénins en local et des logs synthétiques. Valider la normalisation des champs avant déploiement ; ces détections supposent un mapping des champs Sysmon, Security, proxy, DNS ou web selon le pack.

En un coup d'oeil

- Menace : activité de type UNC3886 contre des appliances réseau de sécurité et des infrastructures de virtualisation
- Focus de détection : BROAD pour le sondage externe des surfaces d'administration, STRICT pour les comportements post-exploitation sur l'hôte/appliance
- Artefacts SOC : `playbook/`, `decision-table/`, `diagrams/`, `labs/`
- Fichiers de règles :
  - [`unc3886_management_probe_broad.yml`](./rules/unc3886_management_probe_broad.yml)
  - [`unc3886_appliance_log_tamper_strict.yml`](./rules/unc3886_appliance_log_tamper_strict.yml)

## Résumé de la détection

UNC3886 a été publiquement associé à des intrusions de longue durée contre des infrastructures critiques, notamment des environnements virtualisés, des routeurs et des secteurs télécoms. Ce pack transforme ce profil de campagne en deux règles utiles au SOC : une règle d'exposition et une règle de comportement post-compromission.

## Pourquoi deux règles

| Règle | Objectif | Signal typique |
| --- | --- | --- |
| BROAD | Alerte précoce | Sondage externe des surfaces d'admin avec clients de type automatisation |
| STRICT | Haute confiance | Shelling, tampering des logs ou persistance sur l'appliance |

## Journaux à privilégier

- Reverse proxy, WAF ou pare-feu avec URL, méthode, IP source et user agent
- Journaux de création de processus Linux sur les routeurs, hyperviseurs ou appliances
- Syslog ou EDR exposant `ParentImage`, `Image`, `CommandLine` et le contexte de service

> Note : les noms de champs varient selon le SIEM et le parser. Mapper `Url`, `HttpMethod`, `UserAgent`, `SourceIp`, `ParentImage`, `Image` et `CommandLine` avant le passage en production.

## Références

- https://www.cve.org/CVERecord?id=CVE-2023-20867
- https://www.cve.org/CVERecord?id=CVE-2023-34048
- https://www.techradar.com/pro/security/singapore-says-its-four-largest-phone-companies-were-hit-by-chinese-hackers
