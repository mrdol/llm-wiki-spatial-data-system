---
title: R_agridat_lasrosas.corn_lasrosas.corn
type: dataset
created: 2026-08-15
updated: 2026-08-21
sources:
  - data/final_datasets/sf/R_agridat_lasrosas.corn_lasrosas.corn.rds
  - wiki/datasets/r_package_docs/agridat/topics/lasrosas.corn.md
tags: [dataset, r-package, spatial, point, multi-campagne, source]
---

Source complete de rendement de mais Las Rosas, Argentine, contenant les campagnes 1999 et 2001. Elle est conservee comme archive de provenance, tandis que les taches de benchmark sont separees par campagne.

## Description du jeu de donnees

- Topic: agriculture / rendement de mais et fertilisation azotee
- Observation unit: cellule georeferencee de rendement agregee sur le champ experimental
- Observed population: 3 443 observations de rendement de deux campagnes de recolte, 1999 et 2001
- Geographic context: ferme Las Rosas, Rio Cuarto, province de Cordoba, Argentine
- Temporal context: deux campagnes agricoles presentes dans le meme objet source
- Source description: Yield monitor data for a corn field in Argentina with variable nitrogen.
- Description source: package R `agridat`
- Description confidence: high

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `yield`
- Candidate Y typology: continuous
- Candidate X variables: `nitro`, `topo`, `bv`, `nf`, `year`
- Candidate X typology: continuous, categorical
- Coordinates (x, y - excluded from X candidates): `lat`, `long`, `X`, `Y`
- Identifiant de panel: none documented
- Presence of imputed X: unknown (aucune imputation des covariables n'est documentee dans la source package)

### Formule - niveau publication

- formula_pub: yield ~ nitro + I(nitro^2) + topo + nitro:topo + I(nitro^2):topo (campagne 1999 uniquement)
- x_terms_pub: nitro + I(nitro^2) + topo + nitro:topo + I(nitro^2):topo
- y_term_pub: yield
- Reference publication: Anselin, Bongiovanni and Lowenberg-DeBoer (2004), DOI 10.1111/j.0002-9092.2004.00610.x

### Formule - niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: yield
- Note: aucune formule unique n'est appliquee a l'objet empile. Les specifications sont portees par les taches `1999` et `2001`.

## Bloc 2 - Identification et DOI

- Dataset ID: `R_agridat_lasrosas.corn_lasrosas.corn`
- Dataset aliases: `lasrosas_source`, `lasrosas.corn_source`
- Dataset name: agridat::lasrosas.corn, source multi-campagne
- Source family: r-package
- Source: package R `agridat` (version 1.26)
- Source URL: https://CRAN.R-project.org/package=agridat
- Dataset DOI: none
- Publication DOI: 10.1111/j.0002-9092.2004.00610.x
- Year: 1999, 2001

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): source a scinder avant benchmark
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: coupes_transversales_repetees
- N observations: 3443
- T periods: 2
- Variable temporelle: year
- N/T profile: deux_coupes_spatiales
- Note N/T: les deux campagnes ne disposent pas d'un identifiant d'unite spatiale stable permettant de confirmer un panel. Les coordonnees exactement communes sont insuffisantes pour justifier une estimation de panel. L'objet complet ne doit donc pas etre utilise directement dans les routes actuelles de benchmark.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: cellules de rendement agregees
- Temporal resolution: deux campagnes agricoles
- CRS EPSG: 32720
- CRS nom: WGS 84 / UTM zone 20S
- Spatial extent: champ experimental Las Rosas, Rio Cuarto, province de Cordoba, Argentine
- Time range: 1999-2001
- CRS analyse recommande: EPSG:32720, coordonnees metriques `X` et `Y`

## Bloc 6 - Reproductibilite

- License present: yes
- License name: GPL-2
- License URL: https://CRAN.R-project.org/package=agridat
- License open: yes
- Reproducibility status: available via package R `agridat`; decoupage reproductible par `code/r_catalog/prepare_lasrosas_benchmark_tasks.R`
- Code available: yes
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "manual_review"
  benchmark_task: "source_multicampagne_a_scinder"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "Les campagnes doivent etre traitees separement; aucun identifiant de panel stable n'est documente."
  reason: "La source complete est utile a la tracabilite, mais son empilement 1999-2001 ne constitue pas une tache de regression spatiale transversale ni un panel confirme."
```

- Decision: manual_review
- Manque principal: identifiant longitudinal et protocole de modele de panel absents
- Raison: les taches `R_agridat_lasrosas.corn_lasrosas.corn_1999` et `_2001` portent les analyses par campagne.

## Quality Control

- Variables: OK - `year` est une variable temporelle et non une covariable par defaut.
- Structure: OK - la qualification de panel a ete retiree au profit de deux coupes spatiales repetees.
- Formula: OK - formule de 1999 tracee, sans l'etendre artificiellement a 2001.
- Benchmark: BLOCKED - l'objet complet n'est pas promu dans le package.

## Related Pages

- [[R_agridat_lasrosas.corn_lasrosas.corn_1999]]
- [[R_agridat_lasrosas.corn_lasrosas.corn_2001]]
- Documentation: [[r_package_docs/agridat/topics/lasrosas.corn]]
