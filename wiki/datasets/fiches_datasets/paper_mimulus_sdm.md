---
title: paper_mimulus_sdm
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_mimulus_sdm.rds
  - DatasetFirst_10_5061_dryad_xsj3tx9g1
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "WiBB : an integrated method for quantifying the relative importance of predictive variables" (DOI 10.1111/ecog.05651).

## Description du jeu de donnees

- Topic: ecologie / modelisation de distribution d'espece (SDM multi-especes)
- Observation unit: point d'occurrence/fond
- Observed population: 71 especes de Mimulus (monkeyflowers), Amerique du Nord, N=21307 points
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: WiBB : an integrated method for quantifying the relative importance of predictive variables
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/ecog.05651
- Dataset DOI: 10.5061/dryad.xsj3tx9g1
- Source URL: https://doi.org/10.5061/dryad.xsj3tx9g1
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_xsj3tx9g1/`
- Local sf output: `data/final_datasets/sf/paper_mimulus_sdm.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `presence`
- Candidate Y typology: binary
- Candidate X variables in local artifact: `T_cold`, `GDD0`, `P_season`, `TP_syn`, `Aridity`, `ISO`
- Candidate X count in local artifact: 6
- Candidate X typology: continuous
- Published X variables from paper: T_cold (temperature du mois le plus froid), GDD0 (degres-jours de croissance > 0C), P_season (saisonnalite des precipitations), TP_syn (synchronicite temperature-precipitation), Aridity (aridite de la saison de croissance), ISO (isothermalite)
- Published X count: 6
- Coordinates (x, y - excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `presence` | `integer` | binary | {0, 1} | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `mimulus_sdm`, la ou les reponses `presence` viennent du loader papier et/ou des preuves de l article `WiBB : an integrated method for quantifying the relative importance of predictive variables`. Les covariables X retenues sont `T_cold`, `GDD0`, `P_season`, `TP_syn`, `Aridity`, `ISO`. Les coordonnees (`lon`, `lat`), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `T_cold` | `integer` | count | 0% |
| `GDD0` | `integer` | count | 0% |
| `P_season` | `integer` | count | 0% |
| `TP_syn` | `integer` | count | 0% |
| `Aridity` | `integer` | count | 0% |
| `ISO` | `integer` | count | 0% |

### Formule - niveau publication

- formula_pub: presence ~ T_cold + GDD0 + P_season + TP_syn + Aridity + ISO [WiBB : cadre de ponderation multi-modele (AICc, poids de sommation, WiBB) pour classer l'importance relative des predicteurs dans des GLM binomiaux ajustes espece par espece]
- x_terms_pub: T_cold (temperature du mois le plus froid), GDD0 (degres-jours de croissance > 0C), P_season (saisonnalite des precipitations), TP_syn (synchronicite temperature-precipitation), Aridity (aridite de la saison de croissance), ISO (isothermalite)
- y_term_pub: presence (1=occurrence Mimulus, 0=point de fond aleatoire dans l'aire de distribution)
- Reference publication: Li & Kou (2021), WiBB: an integrated method for quantifying the relative importance of predictive variables, Ecography, doi:10.1111/ecog.05651. Le jeu de donnees empirique (empirical_dataset/) applique la methode WiBB a 71 especes de Mimulus avec occurrences reelles et 6 variables climatiques (memes noms de colonnes que le papier). Donnees brutes (mimulus_occ_var.csv + background_pts_var.csv) telechargees directement depuis Dryad (10.5061/dryad.xsj3tx9g1) -- pas une reconstruction, N=21307 (11362 occurrences + 9945 points de fond), especes multiples poolees en un seul jeu presence/fond pour ce benchmark (le papier ajuste un GLM separe par espece ; formula_used est le pooling multi-especes standard pour un benchmark SDM binaire).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: presence ~ T_cold + GDD0 + P_season + TP_syn + Aridity + ISO
- x_terms_used: T_cold, GDD0, P_season, TP_syn, Aridity, ISO
- y_term_used: presence
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
    formula: "presence ~ T_cold + GDD0 + P_season + TP_syn + Aridity + ISO"
    response: "presence (1=occurrence Mimulus, 0=point de fond aleatoire dans l'aire de distribution)"
    predictors: ["T_cold (temperature du mois le plus froid)", "GDD0 (degres-jours de croissance > 0C)", "P_season (saisonnalite des precipitations)", "TP_syn (synchronicite temperature-precipitation)", "Aridity (aridite de la saison de croissance)", "ISO (isothermalite)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["random_forest", "gamboost", "xgboost"]
    status: "confirmed"

  ml_or_selected:
    formula: "presence ~ T_cold + GDD0 + P_season + TP_syn + Aridity + ISO"
    response: "presence"
    predictors: ["T_cold", "GDD0", "P_season", "TP_syn", "Aridity", "ISO"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["glm_logistic", "random_forest", "random_forest_xy", "xgboost", "gwr"]
    status: "executable_binary_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_mimulus_sdm`
- Dataset name: WiBB: An integrated method for quantifying the relative importance of predictive variables
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: WiBB : an integrated method for quantifying the relative importance of predictive variables
- Paper DOI: 10.1111/ecog.05651
- Dataset DOI: 10.5061/dryad.xsj3tx9g1
- Source URL: https://doi.org/10.5061/dryad.xsj3tx9g1
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "presence ~ T_cold + GDD0 + P_season + TP_syn + Aridity + ISO [WiBB : cadre de ponderation multi-modele (AICc, poids de sommation, WiBB) pour classer l'importance relative des predicteurs dans des GLM binomiaux ajustes espece par espece]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Li & Kou (2021), WiBB: an integrated method for quantifying the relative importance of predictive variables, Ecography, doi:10.1111/ecog.05651. Le jeu de donnees empirique (empirical_dataset/) applique la methode WiBB a 71 especes de Mimulus avec occurrences reelles et 6 variables climatiques (memes noms de colonnes que le papier). Donnees brutes (mimulus_occ_var.csv + background_pts_var.csv) telechargees directement depuis Dryad (10.5061/dryad.xsj3tx9g1) -- pas une reconstruction, N=21307 (11362 occurrences + 9945 points de fond), especes multiples poolees en un seul jeu presence/fond pour ce benchmark (le papier ajuste un GLM separe par espece ; formula_used est le pooling multi-especes standard pour un benchmark SDM binaire)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "classification_binary_presence_absence_sdm"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun -- CSV originaux telecharges directement depuis Dryad, N=21307 identique au depot source (multi-especes poolees, pas de reconstruction des valeurs)"
  reason: "presence binaire reelle (occurrences Mimulus vs points de fond), N=21307 avec coordonnees reelles (Amerique du Nord), 6 covariables climatiques exactement celles du papier (memes noms de colonnes que la publication). CSV originaux telecharges directement depuis Dryad, pas une reconstruction. Papier lu (README du depot) pour confirmer la nature et les colonnes du jeu de donnees empirique."
```

- Decision: ready
- Manque principal: aucun -- CSV originaux telecharges directement depuis Dryad, N=21307 identique au depot source (multi-especes poolees, pas de reconstruction des valeurs)
- Raison: presence binaire reelle (occurrences Mimulus vs points de fond), N=21307 avec coordonnees reelles (Amerique du Nord), 6 covariables climatiques exactement celles du papier (memes noms de colonnes que la publication). CSV originaux telecharges directement depuis Dryad, pas une reconstruction. Papier lu (README du depot) pour confirmer la nature et les colonnes du jeu de donnees empirique.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready"
  eligible_estimators: []
  conditionally_eligible_estimators: ["random_forest", "random_forest_xy", "gamboost", "xgboost", "xgboost_xy", "gam_spatial"]
  ineligible_reason: "reponse binaire (presence/absence) ; le registre benchmark du package (13-benchmark-spatial.R) code en dur mode='regression' pour tous les estimateurs automatiques -- aucun ne supporte de mode classification/binomial aujourd'hui. random_forest/gamboost/xgboost sont notes conditionnels car ce sont les estimateurs que le papier source a reellement utilises (RF/BRT) ; ols/sar_lag/sem_error/sdm_mixed/gwr restent hors de propos pour une reponse binaire (hypothese gaussienne continue) et ne sont pas listes."
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 21307
- k variables: 11
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-136.8072033, -93.2031689], y [17.0448031, 61.5773529]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=43.6deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`mimulus_sdm` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `mimulus_sdm` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`mimulus_sdm` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: WiBB : an integrated method for quantifying the relative importance of predictive variables

