---
title: Python_geodatasets_geoda.nyc_earnings_2004
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.nyc_earnings_2004.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`nyc_earnings_2004`).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`nyc_earnings_2004`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `total_jobs`, `jobs_earnings_high`
- Candidate Y typology: count
- Candidate X variables: `jobs_earnings_low`, `ALAND10`, `AWATER10`, `COUNTYFP10`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `jobs_earnings_mid`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `total_jobs` | `integer` | count | [0, 2014] | 0% |
| `jobs_earnings_high` | `integer` | count | [0, 1009] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables d'emploi (total_jobs, jobs_earnings_high) sont des cibles naturelles pour modéliser la distribution spatiale des emplois ou des emplois bien rémunérés à l'échelle des blocs census de NYC. ALAND10, AWATER10 et COUNTYFP10 sont des covariables géographiques/structurelles utiles, et jobs_earnings_low peut servir de prédicteur complémentaire (corrélé mais distinct de la cible choisie). Les identifiants géographiques textuels (GEOID10, TRACTCE10, BLOCKCE10, STATEFP10, INTPTLAT10, INTPTLON10) sont ignorés car purement administratifs ou redondants avec les coordonnées spatiales.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `jobs_earnings_low` | `integer` | count | 0% |
| `ALAND10` | `integer` | count | 0% |
| `AWATER10` | `integer` | count | 0% |
| `COUNTYFP10` | `integer` | count | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Center for Spatial Data Science, University of Chicago (GeoDa Data and Lab), 'Block-level Earnings in NYC (2002-14)' -- source LEHD (Longitudinal Employer-Household Dynamics, US Census Bureau), https://geodacenter.github.io/data-and-lab//LEHD_Data/. Decoupe le 2026-08-15 en 13 fiches annuelles (politique : plusieurs coupes temporelles plutot qu'une seule) depuis l'objet source geoda.nyc_earnings (N=108487, 71 colonnes C000/CE01/CE02/CE03 x 2002-2014). total_jobs=C000 (emplois totaux), jobs_earnings_low/mid/high=CE01/CE02/CE03 (tiers de revenu LODES : <=1250$/mois, 1251-3333$/mois, >3333$/mois -- somme egale a total_jobs, donc CE01-03 ne doivent pas etre utilisees simultanement avec total_jobs comme X et Y, colinearite exacte par construction).

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

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

- Dataset ID: `Python_geodatasets_geoda.nyc_earnings_2004`
- Dataset name: geodatasets::nyc_earnings_2004
- Source family: python-package
- Source: package Python `geodatasets`
- Source URL: https://pypi.org/project/geodatasets/
- Dataset DOI: none
- Publication DOI: pending
- Year: 2023

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "null"
  equation_family: n/a
  model_family: "n/a"
  source_type: none_found
  source_ref: "null"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 108487
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [1796851.3485, 1990735.0438], y [544218.8337, 675975.4403] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: USA_Contiguous_Albers_Equal_Area_Conic
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/geodatasets/
- License open: yes
- Reproducibility status: available via package Python `geodatasets`
- Code available: yes (package examples and vignettes)
- Repository: python-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_missing_formula"
  benchmark_task: "not_current_regression_benchmark"
  package_include: "no"
  has_local_rds: true
  missing_items: "formule Y ~ X executable manquante"
  reason: "Aucune formule systeme ou publication n est disponible pour ce jeu de donnees package."
```

- Decision: not_ready_missing_formula
- Manque principal: formule Y ~ X executable manquante
- Raison: Aucune formule systeme ou publication n est disponible pour ce jeu de donnees package.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`
