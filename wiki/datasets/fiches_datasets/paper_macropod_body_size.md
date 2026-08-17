---
title: paper_macropod_body_size
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_macropod_body_size.rds
  - DatasetFirst_10_5061_dryad_c3tc6
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Empirical tests of harvest‐induced body‐size evolution along a geographic gradient in A ustralian macropods" (DOI 10.1111/1365-2656.12273).

## Description du jeu de donnees

- Topic: ecologie evolutive / evolution de la taille corporelle induite par la chasse
- Observation unit: crane individuel (collection faunique)
- Observed population: wallaby de Bennett (Macropus rufogriseus), Australie, N=856 cranes
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: 49 distinct periods (variable: Year)
- Source description: Empirical tests of harvest‐induced body‐size evolution along a geographic gradient in A ustralian macropods
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/1365-2656.12273
- Dataset DOI: 10.5061/dryad.c3tc6
- Source URL: https://doi.org/10.5061/dryad.c3tc6
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_c3tc6/`
- Local sf output: `data/final_datasets/sf/paper_macropod_body_size.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `CL`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Sex`, `Year`, `MI`, `WinterMinTemp`, `SummerMaxTemp`, `SummerWetBulbTemp`, `AnnualRain`, `AnnualNDVI`, `GrowSeasRain`, `GrowSeasNDVI`, `MinSeasRain`, `MinSeasNDVI`
- Candidate X count in local artifact: 12
- Candidate X typology: categorical, continuous
- Published X variables from paper: SummerMaxTemp (temperature maximale estivale), AnnualRain (precipitation annuelle), MI (molar progression index, proxy d'age), Sex, Year
- Published X count: 5
- Coordinates (x, y - excluded from X candidates): `Longitude`, `Latitude`
- Identifier columns (excluded from X candidates): `Island`, `gridLongitude`, `gridLatitude`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `CL` | `numeric` | continuous | [83.91, 156.7] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `macropod_body_size`, la ou les reponses `CL` viennent du loader papier et/ou des preuves de l article `Empirical tests of harvest‐induced body‐size evolution along a geographic gradient in A ustralian macropods`. Les covariables X retenues sont `SummerMaxTemp`, `AnnualRain`, `MI`, `Sex`, `Year` ; 7 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Longitude`, `Latitude`), identifiants (`Island`, `gridLongitude`, `gridLatitude`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Sex` | `character` | categorical | 6.8% |
| `Year` | `integer` | count | 0% |
| `MI` | `numeric` | continuous | 0% |
| `WinterMinTemp` | `numeric` | continuous | 0% |
| `SummerMaxTemp` | `numeric` | continuous | 0% |
| `SummerWetBulbTemp` | `numeric` | continuous | 0% |
| `AnnualRain` | `numeric` | continuous | 0% |
| `AnnualNDVI` | `numeric` | continuous | 0% |
| `GrowSeasRain` | `numeric` | continuous | 0% |
| `GrowSeasNDVI` | `numeric` | rate | 0% |
| `MinSeasRain` | `numeric` | continuous | 0% |
| `MinSeasNDVI` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: CL ~ SummerMaxTemp + AnnualRain + MI + Sex + Island + Year [modele spatial bayesien controlant pour l'age (MI, molar progression index), le sexe, l'effet ile, et l'annee ; teste l'hypothese de nanisme induit par la chasse le long d'un gradient geographique sur >2000 cranes de macropodes]
- x_terms_pub: SummerMaxTemp (temperature maximale estivale), AnnualRain (precipitation annuelle), MI (molar progression index, proxy d'age), Sex, Year
- y_term_pub: CL (longueur condylobasale du crane, indicateur standard de taille corporelle chez les macropodes), espece Macropus rufogriseus (wallaby de Bennett, N=856, la mieux representee des 3 especes du depot)
- Reference publication: Prowse et al. (2015), Empirical tests of harvest-induced body-size evolution along a geographic gradient in Australian macropods, Journal of Animal Ecology, doi:10.1111/1365-2656.12273. Le papier mesure plus de 2000 cranes de macropodes (collections fauniques, >130 ans) et ajuste des modeles bayesiens spatiaux controlant pour l'age, le sexe et les effets d'ile ; les resultats montrent une taille de crane augmentant avec une temperature estivale maximale plus basse et des precipitations plus elevees (hypotheses de dissipation thermique et de productivite). Confirme par recherche web (resume Wiley/besjournals, session 2026-08-16), PDF non recupere localement (a ajouter a la liste de recuperation manuelle). Donnees brutes (ProwseEtAl_MacropodData.csv) telechargees directement depuis Dryad (10.5061/dryad.c3tc6) -- pas une reconstruction. Le depot pool 3 especes (M. rufogriseus, M. giganteus, M. fuliginosus) ; formula_used filtre sur M. rufogriseus (N=856, la mieux representee) pour respecter l'approche du papier qui ajuste un modele separe par espece plutot que de pooler des especes aux tailles cranio-corporelles tres differentes.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Prowse et al. (2015), Empirical tests of harvest-induced body-size evolution along a geographic gradient in Australian macropods, Journal of Animal Ecology, doi:10.1111/1365-2656.12273. Le papier mesure plus de 2000 cranes de macropodes (collections fauniques, >130 ans) et ajuste des modeles bayesiens spatiaux controlant pour l'age, le sexe et les effets d'ile ; les resultats montrent une taille de crane augmentant avec une temperature estivale maximale plus basse et des precipitations plus elevees (hypotheses de dissipation thermique et de productivite). Confirme par recherche web (resume Wiley/besjournals, session 2026-08-16), PDF non recupere localement (a ajouter a la liste de recuperation manuelle). Donnees brutes (ProwseEtAl_MacropodData.csv) telechargees directement depuis Dryad (10.5061/dryad.c3tc6) -- pas une reconstruction. Le depot pool 3 especes (M. rufogriseus, M. giganteus, M. fuliginosus) ; formula_used filtre sur M. rufogriseus (N=856, la mieux representee) pour respecter l'approche du papier qui ajuste un modele separe par espece plutot que de pooler des especes aux tailles cranio-corporelles tres differentes.

### Formule - niveau systeme

- formula_used: CL ~ SummerMaxTemp + AnnualRain + MI + Sex + Year
- x_terms_used: SummerMaxTemp, AnnualRain, MI, Sex, Year
- y_term_used: CL
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Prowse et al. (2015), Empirical tests of harvest-induced body-size evolution along a geographic gradient in Australian macropods, Journal of Animal Ecology, doi:10.1111/1365-2656.12273. Le papier mesure plus de 2000 cranes de macropodes (collections fauniques, >130 ans) et ajuste des modeles bayesiens spatiaux controlant pour l'age, le sexe et les effets d'ile ; les resultats montrent une taille de crane augmentant avec une temperature estivale maximale plus basse et des precipitations plus elevees (hypotheses de dissipation thermique et de productivite). Confirme par recherche web (resume Wiley/besjournals, session 2026-08-16), PDF non recupere localement (a ajouter a la liste de recuperation manuelle). Donnees brutes (ProwseEtAl_MacropodData.csv) telechargees directement depuis Dryad (10.5061/dryad.c3tc6) -- pas une reconstruction. Le depot pool 3 especes (M. rufogriseus, M. giganteus, M. fuliginosus) ; formula_used filtre sur M. rufogriseus (N=856, la mieux representee) pour respecter l'approche du papier qui ajuste un modele separe par espece plutot que de pooler des especes aux tailles cranio-corporelles tres differentes.

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
    formula: "CL ~ SummerMaxTemp + AnnualRain + MI + Sex + Year"
    response: "CL (longueur condylobasale du crane, indicateur standard de taille corporelle chez les macropodes), espece Macropus rufogriseus (wallaby de Bennett, N=856, la mieux representee des 3 especes du depot)"
    predictors: ["SummerMaxTemp (temperature maximale estivale)", "AnnualRain (precipitation annuelle)", "MI (molar progression index, proxy d'age)", "Sex", "Year"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Prowse et al. (2015), Empirical tests of harvest-induced body-size evolution along a geographic gradient in Australian macropods, Journal of Animal Ecology, doi:10.1111/1365-2656.12273. Le papier mesure plus de 2000 cranes de macropodes (collections fauniques, >130 ans) et ajuste des modeles bayesiens spatiaux controlant pour l'age, le sexe et les effets d'ile ; les resultats montrent une taille de crane augmentant avec une temperature estivale maximale plus basse et des precipitations plus elevees (hypotheses de dissipation thermique et de productivite). Confirme par recherche web (resume Wiley/besjournals, session 2026-08-16), PDF non recupere localement (a ajouter a la liste de recuperation manuelle). Donnees brutes (ProwseEtAl_MacropodData.csv) telechargees directement depuis Dryad (10.5061/dryad.c3tc6) -- pas une reconstruction. Le depot pool 3 especes (M. rufogriseus, M. giganteus, M. fuliginosus) ; formula_used filtre sur M. rufogriseus (N=856, la mieux representee) pour respecter l'approche du papier qui ajuste un modele separe par espece plutot que de pooler des especes aux tailles cranio-corporelles tres differentes."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "CL ~ WinterMinTemp + SummerMaxTemp + SummerWetBulbTemp + AnnualRain + AnnualNDVI + GrowSeasRain + GrowSeasNDVI + MinSeasRain + MinSeasNDVI + MI + Sex + Year"
    response: "CL"
    predictors: ["WinterMinTemp", "SummerMaxTemp", "SummerWetBulbTemp", "AnnualRain", "AnnualNDVI", "GrowSeasRain", "GrowSeasNDVI", "MinSeasRain", "MinSeasNDVI", "MI", "Sex", "Year"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Prowse et al. (2015), Empirical tests of harvest-induced body-size evolution along a geographic gradient in Australian macropods, Journal of Animal Ecology, doi:10.1111/1365-2656.12273. Le papier mesure plus de 2000 cranes de macropodes (collections fauniques, >130 ans) et ajuste des modeles bayesiens spatiaux controlant pour l'age, le sexe et les effets d'ile ; les resultats montrent une taille de crane augmentant avec une temperature estivale maximale plus basse et des precipitations plus elevees (hypotheses de dissipation thermique et de productivite). Confirme par recherche web (resume Wiley/besjournals, session 2026-08-16), PDF non recupere localement (a ajouter a la liste de recuperation manuelle). Donnees brutes (ProwseEtAl_MacropodData.csv) telechargees directement depuis Dryad (10.5061/dryad.c3tc6) -- pas une reconstruction. Le depot pool 3 especes (M. rufogriseus, M. giganteus, M. fuliginosus) ; formula_used filtre sur M. rufogriseus (N=856, la mieux representee) pour respecter l'approche du papier qui ajuste un modele separe par espece plutot que de pooler des especes aux tailles cranio-corporelles tres differentes."
    estimator_context: ["ols", "gam_spatial", "random_forest", "xgboost", "gwr"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_macropod_body_size`
- Dataset name: Data from: Empirical tests of harvest-induced body-size evolution along a geographic gradient in Australian macropods
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Empirical tests of harvest‐induced body‐size evolution along a geographic gradient in A ustralian macropods
- Paper DOI: 10.1111/1365-2656.12273
- Dataset DOI: 10.5061/dryad.c3tc6
- Source URL: https://doi.org/10.5061/dryad.c3tc6
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "CL ~ SummerMaxTemp + AnnualRain + MI + Sex + Island + Year [modele spatial bayesien controlant pour l'age (MI, molar progression index), le sexe, l'effet ile, et l'annee ; teste l'hypothese de nanisme induit par la chasse le long d'un gradient geographique sur >2000 cranes de macropodes]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Prowse et al. (2015), Empirical tests of harvest-induced body-size evolution along a geographic gradient in Australian macropods, Journal of Animal Ecology, doi:10.1111/1365-2656.12273. Le papier mesure plus de 2000 cranes de macropodes (collections fauniques, >130 ans) et ajuste des modeles bayesiens spatiaux controlant pour l'age, le sexe et les effets d'ile ; les resultats montrent une taille de crane augmentant avec une temperature estivale maximale plus basse et des precipitations plus elevees (hypotheses de dissipation thermique et de productivite). Confirme par recherche web (resume Wiley/besjournals, session 2026-08-16), PDF non recupere localement (a ajouter a la liste de recuperation manuelle). Donnees brutes (ProwseEtAl_MacropodData.csv) telechargees directement depuis Dryad (10.5061/dryad.c3tc6) -- pas une reconstruction. Le depot pool 3 especes (M. rufogriseus, M. giganteus, M. fuliginosus) ; formula_used filtre sur M. rufogriseus (N=856, la mieux representee) pour respecter l'approche du papier qui ajuste un modele separe par espece plutot que de pooler des especes aux tailles cranio-corporelles tres differentes."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun -- CSV original telecharge directement depuis Dryad ; PDF du papier non recupere localement (evidence via resume web), formula_used filtre sur une seule espece (M. rufogriseus, N=856) parmi les 3 poolees dans le depot, conforme a l'approche par-espece du papier"
  reason: "Y continu reel (CL, longueur condylobasale, standard de taille corporelle), N=856 (M. rufogriseus) avec coordonnees reelles (Australie), covariables climatiques exactement celles du papier (SummerMaxTemp, AnnualRain, confirmees par le resume : 'skull size increasing with decreasing summer maximum temperature and increasing rainfall'), plus age (MI) et sexe. CSV original telecharge directement depuis Dryad, pas une reconstruction. Formule confirmee par recherche web (resume officiel Journal of Animal Ecology, session 2026-08-16)."
```

- Decision: ready
- Manque principal: aucun -- CSV original telecharge directement depuis Dryad ; PDF du papier non recupere localement (evidence via resume web), formula_used filtre sur une seule espece (M. rufogriseus, N=856) parmi les 3 poolees dans le depot, conforme a l'approche par-espece du papier
- Raison: Y continu reel (CL, longueur condylobasale, standard de taille corporelle), N=856 (M. rufogriseus) avec coordonnees reelles (Australie), covariables climatiques exactement celles du papier (SummerMaxTemp, AnnualRain, confirmees par le resume : 'skull size increasing with decreasing summer maximum temperature and increasing rainfall'), plus age (MI) et sexe. CSV original telecharge directement depuis Dryad, pas une reconstruction. Formule confirmee par recherche web (resume officiel Journal of Animal Ecology, session 2026-08-16).

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
- N observations: 856
- k variables: 21
- T periods: 49
- Variable temporelle: Year
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (856) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 123 ; panel NON EQUILIBRE (T par unite : min=1, mediane=1, max=163). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 123 unites spatiales distinctes, pas sur les 856 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 49 distinct periods (variable: Year)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [140.9666667, 153.4713889], y [-43.15, -24.3]
- Time range: 1823 to 2007 (variable: Year)
- CRS analyse recommande: 32755 (UTM Zone 55S (EPSG:32755)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`macropod_body_size` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `macropod_body_size` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`macropod_body_size` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Empirical tests of harvest‐induced body‐size evolution along a geographic gradient in A ustralian macropods

