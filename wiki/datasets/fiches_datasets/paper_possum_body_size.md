---
title: paper_possum_body_size
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_possum_body_size.rds
  - DataCite_2015_LeanSeasonPrimaryProductivity_10_1111_ecog_012
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Lean-season primary productivity and heat dissipation as key drivers of geographic body-size variation in a widespread marsupial" (DOI 10.1111/ecog.01243).

## Description du jeu de donnees

- Topic: dataset spatial spatio-temporel
- Observation unit: observation spatiale du dataset "Data from: Lean-season primary productivity and heat dissipation as key drivers of geographic body-size variation in a widespread marsupial"
- Observed population: ModÃ¨le SAR (simultaneous autoregressive) pour variation gÃ©ographique de taille corporelle; domaine Ã©cologie/biogÃ©ographie; mÃ©thode SAR explicite; dataset empirique marsupial australien avec coordonnÃ©es et covariables environnementales
- Geographic context: etendue sf: x [114.8, 153.3], y [-43.15, -11.1]
- Temporal context: 335 distinct periods (variable: Date)
- Source description: Lean-season primary productivity and heat dissipation as key drivers of geographic body-size variation in a widespread marsupial
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/ecog.01243
- Dataset DOI: 10.5061/dryad.gq264
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.gq264
- Local raw dir: `data/raw/papers/DataCite_2015_LeanSeasonPrimaryProductivity_10_1111_ecog_012/`
- Local sf output: `data/final_datasets/sf/paper_possum_body_size.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `CBL`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Date`, `Island_type`, `WinterMinTemp`, `AnnualMinTemp`, `SummerWetBulbTemp`, `AnnualWetBulbTemp`, `SummerMaxTemp`, `AnnualMaxTemp`, `AnnualRain`, `P.PET`, `aaET`, `NDVI`, `CenW`, `GrowSeasRain`, `GrowSeasaaET`, `GrowSeasP.PET`, `GrowSeasNDVI`, `CVSeasRain`, `CVSeasaaET`, `CVSeasP.PET`, `CVSeasMaxTemp`, `CVSeasMinTemp`, `MinSeasRain`, `MinSeasaaET`, `MinSeasP.PET`, `MinSeasNDVI`, `Soil_nutrient_availability`, `Clay_content_0_30cm`, `Soil_bulk_density_0_30cm`
- Candidate X count in local artifact: 29
- Candidate X typology: categorical, continuous
- Published X variables from paper: SummerMaxTemp, MinSeasP.PET, Island_type
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): `Longitude`, `Latitude`
- Identifier columns (excluded from X candidates): `Collection`, `Registration_number`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `CBL` | `numeric` | continuous | [61.61, 99.49] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `possum_body_size`, la ou les reponses `CBL` viennent du loader papier et/ou des preuves de l article `Lean-season primary productivity and heat dissipation as key drivers of geographic body-size variation in a widespread marsupial`. Les covariables X retenues sont `SummerMaxTemp`, `MinSeasP.PET`, `Island_type` ; 26 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Longitude`, `Latitude`), identifiants (`Collection`, `Registration_number`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Date` | `character` | categorical | 19% |
| `Island_type` | `character` | categorical | 0% |
| `WinterMinTemp` | `numeric` | continuous | 0% |
| `AnnualMinTemp` | `numeric` | continuous | 0% |
| `SummerWetBulbTemp` | `numeric` | continuous | 0% |
| `AnnualWetBulbTemp` | `numeric` | continuous | 0% |
| `SummerMaxTemp` | `numeric` | continuous | 0% |
| `AnnualMaxTemp` | `numeric` | continuous | 0% |
| `AnnualRain` | `numeric` | continuous | 0% |
| `P.PET` | `numeric` | continuous | 0% |
| `aaET` | `numeric` | continuous | 0% |
| `NDVI` | `numeric` | continuous | 0% |
| `CenW` | `numeric` | continuous | 0% |
| `GrowSeasRain` | `numeric` | continuous | 0% |
| `GrowSeasaaET` | `numeric` | continuous | 0% |
| `GrowSeasP.PET` | `numeric` | continuous | 0% |
| `GrowSeasNDVI` | `numeric` | rate | 0% |
| `CVSeasRain` | `numeric` | continuous | 0% |
| `CVSeasaaET` | `numeric` | continuous | 0% |
| `CVSeasP.PET` | `numeric` | continuous | 0% |
| `CVSeasMaxTemp` | `numeric` | rate | 0% |
| `CVSeasMinTemp` | `numeric` | continuous | 0% |
| `MinSeasRain` | `numeric` | continuous | 0% |
| `MinSeasaaET` | `numeric` | continuous | 0% |
| `MinSeasP.PET` | `numeric` | continuous | 0% |
| `MinSeasNDVI` | `numeric` | continuous | 0% |
| `Soil_nutrient_availability` | `numeric` | continuous | 0% |
| `Clay_content_0_30cm` | `numeric` | continuous | 0% |
| `Soil_bulk_density_0_30cm` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: CBL ~ SummerMaxTemp + MinSeasP.PET + Island_type [selected aspatial and spatial SAR model]
- x_terms_pub: SummerMaxTemp, MinSeasP.PET, Island_type
- y_term_pub: CBL
- Reference publication: Isaac et al. (2015), Ecography, DOI 10.1111/ecog.01204: Table 2 states that the selected aspatial and spatial SAR model for Trichosurus vulpecula condylobasal length (CBL) is CBL ~ SummerMaxTemp + MinSeasP-PET + island effect. The local .rds uses the matching columns SummerMaxTemp, MinSeasP.PET and Island_type.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Isaac et al. (2015), Ecography, DOI 10.1111/ecog.01204: Table 2 states that the selected aspatial and spatial SAR model for Trichosurus vulpecula condylobasal length (CBL) is CBL ~ SummerMaxTemp + MinSeasP-PET + island effect. The local .rds uses the matching columns SummerMaxTemp, MinSeasP.PET and Island_type.

### Formule - niveau systeme

- formula_used: CBL ~ SummerMaxTemp + MinSeasP.PET + Island_type
- x_terms_used: SummerMaxTemp, MinSeasP.PET, Island_type
- y_term_used: CBL
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Isaac et al. (2015), Ecography, DOI 10.1111/ecog.01204: Table 2 states that the selected aspatial and spatial SAR model for Trichosurus vulpecula condylobasal length (CBL) is CBL ~ SummerMaxTemp + MinSeasP-PET + island effect. The local .rds uses the matching columns SummerMaxTemp, MinSeasP.PET and Island_type.

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
    formula: "CBL ~ SummerMaxTemp + MinSeasP.PET + Island_type"
    response: "CBL"
    predictors: ["SummerMaxTemp", "MinSeasP.PET", "Island_type"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Isaac et al. (2015), Ecography, DOI 10.1111/ecog.01204: Table 2 states that the selected aspatial and spatial SAR model for Trichosurus vulpecula condylobasal length (CBL) is CBL ~ SummerMaxTemp + MinSeasP-PET + island effect. The local .rds uses the matching columns SummerMaxTemp, MinSeasP.PET and Island_type."
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

- Dataset ID: `paper_possum_body_size`
- Dataset name: Data from: Lean-season primary productivity and heat dissipation as key drivers of geographic body-size variation in a widespread marsupial
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Lean-season primary productivity and heat dissipation as key drivers of geographic body-size variation in a widespread marsupial
- Paper DOI: 10.1111/ecog.01243
- Dataset DOI: 10.5061/dryad.gq264
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.gq264
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "CBL ~ SummerMaxTemp + MinSeasP.PET + Island_type [selected aspatial and spatial SAR model]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Isaac et al. (2015), Ecography, DOI 10.1111/ecog.01204: Table 2 states that the selected aspatial and spatial SAR model for Trichosurus vulpecula condylobasal length (CBL) is CBL ~ SummerMaxTemp + MinSeasP-PET + island effect. The local .rds uses the matching columns SummerMaxTemp, MinSeasP.PET and Island_type."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous_body_size"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage package; formule_used alignee sur le modele aspatial/spatial SAR selectionne du papier"
  reason: "Y=CBL continu, coordonnees et covariables du modele selectionne sont disponibles; Table 2 du papier confirme la specification."
```

- Decision: ready
- Manque principal: aucun blocage package; formule_used alignee sur le modele aspatial/spatial SAR selectionne du papier
- Raison: Y=CBL continu, coordonnees et covariables du modele selectionne sont disponibles; Table 2 du papier confirme la specification.

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
- N observations: 588
- k variables: 37
- T periods: 335
- Variable temporelle: Date
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (588) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 323 ; panel NON EQUILIBRE (T par unite : min=1, mediane=1, max=23). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 323 unites spatiales distinctes, pas sur les 588 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 335 distinct periods (variable: Date)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [114.8, 153.3], y [-43.15, -11.1]
- Time range: 08/08/1892 to 9/12/1909 (variable: Date)
- CRS analyse recommande: pending - multi-zones (span=38.5deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`possum_body_size` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `possum_body_size` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`possum_body_size` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Lean-season primary productivity and heat dissipation as key drivers of geographic body-size variation in a widespread marsupial

