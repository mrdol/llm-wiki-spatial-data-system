---
title: R_gstat_oxford_oxford
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/R_gstat_oxford_oxford.rds
tags: [dataset, r-package, spatial, point]
---

Data: 126 soil augerings on a 100 x 100m square grid, with 6 columns and 21 rows. Grid is oriented with long axis North-north-west to South-south-east Origin of grid is South-south-east point, 100m outside grid.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `PROFCLASS`, `MAPCLASS`, `DEPTHCM`, `DEP2LIME`, `PCLAY1`, `PCLAY2`, `OM1`, `CEC1`, `PH1`, `PHOS1`, `POT1`, `MG1`
- Candidate Y typology: categorical, continuous
- Candidate X variables: `ELEV`, `VAL1`, `CHR1`, `LIME1`, `VAL2`, `CHR2`, `LIME2`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `XCOORD`, `YCOORD`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PROFCLASS` | `factor` | categorical | None | 0% |
| `MAPCLASS` | `factor` | categorical | None | 0% |
| `DEPTHCM` | `numeric` | continuous | [10, 91] | 0% |
| `DEP2LIME` | `numeric` | continuous | [20, 90] | 0% |
| `PCLAY1` | `numeric` | continuous | [10, 37] | 0% |
| `PCLAY2` | `numeric` | continuous | [10, 40] | 0% |
| `OM1` | `numeric` | continuous | [2.6, 13.1] | 0% |
| `CEC1` | `numeric` | continuous | [7, 43] | 0% |
| `PH1` | `numeric` | continuous | [4.2, 7.7] | 0% |
| `PHOS1` | `numeric` | continuous | [1.7, 25] | 0% |
| `POT1` | `numeric` | continuous | [83, 847] | 0% |
| `MG1` | `numeric` | continuous | [19, 308] | 0% |


> Selection Y/X (claude-sonnet-4-6) : L'élévation (ELEV) et les attributs de terrain/horizon (VAL, CHR, LIME pour les couches 1 et 2) sont des covariables explicatives naturelles dans un contexte de cartographie pédologique. Les propriétés chimiques et physiques du sol mesurées (pH, matière organique, CEC, phosphore, potassium, magnésium, argile, profondeur, profondeur à la limite calcaire) ainsi que les classes de profil/carte constituent des cibles typiques pour la prédiction spatiale ; PROFILE est ignoré car c'est un simple identifiant de sondage.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `ELEV` | `numeric` | continuous | 0% |
| `VAL1` | `numeric` | continuous | 0% |
| `CHR1` | `numeric` | continuous | 0% |
| `LIME1` | `numeric` | continuous | 0% |
| `VAL2` | `numeric` | continuous | 0% |
| `CHR2` | `numeric` | continuous | 0% |
| `LIME2` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: PH1~ELEV+LIME1
- x_terms_pub: ELEV+LIME1
- y_term_pub: PH1
- Reference publication: Analogie structurelle avec R_agridat_gartner.corn_gartner.corn (banque interne, mission 2026-07)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: candidat par analogie -- non verifie
- Niveau de preuve: analogie
- Methode d'estimation: GWR/OLS
- Correspondance Python/R: aucune identifiee
- Note: CANDIDAT PAR ANALOGIE -- non verifie. Propriete de profil de sol expliquee par l'elevation et le chaulage -- meme logique geomorphologique que gartner.corn (bon candidat, yield~elevation, GWR) ou l'elevation est la covariable geomorphologique primaire d'une propriete agro-pedologique.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_gstat_oxford_oxford`
- Dataset name: gstat::oxford
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
  equation_text: "PH1~ELEV+LIME1"
  equation_family: geographically_weighted
  model_family: "GWR/OLS"
  source_type: unknown
  source_ref: "Analogie structurelle avec R_agridat_gartner.corn_gartner.corn (banque interne, mission 2026-07)"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 126
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [100, 600], y [100, 2100] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
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
