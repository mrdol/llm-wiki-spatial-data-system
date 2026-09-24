---
title: R_spatstat.data_clmfires_clmfires
type: dataset
created: 2026-08-15
updated: 2026-09-23
sources:
  - data/final_datasets/sf/R_spatstat.data_clmfires_clmfires.rds
tags: [dataset, r-package, spatial, point]
---

This dataset is a record of forest fires in the Castilla-La Mancha region of Spain between 1998 and 2007. This region is approximately 400 by 400 kilometres. The coordinates are recorded in kilometres.

## Description du jeu de donnees

- Topic: dataset spatial spatio-temporel
- Observation unit: observation spatiale de type POINT
- Observed population: 8488 enregistrements dans l’artefact local R_spatstat.data_clmfires_clmfires.rds; unite declaree : observation spatiale de type POINT. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: Etendue mesuree dans le RDS : x [8.248001775, 385.34301], y [24.2210124, 377.1749982]; CRS non renseigne, repere/unites a documenter.
- Temporal context: dimension temporelle structurelle detectee
- Source description: This dataset is a record of forest fires in the Castilla-La Mancha region of Spain between 1998 and 2007. This region is approximately 400 by 400 kilometres. The coordinates are recorded in kilometres.
- Description source: package R `spatstat.data`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `burnt.area`
- Candidate Y typology: continuous
- Candidate X variables: `cause`, `julian.date`
- Candidate X typology: categorical, continuous
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `burnt.area` | `numeric` | continuous | [0, 12887.37] | 0% |


> Selection Y/X (claude-sonnet-4-6) : burnt.area est la variable réponse naturelle pour modéliser la sévérité des incendies de forêt. cause et julian.date sont des covariables explicatives pertinentes (origine du feu et saisonnalité). La colonne date et T semblent redondantes avec julian.date ou mal typées, et sont ignorées.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `cause` | `factor` | categorical | 0% |
| `julian.date` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: burnt.area ~ cause (referencee dans catalogue)
- x_terms_pub: cause
- y_term_pub: burnt.area
- Reference publication: Forest Fire Database of Castilla-La Mancha region, Spain, 1998-2007, distributed as spatstat.data::clmfires (Baddeley, Rubak & Turner, spatstat package). Cause coded as lightning/accident/intentional/other. Related published analyses of this fire database include Diaz-Delgado, Lloret & Pons (2004) and later point-process studies (e.g. Comas, Mateu et al.).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: burnt.area ~ cause
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: cause
- y_term_used: burnt.area

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "burnt.area ~ cause"
    response: "burnt.area"
    predictors: ["cause"]
    role: "simple_baseline"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Forest Fire Database of Castilla-La Mancha region, Spain, 1998-2007, distributed as spatstat.data::clmfires (Baddeley, Rubak & Turner, spatstat package). Cause coded as lightning/accident/intentional/other. Related published analyses of this fire database include Diaz-Delgado, Lloret & Pons (2004) and later point-process studies (e.g. Comas, Mateu et al.)."
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

- Dataset ID: `R_spatstat.data_clmfires_clmfires`
- Dataset name: spatstat.data::clmfires
- Source family: r-package
- Source: package R `spatstat.data` (version 3.1.9)
- Source URL: https://CRAN.R-project.org/package=spatstat.data
- Dataset DOI: none
- Publication DOI: pending
- Year: 2017

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "burnt.area ~ cause"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Forest Fire Database of Castilla-La Mancha region, Spain, 1998-2007, distributed as spatstat.data::clmfires (Baddeley, Rubak & Turner, spatstat package). Cause coded as lightning/accident/intentional/other. Related published analyses of this fire database include Diaz-Delgado, Lloret & Pons (2004) and later point-process studies (e.g. Comas, Mateu et al.)."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatio-temporel
- Structure: panel
- N observations: 8488
- T periods: 2041
- Variable temporelle: date
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : verification empirique montre qu'il n'y a AUCUNE repetition de geometrie (N spatial = N observations exactement) malgre la classification 'Structure: panel_ou_series' / 'Data type: spatio-temporel' ci-dessus -- chaque ligne correspond a un lieu unique. Ce n'est donc pas un panel au sens statistique (pas de correlation intra-unite a modeliser), plutot une coupe transversale avec une covariable/dimension temporelle associee a chaque point distinct.
- Temporal note: dimension temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: pending inspection
- Spatial extent: x [8.248, 385.343], y [24.221, 377.175] (CRS unknown)
- Time range: pending inspection
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending -- CRS source non geographique ou inconnu
- CRS note (session 2026-09-23, relecture complete de la doc du package spatstat.data, section 'Remark' -- pas lue jusque-la lors du premier passage) : 'The precision with which the coordinates of the locations of the fires changed between 2003 and 2004. From 1998 to 2003 many of the locations were recorded as the centroid of the corresponding district unit; the rest were recorded as exact UTM coordinates of the centroids of the fires. In 2004 the system changed and the exact UTM coordinates ... were used for all fires.' Confirme donc l'usage de coordonnees UTM (au moins a partir de 2004, partiellement avant), mais **zone UTM et datum ne sont documentes nulle part** dans la doc du package ni ailleurs dans le materiel local -- seule provenance declaree : 'Professor Jorge Mateu'. Castilla-La Mancha est entierement en zone UTM 30N, ce qui rendrait EPSG:25830 (ETRS89) ou EPSG:23030 (ED50) plausibles par deduction geographique seule -- mais conformement a la convention du projet (jamais assigner un CRS par inference, voir paper_crane), **aucun EPSG n'est attribue** tant que le datum n'est pas confirme par une source explicite. CRS reste : indetermine ; projection : UTM (zone/datum non documentes) ; unite des coordonnees de l'objet ppp : kilometres.

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://CRAN.R-project.org/package=spatstat.data
- License open: yes
- Reproducibility status: available via package R `spatstat.data`
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
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2)).

## Note -- promotion en lot (2026-09-09)

Formule, reponse et covariables deja resolues (Y/X/formula_used complets avant cette passe). Seul le bloc 'Estimator eligibility' etait vide -- rempli ici avec les estimateurs generiques adaptes a la typologie Y (continuous), sur decision explicite de l'utilisateur de revoir en lot les fiches 'manual_review' deja completes. Base 'scientific_evidence' reservee aux cas ou le texte de la fiche documente deja une methode precise ; sinon 'benchmark_use'/'generated_candidate' (pas de surinterpretation de la methode publiee).

## Related Pages

- Source: package R `spatstat.data`

## Curation documentée — 2026-09-07

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
