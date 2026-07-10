---
title: Python_geodatasets_naturalearth.cities
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/Python_geodatasets_naturalearth.cities.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`cities`).

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

- formula_pub: none (aucune regression canonique documentee -- recherche manuelle exhaustive menee)
- x_terms_pub: none
- y_term_pub: none
- Reference publication: none (aucune source verifiable retrouvee)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: mauvais candidat
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: Jeu de points de villes (coordonnees + noms) sans variable de reponse — pas de regression par nature. [Revue Tache 4 (2026-07-02) : aucune analogie structurelle pertinente identifiee avec un bon candidat existant -- statut inchange plutot que forcer un rapprochement faible.] Raison : Les X disponibles (scalerank, labelrank, min_zoom) sont des metadonnees de rendu cartographique, pas des covariables substantielles.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

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
  equation_text: "null"
  equation_family: unknown
  model_family: "unknown"
  source_type: unknown
  source_ref: "null"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 243
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

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

WARN: Variables avec NA > 20% : namepar (NA=93.8%), namealt (NA=82.3%), capin (NA=86.4%), note (NA=99.2%), meganame (NA=40.3%)

## Related Pages

- Source: package Python `geodatasets`
