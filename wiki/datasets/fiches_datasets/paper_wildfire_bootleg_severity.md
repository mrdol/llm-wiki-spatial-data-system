---
title: paper_wildfire_bootleg_severity
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_wildfire_bootleg_severity.rds
  - DataCite_2024_LearningFromWildfiresA_10_1002_ecs2_700
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Learning from wildfires: A scalable framework to evaluate treatment effects on burn severity" (DOI 10.1002/ecs2.70073).

## Description du jeu de donnees

- Topic: risques naturels / recuperation post-incendie
- Observation unit: pixel spatial echantillonne depuis une grille de feu de haute severite
- Observed population: pixels d'incendies de haute severite aux Etats-Unis, avec NBR post-feu et covariables climat/sol/topographie
- Geographic context: etendue sf: x [-2051367.72382883, -1994117.72382883], y [2421979.97446648, 2479729.97446648]
- Temporal context: none (cross-sectional)
- Source description: Learning from wildfires: A scalable framework to evaluate treatment effects on burn severity
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1002/ecs2.70073
- Dataset DOI: 10.5061/dryad.mcvdnck6c
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.mcvdnck6c
- Local raw dir: `data/raw/papers/DataCite_2024_LearningFromWildfiresA_10_1002_ecs2_700/`
- Local sf output: `data/final_datasets/sf/paper_wildfire_bootleg_severity.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `rdnbr`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `annual_aet_1981_2010`, `annual_deficit_1981_2010`, `annual_pet_1981_2010`, `annual_ppt_anl_total_1981_2010`, `annual_tmmean_anl_mean_1981_2010`, `annual_tmmin_anl_mean_1981_2010`, `distance_to_roads`, `distance_to_streams_wetlands`, `distance_to_trt_edge`, `frs`, `gedi_rh100_mean`, `gedi_rh100_sd`, `erc`, `fm100`, `fm1000`, `minrh`, `tmmx`, `vpd`, `LF2020_CBD`, `LF2020_CC`, `LF2020_CH`, `forest_mask`, `ownership_mask`, `scf`, `sdd`, `elevation_10res`, `hli_10res`, `slope_10res`, `sri_10res`, `tpi_10res_2010win`, `tpi_10res_410win`, `tpi_10res_8010win`, `tri_10res_410win`, `eastwestness_mx_speed_direction_20230501`, `mx_speed_20230501`, `northsouthness_mx_speed_direction_20230501`
- Candidate X count in local artifact: 36
- Candidate X typology: continuous, categorical
- Published X variables from paper: annual_aet_1981_2010, annual_deficit_1981_2010, annual_pet_1981_2010, annual_ppt_anl_total_1981_2010, annual_tmmean_anl_mean_1981_2010, annual_tmmin_anl_mean_1981_2010, distance_to_roads, distance_to_streams_wetlands, distance_to_trt_edge, frs, gedi_rh100_mean, gedi_rh100_sd, erc, fm100, fm1000, minrh, tmmx, vpd, LF2020_CBD, LF2020_CC, LF2020_CH, scf, sdd, elevation_10res, hli_10res, slope_10res, sri_10res, tpi_10res_2010win, tpi_10res_410win, tpi_10res_8010win, tri_10res_410win, eastwestness_mx_speed_direction_20230501, mx_speed_20230501, northsouthness_mx_speed_direction_20230501
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `rdnbr` | `numeric` | continuous | [-13871.7871, 12647.5479] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `wildfire_bootleg_severity`, la ou les reponses `rdnbr` viennent du loader papier et/ou des preuves de l article `Learning from wildfires: A scalable framework to evaluate treatment effects on burn severity`. Les covariables X retenues sont `annual_aet_1981_2010`, `annual_deficit_1981_2010`, `annual_pet_1981_2010`, `annual_ppt_anl_total_1981_2010`, `annual_tmmean_anl_mean_1981_2010`, `annual_tmmin_anl_mean_1981_2010`, `distance_to_roads`, `distance_to_streams_wetlands`, `distance_to_trt_edge`, `frs`, `gedi_rh100_mean`, `gedi_rh100_sd`, `erc`, `fm100`, `fm1000`, `minrh`, `tmmx`, `vpd`, `LF2020_CBD`, `LF2020_CC`, `LF2020_CH`, `scf`, `sdd`, `elevation_10res`, `hli_10res`, `slope_10res`, `sri_10res`, `tpi_10res_2010win`, `tpi_10res_410win`, `tpi_10res_8010win`, `tri_10res_410win`, `eastwestness_mx_speed_direction_20230501`, `mx_speed_20230501`, `northsouthness_mx_speed_direction_20230501` ; 2 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `annual_aet_1981_2010` | `numeric` | continuous | 0% |
| `annual_deficit_1981_2010` | `numeric` | continuous | 0% |
| `annual_pet_1981_2010` | `numeric` | continuous | 0% |
| `annual_ppt_anl_total_1981_2010` | `numeric` | continuous | 0% |
| `annual_tmmean_anl_mean_1981_2010` | `numeric` | continuous | 0% |
| `annual_tmmin_anl_mean_1981_2010` | `numeric` | continuous | 0% |
| `distance_to_roads` | `numeric` | continuous | 0% |
| `distance_to_streams_wetlands` | `numeric` | continuous | 0% |
| `distance_to_trt_edge` | `numeric` | continuous | 0% |
| `frs` | `numeric` | rate | 0% |
| `gedi_rh100_mean` | `numeric` | continuous | 0% |
| `gedi_rh100_sd` | `numeric` | continuous | 0% |
| `erc` | `numeric` | continuous | 0% |
| `fm100` | `numeric` | continuous | 0% |
| `fm1000` | `numeric` | continuous | 0% |
| `minrh` | `numeric` | continuous | 0% |
| `tmmx` | `numeric` | continuous | 0% |
| `vpd` | `numeric` | continuous | 0% |
| `LF2020_CBD` | `numeric` | rate | 0% |
| `LF2020_CC` | `numeric` | continuous | 0% |
| `LF2020_CH` | `numeric` | continuous | 0% |
| `forest_mask` | `numeric` | binary | 0% |
| `ownership_mask` | `numeric` | binary | 0% |
| `scf` | `numeric` | rate | 0% |
| `sdd` | `numeric` | continuous | 0% |
| `elevation_10res` | `numeric` | continuous | 0% |
| `hli_10res` | `numeric` | rate | 0% |
| `slope_10res` | `numeric` | continuous | 0% |
| `sri_10res` | `numeric` | rate | 0% |
| `tpi_10res_2010win` | `numeric` | continuous | 0% |
| `tpi_10res_410win` | `numeric` | continuous | 0% |
| `tpi_10res_8010win` | `numeric` | continuous | 0% |
| `tri_10res_410win` | `numeric` | continuous | 0% |
| `eastwestness_mx_speed_direction_20230501` | `numeric` | continuous | 0% |
| `mx_speed_20230501` | `numeric` | continuous | 0% |
| `northsouthness_mx_speed_direction_20230501` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: rdnbr ~ annual_aet_1981_2010 + annual_deficit_1981_2010 + annual_pet_1981_2010 + annual_ppt_anl_total_1981_2010 + annual_tmmean_anl_mean_1981_2010 + annual_tmmin_anl_mean_1981_2010 + distance_to_roads + distance_to_streams_wetlands + distance_to_trt_edge + frs + gedi_rh100_mean + gedi_rh100_sd + erc + fm100 + fm1000 + minrh + tmmx + vpd + LF2020_CBD + LF2020_CC + LF2020_CH + scf + sdd + elevation_10res + hli_10res + slope_10res + sri_10res + tpi_10res_2010win + tpi_10res_410win + tpi_10res_8010win + tri_10res_410win + eastwestness_mx_speed_direction_20230501 + mx_speed_20230501 + northsouthness_mx_speed_direction_20230501 [modele SAR complet du papier, matching de traitement -- non reproduit ici, benchmark sur les predicteurs bruts]
- x_terms_pub: annual_aet_1981_2010, annual_deficit_1981_2010, annual_pet_1981_2010, annual_ppt_anl_total_1981_2010, annual_tmmean_anl_mean_1981_2010, annual_tmmin_anl_mean_1981_2010, distance_to_roads, distance_to_streams_wetlands, distance_to_trt_edge, frs, gedi_rh100_mean, gedi_rh100_sd, erc, fm100, fm1000, minrh, tmmx, vpd, LF2020_CBD, LF2020_CC, LF2020_CH, scf, sdd, elevation_10res, hli_10res, slope_10res, sri_10res, tpi_10res_2010win, tpi_10res_410win, tpi_10res_8010win, tri_10res_410win, eastwestness_mx_speed_direction_20230501, mx_speed_20230501, northsouthness_mx_speed_direction_20230501
- y_term_pub: rdnbr
- Reference publication: Chamberlain et al. (2024), Ecosphere, DOI 10.1002/ecs2.70073; README.md + csvs/predictor_variables.csv (Dryad 10.5061/dryad.mcvdnck6c, fournis par les auteurs) documentent RdNBR (severity/2021_Bootleg_rdnbr_w_offset_DATESADJUSTED.tif, 30m) comme reponse et la liste exacte des 35 predicteurs du modele du papier. Verifie le 2026-08-12 par recherche exhaustive dans l'archive : 3 couches documentees (aspect_10res, ecostress_pet, ecostress_esi) sont absentes du depot Dryad public (memes 2 fires) -- non devinees, simplement absentes. formula_used utilise les 34 predicteurs reellement presents (forest_mask/ownership_mask exclus : ce sont des masques de zone d'etude, pas des covariables du papier). Tout reprojete/reechantillonne le 2026-08-12 vers une grille commune Albers EPSG:5070 a 250m (bilineaire pour les variables continues, plus-proche-voisin pour les masques).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: rdnbr ~ annual_aet_1981_2010 + annual_deficit_1981_2010 + annual_pet_1981_2010 + annual_ppt_anl_total_1981_2010 + annual_tmmean_anl_mean_1981_2010 + annual_tmmin_anl_mean_1981_2010 + distance_to_roads + distance_to_streams_wetlands + distance_to_trt_edge + frs + gedi_rh100_mean + gedi_rh100_sd + erc + fm100 + fm1000 + minrh + tmmx + vpd + LF2020_CBD + LF2020_CC + LF2020_CH + scf + sdd + elevation_10res + hli_10res + slope_10res + sri_10res + tpi_10res_2010win + tpi_10res_410win + tpi_10res_8010win + tri_10res_410win + eastwestness_mx_speed_direction_20230501 + mx_speed_20230501 + northsouthness_mx_speed_direction_20230501
- x_terms_used: annual_aet_1981_2010, annual_deficit_1981_2010, annual_pet_1981_2010, annual_ppt_anl_total_1981_2010, annual_tmmean_anl_mean_1981_2010, annual_tmmin_anl_mean_1981_2010, distance_to_roads, distance_to_streams_wetlands, distance_to_trt_edge, frs, gedi_rh100_mean, gedi_rh100_sd, erc, fm100, fm1000, minrh, tmmx, vpd, LF2020_CBD, LF2020_CC, LF2020_CH, scf, sdd, elevation_10res, hli_10res, slope_10res, sri_10res, tpi_10res_2010win, tpi_10res_410win, tpi_10res_8010win, tri_10res_410win, eastwestness_mx_speed_direction_20230501, mx_speed_20230501, northsouthness_mx_speed_direction_20230501
- y_term_used: rdnbr
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "simple_baseline"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

  multivariate_constrained:
    formula: "rdnbr ~ annual_aet_1981_2010 + annual_deficit_1981_2010 + annual_pet_1981_2010 + annual_ppt_anl_total_1981_2010 + annual_tmmean_anl_mean_1981_2010 + annual_tmmin_anl_mean_1981_2010 + distance_to_roads + distance_to_streams_wetlands + distance_to_trt_edge + frs + gedi_rh100_mean + gedi_rh100_sd + erc + fm100 + fm1000 + minrh + tmmx + vpd + LF2020_CBD + LF2020_CC + LF2020_CH + scf + sdd + elevation_10res + hli_10res + slope_10res + sri_10res + tpi_10res_2010win + tpi_10res_410win + tpi_10res_8010win + tri_10res_410win + eastwestness_mx_speed_direction_20230501 + mx_speed_20230501 + northsouthness_mx_speed_direction_20230501"
    response: "rdnbr"
    predictors: ["annual_aet_1981_2010", "annual_deficit_1981_2010", "annual_pet_1981_2010", "annual_ppt_anl_total_1981_2010", "annual_tmmean_anl_mean_1981_2010", "annual_tmmin_anl_mean_1981_2010", "distance_to_roads", "distance_to_streams_wetlands", "distance_to_trt_edge", "frs", "gedi_rh100_mean", "gedi_rh100_sd", "erc", "fm100", "fm1000", "minrh", "tmmx", "vpd", "LF2020_CBD", "LF2020_CC", "LF2020_CH", "scf", "sdd", "elevation_10res", "hli_10res", "slope_10res", "sri_10res", "tpi_10res_2010win", "tpi_10res_410win", "tpi_10res_8010win", "tri_10res_410win", "eastwestness_mx_speed_direction_20230501", "mx_speed_20230501", "northsouthness_mx_speed_direction_20230501"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "ml_candidate_features"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_wildfire_bootleg_severity`
- Dataset name: Data from: Learning from wildfires: a scalable framework to evaluate treatment effects on burn severity
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Learning from wildfires: A scalable framework to evaluate treatment effects on burn severity
- Paper DOI: 10.1002/ecs2.70073
- Dataset DOI: 10.5061/dryad.mcvdnck6c
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.mcvdnck6c
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "rdnbr ~ annual_aet_1981_2010 + annual_deficit_1981_2010 + annual_pet_1981_2010 + annual_ppt_anl_total_1981_2010 + annual_tmmean_anl_mean_1981_2010 + annual_tmmin_anl_mean_1981_2010 + distance_to_roads + distance_to_streams_wetlands + distance_to_trt_edge + frs + gedi_rh100_mean + gedi_rh100_sd + erc + fm100 + fm1000 + minrh + tmmx + vpd + LF2020_CBD + LF2020_CC + LF2020_CH + scf + sdd + elevation_10res + hli_10res + slope_10res + sri_10res + tpi_10res_2010win + tpi_10res_410win + tpi_10res_8010win + tri_10res_410win + eastwestness_mx_speed_direction_20230501 + mx_speed_20230501 + northsouthness_mx_speed_direction_20230501 [modele SAR complet du papier, matching de traitement -- non reproduit ici, benchmark sur les predicteurs bruts]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Chamberlain et al. (2024), Ecosphere, DOI 10.1002/ecs2.70073; README.md + csvs/predictor_variables.csv (Dryad 10.5061/dryad.mcvdnck6c, fournis par les auteurs) documentent RdNBR (severity/2021_Bootleg_rdnbr_w_offset_DATESADJUSTED.tif, 30m) comme reponse et la liste exacte des 35 predicteurs du modele du papier. Verifie le 2026-08-12 par recherche exhaustive dans l'archive : 3 couches documentees (aspect_10res, ecostress_pet, ecostress_esi) sont absentes du depot Dryad public (memes 2 fires) -- non devinees, simplement absentes. formula_used utilise les 34 predicteurs reellement presents (forest_mask/ownership_mask exclus : ce sont des masques de zone d'etude, pas des covariables du papier). Tout reprojete/reechantillonne le 2026-08-12 vers une grille commune Albers EPSG:5070 a 250m (bilineaire pour les variables continues, plus-proche-voisin pour les masques)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "grille reechantillonnee a 250m Albers depuis des sources heterogenes (9m a 1000m) -- compromis de resolution documente, pas la resolution native de chaque couche ; 3 couches documentees dans predictor_variables.csv du papier (aspect_10res, ecostress_pet, ecostress_esi) absentes du depot Dryad public"
  reason: "rdnbr continu et 34 des 35 predicteurs documentes par les auteurs (csvs/predictor_variables.csv) confirmes et alignes (2026-08-12). Y continu, X defendables (liste exacte des auteurs, ecart documente pas invente), artefact local utilisable -- promu sans revue manuelle (2026-08-12)."
```

- Decision: ready
- Manque principal: grille reechantillonnee a 250m Albers depuis des sources heterogenes (9m a 1000m) -- compromis de resolution documente, pas la resolution native de chaque couche ; 3 couches documentees dans predictor_variables.csv du papier (aspect_10res, ecostress_pet, ecostress_esi) absentes du depot Dryad public
- Raison: rdnbr continu et 34 des 35 predicteurs documentes par les auteurs (csvs/predictor_variables.csv) confirmes et alignes (2026-08-12). Y continu, X defendables (liste exacte des auteurs, ecart documente pas invente), artefact local utilisable -- promu sans revue manuelle (2026-08-12).

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
- N observations: 15430
- k variables: 39
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 5070
- CRS nom: NAD83 / Conus Albers
- Spatial extent: x [-2051367.72382883, -1994117.72382883], y [2421979.97446648, 2479729.97446648]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.mcvdnck6c (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`wildfire_bootleg_severity` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `wildfire_bootleg_severity` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (5070).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`wildfire_bootleg_severity` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Learning from wildfires: A scalable framework to evaluate treatment effects on burn severity

