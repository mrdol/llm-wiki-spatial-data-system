---
title: R_GWmodel_GeorgiaCounties_Gedu.counties
type: dataset
created: 2026-06-30
updated: 2026-07-02
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
- Spatial extent: x [636298.2136, 1058883.0273], y [3407273.375, 3865995] (EPSG:26916, resolu 2026-07-02)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 26916
- CRS nom: NAD83 / UTM zone 16N
- CRS analyse recommande: 26916 (NAD83 / UTM zone 16N) — deja projete, adapte a l'analyse

> **Correction CRS (2026-07-02)** — Aucun CRS n'etait embarque dans le .rds ni
> documente dans `wiki/datasets/r_package_docs/GWmodel/topics/Georgia.md`. Resolu
> par inference : les colonnes `G_UTM_`/`G_UTM_ID` du shapefile source indiquent
> explicitement une projection UTM ; l'easting max observe (1058883m) correspond
> a la distance attendue (~1085km) entre le meridien central de la zone UTM 16N
> (-87°) et l'extremite est de la Georgie (~-80.8°, cote atlantique), a la
> latitude ~32°N — calcul : 6.2° x 111.3km x cos(32°) + 500000m (fausse easting)
> ≈ 1085000m. Datum NAD83 suppose (NAD27 alternative possible mais materiellement
> equivalent a cette echelle pour la construction d'une matrice de poids spatiaux).

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://CRAN.R-project.org/package=GWmodel
- License open: yes
- Reproducibility status: available via package R `GWmodel`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

CRS resolu le 2026-07-02 (EPSG:26916, voir note Bloc 5).

## Related Pages

- Source: package R `GWmodel`
