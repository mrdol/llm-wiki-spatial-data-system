---
title: paper_ethiopia_whitetailed_swallow_sdm
type: dataset
created: 2026-08-12
updated: 2026-08-12
sources:
  - data/final_datasets/sf/paper_ethiopia_whitetailed_swallow_sdm.rds
  - DataCite_2021_ClimaticChangeAndExtinction_10_1371_journal_
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Climatic change and extinction risk of two globally threatened Ethiopian endemic bird species" (DOI 10.1371/journal.pone.0249633).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale du dataset "Research data supporting ''Climatic change and extinction risk of two globally threatened Ethiopian endemic bird species''"
- Observed population: Species Distribution Models (SDM) pour oiseaux endémiques Éthiopie avec projections climatiques ; 31 citations ; domaine biodiversité/climate change ; SDM est une forme de modélisation spatiale prédictive
- Geographic context: etendue sf: x [37.61667, 39.77842], y [3.527, 5.38552]
- Temporal context: none (cross-sectional)
- Source description: Climatic change and extinction risk of two globally threatened Ethiopian endemic bird species
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1371/journal.pone.0249633
- Dataset DOI: 10.17863/cam.65907
- Source URL: https://www.repository.cam.ac.uk/handle/1810/319808
- Local raw dir: `data/raw/papers/DataCite_2021_ClimaticChangeAndExtinction_10_1371_journal_/`
- Local sf output: `data/final_datasets/sf/paper_ethiopia_whitetailed_swallow_sdm.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `pa`
- Candidate Y typology: binary
- Candidate X variables in local artifact: `temp_seasonality`, `max_temp_warmest_month`, `temp_annual_range`, `precip_wettest_quarter`, `precip_driest_quarter`
- Candidate X count in local artifact: 5
- Candidate X typology: continuous
- Published X variables from paper: max_temp_warmest_month, temp_seasonality, temp_annual_range, precip_wettest_quarter, precip_driest_quarter
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `pa` | `integer` | binary | {0, 1} | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `ethiopia_whitetailed_swallow_sdm`, la ou les reponses `pa` viennent du loader papier et/ou des preuves de l article `Climatic change and extinction risk of two globally threatened Ethiopian endemic bird species`. Les covariables X retenues sont `max_temp_warmest_month`, `temp_seasonality`, `temp_annual_range`, `precip_wettest_quarter`, `precip_driest_quarter`. Les coordonnees (`lon`, `lat`), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : almost_ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `temp_seasonality` | `numeric` | continuous | 0% |
| `max_temp_warmest_month` | `numeric` | continuous | 0% |
| `temp_annual_range` | `numeric` | continuous | 0% |
| `precip_wettest_quarter` | `numeric` | continuous | 0% |
| `precip_driest_quarter` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: pa ~ max_temp_warmest_month + temp_seasonality + temp_annual_range + precip_wettest_quarter + precip_driest_quarter [MaxEnt/GLM/GAM]
- x_terms_pub: max_temp_warmest_month, temp_seasonality, temp_annual_range, precip_wettest_quarter, precip_driest_quarter
- y_term_pub: pa
- Reference publication: Bladon et al. (2021), PLOS ONE, DOI 10.1371/journal.pone.0249633, p.3 Materials and methods: memes 5 variables WorldClim que le bush-crow, memes reserves sur la resolution et l'origine externe des covariables (telechargees le 2026-08-12).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-12). Bladon et al. (2021), PLOS ONE, DOI 10.1371/journal.pone.0249633, p.3 Materials and methods: memes 5 variables WorldClim que le bush-crow, memes reserves sur la resolution et l'origine externe des covariables (telechargees le 2026-08-12).

### Formule - niveau systeme

- formula_used: pa ~ max_temp_warmest_month + temp_seasonality + temp_annual_range + precip_wettest_quarter + precip_driest_quarter
- x_terms_used: max_temp_warmest_month, temp_seasonality, temp_annual_range, precip_wettest_quarter, precip_driest_quarter
- y_term_used: pa
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-12). Bladon et al. (2021), PLOS ONE, DOI 10.1371/journal.pone.0249633, p.3 Materials and methods: memes 5 variables WorldClim que le bush-crow, memes reserves sur la resolution et l'origine externe des covariables (telechargees le 2026-08-12).

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
    formula: "pa ~ max_temp_warmest_month + temp_seasonality + temp_annual_range + precip_wettest_quarter + precip_driest_quarter"
    response: "pa"
    predictors: ["max_temp_warmest_month", "temp_seasonality", "temp_annual_range", "precip_wettest_quarter", "precip_driest_quarter"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Bladon et al. (2021), PLOS ONE, DOI 10.1371/journal.pone.0249633, p.3 Materials and methods: memes 5 variables WorldClim que le bush-crow, memes reserves sur la resolution et l'origine externe des covariables (telechargees le 2026-08-12)."
    estimator_context: ["random_forest", "gamboost", "xgboost"]
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

- Dataset ID: `paper_ethiopia_whitetailed_swallow_sdm`
- Dataset name: Research data supporting ''Climatic change and extinction risk of two globally threatened Ethiopian endemic bird species''
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Climatic change and extinction risk of two globally threatened Ethiopian endemic bird species
- Paper DOI: 10.1371/journal.pone.0249633
- Dataset DOI: 10.17863/cam.65907
- Source URL: https://www.repository.cam.ac.uk/handle/1810/319808
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "pa ~ max_temp_warmest_month + temp_seasonality + temp_annual_range + precip_wettest_quarter + precip_driest_quarter [MaxEnt/GLM/GAM]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Bladon et al. (2021), PLOS ONE, DOI 10.1371/journal.pone.0249633, p.3 Materials and methods: memes 5 variables WorldClim que le bush-crow, memes reserves sur la resolution et l'origine externe des covariables (telechargees le 2026-08-12)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "almost_ready"
  benchmark_task: "classification_binary_presence_absence"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "idem ethiopia_bushcrow_sdm"
  reason: "Meme source/reserve que ethiopia_bushcrow_sdm."
```

- Decision: almost_ready
- Manque principal: idem ethiopia_bushcrow_sdm
- Raison: Meme source/reserve que ethiopia_bushcrow_sdm.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "almost_ready"
  eligible_estimators: []
  conditionally_eligible_estimators: ["random_forest", "random_forest_xy", "gamboost", "xgboost", "xgboost_xy", "gam_spatial"]
  ineligible_reason: "reponse binaire (presence/absence) ; le registre benchmark du package (13-benchmark-spatial.R) code en dur mode='regression' pour tous les estimateurs automatiques -- aucun ne supporte de mode classification/binomial aujourd'hui. random_forest/gamboost/xgboost sont notes conditionnels car ce sont les estimateurs que le papier source a reellement utilises (RF/BRT) ; ols/sar_lag/sem_error/sdm_mixed/gwr restent hors de propos pour une reponse binaire (hypothese gaussienne continue) et ne sont pas listes."
  rule: "paper fiches are eligible only when response, predictors, coordinates/geometry and required W are executable in the local artifact"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 810
- k variables: 10
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [37.61667, 39.77842], y [3.527, 5.38552]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32637 (UTM Zone 37N (EPSG:32637)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`ethiopia_whitetailed_swallow_sdm` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `ethiopia_whitetailed_swallow_sdm` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`ethiopia_whitetailed_swallow_sdm` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Climatic change and extinction risk of two globally threatened Ethiopian endemic bird species

