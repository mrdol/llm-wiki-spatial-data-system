---
title: Python_libpysal_georgia
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/Python_libpysal_georgia.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `libpysal` (`georgia`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `PctPov`, `PctBach`, `PctBlack`
- Candidate Y typology: continuous
- Candidate X variables: `AREA`, `PERIMETER`, `TotPop90`, `PctRural`, `PctEld`, `PctFB`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `Latitude`, `X`, `Y`
- Identifier columns (excluded from X candidates): `G_UTM_ID`, `AreaKey`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PctPov` | `numeric` | continuous | [2.6, 35.9] | 0% |
| `PctBach` | `numeric` | continuous | [4.2, 37.5] | 0% |
| `PctBlack` | `numeric` | continuous | [0, 79.64] | 0% |


> Selection Y/X (claude-sonnet-4-6) : PctPov (taux de pauvreté), PctBach (niveau d'éducation) et PctBlack (composition démographique) sont des variables socio-économiques classiquement modélisées comme réponses dans des études de géographie humaine. Les covariables retenues capturent la taille (AREA, PERIMETER), la population (TotPop90), le caractère rural (PctRural), la structure par âge (PctEld) et l'immigration (PctFB) ; G_UTM_ semble être un identifiant interne et Longitud une coordonnée redondante, tous deux exclus.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `AREA` | `numeric` | continuous | 0% |
| `PERIMETER` | `numeric` | continuous | 0% |
| `TotPop90` | `integer` | count | 0% |
| `PctRural` | `numeric` | continuous | 0% |
| `PctEld` | `numeric` | continuous | 0% |
| `PctFB` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: PctBach~PctRural+PctFB+PctBlack+PctEld
- x_terms_pub: PctRural+PctFB+PctBlack+PctEld
- y_term_pub: PctBach
- Reference publication: Fotheringham, Brunsdon & Charlton (2002), Wiley

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: GWR
- Correspondance Python/R: R_GWmodel_GeorgiaCounties_Gedu.counties
- Note: Formule identifiee via la documentation du package R equivalent GWmodel::Gedu.counties — meme jeu de donnees sous-jacent (Georgia, Fotheringham et al. 2002).

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_libpysal_georgia`
- Dataset name: libpysal::georgia
- Source family: python-package
- Source: package Python `libpysal`
- Source URL: https://pypi.org/project/libpysal/
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
  equation_text: "PctBach~PctRural+PctFB+PctBlack+PctEld"
  equation_family: geographically_weighted
  model_family: "GWR"
  source_type: software_documentation
  source_ref: "Fotheringham, Brunsdon & Charlton (2002), Wiley"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 159
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-91.4895, -91.4895], y [0.0003, 0.0003] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32615 (UTM Zone 15N (EPSG:32615)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/libpysal/
- License open: yes
- Reproducibility status: available via package Python `libpysal`
- Code available: yes (package examples and vignettes)
- Repository: python-package

## Quality Control

Aucune anomalie detectee.

## Related Pages

- Source: package Python `libpysal`
