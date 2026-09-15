---
title: R_gstat_walker_walker
type: dataset
created: 2026-08-15
updated: 2026-09-07
sources:
  - data/final_datasets/sf/R_gstat_walker_walker.rds
tags: [dataset, r-package, spatial, point]
---

This is the Walker Lake data sets (sample and exhaustive data set), used in Isaaks and Srivastava's Applied Geostatistics.

## Description du jeu de donnees

- Topic: Donnees de r-package : R_gstat_walker_walker
- Observation unit: observation spatiale de type POINT
- Observed population: 470 enregistrements dans l’artefact local R_gstat_walker_walker.rds; unite declaree : observation spatiale de type POINT. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: Etendue mesuree dans le RDS : x [8, 251], y [8, 291]; CRS non renseigne, repere/unites a documenter.
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: This is the Walker Lake data sets (sample and exhaustive data set), used in Isaaks and Srivastava's Applied Geostatistics.
- Description source: package R `gstat`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `V`, `U`
- Candidate Y typology: continuous
- Candidate X variables: `T`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `Id`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `V` | `numeric` | continuous | [0, 1528.1] | 0% |
| `U` | `numeric` | continuous | [0, 5190.1] | 41.5% |


> Selection Y/X (claude-sonnet-4-6) : V et U sont les variables de concentration/mesure géostatistiques classiques du dataset Walker Lake (typiquement des teneurs en métaux), constituant des cibles naturelles pour l'interpolation spatiale ou la prédiction. T est une variable catégorielle binaire (1-2) représentant un type lithologique ou une zone, utilisable comme covariable explicative. Le taux élevé de NA sur U (41.5%) en fait par ailleurs une cible privilégiée pour la prédiction/imputation spatiale.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `T` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: not_applicable - interpolation geostatistique univariee de V (krigeage) ; U sert de variable secondaire dans des exercices de cokrigeage ailleurs dans le livre, ce n'est pas une regression OLS/GLM.
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Isaaks, E.H. & Srivastava, R.M. (1989). An Introduction to Applied Geostatistics. Oxford University Press, New York, 561 p. ISBN 978-0-19-505013-4 (titre complet corrige : la documentation gstat::walker l'appelle par raccourci "Applied Geostatistics", le vrai titre publie est "An Introduction to Applied Geostatistics"). TYPE: manuel (livre), pas un article -- aucun DOI n'existe pour un ouvrage de ce type. Lien : https://global.oup.com/academic/product/an-introduction-to-applied-geostatistics-9780195050134 (page editeur verifiee).

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

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "simple_baseline"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

  multivariate_constrained:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "paper_main_specification"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

  ml_or_selected:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "ml_candidate_features"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `R_gstat_walker_walker`
- Dataset name: gstat::walker
- Source family: r-package
- Source: package R `gstat` (version 2.1.6)
- Source URL: https://CRAN.R-project.org/package=gstat
- Dataset DOI: none
- Publication DOI: none
- Year: 2003

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "null"
  equation_family: n/a
  model_family: "n/a"
  source_type: none_found
  source_ref: "null"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 470
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [8, 251], y [8, 291] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: not_applicable (grille de terrain locale, jeu pedagogique Isaaks & Srivastava)
- CRS nom: not_applicable (coordonnees non georeferencees)
- CRS analyse recommande: not_applicable — X/Y sont des coordonnees en metres d'un jeu pedagogique (Walker Lake, Isaaks & Srivastava, Applied Geostatistics), non rattachees a un systeme geographique reel documente.

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2.0)
- License URL: https://CRAN.R-project.org/package=gstat
- License open: yes
- Reproducibility status: available via package R `gstat`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_missing_formula"
  benchmark_task: "not_current_regression_benchmark"
  package_include: "no"
  has_local_rds: true
  missing_items: "formule Y ~ X executable manquante"
  reason: "Aucune formule systeme ou publication n est disponible pour ce jeu de donnees package."
```

- Decision: not_ready_missing_formula
- Manque principal: formule Y ~ X executable manquante
- Raison: Aucune formule systeme ou publication n est disponible pour ce jeu de donnees package.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20% : U (NA=41.5%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2.0)).

## Related Pages

- Source: package R `gstat`

## Curation documentée — 2026-09-07

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

Verification 2026-09-15 (mode production de secours, tools::Rd_db("gstat")) : reference confirmee (Isaaks & Srivastava, Applied Geostatistics, Oxford University Press -- un livre, pas d'article, donc Publication DOI corrige de "pending" a "none"). Documentation confirme aussi l'absence de CRS reel : "X location in meter", "Y location in meter", sans reference geographique -- corrige de "unknown [lookup required]" a "not_applicable". formula_pub reste correctement not_applicable (interpolation geostatistique univariee, pas une regression) -- decision deja bien fondee, non modifiee.

Complement 2026-09-15 : titre complet corrige ("An Introduction to Applied Geostatistics", pas juste "Applied Geostatistics"), reference explicitement etiquetee comme un manuel, avec lien editeur verifie (Oxford University Press, ISBN 9780195050134 confirme via la recherche).
