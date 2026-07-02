---
title: R_spData_world_world
type: dataset
created: 2026-06-30
updated: 2026-07-02
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

- formula_pub: lifeExp~log(gdpPercap)
- x_terms_pub: log(gdpPercap)
- y_term_pub: lifeExp
- Reference publication: Preston S.H. (1975), The changing relation between mortality and level of economic development, Population Studies 29(2):231-248

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: candidat par analogie -- non verifie
- Niveau de preuve: analogie
- Methode d'estimation: OLS (courbe de Preston)
- Correspondance Python/R: aucune identifiee
- Note: CANDIDAT PAR ANALOGIE -- non verifie sur ce jeu precis. Il ne s'agit pas d'une analogie avec un autre dataset de la banque, mais d'une relation canonique tres documentee dans la litterature demographique/econometrique (courbe de Preston, esperance de vie ~ log(PIB par habitant)) directement applicable a ce type de donnees pays (memes variables : lifeExp, gdpPercap). Non confirme specifiquement pour la version rnaturalearth/spData::world de ces variables.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

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
  existing_model_found: true
  equation_text: "lifeExp~log(gdpPercap)"
  equation_family: linear
  model_family: "OLS (courbe de Preston)"
  source_type: unknown
  source_ref: "Preston S.H. (1975), The changing relation between mortality and level of economic development, Population Studies 29(2):231-248"
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

Aucune anomalie detectee.

## Related Pages

- Source: package R `spData`
