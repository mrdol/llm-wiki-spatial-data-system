---
title: Python_geodatasets_geoda.ndvi
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.ndvi.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`ndvi`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `GREEN`
- Candidate Y typology: count
- Candidate X variables: `TEMP`, `ELEV`, `PREC`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `POLYID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `GREEN` | `integer` | count | [107, 155] | 0% |


> Selection Y/X (claude-sonnet-4-6) : GREEN (réflectance verte / proxy NDVI) est la variable réponse naturelle à modéliser dans un contexte de végétation. TEMP, ELEV et PREC sont des covariables environnementales classiques (température, altitude, précipitations) qui expliquent la distribution spatiale de la végétation. AREA et PERIMETER sont constants (plage [49,49] et [28,28]) donc sans variance utile et sont ignorés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `TEMP` | `integer` | count | 0% |
| `ELEV` | `integer` | count | 0% |
| `PREC` | `integer` | count | 0% |


### Formule — niveau publication

- formula_pub: GREEN~TEMP+PREC
- x_terms_pub: TEMP+PREC
- y_term_pub: GREEN
- Reference publication: geodacenter.github.io/data-and-lab/ndvi/ ; Anselin (1993)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: Autoregression spatiale discrete
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.ndvi`
- Dataset name: geodatasets::ndvi
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
  equation_text: "GREEN~TEMP+PREC"
  equation_family: unknown
  model_family: "Autoregression spatiale discrete"
  source_type: software_documentation
  source_ref: "geodacenter.github.io/data-and-lab/ndvi/ ; Anselin (1993)"
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
- Spatial extent: x [3.5, 45.5], y [3.5, 45.5] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: pending — multi-zones (span=42deg) -- projection nationale recommandee

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
