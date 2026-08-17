---
title: paper_joshua_tree_flowering
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_joshua_tree_flowering.rds
  - DataCite_2024_Reconstructing120YearsOf_10_1111_ele_1447
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Reconstructing 120 years of climate change impacts on Joshua tree flowering" (DOI 10.1111/ele.14478).

## Description du jeu de donnees

- Topic: ecologie / interactions plantes-pollinisateurs
- Observation unit: site d'observation ou cellule de grille d'occurrence
- Observed population: communautes de pollinisateurs ou d'oiseaux nectarivores
- Geographic context: etendue sf: x [-118.6666666, -112.7916662], y [33.7916662, 38.0833332]
- Temporal context: none (cross-sectional)
- Source description: Reconstructing 120 years of climate change impacts on Joshua tree flowering
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/ele.14478
- Dataset DOI: 10.5061/dryad.9kd51c5rr
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.9kd51c5rr
- Local raw dir: `data/raw/papers/DataCite_2024_Reconstructing120YearsOf_10_1111_ele_1447/`
- Local sf output: `data/final_datasets/sf/paper_joshua_tree_flowering.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `flyrs`
- Candidate Y typology: count
- Candidate X variables in local artifact: `Delta.Y1.2..PPT..mm.`, `Delta.Y0.1..PPT..mm.`, `Max.VPD.Y0...hPa.`, `Delta.Y0.1..Min.VPD..hPa.`, `Min.Temp.Y0...degree.C.`, `Delta.Y0.1..Max.Temp..degree.C.`
- Candidate X count in local artifact: 6
- Candidate X typology: continuous
- Published X variables from paper: Delta[Y1-2]*PPT, Delta[Y0-1]*PPT, Max VPD[Y0], Delta[Y0-1]*Min VPD, Delta[Y0-1]*Max Temp, Min Temp[Y0]
- Published X count: 6
- Coordinates (x, y - excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): `timeframe`, `ri.model`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `flyrs` | `integer` | count | [-7, 20] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `joshua_tree_flowering`, la ou les reponses `flyrs` viennent du loader papier et/ou des preuves de l article `Reconstructing 120 years of climate change impacts on Joshua tree flowering`. Les covariables X retenues sont `Delta.Y1.2..PPT..mm.`, `Delta.Y0.1..PPT..mm.`, `Max.VPD.Y0...hPa.`, `Delta.Y0.1..Min.VPD..hPa.`, `Min.Temp.Y0...degree.C.`, `Delta.Y0.1..Max.Temp..degree.C.`. Les coordonnees (`lon`, `lat`), identifiants (`timeframe`, `ri.model`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Delta.Y1.2..PPT..mm.` | `numeric` | continuous | 0% |
| `Delta.Y0.1..PPT..mm.` | `numeric` | continuous | 0% |
| `Max.VPD.Y0...hPa.` | `numeric` | continuous | 0% |
| `Delta.Y0.1..Min.VPD..hPa.` | `numeric` | continuous | 0% |
| `Min.Temp.Y0...degree.C.` | `numeric` | continuous | 0% |
| `Delta.Y0.1..Max.Temp..degree.C.` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: flowering indicator ~ annual precipitation + maximum/minimum temperature + vapor-pressure-deficit predictors [BART classification]; hindcast flowering years ~ selected climate deltas [continuous model output]
- x_terms_pub: Delta[Y1-2]*PPT, Delta[Y0-1]*PPT, Max VPD[Y0], Delta[Y0-1]*Min VPD, Delta[Y0-1]*Max Temp, Min Temp[Y0]
- y_term_pub: binary flowering event indicator for model training; predicted number of flowering years for hindcast summaries
- Reference publication: Yoder et al. (2024), Ecology Letters, DOI 10.1111/ele.14478: Sections Data compilation, Predictor selection and Hindcasting state that binary flowering observations were modelled with BART and then hindcast to 1900. The Dryad output archive contains jotr_flowering_predictors_change.csv, which reports continuous predicted flowering years (flyrs) by 4 km grid cell/timeframe with the six selected climate-change predictors. formula_used uses this continuous hindcast output, not the raw binary flr training response.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: flyrs ~ Delta.Y1.2..PPT..mm. + Delta.Y0.1..PPT..mm. + Max.VPD.Y0...hPa. + Delta.Y0.1..Min.VPD..hPa. + Delta.Y0.1..Max.Temp..degree.C. + Min.Temp.Y0...degree.C.
- x_terms_used: Delta.Y1.2..PPT..mm., Delta.Y0.1..PPT..mm., Max.VPD.Y0...hPa., Delta.Y0.1..Min.VPD..hPa., Min.Temp.Y0...degree.C., Delta.Y0.1..Max.Temp..degree.C.
- y_term_used: flyrs
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
    formula: "flyrs ~ selected annual weather deltas from the BART hindcast"
    response: "binary flowering event indicator for model training; predicted number of flowering years for hindcast summaries"
    predictors: ["Delta[Y1-2]*PPT", "Delta[Y0-1]*PPT", "Max VPD[Y0]", "Delta[Y0-1]*Min VPD", "Delta[Y0-1]*Max Temp", "Min Temp[Y0]"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "flyrs ~ selected climate deltas"
    response: "flyrs"
    predictors: ["Delta.Y1.2..PPT..mm.", "Delta.Y0.1..PPT..mm.", "Max.VPD.Y0...hPa.", "Delta.Y0.1..Min.VPD..hPa.", "Delta.Y0.1..Max.Temp..degree.C.", "Min.Temp.Y0...degree.C."]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["random_forest", "xgboost", "gamboost"]
    status: "confirmed_continuous_hindcast_response"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_joshua_tree_flowering`
- Dataset name: Data from: Reconstructing 120 years of climate change impacts on Joshua tree flowering
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Reconstructing 120 years of climate change impacts on Joshua tree flowering
- Paper DOI: 10.1111/ele.14478
- Dataset DOI: 10.5061/dryad.9kd51c5rr
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.9kd51c5rr
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "flowering indicator ~ annual precipitation + maximum/minimum temperature + vapor-pressure-deficit predictors [BART classification]; hindcast flowering years ~ selected climate deltas [continuous model output]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Yoder et al. (2024), Ecology Letters, DOI 10.1111/ele.14478: Sections Data compilation, Predictor selection and Hindcasting state that binary flowering observations were modelled with BART and then hindcast to 1900. The Dryad output archive contains jotr_flowering_predictors_change.csv, which reports continuous predicted flowering years (flyrs) by 4 km grid cell/timeframe with the six selected climate-change predictors. formula_used uses this continuous hindcast output, not the raw binary flr training response."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous_model_output"
  package_include: "yes"
  has_local_rds: true
  missing_items: "la reponse locale flyrs est une sortie continue du hindcast BART, pas l'observation binaire brute flr ; conserver cette nuance dans toute interpretation benchmark"
  reason: "Le papier entraine un BART sur flr binaire, puis publie des sorties continues de hindcast par cellule et periode. Le loader utilise flyrs et les six predicteurs climatiques de changement fournis dans l'archive, ce qui cree une version continue documentee sans transformer arbitrairement flr."
```

- Decision: ready
- Manque principal: la reponse locale flyrs est une sortie continue du hindcast BART, pas l'observation binaire brute flr ; conserver cette nuance dans toute interpretation benchmark
- Raison: Le papier entraine un BART sur flr binaire, puis publie des sorties continues de hindcast par cellule et periode. Le loader utilise flyrs et les six predicteurs climatiques de changement fournis dans l'archive, ce qui cree une version continue documentee sans transformer arbitrairement flr.

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
- N observations: 11133
- k variables: 13
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-118.6666666, -112.7916662], y [33.7916662, 38.0833332]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32611 (UTM Zone 11N (EPSG:32611)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`joshua_tree_flowering` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `joshua_tree_flowering` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`joshua_tree_flowering` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Reconstructing 120 years of climate change impacts on Joshua tree flowering

