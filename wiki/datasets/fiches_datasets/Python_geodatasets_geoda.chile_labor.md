---
title: Python_geodatasets_geoda.chile_labor
type: dataset
created: 2026-07-10
updated: 2026-07-10
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.chile_labor.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`chile_labor`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `lfs2__1982`, `lfs2__1992`, `lfs2__2002`
- Candidate Y typology: continuous
- Candidate X variables: `pop_1982`, `pop_1992`, `pop_2002`, `area_km2`, `sex1__1982`, `sex2__1982`, `sex1__1992`, `sex2__1992`, `sex1__2002`, `sex2__2002`, `lfs1__1982`, `lfs3__1982`, `lfs1__1992`, `lfs3__1992`, `lfs1__2002`, `lfs3__2002`, `age1__1982`, `age2__1982`, `age3__1982`, `age4__1982`, `age5__1982`, `age6__1982`, `age7__1982`, `age8__1982`, `age9__1982`, `age10_1982`, `age11_1982`, `age12_1982`, `age13_1982`, `age14_1982`, `age15_1982`, `age16_1982`, `age17_1982`, `age18_1982`, `age1__1992`, `age2__1992`, `age3__1992`, `age4__1992`, `age5__1992`, `age6__1992`, `age7__1992`, `age8__1992`, `age9__1992`, `age10_1992`, `age11_1992`, `age12_1992`, `age13_1992`, `age14_1992`, `age15_1992`, `age16_1992`, `age17_1992`, `age18_1992`, `age1__2002`, `age2__2002`, `age3__2002`, `age4__2002`, `age5__2002`, `age6__2002`, `age7__2002`, `age8__2002`, `age9__2002`, `age10_2002`, `age11_2002`, `age12_2002`, `age13_2002`, `age14_2002`, `age15_2002`, `age16_2002`, `age17_2002`, `age18_2002`, `is1_r_1982`, `is2_r_1982`, `is3_r_1982`, `is4_r_1982`, `is5_r_1982`, `is6_r_1982`, `is7_r_1982`, `is8_r_1982`, `is9_r_1982`, `is10__1982`, `is11__1982`, `is1_r_1992`, `is2_r_1992`, `is3_r_1992`, `is4_r_1992`, `is5_r_1992`, `is6_r_1992`, `is7_r_1992`, `is8_r_1992`, `is9_r_1992`, `is10__1992`, `is11__1992`, `is1_r_2002`, `is2_r_2002`, `is3_r_2002`, `is4_r_2002`, `is5_r_2002`, `is6_r_2002`, `is7_r_2002`, `is8_r_2002`, `is9_r_2002`, `is10__2002`, `is11__2002`, `oc0_r_1982`, `oc1_r_1982`, `oc2_r_1982`, `oc3_r_1982`, `oc4_r_1982`, `oc5_r_1982`, `oc6_r_1982`, `oc7_r_1982`, `oc8_r_1982`, `oc9_r_1982`, `oc0_r_1992`, `oc1_r_1992`, `oc2_r_1992`, `oc3_r_1992`, `oc4_r_1992`, `oc5_r_1992`, `oc6_r_1992`, `oc7_r_1992`, `oc8_r_1992`, `oc9_r_1992`, `oc0_r_2002`, `oc1_r_2002`, `oc2_r_2002`, `oc3_r_2002`, `oc4_r_2002`, `oc5_r_2002`, `oc6_r_2002`, `oc7_r_2002`, `oc8_r_2002`, `oc9_r_2002`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `code_flma`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `lfs2__1982` | `numeric` | continuous | [310, 312222] | 3.1% |
| `lfs2__1992` | `numeric` | continuous | [240, 136339] | 3.1% |
| `lfs2__2002` | `numeric` | continuous | [579, 310797] | 3.1% |


> Selection Y/X (claude-sonnet-4-6) : Les variables `lfs2__YYYY` (chômage, labor force status = unemployed) constituent les cibles naturelles d'un dataset sur le marché du travail chilien, représentant le volume de chômeurs par région et par année de recensement. Les covariables incluent la population totale, la superficie, la structure par âge et par sexe, la répartition sectorielle (is = industry sector) et par catégorie socioprofessionnelle (oc = occupation), ainsi que les actifs occupés (lfs1) et les inactifs (lfs3), qui sont tous des prédicteurs classiques du chômage ; `mun` et `dummy` sont ignorés car purement administratifs/indicateurs non informatifs.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `pop_1982` | `numeric` | continuous | 3.1% |
| `pop_1992` | `numeric` | continuous | 3.1% |
| `pop_2002` | `numeric` | continuous | 3.1% |
| `area_km2` | `numeric` | continuous | 3.1% |
| `sex1__1982` | `numeric` | continuous | 3.1% |
| `sex2__1982` | `numeric` | continuous | 3.1% |
| `sex1__1992` | `numeric` | continuous | 3.1% |
| `sex2__1992` | `numeric` | continuous | 3.1% |
| `sex1__2002` | `numeric` | continuous | 3.1% |
| `sex2__2002` | `numeric` | continuous | 3.1% |
| `lfs1__1982` | `numeric` | continuous | 3.1% |
| `lfs3__1982` | `numeric` | continuous | 3.1% |
| `lfs1__1992` | `numeric` | continuous | 3.1% |
| `lfs3__1992` | `numeric` | continuous | 3.1% |
| `lfs1__2002` | `numeric` | continuous | 3.1% |
| `lfs3__2002` | `numeric` | continuous | 3.1% |
| `age1__1982` | `numeric` | continuous | 3.1% |
| `age2__1982` | `numeric` | continuous | 3.1% |
| `age3__1982` | `numeric` | continuous | 3.1% |
| `age4__1982` | `numeric` | continuous | 3.1% |
| `age5__1982` | `numeric` | continuous | 3.1% |
| `age6__1982` | `numeric` | continuous | 3.1% |
| `age7__1982` | `numeric` | continuous | 3.1% |
| `age8__1982` | `numeric` | continuous | 3.1% |
| `age9__1982` | `numeric` | continuous | 3.1% |
| `age10_1982` | `numeric` | continuous | 3.1% |
| `age11_1982` | `numeric` | continuous | 3.1% |
| `age12_1982` | `numeric` | continuous | 3.1% |
| `age13_1982` | `numeric` | continuous | 3.1% |
| `age14_1982` | `numeric` | continuous | 3.1% |
| `age15_1982` | `numeric` | continuous | 3.1% |
| `age16_1982` | `numeric` | continuous | 3.1% |
| `age17_1982` | `numeric` | continuous | 3.1% |
| `age18_1982` | `numeric` | continuous | 3.1% |
| `age1__1992` | `numeric` | continuous | 3.1% |
| `age2__1992` | `numeric` | continuous | 3.1% |
| `age3__1992` | `numeric` | continuous | 3.1% |
| `age4__1992` | `numeric` | continuous | 3.1% |
| `age5__1992` | `numeric` | continuous | 3.1% |
| `age6__1992` | `numeric` | continuous | 3.1% |
| `age7__1992` | `numeric` | continuous | 3.1% |
| `age8__1992` | `numeric` | continuous | 3.1% |
| `age9__1992` | `numeric` | continuous | 3.1% |
| `age10_1992` | `numeric` | continuous | 3.1% |
| `age11_1992` | `numeric` | continuous | 3.1% |
| `age12_1992` | `numeric` | continuous | 3.1% |
| `age13_1992` | `numeric` | continuous | 3.1% |
| `age14_1992` | `numeric` | continuous | 3.1% |
| `age15_1992` | `numeric` | continuous | 3.1% |
| `age16_1992` | `numeric` | continuous | 3.1% |
| `age17_1992` | `numeric` | continuous | 3.1% |
| `age18_1992` | `numeric` | continuous | 3.1% |
| `age1__2002` | `numeric` | continuous | 3.1% |
| `age2__2002` | `numeric` | continuous | 3.1% |
| `age3__2002` | `numeric` | continuous | 3.1% |
| `age4__2002` | `numeric` | continuous | 3.1% |
| `age5__2002` | `numeric` | continuous | 3.1% |
| `age6__2002` | `numeric` | continuous | 3.1% |
| `age7__2002` | `numeric` | continuous | 3.1% |
| `age8__2002` | `numeric` | continuous | 3.1% |
| `age9__2002` | `numeric` | continuous | 3.1% |
| `age10_2002` | `numeric` | continuous | 3.1% |
| `age11_2002` | `numeric` | continuous | 3.1% |
| `age12_2002` | `numeric` | continuous | 3.1% |
| `age13_2002` | `numeric` | continuous | 3.1% |
| `age14_2002` | `numeric` | continuous | 3.1% |
| `age15_2002` | `numeric` | continuous | 3.1% |
| `age16_2002` | `numeric` | continuous | 3.1% |
| `age17_2002` | `numeric` | continuous | 3.1% |
| `age18_2002` | `numeric` | continuous | 3.1% |
| `is1_r_1982` | `numeric` | continuous | 3.1% |
| `is2_r_1982` | `numeric` | continuous | 3.1% |
| `is3_r_1982` | `numeric` | continuous | 3.1% |
| `is4_r_1982` | `numeric` | continuous | 3.1% |
| `is5_r_1982` | `numeric` | continuous | 3.1% |
| `is6_r_1982` | `numeric` | continuous | 3.1% |
| `is7_r_1982` | `numeric` | continuous | 3.1% |
| `is8_r_1982` | `numeric` | continuous | 3.1% |
| `is9_r_1982` | `numeric` | continuous | 3.1% |
| `is10__1982` | `numeric` | continuous | 3.1% |
| `is11__1982` | `numeric` | continuous | 3.1% |
| `is1_r_1992` | `numeric` | continuous | 3.1% |
| `is2_r_1992` | `numeric` | continuous | 3.1% |
| `is3_r_1992` | `numeric` | continuous | 3.1% |
| `is4_r_1992` | `numeric` | continuous | 3.1% |
| `is5_r_1992` | `numeric` | continuous | 3.1% |
| `is6_r_1992` | `numeric` | continuous | 3.1% |
| `is7_r_1992` | `numeric` | continuous | 3.1% |
| `is8_r_1992` | `numeric` | continuous | 3.1% |
| `is9_r_1992` | `numeric` | continuous | 3.1% |
| `is10__1992` | `numeric` | continuous | 3.1% |
| `is11__1992` | `numeric` | continuous | 3.1% |
| `is1_r_2002` | `numeric` | continuous | 3.1% |
| `is2_r_2002` | `numeric` | continuous | 3.1% |
| `is3_r_2002` | `numeric` | continuous | 3.1% |
| `is4_r_2002` | `numeric` | continuous | 3.1% |
| `is5_r_2002` | `numeric` | continuous | 3.1% |
| `is6_r_2002` | `numeric` | continuous | 3.1% |
| `is7_r_2002` | `numeric` | continuous | 3.1% |
| `is8_r_2002` | `numeric` | continuous | 3.1% |
| `is9_r_2002` | `numeric` | continuous | 3.1% |
| `is10__2002` | `numeric` | continuous | 3.1% |
| `is11__2002` | `numeric` | continuous | 3.1% |
| `oc0_r_1982` | `numeric` | continuous | 3.1% |
| `oc1_r_1982` | `numeric` | continuous | 3.1% |
| `oc2_r_1982` | `numeric` | continuous | 3.1% |
| `oc3_r_1982` | `numeric` | continuous | 3.1% |
| `oc4_r_1982` | `numeric` | continuous | 3.1% |
| `oc5_r_1982` | `numeric` | continuous | 3.1% |
| `oc6_r_1982` | `numeric` | continuous | 3.1% |
| `oc7_r_1982` | `numeric` | continuous | 3.1% |
| `oc8_r_1982` | `numeric` | continuous | 3.1% |
| `oc9_r_1982` | `numeric` | continuous | 3.1% |
| `oc0_r_1992` | `numeric` | continuous | 3.1% |
| `oc1_r_1992` | `numeric` | continuous | 3.1% |
| `oc2_r_1992` | `numeric` | continuous | 3.1% |
| `oc3_r_1992` | `numeric` | continuous | 3.1% |
| `oc4_r_1992` | `numeric` | continuous | 3.1% |
| `oc5_r_1992` | `numeric` | continuous | 3.1% |
| `oc6_r_1992` | `numeric` | continuous | 3.1% |
| `oc7_r_1992` | `numeric` | continuous | 3.1% |
| `oc8_r_1992` | `numeric` | continuous | 3.1% |
| `oc9_r_1992` | `numeric` | continuous | 3.1% |
| `oc0_r_2002` | `numeric` | continuous | 3.1% |
| `oc1_r_2002` | `numeric` | continuous | 3.1% |
| `oc2_r_2002` | `numeric` | continuous | 3.1% |
| `oc3_r_2002` | `numeric` | continuous | 3.1% |
| `oc4_r_2002` | `numeric` | continuous | 3.1% |
| `oc5_r_2002` | `numeric` | continuous | 3.1% |
| `oc6_r_2002` | `numeric` | continuous | 3.1% |
| `oc7_r_2002` | `numeric` | continuous | 3.1% |
| `oc8_r_2002` | `numeric` | continuous | 3.1% |
| `oc9_r_2002` | `numeric` | continuous | 3.1% |


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

- formula_used: lfs2__1982 ~ pop_1982 + pop_1992 + pop_2002 + area_km2 + sex1__1982 + sex2__1982 + sex1__1992 + sex2__1992
- x_terms_used: pop_1982 + pop_1992 + pop_2002 + area_km2 + sex1__1982 + sex2__1982 + sex1__1992 + sex2__1992
- y_term_used: lfs2__1982

### Formules candidates — niveau systeme

- formula_candidate_1: lfs2__1982 ~ pop_1982 + pop_1992 + pop_2002 + area_km2 + sex1__1982 + sex2__1982 + sex1__1992 + sex2__1992
- formula_candidate_2: lfs2__1982 ~ pop_1982 + pop_1992 + pop_2002 + area_km2

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.chile_labor`
- Dataset name: geodatasets::chile_labor
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
- N observations: 64
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-109.3433, -68.5229], y [-53.6889, -18.3884] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: pending — multi-zones (span=40.8deg) -- projection nationale recommandee

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
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`
