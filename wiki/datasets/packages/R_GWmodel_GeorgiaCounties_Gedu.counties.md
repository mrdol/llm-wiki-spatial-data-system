---
title: R_GWmodel_GeorgiaCounties_Gedu.counties
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/R_GWmodel_GeorgiaCounties_Gedu.counties.rds
tags: [dataset, r-package, spatial, point]
---

Dataset spatial issu du package R `GWmodel` (`GeorgiaCounties`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `AREA`, `PERIMETER`
- Candidate Y typology: continuous
- Candidate X variables: `G_UTM_`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X_COORD`, `Y_COORD`, `X`, `Y`
- Identifier columns (excluded from X candidates): `G_UTM_ID`, `AREAKEY`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `AREA` | `numeric` | continuous | [313807000, 2356370000] | 0% |
| `PERIMETER` | `numeric` | continuous | [87211.2, 341307] | 0% |


> Selection Y/X (claude-sonnet-4-6) : AREA et PERIMETER sont des mesures géométriques continues des comtés géorgiens pouvant servir de variables réponse (ex. modéliser la taille/forme des unités spatiales). G_UTM_ est un identifiant numérique de zone UTM qui peut agir comme covariable spatiale proxy. AREANAME est un libellé géographique ignoré car purement administratif.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `G_UTM_` | `integer` | count | 0% |


### Formule — niveau publication

- formula_pub: PctBach~PctRural+PctFB+PctBlack+PctEld
- x_terms_pub: PctRural+PctFB+PctBlack+PctEld
- y_term_pub: PctBach
- Reference publication: Fotheringham, Brunsdon & Charlton (2002), Wiley

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: GWR
- Correspondance Python/R: Python_libpysal_georgia
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_GWmodel_GeorgiaCounties_Gedu.counties`
- Dataset name: GWmodel::GeorgiaCounties
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
- Spatial extent: x [636298.2136, 1058883.0273], y [3407273.375, 3865995] (CRS unknown)
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

WARN: CRS absent — lookup EPSG necessaire.

## Related Pages

- Source: package R `GWmodel`
