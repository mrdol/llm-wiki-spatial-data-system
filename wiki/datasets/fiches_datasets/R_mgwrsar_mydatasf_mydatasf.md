---
title: R_mgwrsar_mydatasf_mydatasf
type: dataset
created: 2026-08-15
updated: 2026-09-16
sources:
  - data/final_datasets/sf/R_mgwrsar_mydatasf_mydatasf.rds
tags: [dataset, r-package, spatial, point]
---

mydataf is a Simple Feature object with real estate data in south of France.

## Description du jeu de donnees

- Topic: dataset spatial spatio-temporel
- Observation unit: observation spatiale de type POINT
- Observed population: 1403 enregistrements dans l’artefact local R_mgwrsar_mydatasf_mydatasf.rds; unite declaree : observation spatiale de type POINT. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: Etendue mesuree dans le RDS : x [873719.58, 892123.25], y [6295180.18, 6300866.67]; CRS EPSG:2154.
- Temporal context: dimension temporelle structurelle detectee
- Source description: mydataf is a Simple Feature object with real estate data in south of France.
- Description source: package R `mgwrsar`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `price`
- Candidate Y typology: continuous
- Candidate X variables: `year`, `footage`, `land_area`, `pbb45`, `T`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `price` | `numeric` | continuous | [2500, 2400000] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Le prix (price) est la variable réponse naturelle pour un dataset immobilier. Les autres variables — ancienneté/année (year), surface habitable (footage), surface du terrain (land_area), consommation énergétique probable (pbb45) et type de bien (T) — constituent des covariables explicatives classiques du prix immobilier.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `year` | `numeric` | continuous | 0% |
| `footage` | `numeric` | continuous | 0% |
| `land_area` | `numeric` | continuous | 0% |
| `pbb45` | `numeric` | continuous | 0% |
| `T` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: price ~ year + footage + land_area
- x_terms_pub: year, footage, land_area
- y_term_pub: price
- Reference publication: Geniaux, G. and Martinetti, D. (2018), meme papier que mydata. Formule confirmee dans la vignette officielle du package ("Estimating GWR and Mixed GWR Models with mgwrsar package: An Introduction with House Price Data"), donnees issues de data.gouv.fr (Demandes de valeurs foncieres).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: price ~ year + footage + land_area
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: year, footage, land_area
- y_term_used: price

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "price ~ year + footage + land_area"
    response: "price"
    predictors: ["year, footage, land_area"]
    role: "simple_baseline"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Geniaux, G. and Martinetti, D. (2018), meme papier que mydata. Formule confirmee dans la vignette officielle du package (\"Estimating GWR and Mixed GWR Models with mgwrsar package: An Introduction with House Price Data\"), donnees issues de data.gouv.fr (Demandes de valeurs foncieres)."
    estimator_context: ["linear_regression", "kriging_auxiliary", "spatial_baseline"]
    status: "confirmed"

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
    formula: "pending"
    response: "pending"
    predictors: []
    role: "ml_candidate_features"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `R_mgwrsar_mydatasf_mydatasf`
- Dataset name: mgwrsar::mydatasf
- Source family: r-package
- Source: package R `mgwrsar` (version 1.3.2)
- Source URL: https://CRAN.R-project.org/package=mgwrsar
- Dataset DOI: none
- Publication DOI: 10.1016/j.regsciurbeco.2017.04.001
- Year: unknown

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "price ~ year + footage + land_area"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Geniaux, G. and Martinetti, D. (2018), meme papier que mydata. Formule confirmee dans la vignette officielle du package (\"Estimating GWR and Mixed GWR Models with mgwrsar package: An Introduction with House Price Data\"), donnees issues de data.gouv.fr (Demandes de valeurs foncieres)."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatio-temporel
- Structure: panel
- N observations: 1403
- T periods: 16
- Variable temporelle: year
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (1403) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 1123 ; panel NON EQUILIBRE (T par unite : min=1, mediane=1, max=12). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 1123 unites spatiales distinctes, pas sur les 1403 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.
- Temporal note: dimension temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: pending inspection
- Spatial extent: x [873719.58, 892123.25], y [6295180.18, 6300866.67] (EPSG:2154)
- Time range: pending inspection
- Type de geometrie: POINT
- CRS EPSG: 2154
- CRS nom: RGF93 v1 / Lambert-93
- CRS analyse recommande: aucune reprojection necessaire -- CRS deja projete et metrique. (EPSG:2154, RGF93 v1 / Lambert-93)

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://cran.r-project.org/package=mgwrsar
- License open: yes
- License evidence: CRAN package DB (crandb.r-pkg.org, checked 2026-08-18): License field = 'GPL (>= 2)'.
- Reproducibility status: available via package R `mgwrsar`
- Code available: yes (package examples and vignettes)
- Repository: r-package

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
  eligible_estimators:
    - estimator: mgwrsar_gwr
      basis: scientific_evidence
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "GWR mentionne dans la source."
    - estimator: ols
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Regression lineaire standard, baseline generique pour reponse continue."
    - estimator: gam_spatial
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "GAM (mgcv), baseline non-lineaire generique pour reponse continue."
    - estimator: random_forest
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Alternative ML non-parametrique generique, Y continu."
    - estimator: xgboost
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Alternative ML non-parametrique generique, Y continu."
  conditionally_eligible_estimators: []
  ineligible_reason: "n/a -- estimateurs generiques eligibles (voir eligible_estimators)."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: OK - CRS renseigne dans le Bloc 5 (2154).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: WARN - licence non renseignee automatiquement.

## Note -- promotion en lot (2026-09-09)

Formule, reponse et covariables deja resolues (Y/X/formula_used complets avant cette passe). Seul le bloc 'Estimator eligibility' etait vide -- rempli ici avec les estimateurs generiques adaptes a la typologie Y (continuous), sur decision explicite de l'utilisateur de revoir en lot les fiches 'manual_review' deja completes. Base 'scientific_evidence' reservee aux cas ou le texte de la fiche documente deja une methode precise ; sinon 'benchmark_use'/'generated_candidate' (pas de surinterpretation de la methode publiee).

## Related Pages

- Source: package R `mgwrsar`

## Curation documentée — 2026-09-07

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

Correction 2026-09-16 (mode production de secours) : le champ 'CRS analyse recommande' affirmait a tort que le CRS source etait non geographique/inconnu alors qu'il etait deja renseigne juste au-dessus -- corrige (voir le champ lui-meme pour le texte actuel).
