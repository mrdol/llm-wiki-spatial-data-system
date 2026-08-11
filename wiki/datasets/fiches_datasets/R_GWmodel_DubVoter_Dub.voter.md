---
title: R_GWmodel_DubVoter_Dub.voter
type: dataset
created: 2026-08-11
updated: 2026-08-11
sources:
  - data/final_datasets/sf/R_GWmodel_DubVoter_Dub.voter.rds
tags: [dataset, r-package, spatial, point]
---

Dataset spatial issu du package R `GWmodel` (`DubVoter`).

## Description du jeu de donnees

- Topic: elections et comportement electoral
- Observation unit: circonscription, bureau de vote ou unite administrative
- Observed population: resultats electoraux ou population votante
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package R `GWmodel` (`DubVoter`).
- Description source: package R `GWmodel`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `GenEl2004`
- Candidate Y typology: continuous
- Candidate X variables: `DiffAdd`, `LARent`, `SC1`, `Unempl`, `LowEduc`, `Age18_24`, `Age25_44`, `Age45_64`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `DED_ID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `GenEl2004` | `numeric` | continuous | [27.9846, 72.9142] | 0% |


> Selection Y/X (claude-sonnet-4-6) : GenEl2004 représente le taux de participation (ou résultat) aux élections générales de 2004, variable de sortie typique des études de comportement électoral spatial. Les autres colonnes (mobilité résidentielle, location sociale, statut socio-économique, chômage, faible niveau d'éducation, tranches d'âge) sont des covariables socio-démographiques classiquement utilisées pour expliquer les variations spatiales du vote.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `DiffAdd` | `numeric` | continuous | 0% |
| `LARent` | `numeric` | continuous | 0% |
| `SC1` | `numeric` | continuous | 0% |
| `Unempl` | `numeric` | continuous | 0% |
| `LowEduc` | `numeric` | continuous | 0% |
| `Age18_24` | `numeric` | continuous | 0% |
| `Age25_44` | `numeric` | continuous | 0% |
| `Age45_64` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: GenEl2004~DiffAdd+LARent+SC1+Unempl+LowEduc+Age18_24+Age25_44+Age45_64
- x_terms_pub: DiffAdd, LARent, SC1, Unempl, LowEduc, Age18_24, Age25_44, Age45_64
- y_term_pub: GenEl2004
- Reference publication: Kavanagh A (2006) Turnout or turned off? Electoral participation in Dublin in the early 21st Century. Journal of Irish Urban Studies, 3(2):1-24

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: GenEl2004~DiffAdd+LARent+SC1+Unempl+LowEduc+Age18_24+Age25_44+Age45_64
- x_terms_used: DiffAdd, LARent, SC1, Unempl, LowEduc, Age18_24, Age25_44, Age45_64
- y_term_used: GenEl2004

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "GenEl2004~DiffAdd+LARent+SC1+Unempl+LowEduc+Age18_24+Age25_44+Age45_64"
    response: "GenEl2004"
    predictors: ["DiffAdd, LARent, SC1, Unempl, LowEduc, Age18_24, Age25_44, Age45_64"]
    role: "simple_baseline"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Kavanagh A (2006) Turnout or turned off? Electoral participation in Dublin in the early 21st Century. Journal of Irish Urban Studies, 3(2):1-24"
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

- Dataset ID: `R_GWmodel_DubVoter_Dub.voter`
- Dataset name: GWmodel::DubVoter
- Source family: r-package
- Source: package R `GWmodel`
- Source URL: https://CRAN.R-project.org/package=GWmodel
- Dataset DOI: none
- Publication DOI: pending
- Year: 2013

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "GenEl2004~DiffAdd+LARent+SC1+Unempl+LowEduc+Age18_24+Age25_44+Age45_64"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Kavanagh A (2006) Turnout or turned off? Electoral participation in Dublin in the early 21st Century. Journal of Irish Urban Studies, 3(2):1-24"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 322
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [300888.224, 328236.4395], y [220662.3518, 263404.7994] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://CRAN.R-project.org/package=GWmodel
- License open: yes
- Reproducibility status: available via package R `GWmodel`
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

## Estimator eligibility

```yaml
estimator_eligibility:
  - estimator: ols
    basis: benchmark_use
    source_ref: "GWmodel DubVoter documentation and GWR examples."
  - estimator: gam_spatial
    basis: benchmark_use
    source_ref: "GWmodel DubVoter documentation and GWR examples."
  - estimator: mgwrsar_gwr
    basis: scientific_evidence
    source_ref: "GWmodel DubVoter documentation and GWR examples."
    notes: "Electoral dataset with projected coordinates, useful for geographically weighted regression."
  - estimator: mgwrsar_mgwr
    basis: benchmark_use
    source_ref: "GWmodel DubVoter documentation and GWR examples."
```


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

- Source: package R `GWmodel`
