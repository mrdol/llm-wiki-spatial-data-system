---
title: paper_swiss_rainfall
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_swiss_rainfall.rds
  - Moller_2020_OGC_swiss_rainfall
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Oblique geographic coordinates as covariates for digital soil mapping" (DOI 10.5194/soil-6-269-2020).

## Description du jeu de donnees

- Topic: climat / precipitation
- Observation unit: station ou point de mesure pluviometrique
- Observed population: mesures de pluie en Suisse, Spatial Interpolation Comparison 1997 / SIC97
- Geographic context: Point dataset, fort caractere anisotrope.
- Temporal context: none (cross-sectional)
- Source description: Oblique geographic coordinates as covariates for digital soil mapping
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: low
- Paper DOI: 10.5194/soil-6-269-2020
- Dataset DOI: none
- Source URL: https://cran.r-project.org/package=gstat
- Local raw dir: `data/raw/papers/Moller_2020_OGC_swiss_rainfall/`
- Local sf output: `data/final_datasets/sf/paper_swiss_rainfall.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `rainfall`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `ogc_000`, `ogc_030`, `ogc_060`, `ogc_090`, `ogc_120`, `ogc_150`
- Candidate X count in local artifact: 6
- Candidate X typology: continuous
- Published X variables from paper: oblique geographic coordinates, ordinary kriging, EDFs, RFsp
- Published X count: 4
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `ID`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `rainfall` | `integer` | continuous | [0, 585] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `swiss_rainfall`, la ou les reponses `rainfall` viennent du loader papier et/ou des preuves de l article `Oblique geographic coordinates as covariates for digital soil mapping`. Les covariables X retenues sont `ogc_000`, `ogc_030`, `ogc_060`, `ogc_090`, `ogc_120`, `ogc_150`. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (`ID`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `ogc_000` | `numeric` | continuous | 0% |
| `ogc_030` | `numeric` | continuous | 0% |
| `ogc_060` | `numeric` | continuous | 0% |
| `ogc_090` | `numeric` | continuous | 0% |
| `ogc_120` | `numeric` | continuous | 0% |
| `ogc_150` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: rainfall ~ oblique_geographic_coordinates [random forest / OGC spatial covariates]
- x_terms_pub: oblique geographic coordinates, ordinary kriging, EDFs, RFsp
- y_term_pub: rainfall on 8 May 1986
- Reference publication: Moller et al. (2020), Soil, DOI 10.5194/soil-6-269-2020: Section 2.3.2 and Appendix A compare purely spatial methods on the Swiss rainfall dataset, including OGCs as explicit coordinate covariates. The local loader generates six oblique coordinate covariates from the point geometry, making formula_used executable as an OGC benchmark variant rather than a conventional environmental regression.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: rainfall ~ ogc_000 + ogc_030 + ogc_060 + ogc_090 + ogc_120 + ogc_150
- x_terms_used: ogc_000, ogc_030, ogc_060, ogc_090, ogc_120, ogc_150
- y_term_used: rainfall
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
    formula: "rainfall ~ ogc_000 + ogc_030 + ogc_060 + ogc_090 + ogc_120 + ogc_150"
    response: "rainfall on 8 May 1986"
    predictors: ["oblique geographic coordinates", "ordinary kriging", "EDFs", "RFsp"]
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

- Dataset ID: `paper_swiss_rainfall`
- Dataset name: Swiss rainfall
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Oblique geographic coordinates as covariates for digital soil mapping
- Paper DOI: 10.5194/soil-6-269-2020
- Dataset DOI: none
- Source URL: https://cran.r-project.org/package=gstat
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "rainfall ~ oblique_geographic_coordinates [random forest / OGC spatial covariates]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Moller et al. (2020), Soil, DOI 10.5194/soil-6-269-2020: Section 2.3.2 and Appendix A compare purely spatial methods on the Swiss rainfall dataset, including OGCs as explicit coordinate covariates. The local loader generates six oblique coordinate covariates from the point geometry, making formula_used executable as an OGC benchmark variant rather than a conventional environmental regression."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous_ogc_spatial_covariates"
  package_include: "yes"
  has_local_rds: true
  missing_items: "X = covariables spatiales construites par OGC (pas des covariables environnementales) ; nombre d'angles fixe a 6, pas de tuning"
  reason: "Le papier Moller et al. (2020) compare explicitement OGCs, EDFs, RFsp et kriging sur Swiss rainfall (benchmark SIC97 classique) ; le loader genere des covariables OGC reproductibles depuis la geometrie. Y continu, X defendable (technique explicitement testee par le papier), artefact local utilisable -- promu sans revue manuelle (2026-08-12), statut normalise depuis almost_ready_ogc_spatial_covariates."
```

- Decision: ready
- Manque principal: X = covariables spatiales construites par OGC (pas des covariables environnementales) ; nombre d'angles fixe a 6, pas de tuning
- Raison: Le papier Moller et al. (2020) compare explicitement OGCs, EDFs, RFsp et kriging sur Swiss rainfall (benchmark SIC97 classique) ; le loader genere des covariables OGC reproductibles depuis la geometrie. Y continu, X defendable (technique explicitement testee par le papier), artefact local utilisable -- promu sans revue manuelle (2026-08-12), statut normalise depuis almost_ready_ogc_spatial_covariates.

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
- N observations: 467
- k variables: 10
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: unknown
- CRS nom: unknown
- Spatial extent: x [-159812, 172891], y [-109008, 105361]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`swiss_rainfall` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `swiss_rainfall` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: WARN - CRS absent du sf source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`swiss_rainfall` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Oblique geographic coordinates as covariates for digital soil mapping

