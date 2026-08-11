---
title: paper_florida_crash_gsvcm
type: dataset
created: 2026-08-11
updated: 2026-08-11
sources:
  - data/final_datasets/sf/paper_florida_crash_gsvcm.rds
  - DataCite_2020_GeneralizedSpatiallyVaryingCoefficient_10_1080_10618600
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Generalized Spatially Varying Coefficient Models" (DOI 10.1080/10618600.2020.1754225).

## Description du jeu de donnees

- Topic: transport / securite routiere
- Observation unit: zone spatiale de comptage des accidents
- Observed population: accidents routiers et facteurs socio-demographiques locaux
- Geographic context: etendue sf: x [-87.5292058, -80.0332227], y [25.2968416, 30.9855385]
- Temporal context: none (cross-sectional)
- Source description: Generalized Spatially Varying Coefficient Models
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1080/10618600.2020.1754225
- Dataset DOI: 10.6084/m9.figshare.12156975
- Source URL: https://tandf.figshare.com/articles/dataset/Generalized_Spatially_Varying_Coefficient_Models/12156975
- Local raw dir: `data/raw/papers/DataCite_2020_GeneralizedSpatiallyVaryingCoefficient_10_1080_10618600/`
- Local sf output: `data/final_datasets/sf/paper_florida_crash_gsvcm.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Offcrsh`
- Candidate Y typology: count
- Candidate X variables in local artifact: `log.VMT`, `log.Pop`, `Rmale`, `Rold`, `Rhisp`, `Runemploy`
- Candidate X count in local artifact: 6
- Candidate X typology: continuous
- Published X variables from paper: log.VMT, log.Pop, Rmale, Rhisp, Rold, Runemploy
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): `Lon`, `Lat`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Offcrsh` | `integer` | count | [0, 159] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `florida_crash_gsvcm`, la ou les reponses `Offcrsh` viennent du loader papier et/ou des preuves de l article `Generalized Spatially Varying Coefficient Models`. Les covariables X retenues sont `log.VMT`, `log.Pop`, `Rmale`, `Rhisp`, `Rold`, `Runemploy`. Les coordonnees (`Lon`, `Lat`), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : almost_ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `log.VMT` | `numeric` | continuous | 0% |
| `log.Pop` | `numeric` | continuous | 0% |
| `Rmale` | `numeric` | rate | 0% |
| `Rold` | `numeric` | rate | 0% |
| `Rhisp` | `numeric` | rate | 0% |
| `Runemploy` | `numeric` | rate | 0% |

### Formule - niveau publication

- formula_pub: Offcrsh ~ log.VMT + log.Pop + Rmale + Rhisp + Rold + Runemploy [GSVCM negative-binomial application]
- x_terms_pub: log.VMT, log.Pop, Rmale, Rhisp, Rold, Runemploy
- y_term_pub: Offcrsh
- Reference publication: Wu et al. (2020), supplementary script Code/main_GSVCM_application.R: y=Offcrsh, S=(Lon,Lat), X=log.VMT, log.Pop, Rmale, Rhisp, Rold, Runemploy; family=nb_bps().

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-11). Wu et al. (2020), supplementary script Code/main_GSVCM_application.R: y=Offcrsh, S=(Lon,Lat), X=log.VMT, log.Pop, Rmale, Rhisp, Rold, Runemploy; family=nb_bps().

### Formule - niveau systeme

- formula_used: Offcrsh ~ log.VMT + log.Pop + Rmale + Rhisp + Rold + Runemploy
- x_terms_used: log.VMT, log.Pop, Rmale, Rhisp, Rold, Runemploy
- y_term_used: Offcrsh
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-11). Wu et al. (2020), supplementary script Code/main_GSVCM_application.R: y=Offcrsh, S=(Lon,Lat), X=log.VMT, log.Pop, Rmale, Rhisp, Rold, Runemploy; family=nb_bps().

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
    formula: "Offcrsh ~ log.VMT + log.Pop + Rmale + Rhisp + Rold + Runemploy"
    response: "Offcrsh"
    predictors: ["log.VMT", "log.Pop", "Rmale", "Rhisp", "Rold", "Runemploy"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Wu et al. (2020), supplementary script Code/main_GSVCM_application.R: y=Offcrsh, S=(Lon,Lat), X=log.VMT, log.Pop, Rmale, Rhisp, Rold, Runemploy; family=nb_bps()."
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

- Dataset ID: `paper_florida_crash_gsvcm`
- Dataset name: Generalized Spatially Varying Coefficient Models
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Generalized Spatially Varying Coefficient Models
- Paper DOI: 10.1080/10618600.2020.1754225
- Dataset DOI: 10.6084/m9.figshare.12156975
- Source URL: https://tandf.figshare.com/articles/dataset/Generalized_Spatially_Varying_Coefficient_Models/12156975
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Offcrsh ~ log.VMT + log.Pop + Rmale + Rhisp + Rold + Runemploy [GSVCM negative-binomial application]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Wu et al. (2020), supplementary script Code/main_GSVCM_application.R: y=Offcrsh, S=(Lon,Lat), X=log.VMT, log.Pop, Rmale, Rhisp, Rold, Runemploy; family=nb_bps()."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "almost_ready"
  benchmark_task: "regression_count_spatial_svc"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "confirmer dans l'article que l'application Florida crash est le cas empirique principal et choisir traitement count vs regression continue"
  reason: "Le script supplementaire donne explicitement Y, X et coordonnees; reponse Offcrsh est un compte."
```

- Decision: almost_ready
- Manque principal: confirmer dans l'article que l'application Florida crash est le cas empirique principal et choisir traitement count vs regression continue
- Raison: Le script supplementaire donne explicitement Y, X et coordonnees; reponse Offcrsh est un compte.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "almost_ready"
  eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
  conditionally_eligible_estimators: []
  ineligible_reason: ""
  rule: "paper fiches are eligible only when response, predictors, coordinates/geometry and required W are executable in the local artifact"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 11249
- k variables: 11
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-87.5292058, -80.0332227], y [25.2968416, 30.9855385]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32617 (UTM Zone 17N (EPSG:32617)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`florida_crash_gsvcm` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `florida_crash_gsvcm` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`florida_crash_gsvcm` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Generalized Spatially Varying Coefficient Models

