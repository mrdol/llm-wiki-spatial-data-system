---
title: Python_geodatasets_spdata.columbus
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/Python_geodatasets_spdata.columbus.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`columbus`).

## Description du jeu de donnees

- Topic: criminalite urbaine
- Observation unit: quartier, zone urbaine ou evenement de police selon la documentation source
- Observed population: unites spatiales ou evenements lies a la criminalite
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`columbus`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `CRIME`, `HOVAL`
- Candidate Y typology: continuous
- Candidate X variables: `INC`, `OPEN`, `PLUMB`, `DISCBD`, `NSA`, `NSB`, `EW`, `CP`, `AREA`, `PERIMETER`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `POLYID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `CRIME` | `numeric` | continuous | [0.1783, 68.892] | 0% |
| `HOVAL` | `numeric` | continuous | [17.9, 96.4] | 0% |


> Selection Y/X (claude-sonnet-4-6) : CRIME (taux de criminalité) et HOVAL (valeur des logements) sont les deux variables réponses classiques du dataset Columbus, utilisées comme cibles dans la littérature de spatiale. INC (revenu), OPEN (espaces ouverts), PLUMB (plomberie défectueuse), DISCBD (distance au CBD), les indicateurs binaires de zone (NSA, NSB, EW, CP) ainsi que AREA et PERIMETER constituent des covariables explicatives plausibles ; COLUMBUS_, COLUMBUS_I, NEIG, THOUS et NEIGNO sont des identifiants/codes redondants ignorés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `INC` | `numeric` | continuous | 0% |
| `OPEN` | `numeric` | continuous | 0% |
| `PLUMB` | `numeric` | continuous | 0% |
| `DISCBD` | `numeric` | continuous | 0% |
| `NSA` | `numeric` | binary | 0% |
| `NSB` | `numeric` | binary | 0% |
| `EW` | `numeric` | binary | 0% |
| `CP` | `numeric` | binary | 0% |
| `AREA` | `numeric` | rate | 0% |
| `PERIMETER` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: pending

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: R_spdep_oldcol_COL.OLD
- Note: n/a

### Formule — niveau systeme

- formula_used: CRIME ~ HOVAL + INC
- x_terms_used: HOVAL + INC
- y_term_used: CRIME

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
    formula: "CRIME ~ HOVAL + INC"
    response: "CRIME"
    predictors: ["HOVAL", "INC"]
    role: "paper_main_specification"
    source_type: "published_or_manual_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
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

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_spdata.columbus`
- Dataset name: geodatasets::columbus
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
  existing_model_found: true
  equation_text: "CRIME ~ HOVAL + INC"
  equation_family: regression
  model_family: "regression"
  source_type: published_or_manual_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 49
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [6.1659, 10.9621], y [11.0409, 14.4377] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32632 (UTM Zone 32N (EPSG:32632)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

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
  benchmark_status: "ready"
  benchmark_task: "regression_spatial_validated_generated_formula"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte; conserver la trace de validation dans data/manifests/datasets/package_generated_formula_validation_2026-08.csv"
  reason: "Formule generee par le systeme mais validee contre le .rds local: reponse numerique, covariables presentes, model.frame executable et effectif suffisant."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte; conserver la trace de validation dans data/manifests/datasets/package_generated_formula_validation_2026-08.csv
- Raison: Formule generee par le systeme mais validee contre le .rds local: reponse numerique, covariables presentes, model.frame executable et effectif suffisant.

## Estimator eligibility

```yaml
estimator_eligibility:
  - estimator: ols
    basis: scientific_evidence
    source_ref: "Anselin, Luc (1988) Spatial Econometrics: Methods and Models, Chapter 12 Columbus crime example."
    pages: "191-192"
    pdf_pages: "203-204"
    tables: ["12.3"]
    notes: "OLS regression with diagnostics for spatial effects, formula CRIME ~ INC + HOUSE/HOVAL."
  - estimator: sar_lag
    basis: scientific_evidence
    source_ref: "Anselin, Luc (1988) Spatial Econometrics: Methods and Models, Chapter 12 Columbus crime example."
    pages: "192-194"
    pdf_pages: "204-206"
    tables: ["12.4", "12.5"]
    notes: "Mixed regressive spatial autoregressive model with W_CRIME."
  - estimator: sem_error
    basis: scientific_evidence
    source_ref: "Anselin, Luc (1988) Spatial Econometrics: Methods and Models, Chapter 12 Columbus crime example."
    pages: "194-196"
    pdf_pages: "206-208"
    tables: ["12.6", "12.7"]
    notes: "ML estimation of the model with spatially dependent error terms."
  - estimator: sdm_mixed
    basis: scientific_evidence
    source_ref: "Anselin, Luc (1988) Spatial Econometrics: Methods and Models, Chapter 12 Columbus crime example."
    pages: "196-197"
    pdf_pages: "208-209"
    tables: ["12.8"]
    notes: "Spatial Durbin model with W_CRIME, W_INC and W_HOUSE."
  - estimator: spmoran_esf
    basis: benchmark_use
    source_ref: "spatialtidymodels package tests on Columbus; method source must be Murakami/spmoran, not Anselin 1988."
    notes: "Benchmark route only until a paper-source relation is curated."
  - estimator: spmoran_resf
    basis: benchmark_use
    source_ref: "spatialtidymodels package tests on Columbus; method source must be Murakami/spmoran, not Anselin 1988."
    notes: "Benchmark route only until a paper-source relation is curated."
```


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`
