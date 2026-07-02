---
title: Python_geodatasets_geoda.airbnb
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.airbnb.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`airbnb`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `price_pp`, `rev_rating`, `response_r`, `accept_r`, `num_spots`
- Candidate Y typology: continuous, count
- Candidate X variables: `poverty`, `crowded`, `dependency`, `without_hs`, `unemployed`, `income_pc`, `harship_in`, `num_crimes`, `num_theft`, `population`, `room_type`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `AREAID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `price_pp` | `numeric` | continuous | [14, 176.3756] | 10.4% |
| `rev_rating` | `numeric` | continuous | [80, 100] | 13% |
| `response_r` | `numeric` | continuous | [68, 100] | 11.7% |
| `accept_r` | `numeric` | continuous | [0, 100] | 13% |
| `num_spots` | `integer` | count | [0, 741] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables Airbnb (prix par personne, note, taux de réponse/acceptation, nombre d'annonces) constituent des cibles naturelles pour modéliser l'offre et la qualité des logements. Les indicateurs socio-économiques (pauvreté, chômage, revenu, criminalité, population, etc.) sont des covariables explicatives classiques reflétant le contexte territorial. Les colonnes community, shape_area et shape_len sont purement administratives/géométriques et sont ignorées.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `poverty` | `numeric` | continuous | 0% |
| `crowded` | `numeric` | continuous | 0% |
| `dependency` | `numeric` | continuous | 0% |
| `without_hs` | `numeric` | continuous | 0% |
| `unemployed` | `numeric` | continuous | 0% |
| `income_pc` | `integer` | count | 0% |
| `harship_in` | `integer` | count | 0% |
| `num_crimes` | `integer` | count | 0% |
| `num_theft` | `integer` | count | 0% |
| `population` | `integer` | count | 0% |
| `room_type` | `numeric` | continuous | 10.4% |


### Formule — niveau publication

- formula_pub: price_pp~poverty+crowded+without_hs+unemployed+income_pc+num_crimes+room_type
- x_terms_pub: poverty+crowded+without_hs+unemployed+income_pc+num_crimes+room_type
- y_term_pub: price_pp
- Reference publication: Analogie structurelle avec libpysal.Baltimore / spdata.boston (hedonique) (banque interne, mission 2026-07)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: candidat par analogie -- non verifie
- Niveau de preuve: analogie
- Methode d'estimation: OLS
- Correspondance Python/R: aucune identifiee
- Note: CANDIDAT PAR ANALOGIE -- non verifie. price_pp est un prix explique par la composition socioeconomique du secteur (pauvrete, criminalite, niveau d'etudes, revenu) -- meme structure hedonique que Baltimore/Boston (prix ~ caracteristiques + composition socioeconomique du voisinage), domaine substantiellement comparable.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.airbnb`
- Dataset name: geodatasets::airbnb
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
  equation_text: "price_pp~poverty+crowded+without_hs+unemployed+income_pc+num_crimes+room_type"
  equation_family: linear
  model_family: "OLS"
  source_type: unknown
  source_ref: "Analogie structurelle avec libpysal.Baltimore / spdata.boston (hedonique) (banque interne, mission 2026-07)"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 77
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-87.9047, -87.535], y [41.6655, 42.0105] (EPSG:4326)
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

Aucune anomalie detectee.

## Related Pages

- Source: package Python `geodatasets`
