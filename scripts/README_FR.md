# 📘 Dépôt Sigma Rules – Automatisation SOC & CTI 
👉🏾 [English version available here](README.md)


Ce dépôt fournit des **règles Sigma de niveau entreprise** ainsi que des **scripts d’automatisation** destinés aux équipes SOC et CTI.
L’objectif est d’industrialiser la **validation**, la **conversion** et le **déploiement** des règles de détection multi‑SIEM.
---
## 🛠️ Scripts d’automatisation Sigma

Deux scripts Bash sont fournis et doivent être exécutés depuis le répertoire `scripts/`.

### 1️⃣ `validate_all_rules.sh` – Barrière de Qualité Sigma

**Objectif**
- Valider l’ensemble des règles Sigma
- Détecter :
  - erreurs de syntaxe
  - conditions invalides
  - problèmes de tags (MITRE ATT&CK, tags personnalisés)

**Fonctionnement**
- Parcours récursif de `**/rules/*.yml`
- Exécution de `sigma check`
- Retourne un **code d’erreur bloquant** en cas d’issues
- Conçu comme **gate CI/CD**

---

### 2️⃣ `convert_all_rules.sh` – Conversion Multi‑SIEM

**Objectif**
- Convertir les règles Sigma validées vers des requêtes spécifiques SIEM
- Fournir des règles prêtes à être déployées par les analystes SOC

**SIEM supportés**
- OpenSearch / Lucene
- Splunk
- Elastic / ElastAlert (legacy)
- Elastic EQL
- RSA NetWitness
- Microsoft Sentinel (KQL)

**Structure de sortie**
```text
scripts/conversions/<SIEM>/
├── raw/
└── one-line/
```

---

## ▶️ Exécution

```bash
cd scripts
chmod +x validate_all_rules.sh convert_all_rules.sh
./validate_all_rules.sh
./convert_all_rules.sh
```

---

## 📂 Différence entre `raw/` et `one-line/`

### `raw/` – Sortie Sigma native (par défaut)
- Sortie exacte de `sigma convert`
- Format conservé
- Souvent déjà sur une seule ligne selon le backend
- Recommandé pour :
  - Splunk
  - Microsoft Sentinel (KQL)
  - Elastic EQL
  - RSA NetWitness

### `one-line/` – Variante mono‑ligne de sécurité
- Tous les retours à la ligne sont supprimés
- Nécessaire pour les moteurs exigeant une requête sur une seule ligne
- Cas typiques :
  - OpenSearch / Elasticsearch `query_string`
  - Lucene strict
  - SIEM ou parseurs legacy

**Note**
Il est normal que `raw/` et `one-line/` soient identiques pour certains backends.

**Règle SOC**
- SIEM multi‑ligne → `raw/`
- SIEM mono‑ligne → `one-line/`

---

## 💻 Environnements supportés

- Linux - **recommandé**
- macOS (tests limités)
- Windows via **WSL uniquement**

**Prérequis**
- Bash 4+
- Python 3.9+
- `sigma-cli`

Installation :
```bash
pip install sigma-cli
```

---

## 🧠 Bonnes pratiques SOC

- Toujours valider avant conversion
- Ne jamais déployer de règles avec des issues Sigma
- Utiliser `validate_all_rules.sh` comme barrière CI (Continuous Integration/Intégration Continue)
- Considérer les conversions comme des **artefacts de production**
