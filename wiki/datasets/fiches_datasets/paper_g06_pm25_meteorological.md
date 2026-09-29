---
title: paper_g06_pm25_meteorological
type: dataset
created: 2026-09-23
updated: 2026-09-23
sources:
  - data/final_datasets/sf/paper_g06_pm25_meteorological.rds
  - G06_PM25_meteorological
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Estimation and inference in spatially varying coefficient models" (DOI 10.1002/env.2485).

## Description du jeu de donnees

- Topic: Air quality and meteorology
- Observation unit: observation spatiale du dataset "2011 winter PM2.5 and meteorological data"
- Observed population: Equation (16) relates PM2
- Geographic context: Conterminous-US point monitors matched to nearest valid Livneh and NARR grid cells.
- Temporal context: none (cross-sectional)
- Source description: Estimation and inference in spatially varying coefficient models
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1002/env.2485
- Dataset DOI: none
- Source URL: https://aqs.epa.gov/aqsweb/airdata/download_files.html
- Local raw dir: `data/raw/papers/G06_PM25_meteorological/`
- Local sf output: `data/final_datasets/sf/paper_g06_pm25_meteorological.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `PM25`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `n_observed_days`, `PPTN`, `Tmin`, `Tmax`, `WS`, `RH`, `TCDC`, `sample_status`
- Candidate X count in local artifact: 8
- Candidate X typology: unknown, continuous, categorical
- Published X variables from paper: PPTN (precipitations), RH (humidite relative), Tmin (temperature minimale), Tmax (temperature maximale), WS (vitesse du vent), TCDC (couverture nuageuse totale)
- Published X count: 6
- Coordinates (x, y - excluded from X candidates): `longitude`, `latitude`
- Identifier columns (excluded from X candidates): `site_id`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PM25` | `numeric` | continuous | [1.4619, 39.7774] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `g06_pm25_meteorological`, la ou les reponses `PM25` viennent du loader papier et/ou des preuves de l article `Estimation and inference in spatially varying coefficient models`. Les covariables X retenues sont `PPTN`, `RH`, `Tmin`, `Tmax`, `WS`, `TCDC` ; 2 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`longitude`, `latitude`), identifiants (`site_id`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : needs_manual_review ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `n_observed_days` | `integer` | unknown | 0% |
| `PPTN` | `numeric` | continuous | 0% |
| `Tmin` | `numeric` | continuous | 0% |
| `Tmax` | `numeric` | continuous | 0% |
| `WS` | `numeric` | continuous | 0% |
| `RH` | `numeric` | continuous | 0% |
| `TCDC` | `numeric` | continuous | 0% |
| `sample_status` | `character` | categorical | 0% |

### Formule - niveau publication

- formula_pub: PM25 ~ PPTN + RH + Tmin + Tmax + WS + TCDC [modele a coefficients spatialement variables BPST, equation (16)]
- x_terms_pub: PPTN (precipitations), RH (humidite relative), Tmin (temperature minimale), Tmax (temperature maximale), WS (vitesse du vent), TCDC (couverture nuageuse totale)
- y_term_pub: concentration moyenne journaliere de PM2.5 agregee sur l'hiver 2011
- Reference publication: Wang et al. (2019), Estimation and inference in spatially varying coefficient models, Environmetrics, DOI 10.1002/env.2485, equation (16). Reconstruction depuis les sources citees : EPA AQS 2011, grilles Livneh pour PPTN/Tmin/Tmax/WS et NARR pour RH/TCDC. N=838 sites continentaux complets apres agregation DJF ponderee par le nombre de jours. Les auteurs ne deposent ni leur liste finale de stations ni leur code de jointure ; ne pas presenter cette table comme une replique exacte avant validation.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

### Formule - niveau systeme

- formula_used: PM25 ~ PPTN + RH + Tmin + Tmax + WS + TCDC
- x_terms_used: PPTN, RH, Tmin, Tmax, WS, TCDC
- y_term_used: PM25
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

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
    formula: "PM25 ~ PPTN + RH + Tmin + Tmax + WS + TCDC"
    response: "concentration moyenne journaliere de PM2.5 agregee sur l'hiver 2011"
    predictors: ["PPTN (precipitations)", "RH (humidite relative)", "Tmin (temperature minimale)", "Tmax (temperature maximale)", "WS (vitesse du vent)", "TCDC (couverture nuageuse totale)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "PM25 ~ PPTN + RH + Tmin + Tmax + WS + TCDC"
    response: "PM25"
    predictors: ["PPTN", "RH", "Tmin", "Tmax", "WS", "TCDC"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["bpst_svcm", "gwr", "ols", "random_forest", "xgboost", "gam_spatial"]
    status: "manual_review_public_source_reconstruction"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_g06_pm25_meteorological`
- Dataset name: 2011 winter PM2.5 and meteorological data
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Estimation and inference in spatially varying coefficient models
- Paper DOI: 10.1002/env.2485
- Dataset DOI: none
- Source URL: https://aqs.epa.gov/aqsweb/airdata/download_files.html
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "PM25 ~ PPTN + RH + Tmin + Tmax + WS + TCDC [modele a coefficients spatialement variables BPST, equation (16)]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Wang et al. (2019), Estimation and inference in spatially varying coefficient models, Environmetrics, DOI 10.1002/env.2485, equation (16). Reconstruction depuis les sources citees : EPA AQS 2011, grilles Livneh pour PPTN/Tmin/Tmax/WS et NARR pour RH/TCDC. N=838 sites continentaux complets apres agregation DJF ponderee par le nombre de jours. Les auteurs ne deposent ni leur liste finale de stations ni leur code de jointure ; ne pas presenter cette table comme une replique exacte avant validation."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "needs_manual_review"
  benchmark_task: "unknown"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "statut benchmark non encore curate"
  reason: "Aucune decision explicite encodee pour g06_pm25_meteorological."
```

- Decision: needs_manual_review
- Manque principal: statut benchmark non encore curate
- Raison: Aucune decision explicite encodee pour g06_pm25_meteorological.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "needs_manual_review"
  eligible_estimators: []
  conditionally_eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy"]
  ineligible_reason: "manual review required before package promotion"
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 838
- k variables: 14
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-124.20139, -70.748017], y [26.071097, 48.64193]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=53.5deg) -- etendue compatible avec un grand pays/une region ; verifier qu'une projection nationale/regionale existe et convient a cette zone avant de l'utiliser, sinon envisager une projection continentale equal-area

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`g06_pm25_meteorological` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `g06_pm25_meteorological` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`g06_pm25_meteorological` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Estimation and inference in spatially varying coefficient models

