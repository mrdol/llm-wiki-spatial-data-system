---
title: paper_fire_forest_loss_dominican_republic
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_fire_forest_loss_dominican_republic.rds
  - DatasetFirst_10_5281_zenodo_6990803
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Fire and forest loss in the Dominican Republic during the 21st Century" (DOI 10.1101/2021.06.15.448604).

## Description du jeu de donnees

- Topic: ecologie forestiere / feu et deforestation
- Observation unit: cellule de grille hexagonale (statistiques zonales, ~100km2)
- Observed population: grille hexagonale de la Republique Dominicaine (482 cellules), perte de couvert forestier et densite de feux MODIS, 2001-2018
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: Fire and forest loss in the Dominican Republic during the 21st Century
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1101/2021.06.15.448604
- Dataset DOI: 10.5281/zenodo.6990803
- Source URL: https://doi.org/10.5281/zenodo.6990803
- Local raw dir: `data/raw/papers/DatasetFirst_10_5281_zenodo_6990803/`
- Local sf output: `data/final_datasets/sf/paper_fire_forest_loss_dominican_republic.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `LOSS0118_PCT_PYR`, `LOSS0118_PUA_PYR`, `LOSS0118_AREASQM_PYR`
- Candidate Y typology: continuous, rate
- Candidate X variables in local artifact: `AREASQM`, `AREASQM_PCT`, `GEOMORPHONS_FLAT_PCT`, `GEOMORPHONS_PEAK_PCT`, `GEOMORPHONS_RIDGE_PCT`, `GEOMORPHONS_SHOULDER_PCT`, `GEOMORPHONS_SPUR_PCT`, `GEOMORPHONS_SLOPE_PCT`, `GEOMORPHONS_HOLLOW_PCT`, `GEOMORPHONS_FOOTSLOPE_PCT`, `GEOMORPHONS_VALLEY_PCT`, `GEOMORPHONS_PIT_PCT`, `GEOMORPHONS_<NA>`, `GEOMORPHONS_FLAT_AREASQM`, `GEOMORPHONS_PEAK_AREASQM`, `GEOMORPHONS_RIDGE_AREASQM`, `GEOMORPHONS_SHOULDER_AREASQM`, `GEOMORPHONS_SPUR_AREASQM`, `GEOMORPHONS_SLOPE_AREASQM`, `GEOMORPHONS_HOLLOW_AREASQM`, `GEOMORPHONS_FOOTSLOPE_AREASQM`, `GEOMORPHONS_VALLEY_AREASQM`, `GEOMORPHONS_PIT_AREASQM`, `GEOMORPHONS_<NA>_AREASQM`, `SLOPE_n`, `SLOPE_MIN`, `SLOPE_Q1`, `SLOPE_MEAN`, `SLOPE_MEDIAN`, `SLOPE_Q3`, `SLOPE_MAX`, `SLOPE_SD`, `ROUGHNESS_n`, `ROUGHNESS_MIN`, `ROUGHNESS_Q1`, `ROUGHNESS_MEAN`, `ROUGHNESS_MEDIAN`, `ROUGHNESS_Q3`, `ROUGHNESS_MAX`, `ROUGHNESS_SD`, `ELEVATION_n`, `ELEVATION_MIN`, `ELEVATION_Q1`, `ELEVATION_MEAN`, `ELEVATION_MEDIAN`, `ELEVATION_Q3`, `ELEVATION_MAX`, `ELEVATION_SD`, `TREECOVER2000_>=25%TC_PCT`, `TREECOVER2000_<25%TC_PCT`, `TREECOVER2000_>=25%TC_AREASQM`, `TREECOVER2000_<25%TC_AREASQM`, `LOSSYEAR_0_PCT`, `LOSSYEAR_1_PCT`, `LOSSYEAR_2_PCT`, `LOSSYEAR_3_PCT`, `LOSSYEAR_4_PCT`, `LOSSYEAR_5_PCT`, `LOSSYEAR_6_PCT`, `LOSSYEAR_7_PCT`, `LOSSYEAR_8_PCT`, `LOSSYEAR_9_PCT`, `LOSSYEAR_10_PCT`, `LOSSYEAR_11_PCT`, `LOSSYEAR_12_PCT`, `LOSSYEAR_13_PCT`, `LOSSYEAR_14_PCT`, `LOSSYEAR_15_PCT`, `LOSSYEAR_16_PCT`, `LOSSYEAR_17_PCT`, `LOSSYEAR_18_PCT`, `LOSSYEAR_<NA>_PCT`, `LOSSYEAR_0_AREASQM`, `LOSSYEAR_1_AREASQM`, `LOSSYEAR_2_AREASQM`, `LOSSYEAR_3_AREASQM`, `LOSSYEAR_4_AREASQM`, `LOSSYEAR_5_AREASQM`, `LOSSYEAR_6_AREASQM`, `LOSSYEAR_7_AREASQM`, `LOSSYEAR_8_AREASQM`, `LOSSYEAR_9_AREASQM`, `LOSSYEAR_10_AREASQM`, `LOSSYEAR_11_AREASQM`, `LOSSYEAR_12_AREASQM`, `LOSSYEAR_13_AREASQM`, `LOSSYEAR_14_AREASQM`, `LOSSYEAR_15_AREASQM`, `LOSSYEAR_16_AREASQM`, `LOSSYEAR_17_AREASQM`, `LOSSYEAR_18_AREASQM`, `LOSSYEAR_<NA>_AREASQM`, `LOSS0118_PCT`, `LOSS0118_<NA>_PCT`, `LOSS0118_AREASQM`, `LOSS0118_<NA>_AREASQM`, `LOSS1218_PCT`, `LOSS1218_<NA>_PCT`, `LOSS1218_AREASQM`, `LOSS1218_<NA>_AREASQM`, `NFIRESM6`, `NFIRESV1`, `X_UTM`, `Y_UTM`, `X_KM`, `Y_KM`, `X_KM_P2`, `Y_KM_P2`, `NFIRESM6_PSQKM`, `NFIRESV1_PSQKM`, `NFIRESM6_PSQKM_PYR`, `NFIRESV1_PSQKM_PYR`, `AREASQM_PUA`, `GEOMORPHONS_FLAT_PUA`, `GEOMORPHONS_PEAK_PUA`, `GEOMORPHONS_RIDGE_PUA`, `GEOMORPHONS_SHOULDER_PUA`, `GEOMORPHONS_SPUR_PUA`, `GEOMORPHONS_SLOPE_PUA`, `GEOMORPHONS_HOLLOW_PUA`, `GEOMORPHONS_FOOTSLOPE_PUA`, `GEOMORPHONS_VALLEY_PUA`, `GEOMORPHONS_PIT_PUA`, `TREECOVER2000_>=25%TC_PUA`, `TREECOVER2000_<25%TC_PUA`, `LOSSYEAR_0_PUA`, `LOSSYEAR_1_PUA`, `LOSSYEAR_2_PUA`, `LOSSYEAR_3_PUA`, `LOSSYEAR_4_PUA`, `LOSSYEAR_5_PUA`, `LOSSYEAR_6_PUA`, `LOSSYEAR_7_PUA`, `LOSSYEAR_8_PUA`, `LOSSYEAR_9_PUA`, `LOSSYEAR_10_PUA`, `LOSSYEAR_11_PUA`, `LOSSYEAR_12_PUA`, `LOSSYEAR_13_PUA`, `LOSSYEAR_14_PUA`, `LOSSYEAR_15_PUA`, `LOSSYEAR_16_PUA`, `LOSSYEAR_17_PUA`, `LOSSYEAR_18_PUA`, `LOSSYEAR_<NA>_PUA`, `LOSS0118_PUA`, `LOSS0118_<NA>_PUA`, `LOSS1218_PUA`, `LOSS1218_<NA>_PUA`, `LOSS0118_<NA>_PCT_PYR`, `LOSS0118_<NA>_AREASQM_PYR`, `LOSS0118_<NA>_PUA_PYR`, `LOSS1218_PCT_PYR`, `LOSS1218_<NA>_PCT_PYR`, `LOSS1218_AREASQM_PYR`, `LOSS1218_<NA>_AREASQM_PYR`, `LOSS1218_PUA_PYR`, `LOSS1218_<NA>_PUA_PYR`
- Candidate X count in local artifact: 158
- Candidate X typology: continuous
- Published X variables from paper: NFIRESM6_PSQKM_PYR (densite de points de feu MODIS Collection 6, points/km2/an, filtre 'noise-free')
- Published X count: 1
- Coordinates (x, y - excluded from X candidates): `CENTROID_X_UTM19N`, `CENTROID_Y_UTM19N`
- Identifier columns (excluded from X candidates): `ENLACE`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `LOSS0118_PCT_PYR` | `numeric` | continuous | [0.0018, 1.817] | 0% |
| `LOSS0118_PUA_PYR` | `numeric` | rate | [0, 0.0182] | 0% |
| `LOSS0118_AREASQM_PYR` | `numeric` | continuous | [1059.8764, 1816991.7325] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `fire_forest_loss_dominican_republic`, la ou les reponses `LOSS0118_PCT_PYR`, `LOSS0118_PUA_PYR`, `LOSS0118_AREASQM_PYR` viennent du loader papier et/ou des preuves de l article `Fire and forest loss in the Dominican Republic during the 21st Century`. Les covariables X retenues sont `NFIRESM6_PSQKM_PYR` ; 157 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`CENTROID_X_UTM19N`, `CENTROID_Y_UTM19N`), identifiants (`ENLACE`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `AREASQM` | `numeric` | continuous | 0% |
| `AREASQM_PCT` | `numeric` | continuous | 0% |
| `GEOMORPHONS_FLAT_PCT` | `numeric` | continuous | 18.3% |
| `GEOMORPHONS_PEAK_PCT` | `numeric` | continuous | 5.8% |
| `GEOMORPHONS_RIDGE_PCT` | `numeric` | continuous | 0.6% |
| `GEOMORPHONS_SHOULDER_PCT` | `numeric` | continuous | 10.6% |
| `GEOMORPHONS_SPUR_PCT` | `numeric` | continuous | 0.8% |
| `GEOMORPHONS_SLOPE_PCT` | `numeric` | continuous | 0.2% |
| `GEOMORPHONS_HOLLOW_PCT` | `numeric` | continuous | 0.8% |
| `GEOMORPHONS_FOOTSLOPE_PCT` | `numeric` | continuous | 8.5% |
| `GEOMORPHONS_VALLEY_PCT` | `numeric` | continuous | 0.4% |
| `GEOMORPHONS_PIT_PCT` | `numeric` | continuous | 3.1% |
| `GEOMORPHONS_<NA>` | `numeric` | continuous | 65.8% |
| `GEOMORPHONS_FLAT_AREASQM` | `numeric` | continuous | 18.3% |
| `GEOMORPHONS_PEAK_AREASQM` | `numeric` | continuous | 5.8% |
| `GEOMORPHONS_RIDGE_AREASQM` | `numeric` | continuous | 0.6% |
| `GEOMORPHONS_SHOULDER_AREASQM` | `numeric` | continuous | 10.6% |
| `GEOMORPHONS_SPUR_AREASQM` | `numeric` | continuous | 0.8% |
| `GEOMORPHONS_SLOPE_AREASQM` | `numeric` | continuous | 0.2% |
| `GEOMORPHONS_HOLLOW_AREASQM` | `numeric` | continuous | 0.8% |
| `GEOMORPHONS_FOOTSLOPE_AREASQM` | `numeric` | continuous | 8.5% |
| `GEOMORPHONS_VALLEY_AREASQM` | `numeric` | continuous | 0.4% |
| `GEOMORPHONS_PIT_AREASQM` | `numeric` | continuous | 3.1% |
| `GEOMORPHONS_<NA>_AREASQM` | `numeric` | continuous | 65.8% |
| `SLOPE_n` | `numeric` | continuous | 0% |
| `SLOPE_MIN` | `numeric` | continuous | 0% |
| `SLOPE_Q1` | `numeric` | continuous | 0% |
| `SLOPE_MEAN` | `numeric` | continuous | 0% |
| `SLOPE_MEDIAN` | `numeric` | continuous | 0% |
| `SLOPE_Q3` | `numeric` | continuous | 0% |
| `SLOPE_MAX` | `numeric` | continuous | 0% |
| `SLOPE_SD` | `numeric` | continuous | 0% |
| `ROUGHNESS_n` | `numeric` | continuous | 0% |
| `ROUGHNESS_MIN` | `numeric` | continuous | 0% |
| `ROUGHNESS_Q1` | `numeric` | continuous | 0% |
| `ROUGHNESS_MEAN` | `numeric` | continuous | 0% |
| `ROUGHNESS_MEDIAN` | `numeric` | continuous | 0% |
| `ROUGHNESS_Q3` | `numeric` | continuous | 0% |
| `ROUGHNESS_MAX` | `numeric` | continuous | 0% |
| `ROUGHNESS_SD` | `numeric` | continuous | 0% |
| `ELEVATION_n` | `numeric` | continuous | 0% |
| `ELEVATION_MIN` | `numeric` | continuous | 0% |
| `ELEVATION_Q1` | `numeric` | continuous | 0% |
| `ELEVATION_MEAN` | `numeric` | continuous | 0% |
| `ELEVATION_MEDIAN` | `numeric` | continuous | 0% |
| `ELEVATION_Q3` | `numeric` | continuous | 0% |
| `ELEVATION_MAX` | `numeric` | continuous | 0% |
| `ELEVATION_SD` | `numeric` | continuous | 0% |
| `TREECOVER2000_>=25%TC_PCT` | `numeric` | continuous | 0% |
| `TREECOVER2000_<25%TC_PCT` | `numeric` | continuous | 0% |
| `TREECOVER2000_>=25%TC_AREASQM` | `numeric` | continuous | 0% |
| `TREECOVER2000_<25%TC_AREASQM` | `numeric` | continuous | 0% |
| `LOSSYEAR_0_PCT` | `numeric` | continuous | 0% |
| `LOSSYEAR_1_PCT` | `numeric` | continuous | 1.2% |
| `LOSSYEAR_2_PCT` | `numeric` | continuous | 2.1% |
| `LOSSYEAR_3_PCT` | `numeric` | continuous | 1.5% |
| `LOSSYEAR_4_PCT` | `numeric` | continuous | 1.2% |
| `LOSSYEAR_5_PCT` | `numeric` | continuous | 1% |
| `LOSSYEAR_6_PCT` | `numeric` | continuous | 1.5% |
| `LOSSYEAR_7_PCT` | `numeric` | continuous | 0.6% |
| `LOSSYEAR_8_PCT` | `numeric` | continuous | 1.5% |
| `LOSSYEAR_9_PCT` | `numeric` | continuous | 1% |
| `LOSSYEAR_10_PCT` | `numeric` | continuous | 0.6% |
| `LOSSYEAR_11_PCT` | `numeric` | continuous | 1.5% |
| `LOSSYEAR_12_PCT` | `numeric` | continuous | 0.2% |
| `LOSSYEAR_13_PCT` | `numeric` | continuous | 2.1% |
| `LOSSYEAR_14_PCT` | `numeric` | continuous | 1.7% |
| `LOSSYEAR_15_PCT` | `numeric` | continuous | 1.2% |
| `LOSSYEAR_16_PCT` | `numeric` | continuous | 1.7% |
| `LOSSYEAR_17_PCT` | `numeric` | continuous | 1.7% |
| `LOSSYEAR_18_PCT` | `numeric` | continuous | 4.1% |
| `LOSSYEAR_<NA>_PCT` | `numeric` | continuous | 58.9% |
| `LOSSYEAR_0_AREASQM` | `numeric` | continuous | 0% |
| `LOSSYEAR_1_AREASQM` | `numeric` | continuous | 1.2% |
| `LOSSYEAR_2_AREASQM` | `numeric` | continuous | 2.1% |
| `LOSSYEAR_3_AREASQM` | `numeric` | continuous | 1.5% |
| `LOSSYEAR_4_AREASQM` | `numeric` | continuous | 1.2% |
| `LOSSYEAR_5_AREASQM` | `numeric` | continuous | 1% |
| `LOSSYEAR_6_AREASQM` | `numeric` | continuous | 1.5% |
| `LOSSYEAR_7_AREASQM` | `numeric` | continuous | 0.6% |
| `LOSSYEAR_8_AREASQM` | `numeric` | continuous | 1.5% |
| `LOSSYEAR_9_AREASQM` | `numeric` | continuous | 1% |
| `LOSSYEAR_10_AREASQM` | `numeric` | continuous | 0.6% |
| `LOSSYEAR_11_AREASQM` | `numeric` | continuous | 1.5% |
| `LOSSYEAR_12_AREASQM` | `numeric` | continuous | 0.2% |
| `LOSSYEAR_13_AREASQM` | `numeric` | continuous | 2.1% |
| `LOSSYEAR_14_AREASQM` | `numeric` | continuous | 1.7% |
| `LOSSYEAR_15_AREASQM` | `numeric` | continuous | 1.2% |
| `LOSSYEAR_16_AREASQM` | `numeric` | continuous | 1.7% |
| `LOSSYEAR_17_AREASQM` | `numeric` | continuous | 1.7% |
| `LOSSYEAR_18_AREASQM` | `numeric` | continuous | 4.1% |
| `LOSSYEAR_<NA>_AREASQM` | `numeric` | continuous | 58.9% |
| `LOSS0118_PCT` | `numeric` | continuous | 0% |
| `LOSS0118_<NA>_PCT` | `numeric` | continuous | 0% |
| `LOSS0118_AREASQM` | `numeric` | continuous | 0% |
| `LOSS0118_<NA>_AREASQM` | `numeric` | continuous | 0% |
| `LOSS1218_PCT` | `numeric` | continuous | 0% |
| `LOSS1218_<NA>_PCT` | `numeric` | continuous | 0% |
| `LOSS1218_AREASQM` | `numeric` | continuous | 0% |
| `LOSS1218_<NA>_AREASQM` | `numeric` | continuous | 0% |
| `NFIRESM6` | `integer` | count | 5% |
| `NFIRESV1` | `integer` | count | 1.7% |
| `X_UTM` | `numeric` | continuous | 0% |
| `Y_UTM` | `numeric` | continuous | 0% |
| `X_KM` | `numeric` | continuous | 0% |
| `Y_KM` | `numeric` | continuous | 0% |
| `X_KM_P2` | `numeric` | continuous | 0% |
| `Y_KM_P2` | `numeric` | continuous | 0% |
| `NFIRESM6_PSQKM` | `numeric` | continuous | 5% |
| `NFIRESV1_PSQKM` | `numeric` | continuous | 1.7% |
| `NFIRESM6_PSQKM_PYR` | `numeric` | rate | 0% |
| `NFIRESV1_PSQKM_PYR` | `numeric` | rate | 1.7% |
| `AREASQM_PUA` | `numeric` | continuous | 0% |
| `GEOMORPHONS_FLAT_PUA` | `numeric` | rate | 18.3% |
| `GEOMORPHONS_PEAK_PUA` | `numeric` | rate | 5.8% |
| `GEOMORPHONS_RIDGE_PUA` | `numeric` | rate | 0.6% |
| `GEOMORPHONS_SHOULDER_PUA` | `numeric` | rate | 10.6% |
| `GEOMORPHONS_SPUR_PUA` | `numeric` | rate | 0.8% |
| `GEOMORPHONS_SLOPE_PUA` | `numeric` | rate | 0.2% |
| `GEOMORPHONS_HOLLOW_PUA` | `numeric` | rate | 0.8% |
| `GEOMORPHONS_FOOTSLOPE_PUA` | `numeric` | rate | 8.5% |
| `GEOMORPHONS_VALLEY_PUA` | `numeric` | rate | 0.4% |
| `GEOMORPHONS_PIT_PUA` | `numeric` | rate | 3.1% |
| `TREECOVER2000_>=25%TC_PUA` | `numeric` | rate | 0% |
| `TREECOVER2000_<25%TC_PUA` | `numeric` | rate | 0% |
| `LOSSYEAR_0_PUA` | `numeric` | rate | 0% |
| `LOSSYEAR_1_PUA` | `numeric` | rate | 1.2% |
| `LOSSYEAR_2_PUA` | `numeric` | rate | 2.1% |
| `LOSSYEAR_3_PUA` | `numeric` | rate | 1.5% |
| `LOSSYEAR_4_PUA` | `numeric` | rate | 1.2% |
| `LOSSYEAR_5_PUA` | `numeric` | rate | 1% |
| `LOSSYEAR_6_PUA` | `numeric` | rate | 1.5% |
| `LOSSYEAR_7_PUA` | `numeric` | rate | 0.6% |
| `LOSSYEAR_8_PUA` | `numeric` | rate | 1.5% |
| `LOSSYEAR_9_PUA` | `numeric` | rate | 1% |
| `LOSSYEAR_10_PUA` | `numeric` | rate | 0.6% |
| `LOSSYEAR_11_PUA` | `numeric` | rate | 1.5% |
| `LOSSYEAR_12_PUA` | `numeric` | rate | 0.2% |
| `LOSSYEAR_13_PUA` | `numeric` | rate | 2.1% |
| `LOSSYEAR_14_PUA` | `numeric` | rate | 1.7% |
| `LOSSYEAR_15_PUA` | `numeric` | rate | 1.2% |
| `LOSSYEAR_16_PUA` | `numeric` | rate | 1.7% |
| `LOSSYEAR_17_PUA` | `numeric` | rate | 1.7% |
| `LOSSYEAR_18_PUA` | `numeric` | rate | 4.1% |
| `LOSSYEAR_<NA>_PUA` | `numeric` | rate | 58.9% |
| `LOSS0118_PUA` | `numeric` | rate | 0% |
| `LOSS0118_<NA>_PUA` | `numeric` | rate | 0% |
| `LOSS1218_PUA` | `numeric` | rate | 0% |
| `LOSS1218_<NA>_PUA` | `numeric` | rate | 0% |
| `LOSS0118_<NA>_PCT_PYR` | `numeric` | continuous | 0% |
| `LOSS0118_<NA>_AREASQM_PYR` | `numeric` | continuous | 0% |
| `LOSS0118_<NA>_PUA_PYR` | `numeric` | rate | 0% |
| `LOSS1218_PCT_PYR` | `numeric` | continuous | 0% |
| `LOSS1218_<NA>_PCT_PYR` | `numeric` | continuous | 0% |
| `LOSS1218_AREASQM_PYR` | `numeric` | continuous | 0% |
| `LOSS1218_<NA>_AREASQM_PYR` | `numeric` | continuous | 0% |
| `LOSS1218_PUA_PYR` | `numeric` | rate | 0% |
| `LOSS1218_<NA>_PUA_PYR` | `numeric` | rate | 0% |

### Formule - niveau publication

- formula_pub: LOSS0118_PCT_PYR ~ NFIRESM6_PSQKM_PYR [Spatial Lag Model (SAR) ou Spatial Error Model (SEM), choix base sur le test du multiplicateur de Lagrange + test de Breusch-Pagan + AIC ; contiguite Queen's case, ponderation W row-standardized ; approche 'long-terme' 2001-2018]
- x_terms_pub: NFIRESM6_PSQKM_PYR (densite de points de feu MODIS Collection 6, points/km2/an, filtre 'noise-free')
- y_term_pub: LOSS0118_PCT_PYR (perte moyenne de couvert forestier par an, % de la surface de la cellule, periode 2001-2018)
- Reference publication: Martinez Batlle, J.R. (2021), Fire and forest loss in the Dominican Republic during the 21st Century, bioRxiv, doi:10.1101/2021.06.15.448604. Fichier grd_zonal_statistics.RDS extrait directement du depot Zenodo (10.5281/zenodo.6990803, isSupplementTo le papier), lui-meme reference dans le depot comme le jeu de donnees exact de l'approche 'long-terme' (grille hexagonale de 482 cellules ~100km2, >=45% de surface terrestre, texte du papier section 'Long-term approach') -- pas une reconstruction. Y et X correspondent exactement a la description du papier ('average forest loss per unit area per year' et 'fire density' = points de feu / aire / annees). NFIRESM6_PSQKM_PYR est NA pour 24/482 cellules (aucune valeur exacte de 0 n'existe ailleurs dans la colonne source, minimum non-NA = 1) -- impute a 0 (absence de feu detecte dans la cellule), coherent avec la definition de densite du papier (comptage/aire/annees), pas une donnee fabriquee.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: LOSS0118_PCT_PYR ~ NFIRESM6_PSQKM_PYR
- x_terms_used: NFIRESM6_PSQKM_PYR
- y_term_used: LOSS0118_PCT_PYR
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "LOSS0118_PCT_PYR ~ NFIRESM6_PSQKM_PYR"
    response: "LOSS0118_PCT_PYR (perte moyenne de couvert forestier par an, % de la surface de la cellule, periode 2001-2018)"
    predictors: ["NFIRESM6_PSQKM_PYR (densite de points de feu MODIS Collection 6, points/km2/an, filtre 'noise-free')"]
    role: "simple_baseline"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "spatial_baseline"]
    status: "confirmed"

  multivariate_constrained:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "paper_main_specification"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

  ml_or_selected:
    formula: "LOSS0118_PCT_PYR ~ NFIRESM6_PSQKM_PYR"
    response: "LOSS0118_PCT_PYR"
    predictors: ["NFIRESM6_PSQKM_PYR"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["sar_lag", "sar_error", "spatial_error_model", "spatial_lag_model", "ols"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_fire_forest_loss_dominican_republic`
- Dataset name: Dataset for: Fire and forest loss in the Dominican Republic during the 21st Century
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Fire and forest loss in the Dominican Republic during the 21st Century
- Paper DOI: 10.1101/2021.06.15.448604
- Dataset DOI: 10.5281/zenodo.6990803
- Source URL: https://doi.org/10.5281/zenodo.6990803
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "LOSS0118_PCT_PYR ~ NFIRESM6_PSQKM_PYR [Spatial Lag Model (SAR) ou Spatial Error Model (SEM), choix base sur le test du multiplicateur de Lagrange + test de Breusch-Pagan + AIC ; contiguite Queen's case, ponderation W row-standardized ; approche 'long-terme' 2001-2018]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Martinez Batlle, J.R. (2021), Fire and forest loss in the Dominican Republic during the 21st Century, bioRxiv, doi:10.1101/2021.06.15.448604. Fichier grd_zonal_statistics.RDS extrait directement du depot Zenodo (10.5281/zenodo.6990803, isSupplementTo le papier), lui-meme reference dans le depot comme le jeu de donnees exact de l'approche 'long-terme' (grille hexagonale de 482 cellules ~100km2, >=45% de surface terrestre, texte du papier section 'Long-term approach') -- pas une reconstruction. Y et X correspondent exactement a la description du papier ('average forest loss per unit area per year' et 'fire density' = points de feu / aire / annees). NFIRESM6_PSQKM_PYR est NA pour 24/482 cellules (aucune valeur exacte de 0 n'existe ailleurs dans la colonne source, minimum non-NA = 1) -- impute a 0 (absence de feu detecte dans la cellule), coherent avec la definition de densite du papier (comptage/aire/annees), pas une donnee fabriquee."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "NFIRESM6_PSQKM_PYR impute a 0 pour 24/482 cellules (NA source = absence de feu detecte, verifie via l'absence de tout 0 exact ailleurs dans la colonne) -- documente, pas une donnee fabriquee"
  reason: "Y continu reel (LOSS0118_PCT_PYR, perte de couvert forestier), X continu reel (densite de feux MODIS), formule bivariee exacte du papier (section 'Long-term approach'), geometrie polygonale hexagonale originale (grd_zonal_statistics.RDS extrait directement du depot Zenodo cite en isSupplementTo, pas une reconstruction), N=482 identique au depot source. Decouvert via le pipeline dataset-first (recherche directe Zenodo/Dryad, session 2026-08-16), papier lu integralement (TEI) pour confirmer formule et estimateur (Spatial Lag/Error Model)."
```

- Decision: ready
- Manque principal: NFIRESM6_PSQKM_PYR impute a 0 pour 24/482 cellules (NA source = absence de feu detecte, verifie via l'absence de tout 0 exact ailleurs dans la colonne) -- documente, pas une donnee fabriquee
- Raison: Y continu reel (LOSS0118_PCT_PYR, perte de couvert forestier), X continu reel (densite de feux MODIS), formule bivariee exacte du papier (section 'Long-term approach'), geometrie polygonale hexagonale originale (grd_zonal_statistics.RDS extrait directement du depot Zenodo cite en isSupplementTo, pas une reconstruction), N=482 identique au depot source. Decouvert via le pipeline dataset-first (recherche directe Zenodo/Dryad, session 2026-08-16), papier lu integralement (TEI) pour confirmer formule et estimateur (Spatial Lag/Error Model).

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready"
  eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
  conditionally_eligible_estimators: []
  ineligible_reason: ""
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 482
- k variables: 166
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 32619
- CRS nom: WGS 84 / UTM zone 19N
- Spatial extent: x [192985.004486959, 563711.630966066], y [1961492.46035016, 2203449.7237167]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Attribution 4.0 International
- License URL: https://creativecommons.org/licenses/by/4.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5281/zenodo.6990803 (checked 2026-08-18): rightsList = 'Creative Commons Attribution 4.0 International'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`fire_forest_loss_dominican_republic` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `fire_forest_loss_dominican_republic` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (32619).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20%: GEOMORPHONS_<NA> (NA=65.8%), GEOMORPHONS_<NA>_AREASQM (NA=65.8%), LOSSYEAR_<NA>_PCT (NA=58.9%), LOSSYEAR_<NA>_AREASQM (NA=58.9%), LOSSYEAR_<NA>_PUA (NA=58.9%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`fire_forest_loss_dominican_republic` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Fire and forest loss in the Dominican Republic during the 21st Century

