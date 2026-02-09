# 📊 Attack Flow Diagram (Mermaid)
[👉🏾**English version available here**](README.md)

```mermaid
flowchart TD
  %% Évasion de défense - Neutralisation des outils de sécurité (BROAD vs STRICT)

  A[Telemetrie ingeree: creation de processus Windows et terminaison de processus] --> B{Activite suspecte detectee}

  %% Chemin BROAD (R2)
  B -->|Oui| C[BROAD (R2): tentative de desactivation via ligne de commande]
  C --> D{Exclusions de tuning appliquees}
  D -->|Oui| E[Alerte: moyenne a elevee. Investiguer contexte hote et utilisateur]
  D -->|Non| F[Bruit attendu. Ajouter allowlist scripts admin et images systeme]

  %% Chemin STRICT (R3)
  B -->|Oui| G[STRICT (R3): desactivation a haute confiance]
  G --> H[Alerte: critique. Confinement immediat recommande]

  %% Correlation avec terminaison (R1)
  C --> I{R1 declenchee: arret de processus de securite}
  G --> I
  I -->|Oui| J[Detection correlee: tres forte confiance en evasion de defense]
  I -->|Non| K[Signal isole: poursuivre investigation et enrichir le contexte]

  %% Actions SOC
  J --> L[Playbook reponse: isoler l hote, triage, verifier fenetre de changement]
  E --> L
  H --> L
  K --> M[Pivot enrichissement: LSASS, mouvement lateral, persistance]

  %% Boucle d amelioration
  M --> N[Boucle d amelioration: ajuster filtres, allowlist, renforcer couverture]
  L --> N
```
