# Gentlemen Ransomware, Pack de Détection EDR Killer
[👉🏾 **English version available here**](README.md)

## Résumé de la menace

**Gentlemen** est une opération de Ransomware-as-a-Service (RaaS) qui déploie plusieurs frameworks
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

### BROAD, Terminaison de processus de sécurité
**Fichier :** `windows_gentlemen_edr_security_process_termination_broad.yml`

Détecte `taskkill /F /IM`, `sc stop` ou `net stop` ciblant des processus et services de sécurité
connus chez 48 vendors. Faux positifs attendus de l'administration IT légitime. À utiliser pour
la chasse aux menaces et le triage L1.

### STRICT, impersonnation GentleKiller
**Fichier :** `windows_gentlemen_edr_killer_impersonation_strict.yml`

Détecte :
- Les noms explicites d'outils EDR killer (GentleKiller, HexKiller, ThrottleBlood, HavocKiller, OxideHarvest), tout chemin
- L'impersonnation de noms de produits depuis des chemins accessibles en écriture (Temp, AppData, ProgramData, Downloads)

Les chemins légitimes des vendors sont filtrés. Une alerte sur cette règle doit être investiguée immédiatement.

### STRICT, BYOVD avec signature invalide
**Fichier :** `windows_gentlemen_byovd_invalid_signature_driver_strict.yml`

Détecte les pilotes chargés depuis des chemins non-système portant un certificat invalide
(Expired, Revoked, NotTrusted). Couvre toutes les variantes Gentlemen indépendamment du pilote
utilisé, le pattern de signature volée est constant dans le framework.

---

## Règles Sigma

| Fichier | Niveau | Sévérité | Source de logs |
|---|---|---|---|
| `windows_gentlemen_edr_security_process_termination_broad.yml` | BROAD | medium | windows/process_creation |
| `windows_gentlemen_edr_killer_impersonation_strict.yml` | STRICT | high | windows/process_creation |
| `windows_gentlemen_byovd_invalid_signature_driver_strict.yml` | STRICT | high | windows/driver_load |

---

## Sources de logs requises

| Règle | Logs requis |
|---|---|
| Terminaison de processus BROAD | Windows Security Event 4688 ou Sysmon Event 1 |
| Impersonnation STRICT | Windows Security Event 4688 ou Sysmon Event 1 |
| BYOVD STRICT | **Sysmon Event 6** (DriverLoad), nécessite Sysmon avec la catégorie driver_load |

> La règle BYOVD nécessite Sysmon configuré pour journaliser les événements de chargement de
> pilotes (Event ID 6). Sans Sysmon ou une source EDR équivalente, cette règle ne se déclenchera pas.

---

## Mapping MITRE ATT&CK

| Technique | ID | Règle |
|---|---|---|
| Compromettre les défenses : Désactiver les outils | T1562.001 | Toutes |
| Arrêt de service | T1489 | BROAD |
| Mascarade : Nom légitime | T1036.005 | STRICT impersonnation |
| Exploitation pour l'élévation de privilèges | T1068 | STRICT BYOVD |

---

## Faux positifs

### BROAD
- Administrateur IT arrêtant un service de sécurité (valider avec ticket de changement)
- Auto-mise à jour EDR arrêtant temporairement son propre service (vérifier ParentImage)
- Outils de gestion de patches (SCCM, Intune, PDQ), partiellement filtrés

### STRICT, Impersonnation
- Pratiquement aucun pour les noms explicites de killers
- Un logiciel de sécurité légitime ne s'exécute jamais depuis Temp/AppData

### STRICT, BYOVD avec signature invalide
- Pilotes vendor avec certificats récemment expirés dans des chemins non-standard (rare)
- Environnements de développement/lab testant la signature de pilotes

---

## Triage SOC

1. **Vérifier ParentImage** sur les alertes de terminaison, les EDR killers sont typiquement lancés depuis un dropper, pas depuis msiexec ou des outils de gestion
2. **Vérifier IntegrityLevel**, BYOVD et killers noyau requièrent un niveau d'intégrité High ou System
3. **Vérifier le hash de l'image** sur VirusTotal pour les alertes d'impersonnation
4. **Vérifier SignatureStatus** du pilote, les certificats révoqués peuvent être confirmés via `sigcheck -tv`
5. **Isoler immédiatement** si BYOVD + impersonnation se déclenchent ensemble sur le même hôte dans une courte fenêtre temporelle

---

## Références

- [BleepingComputer, Gentlemen Ransomware EDR Killers](https://www.bleepingcomputer.com/news/security/gentlemen-ransomware-uses-multiple-edr-killers-to-disable-defenses/)
- [MITRE T1562.001, Compromettre les défenses](https://attack.mitre.org/techniques/T1562/001/)
- [MITRE T1068, Exploitation pour élévation de privilèges](https://attack.mitre.org/techniques/T1068/)
- [MITRE T1036.005, Mascarade : nom légitime](https://attack.mitre.org/techniques/T1036/005/)
