# Détection Infostealer Sysmon - BROAD / STRICT / SUPPORT

## Vue d’ensemble
Cet ensemble de trois règles Sigma met en œuvre un modèle de détection progressif et corrélé des infostealers sur les endpoints Windows à partir des logs Sysmon.

Les règles sont complémentaires :
- BROAD fournit un signal précoce d’exécution suspecte
- STRICT détecte le vol d’identifiants avec haute confiance
- SUPPORT confirme la communication réseau externe

Ensemble, elles permettent de passer de la suspicion à une compromission confirmée.

## Rôle des règles

### Règle 1 - BROAD (Exécution – Alerte précoce)
Détecte l’exécution de loaders ou LOLBins (PowerShell, cmd, mshta, rundll32, etc.) depuis des répertoires accessibles en écriture par l’utilisateur (AppData, Temp, Downloads, Users).

**Lecture SOC :**
- Signal faible pris isolément
- Utile pour la chasse et la mise en contexte
- Étape 1 de la corrélation

MITRE ATT&CK : T1059

### Règle 2 - STRICT (Vol d’identifiants)
Détecte des processus non-navigateur accédant aux stockages d’identifiants :
- Chrome / Edge : Login Data, Cookies
- Firefox : key4.db, logins.json

Ce comportement est un indicateur fort de compromission.

**Lecture SOC :**
- Détection à haute confiance
- Critique lorsqu’elle est corrélée

MITRE ATT&CK : T1555

### Règle 3 - SUPPORT (Sortie réseau)
Détecte des connexions réseau sortantes vers Internet initiées par des LOLBins, en excluant les plages d’adresses privées.

Lecture SOC :
- Indique une exfiltration ou une communication C2 possible
- À utiliser en corrélation

MITRE ATT&CK : T1071.001

## Logique de corrélation recommandée

- BROAD seule : Exécution suspecte, surveillance
- STRICT seule : Vol d’identifiants probable, investigation
- STRICT + SUPPORT : Infostealer très probable
- BROAD + STRICT + SUPPORT : Activité infostealer confirmée

## Usage SOC & Réponse à incident
Lorsque les trois règles sont observées dans une fenêtre temporelle courte :
- Considérer le poste comme compromis
- Isoler l’endpoint
- Réinitialiser les identifiants
- Évaluer l’exfiltration de données
- Lancer une phase de threat hunting

