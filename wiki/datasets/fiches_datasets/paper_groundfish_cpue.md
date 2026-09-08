---
title: paper_groundfish_cpue
type: dataset
created: 2026-08-16
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_groundfish_cpue.rds
  - DatasetFirst_10_5061_dryad_s23g7bc
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Spatiotemporally explicit model averaging for forecasting of Alaskan groundfish catch" (DOI 10.1002/ece3.4488).

## Description du jeu de donnees

- Topic: halieutique / prevision de capture (poissons de fond)
- Observation unit: station de peche a la palangre (annee)
- Observed population: poissons de fond d'Alaska (morue, fletan, grenadier), releves longline AFSC
- Geographic context: Etendue mesuree dans le RDS : x [-168.988, -132.838], y [52.663, 59.747]; CRS EPSG:4326.
- Temporal context: 23 distinct periods (variable: Year)
- Source description: Spatiotemporally explicit model averaging for forecasting of Alaskan groundfish catch
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1002/ece3.4488
- Dataset DOI: 10.5061/dryad.s23g7bc
- Source URL: https://doi.org/10.5061/dryad.s23g7bc
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_s23g7bc/`
- Local sf output: `data/final_datasets/sf/paper_groundfish_cpue.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `CPUE`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Year`, `SST_cvW`, `SST_cvW5`, `SST_cvW4`, `SST_cvW3`, `SST_cvW2`, `SST_cvW1`
- Candidate X count in local artifact: 7
- Candidate X typology: continuous
- Published X variables from paper: SST_cvW1-W5
- Published X count: 1
- Coordinates (x, y - excluded from X candidates): `Longitude`, `Latitude`
- Identifier columns (excluded from X candidates): `Station`, `Area`, `Species`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `CPUE` | `numeric` | continuous | [0.019, 16.445] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `groundfish_cpue`, la ou les reponses `CPUE` viennent du loader papier et/ou des preuves de l article `Spatiotemporally explicit model averaging for forecasting of Alaskan groundfish catch`. Les covariables X retenues sont `SST_cvW1`, `SST_cvW2`, `SST_cvW3`, `SST_cvW4`, `SST_cvW5` ; 2 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Longitude`, `Latitude`), identifiants (`Station`, `Area`, `Species`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready_panel_reduction; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Year` | `integer` | count | 0% |
| `SST_cvW` | `numeric` | rate | 0% |
| `SST_cvW5` | `numeric` | rate | 0% |
| `SST_cvW4` | `numeric` | rate | 0% |
| `SST_cvW3` | `numeric` | rate | 0% |
| `SST_cvW2` | `numeric` | rate | 0% |
| `SST_cvW1` | `numeric` | rate | 0% |

### Formule - niveau publication

- formula_pub: CPUE ~ SST_cvW1 + SST_cvW2 + SST_cvW3 + SST_cvW4 + SST_cvW5 [Moyenne de modeles (multimodel averaging, AIC), modeles candidats a differentes fenetres temporelles de coefficient de variation de la temperature de surface de la mer (SST) hivernale]
- x_terms_pub: SST_cvW1-W5
- y_term_pub: CPUE
- Reference publication: Correia, H.E. (2018), Spatiotemporally explicit model averaging for forecasting of Alaskan groundfish catch, Ecology and Evolution, doi:10.1002/ece3.4488. CSV original (stema_data.csv) telecharge directement depuis Dryad (10.5061/dryad.s23g7bc) -- pas une reconstruction, N=6716 (panel station x annee). Y et X correspondent exactement aux variables decrites dans le papier (CPUE standardisee AFSC, coefficient de variation de la SST hivernale sur grille 0.25 degre, plusieurs fenetres temporelles).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: CPUE ~ SST_cvW1 + SST_cvW2 + SST_cvW3 + SST_cvW4 + SST_cvW5
- Recommended validation: N lignes=6716; T declare=23; variable temporelle declaree=Year; repetitions de coordonnees controlees=6643. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: SST_cvW1, SST_cvW2, SST_cvW3, SST_cvW4, SST_cvW5
- y_term_used: CPUE
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "CPUE ~ SST_cvW1 + SST_cvW2 + SST_cvW3 + SST_cvW4 + SST_cvW5"
    response: "CPUE"
    predictors: ["SST_cvW1-W5"]
    role: "simple_baseline"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "spatial_baseline"]
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
    formula: "CPUE ~ SST_cvW1 + SST_cvW2 + SST_cvW3 + SST_cvW4 + SST_cvW5"
    response: "CPUE"
    predictors: ["SST_cvW1", "SST_cvW2", "SST_cvW3", "SST_cvW4", "SST_cvW5"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["model_averaging", "gwr", "random_forest", "sar_lag"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_groundfish_cpue`
- Dataset name: Data from: Spatio-temporally explicit model averaging for forecasting of Alaskan groundfish catch
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Spatiotemporally explicit model averaging for forecasting of Alaskan groundfish catch
- Paper DOI: 10.1002/ece3.4488
- Dataset DOI: 10.5061/dryad.s23g7bc
- Source URL: https://doi.org/10.5061/dryad.s23g7bc
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "CPUE ~ SST_cvW1 + SST_cvW2 + SST_cvW3 + SST_cvW4 + SST_cvW5 [Moyenne de modeles (multimodel averaging, AIC), modeles candidats a differentes fenetres temporelles de coefficient de variation de la temperature de surface de la mer (SST) hivernale]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Correia, H.E. (2018), Spatiotemporally explicit model averaging for forecasting of Alaskan groundfish catch, Ecology and Evolution, doi:10.1002/ece3.4488. CSV original (stema_data.csv) telecharge directement depuis Dryad (10.5061/dryad.s23g7bc) -- pas une reconstruction, N=6716 (panel station x annee). Y et X correspondent exactement aux variables decrites dans le papier (CPUE standardisee AFSC, coefficient de variation de la SST hivernale sur grille 0.25 degre, plusieurs fenetres temporelles)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready_panel_reduction"
  benchmark_task: "grouped_or_temporal_validation_review"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "N lignes=6716; T declare=23; variable temporelle declaree=Year; repetitions de coordonnees controlees=6643. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification."
  reason: "N lignes=6716; T declare=23; variable temporelle declaree=Year; repetitions de coordonnees controlees=6643. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification."
```

- Decision: ready_panel_reduction
- Manque principal: N lignes=6716; T declare=23; variable temporelle declaree=Year; repetitions de coordonnees controlees=6643. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.
- Raison: N lignes=6716; T declare=23; variable temporelle declaree=Year; repetitions de coordonnees controlees=6643. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready_panel_reduction"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "N lignes=6716; T declare=23; variable temporelle declaree=Year; repetitions de coordonnees controlees=6643. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 6716
- k variables: 16
- T periods: 23
- Variable temporelle: Year
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (6716) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 73 ; panel EQUILIBRE (chaque unite a exactement T=92 observations). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 73 unites spatiales distinctes, pas sur les 6716 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 23 distinct periods (variable: Year)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-168.988, -132.838], y [52.663, 59.747]
- Time range: 1990 to 2012 (variable: Year)
- CRS analyse recommande: pending - multi-zones (span=36.2deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.s23g7bc (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`groundfish_cpue` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `groundfish_cpue` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`groundfish_cpue` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Spatiotemporally explicit model averaging for forecasting of Alaskan groundfish catch

## Curation documentée — 2026-09-07

Decision conservatoire : N lignes=6716; T declare=23; variable temporelle declaree=Year; repetitions de coordonnees controlees=6643. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
