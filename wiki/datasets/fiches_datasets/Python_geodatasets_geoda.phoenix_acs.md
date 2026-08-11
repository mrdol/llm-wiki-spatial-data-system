---
title: Python_geodatasets_geoda.phoenix_acs
type: dataset
created: 2026-08-11
updated: 2026-08-11
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.phoenix_acs.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`phoenix_acs`).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`phoenix_acs`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `inc`, `pop_dens`, `renter_rt`, `vac_hsu_rt`
- Candidate Y typology: continuous
- Candidate X variables: `ALAND10`, `AWATER10`, `pop`, `white_rt`, `black_rt`, `hisp_rt`, `fem_nh_rt`, `hsu`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `inc` | `numeric` | continuous | [1492, 111744] | 0% |
| `pop_dens` | `numeric` | continuous | [0.0047, 904.6753] | 0% |
| `renter_rt` | `numeric` | continuous | [0, 53.9407] | 0% |
| `vac_hsu_rt` | `numeric` | continuous | [0, 70.1965] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables socio-économiques et de marché du logement (revenu médian, densité de population, taux de locataires, taux de vacance) constituent des cibles naturelles pour des modèles prédictifs spatiaux. Les caractéristiques physiques du territoire (surfaces), démographiques (population totale, composition ethnique/raciale, part des femmes hors hispanique) et le stock de logements servent de covariables explicatives ; les colonnes d'erreur de mesure (inc_error, pct_error, l_pct_err) et les identifiants/libellés géographiques (GEOID10, NAMELSAD10) sont écartés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `ALAND10` | `numeric` | continuous | 0% |
| `AWATER10` | `numeric` | continuous | 0% |
| `pop` | `numeric` | continuous | 0% |
| `white_rt` | `numeric` | continuous | 0% |
| `black_rt` | `numeric` | continuous | 0% |
| `hisp_rt` | `numeric` | continuous | 0% |
| `fem_nh_rt` | `numeric` | continuous | 0% |
| `hsu` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: pending

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: inc ~ ALAND10 + AWATER10 + pop + white_rt + black_rt + hisp_rt + fem_nh_rt + hsu
- x_terms_used: ALAND10 + AWATER10 + pop + white_rt + black_rt + hisp_rt + fem_nh_rt + hsu
- y_term_used: inc

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
    formula: "inc ~ ALAND10 + AWATER10 + pop + white_rt + black_rt + hisp_rt + fem_nh_rt + hsu"
    response: "inc"
    predictors: ["ALAND10", "AWATER10", "pop", "white_rt", "black_rt", "hisp_rt", "fem_nh_rt", "hsu"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.phoenix_acs`
- Dataset name: geodatasets::phoenix_acs
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
  equation_text: "inc ~ ALAND10 + AWATER10 + pop + white_rt + black_rt + hisp_rt + fem_nh_rt + hsu"
  equation_family: regression_candidate
  model_family: "regression_candidate"
  source_type: generated_system_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 985
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-113.1163, -110.5784], y [32.5242, 33.9764] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32612 (UTM Zone 12N (EPSG:32612)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

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
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`
