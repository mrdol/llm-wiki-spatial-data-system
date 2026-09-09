---
title: paper_spruce_bark_beetle
type: dataset
created: 2026-08-15
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_spruce_bark_beetle.rds
  - DataCite_2024_ClimaticAndManagementRelated_10_1111_1365_266
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Climatic and management-related drivers of endemic European spruce bark beetle populations in boreal forests" (DOI 10.1111/1365-2664.14606).

## Description du jeu de donnees

- Topic: ecologie / interactions plantes-pollinisateurs
- Observation unit: site d'observation ou cellule de grille d'occurrence
- Observed population: communautes de pollinisateurs ou d'oiseaux nectarivores
- Geographic context: etendue sf: x [7.10182, 14.55037], y [58.08526, 66.4163]
- Temporal context: 18 distinct periods (variable: year)
- Source description: Climatic and management-related drivers of endemic European spruce bark beetle populations in boreal forests
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/1365-2664.14606
- Dataset DOI: 10.5061/dryad.kd51c5bdc
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.kd51c5bdc
- Local raw dir: `data/raw/papers/DataCite_2024_ClimaticAndManagementRelated_10_1111_1365_266/`
- Local sf output: `data/final_datasets/sf/paper_spruce_bark_beetle.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `trapcounts`
- Candidate Y typology: count
- Candidate X variables in local artifact: `year`, `masl`, `spruce_vol`, `veg_zone`, `felling_border`, `temperature`, `precipitation`, `soil_moisture`
- Candidate X count in local artifact: 8
- Candidate X typology: continuous, categorical
- Published X variables from paper: spruce_vol, felling_border, temperature, soil_moisture, veg_zone
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): `east`, `north`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `trapcounts` | `integer` | count | [7, 36735] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `spruce_bark_beetle`, la ou les reponses `trapcounts` viennent du loader papier et/ou des preuves de l article `Climatic and management-related drivers of endemic European spruce bark beetle populations in boreal forests`. Les covariables X retenues sont `spruce_vol`, `felling_border`, `temperature`, `soil_moisture`, `veg_zone` ; 3 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`east`, `north`), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready_panel_reduction; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `year` | `integer` | count | 0% |
| `masl` | `character` | categorical | 0% |
| `spruce_vol` | `character` | categorical | 0% |
| `veg_zone` | `factor` | categorical | 0% |
| `felling_border` | `integer` | count | 0% |
| `temperature` | `character` | categorical | 0% |
| `precipitation` | `character` | categorical | 0% |
| `soil_moisture` | `character` | categorical | 0% |

### Formule - niveau publication

- formula_pub: trapcounts ~ spruce_vol + felling_border_lag3 * veg_zone + temperature_lag3 + soil_moisture_lag3 + longitude + latitude + second_order_terms [negative binomial GLM]
- x_terms_pub: spruce_vol, felling_border, temperature, soil_moisture, veg_zone
- y_term_pub: trapcounts
- Reference publication: Gohli et al. (2024), Journal of Applied Ecology, DOI 10.1111/1365-2664.14606: Sections 2.1.1-2.2 define trap counts and predictors; Section 2.1.5 selects a 3-year lag for clearcut edge, temperature, precipitation and soil moisture; Section 3 reports the final parsimonious negative-binomial GLM, where precipitation, altitude and sampling year are dropped, while mature spruce volume, new clearcut edge, temperature, soil moisture, vegetation zone interactions and longitude/latitude remain supported. formula_used keeps the executable non-coordinate subset available in the local .rds.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: trapcounts ~ spruce_vol + felling_border + temperature + soil_moisture + veg_zone
- Recommended validation: N lignes=1731; T declare=18; variable temporelle declaree=year; repetitions de coordonnees controlees=27. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: count
- x_terms_used: spruce_vol, felling_border, temperature, soil_moisture, veg_zone
- y_term_used: trapcounts
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
    formula: "trapcounts ~ spruce_vol + felling_border + temperature + soil_moisture + veg_zone"
    response: "trapcounts"
    predictors: ["spruce_vol", "felling_border", "temperature", "soil_moisture", "veg_zone"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

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

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_spruce_bark_beetle`
- Dataset name: Data for: Climatic and management-related drivers of endemic European spruce bark beetle populations in boreal forests
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Climatic and management-related drivers of endemic European spruce bark beetle populations in boreal forests
- Paper DOI: 10.1111/1365-2664.14606
- Dataset DOI: 10.5061/dryad.kd51c5bdc
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.kd51c5bdc
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "trapcounts ~ spruce_vol + felling_border_lag3 * veg_zone + temperature_lag3 + soil_moisture_lag3 + longitude + latitude + second_order_terms [negative binomial GLM]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Gohli et al. (2024), Journal of Applied Ecology, DOI 10.1111/1365-2664.14606: Sections 2.1.1-2.2 define trap counts and predictors; Section 2.1.5 selects a 3-year lag for clearcut edge, temperature, precipitation and soil moisture; Section 3 reports the final parsimonious negative-binomial GLM, where precipitation, altitude and sampling year are dropped, while mature spruce volume, new clearcut edge, temperature, soil moisture, vegetation zone interactions and longitude/latitude remain supported. formula_used keeps the executable non-coordinate subset available in the local .rds."
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
- N observations: 1731
- k variables: 14
- T periods: 18
- Variable temporelle: year
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (1731) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 1703 ; panel NON EQUILIBRE (T par unite : min=1, mediane=1, max=5). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 1703 unites spatiales distinctes, pas sur les 1731 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 18 distinct periods (variable: year)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [7.10182, 14.55037], y [58.08526, 66.4163]
- Time range: 2004 to 2021 (variable: year)
- CRS analyse recommande: 32632 (UTM Zone 32N (EPSG:32632)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.kd51c5bdc (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`spruce_bark_beetle` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `spruce_bark_beetle` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`spruce_bark_beetle` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Note -- promotion en lot (2026-09-09)

Formule, reponse et covariables deja resolues (Y/X/formula_used complets avant cette passe). Seul le bloc 'Estimator eligibility' etait vide -- rempli ici avec les estimateurs generiques adaptes a la typologie Y (count), sur decision explicite de l'utilisateur de revoir en lot les fiches 'manual_review' deja completes. Base 'scientific_evidence' reservee aux cas ou le texte de la fiche documente deja une methode precise ; sinon 'benchmark_use'/'generated_candidate' (pas de surinterpretation de la methode publiee).

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Climatic and management-related drivers of endemic European spruce bark beetle populations in boreal forests

## Curation documentée — 2026-09-07

Decision conservatoire : N lignes=1731; T declare=18; variable temporelle declaree=year; repetitions de coordonnees controlees=27. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : count. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
