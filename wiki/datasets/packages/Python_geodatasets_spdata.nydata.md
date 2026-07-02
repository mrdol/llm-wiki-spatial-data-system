---
title: Python_geodatasets_spdata.nydata
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/Python_geodatasets_spdata.nydata.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`nydata`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `TRACTCAS`, `PROPCAS`, `Z`
- Candidate Y typology: continuous, rate
- Candidate X variables: `POP8`, `PCTOWNHOME`, `PCTAGE65P`, `AVGIDIST`, `PEXPOSURE`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `AREAKEY`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `TRACTCAS` | `numeric` | continuous | [0, 9.29] | 0% |
| `PROPCAS` | `numeric` | rate | [0, 0.007] | 0% |
| `Z` | `numeric` | continuous | [-1.9206, 4.7105] | 0% |


> Selection Y/X (claude-sonnet-4-6) : TRACTCAS (nombre de cas par tract), PROPCAS (proportion de cas) et Z (vraisemblablement un score standardisé de cas, typique du dataset NY leukemia) sont des cibles épidémiologiques naturelles. POP8, PCTOWNHOME, PCTAGE65P, AVGIDIST et PEXPOSURE sont des covariables explicatives classiques (démographie, statut résidentiel, structure d'âge, distance inverse moyenne à une source, exposition estimée). AREANAME est un libellé géographique ignoré.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `POP8` | `numeric` | continuous | 0% |
| `PCTOWNHOME` | `numeric` | rate | 0% |
| `PCTAGE65P` | `numeric` | rate | 0% |
| `AVGIDIST` | `numeric` | continuous | 0% |
| `PEXPOSURE` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: CASES~PEXPOSURE+PCTOWNHOME+PCTAGE65P+offset(log(POP8))
- x_terms_pub: PEXPOSURE+PCTOWNHOME+PCTAGE65P+offset(log(POP8))
- y_term_pub: CASES
- Reference publication: hughst.github.io/week-7/ ; SISMID 2022 (L. Waller)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: GLM Poisson
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_spdata.nydata`
- Dataset name: geodatasets::nydata
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
  equation_text: "CASES~PEXPOSURE+PCTOWNHOME+PCTAGE65P+offset(log(POP8))"
  equation_family: generalized_linear
  model_family: "GLM Poisson"
  source_type: software_documentation
  source_ref: "hughst.github.io/week-7/ ; SISMID 2022 (L. Waller)"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 281
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-79.4894, -79.4894], y [0.0004, 0.0004] (EPSG:4326)
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

WARN: Variables avec NA > 20% : A, R, E, A, N, A, M, E,  , (, N, A, =, 2, 9, ., 5, %, )

## Related Pages

- Source: package Python `geodatasets`
