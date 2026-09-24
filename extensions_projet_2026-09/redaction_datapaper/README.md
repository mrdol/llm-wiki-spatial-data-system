# Espace de rédaction et de synchronisation du data paper

Ce dossier rassemble l’état consolidé du projet avant la rédaction du manuscrit maître.

Les fichiers générés par `tools/audit_datapaper_repo.py` sont :

- `audit_etat_repo.json` : snapshot lisible par machine ;
- `SYNTHESE_ETAT_PROJET.md` : synthèse scientifique et technique ;
- `SYNTHESE_POUR_JOHNNY.md` : synthèse courte pour partager le même état d’information ;
- `PLAN_SYNCHRONISATION.md` : ordre de travail pour harmoniser fiches, registre, KG, bibliographies et manuscrit.
- `SYNTHESE_REFERENCES_DATAPAPER.md` : rôle des références centrales et méthodologiques dans le futur manuscrit.
- `COMPTE_RENDU_ENCADRANT_2026-09-16.md` : décisions, ambiguïtés et travaux demandés pendant le point d'encadrement.
- `PLAN_DATAPAPER_V2_2026-09-16.md` : plan courant centré sur la collecte et la mise à disposition de la banque.
- `CORRESPONDANCE_RAPPORT_PLAN_V2_2026-09-16.md` : lecture du rapport de stage et tableau indiquant, pour chaque partie du plan V2, ce qui peut servir d'aide, ce qui doit être revérifié et ce qui doit être écarté.
- `PILOTE_META_ANALYSE_2026-09-16.md` : calibration locale de la grille sur six textes ; ces textes ne constituent pas la sélection bibliographique, qui doit être produite indépendamment par recherche web.
- `CORPUS_WEB_BRUT_META_ANALYSE_2026-09-16.md` : proposition externe de 50 articles issue d'une recherche web, conservée avec son contrôle structurel initial ; aucune entrée n'est encore considérée comme validée.
- `meta_analyse_50_pdf_manifest_2026-09-17.tsv` : état consolidé de la collecte et de l'extraction ; les 50 PDF et les 50 TEI sont disponibles, avec chemins, tailles, pagination et nombre de paragraphes extraits.
- `meta_analyse_codage_50_articles_2026-09-17.tsv` : grille complète des 50 articles ; les 47 articles du noyau paramétrique disposent d'un codage manuel des expériences, structures, cellules ou bornes, répétitions, méthodes, métriques, données réelles et validation.
- `openalex_citations_50_articles_2026-09-17.json` : compteurs de citations homogènes OpenAlex et date de consultation pour les 50 DOI.
- `meta_analyse_datasets_a_recuperer_2026-09-17.tsv` : registre des jeux empiriques absents ou seulement partiellement couverts par la banque, avec provenance et piste de récupération.
- `PROMPTS_APPUI_RECHERCHE_META_ANALYSE_2026-09-17.md` : deux prompts actualisés, l'un pour une IA ayant accès au dépôt et l'autre pour une IA externe sans accès aux fichiers locaux.
- `BROUILLON_DATAPAPER_V1_2026-09-21.md` : premier brouillon maître ; le mouvement sur Monte-Carlo et diversité empirique est actualisé sur les 66 articles, ainsi que la méthode de la petite méta-analyse ; les blocs dépendant d'un snapshot final restent signalés comme tels.

Commande depuis la racine du dépôt :

```powershell
python tools/audit_datapaper_repo.py
```

Le futur manuscrit maître devra être ajouté ici. Les brouillons de juillet et août restent des sources historiques tant que leurs chiffres n’ont pas été remplacés par ceux d’un snapshot daté.

- `meta_analyse_codage_66_articles_2026-09-21.tsv` : grille courante de la méta-analyse, 66 articles quantitatifs et 4 lignes de traçabilité hors dénominateur.
- `corpus_meta_analyse/pdf/` et `corpus_meta_analyse/tei/` : copies de travail appariées du corpus du data paper. Les fichiers portent le titre de l'article suivi de l'identifiant entre crochets ; le lot initial contient les 60 articles quantitatifs et A14, et les nouveaux candidats utilisent les identifiants `N01` à `N06`.
- `figures/F1_distribution_jeux_reels_66_articles.png` : distribution du nombre de jeux réels par article pour le corpus quantitatif courant.

État courant de la petite méta-analyse : 66 articles, 73 utilisations empiriques, 63 sources réelles harmonisées, au moins 117 expériences, 141 structures de DGP et 2 042 cellules documentées au minimum. La récupération et l'intégration des jeux empiriques cités dans les 67 textes intégraux constituent une phase ultérieure, placée avant le snapshot final de la banque.
- `corpus_meta_analyse/manifest_5_nouveaux.tsv` : état d'acquisition des cinq candidats supplémentaires et chemins des fichiers sources.


