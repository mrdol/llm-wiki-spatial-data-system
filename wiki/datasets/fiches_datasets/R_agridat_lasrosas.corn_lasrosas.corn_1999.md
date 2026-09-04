---
title: R_agridat_lasrosas.corn_lasrosas.corn_1999
type: dataset
created: 2026-08-21
updated: 2026-08-21
sources:
  - data/final_datasets/sf/R_agridat_lasrosas.corn_lasrosas.corn_1999.rds
  - corpus/papers/raw_pdf/Anselin-SpatialEconometricApproach-2004.pdf
tags: [dataset, r-package, spatial, point, coupe-transversale, agriculture]
---

Coupe spatiale de 1999 du champ de mais Las Rosas, Argentine, utilisee dans l'analyse econometrique spatiale d'Anselin, Bongiovanni et Lowenberg-DeBoer (2004).

## Description du jeu de donnees

- Topic: agriculture / rendement de mais et fertilisation azotee
- Observation unit: cellule georeferencee de rendement agregee sur le champ experimental
- Observed population: 1 738 cellules de rendement de la campagne 1998-1999 de la ferme Las Rosas, Rio Cuarto, Cordoba, Argentine
- Geographic context: ferme Las Rosas, Rio Cuarto, province de Cordoba, Argentine
- Temporal context: campagne de recolte 1999 uniquement
- Source description: Yield monitor data for a corn field in Argentina with variable nitrogen.
- Description source: package R `agridat` et Anselin, Bongiovanni and Lowenberg-DeBoer (2004)
- Description confidence: high

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `yield`
- Candidate Y typology: continuous
- Candidate X variables: `nitro`, `topo`, `bv`, `nf`, `rep`
- Candidate X typology: continuous, categorical
- Coordinates (x, y - excluded from X candidates): `X`, `Y`
- Variable temporelle conservee comme trace de provenance: `year` (constante a 1999 dans cette tache)
- Presence of imputed X: unknown (aucune imputation des covariables n'est documentee dans la source package)

### Formule - niveau publication

- formula_pub: yield ~ nitro + I(nitro^2) + topo + nitro:topo + I(nitro^2):topo
- x_terms_pub: nitro + I(nitro^2) + topo + nitro:topo + I(nitro^2):topo
- y_term_pub: yield
- Reference publication: Anselin, Bongiovanni and Lowenberg-DeBoer (2004), DOI 10.1111/j.0002-9092.2004.00610.x

### Formule - niveau systeme

- formula_used: yield ~ nitro + I(nitro^2) + topo + nitro:topo + I(nitro^2):topo
- x_terms_used: nitro + I(nitro^2) + topo + nitro:topo + I(nitro^2):topo
- y_term_used: yield
- Note: la formule reproduit la specification quadratique a coefficients variant selon les quatre zones topographiques. La formule simplifiee `yield ~ nitro + bv` est conservee dans l'historique du projet mais n'est plus la formule par defaut de cette tache.

### Formules candidates

```yaml
formula_candidates:
  paper_main_specification:
    formula: "yield ~ nitro + I(nitro^2) + topo + nitro:topo + I(nitro^2):topo"
    response: "yield"
    predictors: ["nitro", "I(nitro^2)", "topo", "nitro:topo", "I(nitro^2):topo"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Anselin, Bongiovanni and Lowenberg-DeBoer (2004), DOI 10.1111/j.0002-9092.2004.00610.x"
    status: "confirmed"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `R_agridat_lasrosas.corn_lasrosas.corn_1999`
- Parent dataset: `R_agridat_lasrosas.corn_lasrosas.corn`
- Dataset aliases: `lasrosas`, `lasrosas_1999`, `lasrosas.corn`, `Python_geodatasets_geoda.lasrosas`
- Dataset name: agridat::lasrosas.corn, campagne 1999
- Source family: r-package
- Source: package R `agridat` (version 1.26)
- Source URL: https://CRAN.R-project.org/package=agridat
- Dataset DOI: none
- Publication DOI: 10.1111/j.0002-9092.2004.00610.x
- Year: 1999

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression spatiale continue en coupe
- Modele niveau 2 (famille): regression quadratique avec regimes spatiaux et erreur spatiale
- Modele niveau 3 (variante): SEM avec heteroscedasticite par groupe dans l'article

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "yield ~ nitro + I(nitro^2) + topo + nitro:topo + I(nitro^2):topo"
  equation_family: regression_spatiale
  model_family: "spatial error model (SEM), regimes spatiaux et heteroscedasticite par zone topographique"
  source_type: scientific_publication
  source_ref: "Anselin, Bongiovanni and Lowenberg-DeBoer (2004), pp. 678-684, DOI 10.1111/j.0002-9092.2004.00610.x"
  confidence: high
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 1738
- T periods: 1
- Variable temporelle: year (fixee a 1999)
- N/T profile: N_grand_T_1
- Note N/T: l'article publie analyse cette seule campagne. La matrice de voisinage doit etre construite sur ces 1 738 cellules et non sur les deux campagnes empilees.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: cellules de rendement issues d'une grille de 9.8 x 9.8 m, pivotee de 10.5 degres dans l'article
- Temporal resolution: une campagne agricole
- CRS EPSG: 32720
- CRS nom: WGS 84 / UTM zone 20S
- Spatial extent: champ experimental Las Rosas, Rio Cuarto, province de Cordoba, Argentine
- Time range: 1999
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
  benchmark_status: "ready"
  benchmark_task: "regression_spatiale_continue_coupe_1999"
  package_include: "yes"
  has_local_rds: true
  missing_items: "La matrice rook/queen exacte de l'article n'est pas encore reconstruite; le benchmark documente sa W kNN lorsqu'il utilise une autre construction."
  reason: "La campagne 1999 correspond aux 1 738 cellules de l'article de 2004 et dispose d'une formule publiee, de coordonnees metriques et d'une cible continue."
```

- Decision: ready
- Manque principal: reconstruction eventuelle de la W rook/queen de l'article pour une replication stricte
- Raison: la tache est une coupe transversale explicite et ne melange plus les campagnes 1999 et 2001.

## Estimator eligibility

```yaml
estimator_eligibility:
  - estimator: ols
    basis: scientific_evidence
    source_ref: "Anselin, Bongiovanni and Lowenberg-DeBoer (2004), pp. 679-684."
    pages: "679-684"
  - estimator: sem_error
    basis: scientific_evidence
    source_ref: "Anselin, Bongiovanni and Lowenberg-DeBoer (2004), pp. 678-684; modele a erreur spatialement autoregressive."
    pages: "678-684"
  - estimator: sar_lag
    basis: benchmark_use
    source_ref: "L'article effectue une recherche de specification lag versus erreur avant de retenir l'erreur spatiale."
  - estimator: gam_spatial
    basis: benchmark_use
    source_ref: "Comparateur souple pour une relation rendement-azote spatialement structuree."
  - estimator: random_forest
    basis: benchmark_use
    source_ref: "Comparateur predictif non lineaire du benchmark."
  - estimator: xgboost
    basis: benchmark_use
    source_ref: "Comparateur predictif non lineaire du benchmark."
  - estimator: mgwrsar_gwr
    basis: benchmark_use
    source_ref: "Comparateur local pour la prediction a proximite dans le champ."
```

## Quality Control

- Source campaign: OK - filtre `year == 1999` verifie sur le fichier source.
- Sample size: OK - 1 738 observations, identique a l'echantillon publie apres agregation sur grille.
- Formula: OK - specification principale de l'article de 2004.
- Structure: OK - coupe transversale, T = 1.
- Spatial support: OK - coordonnees metriques `X` et `Y` disponibles.

## Related Pages

- [[R_agridat_lasrosas.corn_lasrosas.corn]]
- Documentation: [[r_package_docs/agridat/topics/lasrosas.corn]]
