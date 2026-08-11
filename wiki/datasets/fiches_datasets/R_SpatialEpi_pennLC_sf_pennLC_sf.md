---
title: R_SpatialEpi_pennLC_sf_pennLC_sf
type: dataset
created: 2026-08-11
updated: 2026-08-11
sources:
  - data/final_datasets/sf/R_SpatialEpi_pennLC_sf_pennLC_sf.rds
tags: [dataset, r-package, spatial, point]
---

County-level (n=67) population/case data for lung cancer in Pennsylvania in 2002, stratified on race (white vs non-white), gender and age (Under 40, 40-59, 60-69 and 70+). Additionally, county-specific smoking rates.

## Description du jeu de donnees

- Topic: sante publique / epidemiologie spatiale
- Observation unit: individu, cas sanitaire ou unite spatiale de sante
- Observed population: population sanitaire documentee par le package source
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: County-level (n=67) population/case data for lung cancer in Pennsylvania in 2002, stratified on race (white vs non-white), gender and age (Under 40, 40-59, 60-69 and 70+). Additionally, county-specific smoking rates.
- Description source: package R `SpatialEpi`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `cases`
- Candidate Y typology: count
- Candidate X variables: `population`, `race`, `gender`, `age`, `smoking`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `cases` | `integer` | count | [0, 387] | 0% |


> Note doc : Number of cases per county split by strata

> Selection Y/X (claude-sonnet-4-6) : cases (nombre de cas de cancer du poumon) est la variable réponse naturelle à modéliser (en tant que count, typiquement via un modèle de Poisson avec offset sur population). population sert d'offset ou de covariable d'exposition, tandis que race, gender, age et smoking sont des facteurs explicatifs classiques de l'incidence du cancer du poumon. county est un libellé administratif ignoré (l'information spatiale est portée par les coordonnées).

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `population` | `integer` | count | 0% |
| `race` | `factor` | categorical | 0% |
| `gender` | `factor` | categorical | 0% |
| `age` | `factor` | categorical | 0% |
| `smoking` | `numeric` | rate | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Kim A.Y., Wakefield J., Moise M. (2023) SpatialEpi: Methods and Data for Spatial Epidemiology. R package version 1.2.8. https://github.com/rudeboybert/SpatialEpi

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: cases ~ population + race + gender + age + smoking
- x_terms_used: population + race + gender + age + smoking
- y_term_used: cases

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
    formula: "cases ~ population + race + gender + age + smoking"
    response: "cases"
    predictors: ["population", "race", "gender", "age", "smoking"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `R_SpatialEpi_pennLC_sf_pennLC_sf`
- Dataset name: SpatialEpi::pennLC_sf
- Source family: r-package
- Source: package R `SpatialEpi` (version 1.2.8)
- Source URL: https://CRAN.R-project.org/package=SpatialEpi
- Dataset DOI: none
- Publication DOI: pending
- Year: 2012

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "cases ~ population + race + gender + age + smoking"
  equation_family: regression_candidate
  model_family: "regression_candidate"
  source_type: generated_system_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 1072
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-80.335, -75.0596], y [39.8664, 42.0436] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32618 (UTM Zone 18N (EPSG:32618)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL-2
- License URL: https://CRAN.R-project.org/package=SpatialEpi
- License open: yes
- Reproducibility status: available via package R `SpatialEpi`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "almost_ready_generated_formula"
  benchmark_task: "regression_spatial_generated_formula"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "valider la formule generee avant inclusion automatique dans le package"
  reason: "La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee."
```

- Decision: almost_ready_generated_formula
- Manque principal: valider la formule generee avant inclusion automatique dans le package
- Raison: La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL-2).

## Related Pages

- Source: package R `SpatialEpi`
