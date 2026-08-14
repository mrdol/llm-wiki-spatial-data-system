---
title: R_spatstat.data_finpines_finpines
type: dataset
created: 2026-08-14
updated: 2026-08-14
sources:
  - data/final_datasets/sf/R_spatstat.data_finpines_finpines.rds
tags: [dataset, r-package, spatial, point]
---

The data record the locations of 126 pine saplings in a Finnish forest, their heights and their diameters.

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: The data record the locations of 126 pine saplings in a Finnish forest, their heights and their diameters.
- Description source: package R `spatstat.data`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `height`
- Candidate Y typology: continuous
- Candidate X variables: `diameter`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `height` | `numeric` | continuous | [0.8, 5.4] | 0% |


> Selection Y/X (claude-sonnet-4-6) : La hauteur (height) est la variable réponse la plus naturelle pour modéliser la croissance des arbres, tandis que le diamètre (diameter) constitue une covariable explicative classique en dendrométrie (relation hauteur-diamètre). Les deux rôles peuvent être inversés selon le contexte, mais height ~ diameter est la convention standard.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `diameter` | `integer` | count | 0% |


### Formule — niveau publication

- formula_pub: not_applicable - analyse par fonction J (statistique d'interaction spatiale non parametrique comparant les distances au plus proche voisin par marque), pas une regression height~diameter malgre l'apparence allometrique des colonnes.
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Van Lieshout, M.N.M. (2004) A J-function for marked point patterns. Research Report PNA-R0404, Centrum voor Wiskunde en Informatica.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: not_applicable - analyse par fonction J (statistique d'interaction spatiale non parametrique comparant les distances au plus proche voisin par marque), pas une regression height~diameter malgre l'apparence allometrique des colonnes.
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

- Dataset ID: `R_spatstat.data_finpines_finpines`
- Dataset name: spatstat.data::finpines
- Source family: r-package
- Source: package R `spatstat.data` (version 3.1.9)
- Source URL: https://CRAN.R-project.org/package=spatstat.data
- Dataset DOI: none
- Publication DOI: pending
- Year: 2017

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "not_applicable - analyse par fonction J (statistique d'interaction spatiale non parametrique comparant les distances au plus proche voisin par marque), pas une regression height~diameter malgre l'apparence allometrique des colonnes."
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Van Lieshout, M.N.M. (2004) A J-function for marked point patterns. Research Report PNA-R0404, Centrum voor Wiskunde en Informatica."
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
- Spatial extent: x [-4.9482, 4.8814], y [-7.9674, 1.9951] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://CRAN.R-project.org/package=spatstat.data
- License open: yes
- Reproducibility status: available via package R `spatstat.data`
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
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2)).

## Related Pages

- Source: package R `spatstat.data`
