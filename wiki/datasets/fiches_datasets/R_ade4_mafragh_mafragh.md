---
title: R_ade4_mafragh_mafragh
type: dataset
created: 2026-08-15
updated: 2026-09-07
sources:
  - data/final_datasets/sf/R_ade4_mafragh_mafragh.rds
tags: [dataset, r-package, spatial, point]
---

This data set gives environmental and spatial informations about species and sites.

## Description du jeu de donnees

- Topic: Donnees de r-package : R_ade4_mafragh_mafragh
- Observation unit: observation spatiale de type POINT
- Observed population: 97 enregistrements dans l’artefact local R_ade4_mafragh_mafragh.rds; unite declaree : observation spatiale de type POINT. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: Etendue mesuree dans le RDS : x [25.2, 386.4], y [9.75, 209]; CRS non renseigne, repere/unites a documenter.
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: This data set gives environmental and spatial informations about species and sites.
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
- Reference publication: See a data description at <http://pbil.univ-lyon1.fr/R/pdf/pps053.pdf> (in French).

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- Formula used evidence: unavailable
- Restored source variables: `env__Clay`, `env__Silt`, `env__Sand`, `env__K2O`, `env__Mg++`, `env__Na+/100g`, `env__K+`, `env__Conductivity`, `env__Retention`, `env__Na+/l`, `env__Elevation`, `flo__Sp1`, `flo__Sp2`, `flo__Sp3`, `flo__Sp4`, `flo__Sp5`, `flo__Sp6`, `flo__Sp7`, `flo__Sp8`, `flo__Sp9`, `flo__Sp10`, `flo__Sp11`, `flo__Sp12`, `flo__Sp13`, `flo__Sp14`, `flo__Sp15`, `flo__Sp16`, `flo__Sp17`, `flo__Sp18`, `flo__Sp19`, `flo__Sp20`, `flo__Sp21`, `flo__Sp22`, `flo__Sp23`, `flo__Sp24`, `flo__Sp25`, `flo__Sp26`, `flo__Sp27`, `flo__Sp28`, `flo__Sp29`, `flo__Sp30`, `flo__Sp31`, `flo__Sp32`, `flo__Sp33`, `flo__Sp34`, `flo__Sp35`, `flo__Sp36`, `flo__Sp37`, `flo__Sp38`, `flo__Sp39`, `flo__Sp40`, `flo__Sp41`, `flo__Sp42`, `flo__Sp43`, `flo__Sp44`, `flo__Sp45`, `flo__Sp46`, `flo__Sp47`, `flo__Sp48`, `flo__Sp49`, `flo__Sp50`, `flo__Sp51`, `flo__Sp52`, `flo__Sp53`, `flo__Sp54`, `flo__Sp55`, `flo__Sp56`
- k variables: 71
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

- Dataset ID: `R_ade4_mafragh_mafragh`
- Dataset name: ade4::mafragh
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
- N observations: 97
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [25.2, 386.4], y [9.75, 209] (CRS unknown)
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

Tables restaurees : env, flo. Les prefixes conservent la table d’origine. Documentation primaire : wiki/datasets/r_package_docs/ade4/topics/mafragh.md ; verification : data/manifests/datasets/ade4_reviewed_table_joins_2026-09-07.json .

Decision conservatoire : Sous-tables natives de sites restaurees par jointure exacte sur les rownames de xy, puis egalite des coordonnees verifiee. Choix scientifique de Y/X et formule encore requis; aucune colonne numerique choisie automatiquement. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
