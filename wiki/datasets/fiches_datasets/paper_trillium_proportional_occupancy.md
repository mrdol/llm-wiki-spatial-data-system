---
title: paper_trillium_proportional_occupancy
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_trillium_proportional_occupancy.rds
  - DataCite_2021_ReproductiveTraitsExplainOccupancy_10_1111_ddi_1329
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Reproductive traits explain occupancy of predicted distributions in a genus of eastern North American understory herbs" (DOI 10.1111/ddi.13297).

## Description du jeu de donnees

- Topic: ecologie vegetale / modeles de distribution d'especes
- Observation unit: point d'occurrence ou pseudo-absence background
- Observed population: occurrences georeferencees de 19 especes de Trillium en Amerique du Nord orientale, completees par un background SDM reconstruit
- Geographic context: etendue sf: x [-92.0867186, -76.6557541], y [30.8668907, 42.0912469]
- Temporal context: none (cross-sectional)
- Source description: Reproductive traits explain occupancy of predicted distributions in a genus of eastern North American understory herbs
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/ddi.13297
- Dataset DOI: 10.5061/dryad.6m905qg03
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.6m905qg03
- Local raw dir: `data/raw/papers/DataCite_2021_ReproductiveTraitsExplainOccupancy_10_1111_ddi_1329/`
- Local sf output: `data/final_datasets/sf/paper_trillium_proportional_occupancy.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `PO`
- Candidate Y typology: rate
- Candidate X variables in local artifact: `EOO_Area`, `EOO_IntersectPSA.Area`, `PSA_area`, `total_occ`, `Biomass`, `No_ovules`, `No_seeds_plant`, `Seed_setting_rate`, `Seed_weight`, `Flower_Type`, `observed_occurrences_local`
- Candidate X count in local artifact: 11
- Candidate X typology: continuous
- Published X variables from paper: Flower_Type, No_ovules, Seed_weight, Seed_setting_rate, No_seeds_plant, Biomass
- Published X count: 6
- Coordinates (x, y - excluded from X candidates): `Longitude`, `Latitude`
- Identifier columns (excluded from X candidates): `species`, `NatServe_Status`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PO` | `numeric` | rate | [0.0118, 0.9624] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `trillium_proportional_occupancy`, la ou les reponses `PO` viennent du loader papier et/ou des preuves de l article `Reproductive traits explain occupancy of predicted distributions in a genus of eastern North American understory herbs`. Les covariables X retenues sont `No_ovules`, `Seed_weight`, `Flower_Type` ; 8 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Longitude`, `Latitude`), identifiants (`species`, `NatServe_Status`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `EOO_Area` | `numeric` | continuous | 0% |
| `EOO_IntersectPSA.Area` | `numeric` | continuous | 0% |
| `PSA_area` | `numeric` | continuous | 0% |
| `total_occ` | `integer` | count | 0% |
| `Biomass` | `numeric` | continuous | 0% |
| `No_ovules` | `numeric` | continuous | 0% |
| `No_seeds_plant` | `numeric` | continuous | 0% |
| `Seed_setting_rate` | `numeric` | continuous | 0% |
| `Seed_weight` | `numeric` | continuous | 0% |
| `Flower_Type` | `numeric` | continuous | 0% |
| `observed_occurrences_local` | `integer` | count | 0% |

### Formule - niveau publication

- formula_pub: PO ~ Flower_Type + No_ovules + Seed_weight [beta regression; model building also considered seed set, seeds per plant and adult biomass]
- x_terms_pub: Flower_Type, No_ovules, Seed_weight, Seed_setting_rate, No_seeds_plant, Biomass
- y_term_pub: proportional occupancy of predicted suitable distribution (PO)
- Reference publication: Miller et al. (2021), Diversity and Distributions, DOI 10.1111/ddi.13297: the paper estimates fundamental niches with ENM/MaxEnt, derives proportional occupancy PO, then relates PO to reproductive traits using beta regression and AICc model selection. The local loader uses Trillium_LifeHistoryTraits.csv from Dryad 10.5061/dryad.6m905qg03 and species occurrence centroids from the accompanying occurrence CSVs. This is the continuous regression companion to paper_trillium_presence_background.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Miller et al. (2021), Diversity and Distributions, DOI 10.1111/ddi.13297: the paper estimates fundamental niches with ENM/MaxEnt, derives proportional occupancy PO, then relates PO to reproductive traits using beta regression and AICc model selection. The local loader uses Trillium_LifeHistoryTraits.csv from Dryad 10.5061/dryad.6m905qg03 and species occurrence centroids from the accompanying occurrence CSVs. This is the continuous regression companion to paper_trillium_presence_background.

### Formule - niveau systeme

- formula_used: PO ~ No_ovules + Seed_weight + Flower_Type
- x_terms_used: No_ovules, Seed_weight, Flower_Type
- y_term_used: PO
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Miller et al. (2021), Diversity and Distributions, DOI 10.1111/ddi.13297: the paper estimates fundamental niches with ENM/MaxEnt, derives proportional occupancy PO, then relates PO to reproductive traits using beta regression and AICc model selection. The local loader uses Trillium_LifeHistoryTraits.csv from Dryad 10.5061/dryad.6m905qg03 and species occurrence centroids from the accompanying occurrence CSVs. This is the continuous regression companion to paper_trillium_presence_background.

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
    formula: "PO ~ reproductive traits"
    response: "proportional occupancy of predicted suitable distribution (PO)"
    predictors: ["Flower_Type", "No_ovules", "Seed_weight", "Seed_setting_rate", "No_seeds_plant", "Biomass"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Miller et al. (2021), Diversity and Distributions, DOI 10.1111/ddi.13297: the paper estimates fundamental niches with ENM/MaxEnt, derives proportional occupancy PO, then relates PO to reproductive traits using beta regression and AICc model selection. The local loader uses Trillium_LifeHistoryTraits.csv from Dryad 10.5061/dryad.6m905qg03 and species occurrence centroids from the accompanying occurrence CSVs. This is the continuous regression companion to paper_trillium_presence_background."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "PO ~ No_ovules + Seed_weight + Flower_Type"
    response: "PO"
    predictors: ["No_ovules", "Seed_weight", "Flower_Type"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Miller et al. (2021), Diversity and Distributions, DOI 10.1111/ddi.13297: the paper estimates fundamental niches with ENM/MaxEnt, derives proportional occupancy PO, then relates PO to reproductive traits using beta regression and AICc model selection. The local loader uses Trillium_LifeHistoryTraits.csv from Dryad 10.5061/dryad.6m905qg03 and species occurrence centroids from the accompanying occurrence CSVs. This is the continuous regression companion to paper_trillium_presence_background."
    estimator_context: ["ols", "gam_spatial", "random_forest", "xgboost", "gamboost"]
    status: "confirmed_continuous_response"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_trillium_proportional_occupancy`
- Dataset name: Data associated with ecological niche models and post-ENM statistical analyses for Trillium species distributions
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Reproductive traits explain occupancy of predicted distributions in a genus of eastern North American understory herbs
- Paper DOI: 10.1111/ddi.13297
- Dataset DOI: 10.5061/dryad.6m905qg03
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.6m905qg03
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "PO ~ Flower_Type + No_ovules + Seed_weight [beta regression; model building also considered seed set, seeds per plant and adult biomass]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Miller et al. (2021), Diversity and Distributions, DOI 10.1111/ddi.13297: the paper estimates fundamental niches with ENM/MaxEnt, derives proportional occupancy PO, then relates PO to reproductive traits using beta regression and AICc model selection. The local loader uses Trillium_LifeHistoryTraits.csv from Dryad 10.5061/dryad.6m905qg03 and species occurrence centroids from the accompanying occurrence CSVs. This is the continuous regression companion to paper_trillium_presence_background."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous_proportion"
  package_include: "yes"
  has_local_rds: true
  missing_items: "petit nombre d'especes apres complete.cases ; coordonnees = centroide des occurrences par espece, car l'unite statistique du papier est espece-niveau"
  reason: "PO est une reponse continue dans (0,1) directement fournie dans Trillium_LifeHistoryTraits.csv, avec traits reproductifs publies. Cette fiche suit la beta-regression finale du papier mieux que la version presence/background."
```

- Decision: ready
- Manque principal: petit nombre d'especes apres complete.cases ; coordonnees = centroide des occurrences par espece, car l'unite statistique du papier est espece-niveau
- Raison: PO est une reponse continue dans (0,1) directement fournie dans Trillium_LifeHistoryTraits.csv, avec traits reproductifs publies. Cette fiche suit la beta-regression finale du papier mieux que la version presence/background.

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
- N observations: 16
- k variables: 18
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_petit_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-92.0867186, -76.6557541], y [30.8668907, 42.0912469]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32616 (UTM Zone 16N (EPSG:32616)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`trillium_proportional_occupancy` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `trillium_proportional_occupancy` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`trillium_proportional_occupancy` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Reproductive traits explain occupancy of predicted distributions in a genus of eastern North American understory herbs

