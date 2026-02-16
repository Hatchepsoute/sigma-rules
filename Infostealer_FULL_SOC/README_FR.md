# 🛡️ Infostealers_FULL_SOC --- Pack de Détection

👉🏾 [**English version available here**](README.md)

## 🎯 Présentation

Ce dépôt contient **quatre règles de détection à haute confiance** permettant d'identifier des activités infostealer sur Windows via corrélation comportementale.

Le pack est structuré en deux modèles complémentaires :

------------------------------------------------------------------------

# 📂 1️⃣ Infostealer_STRICT (Règle Unique Haute Confiance)

Ce dossier contient une **règle consolidée unique** :

[`infostealer_STRICT_credential_access_and_exfiltration.yml`](./Infostealer_STRICT/rules/infostealer_STRICT_credential_access_and_exfiltration.yml) 

### 🔎 Logique de détection

La règle déclenche uniquement si les 3 comportements suivants sont observés simultanément :

1.  Exécution suspecte de LOLBIN depuis un chemin user-writable\
2.  Accès aux stockages d'identifiants navigateur\
3.  Indicateurs d'exfiltration réseau

Condition logique :

    selection_exec AND selection_creds AND selection_net

### 📦 Artifacts inclus

-   Mapping MITRE ATT&CK Navigator\
-   Tables de décision (FR / EN)\
-   Diagrammes Mermaid\
-   Playbooks TheHive (FR / EN)

### 🎯 Utilisation

Recommandé pour les environnements privilégiant une **règle unique à très forte confiance**.

------------------------------------------------------------------------

# 📂 2️⃣ Infostealer_STRICT_Correlated (Modèle par Étapes)

Ce dossier contient **trois règles modulaires** :

-   Step 1 --- Exécution suspecte\   [`infostealer_STRICTv2_step1_suspicious_exec.yml`](./Infostealer_STRICT_Correlated/rules/infostealer_STRICTv2_step1_suspicious_exec.yml)
-   Step 2 --- Accès aux credentials navigateur\   [`infostealer_STRICTv2_step2_browser_cred_access.yml`](./Infostealer_STRICT_Correlated/rules/infostealer_STRICTv2_step2_browser_cred_access.yml)
-   Step 3 --- Egress réseau public   [`infostealer_STRICTv2_step3_public_egress.yml`](./Infostealer_STRICT_Correlated/rules/infostealer_STRICTv2_step3_public_egress.yml)


Ces règles sont conçues pour être corrélées via :

-   Séquence Elastic EQL\
-   Pivot OpenSearch\
-   Mécanisme natif de corrélation SIEM

### 🧠 Modèle de corrélation

    Step1 → Step2 → Step3 (≤10 minutes)

Ce modèle offre :

-   Détection plus précoce (signaux partiels)
-   Tuning SOC avancé
-   Flexibilité opérationnelle

### 📦 Artifacts inclus

-   Requêtes de corrélation (Elastic / OpenSearch)\
-   Tables de décision\
-   Diagramme Kill Chain\
-   Playbooks TheHive\
-   Diagrammes Mermaid

------------------------------------------------------------------------

# 🔴 Sévérité & Stratégie

  Modèle                  Confiance           Flexibilité   Effort SOC
  ----------------------- ------------------- ------------- ------------
  STRICT (règle unique)   Très élevée         Moyenne       Faible
  STRICT Corrélé          Très élevée (3/3)   Élevée        Moyen

Les deux approches reposent sur une **détection comportementale** et non sur des IoC statiques.

------------------------------------------------------------------------

# 📊 Valeur Stratégique

-   Réduction des faux positifs\
-   Détection du vol d'identifiants\
-   Alignement MITRE ATT&CK\
-   Prêt pour production SOC

------------------------------------------------------------------------
