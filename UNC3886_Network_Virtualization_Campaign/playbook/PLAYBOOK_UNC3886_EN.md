# Playbook - UNC3886 Network & Virtualization Campaign

## Objective

Guide SOC triage for external management probing and appliance-side log tampering or shelling behavior associated with UNC3886.

## Scope

Network security appliances, hypervisors and Linux-based management hosts.

## Triage steps

1. Confirm whether the exposed service is a management interface or a public-facing admin path.
2. Review the BROAD alert for source IP, URL, method and user agent.
3. Check whether the STRICT rule fired on appliance-side log tampering or shell spawning.
4. Correlate any request with changes to logs, persistence or service execution.
5. Verify patch level and recent admin activity.
6. Isolate the host if log tampering and shell execution appear in the same time window.

## Evidence to collect

- HTTP access logs
- Syslog or process creation telemetry
- Service ownership and parent process context
- Patch level and version information
- EDR timeline around the incident window

## Escalation criteria

- External probing of an admin interface followed by shelling or log tampering
- Repeated attempts from automation-like tools
- Evidence of log suppression, cleanup or persistence changes
