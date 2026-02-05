
# Playbook SOC – Linux Sliver / FRP / Masquage LPD 
[👉🏾 English version available here: ](./README.md)
## Périmètre
Ce playbook guide les analystes SOC dans l’investigation et la réponse aux alertes liées à :
- L’utilisation de FRP comme reverse proxy
- Un proxy SOCKS déguisé en service LPD (cups-lpd)
- Le déploiement d’implants Sliver
- Les mécanismes de persistance systemd

Ce playbook est aligné avec les règles Sigma, la table de décision et le diagramme Mermaid.

---

## Conditions de Déclenchement
Une ou plusieurs alertes :
- Exécution FRP détectée
- Listener suspect sur TCP/515
- Exécution de cups-lpd avec arguments SOCKS
- Création du binaire `system-updater`
- Création d’un service systemd suspect

---

## Phase 1 – Triage Initial (L1)

**Objectifs**
- Valider la légitimité de l’alerte
- Écarter les faux positifs évidents

**Actions**
- Identifier l’hôte, l’utilisateur, l’horodatage
- Vérifier le rôle de l’hôte
- Confirmer si les services d’impression sont attendus

**Décision**
- Alerte isolée → escalade L2
- Alertes corrélées → Phase 2

---

## Phase 2 – Investigation (L2)

**Analyse des Processus**
- Examiner l’arbre de processus
- Vérifier les chemins suspects (`/tmp`, `/dev/shm`, répertoires cachés)
- Analyser la ligne de commande

**Analyse Réseau**
- Identifier tunnels entrants/sortants
- Vérifier l’écoute sur TCP/515
- Identifier IP et ports distants

**Système de Fichiers**
- Rechercher `system-updater` ou binaires cachés
- Vérifier dates et permissions
- Calculer les hash

**Décision**
- FRP + LPD + implant → escalade L3
- Indicateur unique → surveillance

---

## Phase 3 – Confirmation & Réponse (L3)

**Indicateurs de Compromission**
- Déclenchement multiple de règles Sigma
- Persistance systemd confirmée
- Accès distant non autorisé

**Actions de Réponse**
- Isoler l’hôte
- Désactiver les services systemd malveillants
- Stopper les processus malveillants
- Supprimer les implants

---

## Phase 4 – Confinement & Éradication

- Rotation des identifiants
- Recherche de mouvements latéraux
- Application des correctifs
- Durcissement systemd

---

## Phase 5 – Retours d’Expérience

- Ajuster les règles Sigma
- Mettre à jour les allowlists
- Documenter l’incident
- Partager la CTI en interne

---

## Cartographie du Verdict

| Conditions | Verdict |
|-----------|---------|
| FRP seul | Activité suspecte |
| FRP + LPD | Risque élevé |
| FRP + LPD + Sliver + Persistance | **Compromission confirmée** |

[TheHive_Playbook_Sliver_FortiWeb.yml](./TheHive_Playbook_Sliver_FortiWeb.yml)

[TheHive_Decision_Mapping.yml](./TheHive_Decision_Mapping.yml)
