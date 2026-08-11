---
title: paper_arequipa_climate
type: dataset
created: 2026-08-10
updated: 2026-08-10
sources:
  - data/final_datasets/sf/paper_arequipa_climate.rds
  - DataCite_2021_HowDoIndigenousAnd_10_5751_es_12481
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "How do Indigenous and local knowledge systems respond to climate change?" (DOI 10.5751/es-12481-260327).

## Description du jeu de donnees

- Topic: climatologie regionale / savoirs autochtones
- Observation unit: cellule de grille climatique 1km
- Observed population: bassin versant Arequipa/Colca, Perou
- Geographic context: a preciser depuis l'etendue spatiale (voir Bloc 5)
- Temporal context: none (cross-sectional)
- Source description: How do Indigenous and local knowledge systems respond to climate change?
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: low
- Paper DOI: 10.5751/es-12481-260327
- Dataset DOI: 10.4231/490d-hc66
- Source URL: https://purr.purdue.edu/publications/3212/1
- Local raw dir: `data/raw/papers/DataCite_2021_HowDoIndigenousAnd_10_5751_es_12481/`
- Local sf output: `data/final_datasets/sf/paper_arequipa_climate.rds`

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Prec_annual`, `averageT_annual`
- Candidate Y typology: continuous
- Candidate X variables: `Tmax_annual`, `Tmin_annual`
- Candidate X count: 2
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): none detected
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Prec_annual` | `numeric` | continuous | [1.5, 792.0461] | 0% |
| `averageT_annual` | `numeric` | continuous | [-11.4014, 22.7811] | 0% |

> Selection Y/X (paper-loader/curated evidence) : Pour `arequipa_climate`, la ou les reponses `Prec_annual`, `averageT_annual` viennent du loader papier et/ou des preuves de l article `How do Indigenous and local knowledge systems respond to climate change?`. Les covariables X retenues sont `Tmax_annual`, `Tmin_annual`. Les coordonnees (les coordonnees detectees), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : not_ready_relevance_check ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Tmax_annual` | `numeric` | continuous | 0% |
| `Tmin_annual` | `numeric` | continuous | 0% |

### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: Tmax_annual, Tmin_annual
- y_term_pub: Prec_annual
- Reference publication: pending

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: Prec_annual ~ Tmax_annual + Tmin_annual
- x_terms_used: Tmax_annual, Tmin_annual
- y_term_used: Prec_annual
- Note: formule candidate generee automatiquement (Y ~ toutes les covariables X detectees), PAS une formule publiee ou verifiee dans le papier source — a confirmer par revue manuelle.

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
    formula: "Prec_annual ~ Tmax_annual + Tmin_annual"
    response: "Prec_annual"
    predictors: ["Tmax_annual", "Tmin_annual"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/raw/papers (loader-derived, no published equation located)"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `paper_arequipa_climate`
- Dataset name: Arequipa Climate Maps - Normals (Version 1)
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: How do Indigenous and local knowledge systems respond to climate change?
- Paper DOI: 10.5751/es-12481-260327
- Dataset DOI: 10.4231/490d-hc66
- Source URL: https://purr.purdue.edu/publications/3212/1
- Year: unknown

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "pending"
  equation_family: generated_system_candidate
  model_family: unknown
  source_type: generated_system_formula
  source_ref: "data/raw/papers (loader-derived, no published equation located)"
  confidence: low
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_relevance_check"
  benchmark_task: "climate_grid_product"
  package_include: "no"
  has_local_rds: true
  missing_items: "verifier le lien exact entre la grille extraite et l'analyse empirique du papier"
  reason: "La grille climatique ne contient pas encore un couple Y/X de regression spatiale conforme au papier."
```

- Decision: not_ready_relevance_check
- Manque principal: verifier le lien exact entre la grille extraite et l'analyse empirique du papier
- Raison: La grille climatique ne contient pas encore un couple Y/X de regression spatiale conforme au papier.

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 63307
- k variables: 6
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 — Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 32718
- CRS nom: WGS 84 / UTM zone 18S
- Spatial extent: x [492633.140900001, 948633.140900001], y [8085848, 8379848]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`arequipa_climate` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `arequipa_climate` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: PENDING - formule publication non encore etablie (formule candidate systeme fournie a la place).
- CRS: OK - CRS renseigne dans le Bloc 5 (32718).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`arequipa_climate` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: How do Indigenous and local knowledge systems respond to climate change?

