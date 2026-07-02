---
title: R_gstat_DE_RB_2005_DE_RB_2005
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/R_gstat_DE_RB_2005_DE_RB_2005.rds
tags: [dataset, r-package, spatial, point]
---

Spatio-temporal data set with rural background PM10 concentrations in Germany 2005 (airbase v6).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `PM10`, `annual_mean_PM10`
- Candidate Y typology: continuous
- Candidate X variables: `station_altitude`, `type_of_station`, `station_type_of_area`, `street_type`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `coords.x1`, `coords.x2`, `X`, `Y`
- Identifier columns (excluded from X candidates): `sp.ID`, `station_european_code`, `country_iso_code`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PM10` | `numeric` | continuous | [0, 177] | 0% |
| `annual_mean_PM10` | `numeric` | continuous | [9.8073, 27.7456] | 0% |


> Selection Y/X (claude-sonnet-4-6) : PM10 (mesure instantanée/journalière) et annual_mean_PM10 (agrégat annuel) sont les variables réponse naturelles pour modéliser la concentration en particules fines ; station_altitude, type_of_station, station_type_of_area et street_type sont des covariables explicatives classiques capturant le contexte géographique et environnemental des stations. Les colonnes temporelles (time, endTime, station_start_date, station_end_date), l'index ..1 et T (facteur ambigu/redondant) sont ignorés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `station_altitude` | `integer` | count | 0% |
| `type_of_station` | `factor` | categorical | 0% |
| `station_type_of_area` | `factor` | categorical | 0% |
| `street_type` | `factor` | categorical | 0% |


### Formule — niveau publication

- formula_pub: PM10 ~ 1 (modele de tendance spatio-temporelle, puis krigeage des residus)
- x_terms_pub: 1 (modele de tendance spatio-temporelle, puis krigeage des residus)
- y_term_pub: PM10
- Reference publication: Graler B., Pebesma E., Heuvelink G. (2016) Spatio-Temporal Interpolation using gstat. The R Journal, 8(1), 204-218

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: a verifier
- Niveau de preuve: verbatim
- Methode d'estimation: Krigeage spatio-temporel
- Correspondance Python/R: aucune identifiee
- Note: Formule deja presente (enrichissement anterieur) : modele intercept-only utilise comme tendance de base avant krigeage spatio-temporel des residus dans le tutoriel gstat officiel — pas une regression multi-covariables classique.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_gstat_DE_RB_2005_DE_RB_2005`
- Dataset name: gstat::DE_RB_2005
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
  equation_text: "PM10 ~ 1 (modele de tendance spatio-temporelle, puis krigeage des residus)"
  equation_family: unknown
  model_family: "Krigeage spatio-temporel"
  source_type: software_documentation
  source_ref: "Graler B., Pebesma E., Heuvelink G. (2016) Spatio-Temporal Interpolation using gstat. The R Journal, 8(1), 204-218"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatio-temporel
- Structure: panel
- N observations: 23230
- T periods: 365
- Variable temporelle: time
- N/T profile: N_grand_T_grand

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: pending inspection
- Spatial extent: x [307809.2951, 907374.8164], y [5295751.8753, 6086661.149] (EPSG:32632, via documentation)
- Time range: pending inspection
- Type de geometrie: POINT
- CRS EPSG: 32632 (source: documentation du package, .rds sans CRS embarque)
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
