---
title: paper_biomass_rainforest
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_biomass_rainforest.rds
  - DataCite_2015_SpatialStructureOfAbove_10_1371_journal_
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Spatial Structure of Above-Ground Biomass Limits Accuracy of Carbon Mapping in Rainforest but Large Scale Forest Inventories Can Help to Overcome" (DOI 10.1371/journal.pone.0138456).

## Description du jeu de donnees

- Topic: ecologie forestiere / inventaire de biomasse
- Observation unit: placette d'inventaire forestier
- Observed population: placettes CTFT/ONF, foret tropicale humide
- Geographic context: etendue sf: x [144387.6771, 384675.3438], y [270868.7361, 607409.7224]
- Temporal context: none (cross-sectional)
- Source description: Spatial Structure of Above-Ground Biomass Limits Accuracy of Carbon Mapping in Rainforest but Large Scale Forest Inventories Can Help to Overcome
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1371/journal.pone.0138456
- Dataset DOI: 10.5061/dryad.38578
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.38578
- Local raw dir: `data/raw/papers/DataCite_2015_SpatialStructureOfAbove_10_1371_journal_/`
- Local sf output: `data/final_datasets/sf/paper_biomass_rainforest.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `AGB_mean`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `area_ha`, `n_stems`, `mean_wsg`, `ALT`, `SLO`, `HAND`, `LOG`
- Candidate X count in local artifact: 7
- Candidate X typology: continuous
- Published X variables from paper: LANDScapes, HAND, LOG, GEOL, VEGET, ALT, SLO, spatial_kriging_residual
- Published X count: 8
- Coordinates (x, y - excluded from X candidates): `Xutm`, `Yutm`
- Identifier columns (excluded from X candidates): `ID`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `AGB_mean` | `numeric` | continuous | [34.1731, 759.7623] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `biomass_rainforest`, la reponse publiee n'est pas `mean_wsg` ni `n_stems`, mais `AGB_plot` / above-ground biomass per hectare. Le papier calcule d'abord AGB a partir des classes DBH, de la hauteur simulee, du WSG et de l'aire de placette, puis ajuste un GLM selectionne par AIC avec composante spatiale de krigeage des residus. Dans l'artefact local actuel, `AGB_mean` est reconstruit depuis le supplement PLOS S1_Dataset_AGB.xlsx et sert de reponse locale executable. `area_ha`, `n_stems`, `mean_wsg`, `HAND`, `LOG`, `ALT` et `SLO` sont les covariables locales disponibles. Elles ne remplacent pas la specification complete du papier, car `LANDScapes`, `GEOL`, `VEGET` et la composante de krigeage des residus restent documentees mais non jointes au .rds. Les coordonnees (`Xutm`, `Yutm`), identifiants (`ID`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : local_reduced_formula ; la promotion package doit signaler que formula_used est une specification locale reduite, distincte de la formule publication complete.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `area_ha` | `numeric` | rate | 0% |
| `n_stems` | `numeric` | continuous | 0% |
| `mean_wsg` | `numeric` | rate | 0% |
| `ALT` | `numeric` | continuous | 0% |
| `SLO` | `numeric` | continuous | 0% |
| `HAND` | `numeric` | continuous | 0% |
| `LOG` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: AGB_plot(s) = mu + sum_e gamma_e * x_e(s) + k(s) [kriging-regression model, Eq. 4]
- x_terms_pub: LANDScapes, HAND, LOG, GEOL, VEGET, ALT, SLO, spatial_kriging_residual
- y_term_pub: AGB_plot / above-ground biomass per hectare
- Reference publication: Guitet et al. (2015), PLOS ONE, DOI 10.1371/journal.pone.0138456; Dryad 10.5061/dryad.38578. The paper computes plot-level AGB from DBH class, simulated height, wood specific gravity and plot area (Eq. 1-2), then models AGB with GLM selected by AIC and adds a kriged residual spatial component k(s) (Eq. 4-5). Selected effects reported in Results are LANDScapes, HAND, LOG, GEOL, VEGET, ALT and SLO; LANDForms, DRY and RAIN were excluded. The current local artifact now reconstructs AGB_mean from the PLOS S1_Dataset_AGB.xlsx supplement and exposes plot area, stem counts, mean WSG and the reconstructed numeric environmental covariates HAND, LOG, ALT and SLO. LANDScapes, GEOL and VEGET remain documented from the paper sources but are not joined locally, so formula_used is still a reduced local executable benchmark formula rather than the full published GLM/KR specification.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: AGB_mean ~ area_ha + n_stems + mean_wsg + HAND + LOG + ALT + SLO
- x_terms_used: area_ha, n_stems, mean_wsg, HAND, LOG, ALT, SLO
- y_term_used: AGB_mean
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
    formula: "AGB_plot ~ LANDScapes + HAND + LOG + GEOL + VEGET + ALT + SLO + spatial_kriging_residual"
    response: "AGB_plot / above-ground biomass per hectare"
    predictors: ["LANDScapes", "HAND", "LOG", "GEOL", "VEGET", "ALT", "SLO", "spatial_kriging_residual"]
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

- Dataset ID: `paper_biomass_rainforest`
- Dataset name: Data from: Spatial structure of above-ground biomass limits accuracy of carbon mapping in rainforest but large scale forest inventories can help to overcome
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Spatial Structure of Above-Ground Biomass Limits Accuracy of Carbon Mapping in Rainforest but Large Scale Forest Inventories Can Help to Overcome
- Paper DOI: 10.1371/journal.pone.0138456
- Dataset DOI: 10.5061/dryad.38578
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.38578
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "AGB_plot(s) = mu + sum_e gamma_e * x_e(s) + k(s) [kriging-regression model, Eq. 4]"
  equation_family: kriging_regression_glm_plus_spatial_residual
  model_family: above-ground biomass/carbon mapping with GLM and ordinary kriging
  source_type: scientific_publication_or_package_documentation
  source_ref: "Guitet et al. (2015), PLOS ONE, DOI 10.1371/journal.pone.0138456; Dryad 10.5061/dryad.38578. The paper computes plot-level AGB from DBH class, simulated height, wood specific gravity and plot area (Eq. 1-2), then models AGB with GLM selected by AIC and adds a kriged residual spatial component k(s) (Eq. 4-5). Selected effects reported in Results are LANDScapes, HAND, LOG, GEOL, VEGET, ALT and SLO; LANDForms, DRY and RAIN were excluded. The current local artifact now reconstructs AGB_mean from the PLOS S1_Dataset_AGB.xlsx supplement and exposes plot area, stem counts, mean WSG and the reconstructed numeric environmental covariates HAND, LOG, ALT and SLO. LANDScapes, GEOL and VEGET remain documented from the paper sources but are not joined locally, so formula_used is still a reduced local executable benchmark formula rather than the full published GLM/KR specification."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "formula_used est une version locale reduite : LANDScapes, GEOL, VEGET et la composante de krigeage des residus restent documentees mais absentes du .rds"
  reason: "AGB_mean est reconstruit depuis le supplement PLOS; area_ha, n_stems, mean_wsg, HAND, LOG, ALT et SLO sont disponibles localement. Par decision de curation, cette version reduite est conservable dans le package avec la difference explicite entre formule publiee complete et formule executable locale."
```

- Decision: ready
- Manque principal: formula_used est une version locale reduite : LANDScapes, GEOL, VEGET et la composante de krigeage des residus restent documentees mais absentes du .rds
- Raison: AGB_mean est reconstruit depuis le supplement PLOS; area_ha, n_stems, mean_wsg, HAND, LOG, ALT et SLO sont disponibles localement. Par decision de curation, cette version reduite est conservable dans le package avec la difference explicite entre formule publiee complete et formule executable locale.

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
- N observations: 1335
- k variables: 13
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 32622
- CRS nom: WGS 84 / UTM zone 22N
- Spatial extent: x [144387.6771, 384675.3438], y [270868.7361, 607409.7224]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.38578 (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`biomass_rainforest` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `biomass_rainforest` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (32622).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`biomass_rainforest` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Spatial Structure of Above-Ground Biomass Limits Accuracy of Carbon Mapping in Rainforest but Large Scale Forest Inventories Can Help to Overcome

