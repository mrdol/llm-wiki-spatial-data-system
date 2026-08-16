---
title: R_spData_nydata_nydata
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/R_spData_nydata_nydata.rds
tags: [dataset, r-package, spatial, point]
---

New York leukemia data taken from the data sets supporting Waller and Gotway 2004 (the data should be loaded by running ‘example(NY_data)’ to demonstrate spatial data import techniques)

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: New York leukemia data taken from the data sets supporting Waller and Gotway 2004 (the data should be loaded by running ‘example(NY_data)’ to demonstrate spatial data import techniques)
- Description source: package R `spData`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `TRACTCAS`, `PROPCAS`, `Z`
- Candidate Y typology: continuous, rate
- Candidate X variables: `POP8`, `PCTOWNHOME`, `PCTAGE65P`, `AVGIDIST`, `PEXPOSURE`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `AREAKEY`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `TRACTCAS` | `numeric` | continuous | [0, 9.29] | 0% |
| `PROPCAS` | `numeric` | rate | [0, 0.007] | 0% |
| `Z` | `numeric` | continuous | [-1.9206, 4.7105] | 0% |


> Note doc : number of cases 1978-1982

> Selection Y/X (claude-sonnet-4-6) : Les variables de leucémie (cas par tract TRACTCAS, proportion de cas PROPCAS, score standardisé Z) sont les cibles naturelles d'une modélisation épidémiologique spatiale. POP8 (population), PCTOWNHOME, PCTAGE65P (facteurs socio-démographiques), AVGIDIST et PEXPOSURE (distance/exposition à une source de contamination supposée, typiquement TCE) sont des covariables explicatives classiques dans ce dataset ; AREANAME est ignoré comme libellé administratif.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `POP8` | `numeric` | continuous | 0% |
| `PCTOWNHOME` | `numeric` | rate | 0% |
| `PCTAGE65P` | `numeric` | rate | 0% |
| `AVGIDIST` | `numeric` | continuous | 0% |
| `PEXPOSURE` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: Cases ~ PEXPOSURE + PCTAGE65P + PCTOWNHOME + offset(log(POP8))
- x_terms_pub: PEXPOSURE, PCTAGE65P, PCTOWNHOME
- y_term_pub: Cases
- Reference publication: Waller, L. and C. Gotway (2004) Applied Spatial Statistics for Public Health Data, Ch. 9, Wiley. Formule confirmee par reproduction dans Bivand, Pebesma & Gomez-Rubio (2008) Applied Spatial Data Analysis with R (coefficients rapportes : PEXPOSURE 0.153, PCTOWNHOME -0.359, PCTAGE65P 4.050).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: Cases ~ PEXPOSURE + PCTAGE65P + PCTOWNHOME + offset(log(POP8))
- x_terms_used: PEXPOSURE, PCTAGE65P, PCTOWNHOME
- y_term_used: Cases

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "Cases ~ PEXPOSURE + PCTAGE65P + PCTOWNHOME + offset(log(POP8))"
    response: "Cases"
    predictors: ["PEXPOSURE, PCTAGE65P, PCTOWNHOME"]
    role: "simple_baseline"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Waller, L. and C. Gotway (2004) Applied Spatial Statistics for Public Health Data, Ch. 9, Wiley. Formule confirmee par reproduction dans Bivand, Pebesma & Gomez-Rubio (2008) Applied Spatial Data Analysis with R (coefficients rapportes : PEXPOSURE 0.153, PCTOWNHOME -0.359, PCTAGE65P 4.050)."
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

- Dataset ID: `R_spData_nydata_nydata`
- Dataset name: spData::nydata
- Source family: r-package
- Source: package R `spData` (version 2.3.4)
- Source URL: https://CRAN.R-project.org/package=spData
- Dataset DOI: none
- Publication DOI: 10.1002/0471662682
- Year: 2017

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Cases ~ PEXPOSURE + PCTAGE65P + PCTOWNHOME + offset(log(POP8))"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Waller, L. and C. Gotway (2004) Applied Spatial Statistics for Public Health Data, Ch. 9, Wiley. Formule confirmee par reproduction dans Bivand, Pebesma & Gomez-Rubio (2008) Applied Spatial Data Analysis with R (coefficients rapportes : PEXPOSURE 0.153, PCTOWNHOME -0.359, PCTAGE65P 4.050)."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 281
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-55.4823, 53.5086], y [-75.2907, 56.4101] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: CC0
- License URL: https://CRAN.R-project.org/package=spData
- License open: yes
- Reproducibility status: available via package R `spData`
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
- Missing values: WARN - variables avec NA > 20% : AREANAME (NA=29.5%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (CC0).

## Related Pages

- Source: package R `spData`
