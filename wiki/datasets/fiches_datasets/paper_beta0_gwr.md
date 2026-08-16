---
title: paper_beta0_gwr
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_beta0_gwr.rds
  - DataCite_2018_AGlobalDatasetOf_10_1038_sdata_20
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "A global dataset of air temperature derived from satellite remote sensing and weather stations" (DOI 10.1038/sdata.2018.246).

## Description du jeu de donnees

- Topic: climatologie / desagregation satellite
- Observation unit: cellule de grille globale (0.05 degre)
- Observed population: surface terrestre mondiale
- Geographic context: etendue sf: x [-179.5, 179.5], y [-89.5, 83.5]
- Temporal context: none (cross-sectional)
- Source description: A global dataset of air temperature derived from satellite remote sensing and weather stations
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1038/sdata.2018.246
- Dataset DOI: 10.6084/m9.figshare.6189341
- Source URL: https://springernature.figshare.com/articles/Beta0_for_the_geographically_weighted_regressions/6189341
- Local raw dir: `data/raw/papers/DataCite_2018_AGlobalDatasetOf_10_1038_sdata_20/`
- Local sf output: `data/final_datasets/sf/paper_beta0_gwr.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `b0_annual_mean`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: no additional covariates beyond coordinates/identifiers (raster or grid dataset)
- Candidate X count in local artifact: 0
- Candidate X typology: unknown
- Published X variables from paper: pending
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `b0_annual_mean` | `numeric` | continuous | [-141.0869, 336.9121] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `beta0_gwr`, la ou les reponses `b0_annual_mean` viennent du loader papier et/ou des preuves de l article `A global dataset of air temperature derived from satellite remote sensing and weather stations`. Les covariables X retenues sont aucune covariable explicative locale. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : not_ready_derived_response ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| -- | -- | aucun candidat | -- |

### Formule - niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: DataCite dataset DOI 10.6084/m9.figshare.6189341; Publication DOI 10.1038/sdata.2018.246

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule - niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending
- Note: reponse identifiee dans le loader, mais aucune covariable X locale executable n est disponible dans le .rds actuel.

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

- Dataset ID: `paper_beta0_gwr`
- Dataset name: Beta0 for the geographically weighted regressions
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: A global dataset of air temperature derived from satellite remote sensing and weather stations
- Paper DOI: 10.1038/sdata.2018.246
- Dataset DOI: 10.6084/m9.figshare.6189341
- Source URL: https://springernature.figshare.com/articles/Beta0_for_the_geographically_weighted_regressions/6189341
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "pending"
  equation_family: generated_system_candidate
  model_family: unknown
  source_type: none_found
  source_ref: "data/raw/papers (loader-derived, no published equation located)"
  confidence: low
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_derived_response"
  benchmark_task: "derived_model_output"
  package_include: "no"
  has_local_rds: true
  missing_items: "retrouver le dataset empirique original et ses covariables"
  reason: "La reponse est un coefficient beta0 derive d'une GWR, pas une variable empirique brute."
```

- Decision: not_ready_derived_response
- Manque principal: retrouver le dataset empirique original et ses covariables
- Raison: La reponse est un coefficient beta0 derive d'une GWR, pas une variable empirique brute.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "not_ready_derived_response"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "current package supports continuous spatial regression benchmarks; this fiche is not currently an executable continuous-regression dataset"
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 25989
- k variables: 3
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-179.5, 179.5], y [-89.5, 83.5]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=359deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`beta0_gwr` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `beta0_gwr` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: WARN - Y identifiee, mais aucune covariable X detectee (grille/raster sans covariable additionnelle).
- Formula: PENDING - reponse identifiee, mais aucune covariable X locale executable n est disponible.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`beta0_gwr` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: A global dataset of air temperature derived from satellite remote sensing and weather stations

