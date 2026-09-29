---
title: paper_s02_us_april_1948_precip
type: dataset
created: 2026-09-24
updated: 2026-09-24
sources:
  - data/final_datasets/sf/paper_s02_us_april_1948_precip.rds
  - S02_US_April_1948_precipitation
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Covariance Tapering for Interpolation of Large Spatial Datasets" (DOI 10.1198/106186006X132178).

## Description du jeu de donnees

- Topic: Climatology
- Observation unit: observation spatiale du dataset "US April 1948 precipitation anomalies, 5,906 observed stations"
- Observed population: Official spam::USprecip contains 11,918 locations: 5,906 observed (infill=1) and 6,012 infilled
- Geographic context: Point weather stations in longitude/latitude across the contiguous US; used for large-dataset covariance tapering/kriging.
- Temporal context: none (cross-sectional)
- Source description: Covariance Tapering for Interpolation of Large Spatial Datasets
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: high
- Paper DOI: 10.1198/106186006X132178
- Dataset DOI: none
- Source URL: https://cran.r-project.org/package=spam
- Local raw dir: `data/raw/papers/S02_US_April_1948_precipitation/`
- Local sf output: `data/final_datasets/sf/paper_s02_us_april_1948_precip.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `anomaly`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `raw`, `infill`
- Candidate X count in local artifact: 2
- Candidate X typology: continuous, categorical
- Published X variables from paper: pending
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `anomaly` | `numeric` | continuous | [-2.2322, 4.0178] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `s02_us_april_1948_precip`, la ou les reponses `anomaly` viennent du loader papier et/ou des preuves de l article `Covariance Tapering for Interpolation of Large Spatial Datasets`. Les covariables X retenues sont `raw`, `infill`. Les coordonnees (`lon`, `lat`), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : needs_manual_review ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `raw` | `numeric` | continuous | 0% |
| `infill` | `numeric` | binary | 0% |

### Formule - niveau publication

- formula_pub: Z(s) = mu(s) + epsilon(s), with covariance tapering used for kriging/interpolation of the April 1948 precipitation anomaly field
- x_terms_pub: pending
- y_term_pub: anomaly (anomalie de precipitation agregee d'avril 1948 aux 5 906 stations observees)
- Reference publication: Furrer, Genton & Nychka (2006), Covariance Tapering for Interpolation of Large Spatial Datasets, DOI 10.1198/106186006X132178. Le papier analyse le champ d'anomalies de precipitation d'avril 1948 et compare des calculs de krigeage/covariance; il ne specifie aucune regression Y ~ raw + infill. L'objet officiel spam::USprecip contient 5 906 stations observees (infill=1), chiffre coherent avec la Figure 8, contre 5 909 annoncees dans la prose.

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d estimation: formule systeme generee (formula_pub confirmee mais non reprise telle quelle -- voir Note ci-dessous)
- Correspondance Python/R: aucune identifiee
- Note: Le papier ne regresse pas anomaly sur raw ou infill. `raw` est la precipitation brute et `infill` un indicateur de provenance des valeurs dans l'objet spam::USprecip; ce ne sont pas des covariables du modele publie. Le modele porte sur le champ spatial de l'anomalie et sa covariance. La formule a intercept seul est uniquement une representation tabulaire minimale et ne reproduit pas le krigeage avec covariance tapering.

### Formule - niveau systeme

- formula_used: anomaly ~ 1
- x_terms_used: pending
- y_term_used: anomaly
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

- Dataset ID: `paper_s02_us_april_1948_precip`
- Dataset name: US April 1948 precipitation anomalies, 5,906 observed stations
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Covariance Tapering for Interpolation of Large Spatial Datasets
- Paper DOI: 10.1198/106186006X132178
- Dataset DOI: none
- Source URL: https://cran.r-project.org/package=spam
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Z(s) = mu(s) + epsilon(s), with covariance tapering used for kriging/interpolation of the April 1948 precipitation anomaly field"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Furrer, Genton & Nychka (2006), Covariance Tapering for Interpolation of Large Spatial Datasets, DOI 10.1198/106186006X132178. Le papier analyse le champ d'anomalies de precipitation d'avril 1948 et compare des calculs de krigeage/covariance; il ne specifie aucune regression Y ~ raw + infill. L'objet officiel spam::USprecip contient 5 906 stations observees (infill=1), chiffre coherent avec la Figure 8, contre 5 909 annoncees dans la prose."
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
  reason: "Aucune decision explicite encodee pour s02_us_april_1948_precip."
```

- Decision: needs_manual_review
- Manque principal: statut benchmark non encore curate
- Raison: Aucune decision explicite encodee pour s02_us_april_1948_precip.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "needs_manual_review"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "missing executable formula_used and/or covariates in the local artifact"
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 5906
- k variables: 7
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-124.57, -67.65], y [24.55, 49]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=56.9deg) -- etendue compatible avec un grand pays/une region ; verifier qu'une projection nationale/regionale existe et convient a cette zone avant de l'utiliser, sinon envisager une projection continentale equal-area

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`s02_us_april_1948_precip` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `s02_us_april_1948_precip` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formula_pub confirmee et verifiee (voir Reference publication) ; formula_used est une approximation generee distincte, explicitement etiquetee comme telle (voir Bloc 1 > Statut regression canonique > Note).
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`s02_us_april_1948_precip` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Covariance Tapering for Interpolation of Large Spatial Datasets

