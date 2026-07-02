---
title: R_SpatialEpi_pennLC_sf_pennLC_sf
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/R_SpatialEpi_pennLC_sf_pennLC_sf.rds
tags: [dataset, r-package, spatial, point]
---

County-level (n=67) population/case data for lung cancer in Pennsylvania in 2002, stratified on race (white vs non-white), gender and age (Under 40, 40-59, 60-69 and 70+). Additionally, county-specific smoking rates.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `cases`
- Candidate Y typology: count
- Candidate X variables: `population`, `race`, `gender`, `age`, `smoking`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `cases` | `integer` | count | [0, 387] | 0% |


> Note doc : Number of cases per county split by strata

> Selection Y/X (claude-sonnet-4-6) : cases (nombre de cas de cancer du poumon) est la variable réponse naturelle à modéliser (en tant que count, typiquement via un modèle de Poisson avec offset sur population). population sert d'offset ou de covariable d'exposition, tandis que race, gender, age et smoking sont des facteurs explicatifs classiques de l'incidence du cancer du poumon. county est un libellé administratif ignoré (l'information spatiale est portée par les coordonnées).

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `population` | `integer` | count | 0% |
| `race` | `factor` | categorical | 0% |
| `gender` | `factor` | categorical | 0% |
| `age` | `factor` | categorical | 0% |
| `smoking` | `numeric` | rate | 0% |


### Formule — niveau publication

- formula_pub: Y~offset(log(E))+smoking
- x_terms_pub: offset(log(E))+smoking
- y_term_pub: Y
- Reference publication: Kim, Wakefield & Moise (2025) ; paulamoraga.com/book-spatial

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: Poisson/BYM
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_SpatialEpi_pennLC_sf_pennLC_sf`
- Dataset name: SpatialEpi::pennLC_sf
- Source family: r-package
- Source: package R `SpatialEpi` (version 1.2.8)
- Source URL: https://CRAN.R-project.org/package=SpatialEpi
- Dataset DOI: none
- Publication DOI: pending
- Year: 2012

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Y~offset(log(E))+smoking"
  equation_family: bayesian_latent_field
  model_family: "Poisson/BYM"
  source_type: software_documentation
  source_ref: "Kim, Wakefield & Moise (2025) ; paulamoraga.com/book-spatial"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 1072
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-80.335, -75.0596], y [39.8664, 42.0436] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32618 (UTM Zone 18N (EPSG:32618)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL-2
- License URL: https://CRAN.R-project.org/package=SpatialEpi
- License open: yes
- Reproducibility status: available via package R `SpatialEpi`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

Aucune anomalie detectee.

## Related Pages

- Source: package R `SpatialEpi`
