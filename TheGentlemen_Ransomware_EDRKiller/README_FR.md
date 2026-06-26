# TheGentlemen Ransomware, Pack de Détection EDR Killer
👉🏾 [English version available here](README.md)


> Note lab et SIEM : /labs contient uniquement des PoC bénins en local et des logs synthétiques. Valider la normalisation des champs avant déploiement ; ces détections supposent un mapping des champs Sysmon, Security, proxy, DNS ou web selon le pack.

Résumé de la menace

**TheGentlemen** est une opération de Ransomware-as-a-Service (RaaS) qui déploie plusieurs frameworks
EDR killer personnalisés pour aveugler les défenses de sécurité avant de lancer le chiffrement.
L'outil principal, **GentleKiller**, existe en au moins huit variantes et se fait passer pour des
logiciels de sécurité légitimes (Kaspersky, WatchDog, Javelin) ou des logiciels de jeu (Valorant/Vanguard).

Les outils complémentaires incluent **HexKiller** (lié au gang Warlock), **ThrottleBlood** (lié à
MesudaLocker et DragonForce), **HavocKiller**, et **OxideHarvest** (stealer Rust-based).

### TTPs principaux

| TTP | Détail |
|---|---|
| BYOVD | Accès noyau via des pilotes vulnérables, framework conçu pour l'échange facile de pilotes |
| Signatures volées | Les pilotes apparaissent signés (Signed=true) mais portent des certificats expirés/révoqués |
| Packing | Binaires protégés avec Enigma et Themida pour échapper à l'analyse statique |
| Impersonnation | Exécutables nommés d'après des produits de sécurité/jeu, déposés dans Temp/AppData |
| Terminaison massive | 400+ processus de 48 vendors (Microsoft, CrowdStrike, SentinelOne, Palo Alto, Sophos, ESET…) |
| Vol de credentials | OxideHarvest (Rust) pour la collecte d'identifiants |
| Proxy C2 | Botnet SystemBC (1 570+ victimes entreprises) |

### Accès initial

Lié à l'exploitation de credentials FortiGate issus de la fuite FortiBleed (74 000 identifiants VPN).

---

## Stratégie de détection

### BROAD - Terminaison de processus de sécurité
**Fichier :** [`windows_gentlemen_edr_security_process_termination_broad.yml`](./rules/windows_gentlemen_edr_security_process_termination_broad.yml)

Détecte `taskkill /F /IM`, `sc stop` ou `net stop` ciblant des processus et services de sécurité
connus chez 48 vendors. Faux positifs attendus de l'administration IT légitime. À utiliser pour
la chasse aux menaces et le triage L1.

### BROAD - Chargement de pilote BYOVD (nom + hash)
**Fichier :** [`driver_load_win_gentlemen_byovd_edr_killer_broad.yml`](./rules/driver_load_win_gentlemen_byovd_edr_killer_broad.yml)

Détecte les chargements de pilotes noyau correspondant aux noms de fichiers BYOVD connus de
TheGentlemen (eb.sys, nseckrnl.sys, vgk.sys échantillon malveillant, ThrottleBlood.sys, havoc.sys,
etc.) ou aux hash SHA-1 connus (12 échantillons confirmés). Deux branches de détection :
- **Branche nom :** large couverture, filtrée pour les chemins d'installation légitimes connus (Riot Vanguard, Program Files)
- **Branche hash :** haute confiance, non affectée par les filtres de chemin

> Zone aveugle : si l'acteur renomme le pilote et recompile, les deux branches sont contournées
> simultanément. La règle de corrélation comportementale est la seule couverture résistante à
> cette évasion.

### STRICT - Staging GentleKiller et hash connus
**Fichier :** [`proc_creation_win_gentlemen_edr_killer_gentlemencollection_strict.yml`](./rules/proc_creation_win_gentlemen_edr_killer_gentlemencollection_strict.yml)

Détecte l'exécution de binaires EDR killer TheGentlemen via deux branches :
- **Chemin de staging :** toute image exécutée depuis `\GentlemenCollection\` - le répertoire
  de staging invariant de l'acteur, observé de manière constante dans des intrusions non liées
- **Branche hash :** 13 hash SHA-1 connus (Kasps.exe, FaceIT1.exe, Valorant2.exe, Symantec.exe,
  Avast.exe / HexKiller, Sent.exe / ThrottleBlood, Sophos.exe / HavocKiller, etc.)

Si cette règle se déclenche, traiter comme une intrusion TheGentlemen active en phase d'évasion ;
le chiffrement est imminent. Isoler l'hôte immédiatement.

> Note : le champ `Hashes` n'est peuplé que par Sysmon Event 1, pas par Windows Security Event
> 4688. Sans Sysmon, seule la branche chemin de staging est active.

### STRICT - Impersonation GentleKiller
**Fichier :** [`windows_gentlemen_edr_killer_impersonation_strict.yml`](./rules/windows_gentlemen_edr_killer_impersonation_strict.yml)

Détecte :
- Les noms explicites d'outils EDR killer (GentleKiller, HexKiller, ThrottleBlood, HavocKiller, OxideHarvest), tout chemin
- L'impersonation de noms de produits de sécurité/jeu depuis des chemins accessibles en écriture (Temp, AppData, ProgramData, Downloads)

Les chemins légitimes des vendors sont filtrés. Une alerte sur cette règle doit être investiguée immédiatement.

### STRICT - BYOVD avec signature invalide
**Fichier :** [`windows_gentlemen_byovd_invalid_signature_driver_strict.yml`](./rules/windows_gentlemen_byovd_invalid_signature_driver_strict.yml)

Détecte les pilotes chargés depuis des chemins non-système portant un certificat invalide
(Expired, Revoked, NotTrusted). Couvre toutes les variantes TheGentlemen indépendamment du pilote
utilisé - le pattern de signature volée est constant dans l'ensemble du framework.

### Building block - Accès aux processus de sécurité (alimente la corrélation)
**Fichier :** [`win_gentlemen_mass_security_process_termination_correlation.yml`](./rules/win_gentlemen_mass_security_process_termination_correlation.yml) *(premier document)*

Building block informatif (niveau : informational). Détecte tout processus ouvrant un handle
vers un processus de produit de sécurité connu via Sysmon Event 10 (ProcessAccess). Non
actionnable seul ; existe uniquement pour alimenter la corrélation de terminaison massive.
Résistant au renommage de l'outil car il cible les processus de SÉCURITÉ visés, pas le binaire attaquant.

> Nécessite une configuration explicite de ProcessAccess dans Sysmon - non journalisé par défaut.
> Exemple : `<ProcessAccess onmatch="include"><TargetImage condition="end with">MsMpEng.exe</TargetImage></ProcessAccess>`

### Corrélation - Terminaison massive de processus de sécurité
**Fichier :** [`win_gentlemen_mass_security_process_termination_correlation.yml`](./rules/win_gentlemen_mass_security_process_termination_correlation.yml) *(deuxième document)*

Corrélation comportementale (type `value_count` Sigma) qui se déclenche lorsqu'un **seul
processus accède à ≥ 8 processus de produits de sécurité distincts en 1 minute** - le
comportement central de GentleKiller, qui termine 400+ processus de ~48 vendors en boucle.
Groupée par `SourceImage`, `SourceProcessId` et `Computer`.

C'est la **règle la plus résistante à l'évasion du pack** : elle survit aux changements de
pilote, au repackaging des binaires et au renommage des outils car elle cible uniquement le
comportement de kill, pas les artefacts fichiers.

> Calibrer le seuil (défaut : 8) à 50–75 % du nombre de processus de sécurité distincts
> dans l'environnement. Abaisser à 4–5 pour les stacks minimaux.

---

## Règles Sigma

| Fichier | Niveau | Sévérité | Source de logs |
|---|---|---|---|
| `windows_gentlemen_edr_security_process_termination_broad.yml` | BROAD | medium | windows/process_creation |
| `driver_load_win_gentlemen_byovd_edr_killer_broad.yml` | BROAD | medium | windows/driver_load |
| `proc_creation_win_gentlemen_edr_killer_gentlemencollection_strict.yml` | STRICT | high | windows/process_creation |
| `windows_gentlemen_edr_killer_impersonation_strict.yml` | STRICT | high | windows/process_creation |
| `windows_gentlemen_byovd_invalid_signature_driver_strict.yml` | STRICT | high | windows/driver_load |
| `win_gentlemen_mass_security_process_termination_correlation.yml` | Building block | informational | windows/process_access |
| `win_gentlemen_mass_security_process_termination_correlation.yml` | Corrélation | high | - (value_count) |

---

## Sources de logs requises

| Règle | Logs requis |
|---|---|
| Terminaison de processus BROAD | Windows Security Event 4688 ou Sysmon Event 1 |
| Chargement pilote BYOVD BROAD | **Sysmon Event 6** (DriverLoad) |
| Staging GentleKiller STRICT | Windows Security Event 4688 ou Sysmon Event 1 (Sysmon requis pour la branche hash) |
| Impersonation STRICT | Windows Security Event 4688 ou Sysmon Event 1 |
| BYOVD signature invalide STRICT | **Sysmon Event 6** (DriverLoad) |
| Building block | **Sysmon Event 10** (ProcessAccess), doit être explicitement configuré |
| Corrélation | Nécessite les événements du building block |

> Les deux règles BYOVD nécessitent Sysmon avec les événements `DriverLoad` (Event ID 6).
> Le building block et la corrélation nécessitent Sysmon avec les événements `ProcessAccess`
> (Event ID 10) explicitement configurés pour les images cibles des produits de sécurité.

---

## Mapping MITRE ATT&CK

| Technique | ID | Règle |
|---|---|---|
| Compromettre les défenses : désactiver les outils | T1562.001 | Toutes |
| Arrêt de service | T1489 | Terminaison processus BROAD |
| Mascarade : nom légitime | T1036.005 | Impersonation STRICT |
| Mascarade | T1036 | Staging STRICT (binaires GentlemenCollection imitent des noms vendor) |
| Exploitation pour l'élévation de privilèges | T1068 | Règles BYOVD |
| Rootkit | T1014 | Chargement pilote BYOVD BROAD (capacité de dissimulation noyau) |

---

## Faux positifs

### BROAD - Terminaison de processus
- Administrateur IT arrêtant un service de sécurité (valider avec ticket de changement)
- Auto-mise à jour EDR arrêtant temporairement son propre service (vérifier ParentImage)
- Outils de gestion de patches (SCCM, Intune, PDQ), partiellement filtrés

### BROAD - Chargement pilote BYOVD
- `vgk.sys` sur endpoints de gaming (Riot Vanguard), filtré pour le chemin d'installation légitime ; les hits par hash ne sont pas affectés
- `GameDriverX64.sys` et `dmx.sys` depuis Program Files (aucun hash TheGentlemen confirmé), filtrés
- Red team autorisé ou recherche BYOVD en lab contrôlé

### STRICT - Staging GentleKiller
- Extrêmement improbable - un chemin contenant `\GentlemenCollection\` n'a aucun usage légitime plausible
- Échantillons soumis volontairement à un sandbox interne (vérifier le contexte hôte et utilisateur)

### STRICT - Impersonation
- Pratiquement aucun pour les noms explicites de killers
- Un logiciel de sécurité légitime ne s'exécute jamais depuis Temp/AppData

### STRICT - BYOVD avec signature invalide
- Pilotes vendor avec certificats récemment expirés dans des chemins non-standard (rare)
- Environnements de développement/lab testant la signature de pilotes

### Building block et corrélation
- Outils de gestion ou d'inventaire endpoint énumérant légitimement les processus (ajouter à `filter_legit_sources`)
- Produits de sécurité s'inspectant mutuellement - ajuster `filter_legit_sources` à son stack

---

## Ajustement des règles

1. **Allowlist des parents d'outils de gestion** dans la règle BROAD de terminaison : ajouter SCCM/Intune/PDQ à `filter_main_legitimate_mgmt`
2. **Ajuster le seuil de corrélation** (défaut : 8) à 50–75 % des processus de sécurité distincts dans l'environnement
3. **Allowlist de l'AC interne** pour la règle BYOVD signature invalide si l'org utilise une AC interne dont les certs apparaissent comme NotTrusted sur les endpoints
4. **Activer Sysmon Event 6** pour les deux règles BYOVD ; vérifier avec `sysmon -c` que les événements `DriverLoad` sont capturés
5. **Configurer Sysmon ProcessAccess** pour les images cibles des produits de sécurité afin d'activer le building block et la corrélation
6. **Corréler** dans une fenêtre de 10 minutes : chargement pilote BYOVD + staging GentlemenCollection + corrélation terminaison massive = attribution TheGentlemen haute confiance

---

## Triage SOC

1. **Vérifier ParentImage** sur les alertes de terminaison - les EDR killers sont lancés depuis un dropper, pas msiexec ou des outils de gestion
2. **Vérifier IntegrityLevel** - BYOVD et killers noyau requièrent un niveau d'intégrité High ou System
3. **Vérifier le hash de l'image** sur VirusTotal pour les alertes d'impersonation et de staging
4. **Vérifier SignatureStatus** du pilote - les certificats révoqués peuvent être confirmés via `sigcheck -tv`
5. **Vérifier SourceProcessId** sur les alertes de corrélation - si GentleKiller a injecté dans un processus légitime (process hollowing), SourceImage affiche un nom bénin mais SourceProcessId révèle le thread malveillant réel
6. **Isoler immédiatement** si BYOVD + staging (GentlemenCollection) + corrélation se déclenchent ensemble sur le même hôte

---

## Références

- [BleepingComputer, TheGentlemen Ransomware EDR Killers](https://www.bleepingcomputer.com/news/security/gentlemen-ransomware-uses-multiple-edr-killers-to-disable-defenses/)
- [MITRE T1562.001, Compromettre les défenses](https://attack.mitre.org/techniques/T1562/001/)
- [MITRE T1068, Exploitation pour élévation de privilèges](https://attack.mitre.org/techniques/T1068/)
- [MITRE T1036.005, Mascarade : nom légitime](https://attack.mitre.org/techniques/T1036/005/)
