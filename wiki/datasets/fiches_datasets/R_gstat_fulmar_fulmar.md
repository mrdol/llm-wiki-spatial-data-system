---
title: R_gstat_fulmar_fulmar
type: dataset
created: 2026-08-15
updated: 2026-09-07
sources:
  - data/final_datasets/sf/R_gstat_fulmar_fulmar.rds
tags: [dataset, r-package, spatial, point]
---

Airborne counts of Fulmaris glacialis during the Aug/Sept 1998 and 1999 flights on the Dutch (Netherlands) part of the North Sea (NCP, Nederlands Continentaal Plat).

## Description du jeu de donnees

- Topic: dataset spatial spatio-temporel
- Observation unit: observation spatiale de type POINT
- Observed population: 1324 enregistrements dans l’artefact local R_gstat_fulmar_fulmar.rds; unite declaree : observation spatiale de type POINT. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: Etendue mesuree dans le RDS : x [476209.6, 739041.8], y [5694947, 6150942]; CRS non renseigne, repere/unites a documenter.
- Temporal context: dimension temporelle structurelle detectee
- Source description: Airborne counts of Fulmaris glacialis during the Aug/Sept 1998 and 1999 flights on the Dutch (Netherlands) part of the North Sea (NCP, Nederlands Continentaal Plat).
- Description source: package R `gstat`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `fulmar`
- Candidate Y typology: continuous
- Candidate X variables: `depth`, `coast`, `year`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `fulmar` | `numeric` | continuous | [0, 46.4866] | 0% |


> Selection Y/X (claude-sonnet-4-6) : fulmar représente les comptages de Fulmarus glacialis, variable réponse écologique naturelle. depth (profondeur) et coast (distance à la côte) sont des covariables environnementales classiques pour modéliser la distribution d'oiseaux marins, et year capture l'effet interannuel. La colonne T est ignorée car elle semble redondante avec year (même plage [1998,1999]).

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `depth` | `numeric` | continuous | 0% |
| `coast` | `numeric` | continuous | 0% |
| `year` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: fulmar ~ depth + coast (referencee dans catalogue)
- x_terms_pub: depth, coast
- y_term_pub: fulmar
- Reference publication: Pebesma, E.J., Duin, R.N.M. & Burrough, P.A. (2005). Mapping Sea Bird Densities over the North Sea: Spatially Aggregated Estimates and Temporal Changes. Environmetrics, 16(6), 573-587.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: fulmar ~ depth + coast
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: depth, coast
- y_term_used: fulmar

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "fulmar ~ depth + coast"
    response: "fulmar"
    predictors: ["depth, coast"]
    role: "simple_baseline"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Pebesma, E.J., Duin, R.N.M. & Burrough, P.A. (2005). Mapping Sea Bird Densities over the North Sea: Spatially Aggregated Estimates and Temporal Changes. Environmetrics, 16(6), 573-587."
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

- Dataset ID: `R_gstat_fulmar_fulmar`
- Dataset name: gstat::fulmar
- Source family: r-package
- Source: package R `gstat` (version 2.1.6)
- Source URL: https://CRAN.R-project.org/package=gstat
- Dataset DOI: none
- Publication DOI: 10.1002/env.720
- Year: 2003

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "fulmar ~ depth + coast"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Pebesma, E.J., Duin, R.N.M. & Burrough, P.A. (2005). Mapping Sea Bird Densities over the North Sea: Spatially Aggregated Estimates and Temporal Changes. Environmetrics, 16(6), 573-587."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatio-temporel
- Structure: panel
- N observations: 1324
- T periods: 2
- Variable temporelle: year
- N/T profile: N_grand_T_moyen
- Note N/T (session 2026-08-17, verification directe du `.rds`) : verification empirique montre qu'il n'y a AUCUNE repetition de geometrie (N spatial = N observations exactement) malgre la classification 'Structure: panel_ou_series' / 'Data type: spatio-temporel' ci-dessus -- chaque ligne correspond a un lieu unique. Ce n'est donc pas un panel au sens statistique (pas de correlation intra-unite a modeliser), plutot une coupe transversale avec une covariable/dimension temporelle associee a chaque point distinct.
- Temporal note: dimension temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: pending inspection
- Spatial extent: x [476209.6, 739041.8], y [5694947, 6150942] (CRS unknown)
- Time range: pending inspection
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2.0)
- License URL: https://CRAN.R-project.org/package=gstat
- License open: yes
- Reproducibility status: available via package R `gstat`
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
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2.0)).

## Note -- promotion en lot (2026-09-09)

Formule, reponse et covariables deja resolues (Y/X/formula_used complets avant cette passe). Seul le bloc 'Estimator eligibility' etait vide -- rempli ici avec les estimateurs generiques adaptes a la typologie Y (continuous), sur decision explicite de l'utilisateur de revoir en lot les fiches 'manual_review' deja completes. Base 'scientific_evidence' reservee aux cas ou le texte de la fiche documente deja une methode precise ; sinon 'benchmark_use'/'generated_candidate' (pas de surinterpretation de la methode publiee).

## Related Pages

- Source: package R `gstat`

## Curation documentée — 2026-09-07

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
