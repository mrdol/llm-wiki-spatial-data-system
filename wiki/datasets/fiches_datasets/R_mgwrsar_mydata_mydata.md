---
title: R_mgwrsar_mydata_mydata
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/R_mgwrsar_mydata_mydata.rds
tags: [dataset, r-package, spatial, point]
---

mydata is a simulated data set of a mgwrsar model

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: mydata is a simulated data set of a mgwrsar model
- Description source: package R `mgwrsar`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Y_mgwrsar_1_0_kv`, `Y_ols`, `Y_sar`, `Y_gwr`, `Y_mgwr`, `Y_mgwrsar_0_0_kv`, `Y_mgwrsar_0_kc_kv`, `Y_mgwrsar_1_kc_kv`, `Y_mgwr_outlier`, `Y_mgwr_X2dummy`
- Candidate Y typology: continuous
- Candidate X variables: `X0`, `X1`, `X2`, `X3`, `X2dummy`
- Candidate X typology: categorical, continuous
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Y_mgwrsar_1_0_kv` | `numeric` | continuous | [-2.3916, 17.9013] | 0% |
| `Y_ols` | `numeric` | continuous | [-1.5516, 5.9338] | 0% |
| `Y_sar` | `numeric` | continuous | [-0.9002, 7.9647] | 0% |
| `Y_gwr` | `numeric` | continuous | [-2.5638, 9.7722] | 0% |
| `Y_mgwr` | `numeric` | continuous | [-1.7024, 9.776] | 0% |
| `Y_mgwrsar_0_0_kv` | `numeric` | continuous | [-2.3702, 13.5355] | 0% |
| `Y_mgwrsar_0_kc_kv` | `numeric` | continuous | [-1.386, 13.5179] | 0% |
| `Y_mgwrsar_1_kc_kv` | `numeric` | continuous | [-1.3641, 17.8629] | 0% |
| `Y_mgwr_outlier` | `numeric` | continuous | [-5.7251, 9.776] | 0% |
| `Y_mgwr_X2dummy` | `numeric` | continuous | [-2.8495, 7.818] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les colonnes préfixées 'Y_' sont des variables réponses simulées selon différents modèles (OLS, SAR, GWR, MGWRSAR, avec ou sans outliers), chacune pouvant servir de cible selon le benchmark visé. Les colonnes X0–X3 et X2dummy sont les covariables explicatives du modèle simulé ; les colonnes Beta* et lambda sont des paramètres internes du générateur de données (coefficients spatialement variables et paramètre autorégressif) qui ne sont ni des Y observables ni des covariables utiles pour un benchmark d'estimateurs.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `X0` | `numeric` | binary | 0% |
| `X1` | `numeric` | continuous | 0% |
| `X2` | `numeric` | continuous | 0% |
| `X3` | `numeric` | continuous | 0% |
| `X2dummy` | `logical` | binary | 0% |


### Formule — niveau publication

- formula_pub: Y_mgwrsar_0_kc_kv ~ X1 + X2 + X3
- x_terms_pub: X1, X2, X3
- y_term_pub: Y_mgwrsar_0_kc_kv
- Reference publication: Geniaux, G. and Martinetti, D. (2018) A new method for dealing simultaneously with spatial autocorrelation and spatial heterogeneity in regression models. Regional Science and Urban Economics. Formule exacte confirmee dans le manuel de reference CRAN mgwrsar.pdf (exemple MGWRSAR()).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: Y_mgwrsar_0_kc_kv ~ X1 + X2 + X3
- x_terms_used: X1, X2, X3
- y_term_used: Y_mgwrsar_0_kc_kv

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "Y_mgwrsar_0_kc_kv ~ X1 + X2 + X3"
    response: "Y_mgwrsar_0_kc_kv"
    predictors: ["X1, X2, X3"]
    role: "simple_baseline"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Geniaux, G. and Martinetti, D. (2018) A new method for dealing simultaneously with spatial autocorrelation and spatial heterogeneity in regression models. Regional Science and Urban Economics. Formule exacte confirmee dans le manuel de reference CRAN mgwrsar.pdf (exemple MGWRSAR())."
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

- Dataset ID: `R_mgwrsar_mydata_mydata`
- Dataset name: mgwrsar::mydata
- Source family: r-package
- Source: package R `mgwrsar` (version 1.3.2)
- Source URL: https://CRAN.R-project.org/package=mgwrsar
- Dataset DOI: none
- Publication DOI: 10.1016/j.regsciurbeco.2017.04.001
- Year: unknown

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Y_mgwrsar_0_kc_kv ~ X1 + X2 + X3"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Geniaux, G. and Martinetti, D. (2018) A new method for dealing simultaneously with spatial autocorrelation and spatial heterogeneity in regression models. Regional Science and Urban Economics. Formule exacte confirmee dans le manuel de reference CRAN mgwrsar.pdf (exemple MGWRSAR())."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 1000
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [860021.0002, 879998.0491], y [6220023.3195, 6239997.4454] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: available via package R `mgwrsar`
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
- Reproducibility: WARN - licence non renseignee automatiquement.

## Related Pages

- Source: package R `mgwrsar`
