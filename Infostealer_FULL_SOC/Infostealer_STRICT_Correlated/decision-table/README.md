# 🛡️ Infostealer STRICT v2 - Decision Table

 [👉🏾  **French version available here**](README_FR.md)
 
## 🎯 Objective

This decision table structures SOC analysis for the three STRICT v2 rules:

-   **Step 1 (E1)** --- Suspicious execution from user-writable path via LOLBin\
-   **Step 2 (E2)** --- Non-browser process accessing browser credential stores\
-   **Step 3 (E3)** --- Public network egress from LOLBin/loader

🕒 **Recommended correlation window: ≤ 10 minutes**

------------------------------------------------------------------------

## 🔎 Decision Table

  -----------------------------------------------------------------------------------
  Case   E1   E2   E3   Confidence   SOC Interpretation  Priority   Recommended
                                                                    Actions
  ------ ---- ---- ---- ------------ ------------------- ---------- -----------------
  1      ✅   ✅   ✅   🔴 Very High Typical infostealer P1         Isolate host,
                                     chain                          collect hashes,
                                                                    block IP/domain,
                                                                    reset credentials

  2      ✅   ✅   ❌   🟠 High      Likely credential   P1/P2      Review proxy/DNS
                                     theft                          logs, monitor E3

  3      ✅   ❌   ✅   🟡 Medium    Possible            P2         Validate
                                     loader/downloader              destination
                                                                    reputation

  4      ❌   ✅   ✅   🟠 Medium to Credential access + P1/P2      Identify process,
                        High         exfil                          hunt persistence

  5      ✅   ❌   ❌   🟡 Low to    Suspicious LOLBin   P3         Quick triage
                        Medium       only                           

  6      ❌   ✅   ❌   🟡 Medium    Credential access   P2/P3      Check password
                                     without exfil                  managers

  7      ❌   ❌   ✅   🟡 Low to    Isolated LOLBin     P3         Validate
                        Medium       egress                         IP/domain
                                                                    reputation

  8      ❌   ❌   ❌   ---          No signal           ---        ---
  -----------------------------------------------------------------------------------

------------------------------------------------------------------------

*Update: 2026-02-16 17:06:42 UTC*
