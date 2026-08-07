---
title: Python_geodatasets_geoda.hickory2
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.hickory2.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`hickory2`).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`hickory2`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `INDEX`, `PCTCSE`, `PCTGRO`, `PCTIME`, `EMP01`, `PAY01`
- Candidate Y typology: count, continuous
- Candidate X variables: `POP2001`, `EST98`, `EMP98`, `PAY98`, `EST01`, `MAN98`, `MAN98_12`, `MAN98_39`, `MAN01`, `MAN01_12`, `MAN01_39`, `OFF98`, `OFF98_12`, `OFF98_39`, `OFF01`, `OFF01_12`, `OFF01_39`, `INFO98`, `INFO98_12`, `INFO98_39`, `INFO01`, `INFO01_12`, `INFO01_39`, `NUMSEC`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `CBSA_CODE`, `ID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `INDEX` | `integer` | count | [3, 31] | 0% |
| `PCTCSE` | `numeric` | continuous | [-67.93, 16.65] | 0% |
| `PCTGRO` | `numeric` | continuous | [-64.43, 16.47] | 0% |
| `PCTIME` | `numeric` | continuous | [-2.67, 1.29] | 0% |
| `EMP01` | `integer` | count | [17, 31254] | 0% |
| `PAY01` | `integer` | count | [408, 901471] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables Y candidates sont les indicateurs synthétiques de dynamique économique locale (INDEX, PCTCSE=variation établissements, PCTGRO=croissance emploi, PCTIME, EMP01, PAY01) qui sont des mesures de résultats à expliquer. Les X candidates sont les counts sectoriels (manufacturing, office, info) par zone et période, la population, le nombre d'établissements et d'emplois de base (1998), et le nombre de secteurs (NUMSEC), qui sont des caractéristiques structurelles explicatives ; les colonnes US-level à variance nulle (MAN98US, etc.) sont ignorées car constantes et non informatives.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `POP2001` | `integer` | count | 0% |
| `EST98` | `integer` | count | 0% |
| `EMP98` | `integer` | count | 0% |
| `PAY98` | `integer` | count | 0% |
| `EST01` | `integer` | count | 0% |
| `MAN98` | `integer` | count | 0% |
| `MAN98_12` | `integer` | count | 0% |
| `MAN98_39` | `integer` | count | 0% |
| `MAN01` | `integer` | count | 0% |
| `MAN01_12` | `integer` | count | 0% |
| `MAN01_39` | `integer` | count | 0% |
| `OFF98` | `integer` | count | 0% |
| `OFF98_12` | `integer` | count | 0% |
| `OFF98_39` | `integer` | count | 0% |
| `OFF01` | `integer` | count | 0% |
| `OFF01_12` | `integer` | count | 0% |
| `OFF01_39` | `integer` | count | 0% |
| `INFO98` | `integer` | count | 0% |
| `INFO98_12` | `integer` | count | 0% |
| `INFO98_39` | `integer` | count | 0% |
| `INFO01` | `integer` | count | 0% |
| `INFO01_12` | `integer` | count | 0% |
| `INFO01_39` | `integer` | count | 0% |
| `NUMSEC` | `integer` | count | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: pending

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d'estimation: formule candidate generee par le systeme
- Correspondance Python/R: aucune identifiee
- Note: Aucune formule publiee n'a ete confirmee; deux formules candidates ont ete produites par le systeme et la formule recommandee est reportee dans formula_used.
### Formule — niveau systeme

- formula_used: INDEX ~ POP2001 + EST98 + EMP98 + PAY98 + EST01 + MAN98 + MAN98_12 + MAN98_39
- x_terms_used: POP2001 + EST98 + EMP98 + PAY98 + EST01 + MAN98 + MAN98_12 + MAN98_39
- y_term_used: INDEX

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
    formula: "INDEX ~ POP2001 + EST98 + EMP98 + PAY98 + EST01 + MAN98 + MAN98_12 + MAN98_39"
    response: "INDEX"
    predictors: ["POP2001", "EST98", "EMP98", "PAY98", "EST01", "MAN98", "MAN98_12", "MAN98_39"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.hickory2`
- Dataset name: geodatasets::hickory2
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
  existing_model_found: false
  equation_text: INDEX ~ POP2001 + EST98 + EMP98 + PAY98 + EST01 + MAN98 + MAN98_12 + MAN98_39
  equation_family: regression_candidate
  model_family: spatial_regression_candidate
  source_type: generated_system_formula
  source_ref: data/manifests/datasets/proposed_formula_used_audit.csv
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 29
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-81.9791, -80.9651], y [35.4773, 36.0738] (EPSG:4326)
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

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: CANDIDATE - formule systeme proposee, sans source publication confirmee.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`
