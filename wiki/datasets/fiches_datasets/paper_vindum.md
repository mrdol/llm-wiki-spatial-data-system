---
title: paper_vindum
type: dataset
created: 2026-08-10
updated: 2026-08-10
sources:
  - data/final_datasets/sf/paper_vindum.rds
  - Moller_2020_OGC_vindum
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Oblique geographic coordinates as covariates for digital soil mapping" (DOI 10.5194/soil-6-269-2020).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: a preciser depuis le papier source
- Geographic context: a preciser depuis l'etendue spatiale (voir Bloc 5)
- Temporal context: none (cross-sectional)
- Source description: Oblique geographic coordinates as covariates for digital soil mapping
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: low
- Paper DOI: 10.5194/soil-6-269-2020
- Dataset DOI: 10.5281/zenodo.3820068
- Source URL: https://zenodo.org/records/3820068
- Local raw dir: `data/raw/papers/Moller_2020_OGC_vindum/`
- Local sf output: `data/final_datasets/sf/paper_vindum.rds`

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `SOM`
- Candidate Y typology: continuous
- Candidate X variables: no additional covariates beyond coordinates/identifiers (raster or grid dataset)
- Candidate X count: 0
- Candidate X typology: unknown
- Coordinates (x, y — excluded from X candidates): none detected
- Identifier columns (excluded from X candidates): `ID`
- Variables inspected: yes (auto — generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `SOM` | `numeric` | continuous | [1.3, 38.8] | 0% |

> Selection Y/X (paper-loader/curated evidence) : Pour `vindum`, la ou les reponses `SOM` viennent du loader papier et/ou des preuves de l article `Oblique geographic coordinates as covariates for digital soil mapping`. Les covariables X retenues sont aucune covariable explicative. Les coordonnees (les coordonnees detectees), identifiants (`ID`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : not_ready_geostatistical_univariate ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| -- | -- | aucun candidat | -- |

### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: SOM
- Reference publication: pending

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: SOM
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

- Dataset ID: `paper_vindum`
- Dataset name: Vindum
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Oblique geographic coordinates as covariates for digital soil mapping
- Paper DOI: 10.5194/soil-6-269-2020
- Dataset DOI: 10.5281/zenodo.3820068
- Source URL: https://zenodo.org/records/3820068
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
  benchmark_status: "not_ready_geostatistical_univariate"
  benchmark_task: "geostatistical_interpolation"
  package_include: "no"
  has_local_rds: true
  missing_items: "ajouter des covariables ou traiter comme kriging/interpolation"
  reason: "Dataset geostatistique univarie sans covariables X."
```

- Decision: not_ready_geostatistical_univariate
- Manque principal: ajouter des covariables ou traiter comme kriging/interpolation
- Raison: Dataset geostatistique univarie sans covariables X.

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 285
- k variables: 4
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 — Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: unknown
- CRS nom: unknown
- Spatial extent: x [534887.6172, 535325.9149], y [6247748.1996, 6248113.7981]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`vindum` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `vindum` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: WARN - Y identifiee, mais aucune covariable X detectee (grille/raster sans covariable additionnelle).
- Formula: PENDING - formule publication non encore etablie (formule candidate systeme fournie a la place).
- CRS: WARN - CRS absent du sf source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`vindum` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Oblique geographic coordinates as covariates for digital soil mapping

