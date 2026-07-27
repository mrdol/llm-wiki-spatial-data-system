---
title: R_gstat_jura_jura.pred
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/R_gstat_jura_jura.pred.rds
tags: [dataset, r-package, spatial, point]
---

The jura data set from Pierre Goovaerts' book (see references below). It contains four ‘data.frame’s: prediction.dat, validation.dat and transect.dat and juragrid.dat, and three ‘data.frame’s with consistently coded land use and rock type factors, as well as geographic coordinates. The examples below show how to transform these into spatial (sp) ob...

## Description du jeu de donnees

- Topic: agriculture / rendement ou experimentation agronomique
- Observation unit: parcelle, placette experimentale ou observation agricole
- Observed population: observations agricoles documentees par le package source
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: The jura data set from Pierre Goovaerts' book (see references below). It contains four ‘data.frame’s: prediction.dat, validation.dat and transect.dat and juragrid.dat, and three ‘data.frame’s with consistently coded land use and rock type factors, as well as geographic coordinates. The examples below show how to transform these into spatial (sp) ob...
- Description source: package R `gstat`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Cd`, `Pb`, `Zn`, `Cu`, `Ni`, `Co`, `Cr`
- Candidate Y typology: continuous
- Candidate X variables: `Landuse`, `Rock`
- Candidate X typology: categorical
- Coordinates (x, y — excluded from X candidates): `Xloc`, `Yloc`, `long`, `lat`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Cd` | `numeric` | continuous | [0.135, 5.129] | 0% |
| `Pb` | `numeric` | continuous | [18.96, 229.56] | 0% |
| `Zn` | `numeric` | continuous | [25.2, 219.32] | 0% |
| `Cu` | `numeric` | continuous | [3.96, 166.4] | 0% |
| `Ni` | `numeric` | continuous | [4.2, 53.2] | 0% |
| `Co` | `numeric` | continuous | [1.552, 17.72] | 0% |
| `Cr` | `numeric` | continuous | [8.72, 67.6] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les concentrations en métaux lourds (Cd, Pb, Zn, Cu, Ni, Co, Cr) sont des variables réponses classiques dans ce jeu de données géochimique du Jura, chacune pouvant être modélisée spatialement. Landuse et Rock sont des covariables catégorielles explicatives naturelles reflétant le contexte environnemental et géologique influençant la distribution des métaux.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Landuse` | `factor` | categorical | 0% |
| `Rock` | `factor` | categorical | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Goovaerts, P. (1997) Geostatistics for Natural Resources Evaluation. Oxford University Press, New-York, 483 p. (Appendix C describes the Jura data set)

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_gstat_jura_jura.pred`
- Dataset name: gstat::jura
- Source family: r-package
- Source: package R `gstat` (version 2.1.6)
- Source URL: https://CRAN.R-project.org/package=gstat
- Dataset DOI: none
- Publication DOI: pending
- Year: 2003

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
  source_ref: "Goovaerts, P. (1997) Geostatistics for Natural Resources Evaluation. Oxford University Press, New-York, 483 p. (Appendix C describes the Jura data set)"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 259
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [6.8276, 6.8839], y [47.1167, 47.1626] (EPSG:4326, via documentation)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326 (source: documentation du package, .rds sans CRS embarque)
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2.0)
- License URL: https://CRAN.R-project.org/package=gstat
- License open: yes
- Reproducibility status: available via package R `gstat`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: WARN - CRS absent du `.rds` source ; EPSG:4326 extrait de la documentation et reporte dans le Bloc 5.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: WARN - groupe de versions suspectes `jura`; autres versions: R_gstat_jura_jura.val, R_gstat_jura_prediction.dat, R_gstat_jura_validation.dat
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2.0)).

## Related Pages

- Source: package R `gstat`
- Duplicate/version candidate: [[R_gstat_jura_jura.val]]
- Duplicate/version candidate: [[R_gstat_jura_prediction.dat]]
- Duplicate/version candidate: [[R_gstat_jura_validation.dat]]
