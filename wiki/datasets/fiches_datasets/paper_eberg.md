---
title: paper_eberg
type: dataset
created: 2026-08-13
updated: 2026-08-13
sources:
  - data/final_datasets/sf/paper_eberg.rds
  - Moller_2020_OGC_eberg
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Oblique geographic coordinates as covariates for digital soil mapping" (DOI 10.5194/soil-6-269-2020).

## Description du jeu de donnees

- Topic: sol / cartographie pedologique numerique
- Observation unit: observation pedologique ponctuelle
- Observed population: observations de sol du jeu de donnees Ebergoetzen / plotKML
- Geographic context: Point dataset (soil observations) sur une zone de 100 km2.
- Temporal context: none (cross-sectional)
- Source description: Oblique geographic coordinates as covariates for digital soil mapping
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: high
- Paper DOI: 10.5194/soil-6-269-2020
- Dataset DOI: none
- Source URL: https://cran.r-project.org/package=plotKML
- Local raw dir: `data/raw/papers/Moller_2020_OGC_eberg/`
- Local sf output: `data/final_datasets/sf/paper_eberg.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `TAXGRSC`
- Candidate Y typology: categorical
- Candidate X variables in local artifact: `UHDICM_A`, `LHDICM_A`, `SNDMHT_A`, `SLTMHT_A`, `CLYMHT_A`, `UHDICM_B`, `LHDICM_B`, `SNDMHT_B`, `SLTMHT_B`, `CLYMHT_B`, `UHDICM_C`, `LHDICM_C`, `SNDMHT_C`, `SLTMHT_C`, `CLYMHT_C`, `UHDICM_D`, `LHDICM_D`, `SNDMHT_D`, `SLTMHT_D`, `CLYMHT_D`, `UHDICM_E`, `LHDICM_E`, `SNDMHT_E`, `SLTMHT_E`, `CLYMHT_E`
- Candidate X count in local artifact: 25
- Candidate X typology: categorical, continuous
- Published X variables from paper: UHDICM_A, LHDICM_A, SNDMHT_A, SLTMHT_A, CLYMHT_A, UHDICM_B, LHDICM_B, SNDMHT_B, SLTMHT_B, CLYMHT_B, UHDICM_C, LHDICM_C
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `ID`, `soiltype`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `TAXGRSC` | `factor` | categorical | n/a | 12.5% |

> Selection Y/X (paper-loader / curated evidence) : Pour `eberg`, la ou les reponses `TAXGRSC` viennent du loader papier et/ou des preuves de l article `Oblique geographic coordinates as covariates for digital soil mapping`. Les covariables X retenues sont `UHDICM_A`, `LHDICM_A`, `SNDMHT_A`, `SLTMHT_A`, `CLYMHT_A`, `UHDICM_B`, `LHDICM_B`, `SNDMHT_B`, `SLTMHT_B`, `CLYMHT_B`, `UHDICM_C`, `LHDICM_C` ; 13 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (`ID`, `soiltype`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : not_ready_current_package ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `UHDICM_A` | `numeric` | binary | 0% |
| `LHDICM_A` | `numeric` | continuous | 0% |
| `SNDMHT_A` | `numeric` | continuous | 0.1% |
| `SLTMHT_A` | `numeric` | continuous | 0.1% |
| `CLYMHT_A` | `numeric` | continuous | 0.1% |
| `UHDICM_B` | `numeric` | continuous | 0% |
| `LHDICM_B` | `numeric` | continuous | 0% |
| `SNDMHT_B` | `numeric` | continuous | 7.1% |
| `SLTMHT_B` | `numeric` | continuous | 7.1% |
| `CLYMHT_B` | `numeric` | continuous | 7.1% |
| `UHDICM_C` | `numeric` | continuous | 0% |
| `LHDICM_C` | `numeric` | continuous | 0% |
| `SNDMHT_C` | `numeric` | continuous | 15.6% |
| `SLTMHT_C` | `numeric` | continuous | 15.6% |
| `CLYMHT_C` | `numeric` | continuous | 15.6% |
| `UHDICM_D` | `numeric` | continuous | 0% |
| `LHDICM_D` | `numeric` | continuous | 0% |
| `SNDMHT_D` | `numeric` | continuous | 23.8% |
| `SLTMHT_D` | `numeric` | continuous | 23.8% |
| `CLYMHT_D` | `numeric` | continuous | 23.8% |
| `UHDICM_E` | `numeric` | continuous | 0% |
| `LHDICM_E` | `numeric` | continuous | 0% |
| `SNDMHT_E` | `numeric` | continuous | 28.5% |
| `SLTMHT_E` | `numeric` | continuous | 28.5% |
| `CLYMHT_E` | `numeric` | continuous | 28.5% |

### Formule - niveau publication

- formula_pub: pending
- x_terms_pub: UHDICM_A, LHDICM_A, SNDMHT_A, SLTMHT_A, CLYMHT_A, UHDICM_B, LHDICM_B, SNDMHT_B, SLTMHT_B, CLYMHT_B, UHDICM_C, LHDICM_C
- y_term_pub: TAXGRSC
- Reference publication: R package plotKML (Hengl et al., 2020); Moller et al. (2020), Sect. 2.1.2

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule - niveau systeme

- formula_used: TAXGRSC ~ UHDICM_A + LHDICM_A + SNDMHT_A + SLTMHT_A + CLYMHT_A + UHDICM_B + LHDICM_B + SNDMHT_B + SLTMHT_B + CLYMHT_B + UHDICM_C + LHDICM_C + ... (13 covariables au total, voir Candidate X variables)
- x_terms_used: UHDICM_A, LHDICM_A, SNDMHT_A, SLTMHT_A, CLYMHT_A, UHDICM_B, LHDICM_B, SNDMHT_B, SLTMHT_B, CLYMHT_B, UHDICM_C, LHDICM_C
- y_term_used: TAXGRSC
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
    formula: "TAXGRSC ~ UHDICM_A + LHDICM_A + SNDMHT_A + SLTMHT_A + CLYMHT_A + UHDICM_B + LHDICM_B + SNDMHT_B + SLTMHT_B + CLYMHT_B + UHDICM_C + LHDICM_C + ... (13 covariables au total, voir Candidate X variables)"
    response: "TAXGRSC"
    predictors: ["UHDICM_A", "LHDICM_A", "SNDMHT_A", "SLTMHT_A", "CLYMHT_A", "UHDICM_B", "LHDICM_B", "SNDMHT_B", "SLTMHT_B", "CLYMHT_B", "UHDICM_C", "LHDICM_C"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/raw/papers (loader-derived, no published equation located)"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_eberg`
- Dataset name: eberg
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Oblique geographic coordinates as covariates for digital soil mapping
- Paper DOI: 10.5194/soil-6-269-2020
- Dataset DOI: none
- Source URL: https://cran.r-project.org/package=plotKML
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
  benchmark_task: "soil_classification_or_ogc"
  package_include: "no"
  has_local_rds: true
  missing_items: "generer les covariables OGC/oblique geographic coordinates et definir une tache compatible"
  reason: "Dataset pedologique principalement categoriel; la formule systeme actuelle ne reproduit pas la methode du papier."
```

- Decision: not_ready_current_package
- Manque principal: generer les covariables OGC/oblique geographic coordinates et definir une tache compatible
- Raison: Dataset pedologique principalement categoriel; la formule systeme actuelle ne reproduit pas la methode du papier.

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
- N observations: 3670
- k variables: 30
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: unknown
- CRS nom: unknown
- Spatial extent: x [3569323, 3580992], y [5707618, 5718874]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`eberg` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `eberg` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: PENDING - formule publication non encore etablie (formule candidate systeme fournie a la place).
- CRS: WARN - CRS absent du sf source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20%: SNDMHT_D (NA=23.8%), SLTMHT_D (NA=23.8%), CLYMHT_D (NA=23.8%), SNDMHT_E (NA=28.5%), SLTMHT_E (NA=28.5%), CLYMHT_E (NA=28.5%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`eberg` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Oblique geographic coordinates as covariates for digital soil mapping

