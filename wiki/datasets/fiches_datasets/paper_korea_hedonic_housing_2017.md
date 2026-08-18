---
title: paper_korea_hedonic_housing_2017
type: dataset
created: 2026-08-17
updated: 2026-08-17
sources:
  - data/final_datasets/sf/paper_korea_hedonic_housing_2017.rds
  - DatasetFirst_10_5281_zenodo_14715630
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Hedonic dataset of the metropolitan housing market -- Cases in South Korea" (DOI 10.1016/j.dib.2021.106877).

## Description du jeu de donnees

- Topic: economie immobiliere / prix hedoniques en Coree du Sud
- Observation unit: transaction immobiliere
- Observed population: transactions residentielles, 4 villes coreennes (Busan, Daegu, Daejeon, Gwangju) -- sous-ensemble temporel (annee 2017) du dataset parent paper_korea_hedonic_housing (N total parent = 178719) ; voir Bloc 4 pour le N exact de ce sous-ensemble
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: Hedonic dataset of the metropolitan housing market -- Cases in South Korea
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1016/j.dib.2021.106877
- Dataset DOI: 10.5281/zenodo.14715630
- Source URL: https://doi.org/10.5281/zenodo.14715630
- Local raw dir: `data/raw/papers/DatasetFirst_10_5281_zenodo_14715630/`
- Local sf output: `data/final_datasets/sf/paper_korea_hedonic_housing_2017.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Housing.price`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Area`, `Floor`, `Subway.distance`, `Subway.network.distance`, `Maximum.floor`, `Households`, `Buildings`, `Parking.space`, `Heating`, `Top.school`, `High.school`, `CBD`, `Green.space.distance`, `Waterfront.distance`, `Bus.stops`, `Population`, `Male`, `Female`, `Sex.ratio`, `Medium.age`, `Young.population.ratio`, `Elderly.population.ratio`, `Population.density`, `Higher.degree.ratio`, `Spring`, `Fall`, `Winter`
- Candidate X count in local artifact: 27
- Candidate X typology: continuous, categorical
- Published X variables from paper: Area (Size, surface, m2), Floor (etage), Subway.distance (Network distance to nearest subway station), Population.density (densite de population locale), Green.space.distance (distance a un espace vert)
- Published X count: 5
- Coordinates (x, y - excluded from X candidates): `Longitude`, `Latitude`
- Identifier columns (excluded from X candidates): `City`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Housing.price` | `numeric` | continuous | [7000, 110000] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `korea_hedonic_housing_2017`, la ou les reponses `Housing.price` viennent du loader papier et/ou des preuves de l article `Hedonic dataset of the metropolitan housing market -- Cases in South Korea`. Les covariables X retenues sont `Area`, `Floor`, `Subway.distance`, `Population.density`, `Green.space.distance` ; 22 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Longitude`, `Latitude`), identifiants (`City`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Area` | `numeric` | continuous | 0% |
| `Floor` | `numeric` | continuous | 0% |
| `Subway.distance` | `numeric` | continuous | 0% |
| `Subway.network.distance` | `numeric` | continuous | 0% |
| `Maximum.floor` | `numeric` | continuous | 0% |
| `Households` | `numeric` | continuous | 0% |
| `Buildings` | `numeric` | continuous | 0% |
| `Parking.space` | `numeric` | continuous | 0% |
| `Heating` | `numeric` | binary | 0% |
| `Top.school` | `numeric` | continuous | 0% |
| `High.school` | `numeric` | continuous | 0% |
| `CBD` | `numeric` | continuous | 0% |
| `Green.space.distance` | `numeric` | continuous | 0% |
| `Waterfront.distance` | `numeric` | continuous | 0% |
| `Bus.stops` | `numeric` | continuous | 0% |
| `Population` | `numeric` | continuous | 0% |
| `Male` | `numeric` | continuous | 0% |
| `Female` | `numeric` | continuous | 0% |
| `Sex.ratio` | `numeric` | continuous | 0% |
| `Medium.age` | `numeric` | continuous | 0% |
| `Young.population.ratio` | `numeric` | continuous | 0% |
| `Elderly.population.ratio` | `numeric` | continuous | 0% |
| `Population.density` | `numeric` | continuous | 0% |
| `Higher.degree.ratio` | `numeric` | continuous | 0% |
| `Spring` | `numeric` | binary | 0% |
| `Fall` | `numeric` | binary | 0% |
| `Winter` | `numeric` | binary | 0% |

### Formule - niveau publication

- formula_pub: Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]
- x_terms_pub: Area (Size, surface, m2), Floor (etage), Subway.distance (Network distance to nearest subway station), Population.density (densite de population locale), Green.space.distance (distance a un espace vert)
- y_term_pub: Housing.price (prix du logement -- Condominium price, KRW)
- Reference publication: Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include="yes", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2017, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=4990 transactions, 225 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-17). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance
- x_terms_used: Area, Floor, Subway.distance, Population.density, Green.space.distance
- y_term_used: Housing.price
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-17). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

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
    formula: "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance"
    response: "Housing.price (prix du logement -- Condominium price, KRW)"
    predictors: ["Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City"
    response: "Housing.price"
    predictors: ["Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_korea_hedonic_housing_2017`
- Dataset name: Aggregated hedonic datasets for Busan, Daegu, Daejeon, and Gwangju
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Hedonic dataset of the metropolitan housing market -- Cases in South Korea
- Paper DOI: 10.1016/j.dib.2021.106877
- Dataset DOI: 10.5281/zenodo.14715630
- Source URL: https://doi.org/10.5281/zenodo.14715630
- Year: unknown
- Parent dataset: `paper_korea_hedonic_housing` (sous-ensemble temporel -- ne pas compter comme source independante, voir source_dataset_id)

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include='yes', formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2017, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=4990 transactions, 225 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include='yes' depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau"
  reason: "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2017 du dataset parent deja promu package_include='yes' (paper_korea_hedonic_housing, session 2026-08-16). N=4990 transactions, 225 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
```

- Decision: ready
- Manque principal: aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include="yes" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau
- Raison: Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2017 du dataset parent deja promu package_include="yes" (paper_korea_hedonic_housing, session 2026-08-16). N=4990 transactions, 225 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire.

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
- N observations: 4990
- k variables: 34
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [126.792221, 129.218176], y [35.057349, 36.453431]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32652 (UTM Zone 52N (EPSG:32652)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Attribution 4.0 International
- License URL: https://creativecommons.org/licenses/by/4.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5281/zenodo.14715630 (checked 2026-08-18): rightsList = 'Creative Commons Attribution 4.0 International'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`korea_hedonic_housing_2017` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `korea_hedonic_housing_2017` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`korea_hedonic_housing_2017` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Hedonic dataset of the metropolitan housing market -- Cases in South Korea

