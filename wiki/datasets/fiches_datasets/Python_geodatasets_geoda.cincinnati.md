---
title: Python_geodatasets_geoda.cincinnati
type: dataset
created: 2026-08-15
updated: 2026-09-18
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.cincinnati.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`cincinnati`).

## Description du jeu de donnees

- Topic: Donnees de python-package : Python_geodatasets_geoda.cincinnati
- Observation unit: observation spatiale de type POINT
- Observed population: 457 enregistrements dans l’artefact local Python_geodatasets_geoda.cincinnati.rds; unite declaree : observation spatiale de type POINT. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: Etendue mesuree dans le RDS : x [-84.525388, -84.464741], y [39.112160, 39.150710]; CRS EPSG:4326 (corrige le 2026-09-18 -- correspond maintenant a la vraie etendue geographique de Cincinnati (Ohio, USA), voir Bloc 5 > CRS note).
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`cincinnati`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `BURGLARY`, `ASSAULT`, `THEFT`, `BURG_D`, `ASSALT_D`, `THEFT_D`, `DENSITY`
- Candidate Y typology: count, binary, continuous
- Candidate X variables: `AREA`, `POPULATION`, `MEDIAN_AGE`, `AGE_0_5`, `AGE_15_19`, `AGE_20_24`, `AGE_25_34`, `AGE_35_44`, `AGE_65`, `WHITE`, `BLACK`, `ASIAN`, `AP_HISPANI`, `HOUSEHOLDS`, `HH_FAMILY`, `HH_NONFAMI`, `AVG_HHSIZE`, `AVG_FAMSIZ`, `HSNG_UNITS`, `HU_VACANT`, `OCCHU_OWNE`, `OCCHU_RENT`, `GROUP_QUAR`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `ID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `BURGLARY` | `integer` | count | [0, 10] | 0% |
| `ASSAULT` | `integer` | count | [0, 11] | 0% |
| `THEFT` | `integer` | count | [0, 33] | 0% |
| `BURG_D` | `numeric` | binary | {0, 1} | 0% |
| `ASSALT_D` | `numeric` | binary | {0, 1} | 0% |
| `THEFT_D` | `numeric` | binary | {0, 1} | 0% |
| `DENSITY` | `numeric` | continuous | [0, 55229.6771] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables criminelles (BURGLARY, ASSAULT, THEFT et leurs formes binaires) ainsi que DENSITY sont les cibles naturelles d'une modélisation spatiale dans ce contexte urbain de Cincinnati. Les covariables retenues couvrent les dimensions démographiques (population, structure d'âge, composition raciale/ethnique), sociales (structure des ménages, taille moyenne) et résidentielles (logements vacants, propriétaires vs locataires, logements collectifs) classiquement associées à la criminalité et à la densité urbaine ; DENSITY peut jouer alternativement le rôle de Y (modélisation de la densité) ou de X (prédicteur de la criminalité), d'où sa présence dans les deux listes.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `AREA` | `numeric` | rate | 0% |
| `POPULATION` | `numeric` | continuous | 0% |
| `MEDIAN_AGE` | `numeric` | continuous | 0% |
| `AGE_0_5` | `numeric` | continuous | 0% |
| `AGE_15_19` | `numeric` | continuous | 0% |
| `AGE_20_24` | `numeric` | continuous | 0% |
| `AGE_25_34` | `numeric` | continuous | 0% |
| `AGE_35_44` | `numeric` | continuous | 0% |
| `AGE_65` | `numeric` | continuous | 0% |
| `WHITE` | `numeric` | continuous | 0% |
| `BLACK` | `numeric` | continuous | 0% |
| `ASIAN` | `numeric` | continuous | 0% |
| `AP_HISPANI` | `numeric` | continuous | 0% |
| `HOUSEHOLDS` | `numeric` | continuous | 0% |
| `HH_FAMILY` | `numeric` | continuous | 0% |
| `HH_NONFAMI` | `numeric` | continuous | 0% |
| `AVG_HHSIZE` | `numeric` | continuous | 0% |
| `AVG_FAMSIZ` | `numeric` | continuous | 0% |
| `HSNG_UNITS` | `numeric` | continuous | 0% |
| `HU_VACANT` | `numeric` | continuous | 0% |
| `OCCHU_OWNE` | `numeric` | continuous | 0% |
| `OCCHU_RENT` | `numeric` | continuous | 0% |
| `GROUP_QUAR` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: pending

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: BURGLARY ~ AREA + POPULATION + MEDIAN_AGE + AGE_0_5 + AGE_15_19 + AGE_20_24 + AGE_25_34 + AGE_35_44
- CRS note: Corrige le 2026-09-18 : le point actif etait auparavant derive apres application d'un CRS_OVERRIDES obsolete (code/r_catalog/build_sf_datasets.R) qui reinterpretait a tort les coordonnees deja en degres WGS84 du GeoJSON source comme des metres projetes (UTM), puis les reprojetait -- produisant un point degenere pres de l'origine de la projection (x[-89.32,-89.32] y[37.80,37.80] (un seul point repete pour 457 lignes)). Verification directe du GeoJSON source actuel (data/downloads/software/python_datasets/geojson/) : deja declare CRS84 (= WGS84), coordonnees deja correctes en degres reels. CRS_OVERRIDES ne liste plus ce jeu (l'ancienne entree supposait une source encore en coordonnees projetees, obsolete depuis un re-telechargement du fichier source). Nouvelle etendue verifiee : correspond exactement a Cincinnati (Ohio, USA).
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: count
- x_terms_used: AREA + POPULATION + MEDIAN_AGE + AGE_0_5 + AGE_15_19 + AGE_20_24 + AGE_25_34 + AGE_35_44
- y_term_used: BURGLARY

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
    formula: "pending"
    response: "pending"
    predictors: []
    role: "paper_main_specification"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

  ml_or_selected:
    formula: "BURGLARY ~ AREA + POPULATION + MEDIAN_AGE + AGE_0_5 + AGE_15_19 + AGE_20_24 + AGE_25_34 + AGE_35_44"
    response: "BURGLARY"
    predictors: ["AREA", "POPULATION", "MEDIAN_AGE", "AGE_0_5", "AGE_15_19", "AGE_20_24", "AGE_25_34", "AGE_35_44"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.cincinnati`
- Dataset name: geodatasets::cincinnati
- Source family: python-package
- Source: package Python `geodatasets`
- Source URL: https://pypi.org/project/geodatasets/
- Dataset DOI: none
- Publication DOI: pending
- Year: 2023

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "BURGLARY ~ AREA + POPULATION + MEDIAN_AGE + AGE_0_5 + AGE_15_19 + AGE_20_24 + AGE_25_34 + AGE_35_44"
  equation_family: regression_candidate
  model_family: "regression_candidate"
  source_type: generated_system_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 457
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation (derive d'un polygone source par reduction geometrique -- st_point_on_surface(), rien n'est perdu -- voir Type de geometrie et geom_origine)
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-84.5254, -84.4647], y [39.1122, 39.1507] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT (source native : POLYGON, preservee dans `geom_origine` ; geometrie active derivee via `st_point_on_surface()` ou equivalent, methodologie documentee dans code/r_catalog/guide_objets_sf.md section 3-5 -- rien n'est perdu, correction 2026-09-16 apres verification via tools/verify_fiche_crs.py)
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32616 (UTM Zone 16N (EPSG:32616)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement (recalcule le 2026-09-18 sur le point corrige, voir CRS note ; le meme EPSG ressortait par coincidence sur l'ancien bbox degenere)

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/geodatasets/
- License open: yes
- Reproducibility status: available via package Python `geodatasets`
- Code available: yes (package examples and vignettes)
- Repository: python-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_non_continuous_response"
  benchmark_task: "not_current_regression_benchmark"
  package_include: "no"
  has_local_rds: true
  missing_items: "route classification/binomiale/survie ou transformation continue explicite requise"
  reason: "La variable reponse ou la formule n est pas une regression continue scalaire compatible avec le benchmark actuel."
```

- Decision: not_ready_non_continuous_response
- Manque principal: route classification/binomiale/survie ou transformation continue explicite requise
- Raison: La variable reponse ou la formule n est pas une regression continue scalaire compatible avec le benchmark actuel.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`

## Curation documentée — 2026-09-07

Typologie de la reponse selectionnee : count. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

## Curation documentée — 2026-09-18

Correction CRS (2026-09-18) : le point actif de ce jeu etait corrompu par un CRS_OVERRIDES obsolete dans code/r_catalog/build_sf_datasets.R, qui assumait (a raison, historiquement) que le GeoJSON source etait en coordonnees projetees et lui appliquait une reinterpretation UTM/State Plane + reprojection. Verification directe (2026-09-18) du GeoJSON source actuellement telecharge par le pipeline (data/downloads/software/python_datasets/geojson/) montre qu'il est desormais deja correctement declare en CRS84 (WGS84) avec de vraies coordonnees en degres -- la source a du etre re-telechargee/normalisee depuis l'ecriture de cette table, sans que la table de correction soit mise a jour en consequence. Appliquer l'ancienne correction a des degres deja corrects les reinterpretait comme des metres, produisant un point degenere (x[-89.32,-89.32] y[37.80,37.80] (un seul point repete pour 457 lignes)). Retire de CRS_OVERRIDES le 2026-09-18 ; jeu reconstruit sans transformation (deja geographique, aucune correction necessaire). Nouvelle etendue verifiee : correspond exactement a Cincinnati (Ohio, USA). Meme classe de bug que celle trouvee et corrigee le meme jour sur Baltimore/eire, mais avec une cause differente (source changee sous le pipeline, pas un CRS jamais documente).
