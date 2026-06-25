# Table de décision SOC - UNC3886 Campagne réseau & virtualisation

| Alerte | Sévérité | Confiance | Triage L1 | Quand escalader | Faux positifs probables | Réponse recommandée | Preuves |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Sondage BROAD d'administration | Moyenne | Moyenne | Vérifier l'IP source, l'URL et le user agent | Exposition publique ou hits répétés | Scanners autorisés, jump hosts d'administration | Confirmer l'exposition et le correctif | Logs d'accès, IP source, URL, UA |
| Shelling / tampering STRICT | Haute | Élevée | Vérifier le parent process et la ligne de commande | Shell, nettoyage des logs ou persistance | Scripts de maintenance, support éditeur | Isoler l'hôte et enquêter | Syslog, télémétrie process, ligne de temps EDR |
