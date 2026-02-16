# 📊 Decision Table – Confirmed Infostealer Activity (STRICT)

## 🎯 Rule Logic

The rule triggers only if the 3 conditions are simultaneously true:

1.  **Suspicious LOLBIN execution from user-writable path**
2.  **Browser credential data access**
3.  **Network exfiltration indicators (HTTP / web tools)**

Logical condition:

    selection_exec AND selection_creds AND selection_net

👉🏾   [** Decision Table - Confirmed Infostealer Activity available here **](Decision_Table_Infostealer_STRICT_EN.md)

---

# 🎯 Logique de la règle

La règle déclenche si les 3 conditions sont simultanément vraies :

1.  **Execution suspecte (LOLBIN depuis chemin user-writable)**
2.  **Accès aux données d'identifiants navigateur**
3.  **Indicateurs d'exfiltration réseau (HTTP / outils web)**

Condition logique :
    selection_exec AND selection_creds AND selection_net

👉🏾 [ **# 📊 Table de Décision – Activité Infostealer Confirmée (STRICT)  disponible ici**](Decision_Table_Infostealer_STRICT_FR.md)
