---
title: R_gstat_oxford_oxford
type: dataset
created: 2026-08-11
updated: 2026-08-11
sources:
  - data/final_datasets/sf/R_gstat_oxford_oxford.rds
tags: [dataset, r-package, spatial, point]
---

Data: 126 soil augerings on a 100 x 100m square grid, with 6 columns and 21 rows. Grid is oriented with long axis North-north-west to South-south-east Origin of grid is South-south-east point, 100m outside grid.

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Data: 126 soil augerings on a 100 x 100m square grid, with 6 columns and 21 rows. Grid is oriented with long axis North-north-west to South-south-east Origin of grid is South-south-east point, 100m outside grid.
- Description source: package R `gstat`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `PROFCLASS`, `MAPCLASS`, `DEPTHCM`, `DEP2LIME`, `PCLAY1`, `PCLAY2`, `OM1`, `CEC1`, `PH1`, `PHOS1`, `POT1`, `MG1`
- Candidate Y typology: categorical, continuous
- Candidate X variables: `ELEV`, `VAL1`, `CHR1`, `LIME1`, `VAL2`, `CHR2`, `LIME2`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `XCOORD`, `YCOORD`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PROFCLASS` | `factor` | categorical | None | 0% |
| `MAPCLASS` | `factor` | categorical | None | 0% |
| `DEPTHCM` | `numeric` | continuous | [10, 91] | 0% |
| `DEP2LIME` | `numeric` | continuous | [20, 90] | 0% |
| `PCLAY1` | `numeric` | continuous | [10, 37] | 0% |
| `PCLAY2` | `numeric` | continuous | [10, 40] | 0% |
| `OM1` | `numeric` | continuous | [2.6, 13.1] | 0% |
| `CEC1` | `numeric` | continuous | [7, 43] | 0% |
| `PH1` | `numeric` | continuous | [4.2, 7.7] | 0% |
| `PHOS1` | `numeric` | continuous | [1.7, 25] | 0% |
| `POT1` | `numeric` | continuous | [83, 847] | 0% |
| `MG1` | `numeric` | continuous | [19, 308] | 0% |


> Selection Y/X (claude-sonnet-4-6) : L'élévation (ELEV) et les attributs de terrain/horizon (VAL, CHR, LIME pour les couches 1 et 2) sont des covariables explicatives naturelles dans un contexte de cartographie pédologique. Les propriétés chimiques et physiques du sol mesurées (pH, matière organique, CEC, phosphore, potassium, magnésium, argile, profondeur, profondeur à la limite calcaire) ainsi que les classes de profil/carte constituent des cibles typiques pour la prédiction spatiale ; PROFILE est ignoré car c'est un simple identifiant de sondage.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `ELEV` | `numeric` | continuous | 0% |
| `VAL1` | `numeric` | continuous | 0% |
| `CHR1` | `numeric` | continuous | 0% |
| `LIME1` | `numeric` | continuous | 0% |
| `VAL2` | `numeric` | continuous | 0% |
| `CHR2` | `numeric` | continuous | 0% |
| `LIME2` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Burrough, P.A., McDonnell, R.A. (1998) Principles of Geographical Information Systems. Oxford University Press.

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: PROFCLASS ~ ELEV + VAL1 + CHR1 + LIME1 + VAL2 + CHR2 + LIME2
- x_terms_used: ELEV + VAL1 + CHR1 + LIME1 + VAL2 + CHR2 + LIME2
- y_term_used: PROFCLASS

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
    formula: "PROFCLASS ~ ELEV + VAL1 + CHR1 + LIME1 + VAL2 + CHR2 + LIME2"
    response: "PROFCLASS"
    predictors: ["ELEV", "VAL1", "CHR1", "LIME1", "VAL2", "CHR2", "LIME2"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `R_gstat_oxford_oxford`
- Dataset name: gstat::oxford
- Source family: r-package
- Source: package R `gstat` (version 2.1.6)
- Source URL: https://CRAN.R-project.org/package=gstat
- Dataset DOI: none
- Publication DOI: pending
- Year: 2003

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "PROFCLASS ~ ELEV + VAL1 + CHR1 + LIME1 + VAL2 + CHR2 + LIME2"
  equation_family: regression_candidate
  model_family: "regression_candidate"
  source_type: generated_system_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 126
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [100, 600], y [100, 2100] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2.0)
- License URL: https://CRAN.R-project.org/package=gstat
- License open: yes
- Reproducibility status: available via package R `gstat`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_non_continuous_response"
  benchmark_task: "not_current_regression_benchmark"
  package_include: "no"
  has_local_rds: true
  missing_items: "route classification/binomiale/survie ou transformation continue explicite requise"
  reason: "La variable reponse ou la formule n est pas une regression continue scalaire compatible avec le benchmark actuel."
```

- Decision: not_ready_non_continuous_response
- Manque principal: route classification/binomiale/survie ou transformation continue explicite requise
- Raison: La variable reponse ou la formule n est pas une regression continue scalaire compatible avec le benchmark actuel.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2.0)).

## Related Pages

- Source: package R `gstat`
