---
title: paper_wildfire_bootleg_severity
type: dataset
created: 2026-09-14
updated: 2026-09-16
sources:
  - data/final_datasets/sf/paper_wildfire_bootleg_severity.rds
  - DataCite_2024_LearningFromWildfiresA_10_1002_ecs2_700
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Learning from wildfires: A scalable framework to evaluate treatment effects on burn severity" (DOI 10.1002/ecs2.70073).

## Description du jeu de donnees

- Topic: risques naturels / effets des traitements sur la severite des feux
- Observation unit: pixel spatial (grille de 30m rééchantillonnée) au sein du perimetre forestier de l'incendie
- Observed population: pixels forestiers du perimetre de l'incendie (Bootleg, Oregon, ou Schneider Springs, Washington, 2021), RdNBR continu (toutes classes de severite) et covariables bioclimatiques, meteorologiques, topographiques, structurelles et de gestion
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
- Published X variables from paper: minrh, LF2020_CC, annual_tmmin_anl_mean_1981_2010, annual_deficit_1981_2010, distance_to_trt_edge, tri_10res_410win, scf, fm100, gedi_rh100_mean, gedi_rh100_sd, northsouthness_mx_speed_direction_20230501
- Published X count: 11
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `rdnbr` | `numeric` | continuous | [-13871.7871, 12647.5479] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `wildfire_bootleg_severity`, la ou les reponses `rdnbr` viennent du loader papier et/ou des preuves de l article `Learning from wildfires: A scalable framework to evaluate treatment effects on burn severity`. Les covariables X retenues sont `minrh`, `LF2020_CC`, `annual_tmmin_anl_mean_1981_2010`, `annual_deficit_1981_2010`, `distance_to_trt_edge`, `tri_10res_410win`, `scf`, `fm100`, `gedi_rh100_mean`, `gedi_rh100_sd`, `northsouthness_mx_speed_direction_20230501` ; 25 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

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

- formula_pub: rdnbr ~ treatment_type_x_time_since_treatment + top predictors RF + W [SAR, lag=35m]
- x_terms_pub: minrh, LF2020_CC, annual_tmmin_anl_mean_1981_2010, annual_deficit_1981_2010, distance_to_trt_edge, tri_10res_410win, scf, fm100, gedi_rh100_mean, gedi_rh100_sd, northsouthness_mx_speed_direction_20230501
- y_term_pub: rdnbr
- Reference publication: Chamberlain et al. (2024), Ecosphere, DOI 10.1002/ecs2.70073; README.md + csvs/predictor_variables.csv (Dryad 10.5061/dryad.mcvdnck6c) documentent RdNBR (severity/2021_Bootleg_rdnbr_w_offset_DATESADJUSTED.tif, 30m) et 35 predicteurs candidats. 3 couches documentees (aspect_10res, ecostress_pet, ecostress_esi) absentes du depot Dryad public (verifie 2026-08-12) -- non devinees. Methode verifiee par lecture directe du PDF (2026-09-10) : Random Forest (Fig. 1, etape 1) sur l'ensemble des predicteurs continus apres reduction de colinearite (Spearman) ramene a 11 variables retenues (Fig. 4a) ; ces 3 variables (RH, TMIN, TRI-410m, une par categorie bioclimatique/meteo/topographique) servent a apparier 300 controles a 300 traitements (etape 2) ; modele SAR final (etape 3, lag=35m, pseudo-R2 Nagelkerke=0.92) evalue l'effet du type de traitement x temps depuis traitement en controlant pour les 11 variables retenues. Tout reprojete/reechantillonne le 2026-08-12 vers une grille commune Albers EPSG:5070 a 250m (bilineaire pour les variables continues, plus-proche-voisin pour les masques) -- resolution native du papier : 30m.

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d estimation: formule systeme generee (formula_pub confirmee mais non reprise telle quelle -- voir Note ci-dessous)
- Correspondance Python/R: aucune identifiee
- Note: Le papier n'ajuste PAS une regression lineaire/SAR sur les 34 predicteurs bruts disponibles dans le depot : (1) un Random Forest reduit d'abord ces predicteurs a 11 variables retenues par importance (Fig. 4a, apres reduction de colinearite par correlations de Spearman) ; (2) ces variables servent aussi a apparier 300 unites traitees a 300 controles non traites (matching sur RH, TMIN et TRI uniquement, un par categorie) ; (3) le modele SAR final utilise en X les 11 variables retenues PLUS le type de traitement et le temps depuis traitement (categoriel), avec une structure spatiale (lag=35m). formula_used ne reprend que les 11 variables continues retenues par le RF (correspondance verifiee colonne par colonne avec Table 2 et Figure 4a de l'article) -- treatment_type et time_since_treatment sont ABSENTS de l'artefact local (35 colonnes disponibles, aucune ne code le type/l'age de traitement), donc le coeur du modele publie (l'effet du traitement, objet meme de l'article) n'est pas reproductible ici. Precedemment la fiche listait les 34 predicteurs bruts comme si c'etait 'le' modele SAR publie, avec Statut='resolu'/'formule publication confirmee et utilisee' -- confondait les variables candidates pre-reduction avec la specification econometrique reelle (signale par l'utilisateur 2026-09-10, verifie par lecture directe du PDF, p.6-14).

### Formule - niveau systeme

- formula_used: rdnbr ~ minrh + LF2020_CC + annual_tmmin_anl_mean_1981_2010 + annual_deficit_1981_2010 + distance_to_trt_edge + tri_10res_410win + scf + fm100 + gedi_rh100_mean + gedi_rh100_sd + northsouthness_mx_speed_direction_20230501
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: minrh, LF2020_CC, annual_tmmin_anl_mean_1981_2010, annual_deficit_1981_2010, distance_to_trt_edge, tri_10res_410win, scf, fm100, gedi_rh100_mean, gedi_rh100_sd, northsouthness_mx_speed_direction_20230501
- y_term_used: rdnbr
- Note: Chamberlain et al. (2024), Ecosphere, Fig. 1 (cadre en 3 etapes RF -> appariement -> SAR), Fig. 4a (importance RF, Nagelkerke pseudo-R2=0.92, RMSE=208), p.10 (equation SAR, 300 unites traitees/controles appariees sur RH/TMIN/TRI-410m). Predicteurs RF retenus : RH, canopy cover, TMIN, CWD, distance au bord de traitement, TRI-410m, snow cover frequency, FM100, GEDI height mean/SD, wind northsouthness. Voir formula_used_divergence_note pour l'ecart avec formula_used.

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
    formula: "rdnbr ~ minrh + LF2020_CC + annual_tmmin_anl_mean_1981_2010 + annual_deficit_1981_2010 + distance_to_trt_edge + tri_10res_410win + scf + fm100 + gedi_rh100_mean + gedi_rh100_sd + northsouthness_mx_speed_direction_20230501"
    response: "rdnbr"
    predictors: ["minrh", "LF2020_CC", "annual_tmmin_anl_mean_1981_2010", "annual_deficit_1981_2010", "distance_to_trt_edge", "tri_10res_410win", "scf", "fm100", "gedi_rh100_mean", "gedi_rh100_sd", "northsouthness_mx_speed_direction_20230501"]
    role: "benchmark_simplified_specification"
    source_type: "derived_from_scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
    status: "executable_approximation"

  ml_or_selected:
    formula: "rdnbr ~ annual_aet_1981_2010 + annual_deficit_1981_2010 + annual_pet_1981_2010 + annual_ppt_anl_total_1981_2010 + annual_tmmean_anl_mean_1981_2010 + annual_tmmin_anl_mean_1981_2010 + distance_to_roads + distance_to_streams_wetlands + distance_to_trt_edge + frs + gedi_rh100_mean + gedi_rh100_sd + erc + fm100 + fm1000 + minrh + tmmx + vpd + LF2020_CBD + LF2020_CC + LF2020_CH + scf + sdd + elevation_10res + hli_10res + slope_10res + sri_10res + tpi_10res_2010win + tpi_10res_410win + tpi_10res_8010win + tri_10res_410win + eastwestness_mx_speed_direction_20230501 + mx_speed_20230501 + northsouthness_mx_speed_direction_20230501"
    response: "rdnbr"
    predictors: ["annual_aet_1981_2010", "annual_deficit_1981_2010", "annual_pet_1981_2010", "annual_ppt_anl_total_1981_2010", "annual_tmmean_anl_mean_1981_2010", "annual_tmmin_anl_mean_1981_2010", "distance_to_roads", "distance_to_streams_wetlands", "distance_to_trt_edge", "frs", "gedi_rh100_mean", "gedi_rh100_sd", "erc", "fm100", "fm1000", "minrh", "tmmx", "vpd", "LF2020_CBD", "LF2020_CC", "LF2020_CH", "scf", "sdd", "elevation_10res", "hli_10res", "slope_10res", "sri_10res", "tpi_10res_2010win", "tpi_10res_410win", "tpi_10res_8010win", "tri_10res_410win", "eastwestness_mx_speed_direction_20230501", "mx_speed_20230501", "northsouthness_mx_speed_direction_20230501"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["random_forest", "random_forest_xy", "xgboost", "xgboost_xy"]
    status: "confirmed_predictor_pool_before_rf_reduction"
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
- Year: 2024

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "rdnbr ~ treatment_type_x_time_since_treatment + top predictors RF + W [SAR, lag=35m]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Chamberlain et al. (2024), Ecosphere, DOI 10.1002/ecs2.70073; README.md + csvs/predictor_variables.csv (Dryad 10.5061/dryad.mcvdnck6c) documentent RdNBR (severity/2021_Bootleg_rdnbr_w_offset_DATESADJUSTED.tif, 30m) et 35 predicteurs candidats. 3 couches documentees (aspect_10res, ecostress_pet, ecostress_esi) absentes du depot Dryad public (verifie 2026-08-12) -- non devinees. Methode verifiee par lecture directe du PDF (2026-09-10) : Random Forest (Fig. 1, etape 1) sur l'ensemble des predicteurs continus apres reduction de colinearite (Spearman) ramene a 11 variables retenues (Fig. 4a) ; ces 3 variables (RH, TMIN, TRI-410m, une par categorie bioclimatique/meteo/topographique) servent a apparier 300 controles a 300 traitements (etape 2) ; modele SAR final (etape 3, lag=35m, pseudo-R2 Nagelkerke=0.92) evalue l'effet du type de traitement x temps depuis traitement en controlant pour les 11 variables retenues. Tout reprojete/reechantillonne le 2026-08-12 vers une grille commune Albers EPSG:5070 a 250m (bilineaire pour les variables continues, plus-proche-voisin pour les masques) -- resolution native du papier : 30m."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "grille reechantillonnee a 250m Albers depuis des sources heterogenes (9m a 1000m, resolution native du papier 30m) -- compromis documente ; 3 couches (aspect_10res, ecostress_pet, ecostress_esi) absentes du depot Dryad public ; treatment_type et time_since_treatment (les predicteurs centraux du modele SAR publie sur l'effet des traitements) sont ABSENTS de l'artefact local -- corrige 2026-09-10, le modele publie n'est pas reproductible tel quel ici (voir Bloc 1, formula_used_divergence_note)"
  reason: "Tache benchmark : predire rdnbr (continu, reel) a partir des covariables environnementales retenues par le Random Forest du papier (11 variables, Fig. 4a) -- distincte de la tache causale du papier (effet du traitement sur la severite via SAR), qui necessite treatment_type/time_since_treatment absents du depot local. Y et X reels/documentes (pas inventes), artefact local utilisable pour cette tache de regression -- corrige 2026-09-10 (la fiche affirmait auparavant a tort que les 34 predicteurs bruts formaient le modele SAR publie)."
```

- Decision: ready
- Manque principal: grille reechantillonnee a 250m Albers depuis des sources heterogenes (9m a 1000m, resolution native du papier 30m) -- compromis documente ; 3 couches (aspect_10res, ecostress_pet, ecostress_esi) absentes du depot Dryad public ; treatment_type et time_since_treatment (les predicteurs centraux du modele SAR publie sur l'effet des traitements) sont ABSENTS de l'artefact local -- corrige 2026-09-10, le modele publie n'est pas reproductible tel quel ici (voir Bloc 1, formula_used_divergence_note)
- Raison: Tache benchmark : predire rdnbr (continu, reel) a partir des covariables environnementales retenues par le Random Forest du papier (11 variables, Fig. 4a) -- distincte de la tache causale du papier (effet du traitement sur la severite via SAR), qui necessite treatment_type/time_since_treatment absents du depot local. Y et X reels/documentes (pas inventes), artefact local utilisable pour cette tache de regression -- corrige 2026-09-10 (la fiche affirmait auparavant a tort que les 34 predicteurs bruts formaient le modele SAR publie).

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready"
  eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
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
- Spatial resolution: point observation (support reel : pixel spatial d'une grille de 30 m rechantillonnee au sein du perimetre de l'incendie)
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 5070
- CRS nom: NAD83 / Conus Albers
- Spatial extent: x [-2051367.72382883, -1994117.72382883], y [2421979.97446648, 2479729.97446648]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: aucune reprojection necessaire -- CRS deja projete et metrique. (EPSG:5070, NAD83 / Conus Albers)

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.mcvdnck6c (checked 2026-09-14): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`wildfire_bootleg_severity` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `wildfire_bootleg_severity` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formula_pub confirmee et verifiee (voir Reference publication) ; formula_used est une approximation generee distincte, explicitement etiquetee comme telle (voir Bloc 1 > Statut regression canonique > Note).
- CRS: OK - CRS renseigne dans le Bloc 5 (5070).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`wildfire_bootleg_severity` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Learning from wildfires: A scalable framework to evaluate treatment effects on burn severity

## Curation documentée — 2026-09-07

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

Correction 2026-09-16 (mode production de secours) : le champ 'CRS analyse recommande' affirmait a tort que le CRS source etait non geographique/inconnu alors qu'il etait deja renseigne juste au-dessus -- corrige (voir le champ lui-meme pour le texte actuel).
