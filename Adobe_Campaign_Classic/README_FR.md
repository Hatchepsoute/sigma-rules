# Détection de l'exécution côté serveur Adobe Campaign Classic

[English version](./README.md)

## En un coup d'œil

| Élément | Valeur |
| :--- | :--- |
| Produit | Adobe Campaign Classic v7, installations on-premise et composants on-premise des déploiements hybrides |
| Contexte de sécurité | APSB26-142 contient plusieurs failles critiques d'exécution de code ; CVE-2026-75703 est associée par Adobe à un déni de service applicatif |
| Correctif | Mettre à niveau les systèmes Campaign Classic v7 affectés vers la version 7.4.4 build 9402 ou ultérieure |
| Règle Windows | [`rules/windows_adobe_campaign_web_suspicious_child_process_strict.yml`](./rules/windows_adobe_campaign_web_suspicious_child_process_strict.yml), création de processus Windows |
| Règle Linux | [`rules/linux_adobe_campaign_web_suspicious_child_process_strict.yml`](./rules/linux_adobe_campaign_web_suspicious_child_process_strict.yml), création de processus Linux |

## La menace

Adobe Campaign Classic est une plateforme marketing d'entreprise dont le module `nlserver web` traite le trafic applicatif, la console, les rapports et l'API SOAP. Le bulletin Adobe APSB26-142 corrige plusieurs vulnérabilités critiques dans Campaign Classic v7 build 9401 et antérieurs, notamment des injections de code et de commandes, des défauts d'autorisation, des injections SQL et des failles de type Server-Side Request Forgery. Adobe indique que les instances hébergées ont été corrigées, tandis que les composants on-premise et hybrides on-premise doivent être mis à niveau vers le build 9402. Les informations publiques ne révèlent aucun motif de requête fiable pour CVE-2026-75703 ; ce pack détecte donc l'exécution de processus côté serveur sans prétendre attribuer l'alerte à un exploit précis.

## L'attaque et ce que les règles détectent

1. Un attaquant ou un opérateur non autorisé atteint le serveur applicatif Campaign. Aucune règle de ce pack ne déclenche, car Adobe n'a publié aucun endpoint ou payload malveillant stable.
2. Si le processus Windows `nlserver.exe web` lance un shell, un interpréteur de scripts, un binaire sélectionné d'exécution par proxy ou d'exécution différée, ou un exécutable depuis un répertoire temporaire, [`rules/windows_adobe_campaign_web_suspicious_child_process_strict.yml`](./rules/windows_adobe_campaign_web_suspicious_child_process_strict.yml) déclenche. Les utilitaires de transfert nécessitent un marqueur de téléchargement ou d'URL, ce qui évite d'alerter sur un processus enfant sans rapport contenant seulement une URL.
3. Si le processus Linux `nlserver web` lance un shell, un interpréteur de scripts, un utilitaire sélectionné d'exécution différée ou un exécutable depuis un répertoire temporaire, [`rules/linux_adobe_campaign_web_suspicious_child_process_strict.yml`](./rules/linux_adobe_campaign_web_suspicious_child_process_strict.yml) déclenche. Les utilitaires de transfert nécessitent de la même manière un marqueur de téléchargement ou d'URL.
4. Une exécution de code dans le processus, un crash sans création de processus enfant, un enfant renommé hors des chemins temporaires avec une ligne de commande anodine ou l'absence de télémétrie parentale restent hors de la visibilité de ce pack.

| Critère | Absence de règle initiale | Règle STRICT Windows proposée | Règle STRICT Linux proposée |
| :--- | :--- | :--- | :--- |
| **Détecte le comportement parent-enfant modélisé ?** | ❌ Non | ✅ Oui | ✅ Oui |
| **Taux de FP estimé** | Sans objet | Faible après liste d'autorisation propre à l'environnement | Faible après liste d'autorisation propre à l'environnement |
| **Logique clé** | Aucune couverture | `ParentImage=nlserver.exe` + module web + enfant d'exécution, exécution différée ou chemin temporaire | `ParentImage=/nlserver` + module web + enfant d'exécution, exécution différée ou chemin temporaire |

## Télémétrie requise

| Règle | Source de logs | Champs minimum |
| :--- | :--- | :--- |
| [`rules/windows_adobe_campaign_web_suspicious_child_process_strict.yml`](./rules/windows_adobe_campaign_web_suspicious_child_process_strict.yml) | Sysmon Event ID 1 ou télémétrie EDR Windows équivalente | `Computer`, `User`, `Image`, `CommandLine`, `ParentImage`, `ParentCommandLine`, identifiants de processus |
| [`rules/linux_adobe_campaign_web_suspicious_child_process_strict.yml`](./rules/linux_adobe_campaign_web_suspicious_child_process_strict.yml) | auditd, eBPF, Sysmon for Linux ou télémétrie EDR équivalente | `Computer`, `User`, `Image`, `CommandLine`, `ParentImage`, `ParentCommandLine`, identifiants de processus |

## Références

- https://helpx.adobe.com/security/products/campaign/apsb26-142.html
- https://experienceleague.adobe.com/en/docs/campaign-classic/using/monitoring-campaign-classic/updating-adobe-campaign/introduction
- https://experienceleague.adobe.com/en/docs/campaign-classic/using/monitoring-campaign-classic/production-procedures/log-files
- https://experienceleague.adobe.com/en/docs/campaign-classic/using/installing-campaign-classic/install-campaign-on-prem/installing-campaign-in-windows/installing-the-server
- https://attack.mitre.org/techniques/T1059/
- https://attack.mitre.org/techniques/T1105/
- https://attack.mitre.org/techniques/T1218/
