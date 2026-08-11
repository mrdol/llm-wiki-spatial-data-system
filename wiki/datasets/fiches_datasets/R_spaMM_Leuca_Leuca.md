---
title: R_spaMM_Leuca_Leuca
type: dataset
created: 2026-08-11
updated: 2026-08-11
sources:
  - data/final_datasets/sf/R_spaMM_Leuca_Leuca.rds
tags: [dataset, r-package, spatial, point]
---

A data set from Tonnabel et al. (2021) to be fitted by models with sex-specific spatial random effects. Leucadrendron rubrum is a dioecious shrub from South Africa. Various phenotypes were recorded on individuals from a small patch of habitat.

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: A data set from Tonnabel et al. (2021) to be fitted by models with sex-specific spatial random effects. Leucadrendron rubrum is a dioecious shrub from South Africa. Various phenotypes were recorded on individuals from a small patch of habitat.
- Description source: package R `spaMM`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `fec`, `fec_div`, `area`, `diam`
- Candidate Y typology: continuous, count
- Candidate X variables: `sex`, `diamZ`, `areaZ`, `male`, `female`
- Candidate X typology: categorical, continuous
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `fec` | `numeric` | continuous | [0.0052, 15.6166] | 0% |
| `fec_div` | `numeric` | continuous | [0.0051, 15.372] | 0% |
| `area` | `numeric` | continuous | [0.2129, 1.4847] | 0% |
| `diam` | `integer` | count | [18, 198] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables phénotypiques comme la fécondité (fec, fec_div) et les mesures de taille (area, diam) sont des réponses biologiques plausibles dans un contexte d'écologie des plantes. Le sexe (sex, male, female) est une covariable explicative clé pour des modèles avec effets spatiaux sex-spécifiques, tandis que diamZ et areaZ sont des versions standardisées des traits morphologiques utilisables comme covariables ; name est ignoré car purement administratif, et on évite de placer simultanément diam/area et leurs versions standardisées du même côté.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `sex` | `factor` | categorical | 0% |
| `diamZ` | `numeric` | continuous | 0% |
| `areaZ` | `numeric` | continuous | 0% |
| `male` | `logical` | binary | 0% |
| `female` | `logical` | binary | 0% |


### Formule — niveau publication

- formula_pub: fec_div ~ sex + Matern(1|x+y %in% sex)
- x_terms_pub: sex, Matern(1|x+y %in% sex)
- y_term_pub: fec_div
- Reference publication: Tonnabel J., Klein E.K., Ronce O., Oddou-Muratorio S., Rousset F., Olivieri I., Courtiol A. and Mignot A. (2021) Sex-specific spatial variation in fitness in the highly dimorphic Leucadendron rubrum. Molecular Ecology, 30: 1721-1735.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: fec_div ~ sex + Matern(1|x+y %in% sex)
- x_terms_used: sex, Matern(1|x+y %in% sex)
- y_term_used: fec_div

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
    formula: "fec_div ~ sex + Matern(1|x+y %in% sex)"
    response: "fec_div"
    predictors: ["sex, Matern(1|x", "y %in% sex)"]
    role: "paper_main_specification"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Tonnabel J., Klein E.K., Ronce O., Oddou-Muratorio S., Rousset F., Olivieri I., Courtiol A. and Mignot A. (2021) Sex-specific spatial variation in fitness in the highly dimorphic Leucadendron rubrum. Molecular Ecology, 30: 1721-1735."
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

- Dataset ID: `R_spaMM_Leuca_Leuca`
- Dataset name: spaMM::Leuca
- Source family: r-package
- Source: package R `spaMM` (version 4.6.65)
- Source URL: https://CRAN.R-project.org/package=spaMM
- Dataset DOI: none
- Publication DOI: 10.1111/mec.15833
- Year: 2013

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "fec_div ~ sex + Matern(1|x+y %in% sex)"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Tonnabel J., Klein E.K., Ronce O., Oddou-Muratorio S., Rousset F., Olivieri I., Courtiol A. and Mignot A. (2021) Sex-specific spatial variation in fitness in the highly dimorphic Leucadendron rubrum. Molecular Ecology, 30: 1721-1735."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 156
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [0.5, 68], y [0.5, 102] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: CeCILL-2
- License URL: https://CRAN.R-project.org/package=spaMM
- License open: yes
- Reproducibility status: available via package R `spaMM`
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
- Formula: OK - formule publication renseignee.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (CeCILL-2).

## Related Pages

- Source: package R `spaMM`
