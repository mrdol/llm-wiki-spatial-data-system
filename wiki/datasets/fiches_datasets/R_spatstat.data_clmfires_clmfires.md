---
title: R_spatstat.data_clmfires_clmfires
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/R_spatstat.data_clmfires_clmfires.rds
tags: [dataset, r-package, spatial, point]
---

This dataset is a record of forest fires in the Castilla-La Mancha region of Spain between 1998 and 2007. This region is approximately 400 by 400 kilometres. The coordinates are recorded in kilometres.

## Description du jeu de donnees

- Topic: dataset spatial spatio-temporel
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
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
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

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
  benchmark_status: "almost_ready_cross_section_or_panel_reduction"
  benchmark_task: "regression_spatial_requires_temporal_policy"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "choisir une coupe temporelle ou une politique panel explicite avant benchmark package"
  reason: "Le jeu contient une dimension temporelle; il peut etre benchmarkable apres choix documente d une coupe ou d une aggregation temporelle."
```

- Decision: almost_ready_cross_section_or_panel_reduction
- Manque principal: choisir une coupe temporelle ou une politique panel explicite avant benchmark package
- Raison: Le jeu contient une dimension temporelle; il peut etre benchmarkable apres choix documente d une coupe ou d une aggregation temporelle.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2)).

## Related Pages

- Source: package R `spatstat.data`
