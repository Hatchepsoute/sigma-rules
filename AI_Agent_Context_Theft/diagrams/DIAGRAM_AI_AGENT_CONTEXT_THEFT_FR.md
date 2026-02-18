# 🧠 Vol de Contexte d’Agent IA – Schéma d’attaque (FR)

```mermaid
flowchart TD
  A[Accès initial<br/>(infection infostealer sur poste)] --> B[Découverte de fichiers<br/>Routine générique de file-grabbing (répertoires/extensions)]
  B --> C{Répertoire agent IA détecté ?<br/>ex: .openclaw}
  C -- Non --> Z[Vol générique continue<br/>(navigateurs, wallets, apps)]
  C -- Oui --> D[Accès aux fichiers agent IA (signal BROAD)<br/>openclaw.json / SOUL.md / MEMORY.md / AGENTS.md]
  D --> E{Classe de fichier accédée ?}
  E -- Secret d'auth --> F[Vol de token (STRICT)<br/>openclaw.json = gateway token réutilisable]
  E -- Identité crypto --> G[Vol d'identité device (CRITIQUE)<br/>device.json / .pem = clé privée]
  E -- Mémoire/contexte --> H[Vol de contexte (BROAD→STRICT selon processus)<br/>SOUL.md / MEMORY.md / USER.md]
  F --> I{Contexte processus suspect ?<br/>Temp/AppData/Downloads OU noms usurpés}
  G --> I
  H --> I
  I -- Non --> J[Surveiller / valider activité légitime<br/>(éditeurs, runtime agent)]
  I -- Oui --> K[Escalade SOC<br/>L2 (BROAD) ou L3 (STRICT/CRITIQUE)]
  K --> L{Plusieurs fichiers critiques accédés<br/>par le même processus ?}
  L -- Oui --> M[Compromission totale probable (CRITIQUE)<br/>Auth + Crypto + Mémoire]
  L -- Non --> N[Vol ciblé probable<br/>(token OU clés OU mémoire)]
  M --> O[Actions IR immédiates<br/>Isolation, révocation tokens, rotation clés, audit agent]
  N --> O
  O --> P[Durcissement post-incident<br/>Chiffrement au repos, monitoring répertoires, DLP, inventaire agents IA]
```
