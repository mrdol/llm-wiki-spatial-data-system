---
title: paper_network_misspecification_elections
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_network_misspecification_elections.rds
  - DataCite_2020_BiasFromNetworkMisspecification_10_1017_pan_2020
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Bias from Network Misspecification Under Spatial Dependence" (DOI 10.1017/pan.2020.26).

## Description du jeu de donnees

- Topic: dataset spatial spatio-temporel
- Observation unit: observation spatiale du dataset "Replication Data for: Bias due to network misspecification under spatial dependence"
- Observed population: Article mÃ©thodologique Political Analysis sur biais de mauvaise spÃ©cification de la matrice W sous dÃ©pendance spatiale
- Geographic context: etendue sf: x [-110.426547008631, 176.610152085255], y [-38.00805665, 79.84211425]
- Temporal context: 65 distinct periods (variable: elecyr)
- Source description: Bias from Network Misspecification Under Spatial Dependence
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1017/pan.2020.26
- Dataset DOI: 10.7910/dvn/adifov
- Source URL: https://dataverse.harvard.edu/citation?persistentId=doi:10.7910/DVN/ADIFOV
- Local raw dir: `data/raw/papers/DataCite_2020_BiasFromNetworkMisspecification_10_1017_pan_2020/`
- Local sf output: `data/final_datasets/sf/paper_network_misspecification_elections.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `votelead`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `elecyr`, `typgob2`, `votelead_m1`, `coalsize`, `pop`, `enep`, `gr_an`, `gr_glob_med_an`, `gr_loc_med_an`, `gr_glob_pc_an`, `gr_loc_pc_an`, `gr_glob_tr_an`, `gr_loc_tr_an`, `unem_an`, `unem_glob_med_an`, `unem_loc_med_an`, `unem_glob_pc_an`, `unem_loc_pc_an`, `unem_glob_tr_an`, `unem_loc_tr_an`, `mingov_in_nl`
- Candidate X count in local artifact: 21
- Candidate X typology: continuous, categorical
- Published X variables from paper: gr_an, unem_an, coalsize, pop, enep
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `name`, `ccode`, `key1`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `votelead` | `numeric` | continuous | [2.2, 57.8] | 1.6% |

> Selection Y/X (paper-loader / curated evidence) : Pour `network_misspecification_elections`, la ou les reponses `votelead` viennent du loader papier et/ou des preuves de l article `Bias from Network Misspecification Under Spatial Dependence`. Les covariables X retenues sont `gr_an`, `unem_an`, `coalsize`, `pop`, `enep` ; 16 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (`name`, `ccode`, `key1`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `elecyr` | `numeric` | continuous | 0% |
| `typgob2` | `numeric` | continuous | 6% |
| `votelead_m1` | `numeric` | continuous | 1.6% |
| `coalsize` | `numeric` | continuous | 0.8% |
| `pop` | `numeric` | continuous | 8% |
| `enep` | `numeric` | continuous | 9.3% |
| `gr_an` | `numeric` | continuous | 29.3% |
| `gr_glob_med_an` | `numeric` | continuous | 1.8% |
| `gr_loc_med_an` | `numeric` | continuous | 29.3% |
| `gr_glob_pc_an` | `numeric` | continuous | 1.8% |
| `gr_loc_pc_an` | `numeric` | continuous | 29.3% |
| `gr_glob_tr_an` | `numeric` | continuous | 47.9% |
| `gr_loc_tr_an` | `numeric` | continuous | 49% |
| `unem_an` | `numeric` | continuous | 36% |
| `unem_glob_med_an` | `numeric` | continuous | 1.8% |
| `unem_loc_med_an` | `numeric` | continuous | 36% |
| `unem_glob_pc_an` | `numeric` | continuous | 1.8% |
| `unem_loc_pc_an` | `numeric` | continuous | 36% |
| `unem_glob_tr_an` | `numeric` | continuous | 60.4% |
| `unem_loc_tr_an` | `numeric` | continuous | 60.6% |
| `mingov_in_nl` | `numeric` | binary | 6% |

### Formule - niveau publication

- formula_pub: votelead ~ gr_an + gr_loc_med_an + gr_glob_med_an + unem_an + unem_loc_med_an + unem_glob_med_an + coalsize + pop + enep [SAR/SLX sous differentes specifications de reseau -- objet methodologique principal du papier]
- x_terms_pub: gr_an, unem_an, coalsize, pop, enep
- y_term_pub: votelead
- Reference publication: Betz, Cook & Hollenbach (2020), Political Analysis, DOI 10.1017/pan.2020.26; KP2012_Benchmarking_Agg_Data.dta (archive PAN Dataverse) est un panel pays x annee electorale (22 pays OCDE, noms de pays en toutes lettres), covariables de vote economique (croissance/chomage a divers niveaux d'agregation). Le papier etudie explicitement le biais de mauvaise specification du reseau spatial -- formula_used est une specification simplifiee, pas la comparaison complete de specifications W du papier.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: votelead ~ gr_an + unem_an + coalsize + pop + enep
- x_terms_used: gr_an, unem_an, coalsize, pop, enep
- y_term_used: votelead
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
    formula: "votelead ~ gr_an + unem_an + coalsize + pop + enep"
    response: "votelead"
    predictors: ["gr_an", "unem_an", "coalsize", "pop", "enep"]
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

- Dataset ID: `paper_network_misspecification_elections`
- Dataset name: Replication Data for: Bias due to network misspecification under spatial dependence
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Bias from Network Misspecification Under Spatial Dependence
- Paper DOI: 10.1017/pan.2020.26
- Dataset DOI: 10.7910/dvn/adifov
- Source URL: https://dataverse.harvard.edu/citation?persistentId=doi:10.7910/DVN/ADIFOV
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "votelead ~ gr_an + gr_loc_med_an + gr_glob_med_an + unem_an + unem_loc_med_an + unem_glob_med_an + coalsize + pop + enep [SAR/SLX sous differentes specifications de reseau -- objet methodologique principal du papier]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Betz, Cook & Hollenbach (2020), Political Analysis, DOI 10.1017/pan.2020.26; KP2012_Benchmarking_Agg_Data.dta (archive PAN Dataverse) est un panel pays x annee electorale (22 pays OCDE, noms de pays en toutes lettres), covariables de vote economique (croissance/chomage a divers niveaux d'agregation). Le papier etudie explicitement le biais de mauvaise specification du reseau spatial -- formula_used est une specification simplifiee, pas la comparaison complete de specifications W du papier."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous_panel"
  package_include: "yes"
  has_local_rds: true
  missing_items: "le papier etudie la mauvaise specification du reseau spatial W comme objet methodologique principal ; formula_used est une specification simplifiee documentee, pas la comparaison complete de specifications W du papier"
  reason: "votelead continu et covariables de vote economique confirmees (panel pays x annee, 22 pays, T=65 annees electorales distinctes). Y continu, X defendables (issus du jeu KP2012 reel), artefact local utilisable -- promu sans revue manuelle (2026-08-12)."
```

- Decision: ready
- Manque principal: le papier etudie la mauvaise specification du reseau spatial W comme objet methodologique principal ; formula_used est une specification simplifiee documentee, pas la comparaison complete de specifications W du papier
- Raison: votelead continu et covariables de vote economique confirmees (panel pays x annee, 22 pays, T=65 annees electorales distinctes). Y continu, X defendables (issus du jeu KP2012 reel), artefact local utilisable -- promu sans revue manuelle (2026-08-12).

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
- N observations: 386
- k variables: 28
- T periods: 65
- Variable temporelle: elecyr
- N/T profile: N_moyen_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (386) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 22 ; panel NON EQUILIBRE (T par unite : min=9, mediane=17, max=25). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 22 unites spatiales distinctes, pas sur les 386 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 65 distinct periods (variable: elecyr)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-110.426547008631, 176.610152085255], y [-38.00805665, 79.84211425]
- Time range: 1946 to 2010 (variable: elecyr)
- CRS analyse recommande: pending - multi-zones (span=287deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.7910/dvn/adifov (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`network_misspecification_elections` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `network_misspecification_elections` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20%: gr_an (NA=29.3%), gr_loc_med_an (NA=29.3%), gr_loc_pc_an (NA=29.3%), gr_glob_tr_an (NA=47.9%), gr_loc_tr_an (NA=49%), unem_an (NA=36%), unem_loc_med_an (NA=36%), unem_loc_pc_an (NA=36%), unem_glob_tr_an (NA=60.4%), unem_loc_tr_an (NA=60.6%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`network_misspecification_elections` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Bias from Network Misspecification Under Spatial Dependence

