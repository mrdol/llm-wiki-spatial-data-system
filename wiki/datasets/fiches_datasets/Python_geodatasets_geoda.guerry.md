---
title: Python_geodatasets_geoda.guerry
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.guerry.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`guerry`).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`guerry`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Crm_prs`, `Crm_prp`, `Litercy`, `Suicids`, `Lottery`, `Infants`
- Candidate Y typology: continuous
- Candidate X variables: `Wealth`, `Commerc`, `Clergy`, `Donatns`, `Prsttts`, `Distanc`, `Area`, `Pop1831`, `Desertn`, `Instrct`, `MainCty`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Crm_prs` | `numeric` | continuous | [5883, 37014] | 0% |
| `Crm_prp` | `numeric` | continuous | [1368, 20235] | 0% |
| `Litercy` | `numeric` | continuous | [12, 74] | 0% |
| `Suicids` | `numeric` | continuous | [3460, 163241] | 0% |
| `Lottery` | `numeric` | continuous | [1, 86] | 0% |
| `Infants` | `numeric` | continuous | [2660, 62486] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables Y candidates sont des outcomes sociaux mesurés (criminalité, suicide, illettrisme, infanticide, jeux de loterie) typiquement modélisés dans la littérature Guerry comme variables réponse. Les variables X candidates sont des indicateurs structurels, économiques ou démographiques (richesse, commerce, clergé, dons, prostitution, distance, superficie, population, désertion, instruction, type de ville) servant de covariables explicatives ; les colonnes purement administratives ou géographiques (dept, Region, Dprtmnt) et les doublons en rang (Crm_prn, Infntcd, Dntn_cl) sont ignorés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Wealth` | `numeric` | continuous | 0% |
| `Commerc` | `numeric` | continuous | 0% |
| `Clergy` | `numeric` | continuous | 0% |
| `Donatns` | `numeric` | continuous | 0% |
| `Prsttts` | `numeric` | continuous | 0% |
| `Distanc` | `numeric` | continuous | 0% |
| `Area` | `numeric` | continuous | 0% |
| `Pop1831` | `numeric` | continuous | 0% |
| `Desertn` | `numeric` | continuous | 0% |
| `Instrct` | `numeric` | continuous | 0% |
| `MainCty` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: pending

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: Crm_prs ~ Region + Litercy + Donatns + Infants + Suicids
- x_terms_used: Region + Litercy + Donatns + Infants + Suicids
- y_term_used: Crm_prs

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
    formula: "Crm_prs ~ Region + Litercy + Donatns + Infants + Suicids"
    response: "Crm_prs"
    predictors: ["Region", "Litercy", "Donatns", "Infants", "Suicids"]
    role: "paper_main_specification"
    source_type: "published_or_manual_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
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

- Dataset ID: `Python_geodatasets_geoda.guerry`
- Dataset name: geodatasets::guerry
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
  equation_text: Crm_prs ~ Region + Litercy + Donatns + Infants + Suicids
  equation_family: regression
  model_family: published_or_manual_regression
  source_type: published_or_manual_formula
  source_ref: data/manifests/datasets/proposed_formula_used_audit.csv
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 85
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-3.8198, 7.5352], y [42.6247, 50.5342] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32631 (UTM Zone 31N (EPSG:32631)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/geodatasets/
- License open: yes
- Reproducibility status: available via package Python `geodatasets`
- Code available: yes (package examples and vignettes)
- Repository: python-package

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication ou formule manuelle renseignee.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`
