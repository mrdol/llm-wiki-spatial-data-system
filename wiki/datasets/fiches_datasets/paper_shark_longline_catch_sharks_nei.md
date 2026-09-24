---
title: paper_shark_longline_catch_sharks_nei
type: dataset
created: 2026-09-23
updated: 2026-09-23
sources:
  - data/final_datasets/sf/paper_shark_longline_catch_sharks_nei.rds
  - DatasetFirst_10_25349_d9789w
tags: [dataset, paper-derived, spatial, point, panel-split]
---

Sous-jeu espece-specifique de [[paper_shark_longline_catch]], scinde le 2026-09-23 (code/r_catalog/split_shark_longline_catch.R) parce que le jeu parent avait 4 lignes par couple (site, annee) -- une par espece -- rendant `validate_spatial_panel_data()` invalide sur le jeu pool.  Le papier source (Burns et al. 2024, TEI verifie) entraine un modele SEPARE par espece ("Our model was designed to be replicated for use with datasets of any spatiotemporal AND species resolution") -- ce decoupage suit donc directement l'approche des auteurs, pas une convenance du projet.

Espece : requins non identifies (Sharks NEI -- Not Elsewhere Identified). Reponse binaire `pres_abs` positive dans 16.7% des lignes.

## Description du jeu de donnees

- Topic: halieutique / capture de requins par palangre industrielle -- Sharks NEI
- Observation unit: cellule de grille (5x5 degres) x annee, une seule espece
- Observed population: requins non identifies (Sharks NEI -- Not Elsewhere Identified), captures par palangre, ORGP ICCAT (Atlantique), N=2148 lignes (300 sites x jusqu'a 9 annees)
- Geographic context: Etendue mesuree dans le RDS : x [-95, 30], y [-55, 60]; CRS EPSG:4326.
- Temporal context: 9 distinct periods (variable: year)
- Source description: Global hotspots of shark interactions with industrial longline fisheries -- sous-jeu Sharks NEI
- Description source: split de paper_shark_longline_catch (voir note ci-dessus) + paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.3389/fmars.2022.1062447
- Dataset DOI: 10.25349/d9789w
- Source URL: https://doi.org/10.25349/d9789w
- Local raw dir: `data/raw/papers/DatasetFirst_10_25349_d9789w/`
- Local sf output: `data/final_datasets/sf/paper_shark_longline_catch_sharks_nei.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `catch`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `year`, `mean_sst`, `mean_chla`, `mean_ssh`, `sdm`, `target_effort`, `median_price_species`, `median_price_group`
- Candidate X count in local artifact: 8
- Candidate X typology: unknown, continuous, rate
- Published X variables from paper: mean_sst (temperature de surface de la mer moyenne), mean_chla (chlorophylle-a moyenne), mean_ssh (hauteur de surface de la mer moyenne), sdm (score de modele de distribution d'espece, covariable d'entree du RF), target_effort (effort de peche par pavillon), median_price_species (prix ex-vessel median par espece)
- Published X count: 6
- Coordinates (x, y - excluded from X candidates): `longitude`, `latitude`
- Identifier columns (excluded from X candidates): `pres_abs`, `site_id`
- Variables inspected: yes (split de paper_shark_longline_catch, herite de generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `catch` | `numeric` | continuous | voir paper_shark_longline_catch (heritee, non recalculee pour ce sous-jeu) | 0% |

> Selection Y/X (heritee du jeu parent) : identique a [[paper_shark_longline_catch]] -- `species_commonname` retire de X (constant dans ce sous-jeu, jamais dans formula_used du parent de toute facon). Statut benchmark actuel : ready; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `year` | `integer` | unknown | 0% |
| `mean_sst` | `numeric` | continuous | heritee du parent |
| `mean_chla` | `numeric` | continuous | heritee du parent |
| `mean_ssh` | `numeric` | rate | heritee du parent |
| `sdm` | `numeric` | rate | heritee du parent |
| `target_effort` | `numeric` | continuous | heritee du parent |
| `median_price_species` | `numeric` | continuous | heritee du parent |
| `median_price_group` | `numeric` | continuous | heritee du parent |

### Formule - niveau publication

- formula_pub: catch ~ sdm + mean_sst + mean_chla + effort + [combinaisons de mean_ssh, cv_sst, cv_chla, cv_ssh, prix ex-vessel] [modele Random Forest a deux composantes, ajuste separement par espece et par ORGP (ICCAT/IOTC/IATTC/WCPFC) -- voir [[paper_shark_longline_catch]] pour la citation complete]
- x_terms_pub: mean_sst, mean_chla, mean_ssh, sdm, target_effort, median_price_species
- y_term_pub: catch (capture de Sharks NEI, ICCAT -- Atlantique)
- Reference publication: Burns, Bradley & Thomas (2023), Global hotspots of shark interactions with industrial longline fisheries, Frontiers in Marine Science, doi:10.3389/fmars.2022.1062447 -- voir [[paper_shark_longline_catch]] pour le detail complet de la methodologie. Ce sous-jeu isole Sharks NEI (session 2026-09-23, split_shark_longline_catch.R) pour rendre le panel (site, annee) unique, condition necessaire a benchmark_spatial_panel().

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: heritee de [[paper_shark_longline_catch]], species_commonname retire (constant dans ce sous-jeu).

### Formule - niveau systeme

- formula_used: catch ~ mean_sst + mean_chla + mean_ssh + sdm + target_effort + median_price_species
- License evidence: DataCite API record for DOI 10.25349/d9789w (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Recommended validation: N lignes=2148; T declare=9; variable temporelle declaree=year. Grouper les observations du meme site dans un seul fold, et respecter la chronologie si l'objectif est prospectif.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used.
- Selected Y typology: continuous
- x_terms_used: mean_sst, mean_chla, mean_ssh, sdm, target_effort, median_price_species
- y_term_used: catch
- Note: heritee de [[paper_shark_longline_catch]].

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
    response: "catch (capture de Sharks NEI, ICCAT -- Atlantique)"
    predictors: ["mean_sst", "mean_chla", "mean_ssh", "sdm", "target_effort", "median_price_species"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir [[paper_shark_longline_catch]] Bloc 1 - Formule et variables > Reference publication."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr", "panel_fe", "panel_sar_fe", "panel_sem_fe", "panel_sac_fe"]
    status: "confirmed"

  ml_or_selected:
    formula: "catch ~ mean_sst + mean_chla + mean_ssh + sdm + target_effort + median_price_species"
    response: "catch"
    predictors: ["mean_sst", "mean_chla", "mean_ssh", "sdm", "target_effort", "median_price_species"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir [[paper_shark_longline_catch]] Bloc 1 - Formule et variables > Reference publication."
    estimator_context: ["random_forest", "random_forest_xy", "xgboost", "gam_spatial", "gwr"]
    status: "executable_continuous_variant"
```

### Panel spatial - structure et W

- Data structure: spatial_panel
- Panel unit: site_id
- Panel time: year
- N units: 300
- N periods: 9
- Panel balance: unbalanced
- Panel effect: individual
- W level: unit
- W time varying: no
- W file: `data/final_datasets/weights/paper_shark_longline_catch_W.rds`
- W unit order source: identique a [[paper_shark_longline_catch]] -- meme W reutilisee telle quelle (les 300 sites sont exactement les memes dans les 4 sous-jeux espece, seule la reponse `catch`/`pres_abs` varie). kNN k=8 (defaut du projet, spatial_knn_args()) -- voir code/r_catalog/build_shark_longline_catch_panel_W.R
- Prediction target: fit_only
- Supported resampling: panel_full_fit

Session du 2026-09-23 : sous-jeu cree pour resoudre un conflit d'unicite (site, annee) trouve en testant `validate_spatial_panel_data()` sur le jeu parent (4 lignes/couple, une par espece). Le papier source entraine un modele separe par espece -- ce decoupage suit leur propre approche (voir note en tete de fiche). `validate_spatial_panel_data()` verifie OK sur ce sous-jeu (300 unites, 9 periodes, desequilibre).

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_shark_longline_catch_sharks_nei`
- Dataset name: Global hotspots of shark interactions with industrial longline fisheries -- Sharks NEI
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI) -- sous-jeu de [[paper_shark_longline_catch]]
- Paper title: Global hotspots of shark interactions with industrial longline fisheries
- Paper DOI: 10.3389/fmars.2022.1062447
- Dataset DOI: 10.25349/d9789w
- Source URL: https://doi.org/10.25349/d9789w
- Year: 2023

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "catch ~ sdm + mean_sst + mean_chla + effort + [combinaisons de mean_ssh, cv_sst, cv_chla, cv_ssh, prix ex-vessel] [modele Random Forest a deux composantes, ajuste separement par espece et par ORGP -- voir [[paper_shark_longline_catch]]]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Burns, Bradley & Thomas (2023), doi:10.3389/fmars.2022.1062447 -- voir [[paper_shark_longline_catch]] pour la citation complete. Ce sous-jeu isole Sharks NEI (session 2026-09-23)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous_panel"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun -- sous-jeu derive de paper_shark_longline_catch (deja ready), split par espece pour resoudre l'unicite (site, annee) requise par le harnais panel"
  reason: "Herite l'eligibilite de [[paper_shark_longline_catch]] ; le split par espece (session 2026-09-23) suit l'approche des auteurs (modele separe par espece) et rend le panel (site, annee) unique, condition necessaire a benchmark_spatial_panel_dataset()."
```

- Decision: ready
- Manque principal: aucun
- Raison: Herite l'eligibilite de [[paper_shark_longline_catch]] ; split par espece necessaire pour le harnais panel (voir Panel spatial - structure et W).

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready"
  eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy", "sar_lag", "sem_error", "sdm_mixed", "gwr", "panel_fe", "panel_sar_fe", "panel_sem_fe", "panel_sac_fe"]
  conditionally_eligible_estimators: []
  ineligible_reason: ""
  rule: "Herite de [[paper_shark_longline_catch]] ; panel_fe/panel_sar_fe/panel_sem_fe/panel_sac_fe ajoutes suite au wiring panel du 2026-09-23 (W kNN=8 inventee par le projet, aucune methode publiee -- voir Panel spatial - structure et W)."
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 2148
- k variables: 16
- T periods: 9
- Variable temporelle: year
- N/T profile: N_grand_T_moyen
- Note N/T (session 2026-09-23, split du jeu parent) : "N observations" (2148) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel = 300 (identique au parent, meme ensemble de sites) ; panel NON EQUILIBRE (T par unite : min=1, mediane=9, max=9 -- herite du parent, la ventilation par espece preserve la meme couverture site-annee). Construire W sur les 300 unites spatiales distinctes (deja fait, W partagee avec le parent et les 3 autres sous-jeux espece).

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation (support reel : cellule de grille de 5x5 degres)
- Temporal resolution: 9 distinct periods (variable: year)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-95, 30], y [-55, 60]
- Time range: 2012 to 2020 (variable: year)
- CRS analyse recommande: pending — etendue continentale/mondiale (span=125deg) -- projection nationale non pertinente ; privilegier une projection equal-area continentale ou mondiale (ex: Albers equal-area continental, Behrmann/Mollweide pour une couverture mondiale)

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- Reproducibility status: OK - script de split enregistre et reexecutable (`code/r_catalog/split_shark_longline_catch.R`, lit paper_shark_longline_catch.rds et filtre sur species_commonname="SHARKS NEI") ; source brute tracee dans inst/kg/paper_dataset_uses.json via le jeu parent.
- Code available: yes (`code/r_catalog/split_shark_longline_catch.R` ; loader parent `shark_longline_catch` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche adaptee du format Bloc 1-6 du jeu parent [[paper_shark_longline_catch]].
- Variables: OK - heritees du jeu parent, species_commonname retire (constant).
- Formula: OK - identique au parent, executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326), herite du parent.
- Geometry: OK - type geometrique controle (POINT), herite du parent.
- Missing values: OK - heritee du parent (aucune variable avec NA > 20% detectee).
- Duplicates: OK - verifie 2026-09-23 : aucun couple (site_id, year) duplique dans ce sous-jeu (`validate_spatial_panel_data()` PASS).
- Reproducibility: OK - script de split enregistre et reexecutable.

## Related Pages

- [[paper_shark_longline_catch]] -- jeu parent, methodologie complete
- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Global hotspots of shark interactions with industrial longline fisheries
