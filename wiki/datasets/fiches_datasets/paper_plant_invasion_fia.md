---
title: paper_plant_invasion_fia
type: dataset
created: 2026-09-14
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_plant_invasion_fia.rds
  - DataCite_2024_SpatialPredictionOfPlant_10_1002_ece3_116
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Spatial prediction of plant invasion using a hybrid of machine learning and geostatistical method" (DOI 10.1002/ece3.11605).

## Description du jeu de donnees

- Topic: dataset spatial spatio-temporel
- Observation unit: observation spatiale du dataset "Data for: Spatial prediction of plant invasion using a hybrid of machine learning and geostatistical method"
- Observed population: PrÃ©diction spatiale d'invasion de plantes avec hybridation de machine learning (BRT, LASSO) et krigeage ordinaire (OK) ; donnÃ©es d'invasion dans l'est des Ã‰tats-Unis ; correspond exactement au pÃ©rimÃ¨tre spatial prediction / boosting spatial / kriging / machine learning / spatial interpolation
- Geographic context: etendue sf: x [-98.720006, -67.04813], y [24.665524, 49.319755]
- Temporal context: 13 distinct periods (variable: MEASYEAR)
- Source description: Spatial prediction of plant invasion using a hybrid of machine learning and geostatistical method
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1002/ece3.11605
- Dataset DOI: 10.5061/dryad.0rxwdbs8t
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.0rxwdbs8t
- Local raw dir: `data/raw/papers/DataCite_2024_SpatialPredictionOfPlant_10_1002_ece3_116/`
- Local sf output: `data/final_datasets/sf/paper_plant_invasion_fia.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `InvTotalCover`, `InvSpRichness`
- Candidate Y typology: continuous, unknown
- Candidate X variables in local artifact: `PHASE`, `MEASYEAR`, `RS`, `domain`, `division`, `provname`, `prov_ID`, `sectname`, `sect_ID`, `siteclcd_n`, `siteclcd_top`, `InvAP`, `Mean_Annual_Temp`, `annual_Precip`, `Seasonability`, `alt`, `PLT_TPA`, `Tpha`, `RelDen`, `prpfor`, `plt_drybio_adj`, `plt_drybio_ha`, `native_spp`, `PD_all`, `PSV_all`, `PSV_all_var`, `PSR_all`, `PSR_all_var`, `PSE_all`, `PSC_all`, `anmeantemp`, `meandiurnrge`, `isotherm`, `tempseason`, `maxtempwarm`, `mintempcold`, `tempanrge`, `meantempwetq`, `meantempdryq`, `meantempwarm`, `meantempcold`, `precipwetm`, `precipdrym`, `precipseason`, `precipwetqu`, `precipdryqu`, `precipwarmqu`, `precipcoldqu`, `anprecip`, `soilcarbon`, `aridity`
- Candidate X count in local artifact: 51
- Candidate X typology: categorical, unknown, continuous
- Published X variables from paper: Mean_Annual_Temp, annual_Precip, Seasonability, alt, PLT_TPA, Tpha, RelDen, prpfor, plt_drybio_adj, native_spp, PD_all, PSV_all, PSR_all, anmeantemp, anprecip, soilcarbon
- Published X count: 16
- Coordinates (x, y - excluded from X candidates): `LON`, `LAT`
- Identifier columns (excluded from X candidates): `STATEAB`, `FIPS`, `county`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `InvTotalCover` | `numeric` | continuous | [0, 297.7] | 0% |
| `InvSpRichness` | `integer` | unknown | [0, 12] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `plant_invasion_fia`, la ou les reponses `InvTotalCover`, `InvSpRichness` viennent du loader papier et/ou des preuves de l article `Spatial prediction of plant invasion using a hybrid of machine learning and geostatistical method`. Les covariables X retenues sont `Mean_Annual_Temp`, `annual_Precip`, `Seasonability`, `alt`, `PLT_TPA`, `Tpha`, `RelDen`, `prpfor`, `plt_drybio_adj`, `native_spp`, `PD_all`, `PSV_all`, `PSR_all`, `anmeantemp`, `anprecip`, `soilcarbon` ; 35 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`LON`, `LAT`), identifiants (`STATEAB`, `FIPS`, `county`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `PHASE` | `character` | categorical | 0% |
| `MEASYEAR` | `integer` | unknown | 0% |
| `RS` | `character` | categorical | 0% |
| `domain` | `character` | categorical | 0% |
| `division` | `character` | categorical | 0% |
| `provname` | `character` | categorical | 0% |
| `prov_ID` | `character` | categorical | 0% |
| `sectname` | `character` | categorical | 0% |
| `sect_ID` | `character` | categorical | 0% |
| `siteclcd_n` | `integer` | unknown | 0% |
| `siteclcd_top` | `integer` | unknown | 0% |
| `InvAP` | `integer` | binary | 0% |
| `Mean_Annual_Temp` | `integer` | continuous | 0% |
| `annual_Precip` | `integer` | continuous | 0% |
| `Seasonability` | `integer` | unknown | 0% |
| `alt` | `integer` | continuous | 0% |
| `PLT_TPA` | `numeric` | continuous | 0% |
| `Tpha` | `numeric` | continuous | 0% |
| `RelDen` | `numeric` | rate | 0% |
| `prpfor` | `numeric` | rate | 0% |
| `plt_drybio_adj` | `numeric` | continuous | 0% |
| `plt_drybio_ha` | `numeric` | continuous | 0% |
| `native_spp` | `integer` | unknown | 0% |
| `PD_all` | `numeric` | continuous | 0% |
| `PSV_all` | `numeric` | rate | 0% |
| `PSV_all_var` | `numeric` | rate | 0% |
| `PSR_all` | `numeric` | continuous | 0% |
| `PSR_all_var` | `numeric` | continuous | 0% |
| `PSE_all` | `numeric` | rate | 0% |
| `PSC_all` | `numeric` | rate | 0% |
| `anmeantemp` | `numeric` | continuous | 0% |
| `meandiurnrge` | `numeric` | continuous | 0% |
| `isotherm` | `numeric` | continuous | 0% |
| `tempseason` | `numeric` | continuous | 0% |
| `maxtempwarm` | `numeric` | continuous | 0% |
| `mintempcold` | `numeric` | continuous | 0% |
| `tempanrge` | `numeric` | continuous | 0% |
| `meantempwetq` | `numeric` | continuous | 0% |
| `meantempdryq` | `numeric` | continuous | 0% |
| `meantempwarm` | `numeric` | continuous | 0% |
| `meantempcold` | `numeric` | continuous | 0% |
| `precipwetm` | `integer` | continuous | 0% |
| `precipdrym` | `integer` | continuous | 0% |
| `precipseason` | `numeric` | continuous | 0% |
| `precipwetqu` | `integer` | continuous | 0% |
| `precipdryqu` | `integer` | continuous | 0% |
| `precipwarmqu` | `integer` | continuous | 0% |
| `precipcoldqu` | `integer` | continuous | 0% |
| `anprecip` | `integer` | continuous | 0% |
| `soilcarbon` | `integer` | continuous | 0% |
| `aridity` | `character` | categorical | 0% |

### Formule - niveau publication

- formula_pub: InvTotalCover ~ 41 predicteurs ecologiques (climat, sol, diversite/phylogenie des arbres) [Random Forest spatial]
- x_terms_pub: Mean_Annual_Temp, annual_Precip, Seasonability, alt, PLT_TPA, Tpha, RelDen, prpfor, plt_drybio_adj, native_spp, PD_all, PSV_all, PSR_all, anmeantemp, anprecip, soilcarbon
- y_term_pub: InvTotalCover
- Reference publication: Shen, LaRue, Fei & Zhang (2024), Ecology and Evolution, DOI 10.1002/ece3.11605; README.md (Dryad 10.5061/dryad.0rxwdbs8t) definit LAT/LON et 41 variables ecologiques auxiliaires, avec InvTotalCover explicitement documente comme 'sum of cover estimates for all invasive plants'. Papier p.4: apurement applique dans le loader via complete.cases() sur les 46071 placettes brutes ('after excluding plots with missing values, we eventually got 42,314 samples for analyses') -> N=42612 localement, ecart residuel de 298 lignes vs le N publie probablement du a un controle qualite supplementaire non detaille dans les pages consultees.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

### Formule - niveau systeme

- formula_used: InvTotalCover ~ Mean_Annual_Temp + annual_Precip + Seasonability + alt + PLT_TPA + Tpha + RelDen + prpfor + plt_drybio_adj + native_spp + PD_all + PSV_all + PSR_all + anmeantemp + anprecip + soilcarbon
- License evidence: DataCite API record for DOI 10.5061/dryad.0rxwdbs8t (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Recommended validation: N lignes=42612; T declare=13; variable temporelle declaree=MEASYEAR; repetitions de coordonnees controlees=3. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.
- benchmark_task_note: InvTotalCover mesure une couverture vegetale avec valeurs fractionnaires; MEASYEAR identifie les campagnes.
- Selected Y evidence: InvTotalCover mesure une couverture vegetale avec valeurs fractionnaires; MEASYEAR identifie les campagnes.
- Selected Y typology: continuous
- x_terms_used: Mean_Annual_Temp, annual_Precip, Seasonability, alt, PLT_TPA, Tpha, RelDen, prpfor, plt_drybio_adj, native_spp, PD_all, PSV_all, PSR_all, anmeantemp, anprecip, soilcarbon
- y_term_used: InvTotalCover
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

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
    formula: "InvTotalCover ~ Mean_Annual_Temp + annual_Precip + Seasonability + alt + PLT_TPA + Tpha + RelDen + prpfor + plt_drybio_adj + native_spp + PD_all + PSV_all + PSR_all + anmeantemp + anprecip + soilcarbon"
    response: "InvTotalCover"
    predictors: ["Mean_Annual_Temp", "annual_Precip", "Seasonability", "alt", "PLT_TPA", "Tpha", "RelDen", "prpfor", "plt_drybio_adj", "native_spp", "PD_all", "PSV_all", "PSR_all", "anmeantemp", "anprecip", "soilcarbon"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
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

- Dataset ID: `paper_plant_invasion_fia`
- Dataset name: Data for: Spatial prediction of plant invasion using a hybrid of machine learning and geostatistical method
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Spatial prediction of plant invasion using a hybrid of machine learning and geostatistical method
- Paper DOI: 10.1002/ece3.11605
- Dataset DOI: 10.5061/dryad.0rxwdbs8t
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.0rxwdbs8t
- Year: 2024 (annee de depot Dryad/DataCite, non verifiee comme annee de publication de l'article -- voir Reference publication)

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "InvTotalCover ~ 41 predicteurs ecologiques (climat, sol, diversite/phylogenie des arbres) [Random Forest spatial]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Shen, LaRue, Fei & Zhang (2024), Ecology and Evolution, DOI 10.1002/ece3.11605; README.md (Dryad 10.5061/dryad.0rxwdbs8t) definit LAT/LON et 41 variables ecologiques auxiliaires, avec InvTotalCover explicitement documente comme 'sum of cover estimates for all invasive plants'. Papier p.4: apurement applique dans le loader via complete.cases() sur les 46071 placettes brutes ('after excluding plots with missing values, we eventually got 42,314 samples for analyses') -> N=42612 localement, ecart residuel de 298 lignes vs le N publie probablement du a un controle qualite supplementaire non detaille dans les pages consultees."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Y/X/formula_used deja resolus ; estimateurs generiques (continuous) ajoutes en revue de lot du 2026-09-09."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Y/X/formula_used deja resolus ; estimateurs generiques (continuous) ajoutes en revue de lot du 2026-09-09.

## Estimator eligibility

```yaml
estimator_eligibility:
  eligible_estimators:
    - estimator: random_forest
      basis: scientific_evidence
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Random Forest mentionne dans la source."
    - estimator: ols
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Regression lineaire standard, baseline generique pour reponse continue."
    - estimator: gam_spatial
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "GAM (mgcv), baseline non-lineaire generique pour reponse continue."
    - estimator: xgboost
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Alternative ML non-parametrique generique, Y continu."
  conditionally_eligible_estimators: []
  ineligible_reason: "n/a -- estimateurs generiques eligibles (voir eligible_estimators)."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial (coupe transversale, interpolation geostatistique)
- Structure: coupe_transversale
- N observations: 42612
- k variables: 61
- T periods: 13
- Variable temporelle: MEASYEAR
- N/T profile: N_grand (reclasse -- voir note)
- Note structure (session 2026-09-23, TEI verifie en detail, reclasse de panel_ou_series) : le papier (Shen et al. 2024) construit deux modeles hybrides d'interpolation geostatistique statique -- boosted regression tree residual ordinary kriging (BRTOK) et LASSO residual ordinary kriging (LASOK) -- sur les placettes FIA (Forest Inventory and Analysis) de l'est des Etats-Unis. Recherche explicite dans le texte integral : **0 occurrence** de 'year'/'temporal'/'MEASYEAR'/'repeat[ed]' dans un contexte de modelisation -- la seule mention de 'repeated' concerne la repetition de la validation croisee a 10 plis, pas une repetition temporelle des mesures. MEASYEAR (annee de mesure FIA) n'est utilisee nulle part comme variable ou effet du modele : le kriging ordinaire est une methode d'interpolation spatiale statique par construction (semi-variogramme sur une seule surface), sans dimension temporelle. Coherent avec N spatial reel = 42609 sur 42612 lignes, T median=1 (verifie session 2026-08-17). Les auteurs traitent donc explicitement ce jeu comme une coupe transversale -- pas juste une inference statistique du projet a partir du N/T. La methode kriging (BRTOK/LASOK, semi-variogramme documente) reste une piste interessante pour une future route geostatistique cross-sectionnelle, distincte du chantier panel_fe/panel_sar_fe.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 13 distinct periods (variable: MEASYEAR)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-98.720006, -67.04813], y [24.665524, 49.319755]
- Time range: 2001 to 2013 (variable: MEASYEAR)
- CRS analyse recommande: pending — multi-zones (span=31.7deg) -- etendue compatible avec un grand pays/une region ; verifier qu'une projection nationale/regionale existe et convient a cette zone avant de l'utiliser, sinon envisager une projection continentale equal-area

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- Reproducibility status: OK - loader R enregistre et reexecutable (`plant_invasion_fia` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `plant_invasion_fia` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`plant_invasion_fia` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Spatial prediction of plant invasion using a hybrid of machine learning and geostatistical method

## Curation documentée — 2026-09-07

Decision conservatoire : N lignes=42612; T declare=13; variable temporelle declaree=MEASYEAR; repetitions de coordonnees controlees=3. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : continuous. InvTotalCover mesure une couverture vegetale avec valeurs fractionnaires; MEASYEAR identifie les campagnes.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
