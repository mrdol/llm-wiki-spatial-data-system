---
title: paper_no2_aqs_ma_2016_monitor_covariates
type: dataset
created: 2026-08-11
updated: 2026-09-09
sources:
  - data/final_datasets/sf/paper_no2_aqs_state_25_2016_monitor_covariates.rds
  - tools/build_air_quality_monitor_covariates.R
tags: [dataset, paper-derived, spatial, point, air-quality, derived-reconstruction, benchmark-candidate]
---

Cette fiche documente une reconstruction locale EPA AQS Massachusetts 2016 associée au papier de Di et al. Elle ne contient ni la matrice d'apprentissage originale ni les prédictions de grille du dépôt Dataverse comme réponse observée. L'écart avec la tâche publiée est établi et la reconstruction n'est pas admise au benchmark fidèle au papier.

## Description du jeu de donnees

- Topic: qualite de lair / NO2 / reconstruction monitor-level avec covariables publiques
- Observation unit: station EPA AQS, moyenne annuelle 2016
- Observed population: stations de mesure du Massachusetts avec observations journalieres valides en 2016
- Geographic context: Massachusetts, Etats-Unis ; coordonnees stationnelles WGS84
- Temporal context: coupe spatiale annuelle 2016 derivee dobservations journalieres
- Source description: Assessing NO2 Concentration and Model Uncertainty with High Spatiotemporal Resolution across the Contiguous United States Using Ensemble Model Averaging
- Description source: Di et al. (2020), Assessing NO2 Concentration and Model Uncertainty with High Spatiotemporal Resolution across the Contiguous United States Using Ensemble Model Averaging + outils publics EPA/USGS/NASA/NLCD/Census
- Description confidence: medium
- Paper DOI: 10.1021/acs.est.9b03358
- Dataset DOI original: 10.7910/DVN/LUFKYG
- Local sf output: `data/final_datasets/sf/paper_no2_aqs_state_25_2016_monitor_covariates.rds`
- Builder script: `tools/build_air_quality_monitor_covariates.R`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `no2_mean_2016`, réponse dérivée locale, différente de la réponse publiée
- Candidate Y typology: continuous
- Candidate X variables: `elevation_m_usgs_epqs`, `power_t2m_mean_c`, `power_rh2m_mean_pct`, `power_ws10m_mean_m_s`, `power_prectotcorr_sum_mm`, `power_swdwn_mean_mj_m2_day`, `power_ps_mean_kpa`, `nlcd_land_cover_code`, `nlcd_developed`, `nlcd_forest`, `road_density_primary_secondary_1km_m_per_km2`, `road_density_primary_secondary_10km_m_per_km2`
- Candidate X typology: continuous, categorical, binary
- Candidate X count: 12 variables candidates non constantes parmi 14 colonnes publiques de covariables ; 5 dans l'ancienne formule compacte
- Coordinates (x, y - excluded from X candidates): `longitude`, `latitude`
- Identifier columns (excluded from X candidates): site_id, state_code, county_code, site_num, year, provenance et diagnostics
- Variables inspected: yes ; 10 stations, `measurement_column` vaut Arithmetic Mean partout
- Presence of imputed X: absence de NA ne prouve pas l'absence d'imputation en amont

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `no2_mean_2016` | `numeric` | continuous | [2.720621, 15.07027] | 0% |

> Selection Y/X (paper-loader / curated evidence) : `no2_mean_2016` est la moyenne annuelle des valeurs `Arithmetic Mean` sélectionnées par le builder dans les données AQS (`pick_response_col()`, puis `mean(x$.y)`) ; elle ne restitue pas le maximum quotidien horaire employé par Di et al., qui utilisent le logarithme du NO2 observé lors de l'apprentissage. Les covariables X retenues sont les familles publiques reconstruites localement (élévation, météo/rayonnement NASA POWER, occupation du sol NLCD, densité routière). Les coordonnées (`longitude`, `latitude`), identifiants (`site_id`, `state_code`, `county_code`, `site_num`, `year`) et diagnostics (`no2_grid_prediction_2016`, sa distance de jointure, `n_daily_observations`) sont exclus de X. Statut benchmark actuel : not_ready_training_data ; la reconstruction n'est pas admise comme benchmark fidèle au papier.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `elevation_m_usgs_epqs` | `numeric` | continuous | 0% |
| `power_t2m_mean_c` | `numeric` | continuous | 0% |
| `power_rh2m_mean_pct` | `numeric` | continuous | 0% |
| `power_ws10m_mean_m_s` | `numeric` | continuous | 0% |
| `power_prectotcorr_sum_mm` | `numeric` | continuous | 0% |
| `power_swdwn_mean_mj_m2_day` | `numeric` | continuous | 0% |
| `power_ps_mean_kpa` | `numeric` | continuous | 0% |
| `nlcd_land_cover_code` | `integer` | categorical | 0% |
| `nlcd_developed` | `integer` | binary | 0% |
| `nlcd_forest` | `integer` | binary | 0% |
| `road_density_primary_secondary_1km_m_per_km2` | `numeric` | continuous | 0% |
| `road_density_primary_secondary_10km_m_per_km2` | `numeric` | continuous | 0% |

> Note : `nlcd_land_cover_code` est une catégorie, pas un comptage. `no2_grid_prediction_2016`, sa distance de jointure et `n_daily_observations` sont des diagnostics, pas des prédicteurs publiés. Agriculture et water (NLCD) sont constantes sur ces 10 stations et ne sont pas retenues.

### Formule - niveau publication

- formula_pub: NO2_hat = f1(Location_i, NO2_hat_nn_ij) + f2(Location_i, NO2_hat_rf_ij) + f3(Location_i, NO2_hat_gb_ij)
- x_terms_pub: prédicteurs satellitaires, modèles de transport chimique, météorologie, occupation du sol, routes/trafic, topographie et variables auxiliaires ; puis prédictions NN/RF/GB et localisation pour le GAM d'ensemble
- y_term_pub: NO2 observé, maximum journalier sur une heure, transformé en logarithme pour l'apprentissage
- Reference publication: Di et al. (2020), Environmental Science & Technology 54:1372–1384, DOI 10.1021/acs.est.9b03358, sections 2.1 et 3.2–3.4 ; équation de la section 3.3, page publiée 1375 (page PDF 4).

L'équation ci-dessus conserve les notations et les trois fonctions du papier : splines thin-plate faisant interagir la localisation et les prédictions de chaque apprenant. Le papier utilise 912 stations sur 2000–2016, un downscaling des résidus et des étapes itératives supplémentaires. Une formule R avec cinq covariables et un simple lisseur spatial ne représente pas cet ensemble.

### Statut regression canonique

- Statut: derived_reconstruction
- Niveau de preuve: modèle publié identifié ; matrice d'apprentissage originale absente localement
- Methode d estimation: réseau neuronal, forêt aléatoire et gradient boosting, puis GAM d'ensemble géographiquement pondéré
- Note: Le DOI Dataverse désigne les prédictions finales sur grille, pas les observations et covariables d'apprentissage originales. La reconstruction Massachusetts 2016 a été construite par le projet pour disposer d'une petite table locale ; ce choix n'est pas une spécification de l'article.

### Formule - niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending
- Selected Y typology: continuous
- Note: La formule annuelle à cinq X est retirée de l'usage actif, sans effacer le RDS dérivé. Reconstituer ou obtenir la réponse quotidienne et les prédicteurs des auteurs avant de proposer une tâche fidèle au papier.

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
    source_ref: "Aucune formule locale n'est presentee comme la formule publiee (ensemble NN/RF/GB + GAM geographiquement pondere, section 3.3) ; la table annuelle de dix stations reste un artefact de reconstruction documente, non une replication."
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

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_no2_aqs_ma_2016_monitor_covariates`
- Dataset name: NO2 AQS Massachusetts 2016 monitor covariates
- Source family: derived_reconstruction
- Source: reconstruction EPA AirData, USGS, NASA POWER, NLCD et Census ; associée thématiquement à Di et al. (2020)
- Source URL: https://www.epa.gov/outdoor-air-quality-data
- Dataset DOI: none
- Dataset DOI note: cette reconstruction locale ne possède pas le DOI du produit Dataverse (voir Dataset DOI original ci-dessous)
- Dataset DOI original: 10.7910/DVN/LUFKYG, produit de prédiction associé uniquement
- Publication DOI: 10.1021/acs.est.9b03358
- Year: 2020 (publication) ; données dérivées : 2016

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): prédiction quotidienne spatio-temporelle de NO2
- Modele niveau 2 (famille): ensemble géographiquement pondéré de machine learning
- Modele niveau 3 (variante): NN + RF + gradient boosting combinés par GAM ; downscaling et étapes itératives

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "NO2_hat = f1(Location_i, NO2_hat_nn_ij) + f2(Location_i, NO2_hat_rf_ij) + f3(Location_i, NO2_hat_gb_ij)"
  model_family: "geographically weighted ensemble machine learning"
  source_type: scientific_publication
  source_ref: "10.1021/acs.est.9b03358, section 3.3 page 1375"
  confidence: high
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_training_data"
  benchmark_task: "regression_continuous"
  package_include: "no"
  has_local_rds: true
  missing_items: "Matrice quotidienne originale absente ; réponse annuelle différente, dix stations seulement ; reconstruction non admise comme benchmark fidèle au papier."
  reason: "Matrice quotidienne originale absente ; réponse annuelle différente, dix stations seulement ; reconstruction non admise comme benchmark fidèle au papier."
```

- Decision: not_ready_training_data
- Manque principal: Matrice quotidienne originale absente ; réponse annuelle différente, dix stations seulement ; reconstruction non admise comme benchmark fidèle au papier.
- Raison: Données conservées dans la banque ; le statut ne vaut pas admission au benchmark automatique.

## Estimator eligibility

```yaml
estimator_eligibility:
  eligible_estimators: []
  conditionally_eligible_estimators: ["random_forest", "xgboost", "gam_spatial"]
  ineligible_reason: "Le harnais offre RF, XGBoost et GAM spatial séparément, pas le réseau neuronal ni le GAM combinant leurs prédictions comme dans le papier. Avec dix stations et une réponse différente, aucune admission automatique."
  rule: "Conserver la méthode du papier ; une famille voisine ne constitue pas une reproduction."
```

Les trois routes conditionnelles ne valent que pour une future tâche correctement reconstruite et suffisamment documentée. XGBoost appartient à la famille du gradient boosting, mais l'identité du moteur avec celui des auteurs n'est pas établie. `gam_spatial` ajoute `s(x,y)` aux X ; ce n'est pas le GAM d'ensemble publié. Aucun SAR classique n'est attribué au papier.

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale dérivée ; le papier étudie des observations quotidiennes spatio-temporelles
- N observations: 10
- k variables: 31
- T periods: 1
- Variable temporelle: agrégation annuelle 2016
- N/T profile: N_petit_T_petit
- Note: 32 colonnes, dont une géométrie ; k=31 attributs hors géométrie, incluant identifiants et diagnostics. Ce nombre n'est pas celui des covariables du papier.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: monitoring station
- Temporal resolution: annual mean 2016
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-72.590803, -70.817783], y [42.108992, 42.814412]
- Time range: 2016
- CRS analyse recommande: projected CRS for Massachusetts / CONUS before distance-sensitive weights

## Bloc 6 - Reproductibilite

- License present: partial
- License name: conditions des différentes sources publiques à documenter
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: not_confirmed_for_combined_artifact
- License evidence: La licence CC0 de 10.7910/DVN/LUFKYG concerne le produit de prédiction ; elle ne suffit pas à établir la licence combinée de cette reconstruction multisource.
- Reproducibility status: partial - public APIs are scripted; exact paper training matrix is not reconstructed
- Code available: yes (`tools/build_air_quality_monitor_covariates.R`, `code/r_catalog/generate_air_quality_monitor_fiches.R`)
- Repository: paper-derived reconstruction
- CSV output: `data/interim/air_quality_monitor_covariates/aqs_no2_2016_state_25_monitor_covariates.csv`

## Quality Control

- Variables: colonnes locales contrôlées ; réponse Arithmetic Mean annuelle distincte du maximum quotidien horaire publié.
- Formula: équation d'ensemble identifiée dans le PDF ; aucune formule de réplication locale exécutable.
- CRS: EPSG:4326 ; géométrie des dix stations.
- Missing values: covariables remplies dans le RDS ; familles originales manquantes malgré cette complétude locale.
- Duplicates: table agrégée par station ; ce n'est pas la structure station-jour d'apprentissage.
- Reproducibility: builder retrouvé ; RDS dérivé conservé, non remplacé par des valeurs inventées.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source grid fiche: [[paper_no2_grid]]
