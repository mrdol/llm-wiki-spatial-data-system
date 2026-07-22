---
title: R_GWmodel_EWHP_ewhp
type: dataset
created: 2026-07-10
updated: 2026-07-10
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

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Fotheringham, A.S., Brunsdon, C., and Charlton, M.E. (2002) Geographically Weighted Regression: The Analysis of Spatially Varying Relationships. Chichester: Wiley.

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: Formule systeme proposee automatiquement pour benchmark spatial ; ne pas confondre avec une formule publiee.
### Formule — niveau systeme

- formula_used: PurPrice ~ BldIntWr + BldPostW + Bld60s + Bld70s + Bld80s + TypDetch + TypFlat + FlrArea
- x_terms_used: BldIntWr + BldPostW + Bld60s + Bld70s + Bld80s + TypDetch + TypFlat + FlrArea
- y_term_used: PurPrice

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
  existing_model_found: false
  equation_text: "null"
  equation_family: unknown
  model_family: "n/a"
  source_type: unknown
  source_ref: "Fotheringham, A.S., Brunsdon, C., and Charlton, M.E. (2002) Geographically Weighted Regression: The Analysis of Spatially Varying Relationships. Chichester: Wiley."
  confidence: low
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

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2)).

## Related Pages

- Source: package R `GWmodel`
