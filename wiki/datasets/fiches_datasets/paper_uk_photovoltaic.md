---
title: paper_uk_photovoltaic
type: dataset
created: 2026-08-10
updated: 2026-08-10
sources:
  - data/final_datasets/sf/paper_uk_photovoltaic.rds
  - DataCite_2015_RegionalDistributionOfPhotovoltaic_10_1016_j_eneco_
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Regional distribution of photovoltaic deployment in the UK and its determinants: A spatial econometric approach" (DOI 10.1016/j.eneco.2015.08.003).

## Description du jeu de donnees

- Topic: energie / deploiement photovoltaique
- Observation unit: autorite locale (Local Authority District, UK)
- Observed population: installations PV domestiques (<10kW)
- Geographic context: a preciser depuis l'etendue spatiale (voir Bloc 5)
- Temporal context: none (cross-sectional)
- Source description: Regional distribution of photovoltaic deployment in the UK and its determinants: A spatial econometric approach
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1016/j.eneco.2015.08.003
- Dataset DOI: 10.17632/fthhmvgm6r.1
- Source URL: https://www.gov.uk/government/statistical-data-sets/monthly-central-feed-in-tariff-register-statistics
- Local raw dir: `data/raw/papers/DataCite_2015_RegionalDistributionOfPhotovoltaic_10_1016_j_eneco_/`
- Local sf output: `data/final_datasets/sf/paper_uk_photovoltaic.rds`

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `n_installations`, `total_capacity_kw`
- Candidate Y typology: continuous
- Candidate X variables: no additional covariates beyond coordinates/identifiers (raster or grid dataset)
- Candidate X count: 0
- Candidate X typology: unknown
- Coordinates (x, y — excluded from X candidates): none detected
- Identifier columns (excluded from X candidates): `LAD13CD`, `LAD13NM`
- Variables inspected: yes (auto — generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `n_installations` | `numeric` | continuous | [2, 8586] | 0% |
| `total_capacity_kw` | `numeric` | continuous | [4.2, 28145.06] | 0% |

> Selection Y/X (paper-loader/curated evidence) : Pour `uk_photovoltaic`, la ou les reponses `n_installations`, `total_capacity_kw` viennent du loader papier et/ou des preuves de l article `Regional distribution of photovoltaic deployment in the UK and its determinants: A spatial econometric approach`. Les covariables X retenues sont aucune covariable explicative. Les coordonnees (les coordonnees detectees), identifiants (`LAD13CD`, `LAD13NM`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : needs_preprocessing ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| -- | -- | aucun candidat | -- |

### Formule — niveau publication

- formula_pub: PV_uptake ~ rho*W*PV_uptake + X*beta + W*X*theta + u (Spatial Durbin Model, eq. 1) ; X = demande electrique, densite population, pollution, niveau education, type logement
- x_terms_pub: pending
- y_term_pub: n_installations
- Reference publication: Balta-Ozkan, Yildirim & Connor (2015), Energy Economics — famille de modeles econometriques spatiaux (SAR/SEM/SDM) sur le deploiement PV domestique par region NUTS3 en Grande-Bretagne ; le SDM est retenu par tests du multiplicateur de Lagrange.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-10). Balta-Ozkan, Yildirim & Connor (2015), Energy Economics — famille de modeles econometriques spatiaux (SAR/SEM/SDM) sur le deploiement PV domestique par region NUTS3 en Grande-Bretagne ; le SDM est retenu par tests du multiplicateur de Lagrange.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: n_installations
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-10). Balta-Ozkan, Yildirim & Connor (2015), Energy Economics — famille de modeles econometriques spatiaux (SAR/SEM/SDM) sur le deploiement PV domestique par region NUTS3 en Grande-Bretagne ; le SDM est retenu par tests du multiplicateur de Lagrange.

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

- Dataset ID: `paper_uk_photovoltaic`
- Dataset name: Data for: Regional distribution of photovoltaic deployment in the UK and its determinants: A spatial econometric approach
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Regional distribution of photovoltaic deployment in the UK and its determinants: A spatial econometric approach
- Paper DOI: 10.1016/j.eneco.2015.08.003
- Dataset DOI: 10.17632/fthhmvgm6r.1
- Source URL: https://www.gov.uk/government/statistical-data-sets/monthly-central-feed-in-tariff-register-statistics
- Year: unknown

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "PV_uptake ~ rho*W*PV_uptake + X*beta + W*X*theta + u (Spatial Durbin Model, eq. 1) ; X = demande electrique, densite population, pollution, niveau education, type logement"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Balta-Ozkan, Yildirim & Connor (2015), Energy Economics — famille de modeles econometriques spatiaux (SAR/SEM/SDM) sur le deploiement PV domestique par region NUTS3 en Grande-Bretagne ; le SDM est retenu par tests du multiplicateur de Lagrange."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "needs_preprocessing"
  benchmark_task: "regression_spatial_econometrics"
  package_include: "no"
  has_local_rds: true
  missing_items: "reconcilier les NUTS3 du papier avec le LAD extrait et joindre les covariables du SDM"
  reason: "Le papier modelise 134 regions NUTS3, alors que l'extraction actuelle contient 380 LAD et pas les covariables du papier."
```

- Decision: needs_preprocessing
- Manque principal: reconcilier les NUTS3 du papier avec le LAD extrait et joindre les covariables du SDM
- Raison: Le papier modelise 134 regions NUTS3, alors que l'extraction actuelle contient 380 LAD et pas les covariables du papier.

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 380
- k variables: 6
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 — Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 27700
- CRS nom: OSGB36 / British National Grid
- Spatial extent: x [92015.5184782611, 646668.567307692], y [11094.25, 1151403.25]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`uk_photovoltaic` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `uk_photovoltaic` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: WARN - Y identifiee, mais aucune covariable X detectee (grille/raster sans covariable additionnelle).
- Formula: OK - formule publication renseignee (verifiee par lecture directe du papier).
- CRS: OK - CRS renseigne dans le Bloc 5 (27700).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`uk_photovoltaic` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Regional distribution of photovoltaic deployment in the UK and its determinants: A spatial econometric approach

