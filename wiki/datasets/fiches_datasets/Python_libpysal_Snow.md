---
title: Python_libpysal_Snow
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/Python_libpysal_Snow.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `libpysal` (`Snow`).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `libpysal` (`Snow`).
- Description source: package Python `libpysal`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `deaths`, `deaths_r`, `deaths_nr`
- Candidate Y typology: count
- Candidate X variables: `pestfield`, `dis_pestf`, `dis_sewers`, `dis_bspump`
- Candidate X typology: categorical, continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `ID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `deaths` | `integer` | count | [0, 18] | 0% |
| `deaths_r` | `integer` | count | [0, 12] | 0% |
| `deaths_nr` | `integer` | count | [0, 18] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Ce dataset correspond aux données historiques de choléra de John Snow (Londres 1854) : les variables de décès (totaux, résidents, non-résidents) sont les réponses naturelles à modéliser. Les distances à la pompe Broad Street (dis_bspump), aux égouts (dis_sewers), au champ de pestilence (dis_pestf) et la présence du champ (pestfield) sont des covariables spatiales explicatives classiques pour ce benchmark. Note : deaths étant la somme de deaths_r et deaths_nr, il faudra éviter de les utiliser simultanément comme Y.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `pestfield` | `integer` | binary | 0% |
| `dis_pestf` | `numeric` | continuous | 0% |
| `dis_sewers` | `numeric` | continuous | 0% |
| `dis_bspump` | `numeric` | continuous | 0% |


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

- formula_used: deaths ~ pestfield + dis_pestf + dis_sewers + dis_bspump
- x_terms_used: pestfield + dis_pestf + dis_sewers + dis_bspump
- y_term_used: deaths

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
    formula: "deaths ~ pestfield + dis_pestf + dis_sewers + dis_bspump"
    response: "deaths"
    predictors: ["pestfield", "dis_pestf", "dis_sewers", "dis_bspump"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_libpysal_Snow`
- Dataset name: libpysal::Snow
- Source family: python-package
- Source: package Python `libpysal`
- Source URL: https://pypi.org/project/libpysal/
- Dataset DOI: none
- Publication DOI: pending
- Year: 2017

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "deaths ~ pestfield + dis_pestf + dis_sewers + dis_bspump"
  equation_family: regression_candidate
  model_family: "regression_candidate"
  source_type: generated_system_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 1852
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-0.1424, -0.1324], y [51.5099, 51.516] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32630 (UTM Zone 30N (EPSG:32630)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/libpysal/
- License open: yes
- Reproducibility status: available via package Python `libpysal`
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

- Source: package Python `libpysal`
