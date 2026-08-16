---
title: paper_bean_landrace_gap_sdm
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_bean_landrace_gap_sdm.rds
  - DataCite_2020_AGapAnalysisModelling_10_1111_ddi_1304
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "A gap analysis modelling framework to prioritize collecting for ex situ conservation of crop landraces" (DOI 10.1111/ddi.13046).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale du dataset "A gap analysis modeling framework to prioritize collecting for ex situ conservation of crop landraces"
- Observed population: ModÃ©lisation de distribution spatiale de variÃ©tÃ©s traditionnelles de haricot commun ; gap analysis avec prÃ©dicteurs environnementaux et socioÃ©conomiques ; domaine agriculture/conservation ex situ ; 35 citations
- Geographic context: etendue sf: x [-117.033, -34.9], y [-38.45, 32.616667]
- Temporal context: none (cross-sectional)
- Source description: A gap analysis modelling framework to prioritize collecting for ex situ conservation of crop landraces
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/ddi.13046
- Dataset DOI: 10.5061/dryad.866t1g1n0
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.866t1g1n0
- Local raw dir: `data/raw/papers/DataCite_2020_AGapAnalysisModelling_10_1111_ddi_1304/`
- Local sf output: `data/final_datasets/sf/paper_bean_landrace_gap_sdm.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `status_H_01`
- Candidate Y typology: binary
- Candidate X variables in local artifact: `bio_1`, `bio_2`, `bio_3`, `bio_4`, `bio_5`, `bio_6`, `bio_7`, `bio_8`, `bio_9`, `bio_10`, `bio_11`, `bio_12`, `bio_13`, `bio_14`, `bio_15`, `bio_16`, `bio_17`, `bio_18`, `bio_19`, `srad`, `wspd`, `wvap`, `alt`, `PETa`, `thorn`, `moist`, `conti`, `ember`, `gdd0`, `gdd5`, `t10`, `tminwq`, `tmaxcq`, `PETcq`, `PETdq`, `PETs`, `PETwaq`, `PETweq`, `therm`, `drym`, `urban`, `distgp1`, `popdens`, `rivers`, `irri`, `access`, `aharv`, `prod`, `yield`, `genepool_andean_01`
- Candidate X count in local artifact: 50
- Candidate X typology: continuous, categorical
- Published X variables from paper: WorldClim bioclimatic variables, solar radiation, wind speed, water vapor pressure, altitude, potential evapotranspiration, population density, accessibility, distance to genepool, rivers, irrigation, harvested area, production, yield
- Published X count: 14
- Coordinates (x, y - excluded from X candidates): `longitude`, `latitude`
- Identifier columns (excluded from X candidates): `source`, `status`, `genepool`, `ethnic`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `status_H_01` | `integer` | binary | {0, 1} | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `bean_landrace_gap_sdm`, la ou les reponses `status_H_01` viennent du loader papier et/ou des preuves de l article `A gap analysis modelling framework to prioritize collecting for ex situ conservation of crop landraces`. Les covariables X retenues sont `bio_1`, `bio_12`, `alt`, `PETa`, `popdens`, `access`, `distgp1`, `rivers`, `irri`, `aharv`, `prod`, `yield` ; 38 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`longitude`, `latitude`), identifiants (`source`, `status`, `genepool`, `ethnic`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `bio_1` | `numeric` | continuous | 0% |
| `bio_2` | `numeric` | continuous | 0% |
| `bio_3` | `numeric` | continuous | 0% |
| `bio_4` | `numeric` | continuous | 0% |
| `bio_5` | `numeric` | continuous | 0% |
| `bio_6` | `numeric` | continuous | 0% |
| `bio_7` | `numeric` | continuous | 0% |
| `bio_8` | `numeric` | continuous | 0% |
| `bio_9` | `numeric` | continuous | 0% |
| `bio_10` | `numeric` | continuous | 0% |
| `bio_11` | `numeric` | continuous | 0% |
| `bio_12` | `numeric` | continuous | 0% |
| `bio_13` | `numeric` | continuous | 0% |
| `bio_14` | `numeric` | continuous | 0% |
| `bio_15` | `numeric` | continuous | 0% |
| `bio_16` | `numeric` | continuous | 0% |
| `bio_17` | `numeric` | continuous | 0% |
| `bio_18` | `numeric` | continuous | 0% |
| `bio_19` | `numeric` | continuous | 0% |
| `srad` | `numeric` | continuous | 0% |
| `wspd` | `numeric` | continuous | 0% |
| `wvap` | `numeric` | continuous | 0% |
| `alt` | `numeric` | continuous | 0% |
| `PETa` | `numeric` | continuous | 0% |
| `thorn` | `numeric` | continuous | 0% |
| `moist` | `numeric` | continuous | 0% |
| `conti` | `numeric` | continuous | 0% |
| `ember` | `numeric` | continuous | 0% |
| `gdd0` | `numeric` | continuous | 0% |
| `gdd5` | `numeric` | continuous | 0% |
| `t10` | `numeric` | continuous | 0% |
| `tminwq` | `numeric` | continuous | 0% |
| `tmaxcq` | `numeric` | continuous | 0% |
| `PETcq` | `numeric` | continuous | 0% |
| `PETdq` | `numeric` | continuous | 0% |
| `PETs` | `numeric` | continuous | 0% |
| `PETwaq` | `numeric` | continuous | 0% |
| `PETweq` | `numeric` | continuous | 0% |
| `therm` | `numeric` | continuous | 0% |
| `drym` | `numeric` | continuous | 0% |
| `urban` | `numeric` | continuous | 0% |
| `distgp1` | `numeric` | continuous | 0% |
| `popdens` | `numeric` | continuous | 0% |
| `rivers` | `numeric` | continuous | 0% |
| `irri` | `numeric` | continuous | 0% |
| `access` | `numeric` | continuous | 0% |
| `aharv` | `numeric` | continuous | 0% |
| `prod` | `numeric` | continuous | 0% |
| `yield` | `numeric` | continuous | 0% |
| `genepool_andean_01` | `integer` | binary | 0% |

### Formule - niveau publication

- formula_pub: landrace occurrence / conservation-gap status ~ climatic + accessibility + agricultural + demographic predictors [MaxEnt gap analysis]
- x_terms_pub: WorldClim bioclimatic variables, solar radiation, wind speed, water vapor pressure, altitude, potential evapotranspiration, population density, accessibility, distance to genepool, rivers, irrigation, harvested area, production, yield
- y_term_pub: bean landrace conservation-gap / status class
- Reference publication: Khoury et al. (2020), Diversity and Distributions, DOI 10.1111/ddi.13046; Dryad 10.5061/dryad.866t1g1n0. The local Excel sheet bean_predicted_bd_americas contains coordinates, status/genepool classes and climate/accessibility/agricultural covariates used for the gap-analysis modelling framework. formula_used is an executable binary SDM/classification benchmark variant; it is not a continuous-regression formula.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Khoury et al. (2020), Diversity and Distributions, DOI 10.1111/ddi.13046; Dryad 10.5061/dryad.866t1g1n0. The local Excel sheet bean_predicted_bd_americas contains coordinates, status/genepool classes and climate/accessibility/agricultural covariates used for the gap-analysis modelling framework. formula_used is an executable binary SDM/classification benchmark variant; it is not a continuous-regression formula.

### Formule - niveau systeme

- formula_used: status_H_01 ~ bio_1 + bio_12 + alt + PETa + popdens + access + distgp1 + rivers + irri + aharv + prod + yield
- x_terms_used: bio_1, bio_12, alt, PETa, popdens, access, distgp1, rivers, irri, aharv, prod, yield
- y_term_used: status_H_01
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Khoury et al. (2020), Diversity and Distributions, DOI 10.1111/ddi.13046; Dryad 10.5061/dryad.866t1g1n0. The local Excel sheet bean_predicted_bd_americas contains coordinates, status/genepool classes and climate/accessibility/agricultural covariates used for the gap-analysis modelling framework. formula_used is an executable binary SDM/classification benchmark variant; it is not a continuous-regression formula.

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
    formula: "status_H_01 ~ selected climate, accessibility and agricultural predictors"
    response: "bean landrace conservation-gap / status class"
    predictors: ["WorldClim bioclimatic variables", "solar radiation", "wind speed", "water vapor pressure", "altitude", "potential evapotranspiration", "population density", "accessibility", "distance to genepool", "rivers", "irrigation", "harvested area", "production", "yield"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Khoury et al. (2020), Diversity and Distributions, DOI 10.1111/ddi.13046; Dryad 10.5061/dryad.866t1g1n0. The local Excel sheet bean_predicted_bd_americas contains coordinates, status/genepool classes and climate/accessibility/agricultural covariates used for the gap-analysis modelling framework. formula_used is an executable binary SDM/classification benchmark variant; it is not a continuous-regression formula."
    estimator_context: ["random_forest", "gamboost", "xgboost"]
    status: "confirmed"

  ml_or_selected:
    formula: "status_H_01 ~ climate + accessibility + agricultural predictors"
    response: "status_H_01"
    predictors: ["bio_1", "bio_12", "alt", "PETa", "popdens", "access", "distgp1", "rivers", "irri", "aharv", "prod", "yield"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Khoury et al. (2020), Diversity and Distributions, DOI 10.1111/ddi.13046; Dryad 10.5061/dryad.866t1g1n0. The local Excel sheet bean_predicted_bd_americas contains coordinates, status/genepool classes and climate/accessibility/agricultural covariates used for the gap-analysis modelling framework. formula_used is an executable binary SDM/classification benchmark variant; it is not a continuous-regression formula."
    estimator_context: ["random_forest", "xgboost", "gamboost"]
    status: "executable_binary_sdm_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_bean_landrace_gap_sdm`
- Dataset name: A gap analysis modeling framework to prioritize collecting for ex situ conservation of crop landraces
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: A gap analysis modelling framework to prioritize collecting for ex situ conservation of crop landraces
- Paper DOI: 10.1111/ddi.13046
- Dataset DOI: 10.5061/dryad.866t1g1n0
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.866t1g1n0
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "landrace occurrence / conservation-gap status ~ climatic + accessibility + agricultural + demographic predictors [MaxEnt gap analysis]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Khoury et al. (2020), Diversity and Distributions, DOI 10.1111/ddi.13046; Dryad 10.5061/dryad.866t1g1n0. The local Excel sheet bean_predicted_bd_americas contains coordinates, status/genepool classes and climate/accessibility/agricultural covariates used for the gap-analysis modelling framework. formula_used is an executable binary SDM/classification benchmark variant; it is not a continuous-regression formula."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "classification_binary_sdm"
  package_include: "yes"
  has_local_rds: true
  missing_items: "reponse binaire status_H_01 ; hors cahier de regression continue stricte, mais conserve comme cas SDM/classification documente dans le package"
  reason: "Le fichier Excel Dryad contient coordonnees, statut/genepool et covariables climatiques, d'accessibilite et agricoles. Le loader produit une version sf executable pour benchmark SDM/classification, en documentant que formula_used est une variante binaire locale."
```

- Decision: ready
- Manque principal: reponse binaire status_H_01 ; hors cahier de regression continue stricte, mais conserve comme cas SDM/classification documente dans le package
- Raison: Le fichier Excel Dryad contient coordonnees, statut/genepool et covariables climatiques, d'accessibilite et agricoles. Le loader produit une version sf executable pour benchmark SDM/classification, en documentant que formula_used est une variante binaire locale.

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
- N observations: 21543
- k variables: 59
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-117.033, -34.9], y [-38.45, 32.616667]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=82.1deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`bean_landrace_gap_sdm` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `bean_landrace_gap_sdm` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`bean_landrace_gap_sdm` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: A gap analysis modelling framework to prioritize collecting for ex situ conservation of crop landraces

