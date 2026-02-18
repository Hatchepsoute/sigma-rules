# 🧠 Table de Décision - Vol de Contexte d’Agent IA

👉🏾 [**English version available here**](README.md)
## Objectif
Aider les analystes SOC à qualifier les alertes liées au vol d’identité et de contexte d’agents IA locaux.

---

## 🟡 BROAD - Accès suspect aux fichiers d’agent IA

| Condition | Oui | Non |
|---------|-----|-----|
| Accès au répertoire `.openclaw` | Continuer | Clôturer |
| Fichier sensible (`openclaw.json`, `SOUL.md`, `MEMORY.md`) | Continuer | Clôturer |
| Processus inattendu | Escalade analyste N2 | Surveiller |
| Accès répétés | Confiance renforcée | Surveiller |

Action :
- Alerte de hunting
- Corrélation processus / réseau

---

## 🔴 STRICT - Exfiltration de secrets d’authentification

| Condition | Oui | Non |
|---------|-----|-----|
| Accès à `openclaw.json` | Continuer | Clôturer |
| Processus depuis Temp/AppData | Escalade analyste N3 | Surveiller |
| Processus non légitime | Incident | Surveiller |
| Connexion sortante | Compromission | En attente |

Action :
- Isolation du poste
- Révocation des jetons
- Audit de l’agent IA

---

## 🔴🔴 CRITIQUE - Compromission d’identité cryptographique

| Condition | Oui | Non |
|---------|-----|-----|
| Accès à `device.json` / `.pem` | Incident | Clôturer |
| Clé privée présente | Incident confirmé | Analyse |
| Processus inattendu | IR immédiat | Analyse |

Action :
- Rotation des clés
- Régénération de l’identité
- IR complet

---

## 🔴🔴 CRITIQUE - Accès multi‑fichiers

| Condition | Oui | Non |
|---------|-----|-----|
| Fichiers auth + crypto + mémoire | Compromission totale | Analyse |
| Même processus | IR immédiat | Analyse |

Action :
- Supposer une prise de contrôle complète
## ✍🏿 Author
[Adama ASSIONGBON – SOC & CTI Consultant](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

