# Microsoft Defender for Endpoint (MDE) - Détection des Infostealers (Approche EDR-first)

Ce document présente des requêtes **KQL** destinées à Microsoft Defender for Endpoint (MDE) afin de détecter des **comportements typiques d’infostealers** sur les endpoints Windows.  
L’approche est **EDR-first**, orientée détection comportementale et corrélation.

---

## 1) Processus suspects lancés depuis des emplacements accessibles en écriture par l’utilisateur

Cette requête identifie des **LOLBins / loaders** exécutés depuis des répertoires utilisateurs tels que *AppData*, *Temp* ou *Downloads*.

```kusto
DeviceProcessEvents
| where Timestamp > ago(7d)
| where FolderPath has_any (@'\AppData\', @'\Temp\', @'\Downloads\')
| where FileName in~ ('powershell.exe','pwsh.exe','cmd.exe','rundll32.exe','mshta.exe','wscript.exe','cscript.exe','regsvr32.exe')
| project Timestamp, DeviceName, AccountName, FileName, FolderPath, ProcessCommandLine, InitiatingProcessFileName, InitiatingProcessCommandLine
| order by Timestamp desc
```

📌 **Lecture SOC**  
- Signal précoce (BROAD)  
- Indique une exécution potentiellement malveillante  
- À corréler avec des accès aux identifiants ou une activité réseau

---

## 2) Accès potentiel aux stockages d’identifiants navigateur (Chromium / Firefox) par un processus non-navigateur

Cette requête détecte des **processus suspects accédant aux bases d’identifiants navigateur**, en excluant les navigateurs légitimes.

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

📌 **Lecture SOC**  
- Signal fort (STRICT)  
- Indique un **vol d’identifiants navigateur en cours ou réalisé**  
- À traiter comme une alerte critique si confirmée

---

## 3) Corrélation haute confiance : exécution suspecte + accès aux identifiants dans une fenêtre de 10 minutes

Cette requête corrèle une **exécution suspecte** avec un **accès aux stockages d’identifiants navigateur** sur le même endpoint.

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

📌 **Lecture SOC**  
- Détection corrélée à **haute confiance**  
- Correspond à une **activité infostealer avérée**  
- Déclenchement recommandé d’un playbook IR

---

## 4) Optionnel : communication réseau sortante suspecte depuis des LOLBins

Cette requête met en évidence des **connexions réseau sortantes vers Internet** initiées par des LOLBins.

```kusto
DeviceNetworkEvents
| where Timestamp > ago(7d)
| where InitiatingProcessFileName in~ ('powershell.exe','pwsh.exe','rundll32.exe','mshta.exe','wscript.exe','cscript.exe')
| where RemoteIPType == "Public"
| project Timestamp, DeviceName, InitiatingProcessAccountName, InitiatingProcessFileName, InitiatingProcessCommandLine, RemoteUrl, RemoteIP, RemotePort
| order by Timestamp desc
```

📌 **Lecture SOC**  
- Signal SUPPORT  
- Indique une **exfiltration potentielle ou une communication C2**  
- À corréler avec les étapes 1 et 2

---

## 🔐 Conclusion SOC

- **Étape 1 seule** → suspicion / hunting  
- **Étape 2 seule** → vol d’identifiants probable  
- **Étapes 1 + 2** → infostealer très probable  
- **Étapes 1 + 2 + 4** → **activité infostealer confirmée**  

👉 Action recommandée : **isolement du poste, réinitialisation des identifiants, investigation approfondie**.
