![Sigma](https://img.shields.io/badge/Sigma-Rules-blue)
![Windows](https://img.shields.io/badge/Platform-Windows-informational)
![SOC](https://img.shields.io/badge/Use--case-SOC%20%7C%20Detection%20Engineering-blueviolet)
![License](https://img.shields.io/badge/License-MIT-green)

# Installation & Usage

This document explains how to install the project and how to **validate** and **convert**
Sigma rules using the automation scripts provided in the `scripts/` directory.
These steps are **mandatory** before deploying any rule into a SIEM.

---

## Requirements

- Linux (**recommended**) or macOS  
- Windows via **WSL only**
- Python **3.10+**
- Bash **4+**
- `sigma-cli`
- Target SIEM backend (Elastic, OpenSearch, Splunk, Sentinel, etc.)

---

## Installation

```bash
git clone https://github.com/Hatchepsoute/sigma-rules.git
cd sigma-rules
pip install sigma-cli
sigma --version

