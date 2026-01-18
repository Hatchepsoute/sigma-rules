# Scripts d’automatisation Sigma

Ce répertoire contient des **scripts portables et multiplateformes** destinés à la validation et à la conversion des règles Sigma pour les opérations SOC & CTI.

👉 **English version**: [README.md](README.md)

---

## 📂 Structure du répertoire

```text
scripts/
├── convert_all_rules.sh
├── validate_all_rules.sh
├── Linux_MacOS/
│   ├── validate_all_rules_portable.sh
│   ├── README.md
│   └── README_FR.md
└── windows/
    ├── validate_all_rules.ps1
    ├── README.md
    └── README_FR.md
```

---

## 🧪 Scripts de validation

### Linux / macOS (recommandé)

Script Bash portable :

```bash
./scripts/Linux_MacOS/validate_all_rules_portable.sh
```

📖 Documentation :
- English : `scripts/Linux_MacOS/README.md`
- Français : `scripts/Linux_MacOS/README_FR.md`

---

### Windows (PowerShell)

Script PowerShell portable :

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\validate_all_rules.ps1
```

📖 Documentation :
- English : `scripts/windows/README.md`
- Français : `scripts/windows/README_FR.md`

---

## 🔁 Script de conversion (multi‑SIEM)

```bash
./scripts/convert_all_rules.sh
```

Ce script convertit les règles Sigma validées vers des requêtes spécifiques aux SIEM
(OpenSearch, Splunk, Sentinel, Elastic, etc.).

---

## 🧠 Bonnes pratiques SOC

- Toujours valider les règles avant conversion
- Utiliser les scripts comme **barrière de qualité CI/CD**
- Ne pas exécuter avec des privilèges élevés
- Considérer les règles converties comme des artefacts de production

---

## 👤 Auteur

Adama ASSIONGBON  
Analyste SOC & CTI

---
