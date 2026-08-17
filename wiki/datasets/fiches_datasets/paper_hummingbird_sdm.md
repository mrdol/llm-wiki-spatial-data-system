---
title: paper_hummingbird_sdm
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_hummingbird_sdm.rds
  - DataCite_2023_IntegratedSpeciesDistributionModels_10_1111_geb_1379
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Integrated species distribution models to account for sampling biases and improve range-wide occurrence predictions" (DOI 10.1111/geb.13792).

## Description du jeu de donnees

- Topic: ecologie / interactions plantes-pollinisateurs
- Observation unit: site d'observation ou cellule de grille d'occurrence
- Observed population: communautes de pollinisateurs ou d'oiseaux nectarivores
- Geographic context: etendue sf: x [-89.5, -35.5], y [-39.5, 14.5]
- Temporal context: none (cross-sectional)
- Source description: Integrated species distribution models to account for sampling biases and improve range-wide occurrence predictions
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/geb.13792
- Dataset DOI: 10.5061/dryad.k98sf7mdg
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.k98sf7mdg
- Local raw dir: `data/raw/papers/DataCite_2023_IntegratedSpeciesDistributionModels_10_1111_geb_1379/`
- Local sf output: `data/final_datasets/sf/paper_hummingbird_sdm.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `log1p_species_richness`, `species_richness`, `n_occurrences`
- Candidate Y typology: continuous, count
- Candidate X variables in local artifact: `annual_mean_temperature`, `mean_diurnal_range`, `annual_precipitation`, `precipitation_seasonality`, `evi_annual`
- Candidate X count in local artifact: 5
- Candidate X typology: continuous
- Published X variables from paper: annual mean temperature, mean diurnal range, annual precipitation, precipitation seasonality, intra-annual cloud cover variation, EVI, TRI
- Published X count: 7
- Coordinates (x, y - excluded from X candidates): `cell_lon`, `cell_lat`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `log1p_species_richness` | `numeric` | continuous | [0.6931, 3.9318] | 0% |
| `species_richness` | `integer` | count | [1, 50] | 0% |
| `n_occurrences` | `integer` | count | [1, 739] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `hummingbird_sdm`, la ou les reponses `log1p_species_richness`, `species_richness`, `n_occurrences` viennent du loader papier et/ou des preuves de l article `Integrated species distribution models to account for sampling biases and improve range-wide occurrence predictions`. Les covariables X retenues sont `annual_mean_temperature`, `mean_diurnal_range`, `annual_precipitation`, `precipitation_seasonality`, `evi_annual`. Les coordonnees (`cell_lon`, `cell_lat`), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `annual_mean_temperature` | `numeric` | continuous | 0% |
| `mean_diurnal_range` | `numeric` | continuous | 0% |
| `annual_precipitation` | `numeric` | continuous | 0% |
| `precipitation_seasonality` | `numeric` | continuous | 0% |
| `evi_annual` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: log(lambda_PO) = alpha_PO + beta*x + g(s) ; logit(lambda_PA) = alpha_PA + beta*x + g(s) [modele integre PO+PA, effet spatial latent partage g(s)]
- x_terms_pub: annual mean temperature, mean diurnal range, annual precipitation, precipitation seasonality, intra-annual cloud cover variation, EVI, TRI
- y_term_pub: presence-only intensity, presence-absence occurrence probability, and stacked species richness predictions for 71 hummingbird species
- Reference publication: Makinen, Merow & Jetz (2023), Global Ecology and Biogeography, Section 2.1 and Table 1: SDM integre combinant donnees presence-seule (GBIF) et presence-absence (checklists Andes du Nord) pour 71 especes de colibris, via un processus de Poisson log-lineaire (PO) et un modele Bernoulli (PA) partageant un effet spatial latent g(s). Le README Dryad local fournit CHELSA et EVI ; cloud cover et TRI sont cites par le papier/README mais doivent etre recuperes depuis leurs sources originales avant reproduction complete. formula_used utilise log1p_species_richness, une reponse derivee continue construite depuis le comptage local par cellule ; c est une reconstruction executable partielle au niveau cellule, pas la formule complete des SDM du papier.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: log1p_species_richness ~ annual_mean_temperature + mean_diurnal_range + annual_precipitation + precipitation_seasonality + evi_annual
- x_terms_used: annual_mean_temperature, mean_diurnal_range, annual_precipitation, precipitation_seasonality, evi_annual
- y_term_used: log1p_species_richness
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
    formula: "log1p_species_richness ~ annual_mean_temperature + mean_diurnal_range + annual_precipitation + precipitation_seasonality + evi_annual"
    response: "presence-only intensity, presence-absence occurrence probability, and stacked species richness predictions for 71 hummingbird species"
    predictors: ["annual mean temperature", "mean diurnal range", "annual precipitation", "precipitation seasonality", "intra-annual cloud cover variation", "EVI", "TRI"]
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

- Dataset ID: `paper_hummingbird_sdm`
- Dataset name: Data from: Integrated species distribution models to account for sampling biases and improve range wide occurrence predictions
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Integrated species distribution models to account for sampling biases and improve range-wide occurrence predictions
- Paper DOI: 10.1111/geb.13792
- Dataset DOI: 10.5061/dryad.k98sf7mdg
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.k98sf7mdg
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "log(lambda_PO) = alpha_PO + beta*x + g(s) ; logit(lambda_PA) = alpha_PA + beta*x + g(s) [modele integre PO+PA, effet spatial latent partage g(s)]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Makinen, Merow & Jetz (2023), Global Ecology and Biogeography, Section 2.1 and Table 1: SDM integre combinant donnees presence-seule (GBIF) et presence-absence (checklists Andes du Nord) pour 71 especes de colibris, via un processus de Poisson log-lineaire (PO) et un modele Bernoulli (PA) partageant un effet spatial latent g(s). Le README Dryad local fournit CHELSA et EVI ; cloud cover et TRI sont cites par le papier/README mais doivent etre recuperes depuis leurs sources originales avant reproduction complete. formula_used utilise log1p_species_richness, une reponse derivee continue construite depuis le comptage local par cellule ; c est une reconstruction executable partielle au niveau cellule, pas la formule complete des SDM du papier."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "derived_continuous_species_richness_regression"
  package_include: "yes"
  has_local_rds: true
  missing_items: "reponse log1p_species_richness derivee (agregation continue de comptages d'occurrence reels, pas une sortie de modele) ; ne reproduit pas les SDM PO/PA integres complets du papier et n'inclut pas cloud cover/TRI"
  reason: "Y derive mais defendable (transformation d'un comptage empirique reel), covariables CHELSA/EVI locales et coordonnees disponibles, artefact local utilisable -- promu sans revue manuelle (2026-08-12), statut normalise depuis almost_ready_derived_regression."
```

- Decision: ready
- Manque principal: reponse log1p_species_richness derivee (agregation continue de comptages d'occurrence reels, pas une sortie de modele) ; ne reproduit pas les SDM PO/PA integres complets du papier et n'inclut pas cloud cover/TRI
- Raison: Y derive mais defendable (transformation d'un comptage empirique reel), covariables CHELSA/EVI locales et coordonnees disponibles, artefact local utilisable -- promu sans revue manuelle (2026-08-12), statut normalise depuis almost_ready_derived_regression.

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
- N observations: 227
- k variables: 12
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-89.5, -35.5], y [-39.5, 14.5]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=54deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`hummingbird_sdm` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `hummingbird_sdm` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`hummingbird_sdm` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Integrated species distribution models to account for sampling biases and improve range-wide occurrence predictions

