# 🚨 Playbook TheHive - Vol de Contexte d’Agent IA 
👉🏾 [English version available here](README.md)



## Objectif
Guider les équipes SOC et IR lors d’alertes indiquant un vol d’identité ou de contexte d’un agent IA local (ex : OpenClaw).

---

## 🔎 Déclencheur
- Détection par l’une des règles Sigma suivantes :
  - ai_agent_secrets_exfiltration_strict
  - ai_agent_crypto_identity_compromise_strict
  - ai_agent_multifile_exfiltration_strict

Sévérité : **Élevée / Critique**

---

## 🧭 Phase 1 - Qualification initiale (SOC N2/N3)

1. Vérifier la source de l’alerte et la règle
2. Identifier le poste et l’utilisateur impactés
3. Identifier les fichiers accédés :
   - `openclaw.json`
   - `device.json`, `.pem`
   - `SOUL.md`, `MEMORY.md`, `AGENTS.md`
4. Identifier le processus suspect (chemin, hash, parent)

Décision :
- Si identité crypto touchée → passer en Phase 3
- Sinon continuer Phase 2

---

## 🚧 Phase 2 – Confinement

1. Isoler le poste du réseau
2. Bloquer le hash du processus (EDR)
3. Préserver les données volatiles
4. Empêcher l’accès aux répertoires agent IA

---

## 🔐 Phase 3 – Remédiation Identité & Secrets

1. Révoquer les jetons d’accès de l’agent IA
2. Régénérer l’identité cryptographique (clés / certificats)
3. Invalider les services cloud appairés
4. Réinitialiser les secrets stockés en mémoire

---

## 🧪 Phase 4 – Investigation

1. Reconstituer la chronologie :
   - accès fichiers
   - exécution processus
   - connexions sortantes
2. Vérifier l’exfiltration de données
3. Auditer les actions de l’agent IA
4. Évaluer le risque de mouvement latéral

---

## 🧹 Phase 5 – Restauration

1. Réinstaller ou nettoyer le poste si nécessaire
2. Redéployer l’agent IA de façon sécurisée
3. Restaurer une mémoire minimale fiable
4. Surveiller toute récidive

---

## 📌 Phase 6 – Retour d’expérience

1. Classer les données IA comme sensibles
2. Activer le chiffrement au repos
3. Surveiller les accès aux répertoires
4. Mettre à jour règles et playbooks SOC

---

## 🧠 Message clé
Un agent IA compromis représente un **vol d’identité persistante**, pas une simple infection.
## ✍🏿 Author
[Adama ASSIONGBON – SOC & CTI Consultant](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

