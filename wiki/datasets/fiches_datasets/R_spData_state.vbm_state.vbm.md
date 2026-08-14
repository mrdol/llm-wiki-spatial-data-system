---
title: R_spData_state.vbm_state.vbm
type: dataset
created: 2026-08-14
updated: 2026-08-14
sources:
  - data/final_datasets/sf/R_spData_state.vbm_state.vbm.rds
tags: [dataset, r-package, spatial, point]
---

A SpatialPolygonsDataFrame object to plot a Visibility Based Map.

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: A SpatialPolygonsDataFrame object to plot a Visibility Based Map.
- Description source: package R `spData`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: not identified by LLM classification — manual review required
- Candidate Y typology: unknown
- Candidate X variables: not identified by LLM classification — manual review required
- Candidate X typology: unknown
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| — | — | aucun candidat detecte | — | — |


> Selection Y/X (claude-sonnet-4-6) : Les deux colonnes 'center_x' et 'center_y' représentent des coordonnées géographiques (centroïdes de polygones), qui sont déjà des informations spatiales structurelles du dataset et non des variables réponse ou des covariables explicatives thématiques utiles pour un modèle de spatial ML.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| — | — | aucun candidat | — |


### Formule — niveau publication

- formula_pub: not_applicable - jeu de donnees purement cartographique (polygones redimensionnes pour la lisibilite visuelle), aucune variable reponse ni covariable : seulement center_x/center_y (centroides pour le placement d'etiquettes). L'exemple de la doc colore les etats avec une variable EXTERNE (state.x77) a but de demonstration graphique, pas de modelisation.
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Conversion S-PLUS par Greg Snow d'un cartogramme de Mark Monmonier (visibility-based map des Etats-Unis).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: not_applicable - jeu de donnees purement cartographique (polygones redimensionnes pour la lisibilite visuelle), aucune variable reponse ni covariable : seulement center_x/center_y (centroides pour le placement d'etiquettes). L'exemple de la doc colore les etats avec une variable EXTERNE (state.x77) a but de demonstration graphique, pas de modelisation.
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

- Dataset ID: `R_spData_state.vbm_state.vbm`
- Dataset name: spData::state.vbm
- Source family: r-package
- Source: package R `spData` (version 2.3.4)
- Source URL: https://CRAN.R-project.org/package=spData
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
  equation_text: "not_applicable - jeu de donnees purement cartographique (polygones redimensionnes pour la lisibilite visuelle), aucune variable reponse ni covariable : seulement center_x/center_y (centroides pour le placement d'etiquettes). L'exemple de la doc colore les etats avec une variable EXTERNE (state.x77) a but de demonstration graphique, pas de modelisation."
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Conversion S-PLUS par Greg Snow d'un cartogramme de Mark Monmonier (visibility-based map des Etats-Unis)."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 50
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [9.9, 150], y [8.5, 86.5] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: CC0
- License URL: https://CRAN.R-project.org/package=spData
- License open: yes
- Reproducibility status: available via package R `spData`
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
- Variables: WARN - Y/X non identifiees automatiquement ; revue manuelle requise.
- Formula: OK - formule publication renseignee.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (CC0).

## Related Pages

- Source: package R `spData`
