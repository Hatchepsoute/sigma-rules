# 📊 Table de Décision – Activité Infostealer Confirmée (STRICT)
👉🏾 [English version available here](Decision_Table_Infostealer_STRICT_EN.md)


 
# 🛡️ Decision Table - Infostealer High-Confidence Credential Access and Exfiltration
---
## 🎯 Logique de la règle

La règle déclenche si les 3 conditions sont simultanément vraies :

1.  **Execution suspecte (LOLBIN depuis chemin user-writable)**
2.  **Accès aux données d'identifiants navigateur**
3.  **Indicateurs d'exfiltration réseau (HTTP / outils web)**

Condition logique :

    selection_exec AND selection_creds AND selection_net

------------------------------------------------------------------------

## 🔎 Table de Décision

  ---------------------------------------------------------------------------------------
  Exécution     Accès         Indicateur        Déclenchement   Niveau   Interprétation
  suspecte      credentials   exfiltration                      SOC      
  ------------- ------------- ----------------- --------------- -------- ----------------
  ❌            ❌            ❌                Non             ---      Aucun
                                                                         comportement
                                                                         infostealer

  ✅            ❌            ❌                Non             P3       LOLBIN suspect
                                                                         seul

  ✅            ✅            ❌                Non             P2       Tentative vol
                                                                         credentials sans
                                                                         exfil visible

  ✅            ❌            ✅                Non             P2       Possible
                                                                         downloader /
                                                                         staging

  ❌            ✅            ✅                Non             P2       Activité
                                                                         suspecte mais
                                                                         pas via LOLBIN
                                                                         user-writable

  ✅            ✅            ✅                ✅              🔴 P1    Chaîne complète
                                                                         infostealer
                                                                         (exec + vol
                                                                         creds +
                                                                         exfiltration)
  ---------------------------------------------------------------------------------------

------------------------------------------------------------------------

## 🚨 Politique SOC recommandée

Si la règle déclenche (3/3 conditions) :

-   Isoler immédiatement l'hôte
-   Collecter process tree et hash binaire
-   Bloquer IP/domain
-   Reset credentials navigateur et SSO
-   Hunting latéral (recherche même pattern sur autres endpoints)

------------------------------------------------------------------------


## Sévérité
Critique

## Phrase SOC standard
Cette alerte correspond à une activité infostealer confirmée basée sur une corrélation comportementale multi-étapes.
