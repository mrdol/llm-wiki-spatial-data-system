---
title: R_spDataLarge_lsl_lsl
type: dataset
created: 2026-07-10
updated: 2026-07-10
sources:
  - data/final_datasets/sf/R_spDataLarge_lsl_lsl.rds
tags: [dataset, r-package, spatial, point]
---

Data used in the "Statistical learning for geographic data" chapter in Geocomputation with R. See <https://r.geocompx.org/spatial-cv.html> for details.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `lslpts`
- Candidate Y typology: categorical
- Candidate X variables: `slope`, `cplan`, `cprof`, `elev`, `log10_carea`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `lslpts` | `factor` | categorical | None | 0% |


> Selection Y/X (claude-sonnet-4-6) : lslpts est la variable réponse binaire/catégorielle indiquant la présence/absence de glissements de terrain (landslide points), typique d'un problème de classification spatiale. Les cinq autres colonnes sont des variables topographiques continues (pente, courbures planaire et profilée, altitude, aire de contribution drainée) qui constituent les covariables explicatives classiques pour modéliser la susceptibilité aux glissements de terrain.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `slope` | `numeric` | continuous | 0% |
| `cplan` | `numeric` | continuous | 0% |
| `cprof` | `numeric` | continuous | 0% |
| `elev` | `numeric` | continuous | 0% |
| `log10_carea` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: lslpts ~ slope + cplan + cprof + elev + log10_carea
- x_terms_pub: slope, cplan, cprof, elev, log10_carea
- y_term_pub: lslpts
- Reference publication: Muenchow, J., Brenning, A., Richter, R. (2012) Geomorphic process rates of landslides along a humidity gradient in the tropical Andes. Geomorphology 139-140, 271-284.

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

- Dataset ID: `R_spDataLarge_lsl_lsl`
- Dataset name: spDataLarge::lsl
- Source family: r-package
- Source: package R `spDataLarge` (version 2.2.0)
- Source URL: https://CRAN.R-project.org/package=spDataLarge
- Dataset DOI: none
- Publication DOI: 10.1016/j.geomorph.2011.10.029
- Year: 2017

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "lslpts ~ slope + cplan + cprof + elev + log10_carea"
  equation_family: unknown
  model_family: "n/a"
  source_type: unknown
  source_ref: "Muenchow, J., Brenning, A., Richter, R. (2012) Geomorphic process rates of landslides along a humidity gradient in the tropical Andes. Geomorphology 139-140, 271-284."
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 350
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [712197.7269, 715737.7269], y [9556946.76, 9560806.76] (EPSG:32717, via documentation)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 32717 (source: documentation du package, .rds sans CRS embarque)
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: CC0
- License URL: https://CRAN.R-project.org/package=spDataLarge
- License open: yes
- Reproducibility status: available via package R `spDataLarge`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: WARN - CRS absent du `.rds` source ; EPSG:32717 extrait de la documentation et reporte dans le Bloc 5.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (CC0).

## Related Pages

- Source: package R `spDataLarge`
