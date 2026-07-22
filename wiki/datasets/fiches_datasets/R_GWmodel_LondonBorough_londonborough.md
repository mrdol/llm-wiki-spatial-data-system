---
title: R_GWmodel_LondonBorough_londonborough
type: dataset
created: 2026-07-10
updated: 2026-07-10
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

- formula_pub: `PURCHASE ~ FLOORSZ + PROF + BATH2`
- x_terms_pub: FLOORSZ + PROF + BATH2`
- y_term_pub: `PURCHASE
- Reference publication: Lu, Charlton, Harris & Fotheringham (2014), DOI `10.1080/13658816.2013.865739`; documentation `GWmodel::LondonHP`

### Statut regression canonique

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: GWR non-euclidienne
- Correspondance Python/R: R_GWmodel_LondonHP_londonhp
- Note: Formule identifiee via la documentation du package equivalent `R_GWmodel_LondonHP_londonhp` -- meme jeu de donnees sous-jacent (propagation automatique Tache 3, a confirmer par revue manuelle).

### Formule — niveau systeme

- formula_used: PURCHASE ~ FLOORSZ + PROF + BATH2
- x_terms_used: FLOORSZ + PROF + BATH2
- y_term_used: PURCHASE

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
  equation_text: "`PURCHASE ~ FLOORSZ + PROF + BATH2`"
  equation_family: unknown
  model_family: "GWR non-euclidienne"
  source_type: unknown
  source_ref: "Lu, Charlton, Harris & Fotheringham (2014), DOI `10.1080/13658816.2013.865739`; documentation `GWmodel::LondonHP`"
  confidence: low
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

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20% : TYPE_COD0 (NA=100%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2)).

## Related Pages

- Source: package R `GWmodel`
