---
title: R_agridat_lasrosas.corn_lasrosas.corn
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/R_agridat_lasrosas.corn_lasrosas.corn.rds
tags: [dataset, r-package, spatial, point]
---

Yield monitor data for a corn field in Argentina with variable nitrogen.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `yield`
- Candidate Y typology: continuous
- Candidate X variables: `nitro`, `topo`, `bv`, `nf`, `year`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `lat`, `long`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `yield` | `numeric` | continuous | [12.66, 117.9] | 0% |


> Selection Y/X (claude-sonnet-4-6) : yield (rendement en maïs) est la variable réponse naturelle d'un moniteur de rendement. nitro (dose d'azote variable), topo (position topographique), bv (valeur liée au sol/bassin versant), nf (facteur azote) et year (année de campagne) sont des covariables explicatives agronomiques et environnementales pertinentes. La colonne T est ignorée car elle semble redondante avec year (même plage [1999,2001]), et rep est un identifiant de répétition expérimentale de nature purement administrative.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `nitro` | `numeric` | continuous | 0% |
| `topo` | `factor` | categorical | 0% |
| `bv` | `numeric` | continuous | 0% |
| `nf` | `factor` | categorical | 0% |
| `year` | `integer` | count | 0% |


### Formule — niveau publication

- formula_pub: YIELD~N+N2+TOPO/TOP2-4+NXTOPz
- x_terms_pub: N+N2+TOPO/TOP2-4+NXTOPz
- y_term_pub: YIELD
- Reference publication: geodacenter.github.io/data-and-lab/lasrosas/ ; DOI:10.1111/j.0002-9092.2004.00610.x

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: SEM heteroskedastique
- Correspondance Python/R: Python_geodatasets_geoda.lasrosas
- Note: Formule identifiee via l'homologue Python geodatasets::geoda.lasrosas — meme jeu de donnees sous-jacent (essai agronomique La Rosas, Cordoba, Argentine).

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_agridat_lasrosas.corn_lasrosas.corn`
- Dataset name: agridat::lasrosas.corn
- Source family: r-package
- Source: package R `agridat` (version 1.26)
- Source URL: https://CRAN.R-project.org/package=agridat
- Dataset DOI: none
- Publication DOI: pending
- Year: 2011

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "YIELD~N+N2+TOPO/TOP2-4+NXTOPz"
  equation_family: spatial_error
  model_family: "SEM heteroskedastique"
  source_type: software_documentation
  source_ref: "geodacenter.github.io/data-and-lab/lasrosas/ ; DOI:10.1111/j.0002-9092.2004.00610.x"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatio-temporel
- Structure: panel
- N observations: 3443
- T periods: 2
- Variable temporelle: year
- N/T profile: N_grand_T_moyen

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: pending inspection
- Spatial extent: x [-63.8489, -63.8417], y [-33.0523, -33.0488] (CRS unknown)
- Time range: pending inspection
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: MIT + file LICENSE
- License URL: https://CRAN.R-project.org/package=agridat
- License open: yes
- Reproducibility status: available via package R `agridat`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

WARN: CRS absent — lookup EPSG necessaire.

## Related Pages

- Source: package R `agridat`
