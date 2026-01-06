# Microsoft Defender for Endpoint (MDE) – Infostealer Detection (EDR-first)

## 1) Suspicious process started from user-writable locations
```kusto
DeviceProcessEvents
| where Timestamp > ago(7d)
| where FolderPath has_any (@'\AppData\', @'\Temp\', @'\Downloads\')
| where FileName in~ ('powershell.exe','pwsh.exe','cmd.exe','rundll32.exe','mshta.exe','wscript.exe','cscript.exe','regsvr32.exe')
| project Timestamp, DeviceName, AccountName, FileName, FolderPath, ProcessCommandLine, InitiatingProcessFileName, InitiatingProcessCommandLine
| order by Timestamp desc
```

## 2) Potential browser credential store access (Chromium/Firefox) by non-browser process
```kusto
DeviceFileEvents
| where Timestamp > ago(7d)
| where FolderPath has_any (
  @'\AppData\Local\Google\Chrome\User Data\',
  @'\AppData\Local\Microsoft\Edge\User Data\',
  @'\AppData\Roaming\Mozilla\Firefox\Profiles\'
)
| where FileName in~ ('Login Data','Cookies','key4.db','logins.json')
| where InitiatingProcessFileName !in~ ('chrome.exe','msedge.exe','firefox.exe')
| project Timestamp, DeviceName, InitiatingProcessAccountName, InitiatingProcessFileName, InitiatingProcessFolderPath, InitiatingProcessCommandLine, FolderPath, FileName
| order by Timestamp desc
```

## 3) Correlation (high confidence): suspicious execution + credential store access within 10 minutes
```kusto
let suspicious_exec =
DeviceProcessEvents
| where Timestamp > ago(7d)
| where FolderPath has_any (@'\AppData\', @'\Temp\', @'\Downloads\')
| where FileName in~ ('powershell.exe','pwsh.exe','cmd.exe','rundll32.exe','mshta.exe','wscript.exe','cscript.exe','regsvr32.exe')
| project DeviceId, DeviceName, AccountName, ExecTime=Timestamp, Proc=FileName, Cmd=ProcessCommandLine;
let cred_access =
DeviceFileEvents
| where Timestamp > ago(7d)
| where FolderPath has_any (
  @'\AppData\Local\Google\Chrome\User Data\',
  @'\AppData\Local\Microsoft\Edge\User Data\',
  @'\AppData\Roaming\Mozilla\Firefox\Profiles\'
)
| where FileName in~ ('Login Data','Cookies','key4.db','logins.json')
| where InitiatingProcessFileName !in~ ('chrome.exe','msedge.exe','firefox.exe')
| project DeviceId, AccessTime=Timestamp, AccessProc=InitiatingProcessFileName, AccessCmd=InitiatingProcessCommandLine, FileName, FolderPath;
suspicious_exec
| join kind=inner cred_access on DeviceId
| where AccessTime between (ExecTime .. ExecTime + 10m)
| project ExecTime, AccessTime, DeviceName, AccountName, Proc, Cmd, AccessProc, AccessCmd, FileName, FolderPath
| order by AccessTime desc
```

## 4) Optional: suspicious external egress from LOLBins
```kusto
DeviceNetworkEvents
| where Timestamp > ago(7d)
| where InitiatingProcessFileName in~ ('powershell.exe','pwsh.exe','rundll32.exe','mshta.exe','wscript.exe','cscript.exe')
| where RemoteIPType == "Public"
| project Timestamp, DeviceName, InitiatingProcessAccountName, InitiatingProcessFileName, InitiatingProcessCommandLine, RemoteUrl, RemoteIP, RemotePort
| order by Timestamp desc
```
