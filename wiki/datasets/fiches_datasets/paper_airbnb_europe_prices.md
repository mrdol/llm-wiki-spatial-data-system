---
title: paper_airbnb_europe_prices
type: dataset
created: 2026-09-14
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
- Candidate X typology: categorical, continuous, unknown
- Published X variables from paper: room_private (dummy chambre privee, reference = logement entier), room_shared (dummy chambre partagee), person_capacity, host_is_superhost, multi/biz (professionnalisation de l'hote), cleanliness_rating, guest_satisfaction_overall, bedrooms, dist (distance au centre-ville), metro_dist (distance au metro), attr_index (indice d'attractivite touristique, specification principale -- rest_index teste separement, cf. Note)
- Published X count: 11
- Coordinates (x, y - excluded from X candidates): `lng`, `lat`
- Identifier columns (excluded from X candidates): `city`, `period`, `realSum`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `log_price` | `numeric` | continuous | [3.549, 9.828] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `airbnb_europe_prices`, la ou les reponses `log_price` viennent du loader papier et/ou des preuves de l article `Determinants of Airbnb prices in European cities: A spatial econometrics approach`. Les covariables X retenues sont `room_private`, `room_shared`, `person_capacity`, `host_is_superhost`, `multi`, `biz`, `cleanliness_rating`, `guest_satisfaction_overall`, `bedrooms`, `dist`, `metro_dist`, `attr_index` ; 2 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`lng`, `lat`), identifiants (`city`, `period`, `realSum`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready; la promotion package reste conditionnee au bloc benchmark_readiness.

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
| `bedrooms` | `integer` | unknown | 0% |
| `dist` | `numeric` | continuous | 0% |
| `metro_dist` | `numeric` | continuous | 0% |
| `attr_index` | `numeric` | continuous | 0% |
| `rest_index` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: SDM (spatial Durbin model, WX+WY, modele retenu) : log_price ~ rho*W*log_price + room_private + room_shared + person_capacity + host_is_superhost + multi + biz + cleanliness_rating + guest_satisfaction_overall + bedrooms + dist + metro_dist + attr_index + W*X [Gyodi & Nawaro (2021), Eq. 5 p.6 ; 4 modeles estimes -- OLS, SLX (WX), SAR (WY), SDM (WX+WY) -- SDM retenu (meilleure log-vraisemblance dans les 10 villes, AIC le plus bas dans 7/10) ; SAR second meilleur ; aucun modele SEM n'est estime par ce papier (SEM cite uniquement dans la revue de litterature d'autres etudes, jamais ajuste ici) ; rest_index teste separement d'attr_index (colinearite VIF documentee, jamais dans la meme regression) ; W = k plus proches voisins (k=10) standardise par ligne, robustesse testee avec k=5/25/50 et W de distance a 500m/1000m]
- x_terms_pub: room_private (dummy chambre privee, reference = logement entier), room_shared (dummy chambre partagee), person_capacity, host_is_superhost, multi/biz (professionnalisation de l'hote), cleanliness_rating, guest_satisfaction_overall, bedrooms, dist (distance au centre-ville), metro_dist (distance au metro), attr_index (indice d'attractivite touristique, specification principale -- rest_index teste separement, cf. Note)
- y_term_pub: log_price (logarithme du prix Airbnb, distribution asymetrique justifiant la transformation log selon le papier)
- Reference publication: Gyodi & Nawaro (2021), Determinants of Airbnb prices in European cities: A spatial econometrics approach, Tourism Management 86:104319, doi:10.1016/j.tourman.2021.104319. CORRECTION (2026-09-10, verification directe PDF+TEI apres signalement utilisateur) : (1) room_type (colonne locale) n'est pas la variable publiee -- Table 1 documente room_private et room_shared comme 2 dummies separes (reference = logement entier), confirme par Fig. 3 (coefficients direct_room_shared/direct_room_private distincts) ; les 2 vraies colonnes existent dans l'artefact local et remplacent room_type. (2) Le papier N'ESTIME PAS de modele SEM : Section 4.1 confirme 4 modeles compares (OLS, SLX/WX, SAR/WY, SDM/WX+WY, Eq. 3-5), SDM retenu ('we will focus on the results of the SDM model', meilleure log-vraisemblance/AIC), SAR second. SEM n'apparait que dans la revue de litterature d'autres etudes (Section 3.2, ex. Halleck Vega & Elhorst 2015), jamais ajuste par ces auteurs. (3) attr_index et rest_index ne sont jamais dans la meme regression : test VIF documente une colinearite entre les 2 indices TripAdvisor, 'the two variables will be tested separately in the analysis' -- attr_index est la specification presentee en premier (Figs. 3-5), rest_index en variante secondaire (fin de section 4.2) ; formula_used retient attr_index. (4) Construction de W documentee par les auteurs (Section 3.2, p.6) : 'we decided to calculate row-standardised W with the 10 closest neighbours' (k=10, standardise par ligne) comme choix principal ; robustesse testee avec k=5/25/50 voisins et W de distance a 500m et 1000m. (5) 'weekday/weekend' n'est PAS une structure panel a 2 periodes du point de vue du papier : Section 3.1 dit explicitement 'The analysis is based on the weekday samples, while the weekend data are used for robustness checks' (Appendix B, Fig. B.1) -- modele principal sur l'echantillon weekday uniquement, weekend = re-estimation independante de robustesse, pas un panel joint. Le fait que les memes annonces apparaissent dans les 2 fichiers (repetitions de coordonnees reelles) reste vrai et justifie toujours un regroupement par annonce en CV, mais ce n'est pas une structure temporelle documentee par le papier lui-meme. Donnees brutes (20 fichiers ville x periode) telechargees directement depuis Zenodo (10.5281/zenodo.4446043) -- pas une reconstruction, N=51707 annonces, coordonnees reelles (lng/lat).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

### Formule - niveau systeme

- formula_used: log_price ~ room_private + room_shared + person_capacity + host_is_superhost + multi + biz + cleanliness_rating + guest_satisfaction_overall + bedrooms + dist + metro_dist + attr_index
- License evidence: DataCite API record for DOI 10.5281/zenodo.4446043 (checked 2026-08-18): rightsList = 'Creative Commons Attribution 4.0 International'.
- Recommended validation: N lignes=51707; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=21582. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: room_private, room_shared, person_capacity, host_is_superhost, multi, biz, cleanliness_rating, guest_satisfaction_overall, bedrooms, dist, metro_dist, attr_index
- y_term_used: log_price
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

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
    formula: "log_price ~ room_private + room_shared + person_capacity + host_is_superhost + multi + biz + cleanliness_rating + guest_satisfaction_overall + bedrooms + dist + metro_dist + attr_index"
    response: "log_price (logarithme du prix Airbnb, distribution asymetrique justifiant la transformation log selon le papier)"
    predictors: ["room_private (dummy chambre privee, reference = logement entier)", "room_shared (dummy chambre partagee)", "person_capacity", "host_is_superhost", "multi/biz (professionnalisation de l'hote)", "cleanliness_rating", "guest_satisfaction_overall", "bedrooms", "dist (distance au centre-ville)", "metro_dist (distance au metro)", "attr_index (indice d'attractivite touristique, specification principale -- rest_index teste separement, cf. Note)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "log_price ~ room_private + room_shared + person_capacity + host_is_superhost + multi + biz + cleanliness_rating + guest_satisfaction_overall + bedrooms + dist + metro_dist + attr_index + city + period"
    response: "log_price"
    predictors: ["room_private", "room_shared", "person_capacity", "host_is_superhost", "multi", "biz", "cleanliness_rating", "guest_satisfaction_overall", "bedrooms", "dist", "metro_dist", "attr_index", "city", "period"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sdm_mixed", "gam_spatial", "random_forest", "gwr"]
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
  equation_text: "SDM (spatial Durbin model, WX+WY, modele retenu) : log_price ~ rho*W*log_price + room_private + room_shared + person_capacity + host_is_superhost + multi + biz + cleanliness_rating + guest_satisfaction_overall + bedrooms + dist + metro_dist + attr_index + W*X [Gyodi & Nawaro (2021), Eq. 5 p.6 ; 4 modeles estimes -- OLS, SLX (WX), SAR (WY), SDM (WX+WY) -- SDM retenu (meilleure log-vraisemblance dans les 10 villes, AIC le plus bas dans 7/10) ; SAR second meilleur ; aucun modele SEM n'est estime par ce papier (SEM cite uniquement dans la revue de litterature d'autres etudes, jamais ajuste ici) ; rest_index teste separement d'attr_index (colinearite VIF documentee, jamais dans la meme regression) ; W = k plus proches voisins (k=10) standardise par ligne, robustesse testee avec k=5/25/50 et W de distance a 500m/1000m]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Gyodi & Nawaro (2021), Determinants of Airbnb prices in European cities: A spatial econometrics approach, Tourism Management 86:104319, doi:10.1016/j.tourman.2021.104319. CORRECTION (2026-09-10, verification directe PDF+TEI apres signalement utilisateur) : (1) room_type (colonne locale) n'est pas la variable publiee -- Table 1 documente room_private et room_shared comme 2 dummies separes (reference = logement entier), confirme par Fig. 3 (coefficients direct_room_shared/direct_room_private distincts) ; les 2 vraies colonnes existent dans l'artefact local et remplacent room_type. (2) Le papier N'ESTIME PAS de modele SEM : Section 4.1 confirme 4 modeles compares (OLS, SLX/WX, SAR/WY, SDM/WX+WY, Eq. 3-5), SDM retenu ('we will focus on the results of the SDM model', meilleure log-vraisemblance/AIC), SAR second. SEM n'apparait que dans la revue de litterature d'autres etudes (Section 3.2, ex. Halleck Vega & Elhorst 2015), jamais ajuste par ces auteurs. (3) attr_index et rest_index ne sont jamais dans la meme regression : test VIF documente une colinearite entre les 2 indices TripAdvisor, 'the two variables will be tested separately in the analysis' -- attr_index est la specification presentee en premier (Figs. 3-5), rest_index en variante secondaire (fin de section 4.2) ; formula_used retient attr_index. (4) Construction de W documentee par les auteurs (Section 3.2, p.6) : 'we decided to calculate row-standardised W with the 10 closest neighbours' (k=10, standardise par ligne) comme choix principal ; robustesse testee avec k=5/25/50 voisins et W de distance a 500m et 1000m. (5) 'weekday/weekend' n'est PAS une structure panel a 2 periodes du point de vue du papier : Section 3.1 dit explicitement 'The analysis is based on the weekday samples, while the weekend data are used for robustness checks' (Appendix B, Fig. B.1) -- modele principal sur l'echantillon weekday uniquement, weekend = re-estimation independante de robustesse, pas un panel joint. Le fait que les memes annonces apparaissent dans les 2 fichiers (repetitions de coordonnees reelles) reste vrai et justifie toujours un regroupement par annonce en CV, mais ce n'est pas une structure temporelle documentee par le papier lui-meme. Donnees brutes (20 fichiers ville x periode) telechargees directement depuis Zenodo (10.5281/zenodo.4446043) -- pas une reconstruction, N=51707 annonces, coordonnees reelles (lng/lat)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Y/X/formula_used deja resolus ; estimateurs generiques (continuous) ajoutes en revue de lot du 2026-09-09."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Y/X/formula_used deja resolus ; estimateurs generiques (continuous) ajoutes en revue de lot du 2026-09-09.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "Y/X/formula_used deja resolus ; estimateurs generiques (continuous) ajoutes en revue de lot du 2026-09-09."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 51707
- k variables: 22
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-9.22634, 23.78602], y [37.953, 52.64141]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending — multi-zones (span=33deg) -- etendue compatible avec un grand pays/une region ; verifier qu'une projection nationale/regionale existe et convient a cette zone avant de l'utiliser, sinon envisager une projection continentale equal-area

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Attribution 4.0 International
- License URL: https://creativecommons.org/licenses/by/4.0/legalcode
- License open: yes
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
