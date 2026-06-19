# Gentlemen Ransomware, EDR Killer Detection Pack

## Threat Summary

**Gentlemen** is a Ransomware-as-a-Service (RaaS) operation that deploys multiple custom EDR killer
frameworks to blind security defenses before deploying ransomware. The group's primary tool,
**GentleKiller**, exists in at least eight variants and impersonates legitimate security products
(Kaspersky, WatchDog, Javelin) and gaming software (Valorant/Vanguard) to avoid suspicion.

Companion tools include **HexKiller** (linked to the Warlock gang), **ThrottleBlood** (linked to
MesudaLocker and DragonForce), **HavocKiller**, and **OxideHarvest** (a Rust-based credential
stealer).

### Key TTPs

| TTP | Detail |
|---|---|
| BYOVD | Kernel-level access via vulnerable drivers, framework designed for easy driver swapping between variants |
| Stolen signatures | Drivers appear signed (Signed=true) but carry expired/revoked certificates from legitimate software |
| Packing | Binaries protected with Enigma and Themida to evade static analysis |
| Impersonation | Executables named after security/gaming products, dropped in Temp/AppData |
| Mass termination | 400+ processes across 48 security vendors (Microsoft, CrowdStrike, SentinelOne, Palo Alto, Sophos, ESET, Bitdefender, Kaspersky, Trellix, Carbon Black…) |
| Credential theft | OxideHarvest Rust-based stealer for credential harvesting |
| Proxy C2 | SystemBC proxy malware botnet (1,570+ corporate victims) |

### Initial Access

Linked to exploitation of FortiGate credentials from the FortiBleed leak (74,000 VPN credentials).

---

## Detection Strategy

### BROAD, Security Process Termination
**File:** `windows_gentlemen_edr_security_process_termination_broad.yml`

Detects `taskkill /F /IM`, `sc stop`, or `net stop` targeting known security product processes
and services across 48 vendors. False positives are expected from legitimate IT administration.
Use for hunting and L1 triage. Correlate with STRICT rules for confirmation.

### STRICT, GentleKiller Impersonation
**File:** `windows_gentlemen_edr_killer_impersonation_strict.yml`

Detects:
- Explicit EDR killer tool names (GentleKiller, HexKiller, ThrottleBlood, HavocKiller, OxideHarvest), any path
- Security/gaming product name impersonation from user-writable paths (Temp, AppData, ProgramData, Downloads)

Legitimate vendor paths are filtered. Alert on this rule warrants immediate investigation.

### STRICT, BYOVD with Invalid Signature
**File:** `windows_gentlemen_byovd_invalid_signature_driver_strict.yml`

Detects kernel drivers loaded from non-system paths that carry a valid-looking but invalid
certificate (Expired, Revoked, NotTrusted). This covers all Gentlemen EDR killer variants
regardless of the specific driver used, the stolen signature pattern is consistent across
the framework.

---

## Sigma Rules

| File | Tier | Level | Logsource |
|---|---|---|---|
| `windows_gentlemen_edr_security_process_termination_broad.yml` | BROAD | medium | windows/process_creation |
| `windows_gentlemen_edr_killer_impersonation_strict.yml` | STRICT | high | windows/process_creation |
| `windows_gentlemen_byovd_invalid_signature_driver_strict.yml` | STRICT | high | windows/driver_load |

---

## Log Sources Required

| Rule | Required logs |
|---|---|
| Process termination BROAD | Windows Security Event 4688 or Sysmon Event 1 |
| Impersonation STRICT | Windows Security Event 4688 or Sysmon Event 1 |
| BYOVD STRICT | **Sysmon Event 6** (DriverLoad), requires Sysmon with driver_load category |

> The BYOVD rule requires Sysmon configured to log driver load events (Event ID 6). Without
> Sysmon or an equivalent EDR telemetry source, this rule will not fire.

---

## MITRE ATT&CK Mapping

| Technique | ID | Rule |
|---|---|---|
| Impair Defenses: Disable or Modify Tools | T1562.001 | All |
| Service Stop | T1489 | BROAD |
| Masquerading: Match Legitimate Name | T1036.005 | STRICT impersonation |
| Exploitation for Privilege Escalation | T1068 | STRICT BYOVD |

---

## False Positives

### BROAD
- IT admin stopping a security service (validate change ticket)
- EDR self-update temporarily stopping its own service (check ParentImage)
- Patch management tools (SCCM, Intune, PDQ), partially filtered

### STRICT, Impersonation
- Virtually none for explicit killer names
- Legitimate security software should never run from Temp/AppData

### STRICT, BYOVD Driver
- Vendor drivers with recently expired certificates in non-standard paths (rare)
- Development/lab environments testing driver signing

---

## Tuning Guidance

1. **Allowlist management tool parents** in the BROAD rule: add your SCCM/Intune/PDQ parent images to `filter_main_legitimate_mgmt`
2. **Allowlist internal CA** for the BYOVD rule: if your org uses an internal CA whose certificates may show as NotTrusted on endpoints, add the cert thumbprint or adjust the filter
3. **Sysmon Event 6** must be enabled for BYOVD detection, verify with `sysmon -c` that `DriverLoad` events are captured
4. **Correlate** BROAD termination alerts with STRICT impersonation/BYOVD within a 10-minute window for highest confidence

---

## SOC Triage Steps

1. **Check ParentImage** on process termination alerts, EDR killers are typically launched from a dropper, not from msiexec or management tools
2. **Check IntegrityLevel**, BYOVD and kernel-level EDR killers require High or System integrity
3. **Check image hash** against VirusTotal for impersonation alerts
4. **Check driver SignatureStatus** details, revoked certificates can be verified via `sigcheck -tv` on the binary
5. **Isolate immediately** if BYOVD + impersonation fire together on the same host within a short window

---

## References

- [BleepingComputer, Gentlemen Ransomware EDR Killers](https://www.bleepingcomputer.com/news/security/gentlemen-ransomware-uses-multiple-edr-killers-to-disable-defenses/)
- [MITRE T1562.001, Impair Defenses](https://attack.mitre.org/techniques/T1562/001/)
- [MITRE T1068, Exploitation for Privilege Escalation](https://attack.mitre.org/techniques/T1068/)
- [MITRE T1036.005, Masquerading: Match Legitimate Name](https://attack.mitre.org/techniques/T1036/005/)
