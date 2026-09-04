---
title: Python_geodatasets_geoda.sids_1974
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.sids_1974.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`sids_1974`).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`sids_1974`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `sids_deaths`, `sids_rate`
- Candidate Y typology: continuous
- Candidate X variables: `births`, `nonwhite_births`, `nonwhite_birth_rate`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `CRESS_ID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `sids_deaths` | `numeric` | continuous | [0, 44] | 0% |
| `sids_rate` | `numeric` | continuous | [0, 9.5541] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables cibles naturelles sont le nombre et le taux de morts subites du nourrisson (SIDS), qui constituent la variable épidémiologique d'intérêt à expliquer. Les covariables explicatives sont le nombre total de naissances (exposition), le nombre de naissances non-blanches et le taux correspondant, qui sont des facteurs démographiques classiquement associés au risque de SIDS dans la littérature. NAME, FIPS et FIPSNO sont des identifiants/codes administratifs ignorés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `births` | `numeric` | continuous | 0% |
| `nonwhite_births` | `numeric` | continuous | 0% |
| `nonwhite_birth_rate` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: sids_rate ~ nonwhite_birth_rate (referencee dans catalogue)
- x_terms_pub: nonwhite_birth_rate
- y_term_pub: sids_rate
- Reference publication: Cressie, N. (1991) Statistics for Spatial Data. New York: Wiley, pp. 386-389. 'Much of the variance of the transformed SIDS rate for 1974-8 can be accounted for by the transformed non-white birth variable' (voir aussi Cressie & Read 1985, Cressie & Chan 1989). sids_rate et nonwhite_birth_rate (SIDR/NWR) sont deja precalcules dans le dataset source (geoda.sids2) ; verifie sids_rate = sids_deaths/births*1000 exactement. Decoupe le 2026-08-15 en 2 fiches par periode (1974-78, 1979-84) plutot qu'un seul dataset -- politique de fractionnement.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: sids_rate ~ nonwhite_birth_rate
- x_terms_used: nonwhite_birth_rate
- y_term_used: sids_rate

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "sids_rate ~ nonwhite_birth_rate"
    response: "sids_rate"
    predictors: ["nonwhite_birth_rate"]
    role: "simple_baseline"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Cressie, N. (1991) Statistics for Spatial Data. New York: Wiley, pp. 386-389. 'Much of the variance of the transformed SIDS rate for 1974-8 can be accounted for by the transformed non-white birth variable' (voir aussi Cressie & Read 1985, Cressie & Chan 1989). sids_rate et nonwhite_birth_rate (SIDR/NWR) sont deja precalcules dans le dataset source (geoda.sids2) ; verifie sids_rate = sids_deaths/births*1000 exactement. Decoupe le 2026-08-15 en 2 fiches par periode (1974-78, 1979-84) plutot qu'un seul dataset -- politique de fractionnement."
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

- Dataset ID: `Python_geodatasets_geoda.sids_1974`
- Dataset name: geodatasets::sids_1974
- Source family: python-package
- Source: package Python `geodatasets`
- Source URL: https://pypi.org/project/geodatasets/
- Dataset DOI: none
- Publication DOI: pending
- Year: 2023

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "sids_rate ~ nonwhite_birth_rate"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Cressie, N. (1991) Statistics for Spatial Data. New York: Wiley, pp. 386-389. 'Much of the variance of the transformed SIDS rate for 1974-8 can be accounted for by the transformed non-white birth variable' (voir aussi Cressie & Read 1985, Cressie & Chan 1989). sids_rate et nonwhite_birth_rate (SIDR/NWR) sont deja precalcules dans le dataset source (geoda.sids2) ; verifie sids_rate = sids_deaths/births*1000 exactement. Decoupe le 2026-08-15 en 2 fiches par periode (1974-78, 1979-84) plutot qu'un seul dataset -- politique de fractionnement."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 100
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-84.0558, -75.8728], y [34.0966, 36.474] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32617 (UTM Zone 17N (EPSG:32617)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/geodatasets/
- License open: yes
- Reproducibility status: available via package Python `geodatasets`
- Code available: yes (package examples and vignettes)
- Repository: python-package

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
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`
