# 📊 Table de Décision – Infostealer STRICT v2 (Corrélée)

## Modèle de corrélation
Détection par étapes corrélées dans une fenêtre courte (≤10 minutes).

### Étapes
1. Exécution suspecte de LOLBin / loader
2. Accès aux identifiants navigateur
3. Exfiltration réseau externe

## Matrice de décision SOC

| Étapes observées | Décision | Action |
|-----------------|----------|--------|
| Étape 1 seule | Surveillance | Collecter le contexte |
| Étape 1 + Étape 2 | Forte suspicion | Corrélation requise |
| Étapes 1 + 2 + 3 | **Activité infostealer confirmée** | Déclencher playbook IR |
