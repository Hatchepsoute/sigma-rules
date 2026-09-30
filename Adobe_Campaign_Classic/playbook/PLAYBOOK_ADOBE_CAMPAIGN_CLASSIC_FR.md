# Playbook de réponse à un processus enfant suspect d'Adobe Campaign Classic

[English version](./PLAYBOOK_ADOBE_CAMPAIGN_CLASSIC_EN.md)

## Objectif

Fournir une réponse SOC reproductible lorsque le module `nlserver web` d'Adobe Campaign Classic lance un processus enfant suspect sous Windows ou Linux. L'alerte constitue un signal à haute confiance d'exécution côté serveur, mais elle ne prouve pas quelle vulnérabilité, quel compte ou quelle requête est à l'origine de l'activité.

## Périmètre

Ce playbook s'applique aux serveurs Adobe Campaign Classic v7 déployés on-premise ou comme composants on-premise d'environnements hybrides. Les instances hébergées par Adobe sont hors de la visibilité hôte du client. Les règles nécessitent une télémétrie de création de processus conservant l'image et la ligne de commande du parent.

## Déclencheurs d'alerte

- Sous Windows, `nlserver.exe web` lance un shell, un interpréteur de scripts, un binaire sélectionné d'exécution par proxy ou d'exécution différée, ou un exécutable depuis un répertoire temporaire.
- Sous Linux, `nlserver web` lance un shell, un interpréteur de scripts, un utilitaire sélectionné d'exécution différée ou un exécutable depuis un répertoire temporaire.
- Un utilitaire de transfert connu présente un marqueur de téléchargement ou d'URL, ou toute commande enfant contient un marqueur de commande encodée.

## Triage L1

1. Confirmer que `ParentImage` correspond au binaire Adobe Campaign `nlserver` installé et non à un exécutable sans rapport qui aurait été renommé.
2. Confirmer que `ParentCommandLine` identifie le module `web`, et non `wfserver`, `mta` ou un autre module Campaign.
3. Examiner les valeurs complètes de `Image` et `CommandLine` de l'enfant, les identifiants de processus, l'utilisateur, le niveau d'intégrité, le répertoire courant, les hash, la signature et l'heure de démarrage.
4. Vérifier la version et le build de Campaign. Les systèmes en version 7.4.4 build 9401 ou antérieure nécessitent la mise à jour APSB26-142 ; le build apporte du contexte, mais ne prouve pas une exploitation.
5. Rechercher dans `web.log`, `watchdog.log`, le reverse proxy, le WAF et le répartiteur de charge les requêtes reçues par le même serveur pendant les cinq minutes précédant la création du processus.
6. Déterminer si une maintenance documentée ou une extension personnalisée approuvée a volontairement lancé la commande exacte.

## Collecte des preuves

- Exporter l'arbre de processus avec les identifiants du parent et de l'enfant.
- Conserver les lignes de commande complètes et les informations d'environnement disponibles.
- Collecter le hash, la signature, le chemin et les horodatages du binaire enfant, ainsi qu'une copie conforme à la politique de preuve de réponse à incident.
- Exporter `web.log` et `watchdog.log` d'Adobe Campaign sur une période d'au moins 15 minutes avant et après l'alerte.
- Exporter les événements du reverse proxy, du WAF, du firewall, du DNS et du réseau EDR pour l'hôte affecté.
- Noter le build Campaign, le système d'exploitation, les interfaces exposées, le compte de service et le propriétaire de l'actif.
- Ne conserver la mémoire ou un dump de processus que dans le cadre des procédures forensiques approuvées.

## Confinement

- Pour un shell inexpliqué, une commande encodée, un téléchargement externe ou un callback sortant, isoler l'hôte selon la procédure EDR ou réseau approuvée.
- Restreindre l'accès à l'interface applicative Campaign au niveau du reverse proxy ou du firewall tout en préservant les preuves.
- Désactiver ou renouveler les identifiants uniquement lorsque le responsable de l'incident confirme les identités touchées et l'impact métier.
- Ne pas arrêter les services Campaign avant la collecte des preuves volatiles, sauf si une exécution en cours crée un risque immédiat.

## Éradication

- Mettre à niveau les systèmes Adobe Campaign Classic v7 affectés vers le build 9402 ou une version ultérieure prise en charge.
- Supprimer les fichiers, tâches planifiées, services, comptes, clés SSH, contenus web et modifications de configuration non autorisés identifiés pendant l'enquête.
- Restaurer les composants Campaign modifiés depuis un support de confiance si leur intégrité ne peut pas être établie.
- Examiner les extensions personnalisées et workflows capables d'exécuter des commandes du système d'exploitation.

## Récupération

- Valider le build installé et l'intégrité des composants.
- Réactiver progressivement les accès et surveiller les descendants de `nlserver web`, les connexions sortantes, les authentifications et les journaux Campaign.
- Confirmer l'exécution normale des campagnes avec le propriétaire de l'application.
- Maintenir une surveillance renforcée pendant au moins un cycle complet de campagne métier ou la durée imposée par la politique d'incident.

## Critères d'escalade

Escalader immédiatement si l'un des éléments suivants est présent :

- commande encodée ou obscurcie ;
- téléchargement depuis une destination externe non approuvée ou connexion vers celle-ci ;
- exécutable non signé ou nouvellement créé ;
- comportement de persistance, d'accès aux identifiants, de découverte ou de mouvement latéral ;
- build Campaign vulnérable exposé à un réseau non fiable ;
- absence de maintenance approuvée expliquant exactement la commande.

Ne classer comme activité autorisée que si le propriétaire de l'actif fournit un changement valide et si la commande complète, le binaire, la destination, l'horaire et l'utilisateur correspondent à l'action approuvée.

## Notes de communication

- Décrire le constat comme une exécution suspecte d'un processus enfant côté serveur depuis Adobe Campaign.
- Ne pas affirmer que CVE-2026-75703 ou une autre faille APSB26-142 a été exploitée sans preuve au niveau de la requête ou preuve forensique.
- Informer le propriétaire du service Campaign, le responsable de l'infrastructure, l'équipe de réponse à incident et la fonction de protection des données si une exposition de données clients est plausible.

## Mapping MITRE ATT&CK

| Technique | Pertinence |
| :--- | :--- |
| T1059, Interpréteur de commandes et de scripts | L'exécution directe d'un shell ou d'un interpréteur est détectée. |
| T1053, Tâche ou travail planifié | Des utilitaires sélectionnés d'exécution différée sont détectés comme descendants directs. |
| T1218, Exécution par binaire système détourné | La règle Windows couvre certains binaires de proxy d'exécution. |
| T1105, Transfert entrant d'outils | Les règles couvrent certains utilitaires de transfert lorsque leur commande contient un marqueur de transfert. |
