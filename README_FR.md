# Framework de détection Sigma pour les opérations SOC

[English version](README.md)

Règles Sigma orientées production pour analystes SOC, ingénieurs détection, équipes blue team et MSSP.

## Objectif

Ce dépôt fournit des détections comportementales pour l’exploitation de CVE, les campagnes d’attaque et les activités post-exploitation. Chaque pack contient des règles, des conseils de triage et des éléments de réponse.

## Politique de détection

- **STRICT d’abord**: créer la plus petite règle à haute confiance couvrant le signal observable le plus spécifique.
- **BROAD uniquement si justifiée**: l’ajouter seulement pour une phase d’attaque ou une source de logs distincte, avec des faux positifs exploitables et ajustables.
- **Support et corrélation**: utiliser les règles contextuelles et la télémétrie pour confirmer un incident.

Un pack n’a pas besoin des deux types de règles. Une règle STRICT précise est préférable à une règle BROAD bruyante.

## Structure du dépôt

Chaque pack peut contenir :

- `rules/` Détections Sigma
- `labs/` matériel privé de validation
- `playbook/` guides de réponse SOC
- `decision-table/` décisions de triage
- `diagrams/` flux attaque-réponse
- README bilingues et changelog

## Démarrage rapide

```bash
pipx install sigma-cli
sigma plugin list
bash scripts/validate_all_rules.sh
```

Convertir une règle après vérification des cibles installées :

```bash
sigma check path/to/rules
sigma convert -t <backend> path/to/rule.yml
```

Voir [INSTALLATION.md](INSTALLATION.md), [scripts/README.md](scripts/README.md) et [CONTRIBUTING_FR.md](CONTRIBUTING_FR.md) pour les détails.

## Licence et auteur

Licence Apache 2.0. Les contributions et retours sont bienvenus.

Adama ASSIONGBON, SOC et consultant CTI: [LinkedIn](https://www.linkedin.com/in/adama-assiongbon-9029893a/)
