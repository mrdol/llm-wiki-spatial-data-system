---
title: R_SpatialEpi_scotland_sf_scotland_sf
type: dataset
created: 2026-08-15
updated: 2026-09-16
sources:
  - data/final_datasets/sf/R_SpatialEpi_scotland_sf_scotland_sf.rds
tags: [dataset, r-package, spatial, point]
---

County-level (n=56) data for lip cancer among males in Scotland between 1975-1980

## Description du jeu de donnees

- Topic: sante publique / epidemiologie spatiale
- Observation unit: individu, cas sanitaire ou unite spatiale de sante
- Observed population: population sanitaire documentee par le package source
- Geographic context: Etendue mesuree dans le RDS : x [120.700611287043, 450.670074642068], y [559.4105, 1197.2]; CRS +proj=utm.
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: County-level (n=56) data for lip cancer among males in Scotland between 1975-1980
- Description source: package R `SpatialEpi`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `cases`
- Candidate Y typology: continuous
- Candidate X variables: `expected`, `AFF`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `cases` | `numeric` | count | [0, 39] | 0% |


> Note doc : number of cases, population and strata

> Selection Y/X (claude-sonnet-4-6) : cases (nombre de cas de cancer de la lèvre observés) est la variable réponse naturelle pour la modélisation de cette maladie. expected (cas attendus sous hypothèse nulle) sert de terme d'offset ou de covariable de standardisation, et AFF (proportion de la population active dans l'agriculture, la pêche et la forêt, proxy d'exposition solaire) est la covariable explicative classique de ce jeu de données. county.names est un libellé géographique ignoré.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `expected` | `numeric` | continuous | 0% |
| `AFF` | `numeric` | rate | 0% |


### Formule — niveau publication

- formula_pub: cases ~ AFF + offset(log(expected))
- x_terms_pub: AFF
- y_term_pub: cases
- Reference publication: Clayton D. and Kaldor J. (1987) Empirical Bayes estimates of age-standardized relative risks for use in disease mapping. Biometrics, 43, 671-681.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: cases ~ AFF + offset(log(expected))
- benchmark_task_note: cases est un nombre de cas avec exposition expected en offset.
- Selected Y evidence: cases est un nombre de cas avec exposition expected en offset.
- Selected Y typology: count
- x_terms_used: AFF
- y_term_used: cases

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "cases ~ AFF + offset(log(expected))"
    response: "cases"
    predictors: ["AFF"]
    role: "simple_baseline"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Clayton D. and Kaldor J. (1987) Empirical Bayes estimates of age-standardized relative risks for use in disease mapping. Biometrics, 43, 671-681."
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

- Dataset ID: `R_SpatialEpi_scotland_sf_scotland_sf`
- Dataset name: SpatialEpi::scotland
- Source family: r-package
- Source: package R `SpatialEpi` (version 1.2.8)
- Source URL: https://CRAN.R-project.org/package=SpatialEpi
- Dataset DOI: none
- Publication DOI: 10.2307/2532003
- Year: 2012

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "cases ~ AFF + offset(log(expected))"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Clayton D. and Kaldor J. (1987) Empirical Bayes estimates of age-standardized relative risks for use in disease mapping. Biometrics, 43, 671-681."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 56
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [120.7006, 450.6701], y [559.4105, 1197.2] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT (source native : MULTIPOLYGON, preservee dans `geom_origine` ; geometrie active derivee via `st_point_on_surface()` ou equivalent, methodologie documentee dans code/r_catalog/guide_objets_sf.md section 3-5 -- rien n'est perdu, correction 2026-09-16 apres verification via tools/verify_fiche_crs.py)
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL-2
- License URL: https://CRAN.R-project.org/package=SpatialEpi
- License open: yes
- Reproducibility status: available via package R `SpatialEpi`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "count_poisson_offset"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte ; verifier le support de offset() dans le harnais avant benchmark reel"
  reason: "Bloc estimator_eligibility complete le 2026-09-08. Jeu classique de cartographie de maladies (cancer de la levre, 56 comtes ecossais, 1975-1980), reference confirmee via tools::Rd_db('SpatialEpi') et le papier source Clayton & Kaldor (1987) Biometrics 43:671-681 (estimation empirique bayesienne des risques relatifs standardises) -- le package documente lui-meme SMR=cases/expected, confirmant la structure Poisson avec offset log(expected) deja utilisee par formula_used. Routage comptage (GLM/GAM Poisson) ajoute au harnais cette semaine ; le support explicite du terme offset() dans le harnais reste a verifier avant benchmark reel (limite documentee, pas une invention de capacite)."
```

- Decision: ready
- Manque principal: verifier le support de offset() dans le harnais avant benchmark reel
- Raison: Bloc estimator_eligibility complete le 2026-09-08. Jeu classique de cartographie de maladies (cancer de la levre, 56 comtes ecossais, 1975-1980), reference confirmee via tools::Rd_db('SpatialEpi') et le papier source Clayton & Kaldor (1987) Biometrics 43:671-681 (estimation empirique bayesienne des risques relatifs standardises) -- le package documente lui-meme SMR=cases/expected, confirmant la structure Poisson avec offset log(expected) deja utilisee par formula_used. Routage comptage (GLM/GAM Poisson) ajoute au harnais cette semaine ; le support explicite du terme offset() dans le harnais reste a verifier avant benchmark reel (limite documentee, pas une invention de capacite).

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators:
    - estimator: ols
      basis: generated_candidate
      source_ref: "Routage comptage ajoute au harnais cette semaine (glm(family=poisson())) ; offset(log(expected)) deja present dans formula_used."
      notes: "Structure SMR=cases/expected confirmee par la documentation officielle du package SpatialEpi -- cadre Poisson standard, mais le support technique du terme offset() par le harnais reste a verifier avant tout benchmark reel."
    - estimator: gam_spatial
      basis: generated_candidate
      source_ref: "Routage comptage ajoute au harnais cette semaine (mgcv::gam(family=poisson()))."
      notes: "Meme reserve sur le support de l'offset que ci-dessus."
  conditionally_eligible_estimators: []
  ineligible_reason: "Bloc estimator_eligibility complete le 2026-09-08. Jeu classique de cartographie de maladies (cancer de la levre, 56 comtes ecossais, 1975-1980), reference confirmee via tools::Rd_db('SpatialEpi') et le papier source Clayton & Kaldor (1987) Biometrics 43:671-681 (estimation empirique bayesienne des risques relatifs standardises) -- le package documente lui-meme SMR=cases/expected, confirmant la structure Poisson avec offset log(expected) deja utilisee par formula_used. Routage comptage (GLM/GAM Poisson) ajoute au harnais cette semaine ; le support explicite du terme offset() dans le harnais reste a verifier avant benchmark reel (limite documentee, pas une invention de capacite)."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL-2).

## Related Pages

- Source: package R `SpatialEpi`

## Curation documentée — 2026-09-07

Decision conservatoire : Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. cases est un nombre de cas avec exposition expected en offset. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : count. cases est un nombre de cas avec exposition expected en offset.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
