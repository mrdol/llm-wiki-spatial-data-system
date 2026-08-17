---
title: paper_rocky_mountain_tree_growth
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_rocky_mountain_tree_growth.rds
  - DataCite_2017_ClimateAndCompetitionEffects_10_1111_1365_274
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Climate and competition effects on tree growth in Rocky Mountain forests" (DOI 10.1111/1365-2745.12782).

## Description du jeu de donnees

- Topic: ecologie forestiere / inventaire de biomasse
- Observation unit: placette d'inventaire forestier
- Observed population: placettes CTFT/ONF, foret tropicale humide
- Geographic context: etendue sf: x [-113.9646749, -104.819445], y [32.6490466, 49.0012623]
- Temporal context: none (cross-sectional)
- Source description: Climate and competition effects on tree growth in Rocky Mountain forests
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/1365-2745.12782
- Dataset DOI: 10.5061/dryad.fv322
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.fv322
- Local raw dir: `data/raw/papers/DataCite_2017_ClimateAndCompetitionEffects_10_1111_1365_274/`
- Local sf output: `data/final_datasets/sf/paper_rocky_mountain_tree_growth.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `mean_ring_width_mm`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `elevation_m`, `aspect_degrees`, `terrain_slope_pct`, `mean_stem_diameter_cm`, `mean_age_years`, `neighbor_count`, `neighbor_dbh_sum`, `neighbor_distance_mean`
- Candidate X count in local artifact: 8
- Candidate X typology: continuous
- Published X variables from paper: climate, neighbour competition, stem diameter, age, elevation, aspect, slope
- Published X count: 7
- Coordinates (x, y - excluded from X candidates): `Longitude`, `Latitude`
- Identifier columns (excluded from X candidates): `Sample.tree.ID`, `Species`, `Site`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `mean_ring_width_mm` | `numeric` | continuous | [0.1522, 7.4022] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `rocky_mountain_tree_growth`, la ou les reponses `mean_ring_width_mm` viennent du loader papier et/ou des preuves de l article `Climate and competition effects on tree growth in Rocky Mountain forests`. Les covariables X retenues sont `elevation_m`, `aspect_degrees`, `terrain_slope_pct`, `mean_stem_diameter_cm`, `mean_age_years`, `neighbor_count`, `neighbor_dbh_sum`, `neighbor_distance_mean`. Les coordonnees (`Longitude`, `Latitude`), identifiants (`Sample.tree.ID`, `Species`, `Site`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `elevation_m` | `integer` | continuous | 0% |
| `aspect_degrees` | `integer` | count | 0% |
| `terrain_slope_pct` | `integer` | continuous | 0% |
| `mean_stem_diameter_cm` | `numeric` | continuous | 0% |
| `mean_age_years` | `numeric` | continuous | 0% |
| `neighbor_count` | `integer` | count | 0.5% |
| `neighbor_dbh_sum` | `numeric` | continuous | 0.5% |
| `neighbor_distance_mean` | `numeric` | continuous | 0.5% |

### Formule - niveau publication

- formula_pub: annual tree growth / ring width ~ climate + competition + topography [mixed-effects tree-growth model]
- x_terms_pub: climate, neighbour competition, stem diameter, age, elevation, aspect, slope
- y_term_pub: annual radial growth / ring width
- Reference publication: Buechling et al. (2017), Journal of Ecology, DOI 10.1111/1365-2745.12782: the paper models tree growth using climate and competition effects. The local benchmark collapses annual ring-width observations to one spatial record per sampled tree and joins neighbour-count/DBH summaries; climate time series are not reconstructed in this loader.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: mean_ring_width_mm ~ elevation_m + aspect_degrees + terrain_slope_pct + mean_stem_diameter_cm + mean_age_years + neighbor_count + neighbor_dbh_sum + neighbor_distance_mean
- x_terms_used: elevation_m, aspect_degrees, terrain_slope_pct, mean_stem_diameter_cm, mean_age_years, neighbor_count, neighbor_dbh_sum, neighbor_distance_mean
- y_term_used: mean_ring_width_mm
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
    formula: "mean_ring_width_mm ~ topography + tree size/age + local neighbour competition"
    response: "annual radial growth / ring width"
    predictors: ["climate", "neighbour competition", "stem diameter", "age", "elevation", "aspect", "slope"]
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

- Dataset ID: `paper_rocky_mountain_tree_growth`
- Dataset name: Data from: Climate and competition effects on tree growth in Rocky Mountain forests
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Climate and competition effects on tree growth in Rocky Mountain forests
- Paper DOI: 10.1111/1365-2745.12782
- Dataset DOI: 10.5061/dryad.fv322
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.fv322
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "annual tree growth / ring width ~ climate + competition + topography [mixed-effects tree-growth model]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Buechling et al. (2017), Journal of Ecology, DOI 10.1111/1365-2745.12782: the paper models tree growth using climate and competition effects. The local benchmark collapses annual ring-width observations to one spatial record per sampled tree and joins neighbour-count/DBH summaries; climate time series are not reconstructed in this loader."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous_reduced_cross_section"
  package_include: "yes"
  has_local_rds: true
  missing_items: "climat temporel du modele publie non reconstruit ; artefact local agrégé par arbre"
  reason: "Le loader produit une coupe spatiale par arbre avec ring width moyen et competition locale. C'est executable, mais reduit par rapport au modele temporel climat x competition du papier."
```

- Decision: ready
- Manque principal: climat temporel du modele publie non reconstruit ; artefact local agrégé par arbre
- Raison: Le loader produit une coupe spatiale par arbre avec ring width moyen et competition locale. C'est executable, mais reduit par rapport au modele temporel climat x competition du papier.

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
- N observations: 771
- k variables: 16
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-113.9646749, -104.819445], y [32.6490466, 49.0012623]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32612 (UTM Zone 12N (EPSG:32612)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`rocky_mountain_tree_growth` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `rocky_mountain_tree_growth` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`rocky_mountain_tree_growth` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Climate and competition effects on tree growth in Rocky Mountain forests

