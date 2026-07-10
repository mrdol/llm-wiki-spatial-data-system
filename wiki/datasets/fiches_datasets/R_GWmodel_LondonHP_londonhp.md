---
title: R_GWmodel_LondonHP_londonhp
type: dataset
created: 2026-06-30
updated: 2026-07-10
sources:
  - data/final_datasets/sf/R_GWmodel_LondonHP_londonhp.rds
tags: [dataset, r-package, spatial, point]
---

A house price data set with 18 hedonic variables for London in 2001.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `PURCHASE`
- Candidate Y typology: continuous
- Candidate X variables: `FLOORSZ`, `TYPEDETCH`, `TPSEMIDTCH`, `TYPETRRD`, `TYPEBNGLW`, `TYPEFLAT`, `BLDPWW1`, `BLDPOSTW`, `BLD60S`, `BLD70S`, `BLD80S`, `BLD90S`, `BLDINTW`, `BATH2`, `BEDS2`, `GARAGE1`, `CENTHEAT`, `UNEMPLOY`, `PROF`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PURCHASE` | `numeric` | continuous | [45000, 567500] | 0% |


> Note doc : y is detached (i

> Selection Y/X (claude-sonnet-4-6) : PURCHASE (prix d'achat) est la variable réponse naturelle d'un modèle hédonique de prix immobiliers. Toutes les autres colonnes sont des attributs hédoniques du logement (surface, type, époque de construction, équipements) ou des indicateurs socio-économiques du voisinage (chômage, proportion de professions libérales), qui constituent des covariables explicatives classiques dans ce type de modèle.

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


### Formule — niveau publication

- formula_pub: `PURCHASE ~ FLOORSZ + PROF + BATH2`
- x_terms_pub: `FLOORSZ`, `PROF`, `BATH2`
- y_term_pub: `PURCHASE`
- Reference publication: Lu, Charlton, Harris & Fotheringham (2014), DOI `10.1080/13658816.2013.865739`; documentation `GWmodel::LondonHP`
- Note publication: l'article teste 120 regressions OLS puis 720 calibrations GWR; le modele no. 42 (`PURCHASE ~ FLOORSZ + PROF + BATH2`) est retenu comme specification representative pour comparer les distances GWR.

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: GWR non-euclidienne
- Correspondance Python/R: R_GWmodel_LondonBorough_londonborough
- Note: Dataset ponctuel portant les observations hedoniques ; londonborough (meme package) fournit les polygones d'arrondissement associes. La contribution econometrique principale de Lu et al. (2014) est la comparaison de GWR avec distance euclidienne, distance reseau routier et temps de trajet.

### Formule — niveau systeme

- formula_used: `PURCHASE ~ FLOORSZ + PROF + BATH2`
- x_terms_used: `FLOORSZ`, `PROF`, `BATH2`
- y_term_used: `PURCHASE`
- Note pipeline: le benchmark general peut utiliser une formule elargie pour comparer plusieurs estimateurs, mais le profil de reproduction Lu et al. (2014) doit utiliser la formule ci-dessus.
## Bloc 2 — Identification et DOI

- Dataset ID: `R_GWmodel_LondonHP_londonhp`
- Dataset name: GWmodel::LondonHP
- Source family: r-package
- Source: package R `GWmodel` (version 2.4.1)
- Source URL: https://CRAN.R-project.org/package=GWmodel
- Dataset DOI: none
- Publication DOI: 10.1080/13658816.2013.865739
- Year: 2014

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): regression
- Modele niveau 2 (famille): geographically_weighted_regression
- Modele niveau 3 (variante): GWR with non-Euclidean distance metric

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "PURCHASE ~ FLOORSZ + PROF + BATH2"
  equation_family: geographically_weighted
  model_family: "GWR ED / GWR ND / GWR TT"
  source_type: scientific_article
  source_ref: "Lu, Charlton, Harris & Fotheringham (2014), IJGIS, doi:10.1080/13658816.2013.865739 ; rdrr.io/cran/GWmodel/man/LondonHP.html"
  confidence: high
  implementation_note: "Le pipeline courant reproduit la distance euclidienne via coordonnees metriques; les matrices ND/TT du papier ne sont pas encore disponibles dans le bundle local."
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 316
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [507400, 552300], y [159400, 194900] (EPSG:27700, via documentation)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 27700 (source: documentation du package, .rds sans CRS embarque)
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
