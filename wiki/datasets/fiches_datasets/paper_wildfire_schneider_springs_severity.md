---
title: paper_wildfire_schneider_springs_severity
type: dataset
created: 2026-09-14
updated: 2026-09-16
sources:
  - data/final_datasets/sf/paper_wildfire_schneider_springs_severity.rds
  - DataCite_2024_LearningFromWildfiresA_10_1002_ecs2_700
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Learning from wildfires: A scalable framework to evaluate treatment effects on burn severity" (DOI 10.1002/ecs2.70073).

## Description du jeu de donnees

- Topic: risques naturels / effets des traitements sur la severite des feux
- Observation unit: pixel spatial (grille de 30m rééchantillonnée) au sein du perimetre forestier de l'incendie
- Observed population: pixels forestiers du perimetre de l'incendie (Bootleg, Oregon, ou Schneider Springs, Washington, 2021), RdNBR continu (toutes classes de severite) et covariables bioclimatiques, meteorologiques, topographiques, structurelles et de gestion
- Geographic context: etendue sf: x [-1916920.76579135, -1888170.76579135], y [2888886.48381517, 2918136.48381517]
- Temporal context: none (cross-sectional)
- Source description: Learning from wildfires: A scalable framework to evaluate treatment effects on burn severity
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1002/ecs2.70073
- Dataset DOI: 10.5061/dryad.mcvdnck6c
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.mcvdnck6c
- Local raw dir: `data/raw/papers/DataCite_2024_LearningFromWildfiresA_10_1002_ecs2_700/`
- Local sf output: `data/final_datasets/sf/paper_wildfire_schneider_springs_severity.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `rdnbr`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Annual_AET_V2_1981_2010`, `Annual_Deficit_V2_1981_2010`, `Annual_PET_1981_2010`, `Annual_PPT_anl_total_1981_2010`, `Annual_Tave_anl_mean_1981_2010`, `Annual_Tmin_anl_mean_1981_2010`, `distance_to_roads_20221021`, `distance_to_strms_and_wetlands`, `distance_to_trt_edge`, `frs_ss_clipped`, `gedi_rh100_mean`, `gedi_rh100_sd`, `SS_erc`, `SS_fm100`, `SS_fm1000`, `SS_minrh`, `SS_tmmx_celsius`, `SS_vpd`, `LF2019_CBD`, `LF2019_CC`, `LF2019_CH`, `forest_mask`, `scf_20221011`, `sdd_20221011`, `elevation_10res`, `hli_10res`, `slope_10res`, `sri_10res`, `tpi_10res_2010win`, `tpi_10res_410win`, `tpi_10res_8010win`, `tri_10res_410win`, `eastwestness_mx_speed_direction_20230314`, `mx_speed_20230310`, `northsouthness_mx_speed_direction_20230314`
- Candidate X count in local artifact: 35
- Candidate X typology: continuous, categorical
- Published X variables from paper: Annual_Deficit_V2_1981_2010, SS_minrh, SS_fm1000, distance_to_roads_20221021, LF2019_CC, gedi_rh100_mean, gedi_rh100_sd, distance_to_trt_edge, tpi_10res_8010win, northsouthness_mx_speed_direction_20230314, mx_speed_20230310, frs_ss_clipped, Annual_AET_V2_1981_2010
- Published X count: 13
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `rdnbr` | `numeric` | continuous | [-170.1625, 1154.5323] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `wildfire_schneider_springs_severity`, la ou les reponses `rdnbr` viennent du loader papier et/ou des preuves de l article `Learning from wildfires: A scalable framework to evaluate treatment effects on burn severity`. Les covariables X retenues sont `Annual_Deficit_V2_1981_2010`, `SS_minrh`, `SS_fm1000`, `distance_to_roads_20221021`, `LF2019_CC`, `gedi_rh100_mean`, `gedi_rh100_sd`, `distance_to_trt_edge`, `tpi_10res_8010win`, `northsouthness_mx_speed_direction_20230314`, `mx_speed_20230310`, `frs_ss_clipped`, `Annual_AET_V2_1981_2010` ; 22 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Annual_AET_V2_1981_2010` | `numeric` | continuous | 0% |
| `Annual_Deficit_V2_1981_2010` | `numeric` | continuous | 0% |
| `Annual_PET_1981_2010` | `numeric` | continuous | 0% |
| `Annual_PPT_anl_total_1981_2010` | `numeric` | continuous | 0% |
| `Annual_Tave_anl_mean_1981_2010` | `numeric` | continuous | 0% |
| `Annual_Tmin_anl_mean_1981_2010` | `numeric` | continuous | 0% |
| `distance_to_roads_20221021` | `numeric` | continuous | 0% |
| `distance_to_strms_and_wetlands` | `numeric` | continuous | 0% |
| `distance_to_trt_edge` | `numeric` | continuous | 0% |
| `frs_ss_clipped` | `numeric` | rate | 0% |
| `gedi_rh100_mean` | `numeric` | continuous | 0% |
| `gedi_rh100_sd` | `numeric` | continuous | 0% |
| `SS_erc` | `numeric` | continuous | 0% |
| `SS_fm100` | `numeric` | continuous | 0% |
| `SS_fm1000` | `numeric` | continuous | 0% |
| `SS_minrh` | `numeric` | continuous | 0% |
| `SS_tmmx_celsius` | `numeric` | continuous | 0% |
| `SS_vpd` | `numeric` | continuous | 0% |
| `LF2019_CBD` | `numeric` | rate | 0% |
| `LF2019_CC` | `numeric` | continuous | 0% |
| `LF2019_CH` | `numeric` | continuous | 0% |
| `forest_mask` | `numeric` | binary | 0% |
| `scf_20221011` | `numeric` | rate | 0% |
| `sdd_20221011` | `numeric` | continuous | 0% |
| `elevation_10res` | `numeric` | continuous | 0% |
| `hli_10res` | `numeric` | rate | 0% |
| `slope_10res` | `numeric` | continuous | 0% |
| `sri_10res` | `numeric` | rate | 0% |
| `tpi_10res_2010win` | `numeric` | continuous | 0% |
| `tpi_10res_410win` | `numeric` | continuous | 0% |
| `tpi_10res_8010win` | `numeric` | continuous | 0% |
| `tri_10res_410win` | `numeric` | continuous | 0% |
| `eastwestness_mx_speed_direction_20230314` | `numeric` | continuous | 0% |
| `mx_speed_20230310` | `numeric` | continuous | 0% |
| `northsouthness_mx_speed_direction_20230314` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: rdnbr ~ treatment_type_x_time_since_treatment + top predictors RF + W [SAR, lag=35m]
- x_terms_pub: Annual_Deficit_V2_1981_2010, SS_minrh, SS_fm1000, distance_to_roads_20221021, LF2019_CC, gedi_rh100_mean, gedi_rh100_sd, distance_to_trt_edge, tpi_10res_8010win, northsouthness_mx_speed_direction_20230314, mx_speed_20230310, frs_ss_clipped, Annual_AET_V2_1981_2010
- y_term_pub: rdnbr
- Reference publication: Chamberlain et al. (2024), Ecosphere, DOI 10.1002/ecs2.70073; README.md + csvs/predictor_variables_20221108.csv (Dryad 10.5061/dryad.mcvdnck6c) documentent RdNBR (severity/2021_SchneiderSprings_rdnbr_w_offset_DATESADJUSTED.tif, 30m) et 34 predicteurs candidats pour le second incendie (Washington, 2021). 2 couches ecostress absentes du depot public (verifie 2026-08-12) ; aspect_10res egalement absent. forest_mask present mais exclu (masque de zone d'etude). Methode verifiee par lecture directe du PDF (2026-09-10) : Random Forest (Fig. 1, etape 1) ramene les predicteurs a 13 variables retenues (Fig. 5a, R2=0.570) ; CWD/RH/TPI-8010m (une par categorie) servent a apparier 118 controles a 118 traitements (etape 2) ; modele SAR final (etape 3, lag=35m, pseudo-R2 Nagelkerke=0.94) evalue l'effet du type de traitement x temps depuis traitement en controlant pour les 13 variables retenues.

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d estimation: formule systeme generee (formula_pub confirmee mais non reprise telle quelle -- voir Note ci-dessous)
- Correspondance Python/R: aucune identifiee
- Note: Le papier n'ajuste PAS une regression lineaire/SAR sur les 34 predicteurs bruts disponibles dans le depot : (1) un Random Forest reduit d'abord ces predicteurs a 13 variables retenues par importance (Fig. 5a, R2=0.570, RMSE=231, apres reduction de colinearite par correlations de Spearman) ; (2) 3 de ces variables (CWD, RH, TPI-8010m, une par categorie bioclimatique/meteo/topographique) servent a apparier 118 unites traitees a 118 controles non traites ; (3) le modele SAR final (lag=35m, pseudo-R2 Nagelkerke=0.94) utilise en X les 13 variables retenues PLUS le type de traitement et le temps depuis traitement (categoriel). formula_used ne reprend que les 13 variables continues retenues par le RF (correspondance verifiee colonne par colonne avec Table 2 et Figure 5a de l'article) -- treatment_type et time_since_treatment sont ABSENTS de l'artefact local (35 colonnes disponibles, aucune ne code le type/l'age de traitement), donc le coeur du modele publie (l'effet du traitement, objet meme de l'article) n'est pas reproductible ici. Precedemment la fiche affirmait 'meme modele SAR que Bootleg' en listant les 34 predicteurs bruts comme la formule publiee, avec Statut='resolu'/'formule publication confirmee et utilisee' -- en realite chaque incendie a son propre ensemble de variables retenues par le RF (differentes entre Bootleg et Schneider Springs, cf. Fig. 4a vs 5a), seule la DEMARCHE en 3 etapes est commune aux deux feux (signale par l'utilisateur 2026-09-10 apres relecture croisee avec ChatGPT, verifie independamment par lecture directe du PDF, p.6-14).

### Formule - niveau systeme

- formula_used: rdnbr ~ Annual_Deficit_V2_1981_2010 + SS_minrh + SS_fm1000 + distance_to_roads_20221021 + LF2019_CC + gedi_rh100_mean + gedi_rh100_sd + distance_to_trt_edge + tpi_10res_8010win + northsouthness_mx_speed_direction_20230314 + mx_speed_20230310 + frs_ss_clipped + Annual_AET_V2_1981_2010
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: Annual_Deficit_V2_1981_2010, SS_minrh, SS_fm1000, distance_to_roads_20221021, LF2019_CC, gedi_rh100_mean, gedi_rh100_sd, distance_to_trt_edge, tpi_10res_8010win, northsouthness_mx_speed_direction_20230314, mx_speed_20230310, frs_ss_clipped, Annual_AET_V2_1981_2010
- y_term_used: rdnbr
- Note: Chamberlain et al. (2024), Ecosphere, Fig. 1 (cadre en 3 etapes RF -> appariement -> SAR), Fig. 5a (importance RF, Nagelkerke pseudo-R2=0.94, RMSE=231), p.10-13 (equation SAR, 118 unites traitees/controles appariees sur CWD/RH/TPI-8010m). Predicteurs RF retenus : CWD, RH, FM1000, distance aux routes, canopy cover, GEDI height mean/SD, distance au bord de traitement, TPI-8010m, wind northsouthness, wind speed, fire resistance score, AET. Voir formula_used_divergence_note pour l'ecart avec formula_used.

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
    formula: "rdnbr ~ Annual_Deficit_V2_1981_2010 + SS_minrh + SS_fm1000 + distance_to_roads_20221021 + LF2019_CC + gedi_rh100_mean + gedi_rh100_sd + distance_to_trt_edge + tpi_10res_8010win + northsouthness_mx_speed_direction_20230314 + mx_speed_20230310 + frs_ss_clipped + Annual_AET_V2_1981_2010"
    response: "rdnbr"
    predictors: ["Annual_Deficit_V2_1981_2010", "SS_minrh", "SS_fm1000", "distance_to_roads_20221021", "LF2019_CC", "gedi_rh100_mean", "gedi_rh100_sd", "distance_to_trt_edge", "tpi_10res_8010win", "northsouthness_mx_speed_direction_20230314", "mx_speed_20230310", "frs_ss_clipped", "Annual_AET_V2_1981_2010"]
    role: "benchmark_simplified_specification"
    source_type: "derived_from_scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
    status: "executable_approximation"

  ml_or_selected:
    formula: "rdnbr ~ Annual_AET_V2_1981_2010 + Annual_Deficit_V2_1981_2010 + Annual_PET_1981_2010 + Annual_PPT_anl_total_1981_2010 + Annual_Tave_anl_mean_1981_2010 + Annual_Tmin_anl_mean_1981_2010 + distance_to_roads_20221021 + distance_to_strms_and_wetlands + distance_to_trt_edge + frs_ss_clipped + gedi_rh100_mean + gedi_rh100_sd + SS_erc + SS_fm100 + SS_fm1000 + SS_minrh + SS_tmmx_celsius + SS_vpd + LF2019_CBD + LF2019_CC + LF2019_CH + scf_20221011 + sdd_20221011 + elevation_10res + hli_10res + slope_10res + sri_10res + tpi_10res_2010win + tpi_10res_410win + tpi_10res_8010win + tri_10res_410win + eastwestness_mx_speed_direction_20230314 + mx_speed_20230310 + northsouthness_mx_speed_direction_20230314"
    response: "rdnbr"
    predictors: ["Annual_AET_V2_1981_2010", "Annual_Deficit_V2_1981_2010", "Annual_PET_1981_2010", "Annual_PPT_anl_total_1981_2010", "Annual_Tave_anl_mean_1981_2010", "Annual_Tmin_anl_mean_1981_2010", "distance_to_roads_20221021", "distance_to_strms_and_wetlands", "distance_to_trt_edge", "frs_ss_clipped", "gedi_rh100_mean", "gedi_rh100_sd", "SS_erc", "SS_fm100", "SS_fm1000", "SS_minrh", "SS_tmmx_celsius", "SS_vpd", "LF2019_CBD", "LF2019_CC", "LF2019_CH", "scf_20221011", "sdd_20221011", "elevation_10res", "hli_10res", "slope_10res", "sri_10res", "tpi_10res_2010win", "tpi_10res_410win", "tpi_10res_8010win", "tri_10res_410win", "eastwestness_mx_speed_direction_20230314", "mx_speed_20230310", "northsouthness_mx_speed_direction_20230314"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["random_forest", "random_forest_xy", "xgboost", "xgboost_xy"]
    status: "confirmed_predictor_pool_before_rf_reduction"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_wildfire_schneider_springs_severity`
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
  source_ref: "Chamberlain et al. (2024), Ecosphere, DOI 10.1002/ecs2.70073; README.md + csvs/predictor_variables_20221108.csv (Dryad 10.5061/dryad.mcvdnck6c) documentent RdNBR (severity/2021_SchneiderSprings_rdnbr_w_offset_DATESADJUSTED.tif, 30m) et 34 predicteurs candidats pour le second incendie (Washington, 2021). 2 couches ecostress absentes du depot public (verifie 2026-08-12) ; aspect_10res egalement absent. forest_mask present mais exclu (masque de zone d'etude). Methode verifiee par lecture directe du PDF (2026-09-10) : Random Forest (Fig. 1, etape 1) ramene les predicteurs a 13 variables retenues (Fig. 5a, R2=0.570) ; CWD/RH/TPI-8010m (une par categorie) servent a apparier 118 controles a 118 traitements (etape 2) ; modele SAR final (etape 3, lag=35m, pseudo-R2 Nagelkerke=0.94) evalue l'effet du type de traitement x temps depuis traitement en controlant pour les 13 variables retenues."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "meme reserve que wildfire_bootleg_severity : grille reechantillonnee a 250m Albers (resolution native 30m), 2 couches ecostress + aspect_10res absentes du depot public ; treatment_type et time_since_treatment (predicteurs centraux du modele SAR publie) ABSENTS de l'artefact local -- corrige 2026-09-10, le modele publie n'est pas reproductible tel quel ici"
  reason: "Tache benchmark : predire rdnbr (continu, reel) a partir des covariables environnementales retenues par le Random Forest du papier (13 variables, Fig. 5a) -- distincte de la tache causale du papier (effet du traitement sur la severite via SAR), qui necessite treatment_type/time_since_treatment absents du depot local. Meme source/structure que wildfire_bootleg_severity, second incendie (Washington 2021) du meme papier -- corrige 2026-09-10 (la fiche affirmait auparavant a tort 'meme modele SAR que Bootleg' en listant les 34 predicteurs bruts comme formule publiee)."
```

- Decision: ready
- Manque principal: meme reserve que wildfire_bootleg_severity : grille reechantillonnee a 250m Albers (resolution native 30m), 2 couches ecostress + aspect_10res absentes du depot public ; treatment_type et time_since_treatment (predicteurs centraux du modele SAR publie) ABSENTS de l'artefact local -- corrige 2026-09-10, le modele publie n'est pas reproductible tel quel ici
- Raison: Tache benchmark : predire rdnbr (continu, reel) a partir des covariables environnementales retenues par le Random Forest du papier (13 variables, Fig. 5a) -- distincte de la tache causale du papier (effet du traitement sur la severite via SAR), qui necessite treatment_type/time_since_treatment absents du depot local. Meme source/structure que wildfire_bootleg_severity, second incendie (Washington 2021) du meme papier -- corrige 2026-09-10 (la fiche affirmait auparavant a tort 'meme modele SAR que Bootleg' en listant les 34 predicteurs bruts comme formule publiee).

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
- N observations: 6814
- k variables: 38
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 5070
- CRS nom: NAD83 / Conus Albers
- Spatial extent: x [-1916920.76579135, -1888170.76579135], y [2888886.48381517, 2918136.48381517]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: aucune reprojection necessaire -- CRS deja projete et metrique. (EPSG:5070, NAD83 / Conus Albers) (correction 2026-09-16, mode production de secours : le texte precedent affirmait a tort "CRS source non geographique ou inconnu" alors que le CRS est deja connu et renseigne ci-dessus -- incoherence interne du meme type que celle corrigee sur paper_banff_stream_temperature.)

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.mcvdnck6c (checked 2026-09-14): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`wildfire_schneider_springs_severity` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `wildfire_schneider_springs_severity` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formula_pub confirmee et verifiee (voir Reference publication) ; formula_used est une approximation generee distincte, explicitement etiquetee comme telle (voir Bloc 1 > Statut regression canonique > Note).
- CRS: OK - CRS renseigne dans le Bloc 5 (5070).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`wildfire_schneider_springs_severity` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Learning from wildfires: A scalable framework to evaluate treatment effects on burn severity

## Curation documentée — 2026-09-07

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
