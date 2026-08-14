---
title: R_agridat_lasrosas.corn_lasrosas.corn
type: dataset
created: 2026-08-11
updated: 2026-08-11
sources:
  - data/final_datasets/sf/R_agridat_lasrosas.corn_lasrosas.corn.rds
tags: [dataset, r-package, spatial, point]
---

Yield monitor data for a corn field in Argentina with variable nitrogen.

## Description du jeu de donnees

- Topic: agriculture / rendement ou experimentation agronomique
- Observation unit: parcelle, placette experimentale ou observation agricole
- Observed population: observations agricoles documentees par le package source
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: dimension temporelle structurelle detectee
- Source description: Yield monitor data for a corn field in Argentina with variable nitrogen.
- Description source: package R `agridat`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `yield`
- Candidate Y typology: continuous
- Candidate X variables: `nitro`, `topo`, `bv`, `nf`, `year`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `lat`, `long`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `yield` | `numeric` | continuous | [12.66, 117.9] | 0% |


> Selection Y/X (claude-sonnet-4-6) : yield (rendement en maïs) est la variable réponse naturelle d'un moniteur de rendement. nitro (dose d'azote variable), topo (position topographique), bv (valeur liée au sol/bassin versant), nf (facteur azote) et year (année de campagne) sont des covariables explicatives agronomiques et environnementales pertinentes. La colonne T est ignorée car elle semble redondante avec year (même plage [1999,2001]), et rep est un identifiant de répétition expérimentale de nature purement administrative.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `nitro` | `numeric` | continuous | 0% |
| `topo` | `factor` | categorical | 0% |
| `bv` | `numeric` | continuous | 0% |
| `nf` | `factor` | categorical | 0% |
| `year` | `integer` | count | 0% |


### Formule — niveau publication

- formula_pub: yield ~ nitro + I(nitro^2) + topo + nitro:topo + I(nitro^2):topo (referencee dans catalogue)
- x_terms_pub: nitro + I(nitro^2) + topo + nitro:topo + I(nitro^2):topo
- y_term_pub: yield
- Reference publication: Bongiovanni and Lowenberg-DeBoer (2000); Anselin, Bongiovanni and Lowenberg-DeBoer (2004, DOI 10.1111/j.0002-9092.2004.00610.x); Rakshit et al. (2020, DOI 10.1016/j.fcr.2020.107783).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: Python_geodatasets_geoda.lasrosas
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: yield ~ nitro + I(nitro^2) + topo + nitro:topo + I(nitro^2):topo
- x_terms_used: nitro + I(nitro^2) + topo + nitro:topo + I(nitro^2):topo
- y_term_used: yield

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
    formula: "yield ~ nitro + I(nitro^2) + topo + nitro:topo + I(nitro^2):topo"
    response: "yield"
    predictors: ["nitro", "I(nitro^2)", "topo", "nitro:topo", "I(nitro^2):topo"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Bongiovanni and Lowenberg-DeBoer (2000); Anselin, Bongiovanni and Lowenberg-DeBoer (2004, DOI 10.1111/j.0002-9092.2004.00610.x); Rakshit et al. (2020, DOI 10.1016/j.fcr.2020.107783)."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "yield ~ nitro + bv"
    response: "yield"
    predictors: ["nitro", "bv"]
    role: "package_benchmark_default"
    source_type: "project_curated"
    source_ref: "agridat::lasrosas.corn documentation / current spatialtidymodels benchmark"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost", "mgwrsar_gwr"]
    status: "confirmed_executable"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `R_agridat_lasrosas.corn_lasrosas.corn`
- Dataset aliases: `lasrosas`, `lasrosas.corn`, `Python_geodatasets_geoda.lasrosas`, `python_geodatasets_geoda_lasrosas`
- Dataset name: agridat::lasrosas.corn
- Source family: r-package
- Source: package R `agridat` (version 1.26)
- Source URL: https://CRAN.R-project.org/package=agridat
- Dataset DOI: none
- Publication DOI: pending
- Year: 2011

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "yield ~ nitro + I(nitro^2) + topo + nitro:topo + I(nitro^2):topo"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Bongiovanni and Lowenberg-DeBoer (2000); Anselin, Bongiovanni and Lowenberg-DeBoer (2004, DOI 10.1111/j.0002-9092.2004.00610.x); Rakshit et al. (2020, DOI 10.1016/j.fcr.2020.107783)."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatio-temporel
- Structure: panel
- N observations: 3443
- T periods: 2
- Variable temporelle: year
- N/T profile: N_grand_T_moyen
- Temporal note: dimension temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: pending inspection
- Spatial extent: x [-63.8489, -63.8417], y [-33.0523, -33.0488] (CRS unknown)
- Time range: pending inspection
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL-2
- License URL: https://CRAN.R-project.org/package=agridat
- License open: yes
- Reproducibility status: available via package R `agridat`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_spatial_validated_paper_and_package_formulas"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte; formule papier complete et formule benchmark package documentees"
  reason: "Dataset Las Rosas reconcilie: agridat::lasrosas.corn est la fiche canonique, Python_geodatasets_geoda.lasrosas est un alias, et les formules papier/package sont conservees comme roles distincts."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte; formule papier complete et formule benchmark package documentees
- Raison: Dataset Las Rosas reconcilie: agridat::lasrosas.corn est la fiche canonique, Python_geodatasets_geoda.lasrosas est un alias, et les formules papier/package sont conservees comme roles distincts.

## Estimator eligibility

```yaml
estimator_eligibility:
  - estimator: ols
    basis: benchmark_use
    source_ref: "agridat lasrosas.corn documentation / project regression formula."
  - estimator: gam_spatial
    basis: benchmark_use
    source_ref: "agridat lasrosas.corn documentation / project regression formula."
  - estimator: gamboost
    basis: benchmark_use
    source_ref: "agridat lasrosas.corn documentation / project regression formula."
  - estimator: random_forest
    basis: benchmark_use
    source_ref: "agridat lasrosas.corn documentation / project regression formula."
  - estimator: random_forest_xy
    basis: benchmark_use
    source_ref: "agridat lasrosas.corn documentation / project regression formula."
  - estimator: xgboost
    basis: benchmark_use
    source_ref: "agridat lasrosas.corn documentation / project regression formula."
  - estimator: xgboost_xy
    basis: benchmark_use
    source_ref: "agridat lasrosas.corn documentation / project regression formula."
  - estimator: spboost_bspa_sar_ml
    basis: benchmark_use
    source_ref: "agridat lasrosas.corn documentation / project regression formula."
  - estimator: spboost_bspa_sar_cfe
    basis: benchmark_use
    source_ref: "agridat lasrosas.corn documentation / project regression formula."
  - estimator: mgwrsar_gwr
    basis: benchmark_use
    source_ref: "agridat lasrosas.corn documentation / project regression formula."
  - estimator: MGWRSAR_0_kc_kv
    basis: benchmark_use
    source_ref: "agridat lasrosas.corn documentation / project regression formula."
  - estimator: MGWRSAR_1_kc_kv
    basis: benchmark_use
    source_ref: "agridat lasrosas.corn documentation / project regression formula."
```


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

- Source: package R `agridat`
