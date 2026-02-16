# 🛡️ Infostealer Detection Strategy (STRICT v2) - Sigma Rules
 [👉🏾  **English version available here**](README.md)
 
Ce répertoire contient une suite de 3 règles Sigma corrélées conçues pour détecter les activités d'Infostealers (type Arkanix, RedLine, Vidar) en suivant leur cycle de vie complet, de l'exécution à l'exfiltration.
🏗️ Architecture de Détection (Step-by-Step)

Pour réduire les faux positifs et augmenter la confiance dans les alertes, ces règles sont divisées en trois étapes critiques. Une corrélation de ces trois événements sur un même hôte dans une fenêtre de 10 minutes indique une compromission quasi certaine.

## 1️⃣ Étape 1 : Exécution Suspecte (LOLBins) 🚀

    Fichier : [infostealer_STRICTv2_step1_suspicious_exec.yml](./rules/infostealer_STRICTv2_step1_suspicious_exec.yml)

    Logique : Détecte l'exécution de binaires légitimes Windows (PowerShell, CMD, Rundll32, etc.) depuis des répertoires normalement réservés aux utilisateurs (\Downloads\, \AppData\, \Temp\).

    Indicateur : Utilisation de commandes encodées (Base64) ou de téléchargements directs via CLI.

    Niveau : High

## 2️⃣ Étape 2 : Accès aux Identifiants Navigateurs 🔑

    Fichier : [infostealer_STRICTv2_step2_browser_cred_access.yml](./rules/infostealer_STRICTv2_step2_browser_cred_access.yml)

    Logique : Identifie tout processus non-navigateur qui tente de lire les bases de données de mots de passe, cookies ou sessions (Chrome, Edge, Firefox).

    Cibles : Fichiers Login Data, key4.db, cookies.sqlite, etc.

    **Niveau : Critical**

## 3️⃣ Étape 3 : Exfiltration & Communication Externe 🌐

    Fichier : [infostealer_STRICTv2_step3_public_egress.yml](./rules/ infostealer_STRICTv2_step3_public_egress.yml)

    Logique : Détecte les connexions réseau sortantes vers des adresses IP publiques initiées par des LOLBins (PowerShell, Cscript, Mshta).

    Filtre : Exclut automatiquement les plages d'IP privées (RFC 1918).

    **Niveau : High**
---
### Faux Positifs Communs
- Step 1 : Scripts d'administration IT légitimes (vérifier la signature numérique).
- Step 2 : Outils de sauvegarde ou gestionnaires de mots de passe d'entreprise.
-  Step 3 : Télémétrie logicielle légitime ou mises à jour via PowerShell.

### 👤 Auteur
Adama ASSIONGBON SOC & CTI Consultant 
**Contact:** 🔗 [Profil LinkedIn](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

## 📜 Références
- www.dexpose.io/deep-dive-into-arkanix-stealer-and-its-infrastructure/
- https://attack.mitre.org/techniques/T1555/
- https://attack.mitre.org/techniques/T1059/

