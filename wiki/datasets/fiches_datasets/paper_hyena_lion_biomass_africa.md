---
title: paper_hyena_lion_biomass_africa
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_hyena_lion_biomass_africa.rds
  - DataCite_2021_EnvironmentalFactorsInfluencingSpotted_10_1002_ece3_835
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Environmental factors influencing spotted hyena and lion population biomass across Africa" (DOI 10.1002/ece3.8359).

## Description du jeu de donnees

- Topic: ecologie forestiere / inventaire de biomasse
- Observation unit: placette d'inventaire forestier
- Observed population: placettes CTFT/ONF, foret tropicale humide
- Geographic context: etendue sf: x [20.4321615, 37.2424495], y [-28.217601, 3.840778]
- Temporal context: 23 distinct periods (variable: Year)
- Source description: Environmental factors influencing spotted hyena and lion population biomass across Africa
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1002/ece3.8359
- Dataset DOI: 10.5061/dryad.prr4xgxmj
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.prr4xgxmj
- Local raw dir: `data/raw/papers/DataCite_2021_EnvironmentalFactorsInfluencingSpotted_10_1002_ece3_835/`
- Local sf output: `data/final_datasets/sf/paper_hyena_lion_biomass_africa.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `spotted_hyaena_biomass_log10`, `lion_biomass_log10`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `other_predator_biomass_log10`, `prey_very_small_biomass_log10`, `prey_small_biomass_log10`, `prey_medium_biomass_log10`, `prey_large_biomass_log10`, `prey_very_large_biomass_log10`, `temperature_seasonality_log10`, `max_temperature_warmest_month_log10`, `min_temperature_coolest_month_log10`, `precipitation_wettest_month_log10`, `precipitation_driest_month_log10`, `precipitation_seasonality_log10`, `closed_vegetation_clr`, `semi_open_vegetation_clr`, `open_vegetation_clr`
- Candidate X count in local artifact: 15
- Candidate X typology: continuous
- Published X variables from paper: other predator biomass, very small prey biomass, small prey biomass, medium prey biomass, large prey biomass, very large prey biomass, minimum temperature of coolest month, maximum temperature of warmest month, temperature seasonality, precipitation wettest month, precipitation driest month, precipitation seasonality, closed vegetation cover, semi-open vegetation cover, open vegetation cover
- Published X count: 15
- Coordinates (x, y - excluded from X candidates): `longitude`, `latitude`
- Identifier columns (excluded from X candidates): `Site`, `Year`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `spotted_hyaena_biomass_log10` | `numeric` | continuous | [-0.3286, 1.8861] | 0% |
| `lion_biomass_log10` | `numeric` | continuous | [0.0504, 1.7202] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `hyena_lion_biomass_africa`, la ou les reponses `spotted_hyaena_biomass_log10`, `lion_biomass_log10` viennent du loader papier et/ou des preuves de l article `Environmental factors influencing spotted hyena and lion population biomass across Africa`. Les covariables X retenues sont `other_predator_biomass_log10`, `prey_very_small_biomass_log10`, `prey_small_biomass_log10`, `prey_medium_biomass_log10`, `prey_large_biomass_log10`, `prey_very_large_biomass_log10`, `min_temperature_coolest_month_log10`, `max_temperature_warmest_month_log10`, `precipitation_wettest_month_log10`, `precipitation_driest_month_log10`, `precipitation_seasonality_log10`, `semi_open_vegetation_clr`, `open_vegetation_clr`, `closed_vegetation_clr` ; 1 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`longitude`, `latitude`), identifiants (`Site`, `Year`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `other_predator_biomass_log10` | `numeric` | continuous | 0% |
| `prey_very_small_biomass_log10` | `numeric` | continuous | 0% |
| `prey_small_biomass_log10` | `numeric` | continuous | 0% |
| `prey_medium_biomass_log10` | `numeric` | continuous | 0% |
| `prey_large_biomass_log10` | `numeric` | continuous | 0% |
| `prey_very_large_biomass_log10` | `numeric` | continuous | 0% |
| `temperature_seasonality_log10` | `numeric` | continuous | 0% |
| `max_temperature_warmest_month_log10` | `numeric` | continuous | 0% |
| `min_temperature_coolest_month_log10` | `numeric` | continuous | 0% |
| `precipitation_wettest_month_log10` | `numeric` | continuous | 0% |
| `precipitation_driest_month_log10` | `numeric` | continuous | 0% |
| `precipitation_seasonality_log10` | `numeric` | continuous | 0% |
| `closed_vegetation_clr` | `numeric` | continuous | 0% |
| `semi_open_vegetation_clr` | `numeric` | continuous | 0% |
| `open_vegetation_clr` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: spotted_hyaena_biomass_log10 / lion_biomass_log10 ~ prey biomass classes + other predator biomass + WorldClim temperature/precipitation + vegetation cover [PLS regression]
- x_terms_pub: other predator biomass, very small prey biomass, small prey biomass, medium prey biomass, large prey biomass, very large prey biomass, minimum temperature of coolest month, maximum temperature of warmest month, temperature seasonality, precipitation wettest month, precipitation driest month, precipitation seasonality, closed vegetation cover, semi-open vegetation cover, open vegetation cover
- y_term_pub: spotted hyena and lion population biomass density, base-10 log transformed
- Reference publication: Jones (2021), Ecology and Evolution, DOI 10.1002/ece3.8359: Sections 2.1-2.2 state that 30 site-year datasets from 14 African sites were analysed with partial least squares regression, using spotted hyena and lion biomass as dependent variables and prey biomass, other predator biomass, temperature, precipitation and vegetation cover as predictors. The Dryad workbook supplies the transformed log10 variables and median coordinates used by the loader.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: spotted_hyaena_biomass_log10 ~ other_predator_biomass_log10 + prey_very_small_biomass_log10 + prey_small_biomass_log10 + prey_medium_biomass_log10 + prey_large_biomass_log10 + prey_very_large_biomass_log10 + min_temperature_coolest_month_log10 + max_temperature_warmest_month_log10 + precipitation_wettest_month_log10 + precipitation_driest_month_log10 + precipitation_seasonality_log10 + semi_open_vegetation_clr + open_vegetation_clr + closed_vegetation_clr
- x_terms_used: other_predator_biomass_log10, prey_very_small_biomass_log10, prey_small_biomass_log10, prey_medium_biomass_log10, prey_large_biomass_log10, prey_very_large_biomass_log10, min_temperature_coolest_month_log10, max_temperature_warmest_month_log10, precipitation_wettest_month_log10, precipitation_driest_month_log10, precipitation_seasonality_log10, semi_open_vegetation_clr, open_vegetation_clr, closed_vegetation_clr
- y_term_used: spotted_hyaena_biomass_log10
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
    formula: "spotted_hyaena_biomass_log10 ~ prey biomass classes + other predator biomass + climate + vegetation cover"
    response: "spotted hyena and lion population biomass density, base-10 log transformed"
    predictors: ["other predator biomass", "very small prey biomass", "small prey biomass", "medium prey biomass", "large prey biomass", "very large prey biomass", "minimum temperature of coolest month", "maximum temperature of warmest month", "temperature seasonality", "precipitation wettest month", "precipitation driest month", "precipitation seasonality", "closed vegetation cover", "semi-open vegetation cover", "open vegetation cover"]
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

- Dataset ID: `paper_hyena_lion_biomass_africa`
- Dataset name: Predator biomass, prey biomass landcover and climate data from spotted hyaena and lion sites in Africa
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Environmental factors influencing spotted hyena and lion population biomass across Africa
- Paper DOI: 10.1002/ece3.8359
- Dataset DOI: 10.5061/dryad.prr4xgxmj
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.prr4xgxmj
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "spotted_hyaena_biomass_log10 / lion_biomass_log10 ~ prey biomass classes + other predator biomass + WorldClim temperature/precipitation + vegetation cover [PLS regression]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Jones (2021), Ecology and Evolution, DOI 10.1002/ece3.8359: Sections 2.1-2.2 state that 30 site-year datasets from 14 African sites were analysed with partial least squares regression, using spotted hyena and lion biomass as dependent variables and prey biomass, other predator biomass, temperature, precipitation and vegetation cover as predictors. The Dryad workbook supplies the transformed log10 variables and median coordinates used by the loader."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous_small_n"
  package_include: "yes"
  has_local_rds: true
  missing_items: "petit N=30 a signaler dans les comparaisons ; le papier travaille lui-meme sur 30 observations site-annee, donc ce n'est pas un defaut de reconstruction"
  reason: "Le papier et le workbook Dryad fournissent 30 observations site-annee avec coordonnees medianes, Y continues log10 et 15 X transformees. Le petit N est conforme a l'analyse publiee et documente comme benchmark small-N."
```

- Decision: ready
- Manque principal: petit N=30 a signaler dans les comparaisons ; le papier travaille lui-meme sur 30 observations site-annee, donc ce n'est pas un defaut de reconstruction
- Raison: Le papier et le workbook Dryad fournissent 30 observations site-annee avec coordonnees medianes, Y continues log10 et 15 X transformees. Le petit N est conforme a l'analyse publiee et documente comme benchmark small-N.

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
- N observations: 30
- k variables: 23
- T periods: 23
- Variable temporelle: Year
- N/T profile: N_petit_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (30) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 13 ; panel NON EQUILIBRE (T par unite : min=1, mediane=2, max=5). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 13 unites spatiales distinctes, pas sur les 30 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 23 distinct periods (variable: Year)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [20.4321615, 37.2424495], y [-28.217601, 3.840778]
- Time range: 1962 to 2009 (variable: Year)
- CRS analyse recommande: 32735 (UTM Zone 35S (EPSG:32735)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.prr4xgxmj (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`hyena_lion_biomass_africa` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `hyena_lion_biomass_africa` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`hyena_lion_biomass_africa` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Environmental factors influencing spotted hyena and lion population biomass across Africa

