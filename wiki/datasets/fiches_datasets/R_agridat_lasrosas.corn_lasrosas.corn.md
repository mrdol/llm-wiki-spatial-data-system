---
title: R_agridat_lasrosas.corn_lasrosas.corn
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/R_agridat_lasrosas.corn_lasrosas.corn.rds
  - data/final_datasets/sf/Python_geodatasets_geoda.lasrosas.rds
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

- formula_pub: yield ~ 1 + nitro + I(nitro^2) (referencee dans catalogue)
- x_terms_pub: 1, nitro, I(nitro^2)
- y_term_pub: yield
- Reference publication: Bongiovanni and Lowenberg-DeBoer (2000). Nitrogen management in corn with a spatial regression model. Proceedings of the Fifth International Conference on Precision Agriculture.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: Python_geodatasets_geoda.lasrosas
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: yield ~ 1 + nitro + I(nitro^2) (referencee dans catalogue)
- x_terms_used: 1 + nitro + I(nitro^2) (referencee dans catalogue)
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
    formula: "yield ~ 1 + nitro + I(nitro^2) (referencee dans catalogue)"
    response: "yield"
    predictors: ["1", "nitro", "I(nitro^2) (referencee dans catalogue)"]
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

- Dataset ID: `R_agridat_lasrosas.corn_lasrosas.corn`
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
  equation_text: yield ~ 1 + nitro + I(nitro^2) (referencee dans catalogue)
  equation_family: regression
  model_family: published_or_manual_regression
  source_type: published_or_manual_formula
  source_ref: data/manifests/datasets/proposed_formula_used_audit.csv
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

## Fusion des sources et variantes

Cette fiche est la fiche canonique du cas d'etude Las Rosas corn. Elle fusionne la source R `agridat::lasrosas.corn` et la source Python `geodatasets::geoda.lasrosas`, qui renvoient au meme dispositif spatial d'essai agronomique.

### Sources fusionnees

| Ancienne fiche | Source package | Objet source | Artefact local | Role |
|---|---|---|---|---|
| `R_agridat_lasrosas.corn_lasrosas.corn` | agridat | `lasrosas.corn` | `data/final_datasets/sf/R_agridat_lasrosas.corn_lasrosas.corn.rds` | fiche canonique conservee |
| `Python_geodatasets_geoda.lasrosas` | geodatasets / GeoDa | `geoda.lasrosas` | `data/final_datasets/sf/Python_geodatasets_geoda.lasrosas.rds` | source Python integree puis retiree comme fiche separee |

### Elements communs

- Meme theme: rendement agricole du mais dans un dispositif spatial.
- Meme reponse principale retenue dans le benchmark: `yield`.
- Meme interet pour tester des estimateurs capables de capter une variation spatiale locale.

### Elements non communs

- La source R porte la documentation agronomique principale.
- La source Python apporte une entree GeoDa compatible avec l'ecosysteme Python.

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: FUSED - fiche commune pour `R_agridat_lasrosas.corn_lasrosas.corn` et `Python_geodatasets_geoda.lasrosas`.
- Reproducibility: OK - source package et licence renseignes (GPL-2).

## Related Pages

- Source: package R `agridat`
