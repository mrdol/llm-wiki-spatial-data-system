---
title: paper_wildfire_greenup_nbr5
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_wildfire_greenup_nbr5.rds
  - DataCite_2024_ClimateLimitsVegetationGreen_10_1186_s42408_0
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Climate limits vegetation green-up more than slope, soil erodibility, and immediate precipitation following high-severity wildfire" (DOI 10.1186/s42408-024-00264-0).

## Description du jeu de donnees

- Topic: risques naturels / recuperation post-incendie
- Observation unit: pixel spatial echantillonne depuis une grille de feu de haute severite
- Observed population: pixels d'incendies de haute severite aux Etats-Unis, avec NBR post-feu et covariables climat/sol/topographie
- Geographic context: etendue sf: x [-113.8567461, -104.2530371], y [31.3512483, 36.9995853]
- Temporal context: none (cross-sectional)
- Source description: Climate limits vegetation green-up more than slope, soil erodibility, and immediate precipitation following high-severity wildfire
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1186/s42408-024-00264-0
- Dataset DOI: 10.5061/dryad.mw6m9063p
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.mw6m9063p
- Local raw dir: `data/raw/papers/DataCite_2024_ClimateLimitsVegetationGreen_10_1186_s42408_0/`
- Local sf output: `data/final_datasets/sf/paper_wildfire_greenup_nbr5.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `nbr_5_year`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `postfire_precipitation_total`, `postfire_precipitation_coefvar`, `ls_factor`, `KFACTWS_DC`, `nbr_0_year`, `vpd5`, `def5`, `ppt5`, `tmax5`, `month`
- Candidate X count in local artifact: 10
- Candidate X typology: continuous
- Published X variables from paper: postfire_precipitation_total, postfire_precipitation_coefvar, ls_factor, KFACTWS_DC, nbr_0_year, vpd5, def5, ppt5, tmax5, month
- Published X count: 10
- Coordinates (x, y - excluded from X candidates): `x`, `y`
- Identifier columns (excluded from X candidates): `name`, `raw_full_n`, `sample_tile_x`, `sample_tile_y`, `sample_response_bin`, `sample_strategy`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `nbr_5_year` | `numeric` | continuous | [-288.1381, 931.8255] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `wildfire_greenup_nbr5`, la ou les reponses `nbr_5_year` viennent du loader papier et/ou des preuves de l article `Climate limits vegetation green-up more than slope, soil erodibility, and immediate precipitation following high-severity wildfire`. Les covariables X retenues sont `postfire_precipitation_total`, `postfire_precipitation_coefvar`, `ls_factor`, `KFACTWS_DC`, `nbr_0_year`, `vpd5`, `def5`, `ppt5`, `tmax5`, `month`. Les coordonnees (`x`, `y`), identifiants (`name`, `raw_full_n`, `sample_tile_x`, `sample_tile_y`, `sample_response_bin`, `sample_strategy`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `postfire_precipitation_total` | `numeric` | continuous | 0% |
| `postfire_precipitation_coefvar` | `numeric` | continuous | 0% |
| `ls_factor` | `numeric` | continuous | 0% |
| `KFACTWS_DC` | `numeric` | rate | 0% |
| `nbr_0_year` | `numeric` | continuous | 0% |
| `vpd5` | `numeric` | continuous | 0% |
| `def5` | `numeric` | continuous | 0% |
| `ppt5` | `numeric` | continuous | 0% |
| `tmax5` | `numeric` | continuous | 0% |
| `month` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: NBR_year5 ~ postfire precipitation total + precipitation coefficient of variation + slope length factor + soil erodibility + fire-year NBR + growing-season VPD + climatic water deficit + precipitation + maximum temperature + fire month [random forest]
- x_terms_pub: postfire_precipitation_total, postfire_precipitation_coefvar, ls_factor, KFACTWS_DC, nbr_0_year, vpd5, def5, ppt5, tmax5, month
- y_term_pub: Normalized Burn Ratio five years after fire, proxy for post-fire greenness
- Reference publication: Crockett et al. (2024), Fire Ecology, DOI 10.1186/s42408-024-00264-0: Data and Results sections describe random forest models for post-fire NBR years 1-5 using year-of-fire precipitation/topography/soil variables plus growing-season climate. The Dryad README documents train_nbr5 with 1,382,557 pixels; the loader keeps a deterministic 50,000-row subset stratified by 20x20 spatial tiles and 5 quantile bins of NBR for package-scale benchmarking, and records the full raw N in the fiche rationale.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: nbr_5_year ~ postfire_precipitation_total + postfire_precipitation_coefvar + ls_factor + KFACTWS_DC + nbr_0_year + vpd5 + def5 + ppt5 + tmax5 + month
- x_terms_used: postfire_precipitation_total, postfire_precipitation_coefvar, ls_factor, KFACTWS_DC, nbr_0_year, vpd5, def5, ppt5, tmax5, month
- y_term_used: nbr_5_year
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

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
    formula: "nbr_5_year ~ year-of-fire erosion factors + year-5 growing-season climate"
    response: "Normalized Burn Ratio five years after fire, proxy for post-fire greenness"
    predictors: ["postfire_precipitation_total", "postfire_precipitation_coefvar", "ls_factor", "KFACTWS_DC", "nbr_0_year", "vpd5", "def5", "ppt5", "tmax5", "month"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

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

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_wildfire_greenup_nbr5`
- Dataset name: Climate is more influential to vegetation green-up than factors that contribute to erosion following high-severity wildfire
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Climate limits vegetation green-up more than slope, soil erodibility, and immediate precipitation following high-severity wildfire
- Paper DOI: 10.1186/s42408-024-00264-0
- Dataset DOI: 10.5061/dryad.mw6m9063p
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.mw6m9063p
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "NBR_year5 ~ postfire precipitation total + precipitation coefficient of variation + slope length factor + soil erodibility + fire-year NBR + growing-season VPD + climatic water deficit + precipitation + maximum temperature + fire month [random forest]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Crockett et al. (2024), Fire Ecology, DOI 10.1186/s42408-024-00264-0: Data and Results sections describe random forest models for post-fire NBR years 1-5 using year-of-fire precipitation/topography/soil variables plus growing-season climate. The Dryad README documents train_nbr5 with 1,382,557 pixels; the loader keeps a deterministic 50,000-row subset stratified by 20x20 spatial tiles and 5 quantile bins of NBR for package-scale benchmarking, and records the full raw N in the fiche rationale."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "artefact package sous-echantillonne deterministiquement a 50000 lignes sur 1382557 par tuiles spatiales 20x20 et quantiles de NBR ; utiliser le raw complet pour analyses lourdes"
  reason: "Y continu NBR annee 5, X climatiques/sol/topographie documentees dans README et papier, coordonnees lon/lat. Sous-echantillonnage spatialement stratifie et stratifie par reponse pour eviter un benchmark package trop lourd tout en gardant la couverture spatiale et le gradient de NBR."
```

- Decision: ready
- Manque principal: artefact package sous-echantillonne deterministiquement a 50000 lignes sur 1382557 par tuiles spatiales 20x20 et quantiles de NBR ; utiliser le raw complet pour analyses lourdes
- Raison: Y continu NBR annee 5, X climatiques/sol/topographie documentees dans README et papier, coordonnees lon/lat. Sous-echantillonnage spatialement stratifie et stratifie par reponse pour eviter un benchmark package trop lourd tout en gardant la couverture spatiale et le gradient de NBR.

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
- N observations: 50000
- k variables: 21
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-113.8567461, -104.2530371], y [31.3512483, 36.9995853]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32612 (UTM Zone 12N (EPSG:32612)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.mw6m9063p (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`wildfire_greenup_nbr5` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `wildfire_greenup_nbr5` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`wildfire_greenup_nbr5` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Climate limits vegetation green-up more than slope, soil erodibility, and immediate precipitation following high-severity wildfire

