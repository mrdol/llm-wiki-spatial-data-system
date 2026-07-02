---
title: Python_geodatasets_spdata.columbus
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/Python_geodatasets_spdata.columbus.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`columbus`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `CRIME`, `HOVAL`
- Candidate Y typology: continuous
- Candidate X variables: `INC`, `OPEN`, `PLUMB`, `DISCBD`, `NSA`, `NSB`, `EW`, `CP`, `AREA`, `PERIMETER`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `POLYID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `CRIME` | `numeric` | continuous | [0.1783, 68.892] | 0% |
| `HOVAL` | `numeric` | continuous | [17.9, 96.4] | 0% |


> Selection Y/X (claude-sonnet-4-6) : CRIME (taux de criminalité) et HOVAL (valeur des logements) sont les deux variables réponses classiques du dataset Columbus, utilisées comme cibles dans la littérature de spatiale. INC (revenu), OPEN (espaces ouverts), PLUMB (plomberie défectueuse), DISCBD (distance au CBD), les indicateurs binaires de zone (NSA, NSB, EW, CP) ainsi que AREA et PERIMETER constituent des covariables explicatives plausibles ; COLUMBUS_, COLUMBUS_I, NEIG, THOUS et NEIGNO sont des identifiants/codes redondants ignorés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `INC` | `numeric` | continuous | 0% |
| `OPEN` | `numeric` | continuous | 0% |
| `PLUMB` | `numeric` | continuous | 0% |
| `DISCBD` | `numeric` | continuous | 0% |
| `NSA` | `numeric` | binary | 0% |
| `NSB` | `numeric` | binary | 0% |
| `EW` | `numeric` | binary | 0% |
| `CP` | `numeric` | binary | 0% |
| `AREA` | `numeric` | rate | 0% |
| `PERIMETER` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: CRIME~HOVAL+INC
- x_terms_pub: HOVAL+INC
- y_term_pub: CRIME
- Reference publication: rdrr.io/cran/spData/man/columbus.html ; Anselin (1988)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: OLS/Lag/Erreur
- Correspondance Python/R: R_spdep_oldcol_COL.OLD
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_spdata.columbus`
- Dataset name: geodatasets::columbus
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
  equation_text: "CRIME~HOVAL+INC"
  equation_family: linear
  model_family: "OLS/Lag/Erreur"
  source_type: software_documentation
  source_ref: "rdrr.io/cran/spData/man/columbus.html ; Anselin (1988)"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 49
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [6.1659, 10.9621], y [11.0409, 14.4377] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32632 (UTM Zone 32N (EPSG:32632)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

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
