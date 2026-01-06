# Infostealer FULL SOC Package - STRICT  & STRICT Correlated

This document explains the detection behavior of the Infostealer STRICT framework.

STRICT  provides a high-confidence monolithic detection when execution, credential access, and exfiltration are observed together.

STRICT_Correlated provides a correlated, step-based detection model allowing SOC analysts to progressively validate infostealer activity through execution, credential harvesting, and network exfiltration.

Both approaches are complementary and designed for production SOC environments.

Infostealers/
├── Infostealer_STRICT/
│   ├── rules/
│   ├── decision-table/
│   ├── playbook/
│   ├── README.md
│   └── README_FR.md
│
├── Infostealer_STRICT_Correlated/
│   ├── rules/
│   ├── correlation/
│   ├── decision-table/
│   ├── playbook/
│   ├── README.md
│   └── README_FR.md

