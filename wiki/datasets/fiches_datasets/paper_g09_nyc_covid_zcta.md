---
title: paper_g09_nyc_covid_zcta
type: dataset
created: 2026-09-24
updated: 2026-09-24
sources:
  - data/final_datasets/sf/paper_g09_nyc_covid_zcta.rds
  - G09_Poisson_MGWR_NYC
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "On the local modeling of count data: multiscale geographically weighted Poisson regression" (DOI 10.1080/13658816.2023.2250838).

## Description du jeu de donnees

- Topic: Public health
- Observation unit: observation spatiale du dataset "New York City COVID-19 positive test counts by ZCTA"
- Observed population: Official CC BY 4
- Geographic context: 183 NYC ZCTA polygons (MODZCTA), areal unit count data with an offset.
- Temporal context: 49 distinct periods (variable: Sum_Year_x)
- Source description: On the local modeling of count data: multiscale geographically weighted Poisson regression
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: high
- Paper DOI: 10.1080/13658816.2023.2250838
- Dataset DOI: 10.6084/m9.figshare.21743021.v1
- Source URL: https://doi.org/10.6084/m9.figshare.21743021.v1
- Local raw dir: `data/raw/papers/G09_Poisson_MGWR_NYC/`
- Local sf output: `data/final_datasets/sf/paper_g09_nyc_covid_zcta.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Positive`
- Candidate Y typology: unknown
- Candidate X variables in local artifact: `Var.1`, `owner_occ`, `perc_owner_occ`, `renter_occ`, `per_renter_occ`, `recent_move`, `recent_move_perc`, `moved_201502018`, `perc_mov_2015_2018`, `id_x_x`, `Geographic Area Name`, `living_tot`, `liv_tot_house`, `male_livin_alone`, `female_livi__alone`, `tot_livin_alone`, `id_y_x`, `perc_living_alone`, `tot_housing_unit_x`, `occ_housing_unit_x`, `perc_occ_housing_x`, `vacant_housing_units_x`, `vacant_housing_perc_x`, `id`, `cong_ind`, `geo`, `zcta`, `OBJECTID`, `num_schools`, `ZIPCODE_x`, `tot_housing_unit_y`, `occ_housing_unit_y`, `perc_occ_housing_y`, `vacant_housing_units_y`, `vacant_housing_perc_y`, `id_x_y`, `Geographic Area Name_x`, `geo_x`, `zcta_x`, `id_y_y`, `Geographic Area Name_y`, `tot_pop`, `under_5_x`, `pop_over_5`, `geo_y`, `zcta_y`, `tot_living_household`, `tot_household_pup_assist`, `id_x_y.1`, `Geographic Area Name_x.1`, `perc_pub_ast`, `geo_x.1`, `zcta_x.1`, `tot_pop_x`, `tot_not_hispanic`, `white_alone`, `black_alone`, `AIAN`, `Asian`, `NHPI`, `some_other`, `two_other_races`, `hispanic`, `id_y_y.1`, `Geographic Area Name_y.1`, `perc_white`, `perc_black`, `perc_AIAN`, `perc_asian`, `perc_NHPI`, `perc_hispanic`, `geo_y.1`, `zcta_y.1`, `id_x_y.2`, `Geographic Area Name_x.2`, `pop_5_and_over`, `pop_only_english`, `pop_one_other_english`, `geo_x.2`, `zcta_x.2`, `FID_x`, `FID_1_x`, `ZIPCODE_y`, `BLDGZIP`, `PO_NAME`, `POPULATION`, `AREA`, `STATE`, `COUNTY`, `ST_FIPS`, `CTY_FIPS`, `URL_x`, `SHAPE_AREA`, `SHAPE_LEN`, `Count__x`, `Sum_ALAND_x`, `Sum_AWATER_x`, `Sum_fips_n_x`, `Sum_Shape__x`, `Sum_Shap_1_x`, `Sum_heart_`, `Sum_Year_x`, `Sum_Data_V_x`, `Sum_Low_Co_x`, `Sum_High_C_x`, `Sum_Popula_x`, `Sum_CityFI_x`, `Sum_TractF_x`, `heart_perc`, `zcta_y.2`, `FID_y`, `FID_1_y`, `ZIPCODE_x.1`, `BLDGZIP_x`, `PO_NAME_x`, `POPULATION_x`, `AREA_x`, `STATE_x`, `COUNTY_x`, `ST_FIPS_x`, `CTY_FIPS_x`, `SHAPE_AREA_x`, `SHAPE_LEN_x`, `Count__y`, `Sum_ALAND_y`, `Sum_AWATER_y`, `Sum_fips_n_y`, `Sum_Shape__y`, `Sum_Shap_1_y`, `Sum_raw_co`, `Sum_Year_y`, `Sum_Data_V_y`, `Sum_Low_Co_y`, `Sum_High_C_y`, `Sum_Popula_y`, `Sum_CityFI_y`, `Sum_TractF_y`, `Sum_fips_t`, `copd_perc`, `zcta_x.3`, `id_y_y.2`, `Geographic Area Name_y.2`, `tot_pop_y`, `under_5_y`, `age_65_69`, `age_70_74`, `age_75_79`, `age_80_84`, `age_85_and_up`, `all_65_up`, `geo_y.2`, `zcta_y.3`, `prop_65_up`, `index`, `Total`, `zcta_cum.perc_pos`, `ZIPCODE_y.1`, `BLDGZIP_y`, `PO_NAME_y`, `POPULATION_y`, `AREA_y`, `STATE_y`, `COUNTY_y`, `ST_FIPS_y`, `CTY_FIPS_y`, `URL_y`, `SHAPE_AREA_y`, `SHAPE_LEN_y`, `positivity_rate`, `perc_language`, `perc_over_5`, `polygon_area`, `houses_per_sq_mile`, `pop_density`, `schools_per_mile`, `b_constant`, `b_black`, `b_heart`, `b_cong`, `b_schools`, `b_popden`, `b_hispanic`, `b_pub_ast`, `b_copd`, `vif_black`, `lcc_black`, `vdp_black`
- Candidate X count in local artifact: 187
- Candidate X typology: unknown, continuous, categorical
- Published X variables from paper: perc_black, heart_perc, pop_density, schools_per_mile, perc_pub_ast, perc_hispanic
- Published X count: 6
- Coordinates (x, y - excluded from X candidates): `coord_x`, `coord_y`
- Identifier columns (excluded from X candidates): `MODZCTA`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Positive` | `integer` | unknown | [15, 2946] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `g09_nyc_covid_zcta`, la ou les reponses `Positive` viennent du loader papier et/ou des preuves de l article `On the local modeling of count data: multiscale geographically weighted Poisson regression`. Les covariables X retenues sont `perc_black`, `heart_perc`, `pop_density`, `schools_per_mile`, `perc_pub_ast`, `perc_hispanic` ; 181 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`coord_x`, `coord_y`), identifiants (`MODZCTA`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : needs_manual_review ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Var.1` | `integer` | unknown | 0% |
| `owner_occ` | `integer` | unknown | 0% |
| `perc_owner_occ` | `numeric` | continuous | 0% |
| `renter_occ` | `integer` | unknown | 0% |
| `per_renter_occ` | `numeric` | continuous | 0% |
| `recent_move` | `integer` | unknown | 0% |
| `recent_move_perc` | `numeric` | continuous | 0% |
| `moved_201502018` | `integer` | unknown | 0% |
| `perc_mov_2015_2018` | `numeric` | continuous | 0% |
| `id_x_x` | `character` | categorical | 0% |
| `Geographic Area Name` | `character` | categorical | 0% |
| `living_tot` | `integer` | unknown | 0% |
| `liv_tot_house` | `integer` | unknown | 0% |
| `male_livin_alone` | `integer` | unknown | 0% |
| `female_livi__alone` | `integer` | unknown | 0% |
| `tot_livin_alone` | `integer` | unknown | 0% |
| `id_y_x` | `character` | categorical | 0% |
| `perc_living_alone` | `numeric` | continuous | 0% |
| `tot_housing_unit_x` | `integer` | unknown | 0% |
| `occ_housing_unit_x` | `integer` | unknown | 0% |
| `perc_occ_housing_x` | `numeric` | continuous | 0% |
| `vacant_housing_units_x` | `integer` | unknown | 0% |
| `vacant_housing_perc_x` | `numeric` | continuous | 0% |
| `id` | `character` | categorical | 0% |
| `cong_ind` | `numeric` | continuous | 0% |
| `geo` | `character` | categorical | 0% |
| `zcta` | `integer` | unknown | 0% |
| `OBJECTID` | `integer` | unknown | 0% |
| `num_schools` | `integer` | unknown | 0% |
| `ZIPCODE_x` | `integer` | unknown | 0% |
| `tot_housing_unit_y` | `integer` | unknown | 0% |
| `occ_housing_unit_y` | `integer` | unknown | 0% |
| `perc_occ_housing_y` | `numeric` | continuous | 0% |
| `vacant_housing_units_y` | `integer` | unknown | 0% |
| `vacant_housing_perc_y` | `numeric` | continuous | 0% |
| `id_x_y` | `character` | categorical | 0% |
| `Geographic Area Name_x` | `character` | categorical | 0% |
| `geo_x` | `character` | categorical | 0% |
| `zcta_x` | `integer` | unknown | 0% |
| `id_y_y` | `character` | categorical | 0% |
| `Geographic Area Name_y` | `character` | categorical | 0% |
| `tot_pop` | `integer` | unknown | 0% |
| `under_5_x` | `integer` | unknown | 0% |
| `pop_over_5` | `integer` | unknown | 0% |
| `geo_y` | `character` | categorical | 0% |
| `zcta_y` | `integer` | unknown | 0% |
| `tot_living_household` | `integer` | unknown | 0% |
| `tot_household_pup_assist` | `integer` | unknown | 0% |
| `id_x_y.1` | `character` | categorical | 0% |
| `Geographic Area Name_x.1` | `character` | categorical | 0% |
| `perc_pub_ast` | `numeric` | continuous | 0% |
| `geo_x.1` | `character` | categorical | 0% |
| `zcta_x.1` | `integer` | unknown | 0% |
| `tot_pop_x` | `integer` | unknown | 0% |
| `tot_not_hispanic` | `integer` | unknown | 0% |
| `white_alone` | `integer` | unknown | 0% |
| `black_alone` | `integer` | unknown | 0% |
| `AIAN` | `integer` | unknown | 0% |
| `Asian` | `integer` | unknown | 0% |
| `NHPI` | `integer` | unknown | 0% |
| `some_other` | `integer` | unknown | 0% |
| `two_other_races` | `integer` | unknown | 0% |
| `hispanic` | `integer` | unknown | 0% |
| `id_y_y.1` | `character` | categorical | 0% |
| `Geographic Area Name_y.1` | `character` | categorical | 0% |
| `perc_white` | `numeric` | continuous | 0% |
| `perc_black` | `numeric` | continuous | 0% |
| `perc_AIAN` | `numeric` | continuous | 0% |
| `perc_asian` | `numeric` | continuous | 0% |
| `perc_NHPI` | `numeric` | rate | 0% |
| `perc_hispanic` | `numeric` | continuous | 0% |
| `geo_y.1` | `character` | categorical | 0% |
| `zcta_y.1` | `integer` | unknown | 0% |
| `id_x_y.2` | `character` | categorical | 0% |
| `Geographic Area Name_x.2` | `character` | categorical | 0% |
| `pop_5_and_over` | `integer` | unknown | 0% |
| `pop_only_english` | `integer` | unknown | 0% |
| `pop_one_other_english` | `integer` | unknown | 0% |
| `geo_x.2` | `character` | categorical | 0% |
| `zcta_x.2` | `integer` | unknown | 0% |
| `FID_x` | `integer` | unknown | 0% |
| `FID_1_x` | `integer` | unknown | 0% |
| `ZIPCODE_y` | `integer` | unknown | 0% |
| `BLDGZIP` | `integer` | binary | 0% |
| `PO_NAME` | `character` | categorical | 0% |
| `POPULATION` | `numeric` | continuous | 0% |
| `AREA` | `numeric` | continuous | 0% |
| `STATE` | `character` | categorical | 0% |
| `COUNTY` | `character` | categorical | 0% |
| `ST_FIPS` | `integer` | unknown | 0% |
| `CTY_FIPS` | `integer` | unknown | 0% |
| `URL_x` | `character` | categorical | 0% |
| `SHAPE_AREA` | `numeric` | binary | 0% |
| `SHAPE_LEN` | `numeric` | binary | 0% |
| `Count__x` | `integer` | unknown | 0% |
| `Sum_ALAND_x` | `numeric` | continuous | 0% |
| `Sum_AWATER_x` | `numeric` | continuous | 0% |
| `Sum_fips_n_x` | `numeric` | continuous | 0% |
| `Sum_Shape__x` | `numeric` | continuous | 0% |
| `Sum_Shap_1_x` | `numeric` | continuous | 0% |
| `Sum_heart_` | `numeric` | continuous | 0% |
| `Sum_Year_x` | `integer` | unknown | 0% |
| `Sum_Data_V_x` | `numeric` | continuous | 0% |
| `Sum_Low_Co_x` | `numeric` | continuous | 0% |
| `Sum_High_C_x` | `numeric` | continuous | 0% |
| `Sum_Popula_x` | `integer` | unknown | 0% |
| `Sum_CityFI_x` | `integer` | unknown | 0% |
| `Sum_TractF_x` | `numeric` | continuous | 0% |
| `heart_perc` | `numeric` | continuous | 0% |
| `zcta_y.2` | `integer` | unknown | 0% |
| `FID_y` | `integer` | unknown | 0% |
| `FID_1_y` | `integer` | unknown | 0% |
| `ZIPCODE_x.1` | `integer` | unknown | 0% |
| `BLDGZIP_x` | `integer` | binary | 0% |
| `PO_NAME_x` | `character` | categorical | 0% |
| `POPULATION_x` | `numeric` | continuous | 0% |
| `AREA_x` | `numeric` | continuous | 0% |
| `STATE_x` | `character` | categorical | 0% |
| `COUNTY_x` | `character` | categorical | 0% |
| `ST_FIPS_x` | `integer` | unknown | 0% |
| `CTY_FIPS_x` | `integer` | unknown | 0% |
| `SHAPE_AREA_x` | `numeric` | binary | 0% |
| `SHAPE_LEN_x` | `numeric` | binary | 0% |
| `Count__y` | `integer` | unknown | 0% |
| `Sum_ALAND_y` | `numeric` | continuous | 0% |
| `Sum_AWATER_y` | `numeric` | continuous | 0% |
| `Sum_fips_n_y` | `numeric` | continuous | 0% |
| `Sum_Shape__y` | `numeric` | continuous | 0% |
| `Sum_Shap_1_y` | `numeric` | continuous | 0% |
| `Sum_raw_co` | `numeric` | continuous | 0% |
| `Sum_Year_y` | `integer` | unknown | 0% |
| `Sum_Data_V_y` | `numeric` | continuous | 0% |
| `Sum_Low_Co_y` | `numeric` | continuous | 0% |
| `Sum_High_C_y` | `numeric` | continuous | 0% |
| `Sum_Popula_y` | `integer` | unknown | 0% |
| `Sum_CityFI_y` | `integer` | unknown | 0% |
| `Sum_TractF_y` | `numeric` | continuous | 0% |
| `Sum_fips_t` | `numeric` | continuous | 0% |
| `copd_perc` | `numeric` | continuous | 0% |
| `zcta_x.3` | `integer` | unknown | 0% |
| `id_y_y.2` | `character` | categorical | 0% |
| `Geographic Area Name_y.2` | `character` | categorical | 0% |
| `tot_pop_y` | `integer` | unknown | 0% |
| `under_5_y` | `integer` | unknown | 0% |
| `age_65_69` | `integer` | unknown | 0% |
| `age_70_74` | `integer` | unknown | 0% |
| `age_75_79` | `integer` | unknown | 0% |
| `age_80_84` | `integer` | unknown | 0% |
| `age_85_and_up` | `integer` | unknown | 0% |
| `all_65_up` | `integer` | unknown | 0% |
| `geo_y.2` | `character` | categorical | 0% |
| `zcta_y.3` | `integer` | unknown | 0% |
| `prop_65_up` | `numeric` | rate | 0% |
| `index` | `integer` | unknown | 0% |
| `Total` | `integer` | unknown | 0% |
| `zcta_cum.perc_pos` | `numeric` | continuous | 0% |
| `ZIPCODE_y.1` | `integer` | unknown | 0% |
| `BLDGZIP_y` | `integer` | binary | 0% |
| `PO_NAME_y` | `character` | categorical | 0% |
| `POPULATION_y` | `numeric` | continuous | 0% |
| `AREA_y` | `numeric` | continuous | 0% |
| `STATE_y` | `character` | categorical | 0% |
| `COUNTY_y` | `character` | categorical | 0% |
| `ST_FIPS_y` | `integer` | unknown | 0% |
| `CTY_FIPS_y` | `integer` | unknown | 0% |
| `URL_y` | `character` | categorical | 0% |
| `SHAPE_AREA_y` | `numeric` | binary | 0% |
| `SHAPE_LEN_y` | `numeric` | binary | 0% |
| `positivity_rate` | `numeric` | continuous | 0% |
| `perc_language` | `numeric` | continuous | 0% |
| `perc_over_5` | `numeric` | continuous | 0% |
| `polygon_area` | `numeric` | continuous | 0% |
| `houses_per_sq_mile` | `numeric` | continuous | 0% |
| `pop_density` | `numeric` | continuous | 0% |
| `schools_per_mile` | `numeric` | continuous | 0% |
| `b_constant` | `numeric` | continuous | 0% |
| `b_black` | `numeric` | continuous | 0% |
| `b_heart` | `numeric` | continuous | 0% |
| `b_cong` | `numeric` | continuous | 0% |
| `b_schools` | `numeric` | continuous | 0% |
| `b_popden` | `numeric` | continuous | 0% |
| `b_hispanic` | `numeric` | continuous | 0% |
| `b_pub_ast` | `numeric` | continuous | 0% |
| `b_copd` | `numeric` | continuous | 0% |
| `vif_black` | `numeric` | continuous | 0% |
| `lcc_black` | `numeric` | continuous | 0% |
| `vdp_black` | `numeric` | rate | 0% |

### Formule - niveau publication

- formula_pub: Positive ~ perc_black + heart_perc + pop_density + schools_per_mile + perc_pub_ast + perc_hispanic [Poisson, log link, offset = log(Total)]
- x_terms_pub: perc_black, heart_perc, pop_density, schools_per_mile, perc_pub_ast, perc_hispanic
- y_term_pub: Positive (nombre de tests COVID-19 positifs par ZCTA)
- Reference publication: Sachdeva et al. (2023), On the local modeling of count data: multiscale geographically weighted Poisson regression, DOI 10.1080/13658816.2023.2250838; formule finale verifiee dans le notebook officiel Figshare 10.6084/m9.figshare.21743021.v1.

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d estimation: formule systeme generee (formula_pub confirmee mais non reprise telle quelle -- voir Note ci-dessous)
- Correspondance Python/R: aucune identifiee
- Note: La formule tabulaire conserve exactement les six covariables du notebook final. L'exposition `Total` doit etre fournie comme offset logarithmique au moteur Poisson; elle ne doit pas etre traitee comme une covariable ordinaire.

### Formule - niveau systeme

- formula_used: Positive ~ perc_black + heart_perc + pop_density + schools_per_mile + perc_pub_ast + perc_hispanic
- x_terms_used: perc_black, heart_perc, pop_density, schools_per_mile, perc_pub_ast, perc_hispanic
- y_term_used: Positive
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

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
    formula: "Positive ~ perc_black + heart_perc + pop_density + schools_per_mile + perc_pub_ast + perc_hispanic"
    response: "Positive (nombre de tests COVID-19 positifs par ZCTA)"
    predictors: ["perc_black", "heart_perc", "pop_density", "schools_per_mile", "perc_pub_ast", "perc_hispanic"]
    role: "benchmark_simplified_specification"
    source_type: "derived_from_scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
    status: "executable_approximation"

  ml_or_selected:
    formula: "Positive ~ perc_black + heart_perc + pop_density + schools_per_mile + perc_pub_ast + perc_hispanic"
    response: "Positive"
    predictors: ["perc_black", "heart_perc", "pop_density", "schools_per_mile", "perc_pub_ast", "perc_hispanic"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["multiscale_geographically_weighted_poisson_regression", "poisson_log_offset"]
    status: "manual_review_offset_required"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_g09_nyc_covid_zcta`
- Dataset name: New York City COVID-19 positive test counts by ZCTA
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: On the local modeling of count data: multiscale geographically weighted Poisson regression
- Paper DOI: 10.1080/13658816.2023.2250838
- Dataset DOI: 10.6084/m9.figshare.21743021.v1
- Source URL: https://doi.org/10.6084/m9.figshare.21743021.v1
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Positive ~ perc_black + heart_perc + pop_density + schools_per_mile + perc_pub_ast + perc_hispanic [Poisson, log link, offset = log(Total)]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Sachdeva et al. (2023), On the local modeling of count data: multiscale geographically weighted Poisson regression, DOI 10.1080/13658816.2023.2250838; formule finale verifiee dans le notebook officiel Figshare 10.6084/m9.figshare.21743021.v1."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "needs_manual_review"
  benchmark_task: "unknown"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "statut benchmark non encore curate"
  reason: "Aucune decision explicite encodee pour g09_nyc_covid_zcta."
```

- Decision: needs_manual_review
- Manque principal: statut benchmark non encore curate
- Raison: Aucune decision explicite encodee pour g09_nyc_covid_zcta.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "needs_manual_review"
  eligible_estimators: []
  conditionally_eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy"]
  ineligible_reason: "manual review required before package promotion"
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 183
- k variables: 193
- T periods: 49
- Variable temporelle: Sum_Year_x
- N/T profile: N_moyen_T_grand

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 49 distinct periods (variable: Sum_Year_x)
- CRS EPSG: 2263
- CRS nom: NAD83 / New York Long Island (ftUS)
- Spatial extent: x [916806.667646371, 1064423.29839412], y [124719.187455587, 266829.08351738]
- Time range: 2017 to 125054 (variable: Sum_Year_x)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`g09_nyc_covid_zcta` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `g09_nyc_covid_zcta` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formula_pub confirmee et verifiee (voir Reference publication) ; formula_used est une approximation generee distincte, explicitement etiquetee comme telle (voir Bloc 1 > Statut regression canonique > Note).
- CRS: OK - CRS renseigne dans le Bloc 5 (2263).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`g09_nyc_covid_zcta` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: On the local modeling of count data: multiscale geographically weighted Poisson regression

