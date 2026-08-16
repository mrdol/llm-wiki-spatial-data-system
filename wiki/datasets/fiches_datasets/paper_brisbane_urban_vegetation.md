---
title: paper_brisbane_urban_vegetation
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_brisbane_urban_vegetation.rds
  - DatasetFirst_10_5061_dryad_3bh66
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "[dataset-first, publication non resolue] Data from: Landscape structure influences urban vegetation vertical structure" (DOI unknown).

## Description du jeu de donnees

- Topic: ecologie urbaine / structure verticale de la vegetation
- Observation unit: cellule de grille (1ha)
- Observed population: cellules urbaines, Brisbane, Australie, N=63142
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: [dataset-first, publication non resolue] Data from: Landscape structure influences urban vegetation vertical structure
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: unknown
- Dataset DOI: 10.5061/dryad.3bh66
- Source URL: https://doi.org/10.5061/dryad.3bh66
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_3bh66/`
- Local sf output: `data/final_datasets/sf/paper_brisbane_urban_vegetation.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `dens_015_1`
- Candidate Y typology: rate
- Candidate X variables in local artifact: `aspect_cos`, `aspect_sin`, `water_cap`, `dens_1_2`, `dens_2_5`, `dens_5_10`, `dens_above10`, `elev`, `fpc`, `ht_p95`, `mb_dwel_dens`, `sa1_avghouse`, `sa1_medage`, `sa1_medtothinc`, `slope`, `soc`, `tot_n`, `tot_p`, `tree_area`, `clumpy`, `number_patches`, `perimeter_area_mn`, `park_prop`, `lot_size`, `road_length`, `prop_noncauc`
- Candidate X count in local artifact: 26
- Candidate X typology: continuous
- Published X variables from paper: tree_area (proportion de couvert arbore dans la cellule), aspect_cos (composante nord-sud de l'orientation du terrain), aspect_sin (composante est-ouest de l'orientation du terrain), slope (pente du terrain, degres)
- Published X count: 4
- Coordinates (x, y - excluded from X candidates): `x`, `y`
- Identifier columns (excluded from X candidates): `cell`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `dens_015_1` | `numeric` | rate | [0, 0.9189] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `brisbane_urban_vegetation`, la ou les reponses `dens_015_1` viennent du loader papier et/ou des preuves de l article `[dataset-first, publication non resolue] Data from: Landscape structure influences urban vegetation vertical structure`. Les covariables X retenues sont `tree_area`, `aspect_cos`, `aspect_sin`, `slope` ; 22 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`x`, `y`), identifiants (`cell`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `aspect_cos` | `numeric` | continuous | 0% |
| `aspect_sin` | `numeric` | continuous | 0% |
| `water_cap` | `numeric` | continuous | 1.2% |
| `dens_1_2` | `numeric` | rate | 5% |
| `dens_2_5` | `numeric` | rate | 5% |
| `dens_5_10` | `numeric` | rate | 5% |
| `dens_above10` | `numeric` | rate | 5% |
| `elev` | `numeric` | continuous | 0% |
| `fpc` | `numeric` | continuous | 3% |
| `ht_p95` | `numeric` | continuous | 5.2% |
| `mb_dwel_dens` | `numeric` | continuous | 0.2% |
| `sa1_avghouse` | `numeric` | continuous | 11.4% |
| `sa1_medage` | `numeric` | continuous | 11.4% |
| `sa1_medtothinc` | `numeric` | continuous | 11.4% |
| `slope` | `numeric` | continuous | 0% |
| `soc` | `numeric` | continuous | 1.2% |
| `tot_n` | `numeric` | rate | 1.2% |
| `tot_p` | `numeric` | rate | 1.2% |
| `tree_area` | `numeric` | rate | 0% |
| `clumpy` | `numeric` | continuous | 0% |
| `number_patches` | `integer` | count | 0% |
| `perimeter_area_mn` | `numeric` | continuous | 0% |
| `park_prop` | `numeric` | continuous | 0% |
| `lot_size` | `numeric` | continuous | 0% |
| `road_length` | `numeric` | continuous | 0% |
| `prop_noncauc` | `numeric` | rate | 11.4% |

### Formule - niveau publication

- formula_pub: log(dens_015_1+0.01) ~ poly(tree_area,2) + poly(aspect_cos,2) + poly(aspect_sin,2) + poly(slope,2) [modele SAR mixte (lagsarlm), poids de voisinage a 150m -- Mitchell, Wu, Johansen, Maron, McAlpine & Rhodes (2016), 'Landscape structure influences urban vegetation vertical structure', doi:10.1111/1365-2664.12741 (OpenAlex-linked publication non resolue dans le KG). Formule confirmee par lecture directe du script R original des auteurs (Mitchell_etal_2016_1ha_analysis_20160624.R, present dans le meme depot Dryad) -- meilleur modele combine (selection par AICc/model averaging) pour la strate de densite de vegetation 0.15-1m]
- x_terms_pub: tree_area (proportion de couvert arbore dans la cellule), aspect_cos (composante nord-sud de l'orientation du terrain), aspect_sin (composante est-ouest de l'orientation du terrain), slope (pente du terrain, degres)
- y_term_pub: dens_015_1 (densite de vegetation entre 0.15 et 1m de hauteur, proportion, transformee log(x+0.01) dans le papier)
- Reference publication: Publication liee identifiee automatiquement via OpenAlex dans le manifeste (10.1111/1365-2664.12741, Journal of Applied Ecology) et confirmee par lecture directe du script R original des auteurs, present dans le meme depot Dryad (Mitchell_etal_2016_1ha_analysis_20160624.R) -- le script ajuste des modeles SAR mixtes (lagsarlm, poids de voisinage dnearneigh a 150m) pour 5 strates de hauteur de vegetation (0.15-1m, 1-2m, 2-5m, 5-10m, >10m), chacune avec un jeu de covariables physiques/pedologiques/demographiques/urbaines/paysageres teste separement puis combine. Le meilleur modele combine pour la strate 0.15-1m (retenu par model averaging/dredge, m.max=4) inclut tree_area, aspect_cos, aspect_sin et slope -- formula_used simplifie les termes polynomiaux (poly(x,2)) en lineaire et omet la structure SAR (poids spatiaux 150m), une simplification documentee, pas la specification exacte du papier. CSV original (Mitchell_etal_data_1ha_20160627.csv) telecharge directement depuis Dryad -- pas une reconstruction, N=63142 cellules de grille 1ha (Brisbane, Australie, coordonnees UTM MGA zone 56 verifiees coherentes).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Publication liee identifiee automatiquement via OpenAlex dans le manifeste (10.1111/1365-2664.12741, Journal of Applied Ecology) et confirmee par lecture directe du script R original des auteurs, present dans le meme depot Dryad (Mitchell_etal_2016_1ha_analysis_20160624.R) -- le script ajuste des modeles SAR mixtes (lagsarlm, poids de voisinage dnearneigh a 150m) pour 5 strates de hauteur de vegetation (0.15-1m, 1-2m, 2-5m, 5-10m, >10m), chacune avec un jeu de covariables physiques/pedologiques/demographiques/urbaines/paysageres teste separement puis combine. Le meilleur modele combine pour la strate 0.15-1m (retenu par model averaging/dredge, m.max=4) inclut tree_area, aspect_cos, aspect_sin et slope -- formula_used simplifie les termes polynomiaux (poly(x,2)) en lineaire et omet la structure SAR (poids spatiaux 150m), une simplification documentee, pas la specification exacte du papier. CSV original (Mitchell_etal_data_1ha_20160627.csv) telecharge directement depuis Dryad -- pas une reconstruction, N=63142 cellules de grille 1ha (Brisbane, Australie, coordonnees UTM MGA zone 56 verifiees coherentes).

### Formule - niveau systeme

- formula_used: dens_015_1 ~ tree_area + aspect_cos + aspect_sin + slope
- x_terms_used: tree_area, aspect_cos, aspect_sin, slope
- y_term_used: dens_015_1
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Publication liee identifiee automatiquement via OpenAlex dans le manifeste (10.1111/1365-2664.12741, Journal of Applied Ecology) et confirmee par lecture directe du script R original des auteurs, present dans le meme depot Dryad (Mitchell_etal_2016_1ha_analysis_20160624.R) -- le script ajuste des modeles SAR mixtes (lagsarlm, poids de voisinage dnearneigh a 150m) pour 5 strates de hauteur de vegetation (0.15-1m, 1-2m, 2-5m, 5-10m, >10m), chacune avec un jeu de covariables physiques/pedologiques/demographiques/urbaines/paysageres teste separement puis combine. Le meilleur modele combine pour la strate 0.15-1m (retenu par model averaging/dredge, m.max=4) inclut tree_area, aspect_cos, aspect_sin et slope -- formula_used simplifie les termes polynomiaux (poly(x,2)) en lineaire et omet la structure SAR (poids spatiaux 150m), une simplification documentee, pas la specification exacte du papier. CSV original (Mitchell_etal_data_1ha_20160627.csv) telecharge directement depuis Dryad -- pas une reconstruction, N=63142 cellules de grille 1ha (Brisbane, Australie, coordonnees UTM MGA zone 56 verifiees coherentes).

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
    formula: "dens_015_1 ~ tree_area + aspect_cos + aspect_sin + slope"
    response: "dens_015_1 (densite de vegetation entre 0.15 et 1m de hauteur, proportion, transformee log(x+0.01) dans le papier)"
    predictors: ["tree_area (proportion de couvert arbore dans la cellule)", "aspect_cos (composante nord-sud de l'orientation du terrain)", "aspect_sin (composante est-ouest de l'orientation du terrain)", "slope (pente du terrain, degres)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Publication liee identifiee automatiquement via OpenAlex dans le manifeste (10.1111/1365-2664.12741, Journal of Applied Ecology) et confirmee par lecture directe du script R original des auteurs, present dans le meme depot Dryad (Mitchell_etal_2016_1ha_analysis_20160624.R) -- le script ajuste des modeles SAR mixtes (lagsarlm, poids de voisinage dnearneigh a 150m) pour 5 strates de hauteur de vegetation (0.15-1m, 1-2m, 2-5m, 5-10m, >10m), chacune avec un jeu de covariables physiques/pedologiques/demographiques/urbaines/paysageres teste separement puis combine. Le meilleur modele combine pour la strate 0.15-1m (retenu par model averaging/dredge, m.max=4) inclut tree_area, aspect_cos, aspect_sin et slope -- formula_used simplifie les termes polynomiaux (poly(x,2)) en lineaire et omet la structure SAR (poids spatiaux 150m), une simplification documentee, pas la specification exacte du papier. CSV original (Mitchell_etal_data_1ha_20160627.csv) telecharge directement depuis Dryad -- pas une reconstruction, N=63142 cellules de grille 1ha (Brisbane, Australie, coordonnees UTM MGA zone 56 verifiees coherentes)."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "dens_015_1 ~ tree_area + aspect_cos + aspect_sin + slope + mb_dwel_dens + park_prop + sa1_medtothinc"
    response: "dens_015_1"
    predictors: ["tree_area", "aspect_cos", "aspect_sin", "slope", "mb_dwel_dens", "park_prop", "sa1_medtothinc"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Publication liee identifiee automatiquement via OpenAlex dans le manifeste (10.1111/1365-2664.12741, Journal of Applied Ecology) et confirmee par lecture directe du script R original des auteurs, present dans le meme depot Dryad (Mitchell_etal_2016_1ha_analysis_20160624.R) -- le script ajuste des modeles SAR mixtes (lagsarlm, poids de voisinage dnearneigh a 150m) pour 5 strates de hauteur de vegetation (0.15-1m, 1-2m, 2-5m, 5-10m, >10m), chacune avec un jeu de covariables physiques/pedologiques/demographiques/urbaines/paysageres teste separement puis combine. Le meilleur modele combine pour la strate 0.15-1m (retenu par model averaging/dredge, m.max=4) inclut tree_area, aspect_cos, aspect_sin et slope -- formula_used simplifie les termes polynomiaux (poly(x,2)) en lineaire et omet la structure SAR (poids spatiaux 150m), une simplification documentee, pas la specification exacte du papier. CSV original (Mitchell_etal_data_1ha_20160627.csv) telecharge directement depuis Dryad -- pas une reconstruction, N=63142 cellules de grille 1ha (Brisbane, Australie, coordonnees UTM MGA zone 56 verifiees coherentes)."
    estimator_context: ["ols", "sar_lag", "sar_mixed", "gwr", "random_forest"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_brisbane_urban_vegetation`
- Dataset name: Data from: Landscape structure influences urban vegetation vertical structure
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: [dataset-first, publication non resolue] Data from: Landscape structure influences urban vegetation vertical structure
- Paper DOI: unknown
- Dataset DOI: 10.5061/dryad.3bh66
- Source URL: https://doi.org/10.5061/dryad.3bh66
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "log(dens_015_1+0.01) ~ poly(tree_area,2) + poly(aspect_cos,2) + poly(aspect_sin,2) + poly(slope,2) [modele SAR mixte (lagsarlm), poids de voisinage a 150m -- Mitchell, Wu, Johansen, Maron, McAlpine & Rhodes (2016), 'Landscape structure influences urban vegetation vertical structure', doi:10.1111/1365-2664.12741 (OpenAlex-linked publication non resolue dans le KG). Formule confirmee par lecture directe du script R original des auteurs (Mitchell_etal_2016_1ha_analysis_20160624.R, present dans le meme depot Dryad) -- meilleur modele combine (selection par AICc/model averaging) pour la strate de densite de vegetation 0.15-1m]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Publication liee identifiee automatiquement via OpenAlex dans le manifeste (10.1111/1365-2664.12741, Journal of Applied Ecology) et confirmee par lecture directe du script R original des auteurs, present dans le meme depot Dryad (Mitchell_etal_2016_1ha_analysis_20160624.R) -- le script ajuste des modeles SAR mixtes (lagsarlm, poids de voisinage dnearneigh a 150m) pour 5 strates de hauteur de vegetation (0.15-1m, 1-2m, 2-5m, 5-10m, >10m), chacune avec un jeu de covariables physiques/pedologiques/demographiques/urbaines/paysageres teste separement puis combine. Le meilleur modele combine pour la strate 0.15-1m (retenu par model averaging/dredge, m.max=4) inclut tree_area, aspect_cos, aspect_sin et slope -- formula_used simplifie les termes polynomiaux (poly(x,2)) en lineaire et omet la structure SAR (poids spatiaux 150m), une simplification documentee, pas la specification exacte du papier. CSV original (Mitchell_etal_data_1ha_20160627.csv) telecharge directement depuis Dryad -- pas une reconstruction, N=63142 cellules de grille 1ha (Brisbane, Australie, coordonnees UTM MGA zone 56 verifiees coherentes)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "formula_used simplifie les termes polynomiaux (poly(x,2)) du meilleur modele combine en lineaire et omet la structure SAR (poids spatiaux a 150m) du papier original -- simplification documentee"
  reason: "Y continu reel (dens_015_1, densite de vegetation basse), N=63142 cellules de grille 1ha (Brisbane, Australie) avec coordonnees reelles. CSV original telecharge directement depuis Dryad, pas une reconstruction. Formule confirmee par lecture directe du script R original des auteurs (present dans le meme depot), publication liee identifiee automatiquement via OpenAlex (Mitchell et al. 2016, J. Appl. Ecol., doi:10.1111/1365-2664.12741)."
```

- Decision: ready
- Manque principal: formula_used simplifie les termes polynomiaux (poly(x,2)) du meilleur modele combine en lineaire et omet la structure SAR (poids spatiaux a 150m) du papier original -- simplification documentee
- Raison: Y continu reel (dens_015_1, densite de vegetation basse), N=63142 cellules de grille 1ha (Brisbane, Australie) avec coordonnees reelles. CSV original telecharge directement depuis Dryad, pas une reconstruction. Formule confirmee par lecture directe du script R original des auteurs (present dans le meme depot), publication liee identifiee automatiquement via OpenAlex (Mitchell et al. 2016, J. Appl. Ecol., doi:10.1111/1365-2664.12741).

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
- N observations: 63142
- k variables: 32
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 28356
- CRS nom: GDA94 / MGA zone 56
- Spatial extent: x [474375.5284, 518275.5284], y [6942482, 6982382]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`brisbane_urban_vegetation` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `brisbane_urban_vegetation` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (28356).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`brisbane_urban_vegetation` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: [dataset-first, publication non resolue] Data from: Landscape structure influences urban vegetation vertical structure

