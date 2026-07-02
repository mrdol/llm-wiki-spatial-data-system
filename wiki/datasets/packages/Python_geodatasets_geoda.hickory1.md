---
title: Python_geodatasets_geoda.hickory1
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.hickory1.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`hickory1`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `hh_inc`, `hsg_val`, `pov_tot`
- Candidate Y typology: count
- Candidate X variables: `tot_pop`, `pop_16`, `pop_65`, `white`, `black`, `asian`, `hisp`, `multi_ra`, `males`, `females`, `male1664`, `fem1664`, `empl16`, `emp_away`, `emp_home`, `emp_29`, `emp_30`, `emp_male`, `emp_fem`, `occ_man`, `occ_off1`, `occ_info`, `pov_pop`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `polyid`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `hh_inc` | `integer` | count | [24849, 57029] | 0% |
| `hsg_val` | `integer` | count | [57400, 201800] | 0% |
| `pov_tot` | `integer` | count | [17, 1280] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables hh_inc (revenu médian du ménage), hsg_val (valeur médiane des logements) et pov_tot (population en dessous du seuil de pauvreté) sont des cibles socio-économiques classiques en spatial ML. Les variables démographiques, raciales, d'emploi et d'occupation constituent des covariables explicatives naturelles de ces outcomes ; FIPS et msa sont des codes/identifiants administratifs ignorés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `tot_pop` | `integer` | count | 0% |
| `pop_16` | `integer` | count | 0% |
| `pop_65` | `integer` | count | 0% |
| `white` | `integer` | count | 0% |
| `black` | `integer` | count | 0% |
| `asian` | `integer` | count | 0% |
| `hisp` | `integer` | count | 0% |
| `multi_ra` | `integer` | count | 0% |
| `males` | `integer` | count | 0% |
| `females` | `integer` | count | 0% |
| `male1664` | `integer` | count | 0% |
| `fem1664` | `integer` | count | 0% |
| `empl16` | `integer` | count | 0% |
| `emp_away` | `integer` | count | 0% |
| `emp_home` | `integer` | count | 0% |
| `emp_29` | `integer` | count | 0% |
| `emp_30` | `integer` | count | 0% |
| `emp_male` | `integer` | count | 0% |
| `emp_fem` | `integer` | count | 0% |
| `occ_man` | `integer` | count | 0% |
| `occ_off1` | `integer` | count | 0% |
| `occ_info` | `integer` | count | 0% |
| `pov_pop` | `integer` | count | 0% |


### Formule — niveau publication

- formula_pub: hsg_val~tot_pop+pov_pop+white+black+empl16+occ_man+occ_off1
- x_terms_pub: tot_pop+pov_pop+white+black+empl16+occ_man+occ_off1
- y_term_pub: hsg_val
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

- Dataset ID: `Python_geodatasets_geoda.hickory1`
- Dataset name: geodatasets::hickory1
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
  equation_text: "hsg_val~tot_pop+pov_pop+white+black+empl16+occ_man+occ_off1"
  equation_family: linear
  model_family: "OLS"
  source_type: unknown
  source_ref: "Analogie structurelle avec spdata.boston (hedonique census-tract) (banque interne, mission 2026-07)"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 68
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-81.8463, -80.9726], y [35.5982, 36.0332] (EPSG:4326)
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
