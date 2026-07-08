---
title: R_spaMM_Leuca_Leuca
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/R_spaMM_Leuca_Leuca.rds
tags: [dataset, r-package, spatial, point]
---

A data set from Tonnabel et al. (2021) to be fitted by models with sex-specific spatial random effects. Leucadrendron rubrum is a dioecious shrub from South Africa. Various phenotypes were recorded on individuals from a small patch of habitat.

## Bloc 1 â€” Formule et variables

### Variables (niveau systeme â€” inspection directe du sf)

- Candidate Y variables: `fec`, `fec_div`, `area`, `diam`
- Candidate Y typology: continuous, count
- Candidate X variables: `sex`, `diamZ`, `areaZ`, `male`, `female`
- Candidate X typology: categorical, continuous
- Coordinates (x, y â€” excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto â€” export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `fec` | `numeric` | continuous | [0.0052, 15.6166] | 0% |
| `fec_div` | `numeric` | continuous | [0.0051, 15.372] | 0% |
| `area` | `numeric` | continuous | [0.2129, 1.4847] | 0% |
| `diam` | `integer` | count | [18, 198] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables phÃ©notypiques comme la fÃ©conditÃ© (fec, fec_div) et les mesures de taille (area, diam) sont des rÃ©ponses biologiques plausibles dans un contexte d'Ã©cologie des plantes. Le sexe (sex, male, female) est une covariable explicative clÃ© pour des modÃ¨les avec effets spatiaux sex-spÃ©cifiques, tandis que diamZ et areaZ sont des versions standardisÃ©es des traits morphologiques utilisables comme covariables ; name est ignorÃ© car purement administratif, et on Ã©vite de placer simultanÃ©ment diam/area et leurs versions standardisÃ©es du mÃªme cÃ´tÃ©.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `sex` | `factor` | categorical | 0% |
| `diamZ` | `numeric` | continuous | 0% |
| `areaZ` | `numeric` | continuous | 0% |
| `male` | `logical` | binary | 0% |
| `female` | `logical` | binary | 0% |


### Formule â€” niveau publication

- formula_pub: fec_div ~ sex + Matern(1|x+y %in% sex)
- x_terms_pub: sex + Matern(1|x+y %in% sex)
- y_term_pub: fec_div
- Reference publication: Tonnabel J. et al. (2021) Sex-specific spatial variation in fitness in the highly dimorphic Leucadendron rubrum. Molecular Ecology, 30:1721-1735. DOI:10.1111/mec.15833

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: GLMM geostatistique (effet spatial Matern sexe-specifique)
- Correspondance Python/R: aucune identifiee
- Note: Formule deja presente (enrichissement anterieur), coherente avec le DOI Bloc 2 et les colonnes reelles.

### Formule â€” niveau systeme

- formula_used: fec_div ~ sex + Matern(1|x+y %in% sex)
- x_terms_used: sex + Matern(1|x+y %in% sex)
- y_term_used: fec_div
## Bloc 2 â€” Identification et DOI

- Dataset ID: `R_spaMM_Leuca_Leuca`
- Dataset name: spaMM::Leuca
- Source family: r-package
- Source: package R `spaMM` (version 4.6.65)
- Source URL: https://CRAN.R-project.org/package=spaMM
- Dataset DOI: none
- Publication DOI: 10.1111/mec.15833
- Year: 2013

## Bloc 3 â€” Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "fec_div ~ sex + Matern(1|x+y %in% sex)"
  equation_family: generalized_linear
  model_family: "GLMM geostatistique (effet spatial Matern sexe-specifique)"
  source_type: software_documentation
  source_ref: "Tonnabel J. et al. (2021) Sex-specific spatial variation in fitness in the highly dimorphic Leucadendron rubrum. Molecular Ecology, 30:1721-1735. DOI:10.1111/mec.15833"
  confidence: high
```

## Bloc 4 â€” Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 156
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 â€” Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [0.5, 68], y [0.5, 102] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending â€” CRS source non geographique ou inconnu

## Bloc 6 â€” Reproductibilite

- License present: yes
- License name: CeCILL-2
- License URL: https://CRAN.R-project.org/package=spaMM
- License open: yes
- Reproducibility status: available via package R `spaMM`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

WARN: CRS absent â€” lookup EPSG necessaire.

## Related Pages

- Source: package R `spaMM`
