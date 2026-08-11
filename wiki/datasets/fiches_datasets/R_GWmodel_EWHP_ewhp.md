---
title: R_GWmodel_EWHP_ewhp
type: dataset
created: 2026-08-11
updated: 2026-08-11
sources:
  - data/final_datasets/sf/R_GWmodel_EWHP_ewhp.rds
tags: [dataset, r-package, spatial, point]
---

A house price data set for England and Wales from 2001 with 9 hedonic (explanatory) variables.

## Description du jeu de donnees

- Topic: immobilier / prix des logements
- Observation unit: logement, transaction immobiliere ou zone residentielle selon la documentation source
- Observed population: marche immobilier documente par le package source
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: A house price data set for England and Wales from 2001 with 9 hedonic (explanatory) variables.
- Description source: package R `GWmodel`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `PurPrice`
- Candidate Y typology: continuous
- Candidate X variables: `BldIntWr`, `BldPostW`, `Bld60s`, `Bld70s`, `Bld80s`, `TypDetch`, `TypFlat`, `FlrArea`
- Candidate X typology: categorical, continuous
- Coordinates (x, y — excluded from X candidates): `Easting`, `Northing`, `X`, `Y`
- Identifier columns (excluded from X candidates): `TypSemiD`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PurPrice` | `numeric` | continuous | [8750, 325000] | 0% |


> Note doc : y is detached (i

> Selection Y/X (claude-sonnet-4-6) : PurPrice (purchase price) est la variable réponse naturelle d'un modèle hédonique de prix immobiliers. Les 8 autres colonnes sont des caractéristiques du logement (période de construction, type de bien, surface habitable) constituant les covariables explicatives classiques d'un modèle hédonique.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `BldIntWr` | `integer` | binary | 0% |
| `BldPostW` | `integer` | binary | 0% |
| `Bld60s` | `integer` | binary | 0% |
| `Bld70s` | `integer` | binary | 0% |
| `Bld80s` | `integer` | binary | 0% |
| `TypDetch` | `integer` | binary | 0% |
| `TypFlat` | `integer` | binary | 0% |
| `FlrArea` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Fotheringham, A.S., Brunsdon, C., and Charlton, M.E. (2002) Geographically Weighted Regression: The Analysis of Spatially Varying Relationships. Chichester: Wiley.

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: PurPrice ~ BldIntWr + BldPostW + Bld60s + Bld70s + Bld80s + TypDetch + TypFlat + FlrArea
- x_terms_used: BldIntWr + BldPostW + Bld60s + Bld70s + Bld80s + TypDetch + TypFlat + FlrArea
- y_term_used: PurPrice

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
    formula: "PurPrice ~ BldIntWr + BldPostW + Bld60s + Bld70s + Bld80s + TypDetch + TypFlat + FlrArea"
    response: "PurPrice"
    predictors: ["BldIntWr", "BldPostW", "Bld60s", "Bld70s", "Bld80s", "TypDetch", "TypFlat", "FlrArea"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `R_GWmodel_EWHP_ewhp`
- Dataset name: GWmodel::EWHP
- Source family: r-package
- Source: package R `GWmodel` (version 2.4.1)
- Source URL: https://CRAN.R-project.org/package=GWmodel
- Dataset DOI: none
- Publication DOI: pending
- Year: 2013

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "PurPrice ~ BldIntWr + BldPostW + Bld60s + Bld70s + Bld80s + TypDetch + TypFlat + FlrArea"
  equation_family: regression_candidate
  model_family: "regression_candidate"
  source_type: generated_system_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 519
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [224000, 654600], y [47800, 574000] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://CRAN.R-project.org/package=GWmodel
- License open: yes
- Reproducibility status: available via package R `GWmodel`
- Code available: yes (package examples and vignettes)
- Repository: r-package

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
    basis: benchmark_use
    source_ref: "GWmodel EWHP documentation / project formula."
  - estimator: gam_spatial
    basis: benchmark_use
    source_ref: "GWmodel EWHP documentation / project formula."
  - estimator: mgwrsar_gwr
    basis: benchmark_use
    source_ref: "GWmodel EWHP documentation / project formula."
  - estimator: mgwrsar_mgwr
    basis: benchmark_use
    source_ref: "GWmodel EWHP documentation / project formula."
  - estimator: spboost_bspa_sar_ml
    basis: benchmark_use
    source_ref: "GWmodel EWHP documentation / project formula."
  - estimator: spboost_bspa_sar_cfe
    basis: benchmark_use
    source_ref: "GWmodel EWHP documentation / project formula."
```


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2)).

## Related Pages

- Source: package R `GWmodel`
