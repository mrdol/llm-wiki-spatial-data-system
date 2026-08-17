---
title: paper_pacific_atoll_coconut
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_pacific_atoll_coconut.rds
  - DatasetFirst_10_5061_dryad_0k6djhb7x
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Satellite imagery reveals widespread coconut plantations on Pacific atolls" (DOI 10.1088/1748-9326/ad8c66).

## Description du jeu de donnees

- Topic: teledetection / agriculture-foresterie tropicale (cocotier)
- Observation unit: atoll
- Observed population: atolls du Pacifique, N=266
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: Satellite imagery reveals widespread coconut plantations on Pacific atolls
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1088/1748-9326/ad8c66
- Dataset DOI: 10.5061/dryad.0k6djhb7x
- Source URL: https://doi.org/10.5061/dryad.0k6djhb7x
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_0k6djhb7x/`
- Local sf output: `data/final_datasets/sf/paper_pacific_atoll_coconut.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `cocos.`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Type`, `Average.Rainfall..mm.yr.`, `Inhabited.`, `History.of.copra.production`, `Elevation..m.`, `cocos.km2`, `broadleaf.km2`, `shrub.km2`, `non_veg.km2`, `cloud.km2`, `total.km2`, `total.non.cloud.km2`, `broadleaf.`, `shrub.`, `non_veg.`, `cloud.`, `cocos.veg.`, `cocos.tree.`, `monocrop.km2`, `monocrop.coconut.km2`, `X..of.coconut.existing.in.monocrop`
- Candidate X count in local artifact: 21
- Candidate X typology: categorical, continuous
- Published X variables from paper: Average.Rainfall..mm.yr. (precipitation annuelle moyenne), Elevation..m. (elevation), Inhabited. (habite ou non), History.of.copra.production (histoire de production de coprah, oui/non)
- Published X count: 4
- Coordinates (x, y - excluded from X candidates): `Lon`, `Lat`
- Identifier columns (excluded from X candidates): `Atoll`, `Alternative.names`, `Country`, `Group`, `Subgroup`, `Copra.reference`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `cocos.` | `numeric` | continuous | [0, 81.4278] | 11.7% |

> Selection Y/X (paper-loader / curated evidence) : Pour `pacific_atoll_coconut`, la ou les reponses `cocos.` viennent du loader papier et/ou des preuves de l article `Satellite imagery reveals widespread coconut plantations on Pacific atolls`. Les covariables X retenues sont `Average.Rainfall..mm.yr.`, `Elevation..m.`, `Inhabited.`, `History.of.copra.production` ; 17 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Lon`, `Lat`), identifiants (`Atoll`, `Alternative.names`, `Country`, `Group`, `Subgroup`, `Copra.reference`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Type` | `character` | categorical | 0% |
| `Average.Rainfall..mm.yr.` | `numeric` | continuous | 0% |
| `Inhabited.` | `integer` | binary | 1.1% |
| `History.of.copra.production` | `character` | categorical | 0% |
| `Elevation..m.` | `integer` | continuous | 3.8% |
| `cocos.km2` | `numeric` | continuous | 11.7% |
| `broadleaf.km2` | `numeric` | continuous | 11.7% |
| `shrub.km2` | `numeric` | continuous | 11.7% |
| `non_veg.km2` | `numeric` | continuous | 11.7% |
| `cloud.km2` | `numeric` | continuous | 11.7% |
| `total.km2` | `numeric` | continuous | 11.7% |
| `total.non.cloud.km2` | `numeric` | continuous | 11.7% |
| `broadleaf.` | `numeric` | continuous | 11.7% |
| `shrub.` | `numeric` | continuous | 11.7% |
| `non_veg.` | `numeric` | continuous | 11.7% |
| `cloud.` | `numeric` | continuous | 11.7% |
| `cocos.veg.` | `numeric` | continuous | 11.7% |
| `cocos.tree.` | `numeric` | continuous | 11.7% |
| `monocrop.km2` | `numeric` | continuous | 11.7% |
| `monocrop.coconut.km2` | `numeric` | continuous | 11.7% |
| `X..of.coconut.existing.in.monocrop` | `numeric` | continuous | 11.7% |

### Formule - niveau publication

- formula_pub: cocos% ~ Average.Rainfall + Elevation + Inhabited + History.of.copra.production [classification satellite (Sentinel-2/Planet) de la couverture cocos vs autre vegetation/non-vegetation par atoll, comparee aux variables environnementales et a l'histoire de production de coprah]
- x_terms_pub: Average.Rainfall..mm.yr. (precipitation annuelle moyenne), Elevation..m. (elevation), Inhabited. (habite ou non), History.of.copra.production (histoire de production de coprah, oui/non)
- y_term_pub: cocos. (pourcentage de couverture en cocotier, classification satellite, par atoll du Pacifique)
- Reference publication: Auteurs (2024), Satellite imagery reveals widespread coconut plantations on Pacific atolls, Environmental Research Letters, doi:10.1088/1748-9326/ad8c66. Le papier classifie la couverture vegetale par imagerie satellite (Sentinel-2/Planet) sur des atolls du Pacifique et relie la prevalence du cocotier a l'histoire de production de coprah et aux variables environnementales. Donnees brutes (master-atoll-database-2024-04-16.csv) telechargees directement depuis Dryad (10.5061/dryad.0k6djhb7x) -- pas une reconstruction, N=266 atolls avec coordonnees reelles, statistiques de couverture vegetale issues de la classification satellite du papier lui-meme (pas une reconstruction/estimation).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: cocos. ~ Average.Rainfall..mm.yr. + Elevation..m. + Inhabited. + History.of.copra.production
- x_terms_used: Average.Rainfall..mm.yr., Elevation..m., Inhabited., History.of.copra.production
- y_term_used: cocos.
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
    formula: "cocos. ~ Average.Rainfall..mm.yr. + Elevation..m. + Inhabited. + History.of.copra.production"
    response: "cocos. (pourcentage de couverture en cocotier, classification satellite, par atoll du Pacifique)"
    predictors: ["Average.Rainfall..mm.yr. (precipitation annuelle moyenne)", "Elevation..m. (elevation)", "Inhabited. (habite ou non)", "History.of.copra.production (histoire de production de coprah, oui/non)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "cocos. ~ Average.Rainfall..mm.yr. + Elevation..m. + Inhabited. + History.of.copra.production + broadleaf. + shrub. + non_veg."
    response: "cocos."
    predictors: ["Average.Rainfall..mm.yr.", "Elevation..m.", "Inhabited.", "History.of.copra.production", "broadleaf.", "shrub.", "non_veg."]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "gam_spatial", "random_forest", "gwr"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_pacific_atoll_coconut`
- Dataset name: Pacific Atoll Vegetation Maps
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Satellite imagery reveals widespread coconut plantations on Pacific atolls
- Paper DOI: 10.1088/1748-9326/ad8c66
- Dataset DOI: 10.5061/dryad.0k6djhb7x
- Source URL: https://doi.org/10.5061/dryad.0k6djhb7x
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "cocos% ~ Average.Rainfall + Elevation + Inhabited + History.of.copra.production [classification satellite (Sentinel-2/Planet) de la couverture cocos vs autre vegetation/non-vegetation par atoll, comparee aux variables environnementales et a l'histoire de production de coprah]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Auteurs (2024), Satellite imagery reveals widespread coconut plantations on Pacific atolls, Environmental Research Letters, doi:10.1088/1748-9326/ad8c66. Le papier classifie la couverture vegetale par imagerie satellite (Sentinel-2/Planet) sur des atolls du Pacifique et relie la prevalence du cocotier a l'histoire de production de coprah et aux variables environnementales. Donnees brutes (master-atoll-database-2024-04-16.csv) telechargees directement depuis Dryad (10.5061/dryad.0k6djhb7x) -- pas une reconstruction, N=266 atolls avec coordonnees reelles, statistiques de couverture vegetale issues de la classification satellite du papier lui-meme (pas une reconstruction/estimation)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun -- CSV original telecharge directement depuis Dryad, N=266 atolls, statistiques de couverture vegetale issues de la classification satellite propre au papier"
  reason: "Y continu reel (pourcentage de couverture cocotier, classification satellite), N=266 atolls du Pacifique avec coordonnees reelles, covariables environnementales et historiques reelles (pluviometrie, elevation, histoire de production de coprah). CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier identifie et confirme (titre exact + DOI via OpenAlex, session 2026-08-16)."
```

- Decision: ready
- Manque principal: aucun -- CSV original telecharge directement depuis Dryad, N=266 atolls, statistiques de couverture vegetale issues de la classification satellite propre au papier
- Raison: Y continu reel (pourcentage de couverture cocotier, classification satellite), N=266 atolls du Pacifique avec coordonnees reelles, covariables environnementales et historiques reelles (pluviometrie, elevation, histoire de production de coprah). CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier identifie et confirme (titre exact + DOI via OpenAlex, session 2026-08-16).

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
- N observations: 266
- k variables: 32
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-179.452, 179.8424], y [-24.6811, 28.4226]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=359.3deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`pacific_atoll_coconut` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `pacific_atoll_coconut` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`pacific_atoll_coconut` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Satellite imagery reveals widespread coconut plantations on Pacific atolls

