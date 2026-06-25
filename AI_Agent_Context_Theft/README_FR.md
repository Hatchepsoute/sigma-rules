![Release](https://img.shields.io/badge/release-v1.0.0-blue?style=flat-square)
![Sigma](https://img.shields.io/badge/Sigma-compatible-success?style=flat-square)
![MITRE ATT&CK](https://img.shields.io/badge/MITRE_ATT%26CK-mapped-red?style=flat-square)

# 🧠 Vol de Contexte d’Agent IA - Pack Sigma
👉🏾 [English version available here](README.md)

## En un coup d'oeil

- Menace : vol d'identité et de contexte visant des agents IA locaux
- Focus de détection : BROAD pour l'accès config/mémoire, STRICT/CRITICAL pour le vol de jetons et l'identité crypto
- Artefacts SOC : `playbook/`, `decision-table/`, `diagrams/`
- Fichiers de règles :
  - [`ai_agent_config_access_broad.yml`](./rules/ai_agent_config_access_broad.yml)
  - [`ai_agent_secrets_exfiltration_strict.yml`](./rules/ai_agent_secrets_exfiltration_strict.yml)
  - [`ai_agent_crypto_identity_compromise_strict.yml`](./rules/ai_agent_crypto_identity_compromise_strict.yml)
  - [`ai_agent_multifile_exfiltration_strict.yml`](./rules/ai_agent_multifile_exfiltration_strict.yml)




## Présentation
Ce pack Sigma permet de détecter le vol d’identité et de contexte d’agents IA locaux (OpenClaw et similaires).

Il cible :
- les jetons persistants,
- les clés privées d’identité,
- la mémoire comportementale de l’agent.

Basé sur un cas réel observé en février 2026.

---

## Couches de Détection

| Couche | Règle | Objectif |
|--------|--------|----------|
| 🟡 BROAD | Accès Config & Mémoire | Détection précoce |
| 🔴 STRICT | Vol de Secrets | Compromission probable |
| 🔴🔴 CRITIQUE | Identité Crypto | Usurpation machine |
| 🔴🔴 CRITIQUE | Multi-Fichiers | Compromission totale |

---

## Réponse SOC

Si une règle STRICT ou CRITIQUE déclenche :
1. Isoler le poste
2. Révoquer les jetons
3. Régénérer l’identité crypto
4. Auditer l’activité
5. Considérer l’agent compromis
---
### Références

- https://www.infostealers.com/article/hudson-rock-identifies-real-world-infostealer-infection-targeting-openclaw-configurations/

## ✍🏿 Author
[Adama ASSIONGBON – SOC & CTI Consultant](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

