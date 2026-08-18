---
title: paper_ethiopia_clusters
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_ethiopia_clusters.rds
  - DataCite_2022_SpatialTrendsAndProjections_10_1186_s41043_0
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Spatial trends and projections of chronic malnutrition among children under 5 years of age in Ethiopia from 2011 to 2019: a geographically weighted regression analysis" (DOI 10.1186/s41043-022-00309-7).

## Description du jeu de donnees

- Topic: sante publique / geographie de la malnutrition
- Observation unit: cluster spatial significatif (SaTScan)
- Observed population: enfants de moins de 5 ans, Ethiopie
- Geographic context: etendue sf: x [34.455099, 41.792392], y [3.621391, 13.987653]
- Temporal context: 3 distinct periods (variable: year)
- Source description: Spatial trends and projections of chronic malnutrition among children under 5 years of age in Ethiopia from 2011 to 2019: a geographically weighted regression analysis
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1186/s41043-022-00309-7
- Dataset DOI: 10.6084/m9.figshare.20236415
- Source URL: https://springernature.figshare.com/articles/dataset/Additional_file_2_of_Spatial_trends_and_projections_of_chronic_malnutrition_among_children_under_5_years_of_age_in_Ethiopia_from_2011_to_2019_a_geographically_weighted_regression_analysis/20236415
- Local raw dir: `data/raw/papers/DataCite_2022_SpatialTrendsAndProjections_10_1186_s41043_0/`
- Local sf output: `data/final_datasets/sf/paper_ethiopia_clusters.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `RR`, `cases`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `radius_km`, `population`, `LLR`, `p_value`
- Candidate X count in local artifact: 4
- Candidate X typology: continuous, categorical
- Published X variables from paper: radius_km, population, LLR, p_value
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): `cluster`, `year`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `RR` | `numeric` | continuous | [1.27, 2.23] | 0% |
| `cases` | `numeric` | continuous | [19, 2082] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `ethiopia_clusters`, la ou les reponses `RR`, `cases` viennent du loader papier et/ou des preuves de l article `Spatial trends and projections of chronic malnutrition among children under 5 years of age in Ethiopia from 2011 to 2019: a geographically weighted regression analysis`. Les covariables X retenues sont `radius_km`, `population`, `LLR`, `p_value`. Les coordonnees (`lon`, `lat`), identifiants (`cluster`, `year`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : not_ready_derived_clusters ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `radius_km` | `numeric` | continuous | 0% |
| `population` | `numeric` | continuous | 0% |
| `LLR` | `character` | categorical | 0% |
| `p_value` | `character` | categorical | 0% |

### Formule - niveau publication

- formula_pub: pending
- x_terms_pub: radius_km, population, LLR, p_value
- y_term_pub: RR
- Reference publication: DataCite dataset DOI 10.6084/m9.figshare.20236415; Publication DOI 10.1186/s41043-022-00309-7

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule - niveau systeme

- formula_used: RR ~ radius_km + population + LLR + p_value
- x_terms_used: radius_km, population, LLR, p_value
- y_term_used: RR
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
    formula: "RR ~ radius_km + population + LLR + p_value"
    response: "RR"
    predictors: ["radius_km", "population", "LLR", "p_value"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/raw/papers (loader-derived, no published equation located)"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_ethiopia_clusters`
- Dataset name: Additional file 2 of Spatial trends and projections of chronic malnutrition among children under 5 years of age in Ethiopia from 2011 to 2019: a geographically weighted regression analysis
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Spatial trends and projections of chronic malnutrition among children under 5 years of age in Ethiopia from 2011 to 2019: a geographically weighted regression analysis
- Paper DOI: 10.1186/s41043-022-00309-7
- Dataset DOI: 10.6084/m9.figshare.20236415
- Source URL: https://springernature.figshare.com/articles/dataset/Additional_file_2_of_Spatial_trends_and_projections_of_chronic_malnutrition_among_children_under_5_years_of_age_in_Ethiopia_from_2011_to_2019_a_geographically_weighted_regression_analysis/20236415
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
  benchmark_status: "not_ready_derived_clusters"
  benchmark_task: "cluster_detection_output"
  package_include: "no"
  has_local_rds: true
  missing_items: "retrouver le jeu DHS/GWR original ou rester hors benchmark"
  reason: "Le fichier contient des clusters SaTScan derives, pas les observations de malnutrition utilisees pour la GWR."
```

- Decision: not_ready_derived_clusters
- Manque principal: retrouver le jeu DHS/GWR original ou rester hors benchmark
- Raison: Le fichier contient des clusters SaTScan derives, pas les observations de malnutrition utilisees pour la GWR.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "not_ready_derived_clusters"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "current package supports continuous spatial regression benchmarks; this fiche is not currently an executable continuous-regression dataset"
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 7
- k variables: 13
- T periods: 3
- Variable temporelle: year
- N/T profile: N_petit_T_moyen
- Note N/T (session 2026-08-17, verification directe du `.rds`) : verification empirique montre qu'il n'y a AUCUNE repetition de geometrie (N spatial = N observations exactement) malgre la classification 'Structure: panel_ou_series' / 'Data type: spatio-temporel' ci-dessus -- chaque ligne correspond a un lieu unique. Ce n'est donc pas un panel au sens statistique (pas de correlation intra-unite a modeliser), plutot une coupe transversale avec une covariable/dimension temporelle associee a chaque point distinct.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 3 distinct periods (variable: year)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [34.455099, 41.792392], y [3.621391, 13.987653]
- Time range: 2011 to 2019 (variable: year)
- CRS analyse recommande: 32637 (UTM Zone 37N (EPSG:32637)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Attribution 4.0 International
- License URL: https://creativecommons.org/licenses/by/4.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.6084/m9.figshare.20236415 (checked 2026-08-18): rightsList = 'Creative Commons Attribution 4.0 International'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`ethiopia_clusters` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `ethiopia_clusters` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: PENDING - formule publication non encore etablie (formule candidate systeme fournie a la place).
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`ethiopia_clusters` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Spatial trends and projections of chronic malnutrition among children under 5 years of age in Ethiopia from 2011 to 2019: a geographically weighted regression analysis

