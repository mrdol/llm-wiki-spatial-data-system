---
title: paper_airbnb_europe_prices
type: dataset
created: 2026-08-16
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_airbnb_europe_prices.rds
  - MediumPriorityRetry_10_5281_zenodo_4446043
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Determinants of Airbnb prices in European cities: A spatial econometrics approach" (DOI 10.1016/j.tourman.2021.104319).

## Description du jeu de donnees

- Topic: economie urbaine / econometrie spatiale des prix Airbnb
- Observation unit: annonce Airbnb
- Observed population: annonces Airbnb, 10 villes europeennes (Amsterdam, Athenes, Barcelone, Berlin, Budapest, Lisbonne, Londres, Paris, Rome, Vienne), N=51707
- Geographic context: Etendue mesuree dans le RDS : x [-9.22634, 23.78602], y [37.953, 52.64141]; CRS EPSG:4326.
- Temporal context: none (cross-sectional)
- Source description: Determinants of Airbnb prices in European cities: A spatial econometrics approach
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: low
- Paper DOI: 10.1016/j.tourman.2021.104319
- Dataset DOI: 10.5281/zenodo.4446043
- Source URL: 10.5281/zenodo.4446043
- Local raw dir: `data/raw/papers/MediumPriorityRetry_10_5281_zenodo_4446043/`
- Local sf output: `data/final_datasets/sf/paper_airbnb_europe_prices.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `log_price`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `room_type`, `room_shared`, `room_private`, `person_capacity`, `host_is_superhost`, `multi`, `biz`, `cleanliness_rating`, `guest_satisfaction_overall`, `bedrooms`, `dist`, `metro_dist`, `attr_index`, `rest_index`
- Candidate X count in local artifact: 14
- Candidate X typology: categorical, continuous
- Published X variables from paper: room_type, person_capacity, host_is_superhost, multi/biz, cleanliness_rating, guest_satisfaction_overall, bedrooms, dist, metro_dist, attr_index, rest_index
- Published X count: 11
- Coordinates (x, y - excluded from X candidates): `lng`, `lat`
- Identifier columns (excluded from X candidates): `city`, `period`, `realSum`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `log_price` | `numeric` | continuous | [3.549, 9.828] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `airbnb_europe_prices`, la ou les reponses `log_price` viennent du loader papier et/ou des preuves de l article `Determinants of Airbnb prices in European cities: A spatial econometrics approach`. Les covariables X retenues sont `room_type`, `person_capacity`, `host_is_superhost`, `multi`, `biz`, `cleanliness_rating`, `guest_satisfaction_overall`, `bedrooms`, `dist`, `metro_dist`, `attr_index`, `rest_index` ; 2 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`lng`, `lat`), identifiants (`city`, `period`, `realSum`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : manual_review; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `room_type` | `character` | categorical | 0% |
| `room_shared` | `character` | categorical | 0% |
| `room_private` | `character` | categorical | 0% |
| `person_capacity` | `numeric` | continuous | 0% |
| `host_is_superhost` | `character` | categorical | 0% |
| `multi` | `integer` | binary | 0% |
| `biz` | `integer` | binary | 0% |
| `cleanliness_rating` | `numeric` | continuous | 0% |
| `guest_satisfaction_overall` | `numeric` | continuous | 0% |
| `bedrooms` | `integer` | count | 0% |
| `dist` | `numeric` | continuous | 0% |
| `metro_dist` | `numeric` | continuous | 0% |
| `attr_index` | `numeric` | continuous | 0% |
| `rest_index` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: log(price) ~ room_type + person_capacity + host_is_superhost + multi + biz + cleanliness_rating + guest_satisfaction_overall + bedrooms + dist + metro_dist + attr_index + rest_index + W*log(price) [modeles spatiaux (SAR, modele autoregressif spatial ; SEM, modele a erreur spatiale) sur les prix Airbnb log-transformes, matrice de ponderation spatiale W, 10 villes europeennes, weekday/weekend separement]
- x_terms_pub: room_type, person_capacity, host_is_superhost, multi/biz, cleanliness_rating, guest_satisfaction_overall, bedrooms, dist, metro_dist, attr_index, rest_index
- y_term_pub: log_price
- Reference publication: Gyodi & Nawaro (2021), Determinants of Airbnb prices in European cities: A spatial econometrics approach, Tourism Management, doi:10.1016/j.tourman.2021.104319. Le papier ajuste des modeles spatiaux (SAR/SEM) sur le logarithme du prix Airbnb pour 10 villes europeennes (Amsterdam, Athenes, Barcelone, Berlin, Budapest, Lisbonne, Londres, Paris, Rome, Vienne), separement weekday/weekend, avec les covariables exactement presentes dans les fichiers deposes (memes noms de colonnes que le jeu de donnees). Donnees brutes (20 fichiers ville x periode) telechargees directement depuis Zenodo (10.5281/zenodo.4446043) -- pas une reconstruction, N=51707 annonces, coordonnees reelles (lng/lat).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: log_price ~ room_type + person_capacity + host_is_superhost + multi + biz + cleanliness_rating + guest_satisfaction_overall + bedrooms + dist + metro_dist + attr_index + rest_index
- Recommended validation: N lignes=51707; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=21582. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: room_type, person_capacity, host_is_superhost, multi, biz, cleanliness_rating, guest_satisfaction_overall, bedrooms, dist, metro_dist, attr_index, rest_index
- y_term_used: log_price
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
    formula: "log_price ~ room_type + person_capacity + host_is_superhost + multi + biz + cleanliness_rating + guest_satisfaction_overall + bedrooms + dist + metro_dist + attr_index + rest_index"
    response: "log_price"
    predictors: ["room_type", "person_capacity", "host_is_superhost", "multi/biz", "cleanliness_rating", "guest_satisfaction_overall", "bedrooms", "dist", "metro_dist", "attr_index", "rest_index"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "log_price ~ room_type + person_capacity + host_is_superhost + multi + biz + cleanliness_rating + guest_satisfaction_overall + bedrooms + dist + metro_dist + attr_index + rest_index + city + period"
    response: "log_price"
    predictors: ["room_type", "person_capacity", "host_is_superhost", "multi", "biz", "cleanliness_rating", "guest_satisfaction_overall", "bedrooms", "dist", "metro_dist", "attr_index", "rest_index", "city", "period"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "gam_spatial", "random_forest", "gwr"]
    status: "confirmed_continuous_response"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_airbnb_europe_prices`
- Dataset name: 10.5281/zenodo.4446043
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Determinants of Airbnb prices in European cities: A spatial econometrics approach
- Paper DOI: 10.1016/j.tourman.2021.104319
- Dataset DOI: 10.5281/zenodo.4446043
- Source URL: 10.5281/zenodo.4446043
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "log(price) ~ room_type + person_capacity + host_is_superhost + multi + biz + cleanliness_rating + guest_satisfaction_overall + bedrooms + dist + metro_dist + attr_index + rest_index + W*log(price) [modeles spatiaux (SAR, modele autoregressif spatial ; SEM, modele a erreur spatiale) sur les prix Airbnb log-transformes, matrice de ponderation spatiale W, 10 villes europeennes, weekday/weekend separement]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Gyodi & Nawaro (2021), Determinants of Airbnb prices in European cities: A spatial econometrics approach, Tourism Management, doi:10.1016/j.tourman.2021.104319. Le papier ajuste des modeles spatiaux (SAR/SEM) sur le logarithme du prix Airbnb pour 10 villes europeennes (Amsterdam, Athenes, Barcelone, Berlin, Budapest, Lisbonne, Londres, Paris, Rome, Vienne), separement weekday/weekend, avec les covariables exactement presentes dans les fichiers deposes (memes noms de colonnes que le jeu de donnees). Donnees brutes (20 fichiers ville x periode) telechargees directement depuis Zenodo (10.5281/zenodo.4446043) -- pas une reconstruction, N=51707 annonces, coordonnees reelles (lng/lat)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "manual_review"
  benchmark_task: "grouped_or_temporal_validation_review"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "N lignes=51707; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=21582. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification."
  reason: "N lignes=51707; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=21582. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification."
```

- Decision: manual_review
- Manque principal: N lignes=51707; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=21582. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.
- Raison: N lignes=51707; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=21582. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "N lignes=51707; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=21582. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 51707
- k variables: 22
- T periods: 2 (corrige 2026-09-07 -- voir note ci-dessous)
- Variable temporelle: period
- N/T profile: N_grand_T_petit
- Note T corrigee (session 2026-09-07, verification directe du `.rds`) : le champ `period` (valeurs `weekdays`/`weekends`) existe dans les donnees et est deja liste comme "identifier column" exclu de X, mais n'avait pas ete reporte comme variable temporelle ici (T=1/n/a etait errone). Verification empirique : les coordonnees des annonces se chevauchent fortement entre les deux periodes au sein d'une meme ville (ex. Londres : 3905 coordonnees communes aux fichiers weekdays/weekends sur 4614/5379 lignes) -- confirme que la meme annonce est bien re-observee dans les deux periodes, structure explicitement documentee dans le papier ("weekday/weekend separement", 20 fichiers ville x periode). Grouper par ville x annonce (coordonnee), pas seulement par annonce, pour la CV.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 2 periodes (weekdays / weekends), par ville (10 villes x 2 = 20 groupes)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-9.22634, 23.78602], y [37.953, 52.64141]
- Time range: non applicable (period est une modalite categorique weekdays/weekends, pas une date calendaire)
- CRS analyse recommande: pending - multi-zones (span=33deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Attribution 4.0 International
- License URL: https://creativecommons.org/licenses/by/4.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5281/zenodo.4446043 (checked 2026-08-18): rightsList = 'Creative Commons Attribution 4.0 International'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`airbnb_europe_prices` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `airbnb_europe_prices` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`airbnb_europe_prices` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Determinants of Airbnb prices in European cities: A spatial econometrics approach

## Curation documentée — 2026-09-07

Decision conservatoire : N lignes=51707; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=21582. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
