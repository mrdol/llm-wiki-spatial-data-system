---
title: paper_coral_stylaster
type: dataset
created: 2026-08-15
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_coral_stylaster.rds
  - DataCite_2022_PredictingTheEffectsOf_10_1111_gcb_1638
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Predicting the effects of climate change on deep-water coral distribution around New Zealand-Will there be suitable refuges for protection at the end of the 21st century?" (DOI 10.1111/gcb.16389).

## Description du jeu de donnees

- Topic: Donnees de paper-derived : paper_coral_stylaster
- Observation unit: observation spatiale du dataset "Climate change effects on deep-water corals - habitat suitability model input data"
- Observed population: ModÃ¨les de suitabilitÃ© d'habitat (HSM) pour coraux profonds en Nouvelle-ZÃ©lande avec Random Forests et Boosted Regression Trees ; prÃ©dictions spatiales sous changement climatique ; correspond au pÃ©rimÃ¨tre spatial random forest / boosting spatial / climate / biodiversity / spatial prediction
- Geographic context: etendue sf: x [-179.99665, 179.993454], y [-54.9249992, -24.1665]
- Temporal context: none (cross-sectional)
- Source description: Predicting the effects of climate change on deep-water coral distribution around New Zealand-Will there be suitable refuges for protection at the end of the 21st century?
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/gcb.16389
- Dataset DOI: 10.5061/dryad.41ns1rnht
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.41ns1rnht
- Local raw dir: `data/raw/papers/DataCite_2022_PredictingTheEffectsOf_10_1111_gcb_1638/`
- Local sf output: `data/final_datasets/sf/paper_coral_stylaster.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `pa`
- Candidate Y typology: binary
- Candidate X variables in local artifact: `carbonate`, `mud`, `sand`, `bpi_fine`, `depth`, `slope_per`, `smtfinal`, `BEN_N_C`, `DETFLUX3_C`, `OXY_C`, `PBO_C`, `SFR_OARG_C`, `SO_C`, `OM_CAL3_C`
- Candidate X count in local artifact: 14
- Candidate X typology: continuous
- Published X variables from paper: carbonate, mud, sand, bpi_fine, depth, slope_per, smtfinal, BEN_N_C, DETFLUX3_C, OXY_C, PBO_C, SFR_OARG_C
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `pa` | `integer` | binary | {0, 1} | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `coral_stylaster`, la ou les reponses `pa` viennent du loader papier et/ou des preuves de l article `Predicting the effects of climate change on deep-water coral distribution around New Zealand-Will there be suitable refuges for protection at the end of the 21st century?`. Les covariables X retenues sont `carbonate`, `mud`, `sand`, `bpi_fine`, `depth`, `slope_per`, `smtfinal`, `BEN_N_C`, `DETFLUX3_C`, `OXY_C`, `PBO_C`, `SFR_OARG_C` ; 2 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`lon`, `lat`), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `carbonate` | `numeric` | continuous | 0% |
| `mud` | `numeric` | continuous | 0% |
| `sand` | `numeric` | continuous | 0% |
| `bpi_fine` | `integer` | count | 0% |
| `depth` | `integer` | count | 0% |
| `slope_per` | `numeric` | continuous | 0% |
| `smtfinal` | `numeric` | rate | 0% |
| `BEN_N_C` | `numeric` | continuous | 0% |
| `DETFLUX3_C` | `numeric` | continuous | 0% |
| `OXY_C` | `numeric` | continuous | 0% |
| `PBO_C` | `numeric` | continuous | 0% |
| `SFR_OARG_C` | `numeric` | continuous | 0% |
| `SO_C` | `numeric` | continuous | 0% |
| `OM_CAL3_C` | `numeric` | continuous | 0.4% |

### Formule - niveau publication

- formula_pub: pending
- x_terms_pub: carbonate, mud, sand, bpi_fine, depth, slope_per, smtfinal, BEN_N_C, DETFLUX3_C, OXY_C, PBO_C, SFR_OARG_C
- y_term_pub: pa
- Reference publication: DataCite dataset DOI 10.5061/dryad.41ns1rnht; Publication DOI 10.1111/gcb.16389

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule - niveau systeme

- formula_used: pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OXY_C + PBO_C + SFR_OARG_C + SO_C + OM_CAL3_C
- Formula used evidence: generated_system_formula
- x_terms_used: carbonate, mud, sand, bpi_fine, depth, slope_per, smtfinal, BEN_N_C, DETFLUX3_C, OXY_C, PBO_C, SFR_OARG_C, SO_C, OM_CAL3_C
- y_term_used: pa
- Note: formule candidate generee automatiquement (Y ~ toutes les covariables X detectees), PAS une formule publiee ou verifiee dans le papier source - a confirmer par revue manuelle.

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
    formula: "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OXY_C + PBO_C + SFR_OARG_C + ... (2 covariables au total, voir Candidate X variables)"
    response: "pa"
    predictors: ["carbonate", "mud", "sand", "bpi_fine", "depth", "slope_per", "smtfinal", "BEN_N_C", "DETFLUX3_C", "OXY_C", "PBO_C", "SFR_OARG_C"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/raw/papers (loader-derived, no published equation located)"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_coral_stylaster`
- Dataset name: Climate change effects on deep-water corals - habitat suitability model input data
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Predicting the effects of climate change on deep-water coral distribution around New Zealand-Will there be suitable refuges for protection at the end of the 21st century?
- Paper DOI: 10.1111/gcb.16389
- Dataset DOI: 10.5061/dryad.41ns1rnht
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.41ns1rnht
- Year: unknown

## Bloc 3 - Typologie des modeles

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
  benchmark_status: "ready"
  benchmark_task: "classification_binary_presence_absence"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Bloc estimator_eligibility complete le 2026-09-08. Ancien blocage 'current_package_regression_only' resolu : c'etait un bug du script d'export (code/package_metadata/export_spatialtidymodels_metadata.py, verification textuelle codee en dur sur benchmark_task contenant 'classification'/'presence_absence', jamais mise a jour apres l'ajout du routage binaire/comptage cette semaine) -- corrige a la source, le garde-fou selected_response_typology_unresolved (base sur la vraie typologie resolue) prend desormais seul le relais, correctement, pour les cas multi-classes genuinement non supportes."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Bloc estimator_eligibility complete le 2026-09-08. Ancien blocage 'current_package_regression_only' resolu : c'etait un bug du script d'export (code/package_metadata/export_spatialtidymodels_metadata.py, verification textuelle codee en dur sur benchmark_task contenant 'classification'/'presence_absence', jamais mise a jour apres l'ajout du routage binaire/comptage cette semaine) -- corrige a la source, le garde-fou selected_response_typology_unresolved (base sur la vraie typologie resolue) prend desormais seul le relais, correctement, pour les cas multi-classes genuinement non supportes.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators:
    - estimator: ols
      basis: generated_candidate
      source_ref: "Routage binaire/comptage ajoute au harnais cette semaine (glm(family=binomial()) sous le nom ols) ; verifie par la suite de tests du package."
      notes: "Aucune methode publiee documentee pour ce papier (formula_pub/modeling_evidence: pending) -- eligibilite basee sur la capacite technique du harnais, pas sur une preuve de la publication."
    - estimator: gam_spatial
      basis: generated_candidate
      source_ref: "Routage binaire ajoute au harnais cette semaine (mgcv::gam(family=binomial()))."
      notes: "Meme reserve que ci-dessus : capacite technique, pas preuve documentee du papier source."
    - estimator: random_forest
      basis: published_model
      source_ref: "Description de la fiche (Observed population) : 'Modeles de suitabilite d'habitat (HSM) pour coraux profonds en Nouvelle-Zelande avec Random Forests et Boosted Regression Trees' -- Random Forest est explicitement le modele publie."
      notes: "Route technique (ranger, mode classification, response_typologies inclut binary depuis cette semaine) alignee sur la methode documentee du papier."
    - estimator: xgboost
      basis: published_model
      source_ref: "Description de la fiche (Observed population) mentionne des Boosted Regression Trees (BRT) -- xgboost est l'estimateur boosting le plus proche disponible dans le harnais (BRT et gradient boosting partagent le meme principe, non strictement identiques)."
      notes: "Route technique (mode classification, response_typologies inclut binary depuis cette semaine) analogue a la methode BRT documentee du papier, sans etre l'implementation exacte utilisee par les auteurs."
    - estimator: sar_probit
      basis: generated_candidate
      source_ref: "Nouvel estimateur ajoute cette semaine specifiquement pour la reponse binaire (ProbitSpatial::ProbitSpatialFit, DGP=SAR) -- pertinent ici car 'pa' (presence/absence) est un cas d'usage typique de ce modele (SDM spatial binaire)."
      notes: "Capacite technique du harnais, pas preuve documentee du papier source."
    - estimator: sem_probit
      basis: generated_candidate
      source_ref: "Nouvel estimateur ajoute cette semaine specifiquement pour la reponse binaire (ProbitSpatial::ProbitSpatialFit, DGP=SEM)."
      notes: "Capacite technique du harnais, pas preuve documentee du papier source."
  conditionally_eligible_estimators: []
  ineligible_reason: "Bloc estimator_eligibility complete le 2026-09-08. Ancien blocage 'current_package_regression_only' resolu : c'etait un bug du script d'export (code/package_metadata/export_spatialtidymodels_metadata.py, verification textuelle codee en dur sur benchmark_task contenant 'classification'/'presence_absence', jamais mise a jour apres l'ajout du routage binaire/comptage cette semaine) -- corrige a la source, le garde-fou selected_response_typology_unresolved (base sur la vraie typologie resolue) prend desormais seul le relais, correctement, pour les cas multi-classes genuinement non supportes."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 448
- k variables: 19
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-179.99665, 179.993454], y [-54.9249992, -24.1665]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=360deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.41ns1rnht (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`coral_stylaster` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `coral_stylaster` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: PENDING - formule publication non encore etablie (formule candidate systeme fournie a la place).
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`coral_stylaster` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Predicting the effects of climate change on deep-water coral distribution around New Zealand-Will there be suitable refuges for protection at the end of the 21st century?

## Curation documentée — 2026-09-07

La formule systeme enumere les 14 covariables deja declarees dans Candidate X variables et presentes dans le RDS. L’ancienne ellipse etait un defaut du rendu; cette liste demeure une proposition systeme, sans preuve de specification publiee et sans promotion. Sa pertinence scientifique reste en revue.

Decision conservatoire : Ancienne declaration yes incoherente avec les conditions du registre : current_package_regression_only. Conserver la décision actuelle jusqu’au traitement des constats. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
