---
title: R_spData_house_house
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/R_spData_house_house.rds
tags: [dataset, r-package, spatial, point]
---

Data on 25,357 single family homes sold in Lucas County, Ohio, 1993-1998 from the county auditor, together with an ‘nb’ neighbour object constructed as a sphere of influence graph from projected coordinates.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `price`, `avalue`
- Candidate Y typology: count
- Candidate X variables: `yrbuilt`, `stories`, `TLA`, `wall`, `beds`, `baths`, `halfbaths`, `frontage`, `depth`, `garage`, `garagesqft`, `rooms`, `lotsize`, `s1993`, `s1994`, `s1995`, `s1996`, `s1997`, `s1998`, `syear`, `age`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `price` | `integer` | count | [2000, 875000] | 0% |
| `avalue` | `integer` | count | [1714, 788114] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Le prix de vente (price) est la cible naturelle d'un modèle hédonique immobilier ; la valeur cadastrale (avalue) peut aussi servir de variable réponse alternative. Les caractéristiques structurelles du logement (surface, chambres, salles de bain, garage, etc.), du terrain (frontage, depth, lotsize), de l'âge et de l'année de vente constituent les covariables explicatives classiques. Les colonnes sdate et T sont exclues car redondantes avec syear/s199x.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `yrbuilt` | `integer` | count | 0% |
| `stories` | `factor` | categorical | 0% |
| `TLA` | `integer` | count | 0% |
| `wall` | `factor` | categorical | 0% |
| `beds` | `numeric` | continuous | 0% |
| `baths` | `numeric` | continuous | 0% |
| `halfbaths` | `numeric` | continuous | 0% |
| `frontage` | `integer` | count | 0% |
| `depth` | `integer` | count | 0% |
| `garage` | `factor` | categorical | 0% |
| `garagesqft` | `integer` | count | 0% |
| `rooms` | `integer` | count | 0% |
| `lotsize` | `integer` | count | 0% |
| `s1993` | `integer` | binary | 0% |
| `s1994` | `integer` | binary | 0% |
| `s1995` | `integer` | binary | 0% |
| `s1996` | `integer` | binary | 0% |
| `s1997` | `integer` | binary | 0% |
| `s1998` | `integer` | binary | 0% |
| `syear` | `factor` | categorical | 0% |
| `age` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: log(price)~TLA+Frontage+Depth+age+beds+baths+... (24 variables)
- x_terms_pub: TLA+Frontage+Depth+age+beds+baths+... (24 variables)
- y_term_pub: log(price)
- Reference publication: github.com/Nowosad/spData/blob/master/R/house.R ; LeSage & Pace (2004)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: OLS/SAR/krigeage
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_spData_house_house`
- Dataset name: spData::house
- Source family: r-package
- Source: package R `spData` (version 2.3.4)
- Source URL: https://CRAN.R-project.org/package=spData
- Dataset DOI: none
- Publication DOI: pending
- Year: 2017

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "log(price)~TLA+Frontage+Depth+age+beds+baths+... (24 variables)"
  equation_family: spatial_lag
  model_family: "OLS/SAR/krigeage"
  source_type: software_documentation
  source_ref: "github.com/Nowosad/spData/blob/master/R/house.R ; LeSage & Pace (2004)"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 25357
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_1

> **Correction metadonnees (Tache 2, juillet 2026)** — `sdate` est la date de vente individuelle de chaque maison (25 357 ventes distinctes, comte de Lucas OH, 1993-1998) — chaque ligne est une transaction unique, pas une unite spatiale suivie repetee. Confirme par wiki/datasets/r_package_docs/spData/topics/house.md ('25,357 single family homes sold ... 1993-1998'). T=1444 (nombre de dates de vente distinctes) ne constitue pas un axe panel.
## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-83.8824, -83.2399], y [41.4169, 41.7323] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32617 (UTM Zone 17N (EPSG:32617)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: CC0
- License URL: https://CRAN.R-project.org/package=spData
- License open: yes
- Reproducibility status: available via package R `spData`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

Aucune anomalie detectee.

## Related Pages

- Source: package R `spData`
