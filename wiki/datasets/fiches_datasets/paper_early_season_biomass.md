---
title: paper_early_season_biomass
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_early_season_biomass.rds
  - DataCite_2024_EarlySeasonBiomassAnd_10_1002_ael2_201
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Early-season biomass and weather enable robust cereal rye cover crop biomass predictions" (DOI 10.1002/ael2.20121).

## Description du jeu de donnees

- Topic: agronomie / biomasse de culture de couverture
- Observation unit: placette experimentale (site-annee)
- Observed population: essais de seigle d'hiver (cereal rye) sur 11 etats du centre-est/sud-est des Etats-Unis
- Geographic context: etendue sf: x [-96.42031, -75.455834], y [30.36184, 45.34478]
- Temporal context: 33 distinct periods (variable: plant_date)
- Source description: Early-season biomass and weather enable robust cereal rye cover crop biomass predictions
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1002/ael2.20121
- Dataset DOI: 10.5061/dryad.ngf1vhj1r
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.ngf1vhj1r
- Local raw dir: `data/raw/papers/DataCite_2024_EarlySeasonBiomassAnd_10_1002_ael2_201/`
- Local sf output: `data/final_datasets/sf/paper_early_season_biomass.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `late_bm_kg_ha`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `year`, `early_bm_kg_ha`, `plant_date`, `early_term_date`, `late_term_date`, `CGDD_plant_early_term`, `CGDD_early_late_term`, `mean_PAR`, `cuml_precip_plant_early_term`, `cuml_precip_early_late_term`
- Candidate X count in local artifact: 10
- Candidate X typology: continuous, categorical
- Published X variables from paper: early_bm_kg_ha, CGDD_plant_early_term, CGDD_early_late_term, mean_PAR, cuml_precip_plant_early_term, cuml_precip_early_late_term
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): `state`, `block`, `site`, `early_plot`, `late_plot`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `late_bm_kg_ha` | `numeric` | continuous | [0, 11892] | 3.9% |

> Selection Y/X (paper-loader / curated evidence) : Pour `early_season_biomass`, la ou les reponses `late_bm_kg_ha` viennent du loader papier et/ou des preuves de l article `Early-season biomass and weather enable robust cereal rye cover crop biomass predictions`. Les covariables X retenues sont `early_bm_kg_ha`, `CGDD_plant_early_term`, `CGDD_early_late_term`, `mean_PAR`, `cuml_precip_plant_early_term`, `cuml_precip_early_late_term` ; 4 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`lon`, `lat`), identifiants (`state`, `block`, `site`, `early_plot`, `late_plot`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `year` | `integer` | count | 0% |
| `early_bm_kg_ha` | `numeric` | continuous | 3.9% |
| `plant_date` | `character` | categorical | 9.4% |
| `early_term_date` | `character` | categorical | 4.7% |
| `late_term_date` | `character` | categorical | 4.7% |
| `CGDD_plant_early_term` | `numeric` | continuous | 4.7% |
| `CGDD_early_late_term` | `numeric` | continuous | 4.7% |
| `mean_PAR` | `numeric` | continuous | 4.7% |
| `cuml_precip_plant_early_term` | `numeric` | continuous | 4.7% |
| `cuml_precip_early_late_term` | `numeric` | continuous | 4.7% |

### Formule - niveau publication

- formula_pub: late_bm_kg_ha ~ early_bm_kg_ha + CGDD_plant_early_term + CGDD_early_late_term + mean_PAR + cuml_precip_plant_early_term + cuml_precip_early_late_term
- x_terms_pub: early_bm_kg_ha, CGDD_plant_early_term, CGDD_early_late_term, mean_PAR, cuml_precip_plant_early_term, cuml_precip_early_late_term
- y_term_pub: late_bm_kg_ha
- Reference publication: Huddell et al. (2024), Agricultural & Environmental Letters, DOI 10.1002/ael2.20121; data_dictionary.csv (Dryad 10.5061/dryad.ngf1vhj1r) definit late_bm_kg_ha comme biomasse au moment de la terminaison tardive -- la variable predite d'apres le titre du papier (early-season biomass and weather enable ... biomass predictions).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Huddell et al. (2024), Agricultural & Environmental Letters, DOI 10.1002/ael2.20121; data_dictionary.csv (Dryad 10.5061/dryad.ngf1vhj1r) definit late_bm_kg_ha comme biomasse au moment de la terminaison tardive -- la variable predite d'apres le titre du papier (early-season biomass and weather enable ... biomass predictions).

### Formule - niveau systeme

- formula_used: late_bm_kg_ha ~ early_bm_kg_ha + CGDD_plant_early_term + CGDD_early_late_term + mean_PAR + cuml_precip_plant_early_term + cuml_precip_early_late_term
- x_terms_used: early_bm_kg_ha, CGDD_plant_early_term, CGDD_early_late_term, mean_PAR, cuml_precip_plant_early_term, cuml_precip_early_late_term
- y_term_used: late_bm_kg_ha
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Huddell et al. (2024), Agricultural & Environmental Letters, DOI 10.1002/ael2.20121; data_dictionary.csv (Dryad 10.5061/dryad.ngf1vhj1r) definit late_bm_kg_ha comme biomasse au moment de la terminaison tardive -- la variable predite d'apres le titre du papier (early-season biomass and weather enable ... biomass predictions).

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
    formula: "late_bm_kg_ha ~ early_bm_kg_ha + CGDD_plant_early_term + CGDD_early_late_term + mean_PAR + cuml_precip_plant_early_term + cuml_precip_early_late_term"
    response: "late_bm_kg_ha"
    predictors: ["early_bm_kg_ha", "CGDD_plant_early_term", "CGDD_early_late_term", "mean_PAR", "cuml_precip_plant_early_term", "cuml_precip_early_late_term"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Huddell et al. (2024), Agricultural & Environmental Letters, DOI 10.1002/ael2.20121; data_dictionary.csv (Dryad 10.5061/dryad.ngf1vhj1r) definit late_bm_kg_ha comme biomasse au moment de la terminaison tardive -- la variable predite d'apres le titre du papier (early-season biomass and weather enable ... biomass predictions)."
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

- Dataset ID: `paper_early_season_biomass`
- Dataset name: Early-season biomass and weather enable robust cereal rye cover crop biomass predictions
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Early-season biomass and weather enable robust cereal rye cover crop biomass predictions
- Paper DOI: 10.1002/ael2.20121
- Dataset DOI: 10.5061/dryad.ngf1vhj1r
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.ngf1vhj1r
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "late_bm_kg_ha ~ early_bm_kg_ha + CGDD_plant_early_term + CGDD_early_late_term + mean_PAR + cuml_precip_plant_early_term + cuml_precip_early_late_term"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Huddell et al. (2024), Agricultural & Environmental Letters, DOI 10.1002/ael2.20121; data_dictionary.csv (Dryad 10.5061/dryad.ngf1vhj1r) definit late_bm_kg_ha comme biomasse au moment de la terminaison tardive -- la variable predite d'apres le titre du papier (early-season biomass and weather enable ... biomass predictions)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun bloquant identifie"
  reason: "late_bm_kg_ha continu, 5 covariables meteo/agronomiques documentees dans data_dictionary.csv, coordonnees WGS84, N=512 confirmes par contenu reel. Y continu, X defendables, artefact local utilisable -- promu sans revue manuelle (2026-08-12)."
```

- Decision: ready
- Manque principal: aucun bloquant identifie
- Raison: late_bm_kg_ha continu, 5 covariables meteo/agronomiques documentees dans data_dictionary.csv, coordonnees WGS84, N=512 confirmes par contenu reel. Y continu, X defendables, artefact local utilisable -- promu sans revue manuelle (2026-08-12).

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
- N observations: 512
- k variables: 21
- T periods: 33
- Variable temporelle: plant_date
- N/T profile: N_grand_T_grand

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 33 distinct periods (variable: plant_date)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-96.42031, -75.455834], y [30.36184, 45.34478]
- Time range: 10/1/2019 to 9/8/2017 (variable: plant_date)
- CRS analyse recommande: pending - multi-zones (span=21deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`early_season_biomass` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `early_season_biomass` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`early_season_biomass` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Early-season biomass and weather enable robust cereal rye cover crop biomass predictions

