# Détection Microsoft Office → LOLBins (Règles Sigma)

👉🏾 [English version available here](README.md)

➡️ **[English version available here](README.md)**
## Statut
- **Expérimental**
- Destiné à la détection SOC, au triage et au threat hunting
---

Présentation

Ce répertoire contient **deux règles Sigma corrélées** permettant de détecter des **comportements malveillants liés à l’exploitation de Microsoft Office** observés dans de nombreux CVE et campagnes réelles.

Ces règles sont **génériques** et ne sont pas limitées à un CVE précis.  
Elles ciblent les **comportements post-exécution** les plus fiables.

Elles respectent la **philosophie officielle sigma-rules** :
- Une règle **BROAD** pour la visibilité
- Une règle **STRICT** pour la confirmation

👉🏾 Elles doivent être **déployées ensemble**.

---

## Contexte de menace

Les documents Microsoft Office sont très souvent utilisés comme **vecteur d’exécution initial** :

- Ouverture d’un document piégé
- Office lance des outils système (**LOLBins**)
- Téléchargement ou exécution de payloads
- Transition vers la post-exploitation

👉 **Office ne devrait pas lancer directement des interpréteurs de commandes ou outils de téléchargement.**

---

## Règle 1 - BROAD

### Nom
**Microsoft Office lance un LOLBin ou moteur de script (BROAD)**
[office_spawn_lolbin_broad.yml](./rules/office_spawn_lolbin_broad.yml)
### Objectif
Détecter une **relation parent-enfant anormale** où Office lance un binaire système.

### Logique de détection
- **Processus parent** : applications Microsoft Office
- **Processus enfant** : LOLBins / moteurs de script
- **Sans analyse de ligne de commande**

### Interprétation SOC
- Activité suspecte mais **non concluante seule**
- Fournit une **visibilité précoce**

### Usage recommandé
- Triage analyste SOC N1 / N2
- Threat hunting
- Règle de base pour corrélation

---

## Règle 2 - STRICT

### Nom
**Microsoft Office lance un LOLBin avec téléchargement/exécution ou obfuscation (STRICT)**
[office_download_execute_strict.yml](./rules/office_download_execute_strict.yml)
### Objectif
Détecter une **intention malveillante explicite**.

### Logique de détection
- Office comme processus parent
- LOLBin / moteur de script comme enfant
- **ET** indicateurs :
  - Téléchargement de payload distant
  - Obfuscation / exécution en mémoire (`-enc`, Base64, IEX)

### Interprétation SOC
- **Activité hautement malveillante**
- Exploitation ou post-exploitation en cours

### Usage recommandé
- Escalade analyste SOC N2 / N3
- Déclaration d’incident
- Automatisation SOAR

---

## Corrélation des règles (ESSENTIEL)

Ces règles sont conçues pour être **corrélées**.

### Logique recommandée

1. **Déclenchement BROAD**
   - Activité Office suspecte détectée
   - Contexte établi

2. **Déclenchement STRICT**
   - Intention malveillante confirmée
   - Incident validé

Cette corrélation :
- Réduit les faux positifs
- Maintient une détection précoce

---

## Tableau comparatif SOC

| **Critère** | **BROAD** | **STRICT** |
|------|------|------|
| Portée | Large | Ciblée |
| Faux positifs | Possibles | Rares |
| Niveau de confiance | Moyen | Élevé |
| Analyse ligne de commande | ❌ | ✅ |
| Téléchargement payload | ❌ | ✅ |
| Détection obfuscation | ❌ | ✅ |
| Niveau SOC | L1 / L2 | L2 / L3 |
| Incident confirmé | ❌ | ✅ |

---

## Bonne pratique

> Toujours déployer **les deux règles ensemble**.
>
> - BROAD = visibilité & hunting  
> - STRICT = confirmation & réponse  
>
> Cette combinaison assure une **détection robuste des chaînes d’attaque basées sur Microsoft Office**.

---
✍🏿  Auteur: **Adama ASSIONGBON** - SOC & CTI Consultant  
**Contact:** [LinkedIn Profile](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

## Chaînage des règles
Quand un pack contient plusieurs règles, utiliser `related` pour relier les règles complémentaires.
Traiter l'alerte plus large comme un signal de chasse et la règle plus stricte comme un signal de confirmation quand les deux existent.
Corréler sur le même hôte, le même utilisateur ou dans une fenêtre de temps courte.

