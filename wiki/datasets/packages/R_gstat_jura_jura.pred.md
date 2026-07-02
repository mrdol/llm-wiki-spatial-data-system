---
title: R_gstat_jura_jura.pred
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/R_gstat_jura_jura.pred.rds
tags: [dataset, r-package, spatial, point]
---

The jura data set from Pierre Goovaerts' book (see references below). It contains four ‘data.frame’s: prediction.dat, validation.dat and transect.dat and juragrid.dat, and three ‘data.frame’s with consistently coded land use and rock type factors, as well as geographic coordinates. The examples below show how to transform these into spatial (sp) ob...

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

- formula_pub: log(Zn)~Landuse+Rock
- x_terms_pub: Landuse+Rock
- y_term_pub: log(Zn)
- Reference publication: Analogie structurelle avec R_gstat_meuse.all_meuse.all (banque interne, mission 2026-07)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: candidat par analogie -- non verifie
- Niveau de preuve: analogie
- Methode d'estimation: OLS
- Correspondance Python/R: aucune identifiee
- Note: CANDIDAT PAR ANALOGIE -- non verifie (n'annule pas le statut principal : la methode publiee documentee reste le krigeage/cokrigeage, Goovaerts 1997). Meme domaine que meuse.all (bon candidat, log(zinc)~sqrt(dist)) : concentration en metal lourd expliquee par des covariables categorielles reelles du jeu (occupation du sol, geologie), disponible en complement de l'approche kriging officielle.

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
  existing_model_found: true
  equation_text: "log(Zn)~Landuse+Rock"
  equation_family: linear
  model_family: "OLS"
  source_type: unknown
  source_ref: "Analogie structurelle avec R_gstat_meuse.all_meuse.all (banque interne, mission 2026-07)"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 259
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

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

WARN: CRS absent — lookup EPSG necessaire.

## Related Pages

- Source: package R `gstat`
