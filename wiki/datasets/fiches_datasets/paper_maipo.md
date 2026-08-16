---
title: paper_maipo
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_maipo.rds
  - Brenning_2023_SpatialMLDiagnostics_maipo
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Spatial machine-learning model diagnostics: a model-agnostic distance-based approach" (DOI 10.1080/13658816.2022.2131789).

## Description du jeu de donnees

- Topic: Agriculture
- Observation unit: observation spatiale du dataset "Maipo"
- Observed population: yes - Depot GitHub public cite dans le papier (spdiag) contient les resultats et donnees Maipo (code_data/maipo_*
- Geographic context: Areal dataset (champs agricoles), classification multiclasse.
- Temporal context: none (cross-sectional)
- Source description: Spatial machine-learning model diagnostics: a model-agnostic distance-based approach
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: high
- Paper DOI: 10.1080/13658816.2022.2131789
- Dataset DOI: none
- Source URL: https://github.com/alexanderbrenning/spdiag/tree/main/code_data
- Local raw dir: `data/raw/papers/Brenning_2023_SpatialMLDiagnostics_maipo/`
- Local sf output: `data/final_datasets/sf/paper_maipo.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `croptype`
- Candidate Y typology: categorical
- Candidate X variables in local artifact: `ndvi01`, `ndvi02`, `ndvi03`, `ndvi04`, `ndvi05`, `ndvi06`, `ndvi07`, `ndvi08`, `ndwi01`, `ndwi02`, `ndwi03`, `ndwi04`, `ndwi05`, `ndwi06`, `ndwi07`, `ndwi08`, `b12`, `b13`, `b14`, `b15`, `b16`, `b17`, `b22`, `b23`, `b24`, `b25`, `b26`, `b27`, `b32`, `b33`, `b34`, `b35`, `b36`, `b37`, `b42`, `b43`, `b44`, `b45`, `b46`, `b47`, `b52`, `b53`, `b54`, `b55`, `b56`, `b57`, `b62`, `b63`, `b64`, `b65`, `b66`, `b67`, `b72`, `b73`, `b74`, `b75`, `b76`, `b77`, `b82`, `b83`, `b84`, `b85`, `b86`, `b87`
- Candidate X count in local artifact: 64
- Candidate X typology: continuous
- Published X variables from paper: ndvi01, ndvi02, ndvi03, ndvi04, ndvi05, ndvi06, ndvi07, ndvi08, ndwi01, ndwi02, ndwi03, ndwi04
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): `x`, `y`
- Identifier columns (excluded from X candidates): `field`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `croptype` | `factor` | categorical | n/a | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `maipo`, la ou les reponses `croptype` viennent du loader papier et/ou des preuves de l article `Spatial machine-learning model diagnostics: a model-agnostic distance-based approach`. Les covariables X retenues sont `ndvi01`, `ndvi02`, `ndvi03`, `ndvi04`, `ndvi05`, `ndvi06`, `ndvi07`, `ndvi08`, `ndwi01`, `ndwi02`, `ndwi03`, `ndwi04` ; 52 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`x`, `y`), identifiants (`field`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : not_ready_current_package ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `ndvi01` | `numeric` | rate | 0% |
| `ndvi02` | `numeric` | rate | 0% |
| `ndvi03` | `numeric` | rate | 0% |
| `ndvi04` | `numeric` | rate | 0% |
| `ndvi05` | `numeric` | rate | 0% |
| `ndvi06` | `numeric` | rate | 0% |
| `ndvi07` | `numeric` | rate | 0% |
| `ndvi08` | `numeric` | rate | 0% |
| `ndwi01` | `numeric` | continuous | 0% |
| `ndwi02` | `numeric` | continuous | 0% |
| `ndwi03` | `numeric` | continuous | 0% |
| `ndwi04` | `numeric` | rate | 0% |
| `ndwi05` | `numeric` | continuous | 0% |
| `ndwi06` | `numeric` | continuous | 0% |
| `ndwi07` | `numeric` | continuous | 0% |
| `ndwi08` | `numeric` | continuous | 0% |
| `b12` | `integer` | count | 0% |
| `b13` | `integer` | count | 0% |
| `b14` | `integer` | count | 0% |
| `b15` | `integer` | count | 0% |
| `b16` | `integer` | count | 0% |
| `b17` | `integer` | count | 0% |
| `b22` | `numeric` | continuous | 0% |
| `b23` | `integer` | count | 0% |
| `b24` | `integer` | count | 0% |
| `b25` | `integer` | count | 0% |
| `b26` | `integer` | count | 0% |
| `b27` | `integer` | count | 0% |
| `b32` | `integer` | count | 0% |
| `b33` | `integer` | count | 0% |
| `b34` | `integer` | count | 0% |
| `b35` | `integer` | count | 0% |
| `b36` | `integer` | count | 0% |
| `b37` | `integer` | count | 0% |
| `b42` | `integer` | count | 0% |
| `b43` | `integer` | count | 0% |
| `b44` | `integer` | count | 0% |
| `b45` | `integer` | count | 0% |
| `b46` | `integer` | count | 0% |
| `b47` | `integer` | count | 0% |
| `b52` | `integer` | count | 0% |
| `b53` | `integer` | count | 0% |
| `b54` | `integer` | count | 0% |
| `b55` | `integer` | count | 0% |
| `b56` | `integer` | count | 0% |
| `b57` | `integer` | count | 0% |
| `b62` | `numeric` | continuous | 0% |
| `b63` | `integer` | count | 0% |
| `b64` | `integer` | count | 0% |
| `b65` | `integer` | count | 0% |
| `b66` | `integer` | count | 0% |
| `b67` | `integer` | count | 0% |
| `b72` | `numeric` | continuous | 0% |
| `b73` | `integer` | count | 0% |
| `b74` | `integer` | count | 0% |
| `b75` | `integer` | count | 0% |
| `b76` | `integer` | count | 0% |
| `b77` | `integer` | count | 0% |
| `b82` | `numeric` | continuous | 0% |
| `b83` | `numeric` | continuous | 0% |
| `b84` | `integer` | count | 0% |
| `b85` | `integer` | count | 0% |
| `b86` | `integer` | count | 0% |
| `b87` | `integer` | count | 0% |

### Formule - niveau publication

- formula_pub: pending
- x_terms_pub: ndvi01, ndvi02, ndvi03, ndvi04, ndvi05, ndvi06, ndvi07, ndvi08, ndwi01, ndwi02, ndwi03, ndwi04
- y_term_pub: croptype
- Reference publication: Pena and Brenning (2015); Brenning (2023), Case study description: the Maipo dataset

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule - niveau systeme

- formula_used: croptype ~ ndvi01 + ndvi02 + ndvi03 + ndvi04 + ndvi05 + ndvi06 + ndvi07 + ndvi08 + ndwi01 + ndwi02 + ndwi03 + ndwi04 + ... (52 covariables au total, voir Candidate X variables)
- x_terms_used: ndvi01, ndvi02, ndvi03, ndvi04, ndvi05, ndvi06, ndvi07, ndvi08, ndwi01, ndwi02, ndwi03, ndwi04
- y_term_used: croptype
- Note: formule candidate generee automatiquement (Y ~ toutes les covariables X detectees), PAS une formule publiee ou verifiee dans le papier source - a confirmer par revue manuelle.

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
    formula: "pending"
    response: "pending"
    predictors: []
    role: "paper_main_specification"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

  ml_or_selected:
    formula: "croptype ~ ndvi01 + ndvi02 + ndvi03 + ndvi04 + ndvi05 + ndvi06 + ndvi07 + ndvi08 + ndwi01 + ndwi02 + ndwi03 + ndwi04 + ... (52 covariables au total, voir Candidate X variables)"
    response: "croptype"
    predictors: ["ndvi01", "ndvi02", "ndvi03", "ndvi04", "ndvi05", "ndvi06", "ndvi07", "ndvi08", "ndwi01", "ndwi02", "ndwi03", "ndwi04"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/raw/papers (loader-derived, no published equation located)"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_maipo`
- Dataset name: Maipo
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Spatial machine-learning model diagnostics: a model-agnostic distance-based approach
- Paper DOI: 10.1080/13658816.2022.2131789
- Dataset DOI: none
- Source URL: https://github.com/alexanderbrenning/spdiag/tree/main/code_data
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "pending"
  equation_family: generated_system_candidate
  model_family: unknown
  source_type: generated_system_formula
  source_ref: "data/raw/papers (loader-derived, no published equation located)"
  confidence: low
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_current_package"
  benchmark_task: "classification_multiclass"
  package_include: "no"
  has_local_rds: true
  missing_items: "support classification et metriques adaptees"
  reason: "La reponse crop type est categorielle multiclasse."
```

- Decision: not_ready_current_package
- Manque principal: support classification et metriques adaptees
- Raison: La reponse crop type est categorielle multiclasse.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "not_ready_current_package"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "current package supports continuous spatial regression benchmarks; this fiche is not currently an executable continuous-regression dataset"
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 7713
- k variables: 70
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: unknown
- CRS nom: unknown
- Spatial extent: x [305175, 364605], y [6246865, 6287155]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`maipo` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `maipo` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: PENDING - formule publication non encore etablie (formule candidate systeme fournie a la place).
- CRS: WARN - CRS absent du sf source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`maipo` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Spatial machine-learning model diagnostics: a model-agnostic distance-based approach

