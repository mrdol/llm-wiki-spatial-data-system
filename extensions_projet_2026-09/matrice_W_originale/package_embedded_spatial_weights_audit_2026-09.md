# Matrices de voisinage pour les datasets embarques

Ce rapport verifie les 16 jeux de donnees actuellement embarques dans le package `spatialtidymodels`.
La question est de savoir si leur source R/Python fournit deja une matrice de voisinage originale ou si le benchmark doit construire un voisinage a partir des coordonnees.

## Synthese

- Datasets embarques inspectes : 16
- Datasets provenant de packages R/Python : 7
- Matrice de voisinage source retrouvee : 1
- Quand aucune matrice source n'est documentee, le benchmark conserve le comportement existant : construction d'une W kNN depuis les coordonnees.

## Detail

| Dataset | Origine | Package source | Statut W source | Action |
|---|---|---|---|---|
| `georgia` | Python package | libpysal/GWmodel | not_documented_in_source_package | benchmark_knn_default |
| `columbus_crime` | Python/R package | geodatasets/spData/spdep | available_original | use_original_W_when_loaded |
| `london_hp` | R package | GWmodel | not_documented_in_source_package | benchmark_knn_default |
| `boston_housing` | Python package | geodatasets/spData | not_documented_in_source_package | benchmark_knn_default |
| `dub_voter` | R package | GWmodel | not_documented_in_source_package | benchmark_knn_default |
| `ewhp` | R package | GWmodel | not_documented_in_source_package | benchmark_knn_default |
| `lasrosas` | R package | agridat | not_documented_in_source_package | benchmark_knn_default |
| `paper_covid_sociodemographic_risk` | paper-derived dataset |  | not_applicable_not_package_source | paper_specific_review_if_W_needed |
| `paper_spatial_confounding_diabetes` | paper-derived dataset |  | not_applicable_not_package_source | paper_specific_review_if_W_needed |
| `paper_florida_crash_gsvcm` | paper-derived dataset |  | not_applicable_not_package_source | paper_specific_review_if_W_needed |
| `paper_wildfire_bootleg_severity` | paper-derived dataset |  | not_applicable_not_package_source | paper_specific_review_if_W_needed |
| `paper_amphibian_functional_diversity` | paper-derived dataset |  | not_applicable_not_package_source | paper_specific_review_if_W_needed |
| `paper_dragonfly_diversity_europe` | paper-derived dataset |  | not_applicable_not_package_source | paper_specific_review_if_W_needed |
| `paper_wang_henan_cultivated_land_quality` | paper-derived dataset |  | not_applicable_not_package_source | paper_specific_review_if_W_needed |
| `paper_seshat_social_complexity` | paper-derived dataset |  | not_applicable_not_package_source | paper_specific_review_if_W_needed |
| `paper_airbnb_europe_prices` | paper-derived dataset |  | not_applicable_not_package_source | paper_specific_review_if_W_needed |

## Columbus

Pour `columbus_crime`, le voisinage source est disponible sous forme `spData::weights/columbus.gal`.
Il a ete sauvegarde sous `data/final_datasets/weights/columbus_crime_nb.rds` et sous forme `listw` standardisee en lignes dans `data/final_datasets/weights/columbus_crime_listw.rds`.
Cardinalite : n=49; voisins min=2, mediane=4, moyenne=4.69, max=10.
