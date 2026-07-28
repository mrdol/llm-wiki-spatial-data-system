---
title: Python_geodatasets_geoda.milwaukee1
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.milwaukee1.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`milwaukee1`).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`milwaukee1`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `HH_INC`, `HSG_VAL`, `POV_TOT`, `PCTBLACK`
- Candidate Y typology: count, rate
- Candidate X variables: `TOT_POP`, `POP_16`, `POP_65`, `WHITE_`, `BLACK_`, `ASIAN_`, `HISP_`, `MALES`, `FEMALES`, `MALE1664`, `FEM1664`, `EMPL16`, `EMP_AWAY`, `EMP_HOME`, `EMP_29`, `EMP_30`, `EMP_MALE`, `EMP_FEM`, `OCC_MAN`, `OCC_OFF1`, `OCC_INFO`, `POV_POP`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `polyid`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `HH_INC` | `integer` | count | [0, 161292] | 0% |
| `HSG_VAL` | `integer` | count | [0, 517300] | 0% |
| `POV_TOT` | `integer` | count | [0, 1957] | 0% |
| `PCTBLACK` | `numeric` | rate | [0, 0.9938] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables HH_INC (revenu médian des ménages), HSG_VAL (valeur des logements), POV_TOT (population en pauvreté) et PCTBLACK (taux de population noire) sont des indicateurs socio-économiques ou démographiques synthétiques classiquement modélisés comme variables réponse en spatial ML. Les variables de population, composition démographique, emploi et occupation constituent des covariables explicatives naturelles ; BLACK1 et BLACK_R sont exclus car redondants avec BLACK_ et PCTBLACK, et PCTBLCK est exclu car doublon exact de PCTBLACK.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `TOT_POP` | `integer` | count | 0% |
| `POP_16` | `integer` | count | 0% |
| `POP_65` | `integer` | count | 0% |
| `WHITE_` | `integer` | count | 0% |
| `BLACK_` | `integer` | count | 0% |
| `ASIAN_` | `integer` | count | 0% |
| `HISP_` | `integer` | count | 0% |
| `MALES` | `integer` | count | 0% |
| `FEMALES` | `integer` | count | 0% |
| `MALE1664` | `integer` | count | 0% |
| `FEM1664` | `integer` | count | 0% |
| `EMPL16` | `integer` | count | 0% |
| `EMP_AWAY` | `integer` | count | 0% |
| `EMP_HOME` | `integer` | count | 0% |
| `EMP_29` | `integer` | count | 0% |
| `EMP_30` | `integer` | count | 0% |
| `EMP_MALE` | `integer` | count | 0% |
| `EMP_FEM` | `integer` | count | 0% |
| `OCC_MAN` | `integer` | count | 0% |
| `OCC_OFF1` | `integer` | count | 0% |
| `OCC_INFO` | `integer` | count | 0% |
| `POV_POP` | `integer` | count | 0% |


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

- formula_used: HH_INC ~ TOT_POP + POP_16 + POP_65 + WHITE_ + BLACK_ + ASIAN_ + HISP_ + MALES
- x_terms_used: TOT_POP + POP_16 + POP_65 + WHITE_ + BLACK_ + ASIAN_ + HISP_ + MALES
- y_term_used: HH_INC

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.milwaukee1`
- Dataset name: geodatasets::milwaukee1
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
  equation_text: HH_INC ~ TOT_POP + POP_16 + POP_65 + WHITE_ + BLACK_ + ASIAN_ + HISP_ + MALES
  equation_family: regression_candidate
  model_family: spatial_regression_candidate
  source_type: generated_system_formula
  source_ref: data/manifests/datasets/proposed_formula_used_audit.csv
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 417
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-88.5194, -87.8466], y [42.8573, 43.5141] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32616 (UTM Zone 16N (EPSG:32616)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

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
