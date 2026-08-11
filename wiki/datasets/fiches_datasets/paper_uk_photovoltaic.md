---
title: paper_uk_photovoltaic
type: dataset
created: 2026-08-11
updated: 2026-08-11
sources:
  - data/final_datasets/sf/paper_uk_photovoltaic.rds
  - DataCite_2015_RegionalDistributionOfPhotovoltaic_10_1016_j_eneco_
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Regional distribution of photovoltaic deployment in the UK and its determinants: A spatial econometric approach" (DOI 10.1016/j.eneco.2015.08.003).

## Description du jeu de donnees

- Topic: energie / deploiement photovoltaique
- Observation unit: autorite locale (Local Authority District, UK)
- Observed population: installations PV domestiques (<10kW)
- Geographic context: etendue sf: x [92015.5184782611, 646668.567307692], y [11094.25, 1151403.25]
- Temporal context: none (cross-sectional)
- Source description: Regional distribution of photovoltaic deployment in the UK and its determinants: A spatial econometric approach
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1016/j.eneco.2015.08.003
- Dataset DOI: 10.17632/fthhmvgm6r.1
- Source URL: https://www.gov.uk/government/statistical-data-sets/monthly-central-feed-in-tariff-register-statistics
- Local raw dir: `data/raw/papers/DataCite_2015_RegionalDistributionOfPhotovoltaic_10_1016_j_eneco_/`
- Local sf output: `data/final_datasets/sf/paper_uk_photovoltaic.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `n_installations`, `total_capacity_kw`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: no additional covariates beyond coordinates/identifiers (raster or grid dataset)
- Candidate X count in local artifact: 0
- Candidate X typology: unknown
- Published X variables from paper: Lnypc, Density, Detached, Ownedshare, Lnelectricity, QL2, Avehousehold, Irradiation, CO2
- Published X count: 9
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `LAD13CD`, `LAD13NM`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `n_installations` | `numeric` | continuous | [2, 8586] | 0% |
| `total_capacity_kw` | `numeric` | continuous | [4.2, 28145.06] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `uk_photovoltaic`, la ou les reponses `n_installations`, `total_capacity_kw` viennent du loader papier et/ou des preuves de l article `Regional distribution of photovoltaic deployment in the UK and its determinants: A spatial econometric approach`. Les covariables X retenues sont aucune covariable explicative locale ; cependant le papier documente les covariables publiees `Lnypc`, `Density`, `Detached`, `Ownedshare`, `Lnelectricity`, `QL2`, `Avehousehold`, `Irradiation`, `CO2`, non presentes dans le .rds actuel. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (`LAD13CD`, `LAD13NM`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : needs_covariate_join_and_nuts3_reconciliation ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| -- | -- | aucun candidat | -- |

### Formule - niveau publication

- formula_pub: PV_uptake ~ rho*W*PV_uptake + X*beta + W*X*theta + u (Spatial Durbin Model, eq. 1)
- x_terms_pub: Lnypc, Density, Detached, Ownedshare, Lnelectricity, QL2, Avehousehold, Irradiation, CO2
- y_term_pub: PV uptake, measured by accumulated capacity and number of installations at Great Britain NUTS3 level
- Reference publication: Balta-Ozkan, Yildirim & Connor (2015), Energy Economics, DOI 10.1016/j.eneco.2015.08.003: Section 5.2 lists explanatory variables and sources; Section 5.3 gives the spatial econometric specification; Table 8 reports OLS spatial-dependence tests; Table 9 reports SDM/SAR/SEM/GS-2SLS estimates using Lnypc, Density, Detached, Ownedshare, Lnelectricity, QL2, Avehousehold, Irradiation and CO2. Current local .rds has LAD-level PV aggregates only, so the NUTS3 covariate matrix from the paper still has to be reconstructed before formula_used can be executable.

### Statut regression canonique

- Statut: resolu_publication_non_executable
- Niveau de preuve: publication
- Methode d estimation: modele/formule publication confirme, non executable avec le .rds actuel
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-11). Balta-Ozkan, Yildirim & Connor (2015), Energy Economics, DOI 10.1016/j.eneco.2015.08.003: Section 5.2 lists explanatory variables and sources; Section 5.3 gives the spatial econometric specification; Table 8 reports OLS spatial-dependence tests; Table 9 reports SDM/SAR/SEM/GS-2SLS estimates using Lnypc, Density, Detached, Ownedshare, Lnelectricity, QL2, Avehousehold, Irradiation and CO2. Current local .rds has LAD-level PV aggregates only, so the NUTS3 covariate matrix from the paper still has to be reconstructed before formula_used can be executable.

### Formule - niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-11). Balta-Ozkan, Yildirim & Connor (2015), Energy Economics, DOI 10.1016/j.eneco.2015.08.003: Section 5.2 lists explanatory variables and sources; Section 5.3 gives the spatial econometric specification; Table 8 reports OLS spatial-dependence tests; Table 9 reports SDM/SAR/SEM/GS-2SLS estimates using Lnypc, Density, Detached, Ownedshare, Lnelectricity, QL2, Avehousehold, Irradiation and CO2. Current local .rds has LAD-level PV aggregates only, so the NUTS3 covariate matrix from the paper still has to be reconstructed before formula_used can be executable.

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
    formula: "PV_uptake ~ Lnypc + Density + Detached + Ownedshare + Lnelectricity + QL2 + Avehousehold + Irradiation + CO2"
    response: "PV uptake, measured by accumulated capacity and number of installations at Great Britain NUTS3 level"
    predictors: ["Lnypc", "Density", "Detached", "Ownedshare", "Lnelectricity", "QL2", "Avehousehold", "Irradiation", "CO2"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Balta-Ozkan, Yildirim & Connor (2015), Energy Economics, DOI 10.1016/j.eneco.2015.08.003: Section 5.2 lists explanatory variables and sources; Section 5.3 gives the spatial econometric specification; Table 8 reports OLS spatial-dependence tests; Table 9 reports SDM/SAR/SEM/GS-2SLS estimates using Lnypc, Density, Detached, Ownedshare, Lnelectricity, QL2, Avehousehold, Irradiation and CO2. Current local .rds has LAD-level PV aggregates only, so the NUTS3 covariate matrix from the paper still has to be reconstructed before formula_used can be executable."
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

- Dataset ID: `paper_uk_photovoltaic`
- Dataset name: Data for: Regional distribution of photovoltaic deployment in the UK and its determinants: A spatial econometric approach
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Regional distribution of photovoltaic deployment in the UK and its determinants: A spatial econometric approach
- Paper DOI: 10.1016/j.eneco.2015.08.003
- Dataset DOI: 10.17632/fthhmvgm6r.1
- Source URL: https://www.gov.uk/government/statistical-data-sets/monthly-central-feed-in-tariff-register-statistics
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "PV_uptake ~ rho*W*PV_uptake + X*beta + W*X*theta + u (Spatial Durbin Model, eq. 1)"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Balta-Ozkan, Yildirim & Connor (2015), Energy Economics, DOI 10.1016/j.eneco.2015.08.003: Section 5.2 lists explanatory variables and sources; Section 5.3 gives the spatial econometric specification; Table 8 reports OLS spatial-dependence tests; Table 9 reports SDM/SAR/SEM/GS-2SLS estimates using Lnypc, Density, Detached, Ownedshare, Lnelectricity, QL2, Avehousehold, Irradiation and CO2. Current local .rds has LAD-level PV aggregates only, so the NUTS3 covariate matrix from the paper still has to be reconstructed before formula_used can be executable."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "needs_covariate_join_and_nuts3_reconciliation"
  benchmark_task: "regression_spatial_econometrics"
  package_include: "no"
  has_local_rds: true
  missing_items: "reconcilier les NUTS3 du papier avec le LAD extrait, joindre les covariables publiees de Table 6/Table 9, puis reconstruire W NUTS3"
  reason: "Le papier modelise 134 regions NUTS3 avec un tableau X documente, alors que l'extraction actuelle contient 380 LAD et seulement les agregats PV locaux."
```

- Decision: needs_covariate_join_and_nuts3_reconciliation
- Manque principal: reconcilier les NUTS3 du papier avec le LAD extrait, joindre les covariables publiees de Table 6/Table 9, puis reconstruire W NUTS3
- Raison: Le papier modelise 134 regions NUTS3 avec un tableau X documente, alors que l'extraction actuelle contient 380 LAD et seulement les agregats PV locaux.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "needs_covariate_join_and_nuts3_reconciliation"
  eligible_estimators: []
  conditionally_eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
  ineligible_reason: "paper evidence exists, but the local .rds is not yet an executable Y/X benchmark table"
  rule: "paper fiches are eligible only when response, predictors, coordinates/geometry and required W are executable in the local artifact"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 380
- k variables: 6
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 27700
- CRS nom: OSGB36 / British National Grid
- Spatial extent: x [92015.5184782611, 646668.567307692], y [11094.25, 1151403.25]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`uk_photovoltaic` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `uk_photovoltaic` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: WARN - Y identifiee, mais aucune covariable X detectee (grille/raster sans covariable additionnelle).
- Formula: OK - preuve de modele/formule publication renseignee ; formula_used reste pending car le .rds local ne contient pas le tableau Y/X requis.
- CRS: OK - CRS renseigne dans le Bloc 5 (27700).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`uk_photovoltaic` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Regional distribution of photovoltaic deployment in the UK and its determinants: A spatial econometric approach

