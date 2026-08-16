---
title: paper_dragonfly_colour_lightness
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_dragonfly_colour_lightness.rds
  - DatasetFirst_10_5061_dryad_72tp3
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Colour lightness of dragonfly assemblages across North America and Europe" (DOI 10.1111/ecog.02578).

## Description du jeu de donnees

- Topic: macroecologie / thermoregulation et couleur
- Observation unit: cellule de grille climatique
- Observed population: assemblages de libellules (Odonata: Anisoptera), Amerique du Nord et Europe, N=9966 cellules
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: Colour lightness of dragonfly assemblages across North America and Europe
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/ecog.02578
- Dataset DOI: 10.5061/dryad.72tp3
- Source URL: https://doi.org/10.5061/dryad.72tp3
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_72tp3/`
- Local sf output: `data/final_datasets/sf/paper_dragonfly_colour_lightness.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `meanRGB`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `bio1_mean`, `bio4_mean`, `bio10_mean`, `bio12_mean`, `bio18_mean`, `alt_mean`
- Candidate X count in local artifact: 6
- Candidate X typology: continuous
- Published X variables from paper: bio1_mean (temperature annuelle moyenne), bio4_mean (saisonnalite de temperature), bio10_mean (temperature moyenne du trimestre le plus chaud), bio12_mean (precipitation annuelle), bio18_mean (precipitation du trimestre le plus chaud), alt_mean (altitude)
- Published X count: 6
- Coordinates (x, y - excluded from X candidates): `lng`, `lat`
- Identifier columns (excluded from X candidates): `Cont`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `meanRGB` | `numeric` | continuous | [54.8, 128.5] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `dragonfly_colour_lightness`, la ou les reponses `meanRGB` viennent du loader papier et/ou des preuves de l article `Colour lightness of dragonfly assemblages across North America and Europe`. Les covariables X retenues sont `bio1_mean`, `bio4_mean`, `bio10_mean`, `bio12_mean`, `bio18_mean`, `alt_mean`. Les coordonnees (`lng`, `lat`), identifiants (`Cont`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `bio1_mean` | `numeric` | continuous | 0% |
| `bio4_mean` | `numeric` | continuous | 0% |
| `bio10_mean` | `numeric` | continuous | 0% |
| `bio12_mean` | `numeric` | continuous | 0% |
| `bio18_mean` | `numeric` | continuous | 0% |
| `alt_mean` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: meanRGB ~ bio1_mean + bio4_mean + bio10_mean + bio12_mean + bio18_mean + alt_mean [Modeles a erreur autoregressive (SEM) pour corriger l'autocorrelation spatiale ; regressions ajustees separement par continent (Amerique du Nord / Europe)]
- x_terms_pub: bio1_mean (temperature annuelle moyenne), bio4_mean (saisonnalite de temperature), bio10_mean (temperature moyenne du trimestre le plus chaud), bio12_mean (precipitation annuelle), bio18_mean (precipitation du trimestre le plus chaud), alt_mean (altitude)
- y_term_pub: meanRGB (luminosite/clarte de couleur moyenne de l'assemblage de libellules)
- Reference publication: Pinkert, S., Brandl, R. & Zeuss, D. (2016), Colour lightness of dragonfly assemblages across North America and Europe, Ecography, doi:10.1111/ecog.02578. CSV original (grille poolee Amerique du Nord + Europe) telecharge directement depuis le depot Dryad (10.5061/dryad.72tp3) -- pas une reconstruction, N=9966 cellules de grille. Fichier europeen (';' separateur de champs, ',' separateur decimal), lu via read.csv2. Y et X correspondent exactement aux variables bioclimatiques WorldClim decrites dans le papier.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Pinkert, S., Brandl, R. & Zeuss, D. (2016), Colour lightness of dragonfly assemblages across North America and Europe, Ecography, doi:10.1111/ecog.02578. CSV original (grille poolee Amerique du Nord + Europe) telecharge directement depuis le depot Dryad (10.5061/dryad.72tp3) -- pas une reconstruction, N=9966 cellules de grille. Fichier europeen (';' separateur de champs, ',' separateur decimal), lu via read.csv2. Y et X correspondent exactement aux variables bioclimatiques WorldClim decrites dans le papier.

### Formule - niveau systeme

- formula_used: meanRGB ~ bio1_mean + bio4_mean + bio10_mean + bio12_mean + bio18_mean + alt_mean
- x_terms_used: bio1_mean, bio4_mean, bio10_mean, bio12_mean, bio18_mean, alt_mean
- y_term_used: meanRGB
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Pinkert, S., Brandl, R. & Zeuss, D. (2016), Colour lightness of dragonfly assemblages across North America and Europe, Ecography, doi:10.1111/ecog.02578. CSV original (grille poolee Amerique du Nord + Europe) telecharge directement depuis le depot Dryad (10.5061/dryad.72tp3) -- pas une reconstruction, N=9966 cellules de grille. Fichier europeen (';' separateur de champs, ',' separateur decimal), lu via read.csv2. Y et X correspondent exactement aux variables bioclimatiques WorldClim decrites dans le papier.

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
    formula: "meanRGB ~ bio1_mean + bio4_mean + bio10_mean + bio12_mean + bio18_mean + alt_mean"
    response: "meanRGB (luminosite/clarte de couleur moyenne de l'assemblage de libellules)"
    predictors: ["bio1_mean (temperature annuelle moyenne)", "bio4_mean (saisonnalite de temperature)", "bio10_mean (temperature moyenne du trimestre le plus chaud)", "bio12_mean (precipitation annuelle)", "bio18_mean (precipitation du trimestre le plus chaud)", "alt_mean (altitude)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Pinkert, S., Brandl, R. & Zeuss, D. (2016), Colour lightness of dragonfly assemblages across North America and Europe, Ecography, doi:10.1111/ecog.02578. CSV original (grille poolee Amerique du Nord + Europe) telecharge directement depuis le depot Dryad (10.5061/dryad.72tp3) -- pas une reconstruction, N=9966 cellules de grille. Fichier europeen (';' separateur de champs, ',' separateur decimal), lu via read.csv2. Y et X correspondent exactement aux variables bioclimatiques WorldClim decrites dans le papier."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "meanRGB ~ bio1_mean + bio4_mean + bio10_mean + bio12_mean + bio18_mean + alt_mean"
    response: "meanRGB"
    predictors: ["bio1_mean", "bio4_mean", "bio10_mean", "bio12_mean", "bio18_mean", "alt_mean"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Pinkert, S., Brandl, R. & Zeuss, D. (2016), Colour lightness of dragonfly assemblages across North America and Europe, Ecography, doi:10.1111/ecog.02578. CSV original (grille poolee Amerique du Nord + Europe) telecharge directement depuis le depot Dryad (10.5061/dryad.72tp3) -- pas une reconstruction, N=9966 cellules de grille. Fichier europeen (';' separateur de champs, ',' separateur decimal), lu via read.csv2. Y et X correspondent exactement aux variables bioclimatiques WorldClim decrites dans le papier."
    estimator_context: ["sem_error", "sar_lag", "ols", "gwr"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_dragonfly_colour_lightness`
- Dataset name: Data from: Colour lightness of dragonfly assemblages across North America and Europe
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Colour lightness of dragonfly assemblages across North America and Europe
- Paper DOI: 10.1111/ecog.02578
- Dataset DOI: 10.5061/dryad.72tp3
- Source URL: https://doi.org/10.5061/dryad.72tp3
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "meanRGB ~ bio1_mean + bio4_mean + bio10_mean + bio12_mean + bio18_mean + alt_mean [Modeles a erreur autoregressive (SEM) pour corriger l'autocorrelation spatiale ; regressions ajustees separement par continent (Amerique du Nord / Europe)]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Pinkert, S., Brandl, R. & Zeuss, D. (2016), Colour lightness of dragonfly assemblages across North America and Europe, Ecography, doi:10.1111/ecog.02578. CSV original (grille poolee Amerique du Nord + Europe) telecharge directement depuis le depot Dryad (10.5061/dryad.72tp3) -- pas une reconstruction, N=9966 cellules de grille. Fichier europeen (';' separateur de champs, ',' separateur decimal), lu via read.csv2. Y et X correspondent exactement aux variables bioclimatiques WorldClim decrites dans le papier."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun -- CSV original telecharge directement depuis Dryad, N=9966 identique au depot source"
  reason: "Y continu reel (meanRGB, clarte de couleur), N=9966 cellules de grille avec coordonnees reelles, 6 covariables bioclimatiques WorldClim exactes du papier. CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) pour confirmer la formule (SEM, modele a erreur autoregressive). Papier recupere manuellement par l'utilisateur (session 2026-08-16)."
```

- Decision: ready
- Manque principal: aucun -- CSV original telecharge directement depuis Dryad, N=9966 identique au depot source
- Raison: Y continu reel (meanRGB, clarte de couleur), N=9966 cellules de grille avec coordonnees reelles, 6 covariables bioclimatiques WorldClim exactes du papier. CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) pour confirmer la formule (SEM, modele a erreur autoregressive). Papier recupere manuellement par l'utilisateur (session 2026-08-16).

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready"
  eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
  conditionally_eligible_estimators: []
  ineligible_reason: ""
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 9966
- k variables: 12
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-155.5, 29.6], y [25, 71]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=185.1deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`dragonfly_colour_lightness` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `dragonfly_colour_lightness` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`dragonfly_colour_lightness` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Colour lightness of dragonfly assemblages across North America and Europe

