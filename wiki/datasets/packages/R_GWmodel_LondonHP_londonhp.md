---
title: R_GWmodel_LondonHP_londonhp
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/R_GWmodel_LondonHP_londonhp.rds
tags: [dataset, r-package, spatial, point]
---

A house price data set with 18 hedonic variables for London in 2001.

## Bloc 1 â€” Formule et variables

### Variables (niveau systeme â€” inspection directe du sf)

- Candidate Y variables: `PURCHASE`
- Candidate Y typology: continuous
- Candidate X variables: `FLOORSZ`, `TYPEDETCH`, `TPSEMIDTCH`, `TYPETRRD`, `TYPEBNGLW`, `TYPEFLAT`, `BLDPWW1`, `BLDPOSTW`, `BLD60S`, `BLD70S`, `BLD80S`, `BLD90S`, `BLDINTW`, `BATH2`, `BEDS2`, `GARAGE1`, `CENTHEAT`, `UNEMPLOY`, `PROF`
- Candidate X typology: continuous, categorical
- Coordinates (x, y â€” excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto â€” export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PURCHASE` | `numeric` | continuous | [45000, 567500] | 0% |


> Note doc : y is detached (i

> Selection Y/X (claude-sonnet-4-6) : PURCHASE (prix d'achat) est la variable rÃ©ponse naturelle d'un modÃ¨le hÃ©donique de prix immobiliers. Toutes les autres colonnes sont des attributs hÃ©doniques du logement (surface, type, Ã©poque de construction, Ã©quipements) ou des indicateurs socio-Ã©conomiques du voisinage (chÃ´mage, proportion de professions libÃ©rales), qui constituent des covariables explicatives classiques dans ce type de modÃ¨le.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `FLOORSZ` | `numeric` | continuous | 0% |
| `TYPEDETCH` | `integer` | binary | 0% |
| `TPSEMIDTCH` | `integer` | binary | 0% |
| `TYPETRRD` | `integer` | binary | 0% |
| `TYPEBNGLW` | `integer` | binary | 0% |
| `TYPEFLAT` | `integer` | binary | 0% |
| `BLDPWW1` | `integer` | binary | 0% |
| `BLDPOSTW` | `integer` | binary | 0% |
| `BLD60S` | `integer` | binary | 0% |
| `BLD70S` | `integer` | binary | 0% |
| `BLD80S` | `integer` | binary | 0% |
| `BLD90S` | `integer` | binary | 0% |
| `BLDINTW` | `integer` | binary | 0% |
| `BATH2` | `integer` | binary | 0% |
| `BEDS2` | `integer` | binary | 0% |
| `GARAGE1` | `integer` | binary | 0% |
| `CENTHEAT` | `integer` | binary | 0% |
| `UNEMPLOY` | `numeric` | rate | 0% |
| `PROF` | `numeric` | rate | 0% |


### Formule â€” niveau publication

- formula_pub: Prix immobilier ~ 18 variables hedoniques
- x_terms_pub: 18 variables hedoniques
- y_term_pub: Prix immobilier
- Reference publication: rdrr.io/cran/GWmodel/man/LondonHP.html ; Lu et al. (2014)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: GWR non-euclidienne
- Correspondance Python/R: R_GWmodel_LondonBorough_londonborough
- Note: Dataset ponctuel portant les observations hedoniques ; londonborough (meme package) fournit les polygones d'arrondissement associes.

### Formule â€” niveau systeme

- formula_used: Prix immobilier ~ 18 variables hedoniques
- x_terms_used: 18 variables hedoniques
- y_term_used: Prix immobilier
## Bloc 2 â€” Identification et DOI

- Dataset ID: `R_GWmodel_LondonHP_londonhp`
- Dataset name: GWmodel::LondonHP
- Source family: r-package
- Source: package R `GWmodel` (version 2.4.1)
- Source URL: https://CRAN.R-project.org/package=GWmodel
- Dataset DOI: none
- Publication DOI: 10.1080/13658816.2013.865739
- Year: 2013

## Bloc 3 â€” Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Prix immobilier ~ 18 variables hedoniques"
  equation_family: geographically_weighted
  model_family: "GWR non-euclidienne"
  source_type: software_documentation
  source_ref: "rdrr.io/cran/GWmodel/man/LondonHP.html ; Lu et al. (2014)"
  confidence: high
```

## Bloc 4 â€” Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 316
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 â€” Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [507400, 552300], y [159400, 194900] (EPSG:27700, via documentation)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 27700 (source: documentation du package, .rds sans CRS embarque)
- CRS nom: unknown
- CRS analyse recommande: pending â€” CRS source non geographique ou inconnu

## Bloc 6 â€” Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://CRAN.R-project.org/package=GWmodel
- License open: yes
- Reproducibility status: available via package R `GWmodel`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

WARN: CRS absent â€” lookup EPSG necessaire.

## Related Pages

- Source: package R `GWmodel`
