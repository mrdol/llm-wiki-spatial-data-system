---
title: R_sp_meuse.grid_meuse.grid
type: dataset
created: 2026-08-15
updated: 2026-09-07
sources:
  - data/final_datasets/sf/R_sp_meuse.grid_meuse.grid.rds
tags: [dataset, r-package, spatial, point]
---

The ‘meuse.grid’ data frame has 3103 rows and 7 columns; a grid with 40 m x 40 m spacing that covers the Meuse study area (see meuse)

## Description du jeu de donnees

- Topic: Donnees de r-package : R_sp_meuse.grid_meuse.grid
- Observation unit: observation spatiale de type POINT
- Observed population: 3103 enregistrements dans l’artefact local R_sp_meuse.grid_meuse.grid.rds; unite declaree : observation spatiale de type POINT. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: Etendue mesuree dans le RDS : x [178460, 181540], y [329620, 333740]; CRS non renseigne, repere/unites a documenter.
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: The ‘meuse.grid’ data frame has 3103 rows and 7 columns; a grid with 40 m x 40 m spacing that covers the Meuse study area (see meuse)
- Description source: package R `sp`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: aucune (voir Note ci-dessous -- grille de prediction, pas de reponse observee)
- Candidate Y typology: unknown
- Candidate X variables: `dist`, `part.a`, `part.b`, `soil`, `ffreq`
- Candidate X typology: continuous, binary, categorical
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| (aucune) | -- | -- | -- | -- |

> CORRECTION (2026-09-09) : `dist` n'est PAS une reponse a modeliser -- c'est une covariable (distance normalisee a la riviere Meuse), identique en nature a la colonne `dist` deja presente comme X dans le jeu d'observations reel [[R_sp_meuse_meuse]] (zinc/cadmium/copper/lead ~ dist + ...). Ce jeu (`sp::meuse.grid`) est la grille de prediction reguliere (40m x 40m) qui accompagne `sp::meuse` -- son role est de fournir les valeurs de `dist`/`soil`/`ffreq`/`part.a`/`part.b` sur ~3103 points non-observes du meme domaine, pour predire (krigeage / regression-krigeage) la concentration en metaux lourds apres ajustement du modele sur [[R_sp_meuse_meuse]]. Aucun Y a modeliser directement sur cette fiche.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `part.a` | `numeric` | binary | 0% |
| `part.b` | `numeric` | binary | 0% |
| `soil` | `factor` | categorical | 0% |
| `ffreq` | `factor` | categorical | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: M G J Rikken and R P G Van Rijn (1993) Soil pollution with heavy metals - an inquiry into spatial variation, cost of mapping and the risk evaluation of copper, cadmium, lead and zinc in the floodplains of the Meuse west of Stein, the Netherlands. Doctoraalveldwerkverslag, Dept. of Physical Geography, Utrecht University

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: not_applicable (grille de prediction, aucune reponse observee -- voir Note Bloc 1)
- Formula used evidence: not_applicable
- Selected Y evidence: not_applicable -- aucune ligne Detail Y (aucun Y candidat).
- Selected Y typology: not_applicable
- x_terms_used: not_applicable
- y_term_used: not_applicable
- Note: CORRECTION 2026-09-09 -- l'ancienne formule `dist ~ part.a + part.b + soil + ffreq` etait generee automatiquement en confondant une covariable (dist) avec une reponse. Retiree ; voir [[R_sp_meuse_meuse]] pour la tache de regression reelle (zinc/cadmium/copper/lead) dont ce jeu est le support de prediction.

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
    formula: "not_applicable -- voir R_sp_meuse_meuse (cadmium/copper/lead/zinc ~ dist + ...)"
    response: "not_applicable"
    predictors: []
    role: "paper_main_specification"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "not_applicable_prediction_grid"

  ml_or_selected:
    formula: "not_applicable"
    response: "not_applicable"
    predictors: []
    role: "ml_candidate_features"
    source_type: "none_found"
    source_ref: "CORRECTION 2026-09-09 : l'ancienne formule generee automatiquement (dist ~ part.a + part.b + soil + ffreq) confondait une covariable avec une reponse ; retiree."
    estimator_context: []
    status: "not_applicable_prediction_grid"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `R_sp_meuse.grid_meuse.grid`
- Dataset name: sp::meuse.grid
- Source family: r-package
- Source: package R `sp` (version 2.2.1)
- Source URL: https://CRAN.R-project.org/package=sp
- Dataset DOI: none
- Publication DOI: pending
- Year: 2005

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "not_applicable -- grille de prediction spatiale (sp::meuse.grid), pas un jeu de regression autonome"
  equation_family: not_applicable
  model_family: "prediction_support_grid"
  source_type: package_documentation
  source_ref: "sp::meuse.grid (documentation du package) -- grille compagnon de sp::meuse pour le krigeage/regression-krigeage. Voir R_sp_meuse_meuse pour le modele reel (zinc/cadmium/copper/lead)."
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 3103
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [178460, 181540], y [329620, 333740] (EPSG:28992, via documentation)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 28992 (source: documentation du package, .rds sans CRS embarque)
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://CRAN.R-project.org/package=sp
- License open: yes
- Reproducibility status: available via package R `sp`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_main_benchmark"
  benchmark_task: "source_or_specialized_task_only"
  package_include: "no"
  has_local_rds: true
  missing_items: "Grille de prédiction meuse; dist est une distance géographique et part.a/part.b des partitions, pas la concentration de zinc observée. Les deux fiches décrivent deux représentations du même support. Conserver comme support de prédiction et rattacher à R_sp_meuse_meuse; ne pas promouvoir la régression dist sur champs de grille."
  reason: "Grille de prédiction meuse; dist est une distance géographique et part.a/part.b des partitions, pas la concentration de zinc observée. Les deux fiches décrivent deux représentations du même support. Conserver comme support de prédiction et rattacher à R_sp_meuse_meuse; ne pas promouvoir la régression dist sur champs de grille."
```

- Decision: not_ready_main_benchmark
- Manque principal: Grille de prédiction meuse; dist est une distance géographique et part.a/part.b des partitions, pas la concentration de zinc observée. Les deux fiches décrivent deux représentations du même support. Conserver comme support de prédiction et rattacher à R_sp_meuse_meuse; ne pas promouvoir la régression dist sur champs de grille.
- Raison: Grille de prédiction meuse; dist est une distance géographique et part.a/part.b des partitions, pas la concentration de zinc observée. Les deux fiches décrivent deux représentations du même support. Conserver comme support de prédiction et rattacher à R_sp_meuse_meuse; ne pas promouvoir la régression dist sur champs de grille.


## Estimator eligibility

```yaml
estimator_eligibility:
  status: "not_ready_main_benchmark"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "Grille de prédiction meuse; dist est une distance géographique et part.a/part.b des partitions, pas la concentration de zinc observée. Les deux fiches décrivent deux représentations du même support. Conserver comme support de prédiction et rattacher à R_sp_meuse_meuse; ne pas promouvoir la régression dist sur champs de grille."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: WARN - CRS absent du `.rds` source ; EPSG:28992 extrait de la documentation et reporte dans le Bloc 5.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2)).

## Related Pages

- [[R_sp_meuse_meuse]] -- jeu d'observations reel (N=155) dont ce jeu est la grille de prediction/krigeage
- [[R_sp_meuse.grid_ll_meuse.grid_ll]] -- meme grille, reprojetee en coordonnees geographiques (doublon fonctionnel)
- Source: package R `sp`

## Curation documentée — 2026-09-09

Rattachement explicite a [[R_sp_meuse_meuse]] sur decision de l'utilisateur (2026-09-09) : ce
jeu (`sp::meuse.grid`, N=3103) est la grille reguliere (40m x 40m) qui accompagne
`sp::meuse` dans le package `sp` -- exemple canonique de krigeage/regression-krigeage en
geostatistique R (voir vignettes `gstat`). Elle porte les memes covariables (`dist`, `soil`,
`ffreq`, `part.a`, `part.b`) que celles utilisees comme X dans la regression reelle sur
[[R_sp_meuse_meuse]] (Y = zinc/cadmium/copper/lead), mais SANS reponse observee -- son usage
est de fournir des points hors-echantillon pour predire la surface de concentration en
metaux lourds une fois le modele ajuste sur les 155 observations reelles. Ancienne formule
generee automatiquement (`dist ~ part.a + part.b + soil + ffreq`) retiree -- elle confondait
une covariable partagee avec une reponse a modeliser. `package_include: no` inchange (n'est
pas un jeu de regression autonome), mais desormais documente comme support de prediction
plutot que comme tache rejetee sans explication.

Curation anterieure (2026-09-07) : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
