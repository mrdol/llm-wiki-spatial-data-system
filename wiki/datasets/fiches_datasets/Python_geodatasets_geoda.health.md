---
title: Python_geodatasets_geoda.health
type: dataset
created: 2026-07-10
updated: 2026-07-10
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.health.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`health`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `le_agg_q1`, `le_raceadj`, `le_agg_q2`, `le_racea_1`, `le_agg_q3`, `le_racea_2`, `le_agg_q4`, `le_racea_3`, `le_agg_q11`, `le_racea_4`, `le_agg_q21`, `le_racea_5`, `le_agg_q31`, `le_racea_6`, `le_agg_q41`, `le_racea_7`, `ratio`
- Candidate Y typology: continuous
- Candidate X variables: `statemhir`, `tractmhir`, `cty_pop200`, `cz_pop2000`, `Diversity`, `BlackorA`, `AmericanI`, `Asianalon`, `NativeHaw`, `TwoorMor`, `Hispanico`, `Whitealon`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `cartodb_id`, `state_id`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `le_agg_q1` | `numeric` | continuous | [0, 87.2398] | 0% |
| `le_raceadj` | `numeric` | continuous | [0, 87.1163] | 0% |
| `le_agg_q2` | `numeric` | continuous | [0, 88.6095] | 0% |
| `le_racea_1` | `numeric` | continuous | [0, 88.6159] | 0% |
| `le_agg_q3` | `numeric` | continuous | [0, 91.3513] | 0% |
| `le_racea_2` | `numeric` | continuous | [0, 91.4586] | 0% |
| `le_agg_q4` | `numeric` | continuous | [0, 93.9341] | 0% |
| `le_racea_3` | `numeric` | continuous | [0, 93.9072] | 0% |
| `le_agg_q11` | `numeric` | continuous | [0, 82.5628] | 0% |
| `le_racea_4` | `numeric` | continuous | [0, 82.5807] | 0% |
| `le_agg_q21` | `numeric` | continuous | [0, 86.6032] | 0% |
| `le_racea_5` | `numeric` | continuous | [0, 85.3178] | 0% |
| `le_agg_q31` | `numeric` | continuous | [0, 88.5365] | 0% |
| `le_racea_6` | `numeric` | continuous | [0, 88.6028] | 0% |
| `le_agg_q41` | `numeric` | continuous | [0, 89.2528] | 0% |
| `le_racea_7` | `numeric` | continuous | [0, 89.2977] | 0% |
| `ratio` | `numeric` | continuous | [0, 3.317] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables `le_*` (espérance de vie agrégée ou ajustée par race, par quartile de revenu et par sexe) et `ratio` (rapport revenu local/état) constituent des cibles naturelles pour modéliser les inégalités de santé spatiales. Les covariables retenues capturent le contexte socio-économique (revenus médians au niveau tract et état, populations), la composition raciale/ethnique et la diversité, qui sont des déterminants bien établis des outcomes de santé ; les colonnes administratives (codes FIPS, noms géographiques) et les effectifs de comptage (count_q*) ainsi que les écarts-types (sd_le_*) sont écartés car redondants ou non pertinents comme predicteurs directs.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `statemhir` | `numeric` | continuous | 0% |
| `tractmhir` | `numeric` | continuous | 0% |
| `cty_pop200` | `numeric` | continuous | 0% |
| `cz_pop2000` | `numeric` | continuous | 0% |
| `Diversity` | `numeric` | rate | 0% |
| `BlackorA` | `numeric` | continuous | 0% |
| `AmericanI` | `numeric` | continuous | 0% |
| `Asianalon` | `numeric` | continuous | 0% |
| `NativeHaw` | `numeric` | continuous | 0% |
| `TwoorMor` | `numeric` | continuous | 0% |
| `Hispanico` | `numeric` | continuous | 0% |
| `Whitealon` | `numeric` | continuous | 0% |


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

- formula_used: le_agg_q1 ~ statemhir + tractmhir + cty_pop200 + cz_pop2000 + Diversity + BlackorA + AmericanI + Asianalon
- x_terms_used: statemhir + tractmhir + cty_pop200 + cz_pop2000 + Diversity + BlackorA + AmericanI + Asianalon
- y_term_used: le_agg_q1


### Formules candidates — niveau systeme

- formula_candidate_1: le_agg_q1 ~ statemhir + tractmhir + cty_pop200 + cz_pop2000 + Diversity + BlackorA + AmericanI + Asianalon
- formula_candidate_1_role: recommended_default
- formula_candidate_2: le_agg_q1 ~ statemhir + tractmhir + cty_pop200 + cz_pop2000
- formula_candidate_2_role: alternative_specification
- recommended_formula: formula_candidate_1
- selection_status: generated_system_formula
- selection_reason: candidate_1 conserve la specification systeme actuelle pour comparer les estimateurs; candidate_2 est une variante parcimonieuse utile si colinearite, temps de calcul ou petits folds posent probleme.
- preprocessing_note: Les estimateurs comme xgboost, random_forest, gamboost et spboost peuvent reduire l'effet de certaines variables via leur mecanisme d'apprentissage ou de regularisation ; les modeles lineaires/spatiaux parametriques restent plus sensibles au choix explicite de X.

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.health`
- Dataset name: geodatasets::health
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
- N observations: 3984
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-124.7582, -67.2949], y [24.526, 48.987] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: pending — multi-zones (span=57.5deg) -- projection nationale recommandee

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
- Formula: PENDING - formule publication non encore etablie.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20% : cz_name (NA=42.6%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`
