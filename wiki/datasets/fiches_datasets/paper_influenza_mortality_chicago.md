---
title: paper_influenza_mortality_chicago
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_influenza_mortality_chicago.rds
  - DataCite_2016_DisparitiesInInfluenzaMortality_10_1073_pnas_161
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Disparities in influenza mortality and transmission related to sociodemographic factors within Chicago in the pandemic of 1918" (DOI 10.1073/pnas.1612838113).

## Description du jeu de donnees

- Topic: dataset spatial spatio-temporel
- Observation unit: observation spatiale du dataset "Data from: Disparities in influenza mortality and transmission related to sociodemographic factors within Chicago in the pandemic of 1918"
- Observed population: Analyse spatiotemporelle de la mortalitÃ© grippale Ã  Chicago en 1918 avec modÃ¨les Poisson GEE ; facteurs sociodÃ©mographiques (illettrisme, propriÃ©tÃ©, chÃ´mage) ; clustering spatiotemporel ; correspond au pÃ©rimÃ¨tre health / mortality / epidemiology / spatial autocorrelation / urban studies
- Geographic context: etendue sf: x [343002.47984075, 366885.347685765], y [555447.603044471, 594646.045600259]
- Temporal context: 7 distinct periods (variable: week)
- Source description: Disparities in influenza mortality and transmission related to sociodemographic factors within Chicago in the pandemic of 1918
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1073/pnas.1612838113
- Dataset DOI: 10.5061/dryad.48nv3
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.48nv3
- Local raw dir: `data/raw/papers/DataCite_2016_DisparitiesInInfluenzaMortality_10_1073_pnas_161/`
- Local sf output: `data/final_datasets/sf/paper_influenza_mortality_chicago.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `counts`
- Candidate Y typology: count
- Candidate X variables in local artifact: `week`, `pop`, `Gross_acres`, `illit`, `illit.r`, `den.r`, `unemployed.pct`, `ho.pct`, `agecat1`, `agecat2`, `agecat3`, `agecat4`, `agecat5`, `agecat6`, `agecat7`
- Candidate X count in local artifact: 15
- Candidate X typology: continuous
- Published X variables from paper: illit, den.r, unemployed.pct, ho.pct, agecat1, agecat2, agecat3, agecat4, agecat5, agecat6, agecat7
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `GISJOIN`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `counts` | `integer` | count | [0, 31] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `influenza_mortality_chicago`, la ou les reponses `counts` viennent du loader papier et/ou des preuves de l article `Disparities in influenza mortality and transmission related to sociodemographic factors within Chicago in the pandemic of 1918`. Les covariables X retenues sont `illit`, `den.r`, `unemployed.pct`, `ho.pct`, `agecat1`, `agecat2`, `agecat3`, `agecat4`, `agecat5`, `agecat6`, `agecat7` ; 4 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (`GISJOIN`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `week` | `integer` | count | 0% |
| `pop` | `integer` | count | 0% |
| `Gross_acres` | `numeric` | continuous | 0% |
| `illit` | `integer` | count | 0% |
| `illit.r` | `numeric` | rate | 0% |
| `den.r` | `numeric` | continuous | 0% |
| `unemployed.pct` | `numeric` | rate | 0% |
| `ho.pct` | `numeric` | rate | 0% |
| `agecat1` | `integer` | count | 0% |
| `agecat2` | `integer` | count | 0% |
| `agecat3` | `integer` | count | 0% |
| `agecat4` | `integer` | count | 0% |
| `agecat5` | `integer` | count | 0% |
| `agecat6` | `integer` | count | 0% |
| `agecat7` | `integer` | count | 0% |

### Formule - niveau publication

- formula_pub: counts ~ illit + den.r + unemployed.pct + ho.pct + agecat1 + agecat2 + agecat3 + agecat4 + agecat5 + agecat6 + agecat7, offset=pop
- x_terms_pub: illit, den.r, unemployed.pct, ho.pct, agecat1, agecat2, agecat3, agecat4, agecat5, agecat6, agecat7
- y_term_pub: counts
- Reference publication: Grantz, Rane, Salje, Glass, Schachterle & Cummings (2016), PNAS, DOI 10.1073/pnas.1612838113; tracts.csv (Dryad 10.5061/dryad.48nv3) documente un panel tract x semaine (496 tracts x 7 semaines) avec deces (counts), population (pop, exposition) et covariables sociodemographiques ; jointure verifiee a la geometrie via GISJOIN du shapefile IL_tract_a.shp.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Grantz, Rane, Salje, Glass, Schachterle & Cummings (2016), PNAS, DOI 10.1073/pnas.1612838113; tracts.csv (Dryad 10.5061/dryad.48nv3) documente un panel tract x semaine (496 tracts x 7 semaines) avec deces (counts), population (pop, exposition) et covariables sociodemographiques ; jointure verifiee a la geometrie via GISJOIN du shapefile IL_tract_a.shp.

### Formule - niveau systeme

- formula_used: counts ~ illit + den.r + unemployed.pct + ho.pct + agecat1 + agecat2 + agecat3 + agecat4 + agecat5 + agecat6 + agecat7
- x_terms_used: illit, den.r, unemployed.pct, ho.pct, agecat1, agecat2, agecat3, agecat4, agecat5, agecat6, agecat7
- y_term_used: counts
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Grantz, Rane, Salje, Glass, Schachterle & Cummings (2016), PNAS, DOI 10.1073/pnas.1612838113; tracts.csv (Dryad 10.5061/dryad.48nv3) documente un panel tract x semaine (496 tracts x 7 semaines) avec deces (counts), population (pop, exposition) et covariables sociodemographiques ; jointure verifiee a la geometrie via GISJOIN du shapefile IL_tract_a.shp.

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
    formula: "counts ~ illit + den.r + unemployed.pct + ho.pct + agecat1 + agecat2 + agecat3 + agecat4 + agecat5 + agecat6 + agecat7"
    response: "counts"
    predictors: ["illit", "den.r", "unemployed.pct", "ho.pct", "agecat1", "agecat2", "agecat3", "agecat4", "agecat5", "agecat6", "agecat7"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Grantz, Rane, Salje, Glass, Schachterle & Cummings (2016), PNAS, DOI 10.1073/pnas.1612838113; tracts.csv (Dryad 10.5061/dryad.48nv3) documente un panel tract x semaine (496 tracts x 7 semaines) avec deces (counts), population (pop, exposition) et covariables sociodemographiques ; jointure verifiee a la geometrie via GISJOIN du shapefile IL_tract_a.shp."
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

- Dataset ID: `paper_influenza_mortality_chicago`
- Dataset name: Data from: Disparities in influenza mortality and transmission related to sociodemographic factors within Chicago in the pandemic of 1918
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Disparities in influenza mortality and transmission related to sociodemographic factors within Chicago in the pandemic of 1918
- Paper DOI: 10.1073/pnas.1612838113
- Dataset DOI: 10.5061/dryad.48nv3
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.48nv3
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "counts ~ illit + den.r + unemployed.pct + ho.pct + agecat1 + agecat2 + agecat3 + agecat4 + agecat5 + agecat6 + agecat7, offset=pop"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Grantz, Rane, Salje, Glass, Schachterle & Cummings (2016), PNAS, DOI 10.1073/pnas.1612838113; tracts.csv (Dryad 10.5061/dryad.48nv3) documente un panel tract x semaine (496 tracts x 7 semaines) avec deces (counts), population (pop, exposition) et covariables sociodemographiques ; jointure verifiee a la geometrie via GISJOIN du shapefile IL_tract_a.shp."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_count_spatiotemporal"
  package_include: "yes"
  has_local_rds: true
  missing_items: "structure panel tract x semaine (T=7) documentee ; a surveiller si le schema de CV du package suppose des observations independantes"
  reason: "counts, offset pop, covariables sociodemographiques et geometrie polygone (jointure GISJOIN verifiee) tous confirmes ; structure spatio-temporelle (496 tracts x 7 semaines). Y defendable (count + offset), X defendables, artefact local utilisable -- promu sans revue manuelle (2026-08-12)."
```

- Decision: ready
- Manque principal: structure panel tract x semaine (T=7) documentee ; a surveiller si le schema de CV du package suppose des observations independantes
- Raison: counts, offset pop, covariables sociodemographiques et geometrie polygone (jointure GISJOIN verifiee) tous confirmes ; structure spatio-temporelle (496 tracts x 7 semaines). Y defendable (count + offset), X defendables, artefact local utilisable -- promu sans revue manuelle (2026-08-12).

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

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 3472
- k variables: 20
- T periods: 7
- Variable temporelle: week
- N/T profile: N_grand_T_moyen

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 7 distinct periods (variable: week)
- CRS EPSG: 26971
- CRS nom: NAD83 / Illinois East
- Spatial extent: x [343002.47984075, 366885.347685765], y [555447.603044471, 594646.045600259]
- Time range: 1 to 7 (variable: week)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`influenza_mortality_chicago` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `influenza_mortality_chicago` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (26971).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`influenza_mortality_chicago` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Disparities in influenza mortality and transmission related to sociodemographic factors within Chicago in the pandemic of 1918

