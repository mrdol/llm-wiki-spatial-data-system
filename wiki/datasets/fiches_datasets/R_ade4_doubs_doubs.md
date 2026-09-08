---
title: R_ade4_doubs_doubs
type: dataset
created: 2026-08-15
updated: 2026-09-07
sources:
  - data/final_datasets/sf/R_ade4_doubs_doubs.rds
tags: [dataset, r-package, spatial, point]
---

This data set gives environmental variables, fish species and spatial coordinates for 30 sites.

## Description du jeu de donnees

- Topic: Donnees de r-package : R_ade4_doubs_doubs
- Observation unit: observation spatiale de type POINT
- Observed population: 30 enregistrements dans l’artefact local R_ade4_doubs_doubs.rds; unite declaree : observation spatiale de type POINT. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: Etendue mesuree dans le RDS : x [8, 266], y [7, 233]; CRS non renseigne, repere/unites a documenter.
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: This data set gives environmental variables, fish species and spatial coordinates for 30 sites.
- Description source: package R `ade4`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: not identified by LLM classification — manual review required
- Candidate Y typology: unknown
- Candidate X variables: not identified by LLM classification — manual review required
- Candidate X typology: unknown
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| — | — | aucun candidat detecte | — | — |


> Note doc : y is a data frame with 30 rows (sites) and 2 spatial coordinates

> **ade4** - Donnees ecologiques multivariees. La variable reponse Y et la formule sont a definir manuellement selon l'etude ciblee (ordination, RDA, etc.).

> Selection Y/X (claude-sonnet-4-6) : Aucune variable disponible.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| — | — | aucun candidat | — |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Verneaux, J. (1973) Cours d'eau de Franche-Comté (Massif du Jura). Recherches écologiques sur le réseau hydrographique du Doubs. Essai de biotypologie. Thèse d'état, Université de Besançon, Besançon. 1–257.

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- Formula used evidence: unavailable
- Restored source variables: `env__dfs`, `env__alt`, `env__slo`, `env__flo`, `env__pH`, `env__har`, `env__pho`, `env__nit`, `env__amm`, `env__oxy`, `env__bdo`, `fish__Cogo`, `fish__Satr`, `fish__Phph`, `fish__Neba`, `fish__Thth`, `fish__Teso`, `fish__Chna`, `fish__Chto`, `fish__Lele`, `fish__Lece`, `fish__Baba`, `fish__Spbi`, `fish__Gogo`, `fish__Eslu`, `fish__Pefl`, `fish__Rham`, `fish__Legi`, `fish__Scer`, `fish__Cyca`, `fish__Titi`, `fish__Abbr`, `fish__Icme`, `fish__Acce`, `fish__Ruru`, `fish__Blbj`, `fish__Alal`, `fish__Anan`
- k variables: 42
- x_terms_used: pending
- y_term_used: pending

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

- Dataset ID: `R_ade4_doubs_doubs`
- Dataset name: ade4::doubs
- Source family: r-package
- Source: package R `ade4` (version 1.7.24)
- Source URL: https://CRAN.R-project.org/package=ade4
- Dataset DOI: none
- Publication DOI: pending
- Year: 2002

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "null"
  equation_family: n/a
  model_family: "n/a"
  source_type: none_found
  source_ref: "null"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 30
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [8, 266], y [7, 233] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://CRAN.R-project.org/package=ade4
- License open: yes
- Reproducibility status: available via package R `ade4`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "manual_review"
  benchmark_task: "not_current_regression_benchmark"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "Sous-tables natives de sites restaurees par jointure exacte sur les rownames de xy, puis egalite des coordonnees verifiee. Choix scientifique de Y/X et formule encore requis; aucune colonne numerique choisie automatiquement."
  reason: "Sous-tables natives de sites restaurees par jointure exacte sur les rownames de xy, puis egalite des coordonnees verifiee. Choix scientifique de Y/X et formule encore requis; aucune colonne numerique choisie automatiquement."
```

- Decision: manual_review
- Manque principal: Sous-tables natives de sites restaurees par jointure exacte sur les rownames de xy, puis egalite des coordonnees verifiee. Choix scientifique de Y/X et formule encore requis; aucune colonne numerique choisie automatiquement.
- Raison: Sous-tables natives de sites restaurees par jointure exacte sur les rownames de xy, puis egalite des coordonnees verifiee. Choix scientifique de Y/X et formule encore requis; aucune colonne numerique choisie automatiquement.


## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "Sous-tables natives de sites restaurees par jointure exacte sur les rownames de xy, puis egalite des coordonnees verifiee. Choix scientifique de Y/X et formule encore requis; aucune colonne numerique choisie automatiquement."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: WARN - Y/X non identifiees automatiquement ; revue manuelle requise.
- Formula: PENDING — formule executable indisponible ; conserver la preuve publiee separement dans formula_pub.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2)).

## Related Pages

- Source: package R `ade4`

## Curation documentée — 2026-09-07

Tables restaurees : env, fish. Les prefixes conservent la table d’origine. Documentation primaire : wiki/datasets/r_package_docs/ade4/topics/doubs.md ; verification : data/manifests/datasets/ade4_reviewed_table_joins_2026-09-07.json .

Decision conservatoire : Sous-tables natives de sites restaurees par jointure exacte sur les rownames de xy, puis egalite des coordonnees verifiee. Choix scientifique de Y/X et formule encore requis; aucune colonne numerique choisie automatiquement. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
