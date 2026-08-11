---
title: paper_cluster_detection
type: dataset
created: 2026-08-10
updated: 2026-08-10
sources:
  - data/final_datasets/sf/paper_cluster_detection.rds
  - DataCite_2016_ClusterDetectionOfSpatial_10_1002_sim_7172
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Cluster detection of spatial regression coefficients" (DOI 10.1002/sim.7172).

## Description du jeu de donnees

- Topic: methodologie statistique / detection de cluster spatial
- Observation unit: cellule de grille spatiale simulee
- Observed population: donnees simulees (illustration methodologique)
- Geographic context: a preciser depuis l'etendue spatiale (voir Bloc 5)
- Temporal context: none (cross-sectional)
- Source description: Cluster detection of spatial regression coefficients
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1002/sim.7172
- Dataset DOI: 10.6084/m9.figshare.4126881
- Source URL: https://wiley.figshare.com/articles/dataset/Dataset_for_Cluster_Detection_of_Spatial_Regression_Coefficients/4126881
- Local raw dir: `data/raw/papers/DataCite_2016_ClusterDetectionOfSpatial_10_1002_sim_7172/`
- Local sf output: `data/final_datasets/sf/paper_cluster_detection.rds`

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `y_response_simulated`
- Candidate Y typology: continuous
- Candidate X variables: `x_covariate_simulated`
- Candidate X count: 1
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `long`, `lat`
- Identifier columns (excluded from X candidates): `State`, `County`, `FIPS`
- Variables inspected: yes (auto — generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `y_response_simulated` | `numeric` | continuous | [-11.2008, 14.8403] | 0% |

> Selection Y/X (paper-loader/curated evidence) : Pour `cluster_detection`, la ou les reponses `y_response_simulated` viennent du loader papier et/ou des preuves de l article `Cluster detection of spatial regression coefficients`. Les covariables X retenues sont `x_covariate_simulated`. Les coordonnees (`long`, `lat`), identifiants (`State`, `County`, `FIPS`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : almost_ready_simulation ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `x_covariate_simulated` | `numeric` | continuous | 0% |

### Formule — niveau publication

- formula_pub: mu_i = beta0 + beta1*x_i (hors cluster) ; mu_i = (beta0+theta_j0) + (beta1+theta_j1)*x_i (dans le cluster C_j)
- x_terms_pub: x_covariate_simulated
- y_term_pub: y_response_simulated
- Reference publication: Lee, Gangnon & Zhu (2016), Statistics in Medicine, eq. (1)-(2) — modele a coefficients de regression variables par cluster spatial (varying-coefficient regression), methode de detection de cluster testee sur donnees simulees puis sur mortalite par cancer.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-10). Lee, Gangnon & Zhu (2016), Statistics in Medicine, eq. (1)-(2) — modele a coefficients de regression variables par cluster spatial (varying-coefficient regression), methode de detection de cluster testee sur donnees simulees puis sur mortalite par cancer.

### Formule — niveau systeme

- formula_used: y_response_simulated ~ x_covariate_simulated
- x_terms_used: x_covariate_simulated
- y_term_used: y_response_simulated
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-10). Lee, Gangnon & Zhu (2016), Statistics in Medicine, eq. (1)-(2) — modele a coefficients de regression variables par cluster spatial (varying-coefficient regression), methode de detection de cluster testee sur donnees simulees puis sur mortalite par cancer.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "y_response_simulated ~ x_covariate_simulated"
    response: "y_response_simulated"
    predictors: ["x_covariate_simulated"]
    role: "simple_baseline"
    source_type: "scientific_publication"
    source_ref: "Lee, Gangnon & Zhu (2016), Statistics in Medicine, eq. (1)-(2) — modele a coefficients de regression variables par cluster spatial (varying-coefficient regression), methode de detection de cluster testee sur donnees simulees puis sur mortalite par cancer."
    estimator_context: ["ols", "spatial_baseline"]
    status: "confirmed"

  multivariate_constrained:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "paper_main_specification"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

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

## Bloc 2 — Identification et DOI

- Dataset ID: `paper_cluster_detection`
- Dataset name: Dataset for: Cluster Detection of Spatial Regression Coefficients
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Cluster detection of spatial regression coefficients
- Paper DOI: 10.1002/sim.7172
- Dataset DOI: 10.6084/m9.figshare.4126881
- Source URL: https://wiley.figshare.com/articles/dataset/Dataset_for_Cluster_Detection_of_Spatial_Regression_Coefficients/4126881
- Year: unknown

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "mu_i = beta0 + beta1*x_i (hors cluster) ; mu_i = (beta0+theta_j0) + (beta1+theta_j1)*x_i (dans le cluster C_j)"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Lee, Gangnon & Zhu (2016), Statistics in Medicine, eq. (1)-(2) — modele a coefficients de regression variables par cluster spatial (varying-coefficient regression), methode de detection de cluster testee sur donnees simulees puis sur mortalite par cancer."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "almost_ready_simulation"
  benchmark_task: "regression_continuous_simulated"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "confirmer que le benchmark accepte un dataset simule et non un cas empirique geographique"
  reason: "Y/X et coordonnees disponibles, mais l'exemple principal est une simulation de coefficients spatiaux."
```

- Decision: almost_ready_simulation
- Manque principal: confirmer que le benchmark accepte un dataset simule et non un cas empirique geographique
- Raison: Y/X et coordonnees disponibles, mais l'exemple principal est une simulation de coefficients spatiaux.

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 616
- k variables: 9
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 — Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-91.351781, -75.767536], y [25.601043, 36.559364]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32617 (UTM Zone 17N (EPSG:32617)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`cluster_detection` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `cluster_detection` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee (verifiee par lecture directe du papier).
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`cluster_detection` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Cluster detection of spatial regression coefficients

