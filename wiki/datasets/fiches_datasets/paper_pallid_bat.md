---
title: paper_pallid_bat
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_pallid_bat.rds
  - DataCite_2018_PrimaryProductivityExplainsSize_10_1111_1365_243
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Primary productivity explains size variation across the Pallid bat's western geographic range" (DOI 10.1111/1365-2435.13092).

## Description du jeu de donnees

- Topic: morphometrie et biogeographie animale
- Observation unit: specimen museal individuel
- Observed population: specimens de musee d'histoire naturelle geo-references via GBIF
- Geographic context: etendue sf: x [-124.2623, -109.618423], y [23.5525, 48.052082]
- Temporal context: none (cross-sectional)
- Source description: Primary productivity explains size variation across the Pallid bat's western geographic range
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/1365-2435.13092
- Dataset DOI: 10.5061/dryad.c5805
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.c5805
- Local raw dir: `data/raw/papers/DataCite_2018_PrimaryProductivityExplainsSize_10_1111_1365_243/`
- Local sf output: `data/final_datasets/sf/paper_pallid_bat.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `centroid_size`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `NPP`, `MinWinTemp`, `MaxSumTemp`, `TempSeas`, `PrecSeas`
- Candidate X count in local artifact: 5
- Candidate X typology: continuous
- Published X variables from paper: NPP, MinWinTemp, MaxSumTemp, TempSeas, PrecSeas
- Published X count: 5
- Coordinates (x, y - excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): `institution`, `catalog_number`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `centroid_size` | `numeric` | continuous | [902.6937, 1171.3787] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `pallid_bat`, la ou les reponses `centroid_size` viennent du loader papier et/ou des preuves de l article `Primary productivity explains size variation across the Pallid bat's western geographic range`. Les covariables X retenues sont `NPP`, `MinWinTemp`, `TempSeas` ; 2 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`lon`, `lat`), identifiants (`institution`, `catalog_number`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `NPP` | `numeric` | continuous | 0% |
| `MinWinTemp` | `numeric` | continuous | 0% |
| `MaxSumTemp` | `numeric` | continuous | 0% |
| `TempSeas` | `numeric` | continuous | 0% |
| `PrecSeas` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: body_size ~ NPP + MinWinTemp + TempSeas [top SAR error model]
- x_terms_pub: NPP, MinWinTemp, MaxSumTemp, TempSeas, PrecSeas
- y_term_pub: cranium centroid size / body size proxy
- Reference publication: Kelly, Friedman & Santana (2018), Functional Ecology, DOI 10.1111/1365-2435.13092: Sections 2.2-2.3 and Tables 1-2 use NPP, minimum winter temperature, maximum summer temperature and temperature/precipitation seasonality to explain Pallid bat cranium centroid size with OLS and SAR error models. The local loader extracts the matching Dryad rasters NPP, bio4, bio5, bio6 and bio15 at specimen localities. formula_used uses centroid_size derived from TPS landmarks as the local executable body-size proxy.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: centroid_size ~ NPP + MinWinTemp + TempSeas
- x_terms_used: NPP, MinWinTemp, TempSeas
- y_term_used: centroid_size
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
    formula: "centroid_size ~ NPP + MinWinTemp + TempSeas"
    response: "cranium centroid size / body size proxy"
    predictors: ["NPP", "MinWinTemp", "MaxSumTemp", "TempSeas", "PrecSeas"]
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

- Dataset ID: `paper_pallid_bat`
- Dataset name: Data from: Primary productivity explains size variation across the Pallid bat's (Antrozous pallidus) western geographic range
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Primary productivity explains size variation across the Pallid bat's western geographic range
- Paper DOI: 10.1111/1365-2435.13092
- Dataset DOI: 10.5061/dryad.c5805
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.c5805
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "body_size ~ NPP + MinWinTemp + TempSeas [top SAR error model]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Kelly, Friedman & Santana (2018), Functional Ecology, DOI 10.1111/1365-2435.13092: Sections 2.2-2.3 and Tables 1-2 use NPP, minimum winter temperature, maximum summer temperature and temperature/precipitation seasonality to explain Pallid bat cranium centroid size with OLS and SAR error models. The local loader extracts the matching Dryad rasters NPP, bio4, bio5, bio6 and bio15 at specimen localities. formula_used uses centroid_size derived from TPS landmarks as the local executable body-size proxy."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous_spatial_sar"
  package_include: "yes"
  has_local_rds: true
  missing_items: "centroid_size est un proxy cranien de taille corporelle derive des landmarks TPS; le papier privilegie les resultats ventraux mais indique que les resultats lateraux sont quasi identiques"
  reason: "Le papier definit centroid size comme proxy de body size, selectionne des modeles OLS/SARerr, et le top SARerr inclut NPP, MinWinTemp et TempSeas. Ces variables sont jointes localement et la formule est executable."
```

- Decision: ready
- Manque principal: centroid_size est un proxy cranien de taille corporelle derive des landmarks TPS; le papier privilegie les resultats ventraux mais indique que les resultats lateraux sont quasi identiques
- Raison: Le papier definit centroid size comme proxy de body size, selectionne des modeles OLS/SARerr, et le top SARerr inclut NPP, MinWinTemp et TempSeas. Ces variables sont jointes localement et la formule est executable.

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
- N observations: 182
- k variables: 12
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-124.2623, -109.618423], y [23.5525, 48.052082]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32611 (UTM Zone 11N (EPSG:32611)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.c5805 (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`pallid_bat` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `pallid_bat` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`pallid_bat` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Primary productivity explains size variation across the Pallid bat's western geographic range

