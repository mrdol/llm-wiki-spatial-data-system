# Data papers de banques et collections de données

Corpus de travail révisé le 25 septembre 2026 pour étudier la collecte, la sélection, l’harmonisation, la description, la validation et la diffusion de banques de données. Les articles centrés principalement sur l’exécution d’un benchmark, l’orchestration logicielle ou les ressources de calcul ne font pas partie du noyau.

## Corpus retenu et disponible localement

Le corpus retenu comprend vingt PDF valides. Les articles sont conservés lorsqu’ils décrivent principalement la constitution d’une banque ou d’une suite de données, même s’ils ajoutent une expérience destinée à vérifier son utilité.

Les vingt PDF ont été convertis en TEI XML et contrôlés le 26 septembre 2026. Les fichiers se trouvent dans [`../tei`](../tei). La grille codée article par article se trouve dans [`../grille_comparative_20_data_papers_2026-09-26.tsv`](../grille_comparative_20_data_papers_2026-09-26.tsv). Elle comporte 20 lignes et 23 champs couvrant la collecte, la sélection, l’harmonisation, les métadonnées, la provenance, la qualité, la validation, les tâches, les interfaces, la maintenance et le traitement des structures spatiales ou temporelles.

Le codage repose d’abord sur le texte intégral TEI. Les PDF ont été relus visuellement lorsque des tableaux, schémas ou mises en page portaient une information que GROBID pouvait aplatir. Cette double lecture a notamment servi pour les Data Descriptors de *Scientific Data*, LAGOS-NE et Meta-Album. Une absence dans le TEI n’a donc pas été interprétée automatiquement comme une absence dans l’article.

| Banque ou collection | Fichier local | Angle utile pour le data paper |
|---|---|---|
| OpenML Benchmarking Suites | `bischl_2021_openml_suites.pdf` | Définition, versionnement et réutilisation de suites de tâches. |
| OpenML-CTR23 | `fischer_2023_openml_ctr23.pdf` | Sélection explicite de 35 problèmes de régression, contrôle de la documentation, des licences, de la taille, des dépendances et définition des partitions. |
| TableShift | `gardner_2023_tableshift.pdf` | Critères de sélection et partitions représentant des changements de distribution. |
| TabZilla | `mcelfresh_2023_tabzilla.pdf` | Constitution d’une collection tabulaire et caractérisation des jeux. |
| PMLB | `romano_2022_pmlb.pdf` | Normalisation, validation automatique et contribution de nouveaux jeux. |
| TabReD | `rubachev_2025_tabred.pdf` | Sélection de données réalistes et partitions temporelles. |
| Monash Forecasting Archive | `godahewa_2021_monash_forecasting_archive.pdf` | Harmonisation et description d’une banque de séries temporelles. |
| Open Graph Benchmark | `hu_2020_open_graph_benchmark.pdf` | Tâches, partitions et métriques communes pour données de graphes. |
| Meta-Album | `ullah_2022_meta_album.pdf` | Collection multi-domaines, métadonnées et protocoles de réutilisation. |
| TUDataset | `morris_2020_tudataset.pdf` | Curation et interface commune pour jeux de graphes. |
| MedMNIST v2 | `yang_2023_medmnist_v2.pdf` | Standardisation de collections biomédicales hétérogènes. |
| GriddingMachine | `wang_2022_griddingmachine.pdf` | Harmonisation spatiale, provenance et résolution des grilles. |
| Blood-pressure benchmark | `schrumpf_2023_bp_benchmark.pdf` | Constitution et validation d’une collection physiologique multi-source. |
| SRBench | `lacava_2021_srbench.pdf` | Jeux, métadonnées et protocole commun pour la régression symbolique. |
| Compound Matrix-Based Project Database | `kosztyan_2024_cmpd.pdf` | Consolidation de 12 banques et 23 jeux dans un format unifié. |
| Pyrfume | `hamel_2024_pyrfume.pdf` | Curation, alignement et extension de plus de 40 jeux olfactifs. |
| LAGOS-NE | `soranno_2017_lagos_ne.pdf` | Intégration de 87 sources, provenance, modules, contrôle qualité et dimension spatiale. |
| Common Fund Data Ecosystem | `charbonneau_2022_cfde.pdf` | Mise en relation, découvrabilité et description commune de ressources issues de plusieurs programmes. |
| Microbiome Learning Repo | `vangay_2019_microbiome_learning_repo.pdf` | Collecte de 15 études, traitement commun des séquences, curation des métadonnées, construction de 33 tâches et gestion des groupes pour limiter les fuites de validation. |
| Construction Motion Data Library | `tian_2022_construction_motion_library.pdf` | Intégration de jeux publics hétérogènes et d’une collecte propre, avec harmonisation des structures, fréquences, unités, coordonnées, formats et étiquettes, puis validation technique. |

## Références sorties du noyau

Les PDF de CAMELS, LamaH-CE et Caravan ont été retirés de ce dossier parce qu’ils décrivent chacun une banque thématique particulière et servent mieux à la comparaison spatiale séparée. *Datasheets for Datasets* et les principes FAIR restent des références documentaires, mais ne sont pas des data papers de banques. AMLB a été retiré parce que sa contribution principale porte sur l’exécution reproductible d’un benchmark AutoML plutôt que sur la collecte et la description d’une banque.

L’article sur la Fundamental Clustering Problems Suite n’est pas intégré au noyau. Il rassemble douze jeux, dont dix jeux artificiels construits pour illustrer des difficultés géométriques de clustering et deux applications réelles prétraitées. Il est utile comme exemple de format *Data in Brief* et comme catalogue de problèmes synthétiques, mais apporte peu à l’étude de la collecte, de la sélection et de l’harmonisation d’une banque multi-source de données réelles.

Les traces des tentatives automatisées se trouvent dans `manifest_telechargements.json`.
