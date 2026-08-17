---
title: paper_vindum
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_vindum.rds
  - Moller_2020_OGC_vindum
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Oblique geographic coordinates as covariates for digital soil mapping" (DOI 10.5194/soil-6-269-2020).

## Description du jeu de donnees

- Topic: sol / matiere organique
- Observation unit: point d'echantillonnage pedologique
- Observed population: observations de matiere organique du sol du jeu de donnees Vindum
- Geographic context: Point dataset sur grille 20m, 12 ha.
- Temporal context: none (cross-sectional)
- Source description: Oblique geographic coordinates as covariates for digital soil mapping
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: high
- Paper DOI: 10.5194/soil-6-269-2020
- Dataset DOI: 10.5281/zenodo.3820068
- Source URL: https://zenodo.org/records/3820068
- Local raw dir: `data/raw/papers/Moller_2020_OGC_vindum/`
- Local sf output: `data/final_datasets/sf/paper_vindum.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `SOM`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `aspect_cos`, `aspect_sin`, `bluespot`, `curvature_plan`, `curvature_prof`, `DEM`, `DVI`, `ECa`, `flow_accu`, `midslope`, `MRVBF`, `NDVI`, `RVI`, `SAGAWI`, `SAVI`, `SL`, `slope_gradient`, `TWI`, `valleydepth`, `ogc_000`, `ogc_030`, `ogc_060`, `ogc_090`, `ogc_120`, `ogc_150`
- Candidate X count in local artifact: 25
- Candidate X typology: continuous
- Published X variables from paper: aspect_cos, aspect_sin, bluespot, curvature_plan, curvature_prof, DEM, DVI, ECa, flow_accu, midslope, MRVBF, NDVI, RVI, SAGAWI, SAVI, SL, slope_gradient, TWI, valleydepth, oblique geographic coordinates
- Published X count: 20
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `ID`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `SOM` | `numeric` | continuous | [1.3, 38.8] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `vindum`, la reponse `SOM` vient des observations Vindum_SOM du package OGC cite par Moller et al. (2020). Les covariables X retenues combinent les 19 couches auxiliaires publiees dans le package OGC (`aspect_cos`, `aspect_sin`, `bluespot`, `curvature_plan`, `curvature_prof`, `DEM`, `DVI`, `ECa`, `flow_accu`, `midslope`, `MRVBF`, `NDVI`, `RVI`, `SAGAWI`, `SAVI`, `SL`, `slope_gradient`, `TWI`, `valleydepth`) et les six coordonnees geographiques obliques generees localement (`ogc_000` a `ogc_150`). Les identifiants, geometries et champs techniques sont exclus de X. Statut benchmark actuel : almost_ready_ogc_aux_spatial_covariates ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `aspect_cos` | `numeric` | continuous | 0% |
| `aspect_sin` | `numeric` | continuous | 0% |
| `bluespot` | `numeric` | continuous | 0% |
| `curvature_plan` | `numeric` | continuous | 0% |
| `curvature_prof` | `numeric` | continuous | 0% |
| `DEM` | `numeric` | continuous | 0% |
| `DVI` | `numeric` | continuous | 0% |
| `ECa` | `numeric` | continuous | 0% |
| `flow_accu` | `numeric` | continuous | 0% |
| `midslope` | `numeric` | rate | 0% |
| `MRVBF` | `numeric` | continuous | 0% |
| `NDVI` | `numeric` | rate | 0% |
| `RVI` | `numeric` | continuous | 0% |
| `SAGAWI` | `numeric` | continuous | 0% |
| `SAVI` | `numeric` | rate | 0% |
| `SL` | `numeric` | continuous | 0% |
| `slope_gradient` | `numeric` | continuous | 0% |
| `TWI` | `numeric` | continuous | 0% |
| `valleydepth` | `numeric` | continuous | 0% |
| `ogc_000` | `numeric` | continuous | 0% |
| `ogc_030` | `numeric` | continuous | 0% |
| `ogc_060` | `numeric` | continuous | 0% |
| `ogc_090` | `numeric` | continuous | 0% |
| `ogc_120` | `numeric` | continuous | 0% |
| `ogc_150` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: SOM ~ oblique_geographic_coordinates + auxiliary_data [random forest / OGC spatial covariates]
- x_terms_pub: aspect_cos, aspect_sin, bluespot, curvature_plan, curvature_prof, DEM, DVI, ECa, flow_accu, midslope, MRVBF, NDVI, RVI, SAGAWI, SAVI, SL, slope_gradient, TWI, valleydepth, oblique geographic coordinates
- y_term_pub: soil organic matter (SOM)
- Reference publication: Moller et al. (2020), Soil, DOI 10.5194/soil-6-269-2020: Sections 2.1.1, 2.2 and 2.3.1 model SOM in the Vindum field using random forest with OGC coordinate rasters, with and without auxiliary data. The OGC package cited in the paper contains Vindum_SOM and Vindum_covariates; the local loader now extracts the 19 auxiliary raster layers (DEM terrain derivatives, Sentinel-2 vegetation indices and DUALEM apparent electrical conductivity) at the 285 SOM points and adds six generated OGC covariates. formula_used is the executable local OGC + AUX benchmark variant.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: SOM ~ aspect_cos + aspect_sin + bluespot + curvature_plan + curvature_prof + DEM + DVI + ECa + flow_accu + midslope + MRVBF + NDVI + RVI + SAGAWI + SAVI + SL + slope_gradient + TWI + valleydepth + ogc_000 + ogc_030 + ogc_060 + ogc_090 + ogc_120 + ogc_150
- x_terms_used: aspect_cos, aspect_sin, bluespot, curvature_plan, curvature_prof, DEM, DVI, ECa, flow_accu, midslope, MRVBF, NDVI, RVI, SAGAWI, SAVI, SL, slope_gradient, TWI, valleydepth, ogc_000, ogc_030, ogc_060, ogc_090, ogc_120, ogc_150
- y_term_used: SOM
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
    formula: "SOM ~ aspect_cos + aspect_sin + bluespot + curvature_plan + curvature_prof + DEM + DVI + ECa + flow_accu + midslope + MRVBF + NDVI + RVI + SAGAWI + SAVI + SL + slope_gradient + TWI + valleydepth + ogc_000 + ogc_030 + ogc_060 + ogc_090 + ogc_120 + ogc_150"
    response: "soil organic matter (SOM)"
    predictors: ["aspect_cos", "aspect_sin", "bluespot", "curvature_plan", "curvature_prof", "DEM", "DVI", "ECa", "flow_accu", "midslope", "MRVBF", "NDVI", "RVI", "SAGAWI", "SAVI", "SL", "slope_gradient", "TWI", "valleydepth", "oblique geographic coordinates"]
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

- Dataset ID: `paper_vindum`
- Dataset name: Vindum
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Oblique geographic coordinates as covariates for digital soil mapping
- Paper DOI: 10.5194/soil-6-269-2020
- Dataset DOI: 10.5281/zenodo.3820068
- Source URL: https://zenodo.org/records/3820068
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "SOM ~ oblique_geographic_coordinates + auxiliary_data [random forest / OGC spatial covariates]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Moller et al. (2020), Soil, DOI 10.5194/soil-6-269-2020: Sections 2.1.1, 2.2 and 2.3.1 model SOM in the Vindum field using random forest with OGC coordinate rasters, with and without auxiliary data. The OGC package cited in the paper contains Vindum_SOM and Vindum_covariates; the local loader now extracts the 19 auxiliary raster layers (DEM terrain derivatives, Sentinel-2 vegetation indices and DUALEM apparent electrical conductivity) at the 285 SOM points and adds six generated OGC covariates. formula_used is the executable local OGC + AUX benchmark variant."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous_ogc_aux_spatial_covariates"
  package_include: "yes"
  has_local_rds: true
  missing_items: "X combine 19 auxiliaires publiees du package OGC (Vindum_covariates) et 6 covariables OGC generees localement -- documenter cette composition mixte lors de l'usage"
  reason: "Le papier Moller et al. (2020) utilise SOM avec OGCs, avec et sans auxiliaires ; le loader extrait les 19 covariables auxiliaires Vindum_covariates du package OGC cite explicitement par le papier et ajoute six covariables OGC reproductibles. Y continu, X defendables (source publiee + technique testee par le papier), N=285 confirmes, artefact local utilisable -- promu sans revue manuelle (2026-08-12), statut normalise depuis almost_ready_ogc_aux_spatial_covariates."
```

- Decision: ready
- Manque principal: X combine 19 auxiliaires publiees du package OGC (Vindum_covariates) et 6 covariables OGC generees localement -- documenter cette composition mixte lors de l'usage
- Raison: Le papier Moller et al. (2020) utilise SOM avec OGCs, avec et sans auxiliaires ; le loader extrait les 19 covariables auxiliaires Vindum_covariates du package OGC cite explicitement par le papier et ajoute six covariables OGC reproductibles. Y continu, X defendables (source publiee + technique testee par le papier), N=285 confirmes, artefact local utilisable -- promu sans revue manuelle (2026-08-12), statut normalise depuis almost_ready_ogc_aux_spatial_covariates.

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
- N observations: 285
- k variables: 29
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: unknown
- CRS nom: unknown
- Spatial extent: x [534887.6172, 535325.9149], y [6247748.1996, 6248113.7981]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`vindum` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `vindum` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: WARN - CRS absent du sf source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`vindum` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Oblique geographic coordinates as covariates for digital soil mapping

