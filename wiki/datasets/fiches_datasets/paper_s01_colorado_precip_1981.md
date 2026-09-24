---
title: paper_s01_colorado_precip_1981
type: dataset
created: 2026-09-23
updated: 2026-09-23
sources:
  - data/final_datasets/sf/paper_s01_colorado_precip_1981.rds
  - S01_Colorado_climatological_stations
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Spatial Modelling Using a New Class of Nonstationary Covariance Functions" (DOI 10.1002/env.785).

## Description du jeu de donnees

- Topic: Climatology
- Observation unit: observation spatiale du dataset "Colorado climatological stations, annual precipitation in 1981"
- Observed population: Full TEI: log-transformed annual precipitation in Colorado for 1981; 217 stations without missing monthly values
- Geographic context: Point stations in longitude/latitude; coordinates index the Gaussian spatial process.
- Temporal context: none (cross-sectional)
- Source description: Spatial Modelling Using a New Class of Nonstationary Covariance Functions
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1002/env.785
- Dataset DOI: none
- Source URL: https://www.image.ucar.edu/Data/US.monthly.met/
- Local raw dir: `data/raw/papers/S01_Colorado_climatological_stations/`
- Local sf output: `data/final_datasets/sf/paper_s01_colorado_precip_1981.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `log_annual_precip_1981`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `elevation_m`, `annual_precip_1981_mm`, `observed_months_1981`, `sample_status`
- Candidate X count in local artifact: 4
- Candidate X typology: continuous, unknown, categorical
- Published X variables from paper: pending
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): `longitude`, `latitude`
- Identifier columns (excluded from X candidates): `station_id`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `log_annual_precip_1981` | `numeric` | continuous | [4.8598, 7.3563] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `s01_colorado_precip_1981`, la ou les reponses `log_annual_precip_1981` viennent du loader papier et/ou des preuves de l article `Spatial Modelling Using a New Class of Nonstationary Covariance Functions`. Les covariables X retenues sont `elevation_m`, `annual_precip_1981_mm`, `observed_months_1981`, `sample_status`. Les coordonnees (`longitude`, `latitude`), identifiants (`station_id`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : needs_manual_review ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `elevation_m` | `numeric` | continuous | 0% |
| `annual_precip_1981_mm` | `numeric` | continuous | 0% |
| `observed_months_1981` | `integer` | unknown | 0% |
| `sample_status` | `character` | categorical | 0% |

### Formule - niveau publication

- formula_pub: Y_i ~ N(f(x_i), eta^2) ; f(.) ~ GP(mu, C(.,.; theta)) [processus gaussien stationnaire ou non stationnaire, covariance de Matern]
- x_terms_pub: pending
- y_term_pub: log-transformation des precipitations annuelles de 1981
- Reference publication: Paciorek & Schervish (2006), Spatial Modelling Using a New Class of Nonstationary Covariance Functions, Environmetrics, DOI 10.1002/env.785. Lecture integrale du TEI : le papier annonce 217 stations sans valeurs mensuelles manquantes en 1981 mais ne donne ni identifiants ni filtre additionnel. La source historique UCAR officielle en livre 244 avec ce critere exact. La fiche conserve donc une reconstruction N=244 explicitement distincte de l'echantillon auteur N=217.

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d estimation: formule systeme generee (formula_pub confirmee mais non reprise telle quelle -- voir Note ci-dessous)
- Correspondance Python/R: aucune identifiee
- Note: Le papier ajuste une surface spatiale gaussienne sans covariable X classique : les coordonnees indexent f(x), elles ne sont pas des predicteurs lineaires. La formule executable a intercept seul ne reproduit donc pas le GP publie et ne doit pas servir a promouvoir ce jeu comme benchmark de regression Y ~ X.

### Formule - niveau systeme

- formula_used: log_annual_precip_1981 ~ 1
- x_terms_used: elevation_m, annual_precip_1981_mm, observed_months_1981, sample_status
- y_term_used: log_annual_precip_1981
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
    formula: "pending"
    response: "pending"
    predictors: []
    role: "paper_main_specification"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

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

- Dataset ID: `paper_s01_colorado_precip_1981`
- Dataset name: Colorado climatological stations, annual precipitation in 1981
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Spatial Modelling Using a New Class of Nonstationary Covariance Functions
- Paper DOI: 10.1002/env.785
- Dataset DOI: none
- Source URL: https://www.image.ucar.edu/Data/US.monthly.met/
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Y_i ~ N(f(x_i), eta^2) ; f(.) ~ GP(mu, C(.,.; theta)) [processus gaussien stationnaire ou non stationnaire, covariance de Matern]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Paciorek & Schervish (2006), Spatial Modelling Using a New Class of Nonstationary Covariance Functions, Environmetrics, DOI 10.1002/env.785. Lecture integrale du TEI : le papier annonce 217 stations sans valeurs mensuelles manquantes en 1981 mais ne donne ni identifiants ni filtre additionnel. La source historique UCAR officielle en livre 244 avec ce critere exact. La fiche conserve donc une reconstruction N=244 explicitement distincte de l'echantillon auteur N=217."
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
  reason: "Aucune decision explicite encodee pour s01_colorado_precip_1981."
```

- Decision: needs_manual_review
- Manque principal: statut benchmark non encore curate
- Raison: Aucune decision explicite encodee pour s01_colorado_precip_1981.

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
- N observations: 244
- k variables: 10
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-109.48, -101.05], y [36.512, 41.45]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32613 (UTM Zone 13N (EPSG:32613)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`s01_colorado_precip_1981` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `s01_colorado_precip_1981` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formula_pub confirmee et verifiee (voir Reference publication) ; formula_used est une approximation generee distincte, explicitement etiquetee comme telle (voir Bloc 1 > Statut regression canonique > Note).
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`s01_colorado_precip_1981` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Spatial Modelling Using a New Class of Nonstationary Covariance Functions

