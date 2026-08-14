---
title: R_spacetime_air_DE_NUTS1
type: dataset
created: 2026-08-14
updated: 2026-08-14
sources:
  - data/final_datasets/sf/R_spacetime_air_DE_NUTS1.rds
tags: [dataset, r-package, spatial, point]
---

Air quality data obtained from the airBase European air quality data base. Daily averages for rural background stations in Germany, 1998-2009. In addition, NUTS1 regions (states, or Bundeslaender) for Germany to illustrate spatial aggregation over irregular regions.

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Air quality data obtained from the airBase European air quality data base. Daily averages for rural background stations in Germany, 1998-2009. In addition, NUTS1 regions (states, or Bundeslaender) for Germany to illustrate spatial aggregation over irregular regions.
- Description source: package R `spacetime`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Shape_Area`
- Candidate Y typology: continuous
- Candidate X variables: `Shape_Leng`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Shape_Area` | `numeric` | continuous | [0.0428, 8.6561] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Ce dataset semble être une table de régions administratives NUTS1 allemandes sans variables de qualité de l'air réellement incluses dans les colonnes listées. Seules Shape_Area (superficie de la région) et Shape_Leng (périmètre) sont des variables numériques continues exploitables ; Shape_Area peut servir de variable cible géomorphologique et Shape_Leng de covariable explicative. Toutes les autres colonnes sont des identifiants, codes ou libellés administratifs/géographiques à ignorer.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Shape_Leng` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: not_applicable - couche de polygones administratifs allemands (NUTS1/Bundeslander) utilisee pour illustrer l'agregation spatiale, sans variable reponse propre. La variable PM10 reelle vit dans l'objet separe STFDF (stations/dates/PM10), non present dans ce depot.
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: https://www.eionet.europa.eu/etcs/etc-acm/databases/airbase (gadm.org pour les polygones administratifs)

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: not_applicable - couche de polygones administratifs allemands (NUTS1/Bundeslander) utilisee pour illustrer l'agregation spatiale, sans variable reponse propre. La variable PM10 reelle vit dans l'objet separe STFDF (stations/dates/PM10), non present dans ce depot.
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

- Dataset ID: `R_spacetime_air_DE_NUTS1`
- Dataset name: spacetime::air
- Source family: r-package
- Source: package R `spacetime` (version 1.3.3)
- Source URL: https://CRAN.R-project.org/package=spacetime
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
  equation_text: "not_applicable - couche de polygones administratifs allemands (NUTS1/Bundeslander) utilisee pour illustrer l'agregation spatiale, sans variable reponse propre. La variable PM10 reelle vit dans l'objet separe STFDF (stations/dates/PM10), non present dans ce depot."
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "https://www.eionet.europa.eu/etcs/etc-acm/databases/airbase (gadm.org pour les polygones administratifs)"
  confidence: medium
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
- Spatial extent: x [6.9741, 14.1588], y [48.6606, 54.2129] (CRS unknown)
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
- Reproducibility status: available via package R `spacetime`
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
- Missing values: WARN - variables avec NA > 20% : VARNAME_1 (NA=43.8%), NL_NAME_1 (NA=100%), CC_1 (NA=100%), REMARKS_1 (NA=100%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: WARN - licence non renseignee automatiquement.

## Related Pages

- Source: package R `spacetime`
