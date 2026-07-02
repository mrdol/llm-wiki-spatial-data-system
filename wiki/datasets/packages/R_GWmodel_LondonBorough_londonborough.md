---
title: R_GWmodel_LondonBorough_londonborough
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/R_GWmodel_LondonBorough_londonborough.rds
tags: [dataset, r-package, spatial, point]
---

Dataset spatial issu du package R `GWmodel` (`LondonBorough`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `HECTARES`, `AREA`
- Candidate Y typology: continuous
- Candidate X variables: `NUMBER`, `NUMBER0`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `AREA_CODE`, `POLYGON_ID`, `UNIT_ID`, `CODE`, `TYPE_CODE`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `HECTARES` | `numeric` | continuous | [314.942, 18431.778] | 0% |
| `AREA` | `numeric` | continuous | [0, 2094.43] | 0% |


> Selection Y/X (claude-sonnet-4-6) : HECTARES et AREA sont des mesures continues de superficie, candidates naturelles comme variable réponse (ex: prédire la taille d'un borough). NUMBER et NUMBER0 sont des comptages numériques pouvant servir de covariables explicatives. Les colonnes catégorielles (NAME, DESCRIPTIO, FILE_NAME, DESCRIPT0, B_Name) sont des libellés/identifiants géographiques administratifs à ignorer, et TYPE_COD0 est entièrement manquante (100% NA).

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `NUMBER` | `integer` | count | 0% |
| `NUMBER0` | `integer` | count | 0% |


### Formule — niveau publication

- formula_pub: Prix immobilier ~ 18 variables hedoniques (dataset associe LondonHP porte les observations ponctuelles ; londonborough = polygones d'arrondissements de reference spatiale)
- x_terms_pub: 18 variables hedoniques (dataset associe LondonHP porte les observations ponctuelles ; londonborough = polygones d'arrondissements de reference spatiale)
- y_term_pub: Prix immobilier
- Reference publication: rdrr.io/cran/GWmodel/man/LondonHP.html ; Lu et al. (2014)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: GWR non-euclidienne
- Correspondance Python/R: R_GWmodel_LondonHP_londonhp
- Note: La formule et les variables hedoniques sont portees par le dataset ponctuel associe LondonHP (meme package GWmodel) ; londonborough fournit les polygones d'arrondissement utilises comme reference spatiale/jointure.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_GWmodel_LondonBorough_londonborough`
- Dataset name: GWmodel::LondonBorough
- Source family: r-package
- Source: package R `GWmodel`
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
  equation_text: "Prix immobilier ~ 18 variables hedoniques (dataset associe LondonHP porte les observations ponctuelles ; londonborough = polygones d'arrondissements de reference spatiale)"
  equation_family: geographically_weighted
  model_family: "GWR non-euclidienne"
  source_type: software_documentation
  source_ref: "rdrr.io/cran/GWmodel/man/LondonHP.html ; Lu et al. (2014)"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 35
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [505184.9648, 557214.5531], y [163446.85, 196193.8294] (CRS unknown)
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

WARN: Variables avec NA > 20% : T, Y, P, E, _, C, O, D, 0,  , (, N, A, =, 1, 0, 0, %, )
WARN: CRS absent — lookup EPSG necessaire.

## Related Pages

- Source: package R `GWmodel`
