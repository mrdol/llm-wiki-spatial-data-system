---
title: Python_libpysal_Ohiolung
type: dataset
created: 2026-07-10
updated: 2026-07-10
sources:
  - data/final_datasets/sf/Python_libpysal_Ohiolung.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `libpysal` (`Ohiolung`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `LM68`, `LF68`, `LM78`, `LF78`, `LM88`, `LF88`
- Candidate Y typology: count
- Candidate X variables: `AREA`, `POPM68`, `POPF68`, `POPM78`, `POPF78`, `POPM88`, `POPF88`, `LMW68`, `LMB68`, `LFW68`, `LFB68`, `LMW78`, `LMB78`, `LFW78`, `LFB78`, `LMW88`, `LMB88`, `LFW88`, `LFB88`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `RECORD_ID`, `COUNTYID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `LM68` | `integer` | count | [1, 522] | 0% |
| `LF68` | `integer` | count | [0, 111] | 0% |
| `LM78` | `integer` | count | [3, 580] | 0% |
| `LF78` | `integer` | count | [0, 201] | 0% |
| `LM88` | `integer` | count | [2, 641] | 0% |
| `LF88` | `integer` | count | [1, 352] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Ce dataset porte sur la mortalité pulmonaire (lung cancer) par comté de l'Ohio : les colonnes LM*/LF* représentent les décès (males/females) pour 1968, 1978, 1988 et sont les cibles naturelles, tandis que les populations de référence (POPM*, POPF*, POPMW*, etc.), la superficie (AREA) et les sous-groupes de décès par race/sexe constituent des covariables explicatives pertinentes. FIPSNO, NAME et PERIMETER sont ignorés car purement administratifs ou géométriques.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `AREA` | `integer` | count | 0% |
| `POPM68` | `integer` | count | 0% |
| `POPF68` | `integer` | count | 0% |
| `POPM78` | `integer` | count | 0% |
| `POPF78` | `integer` | count | 0% |
| `POPM88` | `integer` | count | 0% |
| `POPF88` | `integer` | count | 0% |
| `LMW68` | `integer` | count | 0% |
| `LMB68` | `integer` | count | 0% |
| `LFW68` | `integer` | count | 0% |
| `LFB68` | `integer` | count | 0% |
| `LMW78` | `integer` | count | 0% |
| `LMB78` | `integer` | count | 0% |
| `LFW78` | `integer` | count | 0% |
| `LFB78` | `integer` | count | 0% |
| `LMW88` | `integer` | count | 0% |
| `LMB88` | `integer` | count | 0% |
| `LFW88` | `integer` | count | 0% |
| `LFB88` | `integer` | count | 0% |


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
- Note: Formule systeme proposee automatiquement pour benchmark spatial ; ne pas confondre avec une formule publiee.
### Formule — niveau systeme

- formula_used: LM68 ~ AREA + POPM68 + POPF68 + POPM78 + POPF78 + POPM88 + POPF88 + LMW68
- x_terms_used: AREA + POPM68 + POPF68 + POPM78 + POPF78 + POPM88 + POPF88 + LMW68
- y_term_used: LM68


### Formules candidates — niveau systeme

- formula_candidate_1: LM68 ~ AREA + POPM68 + POPF68 + POPM78 + POPF78 + POPM88 + POPF88 + LMW68
- formula_candidate_1_role: recommended_default
- formula_candidate_2: LM68 ~ AREA + POPM68 + POPF68 + POPM78
- formula_candidate_2_role: alternative_specification
- recommended_formula: formula_candidate_1
- selection_status: generated_system_formula
- selection_reason: candidate_1 conserve la specification systeme actuelle pour comparer les estimateurs; candidate_2 est une variante parcimonieuse utile si colinearite, temps de calcul ou petits folds posent probleme.
- preprocessing_note: Les estimateurs comme xgboost, random_forest, gamboost et spboost peuvent reduire l'effet de certaines variables via leur mecanisme d'apprentissage ou de regularisation ; les modeles lineaires/spatiaux parametriques restent plus sensibles au choix explicite de X.

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_libpysal_Ohiolung`
- Dataset name: libpysal::Ohiolung
- Source family: python-package
- Source: package Python `libpysal`
- Source URL: https://pypi.org/project/libpysal/
- Dataset DOI: none
- Publication DOI: pending
- Year: 2017

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "null"
  equation_family: unknown
  model_family: "n/a"
  source_type: unknown
  source_ref: "null"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 88
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-85.4895, -85.4895], y [0.0003, 0.0004] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32616 (UTM Zone 16N (EPSG:32616)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/libpysal/
- License open: yes
- Reproducibility status: available via package Python `libpysal`
- Code available: yes (package examples and vignettes)
- Repository: python-package

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `libpysal`
