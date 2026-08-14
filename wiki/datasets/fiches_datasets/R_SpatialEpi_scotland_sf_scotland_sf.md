---
title: R_SpatialEpi_scotland_sf_scotland_sf
type: dataset
created: 2026-08-14
updated: 2026-08-14
sources:
  - data/final_datasets/sf/R_SpatialEpi_scotland_sf_scotland_sf.rds
tags: [dataset, r-package, spatial, point]
---

County-level (n=56) data for lip cancer among males in Scotland between 1975-1980

## Description du jeu de donnees

- Topic: sante publique / epidemiologie spatiale
- Observation unit: individu, cas sanitaire ou unite spatiale de sante
- Observed population: population sanitaire documentee par le package source
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: County-level (n=56) data for lip cancer among males in Scotland between 1975-1980
- Description source: package R `SpatialEpi`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `cases`
- Candidate Y typology: continuous
- Candidate X variables: `expected`, `AFF`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `cases` | `numeric` | continuous | [0, 39] | 0% |


> Note doc : number of cases, population and strata

> Selection Y/X (claude-sonnet-4-6) : cases (nombre de cas de cancer de la lèvre observés) est la variable réponse naturelle pour la modélisation de cette maladie. expected (cas attendus sous hypothèse nulle) sert de terme d'offset ou de covariable de standardisation, et AFF (proportion de la population active dans l'agriculture, la pêche et la forêt, proxy d'exposition solaire) est la covariable explicative classique de ce jeu de données. county.names est un libellé géographique ignoré.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `expected` | `numeric` | continuous | 0% |
| `AFF` | `numeric` | rate | 0% |


### Formule — niveau publication

- formula_pub: cases ~ AFF + offset(log(expected))
- x_terms_pub: AFF
- y_term_pub: cases
- Reference publication: Clayton D. and Kaldor J. (1987) Empirical Bayes estimates of age-standardized relative risks for use in disease mapping. Biometrics, 43, 671-681.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: cases ~ AFF + offset(log(expected))
- x_terms_used: AFF
- y_term_used: cases

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "cases ~ AFF + offset(log(expected))"
    response: "cases"
    predictors: ["AFF"]
    role: "simple_baseline"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Clayton D. and Kaldor J. (1987) Empirical Bayes estimates of age-standardized relative risks for use in disease mapping. Biometrics, 43, 671-681."
    estimator_context: ["linear_regression", "kriging_auxiliary", "spatial_baseline"]
    status: "confirmed"

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

- Dataset ID: `R_SpatialEpi_scotland_sf_scotland_sf`
- Dataset name: SpatialEpi::scotland
- Source family: r-package
- Source: package R `SpatialEpi` (version 1.2.8)
- Source URL: https://CRAN.R-project.org/package=SpatialEpi
- Dataset DOI: none
- Publication DOI: 10.2307/2532003
- Year: 2012

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "cases ~ AFF + offset(log(expected))"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Clayton D. and Kaldor J. (1987) Empirical Bayes estimates of age-standardized relative risks for use in disease mapping. Biometrics, 43, 671-681."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 56
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [120.7006, 450.6701], y [559.4105, 1197.2] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

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
  benchmark_status: "ready"
  benchmark_task: "regression_spatial_package_formula"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Formule issue d une publication/documentation package, reponse numerique, covariables locales et support spatial disponibles."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Formule issue d une publication/documentation package, reponse numerique, covariables locales et support spatial disponibles.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL-2).

## Related Pages

- Source: package R `SpatialEpi`
