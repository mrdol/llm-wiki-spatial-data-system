---
title: paper_trillium_presence_background
type: dataset
created: 2026-09-14
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_trillium_presence_background.rds
  - DataCite_2021_ReproductiveTraitsExplainOccupancy_10_1111_ddi_1329
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Reproductive traits explain occupancy of predicted distributions in a genus of eastern North American understory herbs" (DOI 10.1111/ddi.13297).

## Description du jeu de donnees

- Topic: ecologie vegetale / modeles de distribution d'especes
- Observation unit: point d'occurrence ou pseudo-absence background
- Observed population: occurrences georeferencees de 19 especes de Trillium en Amerique du Nord orientale, completees par un background SDM reconstruit
- Geographic context: etendue sf: x [-96.5136988, -52.978667], y [28.9134189, 54.0719782]
- Temporal context: none (cross-sectional)
- Source description: Reproductive traits explain occupancy of predicted distributions in a genus of eastern North American understory herbs
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/ddi.13297
- Dataset DOI: 10.5061/dryad.6m905qg03
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.6m905qg03
- Local raw dir: `data/raw/papers/DataCite_2021_ReproductiveTraitsExplainOccupancy_10_1111_ddi_1329/`
- Local sf output: `data/final_datasets/sf/paper_trillium_presence_background.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `presence`
- Candidate Y typology: binary
- Candidate X variables in local artifact: `bio1_annual_mean_temperature`, `bio4_temperature_seasonality`, `bio5_max_temperature_warmest_month`, `bio6_min_temperature_coldest_month`, `bio12_annual_precipitation`, `bio15_precipitation_seasonality`
- Candidate X count in local artifact: 6
- Candidate X typology: continuous
- Published X variables from paper: Flower_Type, No_ovules, Seed_weight
- Published X count: 3
- Coordinates (x, y - excluded from X candidates): `longitude`, `latitude`
- Identifier columns (excluded from X candidates): `species`, `source_file`, `background_id`, `record_type`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `presence` | `integer` | binary | {0, 1} | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `trillium_presence_background`, la ou les reponses `presence` viennent du loader papier et/ou des preuves de l article `Reproductive traits explain occupancy of predicted distributions in a genus of eastern North American understory herbs`. Les covariables X retenues sont `bio1_annual_mean_temperature`, `bio4_temperature_seasonality`, `bio5_max_temperature_warmest_month`, `bio6_min_temperature_coldest_month`, `bio12_annual_precipitation`, `bio15_precipitation_seasonality`. Les coordonnees (`longitude`, `latitude`), identifiants (`species`, `source_file`, `background_id`, `record_type`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `bio1_annual_mean_temperature` | `numeric` | continuous | 0% |
| `bio4_temperature_seasonality` | `numeric` | continuous | 0% |
| `bio5_max_temperature_warmest_month` | `numeric` | continuous | 0% |
| `bio6_min_temperature_coldest_month` | `numeric` | continuous | 0% |
| `bio12_annual_precipitation` | `numeric` | continuous | 0% |
| `bio15_precipitation_seasonality` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: PO ~ Flower_Type + No_ovules + Seed_weight [beta regression; model building also considered seed set, seeds per plant and adult biomass]
- x_terms_pub: Flower_Type, No_ovules, Seed_weight
- y_term_pub: proportional occupancy of predicted suitable distribution (PO); presence/background occurrence model is an executable upstream SDM reconstruction, not the paper's final beta-regression response
- Reference publication: Miller et al. (2021), Diversity and Distributions, DOI 10.1111/ddi.13297. TEI/PDF methods and abstract state that fundamental niches and predicted suitable distributions were estimated using climate-calibrated ecological niche models; PO = occupied distribution area / predicted suitable area; reproductive traits (ovule number, seed set, number of seeds per plant, seed mass, adult biomass, flower type) were related to PO using beta regression and AICc. The local Dryad folder contains occurrence CSVs and Trillium_LifeHistoryTraits.csv, but not the full ClimateNA ENM raster stack; formula_used is therefore a documented executable SDM reconstruction, not a claim to reproduce the final beta-regression exactly.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

### Formule - niveau systeme

- formula_used: presence ~ bio1_annual_mean_temperature + bio4_temperature_seasonality + bio5_max_temperature_warmest_month + bio6_min_temperature_coldest_month + bio12_annual_precipitation + bio15_precipitation_seasonality
- License evidence: DataCite API record for DOI 10.5061/dryad.6m905qg03 (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: binary
- x_terms_used: bio1_annual_mean_temperature, bio4_temperature_seasonality, bio5_max_temperature_warmest_month, bio6_min_temperature_coldest_month, bio12_annual_precipitation, bio15_precipitation_seasonality
- y_term_used: presence
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
    formula: "PO ~ Flower_Type + No_ovules + Seed_weight"
    response: "proportional occupancy of predicted suitable distribution (PO); presence/background occurrence model is an executable upstream SDM reconstruction, not the paper's final beta-regression response"
    predictors: ["Flower_Type", "No_ovules", "Seed_weight"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["random_forest", "gamboost", "xgboost"]
    status: "confirmed"

  ml_or_selected:
    formula: "presence ~ bio1_annual_mean_temperature + bio4_temperature_seasonality + bio5_max_temperature_warmest_month + bio6_min_temperature_coldest_month + bio12_annual_precipitation + bio15_precipitation_seasonality"
    response: "presence"
    predictors: ["bio1_annual_mean_temperature", "bio4_temperature_seasonality", "bio5_max_temperature_warmest_month", "bio6_min_temperature_coldest_month", "bio12_annual_precipitation", "bio15_precipitation_seasonality"]
    role: "ml_candidate_features"
    source_type: "derived_from_scientific_publication_plus_public_covariates"
    source_ref: "Executable SDM-style reconstruction from Dryad occurrence CSVs (10.5061/dryad.6m905qg03) plus WorldClim v2.1 bioclimatic rasters. Background pseudo-absences are generated deterministically within species-specific occurrence bounding boxes expanded by one degree. This is a reproducible benchmark surrogate because the paper used ClimateNA ENMs and predicted suitable areas, but the ClimateNA raster stack and final ENM surfaces are not redistributed in the local Dryad files."
    estimator_context: ["random_forest", "xgboost", "gamboost"]
    status: "extracted_needs_review"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_trillium_presence_background`
- Dataset name: Data associated with ecological niche models and post-ENM statistical analyses for Trillium species distributions
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Reproductive traits explain occupancy of predicted distributions in a genus of eastern North American understory herbs
- Paper DOI: 10.1111/ddi.13297
- Dataset DOI: 10.5061/dryad.6m905qg03
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.6m905qg03
- Year: 2021 (annee de depot Dryad/DataCite, non verifiee comme annee de publication de l'article -- voir Reference publication)

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "PO ~ Flower_Type + No_ovules + Seed_weight [beta regression; model building also considered seed set, seeds per plant and adult biomass]"
  equation_family: beta_regression_plus_sdm_reconstruction
  model_family: species_distribution_modeling
  source_type: scientific_publication_or_package_documentation
  source_ref: "Miller et al. (2021), Diversity and Distributions, DOI 10.1111/ddi.13297. TEI/PDF methods and abstract state that fundamental niches and predicted suitable distributions were estimated using climate-calibrated ecological niche models; PO = occupied distribution area / predicted suitable area; reproductive traits (ovule number, seed set, number of seeds per plant, seed mass, adult biomass, flower type) were related to PO using beta regression and AICc. The local Dryad folder contains occurrence CSVs and Trillium_LifeHistoryTraits.csv, but not the full ClimateNA ENM raster stack; formula_used is therefore a documented executable SDM reconstruction, not a claim to reproduce the final beta-regression exactly."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_binary"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Y/X/formula_used deja resolus ; estimateurs generiques (binary) ajoutes en revue de lot du 2026-09-09."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Y/X/formula_used deja resolus ; estimateurs generiques (binary) ajoutes en revue de lot du 2026-09-09.

## Estimator eligibility

```yaml
estimator_eligibility:
  eligible_estimators:
    - estimator: ols
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Regression (famille binomiale) generique pour reponse binaire."
    - estimator: gam_spatial
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "GAM (famille binomiale), baseline generique pour reponse binaire."
    - estimator: random_forest
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Alternative ML de classification generique, Y binaire."
    - estimator: xgboost
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Alternative ML de classification generique, Y binaire."
    - estimator: sar_probit
      basis: generated_candidate
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Probit spatial (SAR) -- pertinent si dependance spatiale genuine sur Y binaire, non confirme specifiquement pour ce jeu."
    - estimator: sem_probit
      basis: generated_candidate
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Probit spatial (SEM) -- idem sar_probit."
  conditionally_eligible_estimators: []
  ineligible_reason: "n/a -- estimateurs generiques eligibles (voir eligible_estimators)."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 13557
- k variables: 15
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-96.5136988, -52.978667], y [28.9134189, 54.0719782]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending — multi-zones (span=43.5deg) -- etendue compatible avec un grand pays/une region ; verifier qu'une projection nationale/regionale existe et convient a cette zone avant de l'utiliser, sinon envisager une projection continentale equal-area

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- Reproducibility status: OK - loader R enregistre et reexecutable (`trillium_presence_background` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `trillium_presence_background` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20%: background_id (NA=56%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`trillium_presence_background` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Reproductive traits explain occupancy of predicted distributions in a genus of eastern North American understory herbs

## Curation documentée — 2026-09-07

Decision conservatoire : Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : binary. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
