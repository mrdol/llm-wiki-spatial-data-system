---
title: paper_dougfir_sdm
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_dougfir_sdm.rds
  - DatasetFirst_10_5061_dryad_737gk
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Cross‐validation strategies for data with temporal, spatial, hierarchical, or phylogenetic structure" (DOI 10.1111/ecog.02881).

## Description du jeu de donnees

- Topic: ecologie / modelisation de distribution d'espece (SDM)
- Observation unit: point d'occurrence/pseudo-absence
- Observed population: sapin de Douglas (Pseudotsuga menziesii), Amerique du Nord, N=53293 points
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: Cross‐validation strategies for data with temporal, spatial, hierarchical, or phylogenetic structure
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/ecog.02881
- Dataset DOI: 10.5061/dryad.737gk
- Source URL: https://doi.org/10.5061/dryad.737gk
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_737gk/`
- Local sf output: `data/final_datasets/sf/paper_dougfir_sdm.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `PRES`
- Candidate Y typology: binary
- Candidate X variables in local artifact: `Elev`, `MWMT`, `MCMT`, `PPT_sm`, `MDMP`, `DD5`, `AHM`, `PC1`, `PC2`, `PC3`, `PC4`, `PC5`, `PC6`
- Candidate X count in local artifact: 13
- Candidate X typology: continuous
- Published X variables from paper: PC1-PC6 (composantes principales des variables climatiques MWMT, MCMT, PPT_sm, MDMP, DD5, AHM, Elev)
- Published X count: 1
- Coordinates (x, y - excluded from X candidates): `Long`, `Lat`
- Identifier columns (excluded from X candidates): `ID`, `X`, `x`, `y`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PRES` | `integer` | binary | {0, 1} | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `dougfir_sdm`, la ou les reponses `PRES` viennent du loader papier et/ou des preuves de l article `Cross‐validation strategies for data with temporal, spatial, hierarchical, or phylogenetic structure`. Les covariables X retenues sont `PC1`, `PC2`, `PC3`, `PC4`, `PC5`, `PC6` ; 7 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Long`, `Lat`), identifiants (`ID`, `X`, `x`, `y`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Elev` | `integer` | continuous | 0% |
| `MWMT` | `numeric` | continuous | 0% |
| `MCMT` | `numeric` | continuous | 0% |
| `PPT_sm` | `numeric` | continuous | 0% |
| `MDMP` | `numeric` | continuous | 0% |
| `DD5` | `numeric` | continuous | 0% |
| `AHM` | `numeric` | continuous | 0% |
| `PC1` | `numeric` | continuous | 0% |
| `PC2` | `numeric` | continuous | 0% |
| `PC3` | `numeric` | continuous | 0% |
| `PC4` | `numeric` | continuous | 0% |
| `PC5` | `numeric` | continuous | 0% |
| `PC6` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: PRES ~ PC1 + PC2 + PC3 + PC4 + PC5 + PC6 [modele de distribution d'espece (SDM) : GLM binomial stepwise (lineaire et quadratique) et Random Forest sur les composantes principales climatiques, compares sous differentes strategies de validation croisee (aleatoire, par blocs spatiaux, par blocs environnementaux)]
- x_terms_pub: PC1-PC6 (composantes principales des variables climatiques MWMT, MCMT, PPT_sm, MDMP, DD5, AHM, Elev)
- y_term_pub: PRES (presence/absence du sapin de Douglas, Pseudotsuga menziesii, Amerique du Nord)
- Reference publication: Roberts et al. (2017), Cross-validation strategies for data with temporal, spatial, hierarchical, or phylogenetic structure, Ecography, doi:10.1111/ecog.02881. Box 4 de l'article decrit une etude de cas de modelisation de distribution d'espece (Douglas-fir) pour comparer blocage aleatoire, spatial et environnemental en validation croisee. Script fourni (Appendix_6_Box_4_CODE_Environmental_blocking.R) confirme modvars <- paste0('PC',1:6) et lin.modform <- PRES ~ modvars, ajuste par GLM binomial stepwise (lineaire/quadratique) et randomForest. Donnees brutes (Appendix_6_Box_4_DATA_NorthAmerica_DougFir.RData) telechargees directement depuis Dryad (10.5061/dryad.737gk) -- pas une reconstruction, N=53293, PRES binaire (34692 absences / 18601 presences), Lat/Long reels couvrant l'Amerique du Nord.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: PRES ~ PC1 + PC2 + PC3 + PC4 + PC5 + PC6
- x_terms_used: PC1, PC2, PC3, PC4, PC5, PC6
- y_term_used: PRES
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "PRES ~ PC1 + PC2 + PC3 + PC4 + PC5 + PC6"
    response: "PRES (presence/absence du sapin de Douglas, Pseudotsuga menziesii, Amerique du Nord)"
    predictors: ["PC1-PC6 (composantes principales des variables climatiques MWMT, MCMT, PPT_sm, MDMP, DD5, AHM, Elev)"]
    role: "simple_baseline"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "spatial_baseline"]
    status: "confirmed"

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
    formula: "PRES ~ PC1 + PC2 + PC3 + PC4 + PC5 + PC6"
    response: "PRES"
    predictors: ["PC1", "PC2", "PC3", "PC4", "PC5", "PC6"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["glm_logistic", "random_forest", "random_forest_xy", "xgboost", "gwr"]
    status: "executable_binary_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_dougfir_sdm`
- Dataset name: Data from: Cross-validation strategies for data with temporal, spatial, hierarchical, or phylogenetic structure
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Cross‐validation strategies for data with temporal, spatial, hierarchical, or phylogenetic structure
- Paper DOI: 10.1111/ecog.02881
- Dataset DOI: 10.5061/dryad.737gk
- Source URL: https://doi.org/10.5061/dryad.737gk
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "PRES ~ PC1 + PC2 + PC3 + PC4 + PC5 + PC6 [modele de distribution d'espece (SDM) : GLM binomial stepwise (lineaire et quadratique) et Random Forest sur les composantes principales climatiques, compares sous differentes strategies de validation croisee (aleatoire, par blocs spatiaux, par blocs environnementaux)]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Roberts et al. (2017), Cross-validation strategies for data with temporal, spatial, hierarchical, or phylogenetic structure, Ecography, doi:10.1111/ecog.02881. Box 4 de l'article decrit une etude de cas de modelisation de distribution d'espece (Douglas-fir) pour comparer blocage aleatoire, spatial et environnemental en validation croisee. Script fourni (Appendix_6_Box_4_CODE_Environmental_blocking.R) confirme modvars <- paste0('PC',1:6) et lin.modform <- PRES ~ modvars, ajuste par GLM binomial stepwise (lineaire/quadratique) et randomForest. Donnees brutes (Appendix_6_Box_4_DATA_NorthAmerica_DougFir.RData) telechargees directement depuis Dryad (10.5061/dryad.737gk) -- pas une reconstruction, N=53293, PRES binaire (34692 absences / 18601 presences), Lat/Long reels couvrant l'Amerique du Nord."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "classification_binary_presence_absence_sdm"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun -- RData original telecharge directement depuis Dryad, N=53293 identique au depot source"
  reason: "PRES binaire reel (presence/absence Douglas-fir), N=53293 avec coordonnees reelles (Amerique du Nord), covariables climatiques PC1-PC6 exactement celles du script de replication de l'article (Box 4, modvars <- paste0('PC',1:6)). RData original telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) et script R de replication inspecte pour confirmer la formule exacte (GLM binomial stepwise + Random Forest)."
```

- Decision: ready
- Manque principal: aucun -- RData original telecharge directement depuis Dryad, N=53293 identique au depot source
- Raison: PRES binaire reel (presence/absence Douglas-fir), N=53293 avec coordonnees reelles (Amerique du Nord), covariables climatiques PC1-PC6 exactement celles du script de replication de l'article (Box 4, modvars <- paste0('PC',1:6)). RData original telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) et script R de replication inspecte pour confirmer la formule exacte (GLM binomial stepwise + Random Forest).

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready"
  eligible_estimators: []
  conditionally_eligible_estimators: ["random_forest", "random_forest_xy", "gamboost", "xgboost", "xgboost_xy", "gam_spatial"]
  ineligible_reason: "reponse binaire (presence/absence) ; le registre benchmark du package (13-benchmark-spatial.R) code en dur mode='regression' pour tous les estimateurs automatiques -- aucun ne supporte de mode classification/binomial aujourd'hui. random_forest/gamboost/xgboost sont notes conditionnels car ce sont les estimateurs que le papier source a reellement utilises (RF/BRT) ; ols/sar_lag/sem_error/sdm_mixed/gwr restent hors de propos pour une reponse binaire (hypothese gaussienne continue) et ne sont pas listes."
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 53293
- k variables: 21
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-171.8, -95], y [15.7, 79.88]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=76.8deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`dougfir_sdm` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `dougfir_sdm` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`dougfir_sdm` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Cross‐validation strategies for data with temporal, spatial, hierarchical, or phylogenetic structure

