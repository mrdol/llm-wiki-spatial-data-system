---
title: paper_midwest_crop_yield
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_midwest_crop_yield.rds
  - DataCite_2022_CropYieldPredictionUsing_10_1080_01621459
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Crop Yield Prediction Using Bayesian Spatially Varying Coefficient Models with Functional Predictors" (DOI 10.1080/01621459.2022.2123333).

## Description du jeu de donnees

- Topic: dataset spatial spatio-temporel
- Observation unit: observation spatiale du dataset "Crop Yield Prediction Using Bayesian Spatially Varying Coefficient Models with Functional Predictors"
- Observed population: ModÃ¨le bayÃ©sien Ã  coefficients spatialement variables pour prÃ©diction de rendement agricole (corn yield) dans 5 Ã©tats du Midwest USA
- Geographic context: etendue sf: x [-101.806263355221, -84.9366590770885], y [36.21377415, 43.3840075]
- Temporal context: 22 distinct periods (variable: Year)
- Source description: Crop Yield Prediction Using Bayesian Spatially Varying Coefficient Models with Functional Predictors
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1080/01621459.2022.2123333
- Dataset DOI: 10.6084/m9.figshare.21082235
- Source URL: https://tandf.figshare.com/articles/dataset/Crop_Yield_Prediction_Using_Bayesian_Spatially_Varying_Coefficient_Models_with_Functional_Predictors/21082235
- Local raw dir: `data/raw/papers/DataCite_2022_CropYieldPredictionUsing_10_1080_01621459/`
- Local sf output: `data/final_datasets/sf/paper_midwest_crop_yield.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Yield`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `STUSPS`, `county_key`, `Year`, `avgPRCP`, `Area`
- Candidate X count in local artifact: 5
- Candidate X typology: categorical, continuous
- Published X variables from paper: avgPRCP
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `State`, `County`, `CountyI`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Yield` | `numeric` | continuous | [18, 246.7] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `midwest_crop_yield`, la ou les reponses `Yield` viennent du loader papier et/ou des preuves de l article `Crop Yield Prediction Using Bayesian Spatially Varying Coefficient Models with Functional Predictors`. Les covariables X retenues sont `avgPRCP` ; 4 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (`State`, `County`, `CountyI`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `STUSPS` | `character` | categorical | 0% |
| `county_key` | `character` | categorical | 0% |
| `Year` | `integer` | count | 0% |
| `avgPRCP` | `numeric` | continuous | 0% |
| `Area` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: Yield ~ avgPRCP [Z(s) scalaire du modele Eq.1-2 p.3-4 ; Area = omega(s) sert de poids de variance heteroscedastique e(s)~N(0, sigma2/omega(s)), pas de covariable de la moyenne]
- x_terms_pub: avgPRCP
- y_term_pub: Yield
- Reference publication: Park, Li & Li (2022), JASA, DOI 10.1080/01621459.2022.2123333, section 2 p.3 et Eq. (1) p.3-4: le seul covariable scalaire Z(s) du modele est la precipitation annuelle (avgPRCP) ; la taille de terre recoltee (Area, notee omega(s)) est explicitement utilisee comme poids de la variance de l'erreur de sondage (e(s) ~ N(0, sigma_e^2/omega(s))), pas comme predicteur de la moyenne. Le vrai pouvoir predictif du papier vient de trajectoires fonctionnelles de temperature (FPCA), non reproduites localement. MidwestData.RData (supplement JASA) fournit regdat avec Year, State, County (noms complets), Yield et avgPRCP ; jointure verifiee a 98.9% vers tigris::counties().

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: Yield ~ avgPRCP
- x_terms_used: avgPRCP
- y_term_used: Yield
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "Yield ~ avgPRCP"
    response: "Yield"
    predictors: ["avgPRCP"]
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
    formula: "Yield ~ avgPRCP + Area"
    response: "Yield"
    predictors: ["avgPRCP", "Area"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "Area est ajoute ici uniquement comme feature ML exploratoire supplementaire disponible localement ; le papier ne le traite pas comme une covariable de la moyenne (voir source_ref principal)."
    estimator_context: ["random_forest", "xgboost", "gamboost"]
    status: "generated"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_midwest_crop_yield`
- Dataset name: Crop Yield Prediction Using Bayesian Spatially Varying Coefficient Models with Functional Predictors
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Crop Yield Prediction Using Bayesian Spatially Varying Coefficient Models with Functional Predictors
- Paper DOI: 10.1080/01621459.2022.2123333
- Dataset DOI: 10.6084/m9.figshare.21082235
- Source URL: https://tandf.figshare.com/articles/dataset/Crop_Yield_Prediction_Using_Bayesian_Spatially_Varying_Coefficient_Models_with_Functional_Predictors/21082235
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Yield ~ avgPRCP [Z(s) scalaire du modele Eq.1-2 p.3-4 ; Area = omega(s) sert de poids de variance heteroscedastique e(s)~N(0, sigma2/omega(s)), pas de covariable de la moyenne]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Park, Li & Li (2022), JASA, DOI 10.1080/01621459.2022.2123333, section 2 p.3 et Eq. (1) p.3-4: le seul covariable scalaire Z(s) du modele est la precipitation annuelle (avgPRCP) ; la taille de terre recoltee (Area, notee omega(s)) est explicitement utilisee comme poids de la variance de l'erreur de sondage (e(s) ~ N(0, sigma_e^2/omega(s))), pas comme predicteur de la moyenne. Le vrai pouvoir predictif du papier vient de trajectoires fonctionnelles de temperature (FPCA), non reproduites localement. MidwestData.RData (supplement JASA) fournit regdat avec Year, State, County (noms complets), Yield et avgPRCP ; jointure verifiee a 98.9% vers tigris::counties()."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "une seule covariable numerique locale (avgPRCP, le seul Z(s) scalaire reel du papier) ; les predicteurs fonctionnels/spline (trajectoires de temperature FPCA) ne sont pas reproduits localement"
  reason: "Yield continu, jointure comte verifiee a 98.9% (tigris), formula_used = formule exacte du papier (le seul covariable scalaire reel, Area est un poids de variance non un predicteur). Y continu, X defendable (correspond exactement au papier), artefact local utilisable -- promu sans revue manuelle (2026-08-12)."
```

- Decision: ready
- Manque principal: une seule covariable numerique locale (avgPRCP, le seul Z(s) scalaire reel du papier) ; les predicteurs fonctionnels/spline (trajectoires de temperature FPCA) ne sont pas reproduits localement
- Raison: Yield continu, jointure comte verifiee a 98.9% (tigris), formula_used = formule exacte du papier (le seul covariable scalaire reel, Area est un poids de variance non un predicteur). Y continu, X defendable (correspond exactement au papier), artefact local utilisable -- promu sans revue manuelle (2026-08-12).

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
- N observations: 6359
- k variables: 12
- T periods: 22
- Variable temporelle: Year
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (6359) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 404 ; panel NON EQUILIBRE (T par unite : min=6, mediane=17, max=22). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 404 unites spatiales distinctes, pas sur les 6359 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 22 distinct periods (variable: Year)
- CRS EPSG: 4269
- CRS nom: NAD83
- Spatial extent: x [-101.806263355221, -84.9366590770885], y [36.21377415, 43.3840075]
- Time range: 1999 to 2020 (variable: Year)
- CRS analyse recommande: 32615 (UTM Zone 15N (EPSG:32615)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`midwest_crop_yield` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `midwest_crop_yield` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4269).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`midwest_crop_yield` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Crop Yield Prediction Using Bayesian Spatially Varying Coefficient Models with Functional Predictors

