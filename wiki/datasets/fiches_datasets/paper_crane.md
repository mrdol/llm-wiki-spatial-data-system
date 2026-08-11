---
title: paper_crane
type: dataset
created: 2026-08-11
updated: 2026-08-11
sources:
  - data/final_datasets/sf/paper_crane.rds
  - DataCite_2022_BalancingStructuralComplexityWith_10_1111_2041_210
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Balancing structural complexity with ecological insight in Spatio-temporal species distribution models" (DOI 10.1111/2041-210x.13957).

## Description du jeu de donnees

- Topic: distribution d'espece / demographie de population
- Observation unit: observation ponctuelle de presence
- Observed population: population reintroduite de grues (Grus grus)
- Geographic context: etendue sf: x [233643.173683893, 862162.495815702], y [22773.8203577613, 626978.465950806]
- Temporal context: none (cross-sectional)
- Source description: Balancing structural complexity with ecological insight in Spatio-temporal species distribution models
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/2041-210x.13957
- Dataset DOI: 10.5061/dryad.2z34tmpps
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.2z34tmpps
- Local raw dir: `data/raw/papers/DataCite_2022_BalancingStructuralComplexityWith_10_1111_2041_210/`
- Local sf output: `data/final_datasets/sf/paper_crane.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `mark`
- Candidate Y typology: binary
- Candidate X variables in local artifact: `ti`, `Urb_Den_cov`, `PA_Ratio_cov`, `Area_cov`
- Candidate X count in local artifact: 4
- Candidate X typology: continuous
- Published X variables from paper: ti, Urb_Den_cov, PA_Ratio_cov, Area_cov
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): `x`, `y`, `x_m`, `y_m`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `mark` | `integer` | binary | {0, 1} | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `crane`, la ou les reponses `mark` viennent du loader papier et/ou des preuves de l article `Balancing structural complexity with ecological insight in Spatio-temporal species distribution models`. Les covariables X retenues sont `ti`, `Urb_Den_cov`, `PA_Ratio_cov`, `Area_cov`. Les coordonnees (`x`, `y`, `x_m`, `y_m`), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : not_ready_current_package ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `ti` | `integer` | count | 0% |
| `Urb_Den_cov` | `numeric` | continuous | 0% |
| `PA_Ratio_cov` | `numeric` | continuous | 0% |
| `Area_cov` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: pending
- x_terms_pub: ti, Urb_Den_cov, PA_Ratio_cov, Area_cov
- y_term_pub: mark
- Reference publication: DataCite dataset DOI 10.5061/dryad.2z34tmpps; Publication DOI 10.1111/2041-210x.13957

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule - niveau systeme

- formula_used: mark ~ ti + Urb_Den_cov + PA_Ratio_cov + Area_cov
- x_terms_used: ti, Urb_Den_cov, PA_Ratio_cov, Area_cov
- y_term_used: mark
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
    formula: "mark ~ ti + Urb_Den_cov + PA_Ratio_cov + Area_cov"
    response: "mark"
    predictors: ["ti", "Urb_Den_cov", "PA_Ratio_cov", "Area_cov"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/raw/papers (loader-derived, no published equation located)"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_crane`
- Dataset name: Transformed crane data from: Balancing structural complexity with ecological insight in spatio-temporal species distribution models
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Balancing structural complexity with ecological insight in Spatio-temporal species distribution models
- Paper DOI: 10.1111/2041-210x.13957
- Dataset DOI: 10.5061/dryad.2z34tmpps
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.2z34tmpps
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
  benchmark_task: "binary_panel_or_presence_absence"
  package_include: "no"
  has_local_rds: true
  missing_items: "support binaire/panel et schema CV adapte"
  reason: "Reponse binaire et structure temporelle."
```

- Decision: not_ready_current_package
- Manque principal: support binaire/panel et schema CV adapte
- Raison: Reponse binaire et structure temporelle.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "not_ready_current_package"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "current package supports continuous spatial regression benchmarks; this fiche is not currently an executable continuous-regression dataset"
  rule: "paper fiches are eligible only when response, predictors, coordinates/geometry and required W are executable in the local artifact"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 12630
- k variables: 12
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: unknown
- CRS nom: unknown
- Spatial extent: x [233643.173683893, 862162.495815702], y [22773.8203577613, 626978.465950806]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`crane` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `crane` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: PENDING - formule publication non encore etablie (formule candidate systeme fournie a la place).
- CRS: WARN - CRS absent du sf source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`crane` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Balancing structural complexity with ecological insight in Spatio-temporal species distribution models

