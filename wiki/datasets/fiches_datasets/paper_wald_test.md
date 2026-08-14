---
title: paper_wald_test
type: dataset
created: 2026-08-13
updated: 2026-08-13
sources:
  - data/final_datasets/sf/paper_wald_test.rds
  - DataCite_2020_TheWaldTestOf_10_1017_pan_2020
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "The Wald Test of Common Factors in Spatial Model Specification Search Strategies" (DOI 10.1017/pan.2020.23).

## Description du jeu de donnees

- Topic: econometrie spatiale / methodologie de test
- Observation unit: observation parti x election
- Observed population: partis politiques, democraties occidentales
- Geographic context: etendue sf: x [-110.243807777161, 176.516596816029], y [-38.30531015, 79.958143]
- Temporal context: 306 distinct periods (variable: ts)
- Source description: The Wald Test of Common Factors in Spatial Model Specification Search Strategies
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1017/pan.2020.23
- Dataset DOI: 10.7910/dvn/cy7ywe
- Source URL: https://dataverse.harvard.edu/citation?persistentId=doi:10.7910/DVN/CY7YWE
- Local raw dir: `data/raw/papers/DataCite_2020_TheWaldTestOf_10_1017_pan_2020/`
- Local sf output: `data/final_datasets/sf/paper_wald_test.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `change`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `countryname`, `clear1`, `lag_pervote`, `party_shift_t`, `party_shift_t1`, `niche`, `ciep_perc`, `rgdppc_growth`, `gparties`, `majority`, `prime_dummy`, `xregbet`, `govt_lag_pervote`, `govt_gparties`, `niche_lag_pervote`, `eff_par`, `govt_ciep`, `pm_ciep`, `growth_govt`, `pm_growth`, `pm_lag_pervote`, `pm_majority`, `pm_gparties`
- Candidate X count in local artifact: 23
- Candidate X typology: categorical, continuous
- Published X variables from paper: rgdppc_growth, growth_govt, pm_growth, party_shift_t, party_shift_t1, ciep_perc, govt_ciep, pm_ciep, xregbet, prime_dummy, niche, gparties, pm_gparties, lag_pervote, pm_lag_pervote, niche_lag_pervote, eff_par
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `ccode`, `iso_a2`, `party`, `ts`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `change` | `numeric` | continuous | [-28.24, 22.73] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `wald_test`, la ou les reponses `change` viennent du loader papier et/ou des preuves de l article `The Wald Test of Common Factors in Spatial Model Specification Search Strategies`. Les covariables X retenues sont `rgdppc_growth`, `growth_govt`, `pm_growth`, `party_shift_t`, `party_shift_t1`, `ciep_perc`, `govt_ciep`, `pm_ciep`, `xregbet`, `prime_dummy`, `niche`, `gparties`, `pm_gparties`, `lag_pervote`, `pm_lag_pervote`, `niche_lag_pervote`, `eff_par` ; 6 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (`ccode`, `iso_a2`, `party`, `ts`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : needs_original_W ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `countryname` | `character` | categorical | 0% |
| `clear1` | `numeric` | binary | 0% |
| `lag_pervote` | `numeric` | continuous | 0% |
| `party_shift_t` | `numeric` | continuous | 0% |
| `party_shift_t1` | `numeric` | continuous | 0% |
| `niche` | `numeric` | binary | 0% |
| `ciep_perc` | `numeric` | continuous | 0% |
| `rgdppc_growth` | `numeric` | continuous | 0% |
| `gparties` | `integer` | count | 0% |
| `majority` | `numeric` | binary | 0% |
| `prime_dummy` | `numeric` | binary | 0% |
| `xregbet` | `integer` | binary | 0% |
| `govt_lag_pervote` | `numeric` | continuous | 0% |
| `govt_gparties` | `numeric` | continuous | 0% |
| `niche_lag_pervote` | `numeric` | continuous | 0% |
| `eff_par` | `numeric` | continuous | 0% |
| `govt_ciep` | `numeric` | continuous | 0% |
| `pm_ciep` | `numeric` | continuous | 0% |
| `growth_govt` | `numeric` | continuous | 0% |
| `pm_growth` | `numeric` | continuous | 0% |
| `pm_lag_pervote` | `numeric` | continuous | 0% |
| `pm_majority` | `numeric` | binary | 0% |
| `pm_gparties` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: change ~ rgdppc_growth + growth_govt + pm_growth + party_shift_t + party_shift_t1 + ciep_perc + govt_ciep + pm_ciep + xregbet + prime_dummy + niche + gparties + pm_gparties + lag_pervote + pm_lag_pervote + niche_lag_pervote + eff_par
- x_terms_pub: rgdppc_growth, growth_govt, pm_growth, party_shift_t, party_shift_t1, ciep_perc, govt_ciep, pm_ciep, xregbet, prime_dummy, niche, gparties, pm_gparties, lag_pervote, pm_lag_pervote, niche_lag_pervote, eff_par
- y_term_pub: change
- Reference publication: Juhl (2021), Political Analysis - Spatial Durbin Model (SDM), sous-echantillon 'haute clarte de responsabilite' (clear1=1), extrait directement de EmpiricalExample.R (script de replication des auteurs, data/raw/papers/DataCite_2020_TheWaldTestOf_10_1017_pan_2020/EmpiricalExample.R).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-13). Juhl (2021), Political Analysis - Spatial Durbin Model (SDM), sous-echantillon 'haute clarte de responsabilite' (clear1=1), extrait directement de EmpiricalExample.R (script de replication des auteurs, data/raw/papers/DataCite_2020_TheWaldTestOf_10_1017_pan_2020/EmpiricalExample.R).

### Formule - niveau systeme

- formula_used: change ~ rgdppc_growth + growth_govt + pm_growth + party_shift_t + party_shift_t1 + ciep_perc + govt_ciep + pm_ciep + xregbet + prime_dummy + niche + gparties + pm_gparties + lag_pervote + pm_lag_pervote + niche_lag_pervote + eff_par
- x_terms_used: rgdppc_growth, growth_govt, pm_growth, party_shift_t, party_shift_t1, ciep_perc, govt_ciep, pm_ciep, xregbet, prime_dummy, niche, gparties, pm_gparties, lag_pervote, pm_lag_pervote, niche_lag_pervote, eff_par
- y_term_used: change
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-13). Juhl (2021), Political Analysis - Spatial Durbin Model (SDM), sous-echantillon 'haute clarte de responsabilite' (clear1=1), extrait directement de EmpiricalExample.R (script de replication des auteurs, data/raw/papers/DataCite_2020_TheWaldTestOf_10_1017_pan_2020/EmpiricalExample.R).

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
    formula: "change ~ rgdppc_growth + growth_govt + pm_growth + party_shift_t + party_shift_t1 + ciep_perc + govt_ciep + pm_ciep + xregbet + prime_dummy + niche + gparties + pm_gparties + lag_pervote + pm_lag_pervote + niche_lag_pervote + eff_par"
    response: "change"
    predictors: ["rgdppc_growth", "growth_govt", "pm_growth", "party_shift_t", "party_shift_t1", "ciep_perc", "govt_ciep", "pm_ciep", "xregbet", "prime_dummy", "niche", "gparties", "pm_gparties", "lag_pervote", "pm_lag_pervote", "niche_lag_pervote", "eff_par"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Juhl (2021), Political Analysis - Spatial Durbin Model (SDM), sous-echantillon 'haute clarte de responsabilite' (clear1=1), extrait directement de EmpiricalExample.R (script de replication des auteurs, data/raw/papers/DataCite_2020_TheWaldTestOf_10_1017_pan_2020/EmpiricalExample.R)."
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

- Dataset ID: `paper_wald_test`
- Dataset name: Replication Data for: The Wald Test of Common Factors in Spatial Model Specification Search Strategies
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: The Wald Test of Common Factors in Spatial Model Specification Search Strategies
- Paper DOI: 10.1017/pan.2020.23
- Dataset DOI: 10.7910/dvn/cy7ywe
- Source URL: https://dataverse.harvard.edu/citation?persistentId=doi:10.7910/DVN/CY7YWE
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "change ~ rgdppc_growth + growth_govt + pm_growth + party_shift_t + party_shift_t1 + ciep_perc + govt_ciep + pm_ciep + xregbet + prime_dummy + niche + gparties + pm_gparties + lag_pervote + pm_lag_pervote + niche_lag_pervote + eff_par"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Juhl (2021), Political Analysis - Spatial Durbin Model (SDM), sous-echantillon 'haute clarte de responsabilite' (clear1=1), extrait directement de EmpiricalExample.R (script de replication des auteurs, data/raw/papers/DataCite_2020_TheWaldTestOf_10_1017_pan_2020/EmpiricalExample.R)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "needs_original_W"
  benchmark_task: "regression_spatial_weights_non_geographic"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "conserver ou reconstruire la matrice W politique du papier"
  reason: "La formule SDM est confirmee, mais W est une proximite politique et non une matrice construite depuis les coordonnees."
```

- Decision: needs_original_W
- Manque principal: conserver ou reconstruire la matrice W politique du papier
- Raison: La formule SDM est confirmee, mais W est une proximite politique et non une matrice construite depuis les coordonnees.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "needs_original_W"
  eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy"]
  conditionally_eligible_estimators: ["sar_lag", "sem_error", "sdm_mixed"]
  ineligible_reason: "spatial econometric estimators require the original paper W or an explicitly accepted proxy W"
  rule: "paper fiches are eligible only when response, predictors, coordinates/geometry and required W are executable in the local artifact"
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 1428
- k variables: 31
- T periods: 306
- Variable temporelle: ts
- N/T profile: N_grand_T_grand

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 306 distinct periods (variable: ts)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-110.243807777161, 176.516596816029], y [-38.30531015, 79.958143]
- Time range: 1952-06-25 to 2005-05-05 (variable: ts)
- CRS analyse recommande: pending - multi-zones (span=286.8deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`wald_test` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `wald_test` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`wald_test` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: The Wald Test of Common Factors in Spatial Model Specification Search Strategies

