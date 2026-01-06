# 📊 Table de Décision – Activité Infostealer Confirmée (STRICT)

## Portée de la détection
Détection corrélée multi-étapes à haute confiance d’une activité infostealer.

## Logique de détection
Corrélation de :
- Exécution suspecte de LOLBin depuis des chemins utilisateur
- Accès aux stockages d’identifiants des navigateurs
- Exfiltration réseau externe

## Matrice de décision SOC

| Conditions observées | Décision SOC | Action |
|--------------------|-------------|--------|
| LOLBin seul | Surveillance | Pas d’escalade |
| LOLBin + accès identifiants | Suspect | Corrélation requise |
| LOLBin + identifiants + exfiltration | **Activité infostealer confirmée** | Déclencher playbook IR |

## Sévérité
Critique

## Phrase SOC standard
Cette alerte correspond à une activité infostealer confirmée basée sur une corrélation comportementale multi-étapes.
