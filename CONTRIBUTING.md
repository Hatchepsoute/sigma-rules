👉🏾 **French version available here:** [CONTRIBUTING_FR.md](CONTRIBUTING_FR.md)

# Contributing to sigma-rules

Thank you for your interest in contributing to this project 🙌  
This repository aims to provide **production-ready Sigma detection content**
for SOC teams, MSSPs, and Detection Engineers.

All contributions are welcome, provided they follow the guidelines below.

---

## 🎯 Scope of Contributions

We welcome contributions related to:

- Sigma detection rules (BROAD, STRICT, SUPPORT, correlation)
- CVE-focused detection packs
- Campaign-based detection packs
- Decision tables (SOC triage & response)
- SOAR playbooks (TheHive, generic SOC workflows)
- Diagrams and documentation 
- Detection improvements (noise reduction, resilience, coverage)

❌ IoC-only submissions without behavioral logic  
❌ Rules without operational SOC value

---

## 🧠 Detection Philosophy

This project follows a **layered detection approach**:

- **BROAD** – Visibility, threat hunting, early weak signals  
- **STRICT** – High-confidence detection suitable for alerting  
- **SUPPORT / CORRELATION** – Context enrichment and incident confirmation  

Rules must not rely solely on static indicators.

---

## 📁 Repository Structure

Each detection pack should follow this structure:

Pack_Name/
├── rules/
│   ├── BROAD/
│   ├── STRICT/
│   └── SUPPORT/
├── decision-table/
├── playbook/
├── diagrams/
├── README.md
└── README_FR.md

---

## 🧪 Sigma Rule Requirements

All Sigma rules must:

- Follow the official Sigma specification
- Be validated using `sigma check` or equivalent
- Include required metadata (title, id, description, author, references, tags)
- Avoid overly generic or noisy logic

---

## 📊 Decision Tables & Playbooks

Decision tables and playbooks should clearly guide SOC analysts:
- Alert meaning
- Confidence level
- Recommended actions
- Escalation criteria

---

## 🌍 Language

- English is mandatory
- French versions are strongly encouraged
- Cross-link EN / FR documentation

---

## 🔍 Review Process

1. Fork the repository
2. Create a dedicated branch
3. Submit a pull request with clear context and validation details
4. Address review feedback

---

## ⚖️ License

By contributing, you agree that your work will be licensed under the **Apache License 2.0**.

---

Thank you for helping improve open-source detection engineering.
