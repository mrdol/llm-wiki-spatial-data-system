---
title: Python_geodatasets_geoda.health
type: dataset
created: 2026-06-30
updated: 2026-07-02
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

- formula_pub: ratio~tractmhir+Diversity+Whitealon+BlackorA
- x_terms_pub: tractmhir+Diversity+Whitealon+BlackorA
- y_term_pub: ratio
- Reference publication: Analogie structurelle avec geoda.us_sdoh (SDOH) (banque interne, mission 2026-07)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: candidat par analogie -- non verifie
- Niveau de preuve: analogie
- Methode d'estimation: OLS
- Correspondance Python/R: aucune identifiee
- Note: CANDIDAT PAR ANALOGIE -- non verifie. Analogie structurelle avec geoda.us_sdoh (bon candidat, YPLL~Advantage+Mobility+Opportunity+MICA+Violent_crime) : indicateur de sante publique au niveau secteur explique par des determinants sociaux (pauvrete, education, chomage, revenu), domaine substantiellement identique (sante publique et determinants sociaux). Confiance plus faible : semantique exacte de 'ratio' et des variables le_agg_q*/le_racea_* (esperance de vie par quartile/race) reste ambigue sans documentation source -- a confirmer avant usage.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

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
  existing_model_found: true
  equation_text: "ratio~tractmhir+Diversity+Whitealon+BlackorA"
  equation_family: linear
  model_family: "OLS"
  source_type: unknown
  source_ref: "Analogie structurelle avec geoda.us_sdoh (SDOH) (banque interne, mission 2026-07)"
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

WARN: Variables avec NA > 20% : c, z, _, n, a, m, e,  , (, N, A, =, 4, 2, ., 6, %, )

## Related Pages

- Source: package Python `geodatasets`
