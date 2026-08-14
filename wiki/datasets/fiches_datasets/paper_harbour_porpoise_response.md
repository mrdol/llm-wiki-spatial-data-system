---
title: paper_harbour_porpoise_response
type: dataset
created: 2026-08-14
updated: 2026-08-14
sources:
  - data/final_datasets/sf/paper_harbour_porpoise_response.rds
  - DataCite_2019_HarbourPorpoiseResponsesTo_10_1098_rsos_190
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Harbour porpoise responses to pile-driving diminish over time" (DOI 10.1098/rsos.190335).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale du dataset "Data from: Harbour porpoise responses to pile-driving diminish over time"
- Observed population: RÃ©ponses comportementales de marsouins au bruit de battage de pieux ; dÃ©tecteurs d'Ã©cholocation et enregistreurs de bruit avec coordonnÃ©es spatiales ; rÃ©gression pour probabilitÃ© de rÃ©ponse en fonction de la distance ; 75 citations
- Geographic context: etendue sf: x [-3.955967, -2.6177], y [57.8164, 58.33725]
- Temporal context: none (cross-sectional)
- Source description: Harbour porpoise responses to pile-driving diminish over time
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1098/rsos.190335
- Dataset DOI: 10.5061/dryad.5qg30sd
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.5qg30sd
- Local raw dir: `data/raw/papers/DataCite_2019_HarbourPorpoiseResponsesTo_10_1098_rsos_190/`
- Local sf output: `data/final_datasets/sf/paper_harbour_porpoise_response.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `prop24`, `prop12`, `resp24_50`, `resp12_50`
- Candidate Y typology: continuous, binary
- Candidate X variables in local artifact: `dph24`, `dph12`, `base24`, `base12`, `distance`, `vessels24_1km`, `vessels12_1km`, `vessels24_500m`, `vessels12_500m`, `duration`, `piling_order`, `Unweighted_SS_SEL`, `NOAA_SS_SEL`, `Southall_SS_SEL`, `Aud_SS_SEL`
- Candidate X count in local artifact: 15
- Candidate X typology: continuous
- Published X variables from paper: distance, received sound exposure level, cumulative piling order, ADD use, piling duration, vessel activity
- Published X count: 6
- Coordinates (x, y - excluded from X candidates): `Longitude`, `Latitude`
- Identifier columns (excluded from X candidates): `dep_no`, `turbine`, `location`, `pod`, `POD_number`, `Location_ID`, `ADD`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `prop24` | `numeric` | continuous | [-1, 6] | 0% |
| `prop12` | `numeric` | continuous | [-1, Inf] | 2.1% |
| `resp24_50` | `integer` | binary | {0, 1} | 0% |
| `resp12_50` | `integer` | binary | {0, 1} | 2.1% |

> Selection Y/X (paper-loader / curated evidence) : Pour `harbour_porpoise_response`, la ou les reponses `prop24`, `prop12`, `resp24_50`, `resp12_50` viennent du loader papier et/ou des preuves de l article `Harbour porpoise responses to pile-driving diminish over time`. Les covariables X retenues sont `distance`, `vessels24_1km`, `duration`, `piling_order`, `Unweighted_SS_SEL`, `NOAA_SS_SEL`, `Southall_SS_SEL`, `Aud_SS_SEL` ; 7 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Longitude`, `Latitude`), identifiants (`dep_no`, `turbine`, `location`, `pod`, `POD_number`, `Location_ID`, `ADD`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `dph24` | `integer` | count | 0% |
| `dph12` | `integer` | count | 0% |
| `base24` | `integer` | count | 0% |
| `base12` | `integer` | count | 0% |
| `distance` | `numeric` | continuous | 0% |
| `vessels24_1km` | `integer` | count | 0% |
| `vessels12_1km` | `integer` | count | 0% |
| `vessels24_500m` | `integer` | count | 0% |
| `vessels12_500m` | `integer` | count | 0% |
| `duration` | `numeric` | continuous | 0% |
| `piling_order` | `integer` | count | 0% |
| `Unweighted_SS_SEL` | `numeric` | continuous | 0% |
| `NOAA_SS_SEL` | `numeric` | continuous | 0% |
| `Southall_SS_SEL` | `numeric` | continuous | 0% |
| `Aud_SS_SEL` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: response_24h ~ log(distance_to_piling) * cumulative_piling_order + received_SEL + ADD + piling_duration + vessel_activity + random_effect(CPOD_site/POD) [binomial probit GLMM]
- x_terms_pub: distance, received sound exposure level, cumulative piling order, ADD use, piling duration, vessel activity
- y_term_pub: binary behavioural response and proportional DPH change after piling
- Reference publication: Graham et al. (2019), Royal Society Open Science, DOI 10.1098/rsos.190335: Material and methods model binary response with probit GLMM; distance/log distance and received SEL are used in separate models, with cumulative piling order, ADD, duration and vessel activity. The current regression benchmark uses the continuous proportional 24h DPH change prop24 from the same response table, joined to CPOD coordinates.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-14). Graham et al. (2019), Royal Society Open Science, DOI 10.1098/rsos.190335: Material and methods model binary response with probit GLMM; distance/log distance and received SEL are used in separate models, with cumulative piling order, ADD, duration and vessel activity. The current regression benchmark uses the continuous proportional 24h DPH change prop24 from the same response table, joined to CPOD coordinates.

### Formule - niveau systeme

- formula_used: prop24 ~ distance + vessels24_1km + duration + piling_order + Unweighted_SS_SEL + NOAA_SS_SEL + Southall_SS_SEL + Aud_SS_SEL
- x_terms_used: distance, vessels24_1km, duration, piling_order, Unweighted_SS_SEL, NOAA_SS_SEL, Southall_SS_SEL, Aud_SS_SEL
- y_term_used: prop24
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-14). Graham et al. (2019), Royal Society Open Science, DOI 10.1098/rsos.190335: Material and methods model binary response with probit GLMM; distance/log distance and received SEL are used in separate models, with cumulative piling order, ADD, duration and vessel activity. The current regression benchmark uses the continuous proportional 24h DPH change prop24 from the same response table, joined to CPOD coordinates.

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
    formula: "prop24 ~ distance + vessel activity + piling duration/order + sound exposure levels"
    response: "binary behavioural response and proportional DPH change after piling"
    predictors: ["distance", "received sound exposure level", "cumulative piling order", "ADD use", "piling duration", "vessel activity"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Graham et al. (2019), Royal Society Open Science, DOI 10.1098/rsos.190335: Material and methods model binary response with probit GLMM; distance/log distance and received SEL are used in separate models, with cumulative piling order, ADD, duration and vessel activity. The current regression benchmark uses the continuous proportional 24h DPH change prop24 from the same response table, joined to CPOD coordinates."
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

- Dataset ID: `paper_harbour_porpoise_response`
- Dataset name: Data from: Harbour porpoise responses to pile-driving diminish over time
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Harbour porpoise responses to pile-driving diminish over time
- Paper DOI: 10.1098/rsos.190335
- Dataset DOI: 10.5061/dryad.5qg30sd
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.5qg30sd
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "response_24h ~ log(distance_to_piling) * cumulative_piling_order + received_SEL + ADD + piling_duration + vessel_activity + random_effect(CPOD_site/POD) [binomial probit GLMM]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Graham et al. (2019), Royal Society Open Science, DOI 10.1098/rsos.190335: Material and methods model binary response with probit GLMM; distance/log distance and received SEL are used in separate models, with cumulative piling order, ADD, duration and vessel activity. The current regression benchmark uses the continuous proportional 24h DPH change prop24 from the same response table, joined to CPOD coordinates."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "la reponse publiee principale est binaire ; formula_used utilise prop24 continu pour le package de regression"
  reason: "Le tableau local fournit prop24 continu, coordonnees CPOD, distance, exposition sonore, ordre/duree de battage et activite navire. Version continue defendable et tracee."
```

- Decision: ready
- Manque principal: la reponse publiee principale est binaire ; formula_used utilise prop24 continu pour le package de regression
- Raison: Le tableau local fournit prop24 continu, coordonnees CPOD, distance, exposition sonore, ordre/duree de battage et activite navire. Version continue defendable et tracee.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready"
  eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
  conditionally_eligible_estimators: []
  ineligible_reason: ""
  rule: "paper fiches are eligible only when response, predictors, coordinates/geometry and required W are executable in the local artifact"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 700
- k variables: 30
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-3.955967, -2.6177], y [57.8164, 58.33725]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32630 (UTM Zone 30N (EPSG:32630)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`harbour_porpoise_response` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `harbour_porpoise_response` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`harbour_porpoise_response` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Harbour porpoise responses to pile-driving diminish over time

