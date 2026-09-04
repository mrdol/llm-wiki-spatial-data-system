---
title: paper_shark_longline_catch
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_shark_longline_catch.rds
  - DatasetFirst_10_25349_d9789w
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Global hotspots of shark interactions with industrial longline fisheries" (DOI 10.3389/fmars.2022.1062447).

## Description du jeu de donnees

- Topic: halieutique / capture de requins par palangre industrielle
- Observation unit: cellule de grille (5x5 degres)
- Observed population: requins captures par palangre, ORGP ICCAT (Atlantique), N=8592 cellules
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: 9 distinct periods (variable: year)
- Source description: Global hotspots of shark interactions with industrial longline fisheries
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.3389/fmars.2022.1062447
- Dataset DOI: 10.25349/d9789w
- Source URL: https://doi.org/10.25349/d9789w
- Local raw dir: `data/raw/papers/DatasetFirst_10_25349_d9789w/`
- Local sf output: `data/final_datasets/sf/paper_shark_longline_catch.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `catch`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `year`, `species_commonname`, `mean_sst`, `mean_chla`, `mean_ssh`, `sdm`, `target_effort`, `median_price_species`, `median_price_group`
- Candidate X count in local artifact: 9
- Candidate X typology: continuous, categorical
- Published X variables from paper: mean_sst (temperature de surface de la mer moyenne), mean_chla (chlorophylle-a moyenne), mean_ssh (hauteur de surface de la mer moyenne), sdm (score de modele de distribution d'espece, covariable d'entree du RF), target_effort (effort de peche par pavillon), median_price_species (prix ex-vessel median par espece)
- Published X count: 6
- Coordinates (x, y - excluded from X candidates): `longitude`, `latitude`
- Identifier columns (excluded from X candidates): `species_sciname`, `pres_abs`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `catch` | `numeric` | continuous | [0, 24153.5556] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `shark_longline_catch`, la ou les reponses `catch` viennent du loader papier et/ou des preuves de l article `Global hotspots of shark interactions with industrial longline fisheries`. Les covariables X retenues sont `mean_sst`, `mean_chla`, `mean_ssh`, `sdm`, `target_effort`, `median_price_species` ; 3 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`longitude`, `latitude`), identifiants (`species_sciname`, `pres_abs`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `year` | `integer` | count | 0% |
| `species_commonname` | `character` | categorical | 0% |
| `mean_sst` | `numeric` | continuous | 2.9% |
| `mean_chla` | `numeric` | continuous | 4.1% |
| `mean_ssh` | `numeric` | rate | 2.8% |
| `sdm` | `numeric` | rate | 0% |
| `target_effort` | `numeric` | continuous | 0% |
| `median_price_species` | `numeric` | continuous | 0% |
| `median_price_group` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: catch ~ sdm + species_commonname + mean_sst + mean_chla + effort + [combinaisons de mean_ssh, cv_sst, cv_chla, cv_ssh, prix ex-vessel] [modele Random Forest a deux composantes : (1) classification presence/absence, (2) regression de la capture conditionnelle a la presence ; prediction finale = composante 1 x composante 2 ; ajuste separement par ORGP (ICCAT/IOTC/IATTC/WCPFC)]
- x_terms_pub: mean_sst (temperature de surface de la mer moyenne), mean_chla (chlorophylle-a moyenne), mean_ssh (hauteur de surface de la mer moyenne), sdm (score de modele de distribution d'espece, covariable d'entree du RF), target_effort (effort de peche par pavillon), median_price_species (prix ex-vessel median par espece)
- y_term_pub: catch (capture de requin, comptage, palangre industrielle, ICCAT -- Atlantique)
- Reference publication: Burns, Bradley & Thomas (2023), Global hotspots of shark interactions with industrial longline fisheries, Frontiers in Marine Science, doi:10.3389/fmars.2022.1062447. Le papier ajuste des modeles Random Forest en deux composantes (classification presence/absence x regression de capture) par ORGP (ICCAT/IOTC/IATTC/WCPFC) avec SST, chlorophylle-a, hauteur de mer, effort de peche, prix ex-vessel et un score de modele de distribution d'espece comme predicteurs. formula_used utilise la table de predicteurs reels (pas les predictions .pred/.final_pred du modele, exclues) pour ICCAT (Atlantique) uniquement -- les 4 ORGP ont des schemas de colonnes legerement differents (drapeaux de flotte differents), non fusionnes ici. Donnees brutes (ICCAT_ll_untuned_final_predict.csv) telechargees directement depuis Dryad (10.25349/d9789w) -- pas une reconstruction, N=8592 cellules de grille, papier recupere manuellement par l'utilisateur (session 2026-08-16).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: catch ~ mean_sst + mean_chla + mean_ssh + sdm + target_effort + median_price_species
- x_terms_used: mean_sst, mean_chla, mean_ssh, sdm, target_effort, median_price_species
- y_term_used: catch
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
    formula: "catch ~ mean_sst + mean_chla + mean_ssh + sdm + target_effort + median_price_species"
    response: "catch (capture de requin, comptage, palangre industrielle, ICCAT -- Atlantique)"
    predictors: ["mean_sst (temperature de surface de la mer moyenne)", "mean_chla (chlorophylle-a moyenne)", "mean_ssh (hauteur de surface de la mer moyenne)", "sdm (score de modele de distribution d'espece, covariable d'entree du RF)", "target_effort (effort de peche par pavillon)", "median_price_species (prix ex-vessel median par espece)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "catch ~ mean_sst + mean_chla + mean_ssh + sdm + target_effort + median_price_species + species_commonname"
    response: "catch"
    predictors: ["mean_sst", "mean_chla", "mean_ssh", "sdm", "target_effort", "median_price_species", "species_commonname"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["random_forest", "random_forest_xy", "xgboost", "gam_spatial", "gwr"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_shark_longline_catch`
- Dataset name: Global hotspots of shark interactions with industrial longline fisheries
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Global hotspots of shark interactions with industrial longline fisheries
- Paper DOI: 10.3389/fmars.2022.1062447
- Dataset DOI: 10.25349/d9789w
- Source URL: https://doi.org/10.25349/d9789w
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "catch ~ sdm + species_commonname + mean_sst + mean_chla + effort + [combinaisons de mean_ssh, cv_sst, cv_chla, cv_ssh, prix ex-vessel] [modele Random Forest a deux composantes : (1) classification presence/absence, (2) regression de la capture conditionnelle a la presence ; prediction finale = composante 1 x composante 2 ; ajuste separement par ORGP (ICCAT/IOTC/IATTC/WCPFC)]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Burns, Bradley & Thomas (2023), Global hotspots of shark interactions with industrial longline fisheries, Frontiers in Marine Science, doi:10.3389/fmars.2022.1062447. Le papier ajuste des modeles Random Forest en deux composantes (classification presence/absence x regression de capture) par ORGP (ICCAT/IOTC/IATTC/WCPFC) avec SST, chlorophylle-a, hauteur de mer, effort de peche, prix ex-vessel et un score de modele de distribution d'espece comme predicteurs. formula_used utilise la table de predicteurs reels (pas les predictions .pred/.final_pred du modele, exclues) pour ICCAT (Atlantique) uniquement -- les 4 ORGP ont des schemas de colonnes legerement differents (drapeaux de flotte differents), non fusionnes ici. Donnees brutes (ICCAT_ll_untuned_final_predict.csv) telechargees directement depuis Dryad (10.25349/d9789w) -- pas une reconstruction, N=8592 cellules de grille, papier recupere manuellement par l'utilisateur (session 2026-08-16)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun -- table de predicteurs reels (pas les predictions du modele) telechargee directement depuis Dryad, N=8592 cellules ICCAT"
  reason: "Y continu reel (capture de requin), N=8592 cellules de grille avec coordonnees reelles (Atlantique, ICCAT), covariables environnementales et d'effort de peche exactement celles du papier. CSV original telecharge directement depuis Dryad, pas une reconstruction (colonnes de prediction .pred/.final_pred explicitement exclues de X). Papier identifie (Frontiers in Marine Science, DOI 10.3389/fmars.2022.1062447), recupere manuellement par l'utilisateur (session 2026-08-16)."
```

- Decision: ready
- Manque principal: aucun -- table de predicteurs reels (pas les predictions du modele) telechargee directement depuis Dryad, N=8592 cellules ICCAT
- Raison: Y continu reel (capture de requin), N=8592 cellules de grille avec coordonnees reelles (Atlantique, ICCAT), covariables environnementales et d'effort de peche exactement celles du papier. CSV original telecharge directement depuis Dryad, pas une reconstruction (colonnes de prediction .pred/.final_pred explicitement exclues de X). Papier identifie (Frontiers in Marine Science, DOI 10.3389/fmars.2022.1062447), recupere manuellement par l'utilisateur (session 2026-08-16).

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
- N observations: 8592
- k variables: 17
- T periods: 9
- Variable temporelle: year
- N/T profile: N_grand_T_moyen
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (8592) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 300 ; panel NON EQUILIBRE (T par unite : min=4, mediane=36, max=36). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 300 unites spatiales distinctes, pas sur les 8592 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 9 distinct periods (variable: year)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-95, 30], y [-55, 60]
- Time range: 2012 to 2020 (variable: year)
- CRS analyse recommande: pending - multi-zones (span=125deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.25349/d9789w (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`shark_longline_catch` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `shark_longline_catch` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`shark_longline_catch` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Global hotspots of shark interactions with industrial longline fisheries

