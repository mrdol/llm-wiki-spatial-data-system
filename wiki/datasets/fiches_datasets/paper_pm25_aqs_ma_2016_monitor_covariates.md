---
title: paper_pm25_aqs_ma_2016_monitor_covariates
type: dataset
created: 2026-08-10
updated: 2026-08-10
sources:
  - data/final_datasets/sf/paper_pm25_aqs_state_25_2016_monitor_covariates.rds
  - tools/build_air_quality_monitor_covariates.R
tags: [dataset, paper-derived, spatial, point, air-quality, derived-reconstruction, benchmark-candidate]
---

Dataset spatial derive pour transformer le produit de prediction PM2.5 en petit benchmark de regression continue au niveau des stations EPA AQS du Massachusetts en 2016.

Important: cette fiche ne remplace pas la fiche de grille predite du papier. Elle documente une reconstruction publique partielle, fondee uniquement sur des familles de covariables explicitement citees dans le papier et recuperables depuis des sources officielles. Ce nest pas une replication exacte de la matrice dapprentissage des auteurs.

## Description du jeu de donnees

- Topic: qualite de lair / PM2.5 / reconstruction monitor-level avec covariables publiques
- Observation unit: station EPA AQS, moyenne annuelle 2016
- Observed population: stations de mesure du Massachusetts avec observations journalieres valides en 2016
- Geographic context: Massachusetts, Etats-Unis ; coordonnees stationnelles WGS84
- Temporal context: coupe spatiale annuelle 2016 derivee dobservations journalieres
- Source description: An ensemble-based model of PM2.5 concentration across the contiguous United States with high spatiotemporal resolution
- Description source: Di et al. (2019), An ensemble-based model of PM2.5 concentration across the contiguous United States with high spatiotemporal resolution + outils publics EPA/USGS/NASA/NLCD/Census
- Description confidence: medium
- Paper DOI: 10.1016/j.envint.2019.104909
- Dataset DOI original: 10.7910/DVN/58C6HG
- Local sf output: `data/final_datasets/sf/paper_pm25_aqs_state_25_2016_monitor_covariates.rds`
- Builder script: `tools/build_air_quality_monitor_covariates.R`

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `pm25_mean_2016`
- Candidate Y typology: continuous
- Candidate X variables: `elevation_m_usgs_epqs`, `power_t2m_mean_c`, `power_rh2m_mean_pct`, `power_ws10m_mean_m_s`, `power_prectotcorr_sum_mm`, `power_swdwn_mean_mj_m2_day`, `nlcd_land_cover_code`, `nlcd_developed`, `nlcd_forest`, `road_density_primary_secondary_1km_m_per_km2`, `road_density_primary_secondary_10km_m_per_km2`, `power_ps_mean_kpa`
- Candidate X count: 12
- Candidate X typology: continuous, categorical, binary
- Coordinates (x, y — excluded from X candidates): `longitude`, `latitude`
- Identifier columns (excluded from X candidates): `site_id`, `state_code`, `county_code`, `site_num`, `measurement_column`, `response_units`, `pollutant`, `year`, `source_observations`, `source_grid_prediction`
- Variables inspected: yes (auto — generate_air_quality_monitor_fiches.R)
- Presence of imputed X: unknown
- Diagnostic/proxy columns excluded from formula_used: `pm25_grid_prediction_2016`, `pm25_grid_distance_m`

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `pm25_mean_2016` | `numeric` | continuous | [5.0222, 10.2525] | 0% |

> Selection Y/X (paper-loader/curated evidence) : pm25_mean_2016 est la reponse naturelle car elle correspond a la moyenne annuelle 2016 observee aux stations EPA AQS. Les covariables X retenues sont les familles publiques explicitement mentionnees par l article (10.1016/j.envint.2019.104909) et reconstruites localement: elevation, meteo/radiation, occupation du sol et routes. Les predictions de grille originales (`pm25_grid_prediction_2016`, `pm25_grid_distance_m`) sont conservees comme colonnes diagnostiques mais exclues de formula_used pour eviter une fuite d information.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `elevation_m_usgs_epqs` | `numeric` | continuous | 0% |
| `power_t2m_mean_c` | `numeric` | continuous | 0% |
| `power_rh2m_mean_pct` | `numeric` | continuous | 0% |
| `power_ws10m_mean_m_s` | `numeric` | continuous | 0% |
| `power_prectotcorr_sum_mm` | `numeric` | continuous | 0% |
| `power_swdwn_mean_mj_m2_day` | `numeric` | continuous | 0% |
| `nlcd_land_cover_code` | `integer` | count | 0% |
| `nlcd_developed` | `integer` | binary | 0% |
| `nlcd_forest` | `integer` | binary | 0% |
| `road_density_primary_secondary_1km_m_per_km2` | `numeric` | continuous | 0% |
| `road_density_primary_secondary_10km_m_per_km2` | `numeric` | continuous | 0% |
| `power_ps_mean_kpa` | `numeric` | continuous | 0% |

### Formule — niveau publication

- formula_pub: no single monitor-level regression formula published in the extracted article text.
- x_terms_pub: air-quality observations, remote-sensing/satellite products, meteorology, land-use/land-cover, elevation, road/traffic proxies and chemical transport model outputs are cited as covariate families in the paper.
- y_term_pub: PM2.5 concentration.
- Reference publication: Di et al. (2019), An ensemble-based model of PM2.5 concentration across the contiguous United States with high spatiotemporal resolution

### Statut regression canonique

- Statut: derived_reconstruction
- Niveau de preuve: paper covariate families + public data sources
- Methode d estimation: benchmark regression candidate, not exact paper replication
- Correspondance Python/R: aucune identifiee
- Note: formule compacte derivee pour garder un ratio n/p stable sur une coupe Massachusetts 2016.

### Formule — niveau systeme

- formula_used: pm25_mean_2016 ~ elevation_m_usgs_epqs + power_t2m_mean_c + power_rh2m_mean_pct + nlcd_developed + road_density_primary_secondary_10km_m_per_km2
- x_terms_used: elevation_m_usgs_epqs, power_t2m_mean_c, power_rh2m_mean_pct, nlcd_developed, road_density_primary_secondary_10km_m_per_km2
- y_term_used: pm25_mean_2016
- Note: les colonnes de prediction de grille sont exclues pour eviter la fuite dinformation.

### Formules candidates

```yaml
formula_candidates:
  multivariate_constrained:
    formula: "pm25_mean_2016 ~ elevation_m_usgs_epqs + power_t2m_mean_c + power_rh2m_mean_pct + nlcd_developed + road_density_primary_secondary_10km_m_per_km2"
    response: "pm25_mean_2016"
    predictors: ["elevation_m_usgs_epqs", "power_t2m_mean_c", "power_rh2m_mean_pct", "nlcd_developed", "road_density_primary_secondary_10km_m_per_km2"]
    role: "derived_public_covariate_benchmark"
    source_type: "derived_reconstruction"
    source_ref: "10.1016/j.envint.2019.104909; EPA AirData; USGS EPQS; NASA POWER; NLCD ImageServer; Census TIGER/Line"
    estimator_context: ["ols", "gam_spatial", "random_forest", "xgboost", "sar_lag"]
    status: "derived_reconstruction"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `paper_pm25_aqs_ma_2016_monitor_covariates`
- Dataset name: PM2.5 AQS Massachusetts 2016 monitor covariates
- Source family: paper-derived / DataCite-derived / public covariate reconstruction
- Source: Di et al. (2019), An ensemble-based model of PM2.5 concentration across the contiguous United States with high spatiotemporal resolution
- Source URL: Dataverse dataset DOI 10.7910/DVN/58C6HG
- Dataset DOI: 10.7910/DVN/58C6HG
- Publication DOI: 10.1016/j.envint.2019.104909
- Year: 2016

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): regression continue spatiale
- Modele niveau 2 (famille): benchmark derive avec covariables publiques
- Modele niveau 3 (variante): monitor-level annual cross-section

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "no single monitor-level formula found; system formula is a derived reconstruction"
  equation_family: derived_system_candidate
  model_family: "spatial regression / machine learning benchmark candidate"
  source_type: derived_reconstruction_from_public_sources
  source_ref: "10.1016/j.envint.2019.104909"
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "manual_review_derived_reconstruction"
  benchmark_task: "regression_continuous_derived_reconstruction"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "Prototype reconstruction: uses EPA AQS monitor observations, USGS elevation, NASA POWER weather/radiation, NLCD point land-cover class, Census TIGER road density, and nearest final prediction grid value. Satellite AOD and CTM covariates are not yet reconstructed."
  reason: "Continuous response, coordinates and public covariates are present, but this is a partial reconstruction and not the exact training matrix from the paper."
```

- Decision: manual_review_derived_reconstruction
- Manque principal: exact paper training matrix and missing satellite/CTM/traffic covariates
- Raison: usable for exploratory benchmark only after explicit validation.

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 18
- k variables: 31
- T periods: 1
- Variable temporelle: annualized 2016
- N/T profile: N_petit_T_petit

## Bloc 5 — Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: monitoring station
- Temporal resolution: annual mean 2016
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-73.255089, -70.970816], y [41.685707, 42.770837]
- Time range: 2016
- CRS analyse recommande: projected CRS for Massachusetts / CONUS before distance-sensitive weights

## Bloc 6 — Reproductibilite

- License present: unknown
- License name: public source dependent
- License URL: see provider APIs
- License open: mixed public data sources
- Reproducibility status: partial - public APIs are scripted; exact paper training matrix is not reconstructed
- Code available: yes (`tools/build_air_quality_monitor_covariates.R`, `code/r_catalog/generate_air_quality_monitor_fiches.R`)
- Repository: paper-derived reconstruction
- CSV output: `data/interim/air_quality_monitor_covariates/aqs_pm25_2016_state_25_monitor_covariates.csv`

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_air_quality_monitor_fiches.R`.
- Variables: OK - formula variables present in the RDS.
- Formula: WARN - derived compact formula, not a verbatim published equation.
- CRS: OK - EPSG:4326 in Bloc 5.
- Geometry: OK - point geometry from EPA AQS station coordinates.
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - station-level aggregation by site_id.
- Reproducibility: partial - public APIs are scripted; exact paper training matrix is not reconstructed.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source grid fiche: [[paper_pm25_grid]]

