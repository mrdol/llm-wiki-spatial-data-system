---
title: paper_seshat_social_complexity
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_seshat_social_complexity.rds
  - DatasetFirst_10_17916_p6159w
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Fitting Dynamic Regression Models to Seshat Data" (DOI 10.21237/c7clio9137696).

## Description du jeu de donnees

- Topic: histoire quantitative / evolution de la complexite sociale
- Observation unit: polite historique
- Observed population: polites historiques codees par la base Seshat, 31 zones geographiques naturelles, echelle mondiale
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: Fitting Dynamic Regression Models to Seshat Data
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.21237/c7clio9137696
- Dataset DOI: 10.17916/p6159w
- Source URL: https://doi.org/10.17916/p6159w
- Local raw dir: `data/raw/papers/DatasetFirst_10_17916_p6159w/`
- Local sf output: `data/final_datasets/sf/paper_seshat_social_complexity.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Polity_Population`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Administrative_levels`, `Polity_territory`, `Settlement_hierarchy`
- Candidate X count in local artifact: 3
- Candidate X typology: continuous
- Published X variables from paper: Polity_territory (superficie territoriale de la polite, km2), Administrative_levels (nombre de niveaux hierarchiques administratifs), Settlement_hierarchy (nombre de niveaux hierarchiques d'habitat)
- Published X count: 3
- Coordinates (x, y - excluded from X candidates): `nga_lon`, `nga_lat`
- Identifier columns (excluded from X candidates): `NGA`, `Polity`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Polity_Population` | `numeric` | continuous | [30, 3.34e+08] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `seshat_social_complexity`, la ou les reponses `Polity_Population` viennent du loader papier et/ou des preuves de l article `Fitting Dynamic Regression Models to Seshat Data`. Les covariables X retenues sont `Polity_territory`, `Administrative_levels`, `Settlement_hierarchy`. Les coordonnees (`nga_lon`, `nga_lat`), identifiants (`NGA`, `Polity`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Administrative_levels` | `numeric` | continuous | 2.9% |
| `Polity_territory` | `numeric` | continuous | 6.8% |
| `Settlement_hierarchy` | `numeric` | continuous | 2% |

### Formule - niveau publication

- formula_pub: PolityPopulation_t ~ PolityPopulation_(t-1) + covariables de complexite sociale [modele de regression dynamique (autoregressif) ajuste separement pour chaque variable de complexite sociale Seshat -- l'article demontre comment ajuster des modeles de regression dynamique a des donnees panel NGA x Polity x temps avec autocorrelation temporelle et incertitude de codage]
- x_terms_pub: Polity_territory (superficie territoriale de la polite, km2), Administrative_levels (nombre de niveaux hierarchiques administratifs), Settlement_hierarchy (nombre de niveaux hierarchiques d'habitat)
- y_term_pub: Polity_Population (population totale de la polite, valeur maximale enregistree sur sa duree de vie)
- Reference publication: Turchin (2018), Fitting Dynamic Regression Models to Seshat Data, Cliodynamics, doi:10.21237/C7clio9137696. Le papier demontre comment ajuster des modeles de regression dynamique (autoregressifs, tenant compte de l'autocorrelation temporelle) aux donnees panel de la base Seshat (Natural Geographic Area x Polity x variable x periode). formula_used simplifie le panel temporel du papier en une coupe transversale par polite (valeur maximale enregistree sur la duree de vie de chaque polite pour chacune des 4 variables, agregation documentee du format long NGA/Polity/Variable/Date vers une table large) -- ce n'est pas le modele dynamique du papier mais une regression de complexite sociale standard dans la litterature Seshat (correlation population-hierarchie administrative). Coordonnees des 33 zones geographiques naturelles (NGA) Seshat obtenues par geocodage Nominatim/OpenStreetMap de leur nom de region historique (service public, verifie individuellement, pas une estimation -- 2 NGA non appariees a une polite avec donnees de population completes exclues). Donnees brutes (SCdat.csv) telechargees directement depuis Dryad (10.17916/p6159w) via l'API avec token OAuth (la premiere tentative de harvest avait signale a tort 'aucun fichier trouve', corrige en session 2026-08-16) -- pas une reconstruction, N=307 polites, 31 NGA.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: Polity_Population ~ Polity_territory + Administrative_levels + Settlement_hierarchy
- x_terms_used: Polity_territory, Administrative_levels, Settlement_hierarchy
- y_term_used: Polity_Population
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

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
    formula: "Polity_Population ~ Polity_territory + Administrative_levels + Settlement_hierarchy"
    response: "Polity_Population (population totale de la polite, valeur maximale enregistree sur sa duree de vie)"
    predictors: ["Polity_territory (superficie territoriale de la polite, km2)", "Administrative_levels (nombre de niveaux hierarchiques administratifs)", "Settlement_hierarchy (nombre de niveaux hierarchiques d'habitat)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "Polity_Population ~ Polity_territory + Administrative_levels + Settlement_hierarchy"
    response: "Polity_Population"
    predictors: ["Polity_territory", "Administrative_levels", "Settlement_hierarchy"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "gam_spatial", "random_forest", "gwr"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_seshat_social_complexity`
- Dataset name: Fitting Dynamic Regression Models to Seshat Data - Supplemental Material
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Fitting Dynamic Regression Models to Seshat Data
- Paper DOI: 10.21237/c7clio9137696
- Dataset DOI: 10.17916/p6159w
- Source URL: https://doi.org/10.17916/p6159w
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "PolityPopulation_t ~ PolityPopulation_(t-1) + covariables de complexite sociale [modele de regression dynamique (autoregressif) ajuste separement pour chaque variable de complexite sociale Seshat -- l'article demontre comment ajuster des modeles de regression dynamique a des donnees panel NGA x Polity x temps avec autocorrelation temporelle et incertitude de codage]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Turchin (2018), Fitting Dynamic Regression Models to Seshat Data, Cliodynamics, doi:10.21237/C7clio9137696. Le papier demontre comment ajuster des modeles de regression dynamique (autoregressifs, tenant compte de l'autocorrelation temporelle) aux donnees panel de la base Seshat (Natural Geographic Area x Polity x variable x periode). formula_used simplifie le panel temporel du papier en une coupe transversale par polite (valeur maximale enregistree sur la duree de vie de chaque polite pour chacune des 4 variables, agregation documentee du format long NGA/Polity/Variable/Date vers une table large) -- ce n'est pas le modele dynamique du papier mais une regression de complexite sociale standard dans la litterature Seshat (correlation population-hierarchie administrative). Coordonnees des 33 zones geographiques naturelles (NGA) Seshat obtenues par geocodage Nominatim/OpenStreetMap de leur nom de region historique (service public, verifie individuellement, pas une estimation -- 2 NGA non appariees a une polite avec donnees de population completes exclues). Donnees brutes (SCdat.csv) telechargees directement depuis Dryad (10.17916/p6159w) via l'API avec token OAuth (la premiere tentative de harvest avait signale a tort 'aucun fichier trouve', corrige en session 2026-08-16) -- pas une reconstruction, N=307 polites, 31 NGA."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "le papier ajuste des modeles de regression dynamique (panel temporel avec autocorrelation), pas une regression transversale -- formula_used agrege chaque polite a sa valeur maximale enregistree (simplification documentee du format panel long) ; coordonnees des NGA obtenues par geocodage de noms de regions historiques (pas des coordonnees officielles Seshat, non publiees) -- promu a package_include='yes' apres validation utilisateur (session 2026-08-16, groupe A)"
  reason: "Y continu reel (population de polite, valeurs historiques codees par les experts Seshat), N=307 polites sur 31 zones geographiques naturelles avec coordonnees reelles (geocodees individuellement et verifiees), covariables de complexite sociale reelles (territoire, hierarchie administrative, hierarchie d'habitat). CSV original telecharge directement depuis Dryad (fausse alerte 'aucun fichier' corrigee), pas une reconstruction des valeurs elles-memes."
```

- Decision: ready
- Manque principal: le papier ajuste des modeles de regression dynamique (panel temporel avec autocorrelation), pas une regression transversale -- formula_used agrege chaque polite a sa valeur maximale enregistree (simplification documentee du format panel long) ; coordonnees des NGA obtenues par geocodage de noms de regions historiques (pas des coordonnees officielles Seshat, non publiees) -- promu a package_include="yes" apres validation utilisateur (session 2026-08-16, groupe A)
- Raison: Y continu reel (population de polite, valeurs historiques codees par les experts Seshat), N=307 polites sur 31 zones geographiques naturelles avec coordonnees reelles (geocodees individuellement et verifiees), covariables de complexite sociale reelles (territoire, hierarchie administrative, hierarchie d'habitat). CSV original telecharge directement depuis Dryad (fausse alerte 'aucun fichier' corrigee), pas une reconstruction des valeurs elles-memes.

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
- N observations: 307
- k variables: 10
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-155.4486983, 151.8327443], y [-13.5170887, 64.9841821]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=307.3deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`seshat_social_complexity` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `seshat_social_complexity` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`seshat_social_complexity` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Fitting Dynamic Regression Models to Seshat Data

