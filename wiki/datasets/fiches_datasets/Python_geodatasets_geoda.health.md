---
title: Python_geodatasets_geoda.health
type: dataset
created: 2026-08-15
updated: 2026-09-17
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.health.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`health`).

## Description du jeu de donnees

- Topic: sante publique / epidemiologie spatiale
- Observation unit: individu, cas sanitaire ou unite spatiale de sante
- Observed population: population sanitaire documentee par le package source
- Geographic context: Etendue mesuree dans le RDS : x [-124.758210348822, -67.294865361691], y [24.525964, 48.987003]; CRS WGS 84.
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`health`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `le_agg_q1`, `le_raceadj`, `le_agg_q2`, `le_racea_1`, `le_agg_q3`, `le_racea_2`, `le_agg_q4`, `le_racea_3`, `le_agg_q11`, `le_racea_4`, `le_agg_q21`, `le_racea_5`, `le_agg_q31`, `le_racea_6`, `le_agg_q41`, `le_racea_7`, `ratio`
- Candidate Y typology: continuous
- Candidate X variables: `statemhir`, `tractmhir`, `cty_pop200`, `cz_pop2000`, `Diversity`, `BlackorA`, `AmericanI`, `Asianalon`, `NativeHaw`, `TwoorMor`, `Hispanico`, `Whitealon`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `cartodb_id`, `state_id`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `le_agg_q1` | `numeric` | continuous | [0, 87.2398] | 0% |
| `le_raceadj` | `numeric` | continuous | [0, 87.1163] | 0% |
| `le_agg_q2` | `numeric` | continuous | [0, 88.6095] | 0% |
| `le_racea_1` | `numeric` | continuous | [0, 88.6159] | 0% |
| `le_agg_q3` | `numeric` | continuous | [0, 91.3513] | 0% |
| `le_racea_2` | `numeric` | continuous | [0, 91.4586] | 0% |
| `le_agg_q4` | `numeric` | continuous | [0, 93.9341] | 0% |
| `le_racea_3` | `numeric` | continuous | [0, 93.9072] | 0% |
| `le_agg_q11` | `numeric` | continuous | [0, 82.5628] | 0% |
| `le_racea_4` | `numeric` | continuous | [0, 82.5807] | 0% |
| `le_agg_q21` | `numeric` | continuous | [0, 86.6032] | 0% |
| `le_racea_5` | `numeric` | continuous | [0, 85.3178] | 0% |
| `le_agg_q31` | `numeric` | continuous | [0, 88.5365] | 0% |
| `le_racea_6` | `numeric` | continuous | [0, 88.6028] | 0% |
| `le_agg_q41` | `numeric` | continuous | [0, 89.2528] | 0% |
| `le_racea_7` | `numeric` | continuous | [0, 89.2977] | 0% |
| `ratio` | `numeric` | continuous | [0, 3.317] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables `le_*` (espérance de vie agrégée ou ajustée par race, par quartile de revenu et par sexe) et `ratio` (rapport revenu local/état) constituent des cibles naturelles pour modéliser les inégalités de santé spatiales. Les covariables retenues capturent le contexte socio-économique (revenus médians au niveau tract et état, populations), la composition raciale/ethnique et la diversité, qui sont des déterminants bien établis des outcomes de santé ; les colonnes administratives (codes FIPS, noms géographiques) et les effectifs de comptage (count_q*) ainsi que les écarts-types (sd_le_*) sont écartés car redondants ou non pertinents comme predicteurs directs.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `statemhir` | `numeric` | continuous | 0% |
| `tractmhir` | `numeric` | continuous | 0% |
| `cty_pop200` | `numeric` | continuous | 0% |
| `cz_pop2000` | `numeric` | continuous | 0% |
| `Diversity` | `numeric` | rate | 0% |
| `BlackorA` | `numeric` | continuous | 0% |
| `AmericanI` | `numeric` | continuous | 0% |
| `Asianalon` | `numeric` | continuous | 0% |
| `NativeHaw` | `numeric` | continuous | 0% |
| `TwoorMor` | `numeric` | continuous | 0% |
| `Hispanico` | `numeric` | continuous | 0% |
| `Whitealon` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Source empirique directe (partielle) : Chetty, R., Stepner, M., Abraham, S., Lin, S., Scuderi, B., Turner, N., Bergeron, A. & Cutler, D. (2016), 'The Association Between Income and Life Expectancy in the United States, 2001-2014', JAMA 315(16), 1750-1766, DOI 10.1001/jama.2016.4226 (DOI verifie via Crossref). La structure des colonnes (le_agg_q1..q4 = esperance de vie par quartile de revenu agrege, le_racea_1..7 = variantes ajustees par race) correspond aux tables du Health Inequality Project (Opportunity Insights) associees a cet article. IMPORTANT : ce fichier GeoDa n'est PAS l'objet exact utilise dans les regressions de l'article -- c'est un assemblage geospatial enrichi combinant les tables de longevite de Chetty et al. avec des indicateurs de revenu/diversite raciale provenant d'autres sources (recensement) et une geometrie de comtes. Aucune formule de regression precise de l'article n'a ete confirmee comme directement applicable a cet assemblage -- statut maintenu manual_review, pas de promotion sur la seule base de cette attribution de source partielle.

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: le_agg_q1 ~ statemhir + tractmhir + cty_pop200 + cz_pop2000 + Diversity + BlackorA + AmericanI + Asianalon
- Formula used evidence: generated_system_formula
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: statemhir + tractmhir + cty_pop200 + cz_pop2000 + Diversity + BlackorA + AmericanI + Asianalon
- y_term_used: le_agg_q1

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
    formula: "le_agg_q1 ~ statemhir + tractmhir + cty_pop200 + cz_pop2000 + Diversity + BlackorA + AmericanI + Asianalon"
    response: "le_agg_q1"
    predictors: ["statemhir", "tractmhir", "cty_pop200", "cz_pop2000", "Diversity", "BlackorA", "AmericanI", "Asianalon"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.health`
- Dataset name: geodatasets::health
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
  equation_text: "le_agg_q1 ~ statemhir + tractmhir + cty_pop200 + cz_pop2000 + Diversity + BlackorA + AmericanI + Asianalon"
  equation_family: regression_candidate
  model_family: "regression_candidate"
  source_type: generated_system_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 3984
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation (derive d'un polygone source par reduction geometrique -- st_point_on_surface(), rien n'est perdu -- voir Type de geometrie et geom_origine)
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-124.7582, -67.2949], y [24.526, 48.987] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT (source native : POLYGON, preservee dans `geom_origine` ; geometrie active derivee via `st_point_on_surface()` ou equivalent, methodologie documentee dans code/r_catalog/guide_objets_sf.md section 3-5 -- rien n'est perdu, correction 2026-09-16 apres verification via tools/verify_fiche_crs.py)
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: pending — multi-zones (span=57.5deg) -- etendue compatible avec un grand pays/une region ; verifier qu'une projection nationale/regionale existe et convient a cette zone avant de l'utiliser, sinon envisager une projection continentale equal-area

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
  benchmark_status: "almost_ready_generated_formula"
  benchmark_task: "regression_spatial_generated_formula"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "valider la formule generee avant inclusion automatique dans le package"
  reason: "La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee."
```

- Decision: almost_ready_generated_formula
- Manque principal: valider la formule generee avant inclusion automatique dans le package
- Raison: La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20% : cz_name (NA=42.6%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`

## Curation documentée — 2026-09-07

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

## Curation documentée — 2026-09-17

Recherche du 2026-09-17 (suite a un echange avec un autre agent IA ayant identifie une piste Chetty). DOI verifie via Crossref. Source empirique directe (partielle) : Chetty, R., Stepner, M., Abraham, S., Lin, S., Scuderi, B., Turner, N., Bergeron, A. & Cutler, D. (2016), 'The Association Between Income and Life Expectancy in the United States, 2001-2014', JAMA 315(16), 1750-1766, DOI 10.1001/jama.2016.4226 (DOI verifie via Crossref). La structure des colonnes (le_agg_q1..q4 = esperance de vie par quartile de revenu agrege, le_racea_1..7 = variantes ajustees par race) correspond aux tables du Health Inequality Project (Opportunity Insights) associees a cet article. IMPORTANT : ce fichier GeoDa n'est PAS l'objet exact utilise dans les regressions de l'article -- c'est un assemblage geospatial enrichi combinant les tables de longevite de Chetty et al. avec des indicateurs de revenu/diversite raciale provenant d'autres sources (recensement) et une geometrie de comtes. Aucune formule de regression precise de l'article n'a ete confirmee comme directement applicable a cet assemblage -- statut maintenu manual_review, pas de promotion sur la seule base de cette attribution de source partielle. Conclusion : source de donnees partiellement identifiee et documentee, mais pas de formule de regression specifique confirmee pour ce fichier assemble -- ne pas promouvoir package_include sur cette seule base.
