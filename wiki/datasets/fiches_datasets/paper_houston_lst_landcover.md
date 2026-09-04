---
title: paper_houston_lst_landcover
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_houston_lst_landcover.rds
  - DatasetFirst_10_5061_dryad_fbg79cnt2
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Physically constrained spatiotemporal modeling: generating clear-sky constructions of land surface temperature from sparse, remotely sensed satellite data" (DOI 10.1080/02664763.2019.1681384).

## Description du jeu de donnees

- Topic: climatologie urbaine / ilot de chaleur urbain
- Observation unit: pixel de grille satellite
- Observed population: grille de temperature de surface (LST) et couverture du sol, Houston, Texas, N=19059 pixels
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: Physically constrained spatiotemporal modeling: generating clear-sky constructions of land surface temperature from sparse, remotely sensed satellite data
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1080/02664763.2019.1681384
- Dataset DOI: 10.5061/dryad.fbg79cnt2
- Source URL: https://doi.org/10.5061/dryad.fbg79cnt2
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_fbg79cnt2/`
- Local sf output: `data/final_datasets/sf/paper_houston_lst_landcover.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `LST_kelvin`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `land_cover`
- Candidate X count in local artifact: 1
- Candidate X typology: categorical
- Published X variables from paper: land_cover (categorie de couverture du sol par pixel : cropland, forest, grassland, other, savanna, urban)
- Published X count: 1
- Coordinates (x, y - excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `LST_kelvin` | `numeric` | continuous | [295.68, 301.72] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `houston_lst_landcover`, la ou les reponses `LST_kelvin` viennent du loader papier et/ou des preuves de l article `Physically constrained spatiotemporal modeling: generating clear-sky constructions of land surface temperature from sparse, remotely sensed satellite data`. Les covariables X retenues sont `land_cover`. Les coordonnees (`lon`, `lat`), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `land_cover` | `character` | categorical | 0% |

### Formule - niveau publication

- formula_pub: [Le papier construit un modele spatiotemporel physiquement contraint sur l'ensemble des 27 passages satellite pour combler les zones nuageuses (clear-sky reconstruction) de la temperature de surface (LST) ; il ne publie pas de regression Y~X statique unique -- la relation LST~couverture du sol est neanmoins directement mesurable dans les donnees deposees (grille appariee lat/lon/land_cover/LST par passage satellite)]
- x_terms_pub: land_cover (categorie de couverture du sol par pixel : cropland, forest, grassland, other, savanna, urban)
- y_term_pub: LST_kelvin (temperature de surface terrestre, degres Kelvin, passage satellite du 2014-07-01 22:06 UTC, couverture non-nuageuse la plus complete parmi les 27 passages disponibles : 19059/22801 pixels)
- Reference publication: Chang & Wikle (2019), Physically constrained spatiotemporal modeling: generating clear-sky constructions of land surface temperature from sparse, remotely sensed satellite data, Journal of Applied Statistics, doi:10.1080/02664763.2019.1681384. Le papier reconstruit les zones nuageuses de LST par modele spatiotemporel a contrainte physique sur toute la sequence de 27 passages satellite (pas de formule Y~X statique). Les fichiers deposes fournissent une grille 151x151 de latitude, longitude, couverture du sol et LST par passage -- formula_used utilise le passage avec la meilleure couverture non-nuageuse (2014-07-01 22:06 UTC) comme coupe transversale ile-de-chaleur urbaine (LST~land_cover), une simplification documentee du probleme spatiotemporel complet du papier. Donnees brutes (Phoenix_Houston_LST_Dryad.zip, sous-dossier Houston) telechargees directement depuis Dryad (10.5061/dryad.fbg79cnt2) -- pas une reconstruction, grille reelle sur Houston, Texas.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: LST_kelvin ~ land_cover
- x_terms_used: land_cover
- y_term_used: LST_kelvin
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "LST_kelvin ~ land_cover"
    response: "LST_kelvin (temperature de surface terrestre, degres Kelvin, passage satellite du 2014-07-01 22:06 UTC, couverture non-nuageuse la plus complete parmi les 27 passages disponibles : 19059/22801 pixels)"
    predictors: ["land_cover (categorie de couverture du sol par pixel : cropland, forest, grassland, other, savanna, urban)"]
    role: "simple_baseline"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "spatial_baseline"]
    status: "confirmed"

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
    formula: "LST_kelvin ~ land_cover"
    response: "LST_kelvin"
    predictors: ["land_cover"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "gam_spatial", "random_forest", "gwr"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_houston_lst_landcover`
- Dataset name: Summer land surface temperature from MODIS Aqua and Terra satellites for Houston in 2014 and Phoenix in 2003 at 1km resolution
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Physically constrained spatiotemporal modeling: generating clear-sky constructions of land surface temperature from sparse, remotely sensed satellite data
- Paper DOI: 10.1080/02664763.2019.1681384
- Dataset DOI: 10.5061/dryad.fbg79cnt2
- Source URL: https://doi.org/10.5061/dryad.fbg79cnt2
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "[Le papier construit un modele spatiotemporel physiquement contraint sur l'ensemble des 27 passages satellite pour combler les zones nuageuses (clear-sky reconstruction) de la temperature de surface (LST) ; il ne publie pas de regression Y~X statique unique -- la relation LST~couverture du sol est neanmoins directement mesurable dans les donnees deposees (grille appariee lat/lon/land_cover/LST par passage satellite)]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Chang & Wikle (2019), Physically constrained spatiotemporal modeling: generating clear-sky constructions of land surface temperature from sparse, remotely sensed satellite data, Journal of Applied Statistics, doi:10.1080/02664763.2019.1681384. Le papier reconstruit les zones nuageuses de LST par modele spatiotemporel a contrainte physique sur toute la sequence de 27 passages satellite (pas de formule Y~X statique). Les fichiers deposes fournissent une grille 151x151 de latitude, longitude, couverture du sol et LST par passage -- formula_used utilise le passage avec la meilleure couverture non-nuageuse (2014-07-01 22:06 UTC) comme coupe transversale ile-de-chaleur urbaine (LST~land_cover), une simplification documentee du probleme spatiotemporel complet du papier. Donnees brutes (Phoenix_Houston_LST_Dryad.zip, sous-dossier Houston) telechargees directement depuis Dryad (10.5061/dryad.fbg79cnt2) -- pas une reconstruction, grille reelle sur Houston, Texas."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "le papier ne publie pas de regression Y~X statique (modele spatiotemporel physiquement contraint sur toute la sequence de passages satellite) -- formula_used est une coupe transversale ile-de-chaleur urbaine (LST~land_cover) sur le passage le mieux couvert, une simplification documentee, pas la specification publiee -- promu a package_include='yes' apres validation utilisateur (session 2026-08-16, groupe A)"
  reason: "Y continu reel (LST en Kelvin, mesure satellite reelle), N=19059 pixels avec coordonnees reelles (Houston, Texas), covariable land_cover categorique reelle (6 classes). Grille originale telechargee directement depuis Dryad, pas une reconstruction. Papier lu (titre/abstract + structure des fichiers) pour confirmer la nature du probleme (reconstruction clear-sky spatiotemporelle, pas une regression statique)."
```

- Decision: ready
- Manque principal: le papier ne publie pas de regression Y~X statique (modele spatiotemporel physiquement contraint sur toute la sequence de passages satellite) -- formula_used est une coupe transversale ile-de-chaleur urbaine (LST~land_cover) sur le passage le mieux couvert, une simplification documentee, pas la specification publiee -- promu a package_include="yes" apres validation utilisateur (session 2026-08-16, groupe A)
- Raison: Y continu reel (LST en Kelvin, mesure satellite reelle), N=19059 pixels avec coordonnees reelles (Houston, Texas), covariable land_cover categorique reelle (6 classes). Grille originale telechargee directement depuis Dryad, pas une reconstruction. Papier lu (titre/abstract + structure des fichiers) pour confirmer la nature du probleme (reconstruction clear-sky spatiotemporelle, pas une regression statique).

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
- N observations: 19059
- k variables: 6
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-96, -94.49305], y [28.99305, 30.5]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32615 (UTM Zone 15N (EPSG:32615)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.fbg79cnt2 (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`houston_lst_landcover` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `houston_lst_landcover` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`houston_lst_landcover` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Physically constrained spatiotemporal modeling: generating clear-sky constructions of land surface temperature from sparse, remotely sensed satellite data

