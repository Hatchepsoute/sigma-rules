![Release](https://img.shields.io/badge/release-v1.0.0-blue?style=flat-square)
![Sigma](https://img.shields.io/badge/Sigma-compatible-success?style=flat-square)
![MITRE ATT&CK](https://img.shields.io/badge/MITRE_ATT%26CK-mapped-red?style=flat-square)

# 🧠 Vol de Contexte d’Agent IA - Pack Sigma

![Release](https://img.shields.io/badge/release-v1.0.0-blue?style=flat-square)

👉🏾 [**English version available here**](README.md)

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
### Références
https://www.infostealers.com/article/hudson-rock-identifies-real-world-infostealer-infection-targeting-openclaw-configurations/
---
## ✍🏿 Author
[Adama ASSIONGBON – SOC & CTI Consultant](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

