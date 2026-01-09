
# Rootkit Kernel MVDR – Explication par scénario

## 1. Scénario d’attaque (vision attaquant)

Ce pack détecte les attaques par rootkit en mode noyau sur Windows.

Déroulement classique :
1. Obtention de privilèges administrateur
2. Dépôt d’un driver noyau malveillant (.sys)
3. Création d’un service kernel (Type=1)
4. Chargement du driver dans le noyau (Ring-0)
5. Persistance et dissimulation

Une fois le driver chargé, la confiance dans l’OS est rompue.

---

## 2. Fonctionnement des règles (vision SOC)

### Règle mvdr-01-kernel-driver-load
Détecte le chargement d’un driver kernel.
- Faux positifs : drivers légitimes
- Vrais positifs : chargement inattendu
Usage : signal / hunting

### Règle mvdr-02-kernel-service
Détecte la persistance kernel.
- Faux positifs : très rares
- Vrais positifs : service inconnu
Usage : alerte forte

### Règle mvdr-03-kernel-rootkit-correlation
Corrélation exécution + persistance.
- Faux positifs : quasi inexistants
- Vrais positifs : rootkit confirmé
Usage : incident critique

---

## 3. Scénarios Pentest / Purple Team

Scénario A : simulation rootkit en laboratoire
Résultat attendu : déclenchement des 3 règles

Scénario B : installation pilote légitime
Résultat attendu : pas de corrélation

Scénario C : exercice Purple Team
Validation détection et MTTR

---

## 4. Message clé SOC

Une alerte kernel signifie une compromission majeure du système.
