---
title: paper_mammals_sr_pd
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_mammals_sr_pd.rds
  - DataCite_2019_EnvironmentalFactorsExplainThe_10_1111_geb_1299
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Environmental factors explain the spatial mismatches between species richness and phylogenetic diversity of terrestrial mammals" (DOI 10.1111/geb.12999).

## Description du jeu de donnees

- Topic: biogeographie vegetale / gradients de richesse
- Observation unit: cellule de grille (100x100 km)
- Observed population: especes du genre Medicago
- Geographic context: etendue sf: x [-178.137100743291, 178.191046040827], y [-52.1756104, 82.3396486]
- Temporal context: none (cross-sectional)
- Source description: Environmental factors explain the spatial mismatches between species richness and phylogenetic diversity of terrestrial mammals
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/geb.12999
- Dataset DOI: 10.5061/dryad.nq8hg19
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.nq8hg19
- Local raw dir: `data/raw/papers/DataCite_2019_EnvironmentalFactorsExplainThe_10_1111_geb_1299/`
- Local sf output: `data/final_datasets/sf/paper_mammals_sr_pd.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `SR`, `PD`
- Candidate Y typology: count, continuous
- Candidate X variables in local artifact: `area`, `LGM_vel`, `Temp`, `AET`, `Elev`, `d_PD_SR`, `d_PD_tm`, `d_PD_LG`, `d_PD_lv`, `d_PD_at`, `R2_PD`, `res_PD`, `d_SR_tm`, `d_SR_LG`, `d_SR_lv`, `d_SR_at`, `R2_SR`, `res_SR`, `i_PD_SR_t`, `i_PD_SR_L`, `i_PD_SR__1`, `i_PD_SR_A`, `t_PD_tm`, `t_PD_LG`, `t_PD_lv`, `t_PD_at`
- Candidate X count in local artifact: 26
- Candidate X typology: continuous
- Published X variables from paper: AET, Temp
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `ID`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `SR` | `integer` | count | [6, 239] | 0% |
| `PD` | `numeric` | continuous | [367.4006, 5651.262] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `mammals_sr_pd`, la ou les reponses `SR`, `PD` viennent du loader papier et/ou des preuves de l article `Environmental factors explain the spatial mismatches between species richness and phylogenetic diversity of terrestrial mammals`. Les covariables X retenues sont `AET`, `Temp` ; 24 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (`ID`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `area` | `numeric` | continuous | 0% |
| `LGM_vel` | `numeric` | continuous | 0% |
| `Temp` | `numeric` | continuous | 0% |
| `AET` | `numeric` | continuous | 0% |
| `Elev` | `numeric` | continuous | 0% |
| `d_PD_SR` | `numeric` | continuous | 0% |
| `d_PD_tm` | `numeric` | continuous | 0% |
| `d_PD_LG` | `numeric` | continuous | 0% |
| `d_PD_lv` | `numeric` | continuous | 0% |
| `d_PD_at` | `numeric` | continuous | 0% |
| `R2_PD` | `numeric` | rate | 0% |
| `res_PD` | `numeric` | continuous | 0% |
| `d_SR_tm` | `numeric` | continuous | 0% |
| `d_SR_LG` | `numeric` | continuous | 0% |
| `d_SR_lv` | `numeric` | continuous | 0% |
| `d_SR_at` | `numeric` | continuous | 0% |
| `R2_SR` | `numeric` | rate | 0% |
| `res_SR` | `numeric` | continuous | 0% |
| `i_PD_SR_t` | `numeric` | continuous | 0% |
| `i_PD_SR_L` | `numeric` | continuous | 0% |
| `i_PD_SR__1` | `numeric` | continuous | 0% |
| `i_PD_SR_A` | `numeric` | continuous | 0% |
| `t_PD_tm` | `numeric` | continuous | 0% |
| `t_PD_LG` | `numeric` | continuous | 0% |
| `t_PD_lv` | `numeric` | continuous | 0% |
| `t_PD_at` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: SR ~ 0.47*AET + 0.31*Mean_annual_temperature (R2=0.75) ; PD ~ 0.95*SR - 0.37*LGM_velocity + 0.12*Mean_elevation (R2=0.97)
- x_terms_pub: AET, Temp
- y_term_pub: SR
- Reference publication: Barreto, Graham & Rangel (2019), Global Ecology and Biogeography, Figure 1 - modele de path analysis (coefficients standardises, moyenne +/- ecart-type mondial) reliant AET, temperature, velocite climatique depuis le LGM et elevation a la richesse specifique (SR) et la diversite phylogenetique (PD) des mammiferes terrestres.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: SR ~ AET + Temp
- x_terms_used: AET, Temp
- y_term_used: SR
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
    formula: "SR ~ AET + Temp"
    response: "SR"
    predictors: ["AET", "Temp"]
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

- Dataset ID: `paper_mammals_sr_pd`
- Dataset name: Data from: Environmental factors explain the spatial mismatches between species richness and phylogenetic diversity of terrestrial mammals
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Environmental factors explain the spatial mismatches between species richness and phylogenetic diversity of terrestrial mammals
- Paper DOI: 10.1111/geb.12999
- Dataset DOI: 10.5061/dryad.nq8hg19
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.nq8hg19
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "SR ~ 0.47*AET + 0.31*Mean_annual_temperature (R2=0.75) ; PD ~ 0.95*SR - 0.37*LGM_velocity + 0.12*Mean_elevation (R2=0.97)"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Barreto, Graham & Rangel (2019), Global Ecology and Biogeography, Figure 1 - modele de path analysis (coefficients standardises, moyenne +/- ecart-type mondial) reliant AET, temperature, velocite climatique depuis le LGM et elevation a la richesse specifique (SR) et la diversite phylogenetique (PD) des mammiferes terrestres."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "SR est retenu comme benchmark canonique; PD reste documente comme reponse alternative publiee"
  reason: "Y=SR continu, covariables AET et Temp, coordonnees et formule canonique issue de la Figure 1 sont disponibles."
```

- Decision: ready
- Manque principal: SR est retenu comme benchmark canonique; PD reste documente comme reponse alternative publiee
- Raison: Y=SR continu, covariables AET et Temp, coordonnees et formule canonique issue de la Figure 1 sont disponibles.

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
- N observations: 17151
- k variables: 31
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-178.137100743291, 178.191046040827], y [-52.1756104, 82.3396486]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=356.3deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`mammals_sr_pd` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `mammals_sr_pd` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`mammals_sr_pd` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Environmental factors explain the spatial mismatches between species richness and phylogenetic diversity of terrestrial mammals

