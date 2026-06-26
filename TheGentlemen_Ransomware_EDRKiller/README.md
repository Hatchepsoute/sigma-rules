# TheGentlemen Ransomware, EDR Killer Detection Pack
👉🏾 [French version available here](README_FR.md)


Threat summary

**TheGentlemen** is a Ransomware-as-a-Service (RaaS) operation that deploys multiple custom EDR killer
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

### Initial access

Linked to exploitation of FortiGate credentials from the FortiBleed leak (74,000 VPN credentials).

---

## Detection strategy

### BROAD - Security process termination
**File:** [`windows_gentlemen_edr_security_process_termination_broad.yml`](./rules/windows_gentlemen_edr_security_process_termination_broad.yml)

Detects `taskkill /F /IM`, `sc stop`, or `net stop` targeting known security product processes
and services across 48 vendors. False positives are expected from legitimate IT administration.
Use for hunting and L1 triage. Correlate with STRICT rules for confirmation.

### BROAD - BYOVD driver load (name + hash)
**File:** [`driver_load_win_gentlemen_byovd_edr_killer_broad.yml`](./rules/driver_load_win_gentlemen_byovd_edr_killer_broad.yml)

Detects kernel driver loads matching known TheGentlemen BYOVD filenames (eb.sys, nseckrnl.sys,
vgk.sys malicious sample, ThrottleBlood.sys, havoc.sys, etc.) or known SHA-1 hashes (12
confirmed samples). Two detection branches:
- **Name branch:** broad, filtered for known legitimate install paths (Riot Vanguard, Program Files)
- **Hash branch:** high confidence, not affected by path filters

> Blind spot: if the actor renames the driver and recompiles, both branches are evaded simultaneously.
> The behavioral correlation rule is the only coverage resilient to this evasion.

### STRICT - GentleKiller staging path and known hashes
**File:** [`proc_creation_win_gentlemen_edr_killer_gentlemencollection_strict.yml`](./rules/proc_creation_win_gentlemen_edr_killer_gentlemencollection_strict.yml)

Detects execution of TheGentlemen EDR-killer binaries via two branches:
- **Staging path:** any image executed from `\GentlemenCollection\` - the actor's invariant staging
  directory observed consistently across unrelated intrusions
- **Hash branch:** 13 known SHA-1 hashes (Kasps.exe, FaceIT1.exe, Valorant2.exe, Symantec.exe,
  Avast.exe / HexKiller, Sent.exe / ThrottleBlood, Sophos.exe / HavocKiller, etc.)

If this fires, treat as active TheGentlemen intrusion in the defense-evasion phase; ransomware
staging is imminent. Isolate the host immediately.

> Note: the `Hashes` field is populated only by Sysmon Event 1, not by Windows Security Event
> 4688. Without Sysmon, only the staging path branch is active.

### STRICT - GentleKiller impersonation
**File:** [`windows_gentlemen_edr_killer_impersonation_strict.yml`](./rules/windows_gentlemen_edr_killer_impersonation_strict.yml)

Detects:
- Explicit EDR killer tool names (GentleKiller, HexKiller, ThrottleBlood, HavocKiller, OxideHarvest), any path
- Security/gaming product name impersonation from user-writable paths (Temp, AppData, ProgramData, Downloads)

Legitimate vendor paths are filtered. Alert on this rule warrants immediate investigation.

### STRICT - BYOVD with invalid signature
**File:** [`windows_gentlemen_byovd_invalid_signature_driver_strict.yml`](./rules/windows_gentlemen_byovd_invalid_signature_driver_strict.yml)

Detects kernel drivers loaded from non-system paths that carry a valid-looking but invalid
certificate (Expired, Revoked, NotTrusted). This covers all TheGentlemen EDR killer variants
regardless of the specific driver used - the stolen-signature pattern is consistent across
the entire framework.

### Building block - Security process access (feeds correlation)
**File:** [`win_gentlemen_mass_security_process_termination_correlation.yml`](./rules/win_gentlemen_mass_security_process_termination_correlation.yml) *(first document)*

Informational building block (level: informational). Detects any process opening a handle
to a known security product process via Sysmon Event 10 (ProcessAccess). Not actionable alone;
exists only to feed the mass-termination correlation below. Resilient to tool renaming because
it keys on the TARGET security processes, not on the attacker binary.

> Requires explicit ProcessAccess configuration in Sysmon - not logged by default. Example:
> `<ProcessAccess onmatch="include"><TargetImage condition="end with">MsMpEng.exe</TargetImage></ProcessAccess>`

### Correlation - Mass security process termination
**File:** [`win_gentlemen_mass_security_process_termination_correlation.yml`](./rules/win_gentlemen_mass_security_process_termination_correlation.yml) *(second document)*

Behavioral correlation (Sigma `value_count` type) that fires when a **single process accesses
≥ 8 distinct security product processes within 1 minute** - the core behavior of GentleKiller,
which terminates 400+ processes from ~48 vendors in a loop. Grouped by `SourceImage`,
`SourceProcessId`, and `Computer`.

This is the **most evasion-resilient rule in the pack**: it survives driver swaps, binary
repacking, and tool renaming because it keys purely on killing behavior.

> Calibrate the threshold (default: 8) to 50–75% of the distinct security processes running
> in your environment. Lower it to 4–5 for lean stacks.

---

## Sigma rules

| File | Tier | Level | Logsource |
|---|---|---|---|
| `windows_gentlemen_edr_security_process_termination_broad.yml` | BROAD | medium | windows/process_creation |
| `driver_load_win_gentlemen_byovd_edr_killer_broad.yml` | BROAD | medium | windows/driver_load |
| `proc_creation_win_gentlemen_edr_killer_gentlemencollection_strict.yml` | STRICT | high | windows/process_creation |
| `windows_gentlemen_edr_killer_impersonation_strict.yml` | STRICT | high | windows/process_creation |
| `windows_gentlemen_byovd_invalid_signature_driver_strict.yml` | STRICT | high | windows/driver_load |
| `win_gentlemen_mass_security_process_termination_correlation.yml` | Building block | informational | windows/process_access |
| `win_gentlemen_mass_security_process_termination_correlation.yml` | Correlation | high | - (value_count) |

---

## Log sources required

| Rule | Required logs |
|---|---|
| Process termination BROAD | Windows Security Event 4688 or Sysmon Event 1 |
| BYOVD driver load BROAD | **Sysmon Event 6** (DriverLoad) |
| GentleKiller staging STRICT | Windows Security Event 4688 or Sysmon Event 1 (Sysmon required for hash branch) |
| Impersonation STRICT | Windows Security Event 4688 or Sysmon Event 1 |
| BYOVD invalid signature STRICT | **Sysmon Event 6** (DriverLoad) |
| Building block | **Sysmon Event 10** (ProcessAccess), must be explicitly configured |
| Correlation | Requires building block events |

> Both BYOVD rules require Sysmon with `DriverLoad` events (Event ID 6).
> The building block and correlation require Sysmon with `ProcessAccess` events (Event ID 10)
> explicitly configured for security product target images.

---

## MITRE ATT&CK mapping

| Technique | ID | Rule |
|---|---|---|
| Impair defenses: disable or modify tools | T1562.001 | All |
| Service stop | T1489 | Process termination BROAD |
| Masquerading: match legitimate name | T1036.005 | Impersonation STRICT |
| Masquerading | T1036 | Staging STRICT (GentlemenCollection binaries mimic vendor names) |
| Exploitation for privilege escalation | T1068 | BYOVD rules |
| Rootkit | T1014 | BYOVD driver load BROAD (kernel-level hiding capability) |

---

## False positives

### BROAD - Process termination
- IT admin stopping a security service (validate change ticket)
- EDR self-update temporarily stopping its own service (check ParentImage)
- Patch management tools (SCCM, Intune, PDQ), partially filtered

### BROAD - BYOVD driver load
- `vgk.sys` on gaming endpoints (Riot Vanguard), filtered for legitimate install path; hash hits are not affected
- `GameDriverX64.sys` and `dmx.sys` from Program Files (no confirmed TheGentlemen hash), filtered
- Authorized red-team or BYOVD research in a controlled lab

### STRICT - GentleKiller staging
- Extremely unlikely - a path containing `\GentlemenCollection\` has no plausible legitimate use
- Samples submitted voluntarily to an internal sandbox (verify host and user context)

### STRICT - Impersonation
- Virtually none for explicit killer names
- Legitimate security software should never run from Temp/AppData

### STRICT - BYOVD invalid signature
- Vendor drivers with recently expired certificates in non-standard paths (rare)
- Development/lab environments testing driver signing

### Building block and correlation
- Endpoint management or inventory tools legitimately enumerating processes (add to `filter_legit_sources`)
- Security products inspecting one another - tune `filter_legit_sources` to your stack

---

## Tuning guidance

1. **Allowlist management tool parents** in the process termination BROAD rule: add SCCM/Intune/PDQ parent images to `filter_main_legitimate_mgmt`
2. **Adjust correlation threshold** (default: 8) to 50–75 % of the distinct security processes in your environment
3. **Allowlist internal CA** for the BYOVD invalid-signature rule if your org uses an internal CA whose certs show as NotTrusted on endpoints
4. **Enable Sysmon Event 6** for both BYOVD rules; verify with `sysmon -c` that `DriverLoad` events are captured
5. **Configure Sysmon ProcessAccess** events for security product target images to activate the building block and correlation
6. **Correlate** within a 10-minute window: BYOVD driver load + GentlemenCollection staging + mass termination correlation = highest-confidence TheGentlemen attribution

---

## SOC triage steps

1. **Check ParentImage** on process termination alerts - EDR killers are launched from a dropper, not msiexec or management tools
2. **Check IntegrityLevel** - BYOVD and kernel-level killers require High or System integrity
3. **Check image hash** against VirusTotal for impersonation and staging alerts
4. **Check driver SignatureStatus** - revoked certificates can be verified via `sigcheck -tv` on the binary
5. **Check SourceProcessId** on correlation alerts - if GentleKiller injected into a legitimate process (process hollowing), SourceImage shows a benign name but SourceProcessId reveals the actual malicious thread
6. **Isolate immediately** if BYOVD + staging (GentlemenCollection) + correlation fire together on the same host

---

## References

- [BleepingComputer, TheGentlemen Ransomware EDR Killers](https://www.bleepingcomputer.com/news/security/gentlemen-ransomware-uses-multiple-edr-killers-to-disable-defenses/)
- [MITRE T1562.001, Impair Defenses](https://attack.mitre.org/techniques/T1562/001/)
- [MITRE T1068, Exploitation for Privilege Escalation](https://attack.mitre.org/techniques/T1068/)
- [MITRE T1036.005, Masquerading: Match Legitimate Name](https://attack.mitre.org/techniques/T1036/005/)
