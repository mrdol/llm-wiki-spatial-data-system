---
title: R_agridat_lasrosas.corn_lasrosas.corn_2001
type: dataset
created: 2026-08-21
updated: 2026-08-21
sources:
  - data/final_datasets/sf/R_agridat_lasrosas.corn_lasrosas.corn_2001.rds
  - wiki/datasets/r_package_docs/agridat/topics/lasrosas.corn.md
tags: [dataset, r-package, spatial, point, coupe-transversale, agriculture]
---

Coupe spatiale de 2001 du champ de mais Las Rosas, conservee comme tache distincte en attente d'une specification scientifique aussi precise que celle de 1999.

## Description du jeu de donnees

- Topic: agriculture / rendement de mais et fertilisation azotee
- Observation unit: cellule georeferencee de rendement agregee sur le champ experimental
- Observed population: 1 705 cellules de rendement de la campagne 2001 de la ferme Las Rosas, Rio Cuarto, Cordoba, Argentine
- Geographic context: ferme Las Rosas, Rio Cuarto, province de Cordoba, Argentine
- Temporal context: campagne de recolte 2001 uniquement
- Source description: Yield monitor data for a corn field in Argentina with variable nitrogen.
- Description source: package R `agridat`
- Description confidence: medium

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `yield`
- Candidate Y typology: continuous
- Candidate X variables: `nitro`, `topo`, `bv`, `nf`, `rep`
- Candidate X typology: continuous, categorical
- Coordinates (x, y - excluded from X candidates): `X`, `Y`
- Variable temporelle conservee comme trace de provenance: `year` (constante a 2001 dans cette tache)
- Presence of imputed X: unknown (aucune imputation des covariables n'est documentee dans la source package)

### Formule - niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: yield
- Reference publication: la documentation `agridat` signale des resultats de Bongiovanni and Lowenberg-DeBoer (2002), sans specification complete verifiee dans le corpus actuel.

### Formule - niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: yield
- Note: les doses d'azote different legerement de celles de 1999. La formule 1999 ne doit pas etre promue automatiquement comme formule publiee de 2001.

## Bloc 2 - Identification et DOI

- Dataset ID: `R_agridat_lasrosas.corn_lasrosas.corn_2001`
- Parent dataset: `R_agridat_lasrosas.corn_lasrosas.corn`
- Dataset name: agridat::lasrosas.corn, campagne 2001
- Source family: r-package
- Source: package R `agridat` (version 1.26)
- Source URL: https://CRAN.R-project.org/package=agridat
- Dataset DOI: none
- Publication DOI: pending
- Year: 2001

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression spatiale continue en coupe, a documenter
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 1705
- T periods: 1
- Variable temporelle: year (fixee a 2001)
- N/T profile: N_grand_T_1
- Note N/T: cette campagne est separee de 1999. Aucun identifiant d'unite stable n'est documente pour justifier un modele de panel sur les deux fichiers.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: cellules de rendement agregees
- Temporal resolution: une campagne agricole
- CRS EPSG: 32720
- CRS nom: WGS 84 / UTM zone 20S
- Spatial extent: champ experimental Las Rosas, Rio Cuarto, province de Cordoba, Argentine
- Time range: 2001
- CRS analyse recommande: EPSG:32720, coordonnees metriques `X` et `Y`

## Bloc 6 - Reproductibilite

- License present: yes
- License name: GPL-2
- License URL: https://CRAN.R-project.org/package=agridat
- License open: yes
- Reproducibility status: tache derivee de la source package par `code/r_catalog/prepare_lasrosas_benchmark_tasks.R`
- Code available: yes
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "manual_review"
  benchmark_task: "regression_spatiale_continue_coupe_2001"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "Formule et estimation de reference 2001 a verifier dans une source scientifique complete."
  reason: "La campagne est une coupe transversale exploitable, mais la preuve de modelisation disponible est moins precise que pour 1999."
```

- Decision: manual_review
- Manque principal: specification scientifique 2001 a verifier
- Raison: la campagne est conservee sans etre promue ni fusionnee avec 1999.

## Quality Control

- Source campaign: OK - filtre `year == 2001` verifie sur le fichier source.
- Sample size: OK - 1 705 observations.
- Structure: OK - coupe transversale, T = 1.
- Formula: PENDING - pas de formule de reference 2001 verifiee.

## Related Pages

- [[R_agridat_lasrosas.corn_lasrosas.corn]]
- [[R_agridat_lasrosas.corn_lasrosas.corn_1999]]
- Documentation: [[r_package_docs/agridat/topics/lasrosas.corn]]
