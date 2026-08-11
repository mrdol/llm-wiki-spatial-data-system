---
title: paper_spruce_bark_beetle
type: dataset
created: 2026-08-11
updated: 2026-08-11
sources:
  - data/final_datasets/sf/paper_spruce_bark_beetle.rds
  - DataCite_2024_ClimaticAndManagementRelated_10_1111_1365_266
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Climatic and management-related drivers of endemic European spruce bark beetle populations in boreal forests" (DOI 10.1111/1365-2664.14606).

## Description du jeu de donnees

- Topic: ecologie / interactions plantes-pollinisateurs
- Observation unit: site d'observation ou cellule de grille d'occurrence
- Observed population: communautes de pollinisateurs ou d'oiseaux nectarivores
- Geographic context: etendue sf: x [7.10182, 14.55037], y [58.08526, 66.4163]
- Temporal context: 18 distinct periods (variable: year)
- Source description: Climatic and management-related drivers of endemic European spruce bark beetle populations in boreal forests
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/1365-2664.14606
- Dataset DOI: 10.5061/dryad.kd51c5bdc
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.kd51c5bdc
- Local raw dir: `data/raw/papers/DataCite_2024_ClimaticAndManagementRelated_10_1111_1365_266/`
- Local sf output: `data/final_datasets/sf/paper_spruce_bark_beetle.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `trapcounts`
- Candidate Y typology: count
- Candidate X variables in local artifact: `year`, `masl`, `spruce_vol`, `veg_zone`, `felling_border`, `temperature`, `precipitation`, `soil_moisture`
- Candidate X count in local artifact: 8
- Candidate X typology: continuous, categorical
- Published X variables from paper: masl, spruce_vol, veg_zone, felling_border, temperature, precipitation, soil_moisture
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): `east`, `north`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `trapcounts` | `integer` | count | [7, 36735] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `spruce_bark_beetle`, la ou les reponses `trapcounts` viennent du loader papier et/ou des preuves de l article `Climatic and management-related drivers of endemic European spruce bark beetle populations in boreal forests`. Les covariables X retenues sont `masl`, `spruce_vol`, `veg_zone`, `felling_border`, `temperature`, `precipitation`, `soil_moisture` ; 1 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`east`, `north`), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : almost_ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `year` | `integer` | count | 0% |
| `masl` | `character` | categorical | 0% |
| `spruce_vol` | `character` | categorical | 0% |
| `veg_zone` | `factor` | categorical | 0% |
| `felling_border` | `integer` | count | 0% |
| `temperature` | `character` | categorical | 0% |
| `precipitation` | `character` | categorical | 0% |
| `soil_moisture` | `character` | categorical | 0% |

### Formule - niveau publication

- formula_pub: trapcounts ~ masl + spruce_vol + veg_zone + felling_border + temperature + precipitation + soil_moisture
- x_terms_pub: masl, spruce_vol, veg_zone, felling_border, temperature, precipitation, soil_moisture
- y_term_pub: trapcounts
- Reference publication: Dryad README for Gohli et al. (2024), dataset 10.5061/dryad.kd51c5bdc: trap counts and covariates are explicitly documented in dryad.csv/README.md; empirical model specification still needs confirmation against the paper text before being marked as a published equation.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-11). Dryad README for Gohli et al. (2024), dataset 10.5061/dryad.kd51c5bdc: trap counts and covariates are explicitly documented in dryad.csv/README.md; empirical model specification still needs confirmation against the paper text before being marked as a published equation.

### Formule - niveau systeme

- formula_used: trapcounts ~ masl + spruce_vol + veg_zone + felling_border + temperature + precipitation + soil_moisture
- x_terms_used: masl, spruce_vol, veg_zone, felling_border, temperature, precipitation, soil_moisture
- y_term_used: trapcounts
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-11). Dryad README for Gohli et al. (2024), dataset 10.5061/dryad.kd51c5bdc: trap counts and covariates are explicitly documented in dryad.csv/README.md; empirical model specification still needs confirmation against the paper text before being marked as a published equation.

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
    formula: "trapcounts ~ masl + spruce_vol + veg_zone + felling_border + temperature + precipitation + soil_moisture"
    response: "trapcounts"
    predictors: ["masl", "spruce_vol", "veg_zone", "felling_border", "temperature", "precipitation", "soil_moisture"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Dryad README for Gohli et al. (2024), dataset 10.5061/dryad.kd51c5bdc: trap counts and covariates are explicitly documented in dryad.csv/README.md; empirical model specification still needs confirmation against the paper text before being marked as a published equation."
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

- Dataset ID: `paper_spruce_bark_beetle`
- Dataset name: Data for: Climatic and management-related drivers of endemic European spruce bark beetle populations in boreal forests
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Climatic and management-related drivers of endemic European spruce bark beetle populations in boreal forests
- Paper DOI: 10.1111/1365-2664.14606
- Dataset DOI: 10.5061/dryad.kd51c5bdc
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.kd51c5bdc
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "trapcounts ~ masl + spruce_vol + veg_zone + felling_border + temperature + precipitation + soil_moisture"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Dryad README for Gohli et al. (2024), dataset 10.5061/dryad.kd51c5bdc: trap counts and covariates are explicitly documented in dryad.csv/README.md; empirical model specification still needs confirmation against the paper text before being marked as a published equation."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "almost_ready"
  benchmark_task: "regression_count_spatial"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "confirmer la specification empirique exacte dans le papier associe avant inclusion automatique package"
  reason: "Y=trapcounts, covariables documentees, coordonnees WGS84 et N=1731 sont disponibles dans le README Dryad."
```

- Decision: almost_ready
- Manque principal: confirmer la specification empirique exacte dans le papier associe avant inclusion automatique package
- Raison: Y=trapcounts, covariables documentees, coordonnees WGS84 et N=1731 sont disponibles dans le README Dryad.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "almost_ready"
  eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
  conditionally_eligible_estimators: []
  ineligible_reason: ""
  rule: "paper fiches are eligible only when response, predictors, coordinates/geometry and required W are executable in the local artifact"
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 1731
- k variables: 14
- T periods: 18
- Variable temporelle: year
- N/T profile: N_grand_T_grand

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 18 distinct periods (variable: year)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [7.10182, 14.55037], y [58.08526, 66.4163]
- Time range: 2004 to 2021 (variable: year)
- CRS analyse recommande: 32632 (UTM Zone 32N (EPSG:32632)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`spruce_bark_beetle` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `spruce_bark_beetle` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`spruce_bark_beetle` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Climatic and management-related drivers of endemic European spruce bark beetle populations in boreal forests

