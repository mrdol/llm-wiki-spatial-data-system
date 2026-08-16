---
title: paper_gcfr_soil
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_gcfr_soil.rds
  - DatasetFirst_10_5061_dryad_37qc017
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "New regionally modelled soil layers improve prediction of vegetation type relative to that based on global soil models" (DOI 10.1111/ddi.12973).

## Description du jeu de donnees

- Topic: pedologie / cartographie regionale du sol
- Observation unit: point d'echantillonnage de sol
- Observed population: Greater Cape Floristic Region, Afrique du Sud, N=2767 points
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: New regionally modelled soil layers improve prediction of vegetation type relative to that based on global soil models
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/ddi.12973
- Dataset DOI: 10.5061/dryad.37qc017
- Source URL: https://doi.org/10.5061/dryad.37qc017
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_37qc017/`
- Local sf output: `data/final_datasets/sf/paper_gcfr_soil.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `N_total_.`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `pH_H2O`, `pH_extract`, `EC_mS.m`, `CEC_cmol.kg`, `H._cmol.kg`, `Total_exchangable_cations_cmol.kg`, `K_extractable_cmol....kg`, `Na_extractable_cmol....kg`, `P_extractable_mg.kg`, `P_total_mg.kg`, `C_organic_.`, `C_total_.`
- Candidate X count in local artifact: 12
- Candidate X typology: continuous
- Published X variables from paper: pH_extract (pH du sol par extraction, meilleure couverture que pH_H2O), C_total_. (carbone total du sol, %, correlat classique de l'azote)
- Published X count: 2
- Coordinates (x, y - excluded from X candidates): `Lon_deg`, `Lat_deg`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `N_total_.` | `numeric` | continuous | [0.0084, 1.14] | 20.7% |

> Selection Y/X (paper-loader / curated evidence) : Pour `gcfr_soil`, la ou les reponses `N_total_.` viennent du loader papier et/ou des preuves de l article `New regionally modelled soil layers improve prediction of vegetation type relative to that based on global soil models`. Les covariables X retenues sont `pH_extract`, `C_total_.` ; 10 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Lon_deg`, `Lat_deg`), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `pH_H2O` | `numeric` | continuous | 98.9% |
| `pH_extract` | `numeric` | continuous | 9.6% |
| `EC_mS.m` | `numeric` | continuous | 70.8% |
| `CEC_cmol.kg` | `numeric` | continuous | 89% |
| `H._cmol.kg` | `numeric` | continuous | 82.1% |
| `Total_exchangable_cations_cmol.kg` | `numeric` | continuous | 98.6% |
| `K_extractable_cmol....kg` | `numeric` | continuous | 59.5% |
| `Na_extractable_cmol....kg` | `numeric` | continuous | 59.6% |
| `P_extractable_mg.kg` | `numeric` | continuous | 58% |
| `P_total_mg.kg` | `numeric` | continuous | 84.4% |
| `C_organic_.` | `numeric` | continuous | 96% |
| `C_total_.` | `numeric` | continuous | 20.5% |

### Formule - niveau publication

- formula_pub: [Pas de regression Y~X unique dans le papier pour cette table -- les echantillons ponctuels de sol servent d'entree a une interpolation spatiale (krigeage/apprentissage automatique avec covariables environnementales, dans la lignee de SoilGrids) produisant des couches regionales de sol, elles-memes utilisees comme covariables dans un modele separe de prediction du type de vegetation (non inclus dans ce depot)]
- x_terms_pub: pH_extract (pH du sol par extraction, meilleure couverture que pH_H2O), C_total_. (carbone total du sol, %, correlat classique de l'azote)
- y_term_pub: N_total_. (azote total du sol, %) -- reponse choisie pour ce benchmark parmi les proprietes de sol mesurees (le papier n'ayant pas de formule Y~X unique pour cette table de points) ; N_total_. retenue plutot que pH_H2O ou C_organic_. car ces deux dernieres n'ont que 31/2767 et 110/2767 valeurs non-NA respectivement (0 cas complets avec les autres covariables candidates), rendant toute regression non executable -- N_total_. a 2195/2767 valeurs non-NA (79%) et 1927 cas complets avec pH_extract + C_total_.
- Reference publication: Cramer, M.D. & Verboom, G.A. (2019), New regionally modelled soil layers improve prediction of vegetation type relative to that based on global soil models, Diversity and Distributions, doi:10.1111/ddi.12973. CSV original (GCFR_soil.csv) telecharge directement depuis Dryad (10.5061/dryad.37qc017) -- pas une reconstruction, N=2767 points d'echantillonnage de sol (Greater Cape Floristic Region, Afrique du Sud). Le papier utilise ces points pour interpoler des couches de sol regionales (methode SoilGrids ameliore), elles-memes covariables d'un modele separe de type de vegetation non inclus dans ce depot -- formula_used est une reformulation raisonnable en regression continue (N_total_. ~ pH_extract + C_total_.), documentee comme telle, pas la formule publiee du papier. Verification empirique (session 2026-08-16) : 1927/2767 cas complets pour ce triplet (contre 0 cas complets pour la formule initiale pH_H2O ~ 7 covariables, pH_H2O n'ayant que 31 valeurs non-NA).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Cramer, M.D. & Verboom, G.A. (2019), New regionally modelled soil layers improve prediction of vegetation type relative to that based on global soil models, Diversity and Distributions, doi:10.1111/ddi.12973. CSV original (GCFR_soil.csv) telecharge directement depuis Dryad (10.5061/dryad.37qc017) -- pas une reconstruction, N=2767 points d'echantillonnage de sol (Greater Cape Floristic Region, Afrique du Sud). Le papier utilise ces points pour interpoler des couches de sol regionales (methode SoilGrids ameliore), elles-memes covariables d'un modele separe de type de vegetation non inclus dans ce depot -- formula_used est une reformulation raisonnable en regression continue (N_total_. ~ pH_extract + C_total_.), documentee comme telle, pas la formule publiee du papier. Verification empirique (session 2026-08-16) : 1927/2767 cas complets pour ce triplet (contre 0 cas complets pour la formule initiale pH_H2O ~ 7 covariables, pH_H2O n'ayant que 31 valeurs non-NA).

### Formule - niveau systeme

- formula_used: N_total_. ~ pH_extract + C_total_.
- x_terms_used: pH_extract, C_total_.
- y_term_used: N_total_.
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Cramer, M.D. & Verboom, G.A. (2019), New regionally modelled soil layers improve prediction of vegetation type relative to that based on global soil models, Diversity and Distributions, doi:10.1111/ddi.12973. CSV original (GCFR_soil.csv) telecharge directement depuis Dryad (10.5061/dryad.37qc017) -- pas une reconstruction, N=2767 points d'echantillonnage de sol (Greater Cape Floristic Region, Afrique du Sud). Le papier utilise ces points pour interpoler des couches de sol regionales (methode SoilGrids ameliore), elles-memes covariables d'un modele separe de type de vegetation non inclus dans ce depot -- formula_used est une reformulation raisonnable en regression continue (N_total_. ~ pH_extract + C_total_.), documentee comme telle, pas la formule publiee du papier. Verification empirique (session 2026-08-16) : 1927/2767 cas complets pour ce triplet (contre 0 cas complets pour la formule initiale pH_H2O ~ 7 covariables, pH_H2O n'ayant que 31 valeurs non-NA).

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
    formula: "N_total_. ~ pH_extract + C_total_."
    response: "N_total_. (azote total du sol, %) -- reponse choisie pour ce benchmark parmi les proprietes de sol mesurees (le papier n'ayant pas de formule Y~X unique pour cette table de points) ; N_total_. retenue plutot que pH_H2O ou C_organic_. car ces deux dernieres n'ont que 31/2767 et 110/2767 valeurs non-NA respectivement (0 cas complets avec les autres covariables candidates), rendant toute regression non executable -- N_total_. a 2195/2767 valeurs non-NA (79%) et 1927 cas complets avec pH_extract + C_total_."
    predictors: ["pH_extract (pH du sol par extraction, meilleure couverture que pH_H2O)", "C_total_. (carbone total du sol, %, correlat classique de l'azote)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Cramer, M.D. & Verboom, G.A. (2019), New regionally modelled soil layers improve prediction of vegetation type relative to that based on global soil models, Diversity and Distributions, doi:10.1111/ddi.12973. CSV original (GCFR_soil.csv) telecharge directement depuis Dryad (10.5061/dryad.37qc017) -- pas une reconstruction, N=2767 points d'echantillonnage de sol (Greater Cape Floristic Region, Afrique du Sud). Le papier utilise ces points pour interpoler des couches de sol regionales (methode SoilGrids ameliore), elles-memes covariables d'un modele separe de type de vegetation non inclus dans ce depot -- formula_used est une reformulation raisonnable en regression continue (N_total_. ~ pH_extract + C_total_.), documentee comme telle, pas la formule publiee du papier. Verification empirique (session 2026-08-16) : 1927/2767 cas complets pour ce triplet (contre 0 cas complets pour la formule initiale pH_H2O ~ 7 covariables, pH_H2O n'ayant que 31 valeurs non-NA)."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "N_total_. ~ pH_extract + C_total_."
    response: "N_total_."
    predictors: ["pH_extract", "C_total_."]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Cramer, M.D. & Verboom, G.A. (2019), New regionally modelled soil layers improve prediction of vegetation type relative to that based on global soil models, Diversity and Distributions, doi:10.1111/ddi.12973. CSV original (GCFR_soil.csv) telecharge directement depuis Dryad (10.5061/dryad.37qc017) -- pas une reconstruction, N=2767 points d'echantillonnage de sol (Greater Cape Floristic Region, Afrique du Sud). Le papier utilise ces points pour interpoler des couches de sol regionales (methode SoilGrids ameliore), elles-memes covariables d'un modele separe de type de vegetation non inclus dans ce depot -- formula_used est une reformulation raisonnable en regression continue (N_total_. ~ pH_extract + C_total_.), documentee comme telle, pas la formule publiee du papier. Verification empirique (session 2026-08-16) : 1927/2767 cas complets pour ce triplet (contre 0 cas complets pour la formule initiale pH_H2O ~ 7 covariables, pH_H2O n'ayant que 31 valeurs non-NA)."
    estimator_context: ["gwr", "kriging", "random_forest", "ols"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_gcfr_soil`
- Dataset name: Data from: New regionally modelled soil layers improve prediction of vegetation type relative to that based on global soil models
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: New regionally modelled soil layers improve prediction of vegetation type relative to that based on global soil models
- Paper DOI: 10.1111/ddi.12973
- Dataset DOI: 10.5061/dryad.37qc017
- Source URL: https://doi.org/10.5061/dryad.37qc017
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "[Pas de regression Y~X unique dans le papier pour cette table -- les echantillons ponctuels de sol servent d'entree a une interpolation spatiale (krigeage/apprentissage automatique avec covariables environnementales, dans la lignee de SoilGrids) produisant des couches regionales de sol, elles-memes utilisees comme covariables dans un modele separe de prediction du type de vegetation (non inclus dans ce depot)]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Cramer, M.D. & Verboom, G.A. (2019), New regionally modelled soil layers improve prediction of vegetation type relative to that based on global soil models, Diversity and Distributions, doi:10.1111/ddi.12973. CSV original (GCFR_soil.csv) telecharge directement depuis Dryad (10.5061/dryad.37qc017) -- pas une reconstruction, N=2767 points d'echantillonnage de sol (Greater Cape Floristic Region, Afrique du Sud). Le papier utilise ces points pour interpoler des couches de sol regionales (methode SoilGrids ameliore), elles-memes covariables d'un modele separe de type de vegetation non inclus dans ce depot -- formula_used est une reformulation raisonnable en regression continue (N_total_. ~ pH_extract + C_total_.), documentee comme telle, pas la formule publiee du papier. Verification empirique (session 2026-08-16) : 1927/2767 cas complets pour ce triplet (contre 0 cas complets pour la formule initiale pH_H2O ~ 7 covariables, pH_H2O n'ayant que 31 valeurs non-NA)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "le papier n'a pas de formule Y~X unique pour cette table de points d'echantillonnage (utilisee pour interpolation spatiale de couches de sol, pas pour une regression directe) -- formula_used (N_total_. ~ pH_extract + C_total_.) est une reformulation raisonnable documentee comme telle, pas la specification publiee -- promu a package_include='yes' apres validation utilisateur (session 2026-08-16, groupe A)"
  reason: "Y continu reel (N_total_., azote total du sol), N=2767 points d'echantillonnage avec coordonnees reelles, 1927 cas complets pour la formule retenue (79% de couverture sur N_total_.). CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) : la table sert d'entree a une interpolation spatiale, pas a une regression Y~X du papier -- reformulation transparente en regression continue pour ce benchmark. Y initial (pH_H2O) ecarte car seulement 31/2767 valeurs non-NA (0 cas complets avec les covariables), non executable."
```

- Decision: ready
- Manque principal: le papier n'a pas de formule Y~X unique pour cette table de points d'echantillonnage (utilisee pour interpolation spatiale de couches de sol, pas pour une regression directe) -- formula_used (N_total_. ~ pH_extract + C_total_.) est une reformulation raisonnable documentee comme telle, pas la specification publiee -- promu a package_include="yes" apres validation utilisateur (session 2026-08-16, groupe A)
- Raison: Y continu reel (N_total_., azote total du sol), N=2767 points d'echantillonnage avec coordonnees reelles, 1927 cas complets pour la formule retenue (79% de couverture sur N_total_.). CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) : la table sert d'entree a une interpolation spatiale, pas a une regression Y~X du papier -- reformulation transparente en regression continue pour ce benchmark. Y initial (pH_H2O) ecarte car seulement 31/2767 valeurs non-NA (0 cas complets avec les covariables), non executable.

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
- N observations: 2767
- k variables: 17
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [17.73, 25.151], y [-34.75, -29.1833333]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32734 (UTM Zone 34S (EPSG:32734)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`gcfr_soil` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `gcfr_soil` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20%: pH_H2O (NA=98.9%), EC_mS.m (NA=70.8%), CEC_cmol.kg (NA=89%), H._cmol.kg (NA=82.1%), Total_exchangable_cations_cmol.kg (NA=98.6%), K_extractable_cmol....kg (NA=59.5%), Na_extractable_cmol....kg (NA=59.6%), P_extractable_mg.kg (NA=58%), P_total_mg.kg (NA=84.4%), C_organic_. (NA=96%), C_total_. (NA=20.5%), N_total_. (NA=20.7%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`gcfr_soil` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: New regionally modelled soil layers improve prediction of vegetation type relative to that based on global soil models

