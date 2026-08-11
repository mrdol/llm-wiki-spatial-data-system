---
title: R_ade4_butterfly_butterfly
type: dataset
created: 2026-08-11
updated: 2026-08-11
sources:
  - data/final_datasets/sf/R_ade4_butterfly_butterfly.rds
tags: [dataset, r-package, spatial, point]
---

This data set contains environmental and genetics informations about 16 _Euphydryas editha_ butterfly colonies studied in California and Oregon.

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: This data set contains environmental and genetics informations about 16 _Euphydryas editha_ butterfly colonies studied in California and Oregon.
- Description source: package R `ade4`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: not identified by LLM classification — manual review required
- Candidate Y typology: unknown
- Candidate X variables: not identified by LLM classification — manual review required
- Candidate X typology: unknown
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| — | — | aucun candidat detecte | — | — |


> **ade4** - Donnees ecologiques multivariees. La variable reponse Y et la formule sont a definir manuellement selon l'etude ciblee (ordination, RDA, etc.).

> Selection Y/X (claude-sonnet-4-6) : Aucune variable disponible.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| — | — | aucun candidat | — |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Manly, B.F. (1994) Multivariate Statistical Methods: A Primer. Second edition. Chapman & Hall, London. pp. 1–215.

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

- Dataset ID: `R_ade4_butterfly_butterfly`
- Dataset name: ade4::butterfly
- Source family: r-package
- Source: package R `ade4` (version 1.7.24)
- Source URL: https://CRAN.R-project.org/package=ade4
- Dataset DOI: none
- Publication DOI: pending
- Year: 2002

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
- N observations: 16
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [41, 167], y [18, 238] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://CRAN.R-project.org/package=ade4
- License open: yes
- Reproducibility status: available via package R `ade4`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_multivariate_ecology"
  benchmark_task: "not_current_regression_benchmark"
  package_include: "no"
  has_local_rds: true
  missing_items: "definir une reponse scalaire Y et une formule regression depuis une etude source"
  reason: "Les jeux ade4 sont principalement des donnees ecologiques multivariees/ordination; le generateur ne promeut pas automatiquement une colonne en reponse de regression."
```

- Decision: not_ready_multivariate_ecology
- Manque principal: definir une reponse scalaire Y et une formule regression depuis une etude source
- Raison: Les jeux ade4 sont principalement des donnees ecologiques multivariees/ordination; le generateur ne promeut pas automatiquement une colonne en reponse de regression.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: WARN - Y/X non identifiees automatiquement ; revue manuelle requise.
- Formula: PENDING - formule publication non encore etablie.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2)).

## Related Pages

- Source: package R `ade4`
