\
# Dashboard – Infostealer Exposure (OpenSearch / Kibana-like)

## Panel 1 – Suspicious LOLBin execution from user-writable paths
IntegrityLevel:System OR (Image:(*\\powershell.exe OR *\\pwsh.exe OR *\\cmd.exe OR *\\rundll32.exe OR *\\mshta.exe OR *\\wscript.exe OR *\\cscript.exe OR *\\regsvr32.exe) AND (Image:(*\\Users\\* OR *\\AppData\\* OR *\\Temp\\* OR *\\Downloads\\*)))

## Panel 2 – Non-browser process accessing Chrome/Edge credential DB
(TargetFilename:(*\\AppData\\Local\\Google\\Chrome\\User\ Data\\*\\Login\ Data OR *\\AppData\\Local\\Google\\Chrome\\User\ Data\\*\\Cookies OR *\\AppData\\Local\\Microsoft\\Edge\\User\ Data\\*\\Login\ Data OR *\\AppData\\Local\\Microsoft\\Edge\\User\ Data\\*\\Cookies) AND NOT Image:(*\\chrome.exe OR *\\msedge.exe))

## Panel 3 – Non-browser process accessing Firefox credential DB
(TargetFilename:(*\\AppData\\Roaming\\Mozilla\\Firefox\\Profiles\\*\\key4.db OR *\\AppData\\Roaming\\Mozilla\\Firefox\\Profiles\\*\\logins.json) AND NOT Image:*\\firefox.exe)

## Panel 4 – Suspicious external egress from LOLBins (public IP)
(Image:(*\\powershell.exe OR *\\pwsh.exe OR *\\rundll32.exe OR *\\mshta.exe OR *\\wscript.exe OR *\\cscript.exe) AND DestinationIp:(NOT 10.* AND NOT 192.168.* AND NOT 172.16.* AND NOT 172.17.* AND NOT 172.18.* AND NOT 172.19.* AND NOT 172.2* AND NOT 172.30.* AND NOT 172.31.* AND NOT 127.*))
