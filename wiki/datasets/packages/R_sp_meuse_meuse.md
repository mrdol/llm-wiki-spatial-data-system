---
title: R_sp_meuse_meuse
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/R_sp_meuse_meuse.rds
tags: [dataset, r-package, spatial, point]
---

This data set gives locations and topsoil heavy metal concentrations, along with a number of soil and landscape variables at the observation locations, collected in a flood plain of the river Meuse, near the village of Stein (NL). Heavy metal concentrations are from composite samples of an area of approximately 15 m x 15 m.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `cadmium`, `copper`, `lead`, `zinc`
- Candidate Y typology: continuous
- Candidate X variables: `elev`, `dist`, `om`, `ffreq`, `soil`, `lime`, `landuse`, `dist.m`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `cadmium` | `numeric` | continuous | [0.2, 18.1] | 0% |
| `copper` | `numeric` | continuous | [14, 128] | 0% |
| `lead` | `numeric` | continuous | [37, 654] | 0% |
| `zinc` | `numeric` | continuous | [113, 1839] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les concentrations en métaux lourds (cadmium, copper, lead, zinc) sont les variables réponses naturelles de ce dataset de pollution des sols, classiquement modélisées en géostatistique et spatial ML. Les variables topographiques (elev, dist, dist.m), pédologiques (soil, om, lime) et d'occupation du sol (landuse, ffreq) sont des covariables explicatives reflétant les processus de dépôt alluvial et d'accumulation des métaux.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `elev` | `numeric` | continuous | 0% |
| `dist` | `numeric` | rate | 0% |
| `om` | `numeric` | continuous | 1.3% |
| `ffreq` | `factor` | categorical | 0% |
| `soil` | `factor` | categorical | 0% |
| `lime` | `factor` | categorical | 0% |
| `landuse` | `factor` | categorical | 0.6% |
| `dist.m` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: log(zinc)~sqrt(dist) (idem cadmium/lead/copper)
- x_terms_pub: sqrt(dist) (idem cadmium/lead/copper)
- y_term_pub: log(zinc)
- Reference publication: Tutoriel officiel gstat (Pebesma)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: OLS + krigeage universel
- Correspondance Python/R: R_gstat_meuse.all_meuse.all
- Note: Formule identifiee via l'homologue R_gstat_meuse.all — meme jeu de donnees sous-jacent (metaux lourds riviere Meuse), distribue ici via le package sp (objet SpatialPointsDataFrame) plutot que gstat.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_sp_meuse_meuse`
- Dataset name: sp::meuse
- Source family: r-package
- Source: package R `sp` (version 2.2.1)
- Source URL: https://CRAN.R-project.org/package=sp
- Dataset DOI: none
- Publication DOI: pending
- Year: 2005

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "log(zinc)~sqrt(dist) (idem cadmium/lead/copper)"
  equation_family: unknown
  model_family: "OLS + krigeage universel"
  source_type: software_documentation
  source_ref: "Tutoriel officiel gstat (Pebesma)"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 155
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [178605, 181390], y [329714, 333611] (EPSG:28992, via documentation)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 28992 (source: documentation du package, .rds sans CRS embarque)
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://CRAN.R-project.org/package=sp
- License open: yes
- Reproducibility status: available via package R `sp`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

WARN: CRS absent — lookup EPSG necessaire.

## Related Pages

- Source: package R `sp`
