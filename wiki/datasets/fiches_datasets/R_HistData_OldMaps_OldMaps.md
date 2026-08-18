---
title: R_HistData_OldMaps_OldMaps
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/R_HistData_OldMaps_OldMaps.rds
tags: [dataset, r-package, spatial, point]
---

The data set is concerned with the problem of aligning the coordinates of points read from old maps (1688 - 1818) of the Great Lakes area. 39 easily identifiable points were selected in the Great Lakes area, and their (lat, long) coordinates were recorded using a grid overlaid on each of 11 old maps, and using linear interpolation.

## Description du jeu de donnees

- Topic: elections et comportement electoral
- Observation unit: circonscription, bureau de vote ou unite administrative
- Observed population: resultats electoraux ou population votante
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: dimension temporelle structurelle detectee
- Source description: The data set is concerned with the problem of aligning the coordinates of points read from old maps (1688 - 1818) of the Great Lakes area. 39 easily identifiable points were selected in the Great Lakes area, and their (lat, long) coordinates were recorded using a grid overlaid on each of 11 old maps, and using linear interpolation.
- Description source: package R `HistData`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `T`
- Candidate Y typology: continuous
- Candidate X variables: `year`, `col`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `lat`, `long`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `T` | `numeric` | continuous | [1688, 1818] | 8.3% |


> Note doc : y is not good," yet no "*"s appear in the body of the

> Selection Y/X (claude-sonnet-4-6) : T (transformation/alignment target, plage identique à year) est la variable réponse plausible représentant la coordonnée ou valeur transformée à prédire/aligner. Year (date de la carte) et col (colonne/index de carte) sont des covariables explicatives utiles pour modéliser les biais de cartographie historique. Point et name sont des identifiants/libellés ignorés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `year` | `numeric` | continuous | 8.3% |
| `col` | `integer` | count | 0% |


### Formule — niveau publication

- formula_pub: not_applicable - jeu de donnees de calibration cartographique/geodesique (latitude/longitude de 39 points de reference des Grands Lacs sur 11 cartes anciennes 1688-1818 vs coordonnees reelles), destine a diagnostiquer des erreurs de cartographe (erreur constante/proportionnelle en lat/long, rotation), pas une regression Y~X unique et defendable comparable aux autres fiches.
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Andrews, D.F. and Herzberg, A.M. (1985) Data: A Collection of Problems from Many Fields for the Student and Research Worker, Table 10.1, Springer.

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

- Dataset ID: `R_HistData_OldMaps_OldMaps`
- Dataset name: HistData::OldMaps
- Source family: r-package
- Source: package R `HistData` (version 1.0.0)
- Source URL: https://CRAN.R-project.org/package=HistData
- Dataset DOI: none
- Publication DOI: pending
- Year: unknown

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

- Data type: spatio-temporel
- Structure: panel
- N observations: 468
- T periods: 9
- Variable temporelle: year
- N/T profile: N_moyen_T_moyen
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (468) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 463 ; panel NON EQUILIBRE (T par unite : min=1, mediane=1, max=2). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 463 unites spatiales distinctes, pas sur les 468 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.
- Temporal note: dimension temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: pending inspection
- Spatial extent: x [-93.15, 99.22], y [-47.13, 49.25] (CRS unknown)
- Time range: pending inspection
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL
- License URL: https://cran.r-project.org/package=HistData
- License open: yes
- License evidence: CRAN package DB (checked 2026-08-18): License field = 'GPL'.
- Reproducibility status: available via package R `HistData`
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
- Formula: PENDING - formule publication non encore etablie.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: WARN - licence non renseignee automatiquement.

## Related Pages

- Source: package R `HistData`
