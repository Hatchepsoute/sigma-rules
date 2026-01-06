\
# OpenSearch / Lucene Correlation – Infostealer STRICT v2 (Pivot Method)

## Step A (Execution candidates)
(Image:(*\\powershell.exe OR *\\pwsh.exe OR *\\cmd.exe OR *\\rundll32.exe OR *\\mshta.exe OR *\\wscript.exe OR *\\cscript.exe OR *\\regsvr32.exe) AND (Image:(*\\Users\\* OR *\\AppData\\* OR *\\Temp\\* OR *\\Downloads\\*)) AND (CommandLine:(*FromBase64String* OR *IEX* OR *Invoke-Expression* OR *-enc* OR *EncodedCommand* OR *http://* OR *https://*)))

## Step B (Credential-store access)
((TargetFilename:(*\\AppData\\Local\\Google\\Chrome\\User\ Data\\*\\Login\ Data OR *\\AppData\\Local\\Google\\Chrome\\User\ Data\\*\\Cookies OR *\\AppData\\Local\\Microsoft\\Edge\\User\ Data\\*\\Login\ Data OR *\\AppData\\Local\\Microsoft\\Edge\\User\ Data\\*\\Cookies OR *\\AppData\\Roaming\\Mozilla\\Firefox\\Profiles\\*\\key4.db OR *\\AppData\\Roaming\\Mozilla\\Firefox\\Profiles\\*\\logins.json) AND NOT Image:(*\\chrome.exe OR *\\msedge.exe OR *\\firefox.exe)))

## Step C (Public egress)
(Image:(*\\powershell.exe OR *\\pwsh.exe OR *\\rundll32.exe OR *\\mshta.exe OR *\\wscript.exe OR *\\cscript.exe OR *\\regsvr32.exe) AND DestinationIp:(NOT 10.* AND NOT 192.168.* AND NOT 172.16.* AND NOT 172.17.* AND NOT 172.18.* AND NOT 172.19.* AND NOT 172.2* AND NOT 172.30.* AND NOT 172.31.* AND NOT 127.*))

## Analyst workflow
1) Run Step A → capture Hostname + User + timeframe
2) Pivot Step B (same Host/User) within ±10 minutes
3) Pivot Step C (same Host/User) within ±10 minutes
If B and C confirm → Incident Confirmed (Infostealer).
