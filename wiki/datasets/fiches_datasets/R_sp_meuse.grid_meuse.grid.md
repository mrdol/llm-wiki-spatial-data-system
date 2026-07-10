---
title: R_sp_meuse.grid_meuse.grid
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/R_sp_meuse.grid_meuse.grid.rds
tags: [dataset, r-package, spatial, point]
---

The ‘meuse.grid’ data frame has 3103 rows and 7 columns; a grid with 40 m x 40 m spacing that covers the Meuse study area (see meuse)

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `dist`
- Candidate Y typology: rate
- Candidate X variables: `part.a`, `part.b`, `soil`, `ffreq`
- Candidate X typology: categorical
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `dist` | `numeric` | rate | [0, 0.9926] | 0% |


> Selection Y/X (claude-sonnet-4-6) : dist (distance normalisée à la rivière Meuse) est une variable continue naturellement modélisable comme réponse spatiale. part.a, part.b (indicatrices de partition spatiale), soil (type de sol) et ffreq (fréquence d'inondation) sont des covariables explicatives classiques du contexte fluvial de Meuse.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `part.a` | `numeric` | binary | 0% |
| `part.b` | `numeric` | binary | 0% |
| `soil` | `factor` | categorical | 0% |
| `ffreq` | `factor` | categorical | 0% |


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
- Note: Grille de prediction (covariables uniquement, pas d'observations de la variable reponse) utilisee pour le krigeage universel de `meuse`/`meuse.all` — pas un jeu de regression autonome. [Revue Tache 4 (2026-07-02) : aucune analogie structurelle pertinente identifiee avec un bon candidat existant -- statut inchange plutot que forcer un rapprochement faible.] Raison : Grille de prediction (covariables uniquement, pas de Y observe) -- pas un jeu de regression autonome par construction.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_sp_meuse.grid_meuse.grid`
- Dataset name: sp::meuse.grid
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
- N observations: 3103
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [178460, 181540], y [329620, 333740] (EPSG:28992, via documentation)
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
