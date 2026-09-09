---
title: paper_marrot_spatial_autocorrelation_fitness
type: dataset
created: 2026-08-15
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_marrot_spatial_autocorrelation_fitness.rds
  - DataCite_2015_SpatialAutocorrelationInFitness_10_1111_2041_210
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Spatial autocorrelation in fitness affects the estimation of natural selection in the wild" (DOI 10.1111/2041-210x.12448).

## Description du jeu de donnees

- Topic: dataset spatial spatio-temporel
- Observation unit: observation spatiale du dataset "Data from: Spatial autocorrelation in fitness affects the estimation of natural selection in the wild"
- Observed population: DataCite/OpenAlex title, abstract metadata or subjects matched strict spatial regression heuristics
- Geographic context: etendue sf: x [3.661328, 3.679321], y [43.6539548, 43.674217]
- Temporal context: 6 distinct periods (variable: Years)
- Source description: Spatial autocorrelation in fitness affects the estimation of natural selection in the wild
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/2041-210x.12448
- Dataset DOI: 10.5061/dryad.pm86c
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.pm86c
- Local raw dir: `data/raw/papers/DataCite_2015_SpatialAutocorrelationInFitness_10_1111_2041_210/`
- Local sf output: `data/final_datasets/sf/paper_marrot_spatial_autocorrelation_fitness.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Number_of_fledglings`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Laying_date`, `Clutch_size`, `Incubation_duration`
- Candidate X count in local artifact: 3
- Candidate X typology: continuous
- Published X variables from paper: Clutch_size, Laying_date, Incubation_duration
- Published X count: 3
- Coordinates (x, y - excluded from X candidates): `Longitude`, `Latitude`
- Identifier columns (excluded from X candidates): `Individuals_ID`, `Nest_boxes_ID`, `Years`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Number_of_fledglings` | `numeric` | count | [0, 13] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `marrot_spatial_autocorrelation_fitness`, la ou les reponses `Number_of_fledglings` viennent du loader papier et/ou des preuves de l article `Spatial autocorrelation in fitness affects the estimation of natural selection in the wild`. Les covariables X retenues sont `Clutch_size`, `Laying_date`, `Incubation_duration`. Les coordonnees (`Longitude`, `Latitude`), identifiants (`Individuals_ID`, `Nest_boxes_ID`, `Years`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready_panel_reduction; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Laying_date` | `numeric` | continuous | 0% |
| `Clutch_size` | `numeric` | continuous | 0% |
| `Incubation_duration` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: Number_of_fledglings ~ Clutch_size + Laying_date + Incubation_duration [GLS/SAR selon la structure d'autocorrelation spatiale testee]
- x_terms_pub: Clutch_size, Laying_date, Incubation_duration
- y_term_pub: Number_of_fledglings
- Reference publication: Formule presente dans inst/kg/paper_dataset_uses.json (bib_key DataCite_2015_SpatialAutocorrelationInFitness_10_1111_2041_210) : Number_of_fledglings ~ Clutch_size + Laying_date + Incubation_duration, estimateurs geoles/SAR-lag/SAR-error/PCNM. Les 3 covariables et la reponse sont presentes telles quelles dans le .rds local (N=229). Aucune variante continue de la reponse n'existe dans le depot -- Number_of_fledglings (compte de jeunes a l'envol) est la seule reponse disponible, promue package_include=yes le 2026-08-15 (decision utilisateur : Y present + formule disponible + rds/fiche prets suffit, pas besoin d'une variante continue quand aucune n'existe).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: Number_of_fledglings ~ Clutch_size + Laying_date + Incubation_duration
- Recommended validation: N lignes=229; T declare=6; variable temporelle declaree=Years; repetitions de coordonnees controlees=89. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.
- benchmark_task_note: Number_of_fledglings denombre les jeunes a l’envol.
- Selected Y evidence: Number_of_fledglings denombre les jeunes a l’envol.
- Selected Y typology: count
- x_terms_used: Clutch_size, Laying_date, Incubation_duration
- y_term_used: Number_of_fledglings
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

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
    formula: "Number_of_fledglings ~ Clutch_size + Laying_date + Incubation_duration"
    response: "Number_of_fledglings"
    predictors: ["Clutch_size", "Laying_date", "Incubation_duration"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "Number_of_fledglings ~ Clutch_size + Laying_date + Incubation_duration"
    response: "Number_of_fledglings"
    predictors: ["Clutch_size", "Laying_date", "Incubation_duration"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["gls", "sar_lag", "sar_error", "pcnm", "random_forest"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_marrot_spatial_autocorrelation_fitness`
- Dataset name: Data from: Spatial autocorrelation in fitness affects the estimation of natural selection in the wild
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Spatial autocorrelation in fitness affects the estimation of natural selection in the wild
- Paper DOI: 10.1111/2041-210x.12448
- Dataset DOI: 10.5061/dryad.pm86c
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.pm86c
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Number_of_fledglings ~ Clutch_size + Laying_date + Incubation_duration [GLS/SAR selon la structure d'autocorrelation spatiale testee]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Formule presente dans inst/kg/paper_dataset_uses.json (bib_key DataCite_2015_SpatialAutocorrelationInFitness_10_1111_2041_210) : Number_of_fledglings ~ Clutch_size + Laying_date + Incubation_duration, estimateurs geoles/SAR-lag/SAR-error/PCNM. Les 3 covariables et la reponse sont presentes telles quelles dans le .rds local (N=229). Aucune variante continue de la reponse n'existe dans le depot -- Number_of_fledglings (compte de jeunes a l'envol) est la seule reponse disponible, promue package_include=yes le 2026-08-15 (decision utilisateur : Y present + formule disponible + rds/fiche prets suffit, pas besoin d'une variante continue quand aucune n'existe)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_count"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Y/X/formula_used deja resolus ; estimateurs generiques (count) ajoutes en revue de lot du 2026-09-09."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Y/X/formula_used deja resolus ; estimateurs generiques (count) ajoutes en revue de lot du 2026-09-09.

## Estimator eligibility

```yaml
estimator_eligibility:
  eligible_estimators:
    - estimator: sar_lag
      basis: scientific_evidence
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "SAR / spatial-lag mentionne dans la source."
    - estimator: ols
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Regression (famille Poisson) generique pour reponse de comptage."
    - estimator: gam_spatial
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "GAM (famille Poisson), baseline generique pour reponse de comptage."
    - estimator: xgboost
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Alternative ML generique (objectif Poisson), Y comptage. random_forest exclu -- pas de mode Poisson natif dans ranger/parsnip."
  conditionally_eligible_estimators: []
  ineligible_reason: "n/a -- estimateurs generiques eligibles (voir eligible_estimators)."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 229
- k variables: 12
- T periods: 6
- Variable temporelle: Years
- N/T profile: N_moyen_T_moyen
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (229) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 140 ; panel NON EQUILIBRE (T par unite : min=1, mediane=1, max=5). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 140 unites spatiales distinctes, pas sur les 229 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 6 distinct periods (variable: Years)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [3.661328, 3.679321], y [43.6539548, 43.674217]
- Time range: 2008 to 2013 (variable: Years)
- CRS analyse recommande: 32631 (UTM Zone 31N (EPSG:32631)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.pm86c (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`marrot_spatial_autocorrelation_fitness` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `marrot_spatial_autocorrelation_fitness` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`marrot_spatial_autocorrelation_fitness` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Note -- promotion en lot (2026-09-09)

Formule, reponse et covariables deja resolues (Y/X/formula_used complets avant cette passe). Seul le bloc 'Estimator eligibility' etait vide -- rempli ici avec les estimateurs generiques adaptes a la typologie Y (count), sur decision explicite de l'utilisateur de revoir en lot les fiches 'manual_review' deja completes. Base 'scientific_evidence' reservee aux cas ou le texte de la fiche documente deja une methode precise ; sinon 'benchmark_use'/'generated_candidate' (pas de surinterpretation de la methode publiee).

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Spatial autocorrelation in fitness affects the estimation of natural selection in the wild

## Curation documentée — 2026-09-07

Decision conservatoire : N lignes=229; T declare=6; variable temporelle declaree=Years; repetitions de coordonnees controlees=89. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : count. Number_of_fledglings denombre les jeunes a l’envol.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
