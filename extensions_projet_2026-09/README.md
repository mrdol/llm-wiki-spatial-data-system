# Travaux issus de la réunion avec l'encadrant — septembre 2026

Suivi des trois chantiers ouverts lors de la discussion du 2026-09-04 avec l'encadrant (préparation du data paper + pistes v2 du package `spatialtidymodels`).

| Chantier | Dossier | Statut |
|---|---|---|
| Revue biblio — données semi-synthétiques / DGP pour Monte Carlo (**priorité annoncée**) | [`revue_donnees_semi_synthetiques/`](revue_donnees_semi_synthetiques/) | Cadrage plasmode exclusivement le 8 sept. ; protocole et premier pilote exécuté |
| Revue biblio — jeux de données pour benchmark (data paper) | [`revue_jeux_donnees_benchmark/`](revue_jeux_donnees_benchmark/) | Premier passage exploratoire fait (7 sept.) |
| Reconstruction de la matrice de voisinage W originale | [`matrice_W_originale/`](matrice_W_originale/) | Audit initial fait, méthodologie de reconstruction pas encore implémentée |
| Synchronisation et rédaction du data paper | [`redaction_datapaper/`](redaction_datapaper/) | Audit reproductible du dépôt, deux synthèses et plan de synchronisation disponibles |

Chaque sous-dossier contient son propre `README.md` avec le détail (méthodologie, état d'avancement, prochaines étapes).

L'audit éditorial se relance avec `python tools/audit_datapaper_repo.py`. Il inventorie les fiches, le registre du package, le KG, les bibliographies, les revues et les brouillons, puis régénère le snapshot et les synthèses dans `redaction_datapaper/`.
