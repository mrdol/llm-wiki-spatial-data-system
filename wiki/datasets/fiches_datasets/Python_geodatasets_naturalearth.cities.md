---
title: Python_geodatasets_naturalearth.cities
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/Python_geodatasets_naturalearth.cities.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`cities`).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`cities`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `pop_max`, `pop_min`, `megacity`, `worldcity`
- Candidate Y typology: count, binary
- Candidate X variables: `scalerank`, `natscale`, `labelrank`, `adm0cap`, `capalt`, `rank_max`, `rank_min`, `min_zoom`, `pop_other`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `latitude`, `longitude`, `X`, `Y`
- Identifier columns (excluded from X candidates): `ne_id`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `pop_max` | `integer` | count | [500, 35676000] | 0% |
| `pop_min` | `integer` | count | [200, 14608512] | 0% |
| `megacity` | `integer` | binary | {0, 1} | 0% |
| `worldcity` | `integer` | binary | {0, 1} | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables de population (pop_max, pop_min) et les indicateurs de statut urbain (megacity, worldcity) sont des cibles naturelles pour modéliser l'importance ou la taille des villes. Les variables de rang, d'échelle cartographique, de statut de capitale et de population complémentaire servent de covariables explicatives ; les colonnes de noms, codes pays/région et libellés géographiques sont ignorées car purement administratives.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `scalerank` | `integer` | count | 0% |
| `natscale` | `integer` | count | 0% |
| `labelrank` | `integer` | count | 0% |
| `adm0cap` | `integer` | binary | 0% |
| `capalt` | `integer` | binary | 0% |
| `rank_max` | `integer` | count | 0% |
| `rank_min` | `integer` | count | 0% |
| `min_zoom` | `numeric` | continuous | 0% |
| `pop_other` | `integer` | count | 0% |


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

- formula_used: pop_max ~ scalerank + natscale + labelrank + adm0cap + capalt + rank_max + rank_min + min_zoom
- x_terms_used: scalerank + natscale + labelrank + adm0cap + capalt + rank_max + rank_min + min_zoom
- y_term_used: pop_max

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_naturalearth.cities`
- Dataset name: geodatasets::cities
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
  equation_text: pop_max ~ scalerank + natscale + labelrank + adm0cap + capalt + rank_max + rank_min + min_zoom
  equation_family: regression_candidate
  model_family: spatial_regression_candidate
  source_type: generated_system_formula
  source_ref: data/manifests/datasets/proposed_formula_used_audit.csv
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 243
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-175.2206, 179.2166], y [-41.2921, 64.1435] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: pending — multi-zones (span=354.4deg) -- projection nationale recommandee

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
- Missing values: WARN - variables avec NA > 20% : namepar (NA=93.8%), namealt (NA=82.3%), capin (NA=86.4%), note (NA=99.2%), meganame (NA=40.3%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`
