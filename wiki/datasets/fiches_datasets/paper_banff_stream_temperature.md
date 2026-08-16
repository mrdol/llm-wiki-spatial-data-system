---
title: paper_banff_stream_temperature
type: dataset
created: 2026-08-17
updated: 2026-08-17
sources:
  - data/final_datasets/sf/paper_banff_stream_temperature.rds
  - DatasetFirst_10_5061_dryad_crjdfn391
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "[dataset-first, publication non resolue] Data from: Statistical stream temperature modelling with SSN and INLA: an introduction for conservation practitioners" (DOI unknown).

## Description du jeu de donnees

- Topic: hydrologie / temperature des cours d'eau (modelisation SSN)
- Observation unit: site de mesure de temperature (logger)
- Observed population: cours d'eau, Parc national de Banff, Alberta, N=110 sites
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: [dataset-first, publication non resolue] Data from: Statistical stream temperature modelling with SSN and INLA: an introduction for conservation practitioners
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: unknown
- Dataset DOI: 10.5061/dryad.crjdfn391
- Source URL: https://doi.org/10.5061/dryad.crjdfn391
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_crjdfn391/`
- Local sf output: `data/final_datasets/sf/paper_banff_stream_temperature.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `WaterTemp`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Year_`, `LE`, `Elev`, `RSlope`, `h2oAreaKm2`, `logRCA`
- Candidate X count in local artifact: 6
- Candidate X typology: continuous, categorical
- Published X variables from paper: Elev (elevation du site, m), RSlope (pente du cours d'eau), h2oAreaKm2 (aire du bassin versant amont, km2), logRCA (log de l'aire de contribution du reseau)
- Published X count: 4
- Coordinates (x, y - excluded from X candidates): `Easting`, `Northing`
- Identifier columns (excluded from X candidates): `ID`, `LoggerID`, `S_N`, `WSf`, `Waterbody`, `HUC10`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `WaterTemp` | `numeric` | continuous | [2.6, 13.6] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `banff_stream_temperature`, la ou les reponses `WaterTemp` viennent du loader papier et/ou des preuves de l article `[dataset-first, publication non resolue] Data from: Statistical stream temperature modelling with SSN and INLA: an introduction for conservation practitioners`. Les covariables X retenues sont `Elev`, `RSlope`, `h2oAreaKm2`, `logRCA` ; 2 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Easting`, `Northing`), identifiants (`ID`, `LoggerID`, `S_N`, `WSf`, `Waterbody`, `HUC10`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Year_` | `integer` | count | 0% |
| `LE` | `integer` | binary | 0% |
| `Elev` | `integer` | continuous | 0% |
| `RSlope` | `numeric` | continuous | 0% |
| `h2oAreaKm2` | `numeric` | continuous | 0% |
| `logRCA` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: [Struthers, Gutowsky, Lucas, Mochnacz, Carli & Taylor (2023), 'Statistical stream temperature modelling with SSN and INLA: an introduction for conservation practitioners', Canadian Journal of Fisheries and Aquatic Science 81(4):417-232. Le papier presente une methodologie de modelisation spatiale sur reseau fluvial (SSN, INLA) pour la temperature de l'eau, avec les memes variables predictives que celles presentes dans ce depot (README confirme les definitions exactes des colonnes) -- specification exacte du modele SSN/INLA non extraite (methodologie complexe, texte integral non consulte)]
- x_terms_pub: Elev (elevation du site, m), RSlope (pente du cours d'eau), h2oAreaKm2 (aire du bassin versant amont, km2), logRCA (log de l'aire de contribution du reseau)
- y_term_pub: WaterTemp (temperature moyenne d'aout du cours d'eau, degres C, mesuree par logger)
- Reference publication: Papier identifie avec certitude via le README.md du depot (citation complete fournie par les auteurs) : Struthers, Gutowsky, Lucas, Mochnacz, Carli & Taylor (2023), Canadian Journal of Fisheries and Aquatic Science 81(4):417-232, doi non liste dans le README mais dataset DOI confirme 10.5061/dryad.crjdfn391 (Parks Canada, Banff National Park). CSV original (bnp_data_June2022_V5.csv) telecharge directement depuis Dryad -- pas une reconstruction, N=110 sites de mesure de temperature avec coordonnees UTM Zone 11N (README confirme le systeme de coordonnees exact). Le papier presente une methodologie SSN (Spatial Stream Network) + INLA pour modeliser la temperature sur le reseau hydrographique, une approche geostatistique sur reseau bien plus complexe qu'une regression classique -- formula_used retient les covariables reelles disponibles (elevation, pente, aire de bassin versant, aire de contribution) en regression lineaire simple, une simplification documentee, pas la specification exacte du modele SSN/INLA du papier. Fichier bnp_data_preds_June2022_V5.csv (grille de prediction, 642 lignes) present dans le meme depot mais non utilise ici (pas de Y, utile seulement pour du krigeage). package_include laisse en manual_review pour cette raison.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-17). Papier identifie avec certitude via le README.md du depot (citation complete fournie par les auteurs) : Struthers, Gutowsky, Lucas, Mochnacz, Carli & Taylor (2023), Canadian Journal of Fisheries and Aquatic Science 81(4):417-232, doi non liste dans le README mais dataset DOI confirme 10.5061/dryad.crjdfn391 (Parks Canada, Banff National Park). CSV original (bnp_data_June2022_V5.csv) telecharge directement depuis Dryad -- pas une reconstruction, N=110 sites de mesure de temperature avec coordonnees UTM Zone 11N (README confirme le systeme de coordonnees exact). Le papier presente une methodologie SSN (Spatial Stream Network) + INLA pour modeliser la temperature sur le reseau hydrographique, une approche geostatistique sur reseau bien plus complexe qu'une regression classique -- formula_used retient les covariables reelles disponibles (elevation, pente, aire de bassin versant, aire de contribution) en regression lineaire simple, une simplification documentee, pas la specification exacte du modele SSN/INLA du papier. Fichier bnp_data_preds_June2022_V5.csv (grille de prediction, 642 lignes) present dans le meme depot mais non utilise ici (pas de Y, utile seulement pour du krigeage). package_include laisse en manual_review pour cette raison.

### Formule - niveau systeme

- formula_used: WaterTemp ~ Elev + RSlope + h2oAreaKm2 + logRCA
- x_terms_used: Elev, RSlope, h2oAreaKm2, logRCA
- y_term_used: WaterTemp
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-17). Papier identifie avec certitude via le README.md du depot (citation complete fournie par les auteurs) : Struthers, Gutowsky, Lucas, Mochnacz, Carli & Taylor (2023), Canadian Journal of Fisheries and Aquatic Science 81(4):417-232, doi non liste dans le README mais dataset DOI confirme 10.5061/dryad.crjdfn391 (Parks Canada, Banff National Park). CSV original (bnp_data_June2022_V5.csv) telecharge directement depuis Dryad -- pas une reconstruction, N=110 sites de mesure de temperature avec coordonnees UTM Zone 11N (README confirme le systeme de coordonnees exact). Le papier presente une methodologie SSN (Spatial Stream Network) + INLA pour modeliser la temperature sur le reseau hydrographique, une approche geostatistique sur reseau bien plus complexe qu'une regression classique -- formula_used retient les covariables reelles disponibles (elevation, pente, aire de bassin versant, aire de contribution) en regression lineaire simple, une simplification documentee, pas la specification exacte du modele SSN/INLA du papier. Fichier bnp_data_preds_June2022_V5.csv (grille de prediction, 642 lignes) present dans le meme depot mais non utilise ici (pas de Y, utile seulement pour du krigeage). package_include laisse en manual_review pour cette raison.

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
    formula: "WaterTemp ~ Elev + RSlope + h2oAreaKm2 + logRCA"
    response: "WaterTemp (temperature moyenne d'aout du cours d'eau, degres C, mesuree par logger)"
    predictors: ["Elev (elevation du site, m)", "RSlope (pente du cours d'eau)", "h2oAreaKm2 (aire du bassin versant amont, km2)", "logRCA (log de l'aire de contribution du reseau)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Papier identifie avec certitude via le README.md du depot (citation complete fournie par les auteurs) : Struthers, Gutowsky, Lucas, Mochnacz, Carli & Taylor (2023), Canadian Journal of Fisheries and Aquatic Science 81(4):417-232, doi non liste dans le README mais dataset DOI confirme 10.5061/dryad.crjdfn391 (Parks Canada, Banff National Park). CSV original (bnp_data_June2022_V5.csv) telecharge directement depuis Dryad -- pas une reconstruction, N=110 sites de mesure de temperature avec coordonnees UTM Zone 11N (README confirme le systeme de coordonnees exact). Le papier presente une methodologie SSN (Spatial Stream Network) + INLA pour modeliser la temperature sur le reseau hydrographique, une approche geostatistique sur reseau bien plus complexe qu'une regression classique -- formula_used retient les covariables reelles disponibles (elevation, pente, aire de bassin versant, aire de contribution) en regression lineaire simple, une simplification documentee, pas la specification exacte du modele SSN/INLA du papier. Fichier bnp_data_preds_June2022_V5.csv (grille de prediction, 642 lignes) present dans le meme depot mais non utilise ici (pas de Y, utile seulement pour du krigeage). package_include laisse en manual_review pour cette raison."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "WaterTemp ~ Elev + RSlope + h2oAreaKm2 + logRCA + LE"
    response: "WaterTemp"
    predictors: ["Elev", "RSlope", "h2oAreaKm2", "logRCA", "LE"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Papier identifie avec certitude via le README.md du depot (citation complete fournie par les auteurs) : Struthers, Gutowsky, Lucas, Mochnacz, Carli & Taylor (2023), Canadian Journal of Fisheries and Aquatic Science 81(4):417-232, doi non liste dans le README mais dataset DOI confirme 10.5061/dryad.crjdfn391 (Parks Canada, Banff National Park). CSV original (bnp_data_June2022_V5.csv) telecharge directement depuis Dryad -- pas une reconstruction, N=110 sites de mesure de temperature avec coordonnees UTM Zone 11N (README confirme le systeme de coordonnees exact). Le papier presente une methodologie SSN (Spatial Stream Network) + INLA pour modeliser la temperature sur le reseau hydrographique, une approche geostatistique sur reseau bien plus complexe qu'une regression classique -- formula_used retient les covariables reelles disponibles (elevation, pente, aire de bassin versant, aire de contribution) en regression lineaire simple, une simplification documentee, pas la specification exacte du modele SSN/INLA du papier. Fichier bnp_data_preds_June2022_V5.csv (grille de prediction, 642 lignes) present dans le meme depot mais non utilise ici (pas de Y, utile seulement pour du krigeage). package_include laisse en manual_review pour cette raison."
    estimator_context: ["ols", "gwr", "sar_error", "random_forest_xy"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_banff_stream_temperature`
- Dataset name: Data from: Statistical stream temperature modelling with SSN and INLA: an introduction for conservation practitioners
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: [dataset-first, publication non resolue] Data from: Statistical stream temperature modelling with SSN and INLA: an introduction for conservation practitioners
- Paper DOI: unknown
- Dataset DOI: 10.5061/dryad.crjdfn391
- Source URL: https://doi.org/10.5061/dryad.crjdfn391
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "[Struthers, Gutowsky, Lucas, Mochnacz, Carli & Taylor (2023), 'Statistical stream temperature modelling with SSN and INLA: an introduction for conservation practitioners', Canadian Journal of Fisheries and Aquatic Science 81(4):417-232. Le papier presente une methodologie de modelisation spatiale sur reseau fluvial (SSN, INLA) pour la temperature de l'eau, avec les memes variables predictives que celles presentes dans ce depot (README confirme les definitions exactes des colonnes) -- specification exacte du modele SSN/INLA non extraite (methodologie complexe, texte integral non consulte)]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Papier identifie avec certitude via le README.md du depot (citation complete fournie par les auteurs) : Struthers, Gutowsky, Lucas, Mochnacz, Carli & Taylor (2023), Canadian Journal of Fisheries and Aquatic Science 81(4):417-232, doi non liste dans le README mais dataset DOI confirme 10.5061/dryad.crjdfn391 (Parks Canada, Banff National Park). CSV original (bnp_data_June2022_V5.csv) telecharge directement depuis Dryad -- pas une reconstruction, N=110 sites de mesure de temperature avec coordonnees UTM Zone 11N (README confirme le systeme de coordonnees exact). Le papier presente une methodologie SSN (Spatial Stream Network) + INLA pour modeliser la temperature sur le reseau hydrographique, une approche geostatistique sur reseau bien plus complexe qu'une regression classique -- formula_used retient les covariables reelles disponibles (elevation, pente, aire de bassin versant, aire de contribution) en regression lineaire simple, une simplification documentee, pas la specification exacte du modele SSN/INLA du papier. Fichier bnp_data_preds_June2022_V5.csv (grille de prediction, 642 lignes) present dans le meme depot mais non utilise ici (pas de Y, utile seulement pour du krigeage). package_include laisse en manual_review pour cette raison."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "le papier presente une methodologie SSN (Spatial Stream Network) + INLA sur reseau hydrographique, pas une regression classique -- formula_used est une simplification lineaire du curateur utilisant les covariables reelles disponibles ; package_include laisse en manual_review pour cette raison"
  reason: "Y continu reel (WaterTemp, temperature moyenne d'aout), N=110 sites de mesure avec coordonnees UTM reelles (Parc national de Banff, Alberta). CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier identifie avec certitude via le README du depot (citation complete des auteurs)."
```

- Decision: ready
- Manque principal: le papier presente une methodologie SSN (Spatial Stream Network) + INLA sur reseau hydrographique, pas une regression classique -- formula_used est une simplification lineaire du curateur utilisant les covariables reelles disponibles ; package_include laisse en manual_review pour cette raison
- Raison: Y continu reel (WaterTemp, temperature moyenne d'aout), N=110 sites de mesure avec coordonnees UTM reelles (Parc national de Banff, Alberta). CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier identifie avec certitude via le README du depot (citation complete des auteurs).

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
- N observations: 110
- k variables: 18
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 32611
- CRS nom: WGS 84 / UTM zone 11N
- Spatial extent: x [580218, 612127], y [5642845, 5701082]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`banff_stream_temperature` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `banff_stream_temperature` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (32611).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`banff_stream_temperature` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: [dataset-first, publication non resolue] Data from: Statistical stream temperature modelling with SSN and INLA: an introduction for conservation practitioners

