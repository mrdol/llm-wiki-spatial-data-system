---
title: R_spData_nz_nz
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/R_spData_nz_nz.rds
tags: [dataset, r-package, spatial, point]
---

Polygons representing the 16 regions of New Zealand (2018). See <https://en.wikipedia.org/wiki/Regions_of_New_Zealand> for a description of these regions and <https://www.stats.govt.nz> for information on the data source

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Population`, `Median_income`, `Sex_ratio`
- Candidate Y typology: continuous, count
- Candidate X variables: `Land_area`, `Island`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Population` | `numeric` | continuous | [32400, 1657200] | 0% |
| `Median_income` | `integer` | count | [23400, 32700] | 0% |
| `Sex_ratio` | `numeric` | continuous | [0.9238, 1.0139] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Population, Median_income et Sex_ratio sont des indicateurs socio-économiques ou démographiques plausibles comme variables réponse à modéliser spatialement. Land_area et Island (Nord/Sud) sont des covariables explicatives naturelles capturant la taille et la localisation géographique des régions ; Name est ignoré car purement administratif.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Land_area` | `numeric` | continuous | 0% |
| `Island` | `character` | categorical | 0% |


### Formule — niveau publication

- formula_pub: none (aucune regression canonique documentee -- recherche manuelle exhaustive menee)
- x_terms_pub: none
- y_term_pub: none
- Reference publication: none (aucune source verifiable retrouvee)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: mauvais candidat
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: Jeu de polygones administratifs (Nouvelle-Zelande) sans variable de reponse documentee pour une regression canonique. [Revue Tache 4 (2026-07-02) : aucune analogie structurelle pertinente identifiee avec un bon candidat existant -- statut inchange plutot que forcer un rapprochement faible.] Raison : Seulement 2 covariables tres generiques (Land_area, Island) pour 16 observations -- base trop mince pour une analogie substantielle credible.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_spData_nz_nz`
- Dataset name: spData::nz
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
  existing_model_found: false
  equation_text: "null"
  equation_family: unknown
  model_family: "unknown"
  source_type: unknown
  source_ref: "null"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 16
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [167.9488, 177.9074], y [-45.4496, -35.4391] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32759 (UTM Zone 59S (EPSG:32759)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

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
