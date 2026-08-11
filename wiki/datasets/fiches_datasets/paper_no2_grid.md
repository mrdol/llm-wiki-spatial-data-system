---
title: paper_no2_grid
type: dataset
created: 2026-08-10
updated: 2026-08-10
sources:
  - data/final_datasets/sf/paper_no2_grid.rds
  - DataCite_2019_AssessingNo2Concentration_10_1021_acs_est_
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Assessing NO 2 Concentration and Model Uncertainty with High Spatiotemporal Resolution across the Contiguous United States Using Ensemble Model Averaging" (DOI 10.1021/acs.est.9b03358).

## Description du jeu de donnees

- Topic: qualite de l'air / modele ensembliste ML
- Observation unit: point de grille 1km
- Observed population: Etats-Unis contigus
- Geographic context: a preciser depuis l'etendue spatiale (voir Bloc 5)
- Temporal context: none (cross-sectional)
- Source description: Assessing NO 2 Concentration and Model Uncertainty with High Spatiotemporal Resolution across the Contiguous United States Using Ensemble Model Averaging
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: low
- Paper DOI: 10.1021/acs.est.9b03358
- Dataset DOI: 10.7910/dvn/lufkyg
- Source URL: https://dataverse.harvard.edu/citation?persistentId=doi:10.7910/DVN/LUFKYG
- Local raw dir: `data/raw/papers/DataCite_2019_AssessingNo2Concentration_10_1021_acs_est_/`
- Local sf output: `data/final_datasets/sf/paper_no2_grid.rds`

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `NO2_2016`
- Candidate Y typology: continuous
- Candidate X variables: no additional covariates beyond coordinates/identifiers (raster or grid dataset)
- Candidate X count: 0
- Candidate X typology: unknown
- Coordinates (x, y — excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): `idx`
- Variables inspected: yes (auto — generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `NO2_2016` | `numeric` | continuous | [0, 34.9084] | 0% |

> Selection Y/X (paper-loader/curated evidence) : Pour `no2_grid`, la ou les reponses `NO2_2016` viennent du loader papier et/ou des preuves de l article `Assessing NO 2 Concentration and Model Uncertainty with High Spatiotemporal Resolution across the Contiguous United States Using Ensemble Model Averaging`. Les covariables X retenues sont aucune covariable explicative. Les coordonnees (`lon`, `lat`), identifiants (`idx`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : not_ready_prediction_product ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| -- | -- | aucun candidat | -- |

### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: NO2_2016
- Reference publication: pending

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: NO2_2016
- Note: formule candidate generee automatiquement (Y ~ toutes les covariables X detectees), PAS une formule publiee ou verifiee dans le papier source — a confirmer par revue manuelle.

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

## Bloc 2 — Identification et DOI

- Dataset ID: `paper_no2_grid`
- Dataset name: Daily, Monthly, and Annual NO2 Concentrations for the Contiguous United States, 1-km Grid (2000 - 2016)
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Assessing NO 2 Concentration and Model Uncertainty with High Spatiotemporal Resolution across the Contiguous United States Using Ensemble Model Averaging
- Paper DOI: 10.1021/acs.est.9b03358
- Dataset DOI: 10.7910/dvn/lufkyg
- Source URL: https://dataverse.harvard.edu/citation?persistentId=doi:10.7910/DVN/LUFKYG
- Year: unknown

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "pending"
  equation_family: generated_system_candidate
  model_family: unknown
  source_type: generated_system_formula
  source_ref: "data/raw/papers (loader-derived, no published equation located)"
  confidence: low
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

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 27993
- k variables: 6
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 — Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-126.0776767, -65.7630374], y [23.736447, 49.9666389]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending — multi-zones (span=60.3deg) -- projection nationale recommandee

## Bloc 6 — Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`no2_grid` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `no2_grid` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: WARN - Y identifiee, mais aucune covariable X detectee (grille/raster sans covariable additionnelle).
- Formula: PENDING - formule publication non encore etablie (formule candidate systeme fournie a la place).
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`no2_grid` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Assessing NO 2 Concentration and Model Uncertainty with High Spatiotemporal Resolution across the Contiguous United States Using Ensemble Model Averaging

