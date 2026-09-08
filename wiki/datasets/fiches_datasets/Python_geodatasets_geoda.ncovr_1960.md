---
title: Python_geodatasets_geoda.ncovr_1960
type: dataset
created: 2026-08-15
updated: 2026-09-07
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.ncovr_1960.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`ncovr_1960`).

## Description du jeu de donnees

- Topic: Donnees de python-package : Python_geodatasets_geoda.ncovr_1960
- Observation unit: observation spatiale de type POINT
- Observed population: 3085 enregistrements dans l’artefact local Python_geodatasets_geoda.ncovr_1960.rds; unite declaree : observation spatiale de type POINT. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: Etendue mesuree dans le RDS : x [-124.208955460193, -67.554446611081], y [25.53857425, 48.86431695]; CRS WGS 84.
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`ncovr_1960`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `homicide_rate`
- Candidate Y typology: continuous
- Candidate X variables: `SOUTH`, `resource_deprivation`, `population_structure`, `median_age`, `unemployment_rate`, `divorce_rate`
- Candidate X typology: categorical, continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `homicide_rate` | `numeric` | continuous | [0, 92.9368] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Le taux d'homicide est la variable réponse naturelle de ce dataset issu de la littérature criminologique (NAcovR). Les variables socio-économiques et démographiques (déprivation, structure de population, âge médian, chômage, divorce, indicateur Sud) constituent des covariables explicatives classiques de la criminalité ; les colonnes NAME, STATE_NAME, FIPS et FIPSNO sont purement administratives/identifiantes et sont ignorées.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `SOUTH` | `integer` | binary | 0% |
| `resource_deprivation` | `numeric` | continuous | 0% |
| `population_structure` | `numeric` | continuous | 0% |
| `median_age` | `numeric` | continuous | 0% |
| `unemployment_rate` | `numeric` | continuous | 0% |
| `divorce_rate` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: homicide_rate ~ resource_deprivation + population_structure + median_age + unemployment_rate + divorce_rate + SOUTH (referencee dans catalogue)
- x_terms_pub: resource_deprivation, population_structure, median_age, unemployment_rate, divorce_rate, SOUTH
- y_term_pub: homicide_rate
- Reference publication: Baller, R.D., Anselin, L., Messner, S.F., Deane, G. and Hawkins, D.F. (2001) Structural covariates of U.S. county homicide rates: incorporating spatial effects. Criminology 39(3), 561-590. DOI 10.1111/j.1745-9125.2001.tb00933.x. Section 'Data' (p.568) confirmee par lecture directe du PDF : 'The independent variables are county analogues of the measures used by Land et al. (1990) ... resource deprivation and population structure are represented by principal components indexes ... The models also include median age, the unemployment rate, percent divorced, and a Southern dummy variable.' RD/PS sont deja les composantes principales precalculees dans le dataset (colonnes RD60-90/PS60-90 du package geoda.ncovr), pas reconstruites. Decoupe le 2026-08-15 en 4 fiches decennales (politique : plusieurs coupes temporelles plutot qu'une seule).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: homicide_rate ~ resource_deprivation + population_structure + median_age + unemployment_rate + divorce_rate + SOUTH
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: resource_deprivation, population_structure, median_age, unemployment_rate, divorce_rate, SOUTH
- y_term_used: homicide_rate

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "homicide_rate ~ resource_deprivation + population_structure + median_age + unemployment_rate + divorce_rate + SOUTH"
    response: "homicide_rate"
    predictors: ["resource_deprivation, population_structure, median_age, unemployment_rate, divorce_rate, SOUTH"]
    role: "simple_baseline"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Baller, R.D., Anselin, L., Messner, S.F., Deane, G. and Hawkins, D.F. (2001) Structural covariates of U.S. county homicide rates: incorporating spatial effects. Criminology 39(3), 561-590. DOI 10.1111/j.1745-9125.2001.tb00933.x. Section 'Data' (p.568) confirmee par lecture directe du PDF : 'The independent variables are county analogues of the measures used by Land et al. (1990) ... resource deprivation and population structure are represented by principal components indexes ... The models also include median age, the unemployment rate, percent divorced, and a Southern dummy variable.' RD/PS sont deja les composantes principales precalculees dans le dataset (colonnes RD60-90/PS60-90 du package geoda.ncovr), pas reconstruites. Decoupe le 2026-08-15 en 4 fiches decennales (politique : plusieurs coupes temporelles plutot qu'une seule)."
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

- Dataset ID: `Python_geodatasets_geoda.ncovr_1960`
- Dataset name: geodatasets::ncovr_1960
- Source family: python-package
- Source: package Python `geodatasets`
- Source URL: https://pypi.org/project/geodatasets/
- Dataset DOI: none
- Publication DOI: 10.1111/j.1745-9125.2001.tb00933.x
- Year: 2023

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "homicide_rate ~ resource_deprivation + population_structure + median_age + unemployment_rate + divorce_rate + SOUTH"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Baller, R.D., Anselin, L., Messner, S.F., Deane, G. and Hawkins, D.F. (2001) Structural covariates of U.S. county homicide rates: incorporating spatial effects. Criminology 39(3), 561-590. DOI 10.1111/j.1745-9125.2001.tb00933.x. Section 'Data' (p.568) confirmee par lecture directe du PDF : 'The independent variables are county analogues of the measures used by Land et al. (1990) ... resource deprivation and population structure are represented by principal components indexes ... The models also include median age, the unemployment rate, percent divorced, and a Southern dummy variable.' RD/PS sont deja les composantes principales precalculees dans le dataset (colonnes RD60-90/PS60-90 du package geoda.ncovr), pas reconstruites. Decoupe le 2026-08-15 en 4 fiches decennales (politique : plusieurs coupes temporelles plutot qu'une seule)."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 3085
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-124.209, -67.5544], y [25.5386, 48.8643] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: pending — multi-zones (span=56.7deg) -- projection nationale recommandee

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
  benchmark_status: "ready"
  benchmark_task: "regression_spatial_package_formula"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Formule issue d'une publication/documentation package, reponse numerique, covariables locales et support spatial disponibles. Bloc estimator_eligibility complete le 2026-09-08 avec au moins un estimateur documente (voir section Estimator eligibility) -- resout l'incoherence 'estimator_eligibility_block_missing' qui avait motive la retrogradation du 2026-09-07."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Formule issue d'une publication/documentation package, reponse numerique, covariables locales et support spatial disponibles. Bloc estimator_eligibility complete le 2026-09-08 avec au moins un estimateur documente (voir section Estimator eligibility) -- resout l'incoherence 'estimator_eligibility_block_missing' qui avait motive la retrogradation du 2026-09-07.


## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators:
    - estimator: ols
      basis: scientific_evidence
      source_ref: "Baller, Anselin, Messner, Deane & Hawkins (2001), Criminology 39(3), 561-590, section 'Data' p.568."
      notes: "Modele de base homicide_rate ~ covariables structurelles, tel que documente dans le texte cite du papier."
    - estimator: sar_lag
      basis: scientific_evidence
      source_ref: "Baller, Anselin, Messner, Deane & Hawkins (2001), Criminology 39(3), 561-590."
      notes: "Titre du papier ('incorporating spatial effects') et objet meme de l'article : modeles de regression spatiale (spatial lag/regime) sur homicide_rate. Verification page-par-page des coefficients non encore faite -- basis restera a affiner si une lecture plus fine devient necessaire."
  conditionally_eligible_estimators: []
  ineligible_reason: "Bloc estimator_eligibility complete le 2026-09-08 (etait vide/placeholder depuis l'audit du 2026-09-07, incoherence 'estimator_eligibility_block_missing'). 2 estimateur(s) documente(s) sans invention, bases exclusivement sur le texte deja present dans 'Reference publication'/'formula_pub' de cette fiche."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`

## Curation documentée — 2026-09-07

Decision conservatoire : Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
