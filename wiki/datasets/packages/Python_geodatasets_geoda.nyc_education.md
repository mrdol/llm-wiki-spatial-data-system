---
title: Python_geodatasets_geoda.nyc_education
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.nyc_education.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`nyc_education`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `YOUTH_DROP`, `HS_DROP`, `COL_DEGREE`, `dropout`, `GENDER_PAR`
- Candidate Y typology: rate, continuous
- Candidate X variables: `PER_MNRTY`, `PER_ASIAN`, `PER_WHITE`, `PER_BLACK`, `mean_inc`, `pop1619`, `enrollhs`, `PER_PRV_SC`, `PER_PUB_SC`, `over3`, `notenroll`, `over3enr`, `pubsch`, `privsch`, `over25`, `subhs`, `somecol`, `college`, `master`, `prof`, `phd`, `sub18`, `SCHOOL_CT`, `popdens`, `population`, `NP_CT`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `POLY_ID`, `BoroCode`, `NTACode`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `YOUTH_DROP` | `numeric` | rate | [0, 1] | 0% |
| `HS_DROP` | `numeric` | rate | [0, 1] | 0% |
| `COL_DEGREE` | `numeric` | rate | [0, 1] | 0% |
| `dropout` | `numeric` | continuous | [0, 403] | 0% |
| `GENDER_PAR` | `numeric` | continuous | [0, 75.875] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables Y candidates sont des taux ou mesures de résultats éducatifs (décrochage scolaire, diplomation, parité de genre) qui constituent des cibles naturelles pour la modélisation spatiale. Les variables X regroupent les caractéristiques socio-démographiques (composition raciale, revenus, densité, population) et les indicateurs structurels du système éducatif (effectifs scolaires public/privé, niveaux d'éducation des adultes) qui jouent un rôle explicatif ; les colonnes purement administratives ou géographiques (CTLabel, BoroName, CT2000, BoroCT2000, NTANAme, PUMA, Shape_Leng, Shape_Area) sont ignorées.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `PER_MNRTY` | `numeric` | rate | 0% |
| `PER_ASIAN` | `numeric` | rate | 0% |
| `PER_WHITE` | `numeric` | rate | 0% |
| `PER_BLACK` | `numeric` | rate | 0% |
| `mean_inc` | `numeric` | continuous | 0% |
| `pop1619` | `numeric` | continuous | 0% |
| `enrollhs` | `numeric` | continuous | 0% |
| `PER_PRV_SC` | `numeric` | rate | 0% |
| `PER_PUB_SC` | `numeric` | rate | 0% |
| `over3` | `numeric` | continuous | 0% |
| `notenroll` | `numeric` | continuous | 0% |
| `over3enr` | `numeric` | continuous | 0% |
| `pubsch` | `numeric` | continuous | 0% |
| `privsch` | `numeric` | continuous | 0% |
| `over25` | `numeric` | continuous | 0% |
| `subhs` | `numeric` | continuous | 0% |
| `somecol` | `numeric` | continuous | 0% |
| `college` | `numeric` | continuous | 0% |
| `master` | `numeric` | continuous | 0% |
| `prof` | `numeric` | continuous | 0% |
| `phd` | `numeric` | continuous | 0% |
| `sub18` | `numeric` | continuous | 0% |
| `SCHOOL_CT` | `integer` | count | 0% |
| `popdens` | `numeric` | continuous | 0% |
| `population` | `numeric` | continuous | 0% |
| `NP_CT` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: mean_inc~sub18+PER_PRV_SC+YOUTH_DROP+HS_DROP+COL_DEGREE+SCHOOL_CT
- x_terms_pub: sub18+PER_PRV_SC+YOUTH_DROP+HS_DROP+COL_DEGREE+SCHOOL_CT
- y_term_pub: mean_inc
- Reference publication: arxiv.org/pdf/2212.05814

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: OLS/GWR/GWRBoost
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.nyc_education`
- Dataset name: geodatasets::nyc_education
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
  equation_text: "mean_inc~sub18+PER_PRV_SC+YOUTH_DROP+HS_DROP+COL_DEGREE+SCHOOL_CT"
  equation_family: geographically_weighted
  model_family: "OLS/GWR/GWRBoost"
  source_type: software_documentation
  source_ref: "arxiv.org/pdf/2212.05814"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 2216
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-74.2397, -73.705], y [40.5077, 40.9127] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32618 (UTM Zone 18N (EPSG:32618)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

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
