---
title: Python_geodatasets_geoda.tampa1
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.tampa1.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`tampa1`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `HH_INC`, `HSG_VAL`, `POV_TOT`
- Candidate Y typology: count
- Candidate X variables: `TOT_POP`, `POP_16`, `POP_65`, `WHITE_`, `BLACK_`, `ASIAN_`, `HISP_`, `MULTI_RA`, `MALES`, `FEMALES`, `MALE1664`, `FEM1664`, `EMPL16`, `EMP_AWAY`, `EMP_HOME`, `EMP_29`, `EMP_30`, `EMP_MALE`, `EMP_FEM`, `OCC_MAN`, `OCC_OFF1`, `OCC_INFO`, `POV_POP`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `POLYID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `HH_INC` | `integer` | count | [8494, 96594] | 0% |
| `HSG_VAL` | `integer` | count | [0, 294200] | 0% |
| `POV_TOT` | `integer` | count | [0, 2721] | 0% |


> Selection Y/X (claude-sonnet-4-6) : HH_INC (revenu médian des ménages), HSG_VAL (valeur médiane du logement) et POV_TOT (nombre de personnes en situation de pauvreté) sont des cibles socio-économiques classiques en spatial ML. Les variables démographiques (population totale, structure par âge, race/ethnie, sexe) et d'emploi/occupation constituent des covariables explicatives naturelles pour ces outcomes ; FIPS et MSA sont des identifiants administratifs ignorés.

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
| `MULTI_RA` | `integer` | count | 0% |
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

- formula_pub: HSG_VAL~TOT_POP+POV_POP+WHITE_+BLACK_+EMPL16+OCC_MAN+OCC_OFF1
- x_terms_pub: TOT_POP+POV_POP+WHITE_+BLACK_+EMPL16+OCC_MAN+OCC_OFF1
- y_term_pub: HSG_VAL
- Reference publication: Analogie structurelle avec spdata.boston (hedonique census-tract) (banque interne, mission 2026-07)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: candidat par analogie -- non verifie
- Niveau de preuve: analogie
- Methode d'estimation: OLS
- Correspondance Python/R: aucune identifiee
- Note: CANDIDAT PAR ANALOGIE -- non verifie. Schema identique a 8 autres jeux 'small area' GeoDa (memes colonnes TOT_POP/POV_POP/WHITE/BLACK/EMPL16/OCC_MAN/OCC_OFF1). Analogie structurelle avec spdata.boston (bon candidat, log(CMEDV)~CRIM+...+B+LSTAT : valeur immobiliere/socioeconomique de secteur de recensement expliquee par la composition raciale et socioeconomique) : meme role de variables (Y = indicateur de valeur/richesse au niveau tract, X = composition demographique/raciale/emploi), domaine substantiellement identique (hedonique/socioeconomique a l'echelle du census tract).

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.tampa1`
- Dataset name: geodatasets::tampa1
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
  equation_text: "HSG_VAL~TOT_POP+POV_POP+WHITE_+BLACK_+EMPL16+OCC_MAN+OCC_OFF1"
  equation_family: linear
  model_family: "OLS"
  source_type: unknown
  source_ref: "Analogie structurelle avec spdata.boston (hedonique census-tract) (banque interne, mission 2026-07)"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 547
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-82.8494, -82.0803], y [27.6622, 28.619] (EPSG:4326)
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

Aucune anomalie detectee.

## Related Pages

- Source: package Python `geodatasets`
