# 🛡️ Infostealer STRICT v2 -Table de Décision

[👉🏾  **English version available here**](README.md)

## 🎯 Objectif

Cette table de décision structure l'analyse SOC pour les trois règles STRICT v2 :

-   **Step 1 (E1)** --- Exécution suspecte depuis un chemin user-writable via LOLBin\
-   **Step 2 (E2)** --- Accès aux stockages d'identifiants navigateur par un processus non-browser\
-   **Step 3 (E3)** --- Communication sortante vers Internet depuis LOLBin/loader

🕒 **Fenêtre de corrélation recommandée : ≤ 10 minutes**

------------------------------------------------------------------------

## 🔎 Table de Décision

  ------------------------------------------------------------------------------------
  Cas   E1   E2   E3   Niveau de        Interprétation    Priorité   Actions
                       confiance        SOC                          recommandées
  ----- ---- ---- ---- ---------------- ----------------- ---------- -----------------
  1     ✅   ✅   ✅   🔴 Très élevée   Chaîne complète   P1         Isoler la
                                        typique                      machine,
                                        d'infostealer                collecter process
                                        (exec → vol creds            tree & hash,
                                        → exfil)                     bloquer
                                                                     IP/domain, reset
                                                                     credentials
                                                                     navigateur/SSO

  2     ✅   ✅   ❌   🟠 Élevée        Vol               P1/P2      Vérifier
                                        d'identifiants               proxy/DNS,
                                        probable, exfil              surveiller E3
                                        non observée ou              
                                        bloquée                      

  3     ✅   ❌   ✅   🟡 Moyenne       Loader ou         P2         Valider
                                        downloader                   destination,
                                        possible                     vérifier parent
                                                                     process

  4     ❌   ✅   ✅   🟠 Moyenne à     Accès creds +     P1/P2      Identifier
                       élevée           exfil, outil                 processus,
                                        potentiellement              hunting
                                        furtif                       persistence

  5     ✅   ❌   ❌   🟡 Faible à      Suspicious LOLBin P3         Triage rapide
                       moyenne          seul                         

  6     ❌   ✅   ❌   🟡 Moyenne       Accès aux stores  P2/P3      Vérifier password
                                        sans exfil                   managers / EDR
                                        visible                      

  7     ❌   ❌   ✅   🟡 Faible à      Egress LOLBin     P3         Valider
                       moyenne          isolé                        réputation
                                                                     IP/domain

  8     ❌   ❌   ❌   ---              Aucun signal      ---        ---
  ------------------------------------------------------------------------------------

------------------------------------------------------------------------

*Update: 2026-02-16 17:06:42 UTC*
