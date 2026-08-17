---
title: paper_pm25_grid
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_pm25_grid.rds
  - DataCite_2019_AnEnsembleBasedModel_10_1016_j_envint
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "An ensemble-based model of PM2.5 concentration across the contiguous United States with high spatiotemporal resolution" (DOI 10.1016/j.envint.2019.104909).

## Description du jeu de donnees

- Topic: qualite de l'air / modele ensembliste ML
- Observation unit: point de grille 1km
- Observed population: Etats-Unis contigus
- Geographic context: etendue sf: x [-157.73833, -65.7630374], y [21.115, 58.8025]
- Temporal context: none (cross-sectional)
- Source description: An ensemble-based model of PM2.5 concentration across the contiguous United States with high spatiotemporal resolution
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1016/j.envint.2019.104909
- Dataset DOI: 10.7910/dvn/58c6hg
- Source URL: https://dataverse.harvard.edu/citation?persistentId=doi:10.7910/DVN/58C6HG
- Local raw dir: `data/raw/papers/DataCite_2019_AnEnsembleBasedModel_10_1016_j_envint/`
- Local sf output: `data/final_datasets/sf/paper_pm25_grid.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `PM25_2016`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: no additional covariates beyond coordinates/identifiers (raster or grid dataset)
- Candidate X count in local artifact: 0
- Candidate X typology: unknown
- Published X variables from paper: spatially_lagged_PM2.5, CMAQ_PM2.5, CMAQ_PM2.5_sulfate, CMAQ_PM2.5_elemental_carbon, CMAQ_PM2.5_organic_carbon, AOD_related_variables, road_density, longitude, latitude, elevation_sd, NLCD_developed_area
- Published X count: 11
- Coordinates (x, y - excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): `idx`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PM25_2016` | `numeric` | continuous | [0.095, 12.7699] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `pm25_grid`, la ou les reponses `PM25_2016` viennent du loader papier et/ou des preuves de l article `An ensemble-based model of PM2.5 concentration across the contiguous United States with high spatiotemporal resolution`. Les covariables X retenues sont aucune covariable explicative locale ; cependant le papier documente les covariables publiees `spatially_lagged_PM2.5`, `CMAQ_PM2.5`, `CMAQ_PM2.5_sulfate`, `CMAQ_PM2.5_elemental_carbon`, `CMAQ_PM2.5_organic_carbon`, `AOD_related_variables`, `road_density`, `longitude`, `latitude`, `elevation_sd`, `NLCD_developed_area`, non presentes dans le .rds actuel. Les coordonnees (`lon`, `lat`), identifiants (`idx`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : not_ready_prediction_product ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| -- | -- | aucun candidat | -- |

### Formule - niveau publication

- formula_pub: PM2.5 ~ f(selected predictor variables) [neural network, random forest, gradient boosting; ensemble via geographically weighted generalized additive model]
- x_terms_pub: spatially_lagged_PM2.5, CMAQ_PM2.5, CMAQ_PM2.5_sulfate, CMAQ_PM2.5_elemental_carbon, CMAQ_PM2.5_organic_carbon, AOD_related_variables, road_density, longitude, latitude, elevation_sd, NLCD_developed_area
- y_term_pub: monitored PM2.5 concentration
- Reference publication: Di et al. (2019), Environment International, abstract, sections 1.3-1.5 and Table 4. The current local grid .rds contains final predicted PM2.5 values only; it does not contain the full learner training matrix.

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
    formula: "monitored_PM2.5 ~ selected predictor variables ranked by learner-specific variable importance"
    response: "monitored PM2.5 concentration"
    predictors: ["spatially_lagged_PM2.5", "CMAQ_PM2.5", "CMAQ_PM2.5_sulfate", "CMAQ_PM2.5_elemental_carbon", "CMAQ_PM2.5_organic_carbon", "AOD_related_variables", "road_density", "longitude", "latitude", "elevation_sd", "NLCD_developed_area", "soil_moisture", "NLCD_tree_canopy", "NLCD_planted_land", "CMAQ_NO2", "daily_max_air_temperature", "MODIS_daytime_surface_temperature", "OMI_NO2_column_concentration", "MERRA2_sulfate_aerosol"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Di et al. (2019), Environment International, abstract, sections 1.3-1.5 and Table 4: the authors trained neural network, random forest and gradient boosting learners, ranked predictor contributions, then combined learner predictions with a geographically weighted generalized additive model. Table 4 lists the top 20 variable-importance contributors by learner."
    estimator_context: ["random_forest", "gradient_boosting", "neural_network", "gam_spatial", "gwr"]
    status: "confirmed_feature_groups"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_pm25_grid`
- Dataset name: Daily, Monthly, and Annual PM2.5 Concentrations for the Contiguous United States, 1-km Grid (2000 - 2016)
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: An ensemble-based model of PM2.5 concentration across the contiguous United States with high spatiotemporal resolution
- Paper DOI: 10.1016/j.envint.2019.104909
- Dataset DOI: 10.7910/dvn/58c6hg
- Source URL: https://dataverse.harvard.edu/citation?persistentId=doi:10.7910/DVN/58C6HG
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "PM2.5 ~ f(selected predictor variables) [neural network, random forest, gradient boosting; ensemble via geographically weighted generalized additive model]"
  equation_family: ensemble_ml_geographically_weighted_gam
  model_family: neural network + random forest + gradient boosting ensemble via geographically weighted GAM
  source_type: scientific_publication_or_package_documentation
  source_ref: "Di et al. (2019), Environment International, abstract, sections 1.3-1.5 and Table 4. The current local grid .rds contains final predicted PM2.5 values only; it does not contain the full learner training matrix."
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
- Spatial extent: x [-157.73833, -65.7630374], y [21.115, 58.8025]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=92deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`pm25_grid` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `pm25_grid` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: WARN - Y identifiee, mais aucune covariable X detectee (grille/raster sans covariable additionnelle).
- Formula: OK - preuve de modele/formule publication renseignee ; formula_used reste pending car le .rds local ne contient pas le tableau Y/X requis.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`pm25_grid` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: An ensemble-based model of PM2.5 concentration across the contiguous United States with high spatiotemporal resolution

