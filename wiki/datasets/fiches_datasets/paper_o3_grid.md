---
title: paper_o3_grid
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_o3_grid.rds
  - DataCite_2020_AnEnsembleLearningApproach_10_1021_acs_est_
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "An Ensemble Learning Approach for Estimating High Spatiotemporal Resolution of Ground-Level Ozone in the Contiguous United States" (DOI 10.1021/acs.est.0c01791).

## Description du jeu de donnees

- Topic: qualite de l'air / modele ensembliste ML
- Observation unit: point de grille 1km
- Observed population: Etats-Unis contigus
- Geographic context: etendue sf: x [-155.678611, -65.8576819], y [19.902222, 54.5145]
- Temporal context: none (cross-sectional)
- Source description: An Ensemble Learning Approach for Estimating High Spatiotemporal Resolution of Ground-Level Ozone in the Contiguous United States
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1021/acs.est.0c01791
- Dataset DOI: 10.7910/dvn/dgxcth
- Source URL: https://dataverse.harvard.edu/citation?persistentId=doi:10.7910/DVN/DGXCTH
- Local raw dir: `data/raw/papers/DataCite_2020_AnEnsembleLearningApproach_10_1021_acs_est_/`
- Local sf output: `data/final_datasets/sf/paper_o3_grid.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `O3_2016`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: no additional covariates beyond coordinates/identifiers (raster or grid dataset)
- Candidate X count in local artifact: 0
- Candidate X typology: unknown
- Published X variables from paper: meteorological_variables, chemical_transport_model_outputs, remote_sensing_observations, land_use_variables, CMAQ, GEOS_Chem, spatiotemporally_lagged_O3, nearby_monitor_weighted_O3, AOD, NDVI, road_density, tree_canopy, developed_area
- Published X count: 13
- Coordinates (x, y - excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): `idx`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `O3_2016` | `numeric` | continuous | [27.116, 58.6921] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `o3_grid`, la ou les reponses `O3_2016` viennent du loader papier et/ou des preuves de l article `An Ensemble Learning Approach for Estimating High Spatiotemporal Resolution of Ground-Level Ozone in the Contiguous United States`. Les covariables X retenues sont aucune covariable explicative locale ; cependant le papier documente les covariables publiees `meteorological_variables`, `chemical_transport_model_outputs`, `remote_sensing_observations`, `land_use_variables`, `CMAQ`, `GEOS_Chem`, `spatiotemporally_lagged_O3`, `nearby_monitor_weighted_O3`, `AOD`, `NDVI`, `road_density`, `tree_canopy`, `developed_area`, non presentes dans le .rds actuel. Les coordonnees (`lon`, `lat`), identifiants (`idx`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : not_ready_prediction_product ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| -- | -- | aucun candidat | -- |

### Formule - niveau publication

- formula_pub: O3 ~ f(169 predictor variables) [neural network, random forest, gradient boosting; ensemble via geographically weighted generalized additive model]
- x_terms_pub: meteorological_variables, chemical_transport_model_outputs, remote_sensing_observations, land_use_variables, CMAQ, GEOS_Chem, spatiotemporally_lagged_O3, nearby_monitor_weighted_O3, AOD, NDVI, road_density, tree_canopy, developed_area
- y_term_pub: daily maximum 8 h O3 concentration at monitoring sites
- Reference publication: Requia et al. (2020), Environmental Science & Technology, DOI 10.1021/acs.est.0c01791. The publication documents the training response, predictor families and ensemble models, but the downloaded local grid files are prediction products, not raw Y/X training data.

### Statut regression canonique

- Statut: resolu_publication_non_executable
- Niveau de preuve: publication
- Methode d estimation: modele/formule publication confirme, non executable avec le .rds actuel
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending
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
    formula: "pending"
    response: "pending"
    predictors: []
    role: "paper_main_specification"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

  ml_or_selected:
    formula: "monitored_O3 ~ 169 predictor variables from weather, CTM, remote sensing, land-use and spatiotemporal lag families"
    response: "daily maximum 8 h O3 concentration"
    predictors: ["meteorological_variables", "chemical_transport_model_outputs", "remote_sensing_observations", "land_use_variables", "CMAQ", "GEOS_Chem", "spatiotemporally_lagged_O3", "nearby_monitor_weighted_O3", "AOD", "NDVI", "road_density", "tree_canopy", "developed_area"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Requia et al. (2020), Environmental Science & Technology, DOI 10.1021/acs.est.0c01791: Sections 2.1-2.5 describe monitored daily maximum 8 h O3 as the response, 169 predictors consolidated from weather, CTM outputs, remote sensing and land-use data, random-forest imputation, neural network, random forest, gradient boosting, and a geographically weighted GAM ensemble. The current local grid .rds contains final predicted O3 values only; it does not contain the monitor-level training matrix."
    estimator_context: ["random_forest", "gradient_boosting", "neural_network", "gam_spatial", "gwr"]
    status: "confirmed_feature_groups"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_o3_grid`
- Dataset name: Daily, Monthly, and Annual 8-Hour Maximum O3 Concentrations for the Contiguous United States, 1-km Grid (2000 - 2016)
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: An Ensemble Learning Approach for Estimating High Spatiotemporal Resolution of Ground-Level Ozone in the Contiguous United States
- Paper DOI: 10.1021/acs.est.0c01791
- Dataset DOI: 10.7910/dvn/dgxcth
- Source URL: https://dataverse.harvard.edu/citation?persistentId=doi:10.7910/DVN/DGXCTH
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "O3 ~ f(169 predictor variables) [neural network, random forest, gradient boosting; ensemble via geographically weighted generalized additive model]"
  equation_family: ensemble_ml_geographically_weighted_gam
  model_family: neural network + random forest + gradient boosting ensemble via geographically weighted GAM
  source_type: scientific_publication_or_package_documentation
  source_ref: "Requia et al. (2020), Environmental Science & Technology, DOI 10.1021/acs.est.0c01791. The publication documents the training response, predictor families and ensemble models, but the downloaded local grid files are prediction products, not raw Y/X training data."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_prediction_product"
  benchmark_task: "prediction_product"
  package_include: "no"
  has_local_rds: true
  missing_items: "retrouver les observations et covariables sources du modele ensembliste"
  reason: "Le fichier extrait est une grille de predictions, pas un tableau Y/X brut."
```

- Decision: not_ready_prediction_product
- Manque principal: retrouver les observations et covariables sources du modele ensembliste
- Raison: Le fichier extrait est une grille de predictions, pas un tableau Y/X brut.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "not_ready_prediction_product"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "current package supports continuous spatial regression benchmarks; this fiche is not currently an executable continuous-regression dataset"
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 28046
- k variables: 6
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-155.678611, -65.8576819], y [19.902222, 54.5145]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=89.8deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`o3_grid` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `o3_grid` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: WARN - Y identifiee, mais aucune covariable X detectee (grille/raster sans covariable additionnelle).
- Formula: OK - preuve de modele/formule publication renseignee ; formula_used reste pending car le .rds local ne contient pas le tableau Y/X requis.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`o3_grid` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: An Ensemble Learning Approach for Estimating High Spatiotemporal Resolution of Ground-Level Ozone in the Contiguous United States

