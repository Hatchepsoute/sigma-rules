# 🛡️ Évasion de Défense – Neutralisation des Outils de Sécurité (Pack Sigma)
[👉🏾**English version available here**](README.md)

Ce pack Sigma open-source détecte les tentatives visant à **neutraliser, désactiver ou arrêter** des outils de sécurité (EDR, antivirus, Microsoft Defender) sur des systèmes Windows.

Ces comportements sont fréquemment observés lors :
- des phases pré-chiffrement de ransomware
- des activités post-exploitation
- des techniques d’évasion de défense (MITRE ATT&CK T1562.001)

Les règles sont **comportementales**, **indépendantes de tout SIEM** et convertibles vers n’importe quelle plateforme (Splunk, Elastic, OpenSearch, QRadar, ArcSight, Wazuh, Sentinel, etc.).

---

## 📂 Règles Sigma incluses

### 1️⃣ Arrêt de processus de sécurité
**Fichier :**  
[`proc_termination_security_processes.yml`](./rules/proc_termination_security_processes.yml)

**Objectif :**  
Détecter l’arrêt de processus associés à des outils de sécurité ou EDR.

**Logique de détection :**
- Surveillance des événements de terminaison de processus
- Correspondance avec des noms de processus de sécurité connus
- Signal contextuel (non suffisant seul)

**Cas d’usage :**  
Corrélation, investigation SOC, analyse de chaîne d’attaque ransomware

---

### 2️⃣ Désactivation des outils de sécurité via ligne de commande (BROAD)
**Fichier :**  
[`proc_creation_disable_security_tools_broad.yml`](./rules/proc_creation_disable_security_tools_broad.yml)

**Objectif :**  
Détection large des tentatives de désactivation d’outils de sécurité via des commandes système.

**Logique de détection :**
- Utilitaires : taskkill, sc, net, PowerShell, wmic
- Actions génériques (stop, disable, exclusion)
- Cibles liées à Defender ou aux solutions de sécurité

**Cas d’usage :**  
Threat hunting, détection précoce, abus administratifs suspects

---

### 3️⃣ Désactivation des outils de sécurité via ligne de commande (STRICT)
**Fichier :**  
[`proc_creation_disable_security_tools_strict.yml`](./rules/proc_creation_disable_security_tools_strict.yml)

**Objectif :**  
Détection à **haute confiance** d’actions explicites de neutralisation des protections.

**Logique de détection :**
- Patterns forts :
  - `taskkill /F /IM <processus_sécurité>`
  - `sc stop WinDefend`
  - `Set-MpPreference -DisableRealtimeMonitoring`
- Combinaison explicite outil + action + cible

**Cas d’usage :**  
Alerte SOC, réponse automatisée, confinement ransomware

---

## 🎯 Stratégie de détection

| Règle | Confiance | Usage SOC |
|---|---|---|
| Arrêt de processus | Moyenne | Corrélation / contexte |
| Désactivation CLI (BROAD) | Moyenne | Hunting / alerte précoce |
| Désactivation CLI (STRICT) | Élevée | Alerte / réponse |

**Bonne pratique :**  
Corréler plusieurs règles sur une courte fenêtre temporelle pour confirmer l’attaque.

---

## 🧠 Cartographie MITRE ATT&CK

- `T1562` – Altération des défenses  
- `T1562.001` – Désactivation ou modification des outils de sécurité

---

## ⚠️ Faux positifs & ajustements

Scénarios légitimes possibles :
- Maintenance par des administrateurs
- Scripts de provisioning ou d’images systèmes
- Actions de réponse à incident

➡️ Recommandations :
- Ajouter des listes d’exclusion adaptées
- Corréler avec les fenêtres de changement
- Ne pas utiliser la règle STRICT seule sans contexte

---

## 📌 Avertissement

Ces règles sont fournies à des fins défensives uniquement.  
Elles doivent être adaptées et testées dans chaque environnement.

---

## 🤝 Contributions

Les contributions, améliorations et ajouts de vendors sont les bienvenus via pull request.
## Auteur

✍🏿  Adama ASSIONGBON - SOC & CTI Consultant  
[LinkedIn Profile](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

