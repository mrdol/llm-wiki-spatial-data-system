---
title: paper_korea_hedonic_housing
type: dataset
created: 2026-08-17
updated: 2026-08-17
sources:
  - data/final_datasets/sf/paper_korea_hedonic_housing.rds
  - DatasetFirst_10_5281_zenodo_14715630
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Hedonic dataset of the metropolitan housing market -- Cases in South Korea" (DOI 10.1016/j.dib.2021.106877).

## Description du jeu de donnees

- Topic: economie immobiliere / prix hedoniques en Coree du Sud
- Observation unit: transaction immobiliere
- Observed population: transactions residentielles, 4 villes coreennes (Busan, Daegu, Daejeon, Gwangju), N=178719
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: 46 distinct periods (variable: Year)
- Source description: Hedonic dataset of the metropolitan housing market -- Cases in South Korea
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1016/j.dib.2021.106877
- Dataset DOI: 10.5281/zenodo.14715630
- Source URL: https://doi.org/10.5281/zenodo.14715630
- Local raw dir: `data/raw/papers/DatasetFirst_10_5281_zenodo_14715630/`
- Local sf output: `data/final_datasets/sf/paper_korea_hedonic_housing.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Housing.price`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Area`, `Floor`, `Year`, `Subway.distance`, `Subway.network.distance`, `Maximum.floor`, `Households`, `Buildings`, `Parking.space`, `Heating`, `Top.school`, `High.school`, `CBD`, `Green.space.distance`, `Waterfront.distance`, `Bus.stops`, `Population`, `Male`, `Female`, `Sex.ratio`, `Medium.age`, `Young.population.ratio`, `Elderly.population.ratio`, `Population.density`, `Higher.degree.ratio`, `Spring`, `Fall`, `Winter`
- Candidate X count in local artifact: 28
- Candidate X typology: continuous, categorical
- Published X variables from paper: Area (Size, surface, m2), Floor (etage), Subway.distance (Network distance to nearest subway station -- variable confirmee comme la plus importante par l'etude d'application liee), Population.density (densite de population locale), Green.space.distance (distance a un espace vert)
- Published X count: 5
- Coordinates (x, y - excluded from X candidates): `Longitude`, `Latitude`
- Identifier columns (excluded from X candidates): `City`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Housing.price` | `numeric` | continuous | [1000, 414340] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `korea_hedonic_housing`, la ou les reponses `Housing.price` viennent du loader papier et/ou des preuves de l article `Hedonic dataset of the metropolitan housing market -- Cases in South Korea`. Les covariables X retenues sont `Area`, `Floor`, `Subway.distance`, `Population.density`, `Green.space.distance` ; 23 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Longitude`, `Latitude`), identifiants (`City`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Area` | `numeric` | continuous | 0% |
| `Floor` | `numeric` | continuous | 0% |
| `Year` | `numeric` | continuous | 0% |
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

- formula_pub: Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877 -- article 'data descriptor' officiel de ce meme jeu de donnees (26 variables en 4 categories : housing properties, local demographics, local amenities, seasonal controls). Etude d'application liee trouvee : Ahn et al., 'Economic impact of being close to subway networks', doi:10.1016/j.retrec.2020.100900, confirmant 'network distance to nearest subway station' comme la variable la plus importante pour expliquer le prix, avec les caracteristiques du logement]
- x_terms_pub: Area (Size, surface, m2), Floor (etage), Subway.distance (Network distance to nearest subway station -- variable confirmee comme la plus importante par l'etude d'application liee), Population.density (densite de population locale), Green.space.distance (distance a un espace vert)
- y_term_pub: Housing.price (prix du logement -- Condominium price, KRW)
- Reference publication: CONFIRMED (session 2026-08-16, recherche bibliographique demandee par l'utilisateur) : le papier 'data descriptor' officiel de ce jeu de donnees a ete retrouve -- Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877 (texte consulte via PMC, article en libre acces). Structure officielle confirmee : 26 variables en 4 categories (housing properties : size/floor/parking/annee construction ; demographie locale : population/densite/education/age ; amenites locales : distance metro/bus/espaces verts/CBD ; controles saisonniers). Une etude d'application du meme jeu de donnees a egalement ete identifiee -- Ahn et al., 'Economic impact of being close to subway networks', doi:10.1016/j.retrec.2020.100900 -- confirmant explicitement que la distance au metro et les caracteristiques du logement sont les determinants les plus importants du prix. formula_used (deja proposee par le curateur avant cette recherche) s'avere BIEN ALIGNEE avec la structure officiellement documentee (Area/Floor/Subway.distance/Population.density/Green.space.distance correspondent directement aux 4 categories du data descriptor, Subway.distance confirmee comme variable cle) -- aucune correction necessaire, seule la reference bibliographique est ajoutee. 4 fichiers xlsx (Busan.xlsx, Daegu.xlsx, Daejeon.xlsx, Gwangju.xlsx) telecharges directement depuis Zenodo (DOI 10.5281/zenodo.14715630, tres probablement une extension/mise a jour du dataset original de Song et al. par les memes auteurs ou un groupe associe) -- pas une reconstruction, N=178719 transactions immobilieres (Busan 53458, Daegu 56606, Daejeon 24350, Gwangju 44305). Coordonnees reelles (Longitude/Latitude) verifiees coherentes par ville, pas d'inversion. package_include laisse en manual_review : formule alignee avec la documentation officielle du dataset, mais pas verifiee terme-a-terme contre une regression publiee precise (le data descriptor ne publie pas lui-meme d'equation de regression, seulement la structure des variables).

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
    predictors: ["Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station -- variable confirmee comme la plus importante par l'etude d'application liee)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"]
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

- Dataset ID: `paper_korea_hedonic_housing`
- Dataset name: Aggregated hedonic datasets for Busan, Daegu, Daejeon, and Gwangju
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Hedonic dataset of the metropolitan housing market -- Cases in South Korea
- Paper DOI: 10.1016/j.dib.2021.106877
- Dataset DOI: 10.5281/zenodo.14715630
- Source URL: https://doi.org/10.5281/zenodo.14715630
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877 -- article 'data descriptor' officiel de ce meme jeu de donnees (26 variables en 4 categories : housing properties, local demographics, local amenities, seasonal controls). Etude d'application liee trouvee : Ahn et al., 'Economic impact of being close to subway networks', doi:10.1016/j.retrec.2020.100900, confirmant 'network distance to nearest subway station' comme la variable la plus importante pour expliquer le prix, avec les caracteristiques du logement]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "CONFIRMED (session 2026-08-16, recherche bibliographique demandee par l'utilisateur) : le papier 'data descriptor' officiel de ce jeu de donnees a ete retrouve -- Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877 (texte consulte via PMC, article en libre acces). Structure officielle confirmee : 26 variables en 4 categories (housing properties : size/floor/parking/annee construction ; demographie locale : population/densite/education/age ; amenites locales : distance metro/bus/espaces verts/CBD ; controles saisonniers). Une etude d'application du meme jeu de donnees a egalement ete identifiee -- Ahn et al., 'Economic impact of being close to subway networks', doi:10.1016/j.retrec.2020.100900 -- confirmant explicitement que la distance au metro et les caracteristiques du logement sont les determinants les plus importants du prix. formula_used (deja proposee par le curateur avant cette recherche) s'avere BIEN ALIGNEE avec la structure officiellement documentee (Area/Floor/Subway.distance/Population.density/Green.space.distance correspondent directement aux 4 categories du data descriptor, Subway.distance confirmee comme variable cle) -- aucune correction necessaire, seule la reference bibliographique est ajoutee. 4 fichiers xlsx (Busan.xlsx, Daegu.xlsx, Daejeon.xlsx, Gwangju.xlsx) telecharges directement depuis Zenodo (DOI 10.5281/zenodo.14715630, tres probablement une extension/mise a jour du dataset original de Song et al. par les memes auteurs ou un groupe associe) -- pas une reconstruction, N=178719 transactions immobilieres (Busan 53458, Daegu 56606, Daejeon 24350, Gwangju 44305). Coordonnees reelles (Longitude/Latitude) verifiees coherentes par ville, pas d'inversion. package_include laisse en manual_review : formule alignee avec la documentation officielle du dataset, mais pas verifiee terme-a-terme contre une regression publiee precise (le data descriptor ne publie pas lui-meme d'equation de regression, seulement la structure des variables)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "data descriptor officiel retrouve (Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877) -- formula_used deja alignee avec la structure officielle documentee (Subway.distance confirmee comme variable cle par une etude d'application liee) -- promu a package_include='yes' apres validation utilisateur (session 2026-08-16)"
  reason: "Y continu reel (Housing.price, prix du logement), N=178719 transactions immobilieres reelles (4 villes coreennes) avec coordonnees reelles. 4 fichiers xlsx telecharges directement depuis Zenodo, pas une reconstruction, 0% NA verifie sur toutes les colonnes cles."
```

- Decision: ready
- Manque principal: data descriptor officiel retrouve (Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877) -- formula_used deja alignee avec la structure officielle documentee (Subway.distance confirmee comme variable cle par une etude d'application liee) -- promu a package_include="yes" apres validation utilisateur (session 2026-08-16)
- Raison: Y continu reel (Housing.price, prix du logement), N=178719 transactions immobilieres reelles (4 villes coreennes) avec coordonnees reelles. 4 fichiers xlsx telecharges directement depuis Zenodo, pas une reconstruction, 0% NA verifie sur toutes les colonnes cles.

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
- N observations: 178719
- k variables: 35
- T periods: 46
- Variable temporelle: Year
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (178719) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 5395 ; panel NON EQUILIBRE (T par unite : min=1, mediane=15, max=908). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 5395 unites spatiales distinctes, pas sur les 178719 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 46 distinct periods (variable: Year)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [126.771905, 129.255899], y [35.048503, 36.453431]
- Time range: 1969 to 2019 (variable: Year)
- CRS analyse recommande: 32652 (UTM Zone 52N (EPSG:32652)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`korea_hedonic_housing` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `korea_hedonic_housing` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`korea_hedonic_housing` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Hedonic dataset of the metropolitan housing market -- Cases in South Korea

