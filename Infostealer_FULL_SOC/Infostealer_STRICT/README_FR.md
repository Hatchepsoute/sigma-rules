# 🕵️‍♂️ Infostealer STRICT – Détection haute confiance d’accès aux identifiants et exfiltration
👉🏾 [English version available here](README.md)


 
## 📌 Vue d’ensemble

Cette règle Sigma permet de **détecter avec un haut niveau de confiance une activité infostealer**, en corrélant **trois comportements critiques** observés dans les campagnes réelles :

1️⃣ Exécution suspecte de LOLBins depuis des répertoires accessibles à l’utilisateur  
2️⃣ Accès aux stockages d’identifiants des navigateurs  
3️⃣ Exfiltration réseau via des outils en ligne de commande  

🎯 Objectif : fournir une **détection SOC opérationnelle**, avec très peu de faux positifs.

---

## 🔍 Logique de détection

L’alerte est déclenchée **uniquement si les trois comportements sont observés ensemble**, garantissant une détection robuste.

### 1️⃣ Exécution suspecte (LOLBins)

Surveillance de binaires Windows souvent détournés :

- `powershell.exe`, `pwsh.exe`
- `cmd.exe`
- `mshta.exe`
- `rundll32.exe`

🚨 Lorsqu’ils sont exécutés depuis :
- `\Users\`
- `\AppData\`
- `\Temp\`
- `\Downloads\`

Schéma typique des **loaders d’infostealers modernes**.

---

### 2️⃣ Accès aux identifiants navigateur

Détection d’accès aux artefacts sensibles :
- Bases Chrome / Edge (`Login Data`, `Cookies`)
- Déchiffrement via `CryptUnprotectData`

🔐 Indicateur fort de **vol d’identifiants**.

---

### 3️⃣ Exfiltration réseau

Confirmation d’une sortie de données via :
- HTTP / HTTPS
- `Invoke-WebRequest`
- `curl`, `wget`

🌍 Correspond à l’**exfiltration effective des données volées**.

---

## 🔗 Condition de corrélation

```
selection_exec AND selection_creds AND selection_net
```

✅ Permet d’identifier des **chaînes d’attaque complètes**.

---

## 🧭 Mapping MITRE ATT&CK

- **Execution** : T1059 – Command and Scripting Interpreter
- **Credential Access** : T1555 – Credentials from Password Stores
- **Exfiltration** : T1041 – Exfiltration Over C2 Channel

---

## ⚠️ Faux positifs

Très rares :
- Outils forensiques autorisés
- Scripts légitimes de sécurité

📝 Toujours valider le contexte.

---

## 🔥 Sévérité

**CRITIQUE**  
🚑 Investigation SOC immédiate requise.

---

## 📚 Référence CTI

Cette règle s’appuie sur les techniques réelles documentées ici :

🔗 https://www.dexpose.io/deep-dive-into-arkanix-stealer-and-its-infrastructure/

---

## 👤 Auteur

**Adama ASSIONGBON**  
Consultant SOC & CTI  
🔗 https://www.linkedin.com/in/adama-assiongbon-9029893a/
