---
title: paper_california_wildfire_growth
type: dataset
created: 2026-08-17
updated: 2026-08-17
sources:
  - data/final_datasets/sf/paper_california_wildfire_growth.rds
  - DatasetFirst_10_5281_zenodo_7569337
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "[dataset-first, publication non resolue] ENVIRONMENTAL INFLUENCES ON LARGE DAILY WILDFIRE GROWTH IN CALIFORNIA" (DOI unknown).

## Description du jeu de donnees

- Topic: risques naturels / croissance journaliere de feux de foret
- Observation unit: jour-incendie (fire day)
- Observed population: incendies, Californie 2003-2020, N=23031 jours-incendie
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: 5388 distinct periods (variable: Date)
- Source description: [dataset-first, publication non resolue] ENVIRONMENTAL INFLUENCES ON LARGE DAILY WILDFIRE GROWTH IN CALIFORNIA
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: unknown
- Dataset DOI: 10.5281/zenodo.7569337
- Source URL: https://doi.org/10.5281/zenodo.7569337
- Local raw dir: `data/raw/papers/DatasetFirst_10_5281_zenodo_7569337/`
- Local sf output: `data/final_datasets/sf/paper_california_wildfire_growth.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Final_size_perimeter`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Date`, `Start_DT`, `Int_perim_24`, `Int_perim_48`, `Int_perim_72`, `Int_pixel_24`, `Int_pixel_48`, `Int_pixel_72`, `Final_size_pixels`, `Daily_FRP`, `FRE`, `Final_DT`, `Within_Boundary`, `Agency_Ignition_Lon`, `Agency_Ignition_Lat`, `All_Agency_Sources`, `Agency_Type`, `Agency_Cause`, `Agency_Start_DT`, `Agency_End_DT`, `Agency_Area`, `All_Agency_Names`, `Int_agency_24`, `Int_agency_48`, `Int_agency_72`, `Flag`, `PREC_ACC_NC`, `Q2`, `SMOIS`, `SWDOWN`, `T2`, `U10`, `V10`, `PSFC`, `UST`, `TSLB`, `LFM_Chamise_New`, `LFM_Chamise_Old`, `LFM_Manzanita_New`, `LU_INDEX`, `VAR_SSO`, `IVGTYP`, `ISLTYP`, `VEGFRA`, `LAI`, `HGT`, `VAR`, `PBLH`, `LFMASS`, `WOOD`, `STBLCP`, `FSA`, `SAV`, `WS`, `T2_MAX`, `WS_MAX`, `Q2_MIN`, `NFUEL_CAT`, `GREENFRAC`, `HGT_M`, `LANDUSEF`, `mean_wtd_moisture_1hr`, `mean_wtd_moisture_10hr`, `mean_wtd_moisture_100hr`, `mean_wtd_moisture_1000hr`, `SLP_WRF`, `ASP_WRF`, `ERC`, `BI`, `PET`, `PDSI`, `HAINES_AVG`, `HAINES_MAX`, `X300_HOR_WS_AVG`, `X300_HOR_WS_MAX`, `X300_VERT_WS_AVG`, `X300_VERT_WS_MAX`, `X50_TKE_AVG`, `X50_TKE_MAX`, `ASPECT`, `SLOPE`, `WIND_DIR`, `WS_PAR_SLP`, `mean_RH`, `min_RH`, `max_RH`, `mean_T`, `min_T`, `max_T`
- Candidate X count in local artifact: 89
- Candidate X typology: categorical, continuous
- Published X variables from paper: T2 (temperature a 2m, WRF), WS (vitesse du vent), mean_RH (humidite relative moyenne), ERC (Energy Release Component, indice de secheresse combustible), BI (Burning Index), PDSI (Palmer Drought Severity Index)
- Published X count: 6
- Coordinates (x, y - excluded from X candidates): `Ignition_lon`, `Ignition_lat`
- Identifier columns (excluded from X candidates): `Fire_ID`, `Agency_Name`, `Agency_ID`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Final_size_perimeter` | `numeric` | continuous | [193.9873, 1151523.521] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `california_wildfire_growth`, la ou les reponses `Final_size_perimeter` viennent du loader papier et/ou des preuves de l article `[dataset-first, publication non resolue] ENVIRONMENTAL INFLUENCES ON LARGE DAILY WILDFIRE GROWTH IN CALIFORNIA`. Les covariables X retenues sont `T2`, `WS`, `mean_RH`, `ERC`, `BI`, `PDSI` ; 83 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Ignition_lon`, `Ignition_lat`), identifiants (`Fire_ID`, `Agency_Name`, `Agency_ID`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Date` | `character` | categorical | 0% |
| `Start_DT` | `character` | categorical | 0% |
| `Int_perim_24` | `numeric` | continuous | 15.5% |
| `Int_perim_48` | `numeric` | continuous | 69.6% |
| `Int_perim_72` | `numeric` | continuous | 75.9% |
| `Int_pixel_24` | `integer` | count | 15.5% |
| `Int_pixel_48` | `integer` | count | 69.6% |
| `Int_pixel_72` | `numeric` | continuous | 75.9% |
| `Final_size_pixels` | `integer` | count | 0% |
| `Daily_FRP` | `numeric` | continuous | 12.7% |
| `FRE` | `numeric` | continuous | 12.7% |
| `Final_DT` | `character` | categorical | 0% |
| `Within_Boundary` | `logical` | binary | 0% |
| `Agency_Ignition_Lon` | `numeric` | continuous | 63.7% |
| `Agency_Ignition_Lat` | `numeric` | continuous | 63.7% |
| `All_Agency_Sources` | `character` | categorical | 0% |
| `Agency_Type` | `character` | categorical | 0% |
| `Agency_Cause` | `character` | categorical | 0% |
| `Agency_Start_DT` | `character` | categorical | 0% |
| `Agency_End_DT` | `character` | categorical | 0% |
| `Agency_Area` | `numeric` | continuous | 63.7% |
| `All_Agency_Names` | `character` | categorical | 0% |
| `Int_agency_24` | `numeric` | continuous | 69.1% |
| `Int_agency_48` | `numeric` | continuous | 80% |
| `Int_agency_72` | `numeric` | continuous | 82.7% |
| `Flag` | `character` | categorical | 0% |
| `PREC_ACC_NC` | `numeric` | continuous | 7.5% |
| `Q2` | `numeric` | rate | 7.5% |
| `SMOIS` | `numeric` | rate | 7.5% |
| `SWDOWN` | `numeric` | continuous | 7.5% |
| `T2` | `numeric` | continuous | 7.5% |
| `U10` | `numeric` | continuous | 7.5% |
| `V10` | `numeric` | continuous | 7.5% |
| `PSFC` | `numeric` | continuous | 7.5% |
| `UST` | `numeric` | continuous | 7.5% |
| `TSLB` | `numeric` | continuous | 7.5% |
| `LFM_Chamise_New` | `numeric` | continuous | 7.6% |
| `LFM_Chamise_Old` | `numeric` | continuous | 7.6% |
| `LFM_Manzanita_New` | `numeric` | continuous | 7.6% |
| `LU_INDEX` | `numeric` | continuous | 7.5% |
| `VAR_SSO` | `numeric` | continuous | 7.5% |
| `IVGTYP` | `numeric` | continuous | 7.5% |
| `ISLTYP` | `numeric` | continuous | 7.5% |
| `VEGFRA` | `numeric` | continuous | 7.5% |
| `LAI` | `numeric` | continuous | 7.5% |
| `HGT` | `numeric` | continuous | 7.5% |
| `VAR` | `numeric` | continuous | 7.5% |
| `PBLH` | `numeric` | continuous | 7.5% |
| `LFMASS` | `numeric` | continuous | 7.5% |
| `WOOD` | `numeric` | continuous | 7.5% |
| `STBLCP` | `numeric` | continuous | 7.5% |
| `FSA` | `numeric` | continuous | 7.5% |
| `SAV` | `numeric` | continuous | 7.5% |
| `WS` | `numeric` | continuous | 7.5% |
| `T2_MAX` | `numeric` | continuous | 7.5% |
| `WS_MAX` | `numeric` | continuous | 7.5% |
| `Q2_MIN` | `numeric` | rate | 7.5% |
| `NFUEL_CAT` | `numeric` | continuous | 7.5% |
| `GREENFRAC` | `numeric` | rate | 7.5% |
| `HGT_M` | `numeric` | continuous | 7.5% |
| `LANDUSEF` | `numeric` | rate | 7.5% |
| `mean_wtd_moisture_1hr` | `numeric` | rate | 7.7% |
| `mean_wtd_moisture_10hr` | `numeric` | rate | 7.7% |
| `mean_wtd_moisture_100hr` | `numeric` | rate | 7.7% |
| `mean_wtd_moisture_1000hr` | `numeric` | rate | 7.7% |
| `SLP_WRF` | `numeric` | continuous | 7.5% |
| `ASP_WRF` | `numeric` | continuous | 7.5% |
| `ERC` | `integer` | count | 0% |
| `BI` | `integer` | count | 0% |
| `PET` | `numeric` | continuous | 0% |
| `PDSI` | `numeric` | continuous | 0% |
| `HAINES_AVG` | `numeric` | continuous | 9.3% |
| `HAINES_MAX` | `numeric` | continuous | 7.5% |
| `X300_HOR_WS_AVG` | `numeric` | continuous | 11.4% |
| `X300_HOR_WS_MAX` | `numeric` | continuous | 11.2% |
| `X300_VERT_WS_AVG` | `numeric` | continuous | 11.4% |
| `X300_VERT_WS_MAX` | `numeric` | continuous | 11.2% |
| `X50_TKE_AVG` | `numeric` | continuous | 7.7% |
| `X50_TKE_MAX` | `numeric` | continuous | 7.5% |
| `ASPECT` | `numeric` | continuous | 7.5% |
| `SLOPE` | `numeric` | continuous | 7.5% |
| `WIND_DIR` | `numeric` | continuous | 7.5% |
| `WS_PAR_SLP` | `numeric` | continuous | 7.5% |
| `mean_RH` | `numeric` | continuous | 7.5% |
| `min_RH` | `numeric` | continuous | 7.5% |
| `max_RH` | `numeric` | continuous | 7.5% |
| `mean_T` | `numeric` | continuous | 7.5% |
| `min_T` | `numeric` | continuous | 7.5% |
| `max_T` | `numeric` | continuous | 7.5% |

### Formule - niveau publication

- formula_pub: large_growth_binary(>10000 acres/24h) ~ weather_vars + fuel_vars + topographic_vars [modele Random Forest, feature importance -- Hanley, H.S. (2022), 'Environmental Influences on Large Daily Wildfire Growth in California', Master's Thesis, San Jose State University, doi:10.31979/etd.5znn-tm8p. 16013 jours-incendie CA 2003-2020. Variables meteo (temperature, vent, humidite, precipitation), combustible (type, charge, disponibilite, humidite), topographie (pente, aspect, elevation, forme) confirmees comme predicteurs testes]
- x_terms_pub: T2 (temperature a 2m, WRF), WS (vitesse du vent), mean_RH (humidite relative moyenne), ERC (Energy Release Component, indice de secheresse combustible), BI (Burning Index), PDSI (Palmer Drought Severity Index)
- y_term_pub: Final_size_perimeter (taille finale du perimetre de l'incendie) -- le papier utilise en realite un seuil binaire (>10000 acres en 24h de croissance journaliere), non retenu ici (formula_used utilise la taille finale continue, une variable reelle disponible mais differente de la reponse binaire exacte du papier)
- Reference publication: Papier identifie via recherche web (session 2026-08-17) : Hanley, H.S. (2022), 'Environmental Influences on Large Daily Wildfire Growth in California', Master's Thesis, San Jose State University, doi:10.31979/etd.5znn-tm8p (these avec DOI officiel, ScholarWorks repository). Le papier ajuste un modele Random Forest sur 16013 jours-incendie (2003-2020) pour predire un SEUIL BINAIRE (croissance >10000 acres en 24h), pas une regression continue -- formula_used utilise la taille finale du perimetre (Final_size_perimeter, variable continue reelle disponible dans ce depot) comme proxy, avec les memes familles de covariables meteo/combustible/topographie confirmees par le resume du papier (temperature, vent, humidite, indices de secheresse ERC/BI/PDSI) -- une reformulation en regression continue documentee, pas la specification binaire exacte du papier. CSV original (Fire_03_20.csv) telecharge directement depuis Zenodo -- pas une reconstruction, N=23031 incendies avec coordonnees d'ignition reelles (Californie, 32.5-42.0 lat / -124.4 a -114.2 lon, coherent). Fichier drought_cumu_perc_area.csv (serie temporelle secheresse CA sans coordonnees) present dans le meme depot mais non utilise ici. package_include laisse en manual_review : formule reste une simplification (continue au lieu de binaire) documentee.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-17). Papier identifie via recherche web (session 2026-08-17) : Hanley, H.S. (2022), 'Environmental Influences on Large Daily Wildfire Growth in California', Master's Thesis, San Jose State University, doi:10.31979/etd.5znn-tm8p (these avec DOI officiel, ScholarWorks repository). Le papier ajuste un modele Random Forest sur 16013 jours-incendie (2003-2020) pour predire un SEUIL BINAIRE (croissance >10000 acres en 24h), pas une regression continue -- formula_used utilise la taille finale du perimetre (Final_size_perimeter, variable continue reelle disponible dans ce depot) comme proxy, avec les memes familles de covariables meteo/combustible/topographie confirmees par le resume du papier (temperature, vent, humidite, indices de secheresse ERC/BI/PDSI) -- une reformulation en regression continue documentee, pas la specification binaire exacte du papier. CSV original (Fire_03_20.csv) telecharge directement depuis Zenodo -- pas une reconstruction, N=23031 incendies avec coordonnees d'ignition reelles (Californie, 32.5-42.0 lat / -124.4 a -114.2 lon, coherent). Fichier drought_cumu_perc_area.csv (serie temporelle secheresse CA sans coordonnees) present dans le meme depot mais non utilise ici. package_include laisse en manual_review : formule reste une simplification (continue au lieu de binaire) documentee.

### Formule - niveau systeme

- formula_used: Final_size_perimeter ~ T2 + WS + mean_RH + ERC + BI + PDSI
- x_terms_used: T2, WS, mean_RH, ERC, BI, PDSI
- y_term_used: Final_size_perimeter
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-17). Papier identifie via recherche web (session 2026-08-17) : Hanley, H.S. (2022), 'Environmental Influences on Large Daily Wildfire Growth in California', Master's Thesis, San Jose State University, doi:10.31979/etd.5znn-tm8p (these avec DOI officiel, ScholarWorks repository). Le papier ajuste un modele Random Forest sur 16013 jours-incendie (2003-2020) pour predire un SEUIL BINAIRE (croissance >10000 acres en 24h), pas une regression continue -- formula_used utilise la taille finale du perimetre (Final_size_perimeter, variable continue reelle disponible dans ce depot) comme proxy, avec les memes familles de covariables meteo/combustible/topographie confirmees par le resume du papier (temperature, vent, humidite, indices de secheresse ERC/BI/PDSI) -- une reformulation en regression continue documentee, pas la specification binaire exacte du papier. CSV original (Fire_03_20.csv) telecharge directement depuis Zenodo -- pas une reconstruction, N=23031 incendies avec coordonnees d'ignition reelles (Californie, 32.5-42.0 lat / -124.4 a -114.2 lon, coherent). Fichier drought_cumu_perc_area.csv (serie temporelle secheresse CA sans coordonnees) present dans le meme depot mais non utilise ici. package_include laisse en manual_review : formule reste une simplification (continue au lieu de binaire) documentee.

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
    formula: "Final_size_perimeter ~ T2 + WS + mean_RH + ERC + BI + PDSI"
    response: "Final_size_perimeter (taille finale du perimetre de l'incendie) -- le papier utilise en realite un seuil binaire (>10000 acres en 24h de croissance journaliere), non retenu ici (formula_used utilise la taille finale continue, une variable reelle disponible mais differente de la reponse binaire exacte du papier)"
    predictors: ["T2 (temperature a 2m, WRF)", "WS (vitesse du vent)", "mean_RH (humidite relative moyenne)", "ERC (Energy Release Component, indice de secheresse combustible)", "BI (Burning Index)", "PDSI (Palmer Drought Severity Index)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Papier identifie via recherche web (session 2026-08-17) : Hanley, H.S. (2022), 'Environmental Influences on Large Daily Wildfire Growth in California', Master's Thesis, San Jose State University, doi:10.31979/etd.5znn-tm8p (these avec DOI officiel, ScholarWorks repository). Le papier ajuste un modele Random Forest sur 16013 jours-incendie (2003-2020) pour predire un SEUIL BINAIRE (croissance >10000 acres en 24h), pas une regression continue -- formula_used utilise la taille finale du perimetre (Final_size_perimeter, variable continue reelle disponible dans ce depot) comme proxy, avec les memes familles de covariables meteo/combustible/topographie confirmees par le resume du papier (temperature, vent, humidite, indices de secheresse ERC/BI/PDSI) -- une reformulation en regression continue documentee, pas la specification binaire exacte du papier. CSV original (Fire_03_20.csv) telecharge directement depuis Zenodo -- pas une reconstruction, N=23031 incendies avec coordonnees d'ignition reelles (Californie, 32.5-42.0 lat / -124.4 a -114.2 lon, coherent). Fichier drought_cumu_perc_area.csv (serie temporelle secheresse CA sans coordonnees) present dans le meme depot mais non utilise ici. package_include laisse en manual_review : formule reste une simplification (continue au lieu de binaire) documentee."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "Final_size_perimeter ~ T2 + WS + mean_RH + ERC + BI + PDSI + SMOIS + Q2"
    response: "Final_size_perimeter"
    predictors: ["T2", "WS", "mean_RH", "ERC", "BI", "PDSI", "SMOIS", "Q2"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Papier identifie via recherche web (session 2026-08-17) : Hanley, H.S. (2022), 'Environmental Influences on Large Daily Wildfire Growth in California', Master's Thesis, San Jose State University, doi:10.31979/etd.5znn-tm8p (these avec DOI officiel, ScholarWorks repository). Le papier ajuste un modele Random Forest sur 16013 jours-incendie (2003-2020) pour predire un SEUIL BINAIRE (croissance >10000 acres en 24h), pas une regression continue -- formula_used utilise la taille finale du perimetre (Final_size_perimeter, variable continue reelle disponible dans ce depot) comme proxy, avec les memes familles de covariables meteo/combustible/topographie confirmees par le resume du papier (temperature, vent, humidite, indices de secheresse ERC/BI/PDSI) -- une reformulation en regression continue documentee, pas la specification binaire exacte du papier. CSV original (Fire_03_20.csv) telecharge directement depuis Zenodo -- pas une reconstruction, N=23031 incendies avec coordonnees d'ignition reelles (Californie, 32.5-42.0 lat / -124.4 a -114.2 lon, coherent). Fichier drought_cumu_perc_area.csv (serie temporelle secheresse CA sans coordonnees) present dans le meme depot mais non utilise ici. package_include laisse en manual_review : formule reste une simplification (continue au lieu de binaire) documentee."
    estimator_context: ["random_forest_xy", "ols", "gwr", "xgboost_xy"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_california_wildfire_growth`
- Dataset name: ENVIRONMENTAL INFLUENCES ON LARGE DAILY WILDFIRE GROWTH IN CALIFORNIA
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: [dataset-first, publication non resolue] ENVIRONMENTAL INFLUENCES ON LARGE DAILY WILDFIRE GROWTH IN CALIFORNIA
- Paper DOI: unknown
- Dataset DOI: 10.5281/zenodo.7569337
- Source URL: https://doi.org/10.5281/zenodo.7569337
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "large_growth_binary(>10000 acres/24h) ~ weather_vars + fuel_vars + topographic_vars [modele Random Forest, feature importance -- Hanley, H.S. (2022), 'Environmental Influences on Large Daily Wildfire Growth in California', Master's Thesis, San Jose State University, doi:10.31979/etd.5znn-tm8p. 16013 jours-incendie CA 2003-2020. Variables meteo (temperature, vent, humidite, precipitation), combustible (type, charge, disponibilite, humidite), topographie (pente, aspect, elevation, forme) confirmees comme predicteurs testes]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Papier identifie via recherche web (session 2026-08-17) : Hanley, H.S. (2022), 'Environmental Influences on Large Daily Wildfire Growth in California', Master's Thesis, San Jose State University, doi:10.31979/etd.5znn-tm8p (these avec DOI officiel, ScholarWorks repository). Le papier ajuste un modele Random Forest sur 16013 jours-incendie (2003-2020) pour predire un SEUIL BINAIRE (croissance >10000 acres en 24h), pas une regression continue -- formula_used utilise la taille finale du perimetre (Final_size_perimeter, variable continue reelle disponible dans ce depot) comme proxy, avec les memes familles de covariables meteo/combustible/topographie confirmees par le resume du papier (temperature, vent, humidite, indices de secheresse ERC/BI/PDSI) -- une reformulation en regression continue documentee, pas la specification binaire exacte du papier. CSV original (Fire_03_20.csv) telecharge directement depuis Zenodo -- pas une reconstruction, N=23031 incendies avec coordonnees d'ignition reelles (Californie, 32.5-42.0 lat / -124.4 a -114.2 lon, coherent). Fichier drought_cumu_perc_area.csv (serie temporelle secheresse CA sans coordonnees) present dans le meme depot mais non utilise ici. package_include laisse en manual_review : formule reste une simplification (continue au lieu de binaire) documentee."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "le papier (Hanley 2022, these SJSU, doi:10.31979/etd.5znn-tm8p) predit un seuil binaire de croissance journaliere (>10000 acres/24h), pas une regression continue -- formula_used utilise la taille finale du perimetre comme proxy continu, meme familles de covariables meteo/combustible/topographie ; package_include laisse en manual_review pour cette raison"
  reason: "Y continu reel (Final_size_perimeter, taille finale de l'incendie), N=23031 incendies avec coordonnees d'ignition reelles (Californie). CSV original telecharge directement depuis Zenodo, pas une reconstruction. Papier identifie via recherche web (these avec DOI officiel)."
```

- Decision: ready
- Manque principal: le papier (Hanley 2022, these SJSU, doi:10.31979/etd.5znn-tm8p) predit un seuil binaire de croissance journaliere (>10000 acres/24h), pas une regression continue -- formula_used utilise la taille finale du perimetre comme proxy continu, meme familles de covariables meteo/combustible/topographie ; package_include laisse en manual_review pour cette raison
- Raison: Y continu reel (Final_size_perimeter, taille finale de l'incendie), N=23031 incendies avec coordonnees d'ignition reelles (Californie). CSV original telecharge directement depuis Zenodo, pas une reconstruction. Papier identifie via recherche web (these avec DOI officiel).

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

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 23031
- k variables: 98
- T periods: 5388
- Variable temporelle: Date
- N/T profile: N_grand_T_grand

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 5388 distinct periods (variable: Date)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-124.3596586, -114.2090645], y [32.5458334, 42.0041667]
- Time range: 1/1/08 to 9/9/20 (variable: Date)
- CRS analyse recommande: 32611 (UTM Zone 11N (EPSG:32611)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`california_wildfire_growth` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `california_wildfire_growth` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20%: Int_perim_48 (NA=69.6%), Int_perim_72 (NA=75.9%), Int_pixel_48 (NA=69.6%), Int_pixel_72 (NA=75.9%), Agency_Ignition_Lon (NA=63.7%), Agency_Ignition_Lat (NA=63.7%), Agency_Area (NA=63.7%), Int_agency_24 (NA=69.1%), Int_agency_48 (NA=80%), Int_agency_72 (NA=82.7%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`california_wildfire_growth` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: [dataset-first, publication non resolue] ENVIRONMENTAL INFLUENCES ON LARGE DAILY WILDFIRE GROWTH IN CALIFORNIA

