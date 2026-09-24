# Recherche et collecte complémentaires — 9 septembre 2026

**20 articles retenus et disponibles : 17 PDF récupérés automatiquement et 3 fournis par l’utilisateur, tous contrôlés. Deux bibliographies produites : 20 références semi-synthétiques et 11 références de benchmark, en incluant les PDF antérieurs.** Le travail méthodologique du pilote est en pause à la demande de l’utilisateur.

## Dossiers par sujet

- [Semi-synthétique : 9 nouveaux PDF sur 9 articles retenus](revue_donnees_semi_synthetiques/articles_complementaires_2026-09-09/README.md).
- [Jeux de benchmark : 11 nouveaux PDF sur 11 articles retenus](revue_jeux_donnees_benchmark/articles_complementaires_2026-09-09/README.md).

Les cinq PDF récupérés juste avant cette collecte (Stolte 2024, Stolte 2025, Lahiri–Zhu 2006, López–Kholodilin 2023 et Gryparis 2009) sont déjà conservés dans `revue_donnees_semi_synthetiques/papiers_lus/priorites_2026-09-09/`. Ils ne sont pas recomptés parmi les 17 nouveaux PDF. Les PDF historiques, dont SpaCE, restent à leur emplacement.

## Articles reçus depuis Downloads et classés

| Sujet | Titre exact | DOI | Fichier conseillé |
|---|---|---|---|
| Semi-synthétique | Model-Based Spatial Data Fusion | [10.1146/annurev-statistics-042424-052920](https://doi.org/10.1146/annurev-statistics-042424-052920) | `gelfand_schliep_2026_spatial_fusion.pdf` |
| Semi-synthétique | Combining Incompatible Spatial Data | [10.1198/016214502760047140](https://doi.org/10.1198/016214502760047140) | `gotway_young_2002_spatial_support.pdf` |
| Semi-synthétique | Effect of correlated observation error on parameters, predictions, and uncertainty | [10.1002/wrcr.20499](https://doi.org/10.1002/wrcr.20499) | `tiedeman_green_2013_observation_error.pdf` |

Les trois PDF ont été copiés depuis Downloads dans `revue_donnees_semi_synthetiques/articles_complementaires_2026-09-09/` et vérifiés (titre, ouverture, pages et SHA-256). Les originaux de Downloads sont conservés. Historique des tentatives automatiques : Les routes éditeur et Unpaywall n’ont pas fourni de PDF valide ; une tentative supplémentaire via la copie déposée par Young sur ResearchGate a également échoué. La notice USGS de Tiedeman a été consultée sans lien PDF supplémentaire trouvé. Gelfand–Schliep est publié en 2026, volume 13, pages 225–244 ; le site indique une licence CC BY, mais le téléchargement automatique a été refusé.

## Pourquoi ces articles

- Semi-synthétique : calibration sur données réelles (Sauer), qualité des simulations (Morris, White), dépendance aux générateurs (Curth), échelles spatiales (Paciorek), validation (Roberts), supports et observation (Gotway–Young, Tiedeman–Green, Gelfand–Schliep). Le précédent causal de Curth reste documentaire et ne réouvre pas le programme EMCS.

- Benchmark : suites de tâches et métadonnées (OpenML, PMLB, AMLB), décalages de distribution et splits temporels (TableShift, TabReD), diversité des difficultés (TabZilla), documentation (Datasheets, FAIR), exemples de data papers spatiaux et temporels (CAMELS, LamaH-CE, Caravan). Les banques hydrologiques incluent des séries temporelles et supports de bassins ; elles ne sont pas présentées comme des tables indépendantes immédiatement admissibles au package.

Ces exemples rendent nécessaire de vérifier, et non de reprendre telle quelle, l’affirmation générale selon laquelle les dépôts existants ne documenteraient pas la dimension spatiale. Les mécanismes de requêtes SQL géospatiales et les benchmarks d’imagerie ne sont pas retenus dans ce lot, centré sur notre besoin tabulaire.

## Versions et traçabilité

- Sauer : prépublication du 7 novembre 2025 récupérée ; publication 2026 identifiée par DOI.
- PMLB et Datasheets : versions auteur arXiv récupérées ; DOI de publication conservés.
- Paciorek : reprint publié déposé sur arXiv.
- TabReD : titre corrigé d’après le PDF ICLR 2025, « Analyzing Pitfalls and Filling the Gaps in Tabular Deep Learning Benchmarks ».
- Les DOI d’article non identifiés ne sont pas inventés ; URL des actes conservée.

Les 20 nouveaux PDF sont lisibles par `pypdf`, leurs titres ont été contrôlés dans les premières pages et leurs empreintes SHA-256 sont toutes distinctes. Cela vérifie les fichiers et leur identité, pas les résultats scientifiques des articles. Le détail se trouve dans les deux manifestes JSON et dans [la sélection](selection_articles_web_2026-09-09.json).

Le téléchargeur utilisé est `code/package_metadata/download_regression_article_pdfs.py`, appelé via l’adaptateur `tools/download_extension_review_pdfs.py` pour lire la sélection JSON et écrire dans les deux extensions. Le module de téléchargement existant est inchangé. Le runtime d’exécution utilisait Python 3.14 avec requests installé et pypdf du runtime Codex ; aucune dépendance n’a été installée.

## Bibliographies terminées

- [Semi-synthétique : 20 références](revue_donnees_semi_synthetiques/revue_donnees_semi_synthetiques.bib).
- [Jeux de benchmark : 11 références](revue_jeux_donnees_benchmark/revue_jeux_donnees_benchmark.bib).

Biblio_from_pdf a traité des copies de travail pour préserver les noms et liens des PDF des revues. Les 31 notices ont été contrôlées sur les premières pages et les sources bibliographiques. Les versions auteur sont signalées. Le PDF nommé `huber_lechner_wunsch_2013.pdf` est en réalité le Discussion Paper IZA 5268 de 2010, « How to Control for Many Covariates? Reliable Estimators Based on the Propensity Score » : sa notice décrit ce document, sans lui attribuer le DOI d’un autre titre.

Les DOI extraits à tort des références ont été remplacés ou retirés ; les années de volume ont été distinguées des dates de prépublication. Pour Knaus, la publication est [2021, volume 24, pages 134–161](https://academic.oup.com/ectj/article-abstract/24/1/134/5854188), alors que le PDF local est une prépublication 2018. Les DOI de [TableShift](https://proceedings.neurips.cc/paper_files/paper/2023/hash/a76a757ed479a1e6a5f8134bea492f83-Abstract-Datasets_and_Benchmarks.html) et de [TabZilla](https://www.proceedings.com/075280-3337.html) sont confirmés par les actes.

Validation : 31 clés distinctes, 24 DOI renseignés sans doublon, 31 liens PDF contrôlés par SHA-256, intégrité BibTeX et compilation pdflatex/bibtex réussies pour les sorties du sas et les exports dans les revues. Les sept notices sans DOI restent utilisables et n’ont pas reçu de DOI inventé. Trois tests du correctif Biblio_from_pdf passent (priorité des corrections relues, revue systématique avec `--codex-policy all`, conservation de l’année et des champs de conférence).

Aucune ingestion dans le corpus central ni admission de dataset n’a été faite. Le pilote méthodologique reste en pause ; la prochaine tâche portera sur les fiches datasets, selon les instructions à venir de l’utilisateur.

## Recherche effectuée

Recherche ciblée, non exhaustive : KG « benchmark suites » sans résultat, consultation des deux README et de la bibliographie locale, puis recherches web sur plasmode/générateur, simulation quality, spatial observation error/change of support, benchmark suites, distribution shift et large-sample hydrology. Sources retenues : actes NeurIPS/ICLR, JMLR, éditeurs, dépôts universitaires, arXiv et dépôt auteur. Les URL de chaque article sont consignées dans la sélection et les manifestes.
