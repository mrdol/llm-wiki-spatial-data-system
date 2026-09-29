---
title: paper_n06_tsuga_mi_tsca
type: dataset
created: 2026-09-24
updated: 2026-09-24
sources:
  - data/final_datasets/sf/paper_n06_tsuga_mi_tsca.rds
  - N06_Tsuga_MI_TSCA
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Bayesian Spatial Predictive Synthesis" (DOI unknown).

## Description du jeu de donnees

- Topic: Forest ecology
- Observation unit: observation spatiale du dataset "Tsuga canadensis occurrence in Michigan, 17,743 forest stands"
- Observed population: Section 5
- Geographic context: 17,743 forest stands with two analytical coordinate columns; package documentation calls them Albers Equal Area but the declared unit/projection is inconsistent with the stored scale, so CRS is left unresolved.
- Temporal context: none (cross-sectional)
- Source description: Bayesian Spatial Predictive Synthesis
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: high_except_crs
- Paper DOI: unknown
- Dataset DOI: 10.5061/dryad.fj6q573qg
- Source URL: https://cran.r-project.org/package=spNNGP
- Local raw dir: `data/raw/papers/N06_Tsuga_MI_TSCA/`
- Local sf output: `data/final_datasets/sf/paper_n06_tsuga_mi_tsca.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `TSCA`
- Candidate Y typology: binary
- Candidate X variables in local artifact: `MIN`, `MAX`, `SUP`, `WIP`, `AET`, `DEF`
- Candidate X count in local artifact: 6
- Candidate X typology: continuous
- Published X variables from paper: MIN, MAX, SUP, WIP, AET, DEF
- Published X count: 6
- Coordinates (x, y - excluded from X candidates): `long`, `lat`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `TSCA` | `integer` | binary | {0, 1} | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `n06_tsuga_mi_tsca`, la ou les reponses `TSCA` viennent du loader papier et/ou des preuves de l article `Bayesian Spatial Predictive Synthesis`. Les covariables X retenues sont `MIN`, `MAX`, `SUP`, `WIP`, `AET`, `DEF`. Les coordonnees (`long`, `lat`), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : needs_manual_review ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `MIN` | `numeric` | continuous | 0% |
| `MAX` | `numeric` | continuous | 0% |
| `SUP` | `numeric` | continuous | 0% |
| `WIP` | `numeric` | continuous | 0% |
| `AET` | `numeric` | continuous | 0% |
| `DEF` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: TSCA ~ MIN + MAX + SUP + WIP + AET + DEF [Bernoulli/logit; GLM, GAM1, GAM2 and spatial logistic NNGP predictors synthesized by BSPS]
- x_terms_pub: MIN, MAX, SUP, WIP, AET, DEF
- y_term_pub: TSCA (presence/absence de Tsuga canadensis)
- Reference publication: Cabel, Sugasawa, Kato, Takanashi & McAlinn (2025), Bayesian Spatial Predictive Synthesis, arXiv:2203.05197v4, Section 5.1. L'application utilise 17 743 peuplements, six covariables climatiques, 2 000 observations de validation repetees sur 20 partitions, et l'objet exact MI_TSCA distribue par spNNGP. La documentation spNNGP declare un Albers Equal Area en metres, mais l'echelle numerique des coordonnees est incompatible avec cette unite et la transformation correspondante ne tombe pas au Michigan; le CRS reste donc volontairement non assigne en attendant une clarification de la source.

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d estimation: formule systeme generee (formula_pub confirmee mais non reprise telle quelle -- voir Note ci-dessous)
- Correspondance Python/R: aucune identifiee
- Note: La formule tabulaire restitue les six covariables climatiques de l'application. Elle ne reproduit pas a elle seule les fonctions lissees de GAM1/GAM2, le champ spatial NNGP de SPR, ni la synthese BSPS a coefficients spatialement variables. La reponse est binaire et le harnais de regression continue actuel ne doit pas promouvoir automatiquement ce jeu.

### Formule - niveau systeme

- formula_used: TSCA ~ MIN + MAX + SUP + WIP + AET + DEF
- x_terms_used: MIN, MAX, SUP, WIP, AET, DEF
- y_term_used: TSCA
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

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
    formula: "TSCA ~ MIN + MAX + SUP + WIP + AET + DEF"
    response: "TSCA (presence/absence de Tsuga canadensis)"
    predictors: ["MIN", "MAX", "SUP", "WIP", "AET", "DEF"]
    role: "benchmark_simplified_specification"
    source_type: "derived_from_scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
    status: "executable_approximation"

  ml_or_selected:
    formula: "TSCA ~ MIN + MAX + SUP + WIP + AET + DEF"
    response: "TSCA"
    predictors: ["MIN", "MAX", "SUP", "WIP", "AET", "DEF"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["bsps_binary", "glm_binomial", "gam_binomial", "spatial_logistic_nngp"]
    status: "manual_review_binary_response_and_bsps_unimplemented"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_n06_tsuga_mi_tsca`
- Dataset name: Tsuga canadensis occurrence in Michigan, 17,743 forest stands
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Bayesian Spatial Predictive Synthesis
- Paper DOI: unknown
- Dataset DOI: 10.5061/dryad.fj6q573qg
- Source URL: https://cran.r-project.org/package=spNNGP
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "TSCA ~ MIN + MAX + SUP + WIP + AET + DEF [Bernoulli/logit; GLM, GAM1, GAM2 and spatial logistic NNGP predictors synthesized by BSPS]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Cabel, Sugasawa, Kato, Takanashi & McAlinn (2025), Bayesian Spatial Predictive Synthesis, arXiv:2203.05197v4, Section 5.1. L'application utilise 17 743 peuplements, six covariables climatiques, 2 000 observations de validation repetees sur 20 partitions, et l'objet exact MI_TSCA distribue par spNNGP. La documentation spNNGP declare un Albers Equal Area en metres, mais l'echelle numerique des coordonnees est incompatible avec cette unite et la transformation correspondante ne tombe pas au Michigan; le CRS reste donc volontairement non assigne en attendant une clarification de la source."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "needs_manual_review"
  benchmark_task: "unknown"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "statut benchmark non encore curate"
  reason: "Aucune decision explicite encodee pour n06_tsuga_mi_tsca."
```

- Decision: needs_manual_review
- Manque principal: statut benchmark non encore curate
- Raison: Aucune decision explicite encodee pour n06_tsuga_mi_tsca.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "needs_manual_review"
  eligible_estimators: []
  conditionally_eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy"]
  ineligible_reason: "manual review required before package promotion"
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 17743
- k variables: 11
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: unknown
- CRS nom: unknown
- Spatial extent: x [4797.33881710002, 5254.94916092262], y [280.05842976885, 801.27652835387]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`n06_tsuga_mi_tsca` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `n06_tsuga_mi_tsca` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formula_pub confirmee et verifiee (voir Reference publication) ; formula_used est une approximation generee distincte, explicitement etiquetee comme telle (voir Bloc 1 > Statut regression canonique > Note).
- CRS: WARN - CRS absent du sf source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`n06_tsuga_mi_tsca` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Bayesian Spatial Predictive Synthesis

