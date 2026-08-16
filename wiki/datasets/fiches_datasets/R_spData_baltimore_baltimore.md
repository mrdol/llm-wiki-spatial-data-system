---
title: R_spData_baltimore_baltimore
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/R_spData_baltimore_baltimore.rds
tags: [dataset, r-package, spatial, point]
---

House sales price and characteristics for a spatial hedonic regression, Baltimore, MD 1978. X,Y on Maryland grid, projection type unknown.

## Description du jeu de donnees

- Topic: immobilier / prix des logements
- Observation unit: logement, transaction immobiliere ou zone residentielle selon la documentation source
- Observed population: marche immobilier documente par le package source
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: House sales price and characteristics for a spatial hedonic regression, Baltimore, MD 1978. X,Y on Maryland grid, projection type unknown.
- Description source: package R `spData`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `PRICE`
- Candidate Y typology: continuous
- Candidate X variables: `NROOM`, `DWELL`, `NBATH`, `PATIO`, `FIREPL`, `AC`, `BMENT`, `NSTOR`, `GAR`, `AGE`, `CITCOU`, `LOTSZ`, `SQFT`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PRICE` | `numeric` | continuous | [3.5, 165] | 0% |


> Selection Y/X (claude-sonnet-4-6) : PRICE (prix de vente des logements) est la variable réponse naturelle pour une régression hédonique spatiale. Toutes les autres colonnes descriptives du logement (superficie, nombre de pièces, équipements, âge, type) sont des covariables explicatives classiques du prix ; STATION est un identifiant de station/observation et est ignoré.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `NROOM` | `numeric` | continuous | 0% |
| `DWELL` | `numeric` | binary | 0% |
| `NBATH` | `numeric` | continuous | 0% |
| `PATIO` | `numeric` | binary | 0% |
| `FIREPL` | `numeric` | binary | 0% |
| `AC` | `numeric` | binary | 0% |
| `BMENT` | `numeric` | continuous | 0% |
| `NSTOR` | `numeric` | continuous | 0% |
| `GAR` | `numeric` | continuous | 0% |
| `AGE` | `numeric` | continuous | 0% |
| `CITCOU` | `numeric` | binary | 0% |
| `LOTSZ` | `numeric` | continuous | 0% |
| `SQFT` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: PRICE ~ NROOM + NBATH + PATIO + FIREPL + AC + GAR + AGE + LOTSZ + SQFT
- x_terms_pub: NROOM, NBATH, PATIO, FIREPL, AC, GAR, AGE, LOTSZ, SQFT
- y_term_pub: PRICE
- Reference publication: Dubin, Robin A. (1992). Spatial autocorrelation and neighborhood quality. Regional Science and Urban Economics 22(3), 433-452. NOTE (confiance moyenne) : formule hedonique standard reproduite par les packages derives de ce jeu de donnees (hspm/spregimes) ; texte original de Dubin non accessible (paywall) pour verifier exactement la liste de covariables/forme fonctionnelle (log vs niveau, inclusion DWELL/BMENT/NSTOR/CITCOU).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: PRICE ~ NROOM + NBATH + PATIO + FIREPL + AC + GAR + AGE + LOTSZ + SQFT
- x_terms_used: NROOM, NBATH, PATIO, FIREPL, AC, GAR, AGE, LOTSZ, SQFT
- y_term_used: PRICE

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "PRICE ~ NROOM + NBATH + PATIO + FIREPL + AC + GAR + AGE + LOTSZ + SQFT"
    response: "PRICE"
    predictors: ["NROOM, NBATH, PATIO, FIREPL, AC, GAR, AGE, LOTSZ, SQFT"]
    role: "simple_baseline"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Dubin, Robin A. (1992). Spatial autocorrelation and neighborhood quality. Regional Science and Urban Economics 22(3), 433-452. NOTE (confiance moyenne) : formule hedonique standard reproduite par les packages derives de ce jeu de donnees (hspm/spregimes) ; texte original de Dubin non accessible (paywall) pour verifier exactement la liste de covariables/forme fonctionnelle (log vs niveau, inclusion DWELL/BMENT/NSTOR/CITCOU)."
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

- Dataset ID: `R_spData_baltimore_baltimore`
- Dataset name: spData::baltimore
- Source family: r-package
- Source: package R `spData` (version 2.3.4)
- Source URL: https://CRAN.R-project.org/package=spData
- Dataset DOI: none
- Publication DOI: 10.1016/0166-0462(92)90038-3
- Year: 2017

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "PRICE ~ NROOM + NBATH + PATIO + FIREPL + AC + GAR + AGE + LOTSZ + SQFT"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Dubin, Robin A. (1992). Spatial autocorrelation and neighborhood quality. Regional Science and Urban Economics 22(3), 433-452. NOTE (confiance moyenne) : formule hedonique standard reproduite par les packages derives de ce jeu de donnees (hspm/spregimes) ; texte original de Dubin non accessible (paywall) pour verifier exactement la liste de covariables/forme fonctionnelle (log vs niveau, inclusion DWELL/BMENT/NSTOR/CITCOU)."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 211
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [860, 987.5], y [505.5, 581] (CRS unknown)
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
- Reproducibility: OK - source package et licence renseignes (CC0).

## Related Pages

- Source: package R `spData`
