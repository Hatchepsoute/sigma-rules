# Changelog

## 2026-09-25

- Added high-confidence Windows and Linux process-creation rules for suspicious child processes of the Adobe Campaign Classic `nlserver web` module.
- Deliberately omitted a BROAD web rule because no public endpoint or payload pattern supports a low-noise pre-exploitation signal.
- Added bilingual documentation, SOC playbooks, decision tables, Mermaid diagrams, and private lab material.
- Documented that these behavioral rules do not attribute an alert to CVE-2026-75703 by themselves.
- Tightened transfer detection so a generic child command containing an URL does not alert by itself.
- Added selected alternate interpreters, proxy-execution binaries, delayed-execution utilities, and temporary-directory child-process coverage.
