# 📊 Table de Décision - Neutralisation des Outils de Sécurité (Sigma)
[👉🏾**English version available here**](README.md)

Cette table de décision explique **quand et comment utiliser chaque règle Sigma** du pack *Évasion de Défense – Neutralisation des Outils de Sécurité*.

Les règles sont **complémentaires** et doivent idéalement être **corrélées entre elles** pour une détection fiable.

---

## 🧩 Vue d’ensemble des règles

| ID | Nom de la règle | Objectif |
|----|---------------|----------|
| R1 | Arrêt de processus de sécurité | Effet observé |
| R2 | Désactivation via ligne de commande (BROAD) | Intention suspecte |
| R3 | Désactivation via ligne de commande (STRICT) | Action malveillante explicite |

---

## 🎯 Matrice de décision

| Scénario | R1<br>Arrêt Processus | R2<br>CLI Disable (BROAD) | R3<br>CLI Disable (STRICT) | Interprétation SOC | Action recommandée |
|--------|----------------------|--------------------------|---------------------------|--------------------|-------------------|
| Maintenance administrateur | ✅ | ❌ / ⚠️ | ❌ | Légitime probable | Journaliser / surveiller |
| Abus administratif suspect | ❌ / ⚠️ | ✅ | ❌ | Alerte précoce | Investiguer |
| Préparation ransomware | ⚠️ | ✅ | ⚠️ | Risque élevé | Confinement préventif |
| Évasion de défense active | ✅ | ⚠️ | ✅ | Compromission avérée | Isolation immédiate |
| Kill EDR avant chiffrement | ✅ | ✅ | ✅ | Incident critique | IR + confinement |

Légende :  
- ✅ = Détecté  
- ⚠️ = Possiblement détecté  
- ❌ = Non détecté

---

## 🧠 Recommandations de corrélation

Logique recommandée :
- **R2 suivi de R1** → forte suspicion d’évasion de défense
- **R3 seul** → activité malveillante à haute confiance
- **R1 seul** → signal contextuel, ne pas alerter isolément

Fenêtre temporelle recommandée :
- **5 à 15 minutes**

---

## 🚨 Stratégie d’alerte

| Règle | Sévérité | Usage |
|----|---------|------|
| R1 | Moyenne | Contexte / enrichissement |
| R2 | Moyenne à élevée | Hunting / détection précoce |
| R3 | Critique | Alerte SOC / réponse |

---

## 🧩 Bonnes pratiques SOC

- Ne jamais utiliser une règle seule
- Corréler avec :
  - Accès LSASS
  - Dump d’identifiants
  - Mouvement latéral
  - Création de tâches planifiées
- Aligner les alertes avec les fenêtres de changement

---

## 📌 Remarques

Ces règles sont indépendantes du SIEM et doivent être adaptées à chaque environnement.
## Auteur

✍🏿  Adama ASSIONGBON - SOC & CTI Consultant  
[LinkedIn Profile](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

