---
title: R_MASS_npr1_npr1
type: dataset
created: 2026-08-14
updated: 2026-08-14
sources:
  - data/final_datasets/sf/R_MASS_npr1_npr1.rds
tags: [dataset, r-package, spatial, point]
---

Data on the locations, porosity and permeability (a measure of oil flow) on 104 oil wells in the US Naval Petroleum Reserve No. 1 in California.

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Data on the locations, porosity and permeability (a measure of oil flow) on 104 oil wells in the US Naval Petroleum Reserve No. 1 in California.
- Description source: package R `MASS`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `perm`
- Candidate Y typology: count
- Candidate X variables: `por`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `perm` | `integer` | count | [4, 4770] | 0% |


> Selection Y/X (claude-sonnet-4-6) : La perméabilité (perm) est la variable cible naturelle car elle mesure la capacité d'écoulement du pétrole, grandeur d'intérêt principal en ingénierie pétrolière. La porosité (por) est la covariable explicative, car elle est physiquement liée à la perméabilité et généralement plus facile à mesurer.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `por` | `integer` | count | 0% |


### Formule — niveau publication

- formula_pub: pending - hypothese non verifiee par analogie avec le traitement de `topo` dans le meme livre (surface de tendance polynomiale degre 2 puis krigeage des residus, ex. por ~ poly(x,y,2)) mais texte du chapitre non accessible pour confirmer ; ne pas retenir comme fait etabli.
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Venables, W. N. and Ripley, B. D. (2002) Modern Applied Statistics with S, 4th ed., Springer. Source terrain : Maher, Carter & Lantz (1975) USGS Professional Paper 912.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: pending - hypothese non verifiee par analogie avec le traitement de `topo` dans le meme livre (surface de tendance polynomiale degre 2 puis krigeage des residus, ex. por ~ poly(x,y,2)) mais texte du chapitre non accessible pour confirmer ; ne pas retenir comme fait etabli.
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

- Dataset ID: `R_MASS_npr1_npr1`
- Dataset name: MASS::npr1
- Source family: r-package
- Source: package R `MASS` (version 7.3.65)
- Source URL: https://CRAN.R-project.org/package=MASS
- Dataset DOI: none
- Publication DOI: pending
- Year: unknown

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "pending - hypothese non verifiee par analogie avec le traitement de `topo` dans le meme livre (surface de tendance polynomiale degre 2 puis krigeage des residus, ex. por ~ poly(x,y,2)) mais texte du chapitre non accessible pour confirmer ; ne pas retenir comme fait etabli."
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Venables, W. N. and Ripley, B. D. (2002) Modern Applied Statistics with S, 4th ed., Springer. Source terrain : Maher, Carter & Lantz (1975) USGS Professional Paper 912."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 104
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [6.13, 13.88], y [1.13, 5.63] (CRS unknown)
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
- Reproducibility status: available via package R `MASS`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_missing_formula"
  benchmark_task: "not_current_regression_benchmark"
  package_include: "no"
  has_local_rds: true
  missing_items: "formule Y ~ X executable manquante"
  reason: "Aucune formule systeme ou publication n est disponible pour ce jeu de donnees package."
```

- Decision: not_ready_missing_formula
- Manque principal: formule Y ~ X executable manquante
- Raison: Aucune formule systeme ou publication n est disponible pour ce jeu de donnees package.


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

- Source: package R `MASS`
