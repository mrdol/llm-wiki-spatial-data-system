---
title: R_spData_world_world
type: dataset
created: 2026-07-10
updated: 2026-07-10
sources:
  - data/final_datasets/sf/R_spData_world_world.rds
tags: [dataset, r-package, spatial, point]
---

The object loaded is a ‘sf’ object containing a world map data from Natural Earth with a few variables from World Bank

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `lifeExp`, `gdpPercap`, `pop`
- Candidate Y typology: continuous
- Candidate X variables: `area_km2`, `continent`, `region_un`, `subregion`, `type`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `lifeExp` | `numeric` | continuous | [50.621, 83.5878] | 5.6% |
| `gdpPercap` | `numeric` | continuous | [597.1352, 120860.0676] | 9.6% |
| `pop` | `numeric` | continuous | [56295, 1364270000] | 5.6% |


> Selection Y/X (claude-sonnet-4-6) : lifeExp, gdpPercap et pop sont des variables quantitatives de résultat classiquement modélisées en économie et démographie spatiale. area_km2, continent, region_un, subregion et type sont des caractéristiques structurelles des pays utilisables comme covariables explicatives ; iso_a2 et name_long sont des identifiants/libellés ignorés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `area_km2` | `numeric` | continuous | 0% |
| `continent` | `character` | categorical | 0% |
| `region_un` | `character` | categorical | 0% |
| `subregion` | `character` | categorical | 0% |
| `type` | `character` | categorical | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: pending

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: Formule systeme proposee automatiquement pour benchmark spatial ; ne pas confondre avec une formule publiee.
### Formule — niveau systeme

- formula_used: lifeExp ~ area_km2 + continent + region_un + subregion + type
- x_terms_used: area_km2 + continent + region_un + subregion + type
- y_term_used: lifeExp

## Bloc 2 — Identification et DOI

- Dataset ID: `R_spData_world_world`
- Dataset name: spData::world
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
  model_family: "n/a"
  source_type: unknown
  source_ref: "null"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 177
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-110.2438, 177.9759], y [-76.6051, 79.9581] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: pending — multi-zones (span=288.2deg) -- projection nationale recommandee

## Bloc 6 — Reproductibilite

- License present: yes
- License name: CC0
- License URL: https://CRAN.R-project.org/package=spData
- License open: yes
- Reproducibility status: available via package R `spData`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (CC0).

## Related Pages

- Source: package R `spData`
