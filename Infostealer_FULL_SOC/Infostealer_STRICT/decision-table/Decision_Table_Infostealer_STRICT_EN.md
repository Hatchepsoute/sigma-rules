# 📊 Decision Table – Confirmed Infostealer Activity (STRICT)
 
 [👉🏾  **French version available here**](Decision_Table_Infostealer_STRICT_FR.md)
 

## 🎯 Rule Logic

The rule triggers only if the 3 conditions are simultaneously true:

1.  **Suspicious LOLBIN execution from user-writable path**
2.  **Browser credential data access**
3.  **Network exfiltration indicators (HTTP / web tools)**

Logical condition:

    selection_exec AND selection_creds AND selection_net

------------------------------------------------------------------------

## 🔎 Decision Table

  --------------------------------------------------------------------------------
  Suspicious       Credential     Exfil         Trigger   SOC     Interpretation
  Execution        Access         Indicator               Level   
  ---------------- -------------- ------------- --------- ------- ----------------
  ❌               ❌             ❌            No        ---     No infostealer
                                                                  behavior

  ✅               ❌             ❌            No        P3      Suspicious
                                                                  LOLBIN only

  ✅               ✅             ❌            No        P2      Credential
                                                                  access without
                                                                  visible exfil

  ✅               ❌             ✅            No        P2      Possible
                                                                  downloader /
                                                                  staging

  ❌               ✅             ✅            No        P2      Suspicious but
                                                                  not via
                                                                  user-writable
                                                                  LOLBIN

  ✅               ✅             ✅            Yes       🔴 P1   Full infostealer
                                                                  chain (exec +
                                                                  credential
                                                                  theft +
                                                                  exfiltration)
  --------------------------------------------------------------------------------

------------------------------------------------------------------------

## 🚨 Recommended SOC Response

If rule triggers (3/3 conditions):

-   Immediately isolate host
-   Collect process tree & binary hash
-   Block IP/domain
-   Reset browser and SSO credentials
-   Perform lateral hunting across endpoints

------------------------------------------------------------------------
## Severity
Critical

## SOC Standard Statement
This alert represents a confirmed infostealer activity based on multi-stage behavioral correlation.
