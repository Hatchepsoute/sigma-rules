# Playbook - Campagne réseau & virtualisation UNC3886

## Objectif

Guider le triage SOC pour un sondage externe des interfaces d'administration et des comportements de tampering/logging ou de shelling associés à UNC3886.

## Périmètre

Appliances de sécurité réseau, hyperviseurs et hôtes Linux d'administration.

## Étapes de triage

1. Confirmer si le service exposé est une interface d'administration ou un chemin d'admin public.
2. Examiner l'alerte BROAD : IP source, URL, méthode et user agent.
3. Vérifier si la règle STRICT s'est déclenchée sur un tampering des logs ou un lancement de shell.
4. Corréler la requête avec une modification des logs, de la persistance ou de l'exécution de services.
5. Vérifier le niveau de correctif et l'activité d'administration récente.
6. Isoler l'hôte si tampering des logs et exécution de shell apparaissent dans la même fenêtre.

## Preuves à collecter

- Journaux d'accès HTTP
- Syslog ou télémétrie de création de processus
- Contexte d'ownership du service et du parent process
- Version et niveau de correctif
- Ligne de temps EDR autour de l'incident

## Critères d'escalade

- Sondage externe d'une interface d'admin suivi de shelling ou de tampering des logs
- Tentatives répétées depuis des outils d'automatisation
- Preuves de suppression des logs, nettoyage ou modification de persistance
