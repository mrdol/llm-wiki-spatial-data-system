---
title: paper_biomass_rainforest
type: dataset
created: 2026-08-10
updated: 2026-08-10
sources:
  - data/final_datasets/sf/paper_biomass_rainforest.rds
  - DataCite_2015_SpatialStructureOfAbove_10_1371_journal_
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Spatial Structure of Above-Ground Biomass Limits Accuracy of Carbon Mapping in Rainforest but Large Scale Forest Inventories Can Help to Overcome" (DOI 10.1371/journal.pone.0138456).

## Description du jeu de donnees

- Topic: ecologie forestiere / inventaire de biomasse
- Observation unit: placette d'inventaire forestier
- Observed population: placettes CTFT/ONF, foret tropicale humide
- Geographic context: a preciser depuis l'etendue spatiale (voir Bloc 5)
- Temporal context: none (cross-sectional)
- Source description: Spatial Structure of Above-Ground Biomass Limits Accuracy of Carbon Mapping in Rainforest but Large Scale Forest Inventories Can Help to Overcome
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: low
- Paper DOI: 10.1371/journal.pone.0138456
- Dataset DOI: 10.5061/dryad.38578
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.38578
- Local raw dir: `data/raw/papers/DataCite_2015_SpatialStructureOfAbove_10_1371_journal_/`
- Local sf output: `data/final_datasets/sf/paper_biomass_rainforest.rds`

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `mean_wsg`, `n_stems`
- Candidate Y typology: rate, continuous
- Candidate X variables: `area_ha`
- Candidate X count: 1
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `Xutm`, `Yutm`
- Identifier columns (excluded from X candidates): `ID`
- Variables inspected: yes (auto — generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `mean_wsg` | `numeric` | rate | [0.5535, 0.7867] | 0% |
| `n_stems` | `numeric` | continuous | [28, 152] | 0% |

> Selection Y/X (paper-loader/curated evidence) : Pour `biomass_rainforest`, la ou les reponses `mean_wsg`, `n_stems` viennent du loader papier et/ou des preuves de l article `Spatial Structure of Above-Ground Biomass Limits Accuracy of Carbon Mapping in Rainforest but Large Scale Forest Inventories Can Help to Overcome`. Les covariables X retenues sont `area_ha`. Les coordonnees (`Xutm`, `Yutm`), identifiants (`ID`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : needs_response_reconstruction ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `area_ha` | `numeric` | rate | 0% |

### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: area_ha
- y_term_pub: mean_wsg
- Reference publication: pending

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: mean_wsg ~ area_ha
- x_terms_used: area_ha
- y_term_used: mean_wsg
- Note: formule candidate generee automatiquement (Y ~ toutes les covariables X detectees), PAS une formule publiee ou verifiee dans le papier source — a confirmer par revue manuelle.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "mean_wsg ~ area_ha"
    response: "mean_wsg"
    predictors: ["area_ha"]
    role: "simple_baseline"
    source_type: "generated_system_formula"
    source_ref: "data/raw/papers (loader-derived, no published equation located)"
    estimator_context: ["ols", "spatial_baseline"]
    status: "generated"

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
    formula: "mean_wsg ~ area_ha"
    response: "mean_wsg"
    predictors: ["area_ha"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/raw/papers (loader-derived, no published equation located)"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `paper_biomass_rainforest`
- Dataset name: Data from: Spatial structure of above-ground biomass limits accuracy of carbon mapping in rainforest but large scale forest inventories can help to overcome
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Spatial Structure of Above-Ground Biomass Limits Accuracy of Carbon Mapping in Rainforest but Large Scale Forest Inventories Can Help to Overcome
- Paper DOI: 10.1371/journal.pone.0138456
- Dataset DOI: 10.5061/dryad.38578
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.38578
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
  benchmark_status: "needs_response_reconstruction"
  benchmark_task: "regression_continuous"
  package_include: "no"
  has_local_rds: true
  missing_items: "reconstruire ou extraire AGB/AGC et joindre DBH/H ou covariables environnementales"
  reason: "L'extraction actuelle contient des composantes de l'allometrie, mais pas la variable cible AGB/AGC du papier."
```

- Decision: needs_response_reconstruction
- Manque principal: reconstruire ou extraire AGB/AGC et joindre DBH/H ou covariables environnementales
- Raison: L'extraction actuelle contient des composantes de l'allometrie, mais pas la variable cible AGB/AGC du papier.

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 1335
- k variables: 8
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 — Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 32622
- CRS nom: WGS 84 / UTM zone 22N
- Spatial extent: x [144387.6771, 384675.3438], y [270868.7361, 607409.7224]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`biomass_rainforest` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `biomass_rainforest` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: PENDING - formule publication non encore etablie (formule candidate systeme fournie a la place).
- CRS: OK - CRS renseigne dans le Bloc 5 (32622).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`biomass_rainforest` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Spatial Structure of Above-Ground Biomass Limits Accuracy of Carbon Mapping in Rainforest but Large Scale Forest Inventories Can Help to Overcome

