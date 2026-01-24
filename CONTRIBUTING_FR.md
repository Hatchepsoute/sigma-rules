👉🏾 **English version available here:** [CONTRIBUTING.md](CONTRIBUTING.md)

# Contribuer au projet sigma-rules

Merci pour votre intérêt à contribuer à ce projet 🙌  
Ce dépôt vise à fournir du **contenu Sigma prêt pour des SOC de production** à destination des équipes SOC, MSSP et Detection Engineers.

Toute contribution est la bienvenue, sous réserve du respect des règles ci-dessous.

---

## 🎯 Périmètre des contributions

Les contributions acceptées concernent notamment :

- Règles Sigma (BROAD, STRICT, SUPPORT, corrélation)
- Packs de détection orientés CVE
- Packs de détection orientés campagne
- Tables de décision SOC
- Playbooks SOAR (TheHive, workflows génériques)
- Diagrammes et documentation 
- Amélioration des détections (bruit, résilience, couverture)

❌ Soumissions basées uniquement sur des IoC statiques  
❌ Règles sans valeur opérationnelle SOC

---

## 🧠 Philosophie de détection

Le projet repose sur une **approche de détection multicouche** :

- **BROAD** – Visibilité et threat hunting  
- **STRICT** – Détection à forte confiance  
- **SUPPORT / CORRELATION** – Contexte et confirmation d’incident  

Les règles ne doivent pas reposer uniquement sur des indicateurs statiques.

---

## 📁 Structure du dépôt

Chaque pack de détection doit respecter la structure suivante :
```text
Pack_Name/
├── rules/
│   ├── BROAD/
│   ├── STRICT/
│   └── SUPPORT/
├── decision-table/
├── playbook/
├── diagrams/
├── README.md
└── README_FR.md
```
---

## 🧪 Exigences sur les règles Sigma

Les règles doivent :

- Respecter la spécification officielle Sigma
- Être validées (`sigma check` ou équivalent)
- Inclure les métadonnées obligatoires
- Éviter les logiques trop génériques ou bruyantes

---

## 📊 Tables de décision & Playbooks

Les tables et playbooks doivent guider clairement l’analyste SOC :
- Signification de l’alerte
- Niveau de confiance
- Actions recommandées
- Critères d’escalade

---

## 🌍 Langue

- L’anglais est obligatoire
- La version française est fortement recommandée
- Les documents EN / FR doivent être liés entre eux

---

## 🔍 Processus de revue

1. Fork du dépôt
2. Création d’une branche dédiée
3. Pull request avec contexte et validation
4. Prise en compte des retours

---

## ⚖️ Licence

En contribuant, vous acceptez que vos apports soient distribués sous licence **Apache 2.0**.

---

Merci de contribuer à l’amélioration de la détection open-source.
