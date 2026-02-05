
# SOC Playbook – Linux Sliver / FRP / LPD Masquerade 
[👉🏾 French version available here: ](./README_FR.md)
## Scope
This playbook guides SOC analysts through the investigation and response to alerts related to:
- FRP reverse proxy activity
- SOCKS proxy masquerading as LPD (cups-lpd)
- Sliver implant deployment
- systemd persistence mechanisms

This playbook is aligned with the Sigma rules, decision table, and Mermaid diagram.

---

## Trigger Conditions
One or more of the following alerts:
- FRP execution detected
- Suspicious listener on TCP/515
- Execution of cups-lpd with SOCKS arguments
- Creation of `system-updater` binary
- Suspicious systemd service creation

---

## Phase 1 – Initial Triage (L1)

**Objectives**
- Validate alert legitimacy
- Eliminate obvious false positives

**Actions**
- Identify hostname, user, timestamp
- Verify if host is a server, appliance, or workstation
- Check if printing services (CUPS/LPD) are expected

**Decision**
- If isolated alert → escalate to L2
- If correlated alerts → proceed to Phase 2

---

## Phase 2 – Investigation (L2)

**Process Analysis**
- Review process tree (parent/child)
- Confirm execution paths (`/tmp`, `/dev/shm`, hidden dirs)
- Inspect command-line arguments

**Network Analysis**
- Confirm outbound/inbound tunnels
- Check listening services on TCP/515
- Identify remote IPs and ports

**File System**
- Locate `system-updater` or hidden binaries
- Check timestamps and permissions
- Compute hashes

**Decision**
- If FRP + LPD + implant → escalate to L3
- If single indicator → continue monitoring

---

## Phase 3 – Confirmation & Response (L3)

**Indicators of Compromise**
- Multiple Sigma rules triggered
- systemd persistence confirmed
- Unauthorized remote access

**Response Actions**
- Isolate the host
- Disable malicious systemd services
- Kill malicious processes
- Remove implant binaries

---

## Phase 4 – Containment & Eradication

- Rotate credentials used on the host
- Scan for lateral movement
- Patch exposed services
- Harden systemd and service permissions

---

## Phase 5 – Lessons Learned

- Tune Sigma rules if needed
- Update allowlists
- Document the incident
- Share intelligence internally

---

## Verdict Mapping

| Conditions Met | Verdict |
|---------------|---------|
| FRP only | Suspicious |
| FRP + LPD | High Risk |
| FRP + LPD + Sliver + Persistence | **Confirmed Compromise** |


[TheHive_Playbook_Sliver_FortiWeb.yml](./TheHive_Playbook_Sliver_FortiWeb.yml)

[TheHive_Decision_Mapping.yml](./TheHive_Decision_Mapping.yml)
