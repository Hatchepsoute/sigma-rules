
# Decision Table SOC – Kernel_Rootkit_MVDR 
👉🏾 [English version available here](README.md)


 
## Objectif
Guider les analystes SOC dans la prise de décision lorsque des règles du pack Kernel_Rootkit_MVDR se déclenchent.

## Règles
- R1 : Kernel driver load (visibilité)
- R2 : Kernel driver service creation (persistance)
- R3 : Kernel rootkit correlation (confirmation)

## Table de décision

| R1 | R2 | R3 | Niveau de risque | Décision SOC | Action immédiate |
|----|----|----|-----------------|--------------|------------------|
| ❌ | ❌ | ❌ | Aucun | Ignorer | Aucune |
| ✅ | ❌ | ❌ | Faible | Monitoring | Vérifier contexte |
| ❌ | ✅ | ❌ | Élevé | Investigation | Identifier service |
| ✅ | ✅ | ❌ | Très élevé | Incident potentiel | Escalade N2 |
| ❌ | ❌ | ✅ | Critique | Incident confirmé | IR immédiate |
| ✅ | ❌ | ✅ | Critique | Incident confirmé | IR immédiate |
| ❌ | ✅ | ✅ | Critique | Incident confirmé | IR immédiate |
| ✅ | ✅ | ✅ | Critique | Incident confirmé | IR immédiate |

## Interprétation
- R1 seule : signal faible
- R2 seule : suspicion forte
- R3 : confiance OS rompue

✍🏿 **Auteur :** Adama ASSIONGBON – SOC & CTI Consultant  
[LinkedIn Profile](https://www.linkedin.com/in/adama-assiongbon-9029893a/)

## Chaînage des règles et relations
Quand un pack contient plusieurs détections, `related` relie les règles complémentaires pour permettre au SOC de passer du contexte à la confirmation.
Utiliser l'alerte plus large comme signal de chasse et la règle plus stricte comme signal de confirmation quand les deux existent.

