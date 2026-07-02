---
title: R_GWmodel_EWHP_ewhp
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/R_GWmodel_EWHP_ewhp.rds
tags: [dataset, r-package, spatial, point]
---

A house price data set for England and Wales from 2001 with 9 hedonic (explanatory) variables.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `PurPrice`
- Candidate Y typology: continuous
- Candidate X variables: `BldIntWr`, `BldPostW`, `Bld60s`, `Bld70s`, `Bld80s`, `TypDetch`, `TypFlat`, `FlrArea`
- Candidate X typology: categorical, continuous
- Coordinates (x, y — excluded from X candidates): `Easting`, `Northing`, `X`, `Y`
- Identifier columns (excluded from X candidates): `TypSemiD`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PurPrice` | `numeric` | continuous | [8750, 325000] | 0% |


> Note doc : y is detached (i

> Selection Y/X (claude-sonnet-4-6) : PurPrice (purchase price) est la variable réponse naturelle d'un modèle hédonique de prix immobiliers. Les 8 autres colonnes sont des caractéristiques du logement (période de construction, type de bien, surface habitable) constituant les covariables explicatives classiques d'un modèle hédonique.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `BldIntWr` | `integer` | binary | 0% |
| `BldPostW` | `integer` | binary | 0% |
| `Bld60s` | `integer` | binary | 0% |
| `Bld70s` | `integer` | binary | 0% |
| `Bld80s` | `integer` | binary | 0% |
| `TypDetch` | `integer` | binary | 0% |
| `TypFlat` | `integer` | binary | 0% |
| `FlrArea` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: PurPrice~BldIntWr+BldPostW+Bld60s+Bld70s+Bld80s+TypDetch+TypSemiD+TypFlat+FlrArea
- x_terms_pub: BldIntWr+BldPostW+Bld60s+Bld70s+Bld80s+TypDetch+TypSemiD+TypFlat+FlrArea
- y_term_pub: PurPrice
- Reference publication: Gollini et al. (2015), JSS 63, arxiv.org/pdf/1306.0413

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: GWR/OLS
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_GWmodel_EWHP_ewhp`
- Dataset name: GWmodel::EWHP
- Source family: r-package
- Source: package R `GWmodel` (version 2.4.1)
- Source URL: https://CRAN.R-project.org/package=GWmodel
- Dataset DOI: none
- Publication DOI: pending
- Year: 2013

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "PurPrice~BldIntWr+BldPostW+Bld60s+Bld70s+Bld80s+TypDetch+TypSemiD+TypFlat+FlrArea"
  equation_family: geographically_weighted
  model_family: "GWR/OLS"
  source_type: software_documentation
  source_ref: "Gollini et al. (2015), JSS 63, arxiv.org/pdf/1306.0413"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 519
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [224000, 654600], y [47800, 574000] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://CRAN.R-project.org/package=GWmodel
- License open: yes
- Reproducibility status: available via package R `GWmodel`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

WARN: CRS absent — lookup EPSG necessaire.

## Related Pages

- Source: package R `GWmodel`
