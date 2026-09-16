---
title: paper_coral_bathypathes
type: dataset
created: 2026-09-14
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_coral_bathypathes.rds
  - DataCite_2022_PredictingTheEffectsOf_10_1111_gcb_1638
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Predicting the effects of climate change on deep-water coral distribution around New Zealand-Will there be suitable refuges for protection at the end of the 21st century?" (DOI 10.1111/gcb.16389).

## Description du jeu de donnees

- Topic: morphometrie et biogeographie animale
- Observation unit: specimen museal individuel
- Observed population: specimens de musee d'histoire naturelle geo-references via GBIF
- Geographic context: etendue sf: x [-179.996833, 179.961167], y [-53.7384167, -28.7049999]
- Temporal context: none (cross-sectional)
- Source description: Predicting the effects of climate change on deep-water coral distribution around New Zealand-Will there be suitable refuges for protection at the end of the 21st century?
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/gcb.16389
- Dataset DOI: 10.5061/dryad.41ns1rnht
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.41ns1rnht
- Local raw dir: `data/raw/papers/DataCite_2022_PredictingTheEffectsOf_10_1111_gcb_1638/`
- Local sf output: `data/final_datasets/sf/paper_coral_bathypathes.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `pa`
- Candidate Y typology: binary
- Candidate X variables in local artifact: `carbonate`, `mud`, `sand`, `bpi_fine`, `depth`, `slope_per`, `smtfinal`, `BEN_N_C`, `DETFLUX3_C`, `OM_CAL3_C`, `OXY_C`, `PBO_C`, `SO_C`, `SFR_OARG_C`
- Candidate X count in local artifact: 14
- Candidate X typology: continuous, unknown
- Published X variables from paper: carbonate, mud, sand, bpi_fine, depth, slope_per, smtfinal, BEN_N_C, DETFLUX3_C, OM_CAL3_C, OXY_C, PBO_C, SO_C, SFR_OARG_C
- Published X count: 14
- Coordinates (x, y - excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `pa` | `integer` | binary | {0, 1} | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `coral_bathypathes`, la ou les reponses `pa` viennent du loader papier et/ou des preuves de l article `Predicting the effects of climate change on deep-water coral distribution around New Zealand-Will there be suitable refuges for protection at the end of the 21st century?`. Les covariables X retenues sont `carbonate`, `mud`, `sand`, `bpi_fine`, `depth`, `slope_per`, `smtfinal`, `BEN_N_C`, `DETFLUX3_C`, `OM_CAL3_C`, `OXY_C`, `PBO_C`, `SO_C`, `SFR_OARG_C`. Les coordonnees (`lon`, `lat`), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `carbonate` | `numeric` | continuous | 0% |
| `mud` | `numeric` | continuous | 0% |
| `sand` | `numeric` | continuous | 0% |
| `bpi_fine` | `integer` | unknown | 0% |
| `depth` | `integer` | unknown | 0% |
| `slope_per` | `numeric` | continuous | 0% |
| `smtfinal` | `numeric` | rate | 0% |
| `BEN_N_C` | `numeric` | continuous | 0% |
| `DETFLUX3_C` | `numeric` | continuous | 0% |
| `OM_CAL3_C` | `numeric` | continuous | 0% |
| `OXY_C` | `numeric` | continuous | 0% |
| `PBO_C` | `numeric` | continuous | 0% |
| `SO_C` | `numeric` | continuous | 0% |
| `SFR_OARG_C` | `numeric` | continuous | 0.8% |

### Formule - niveau publication

- formula_pub: pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C [Random Forests + Boosted Regression Trees ensemble SDM]
- x_terms_pub: carbonate, mud, sand, bpi_fine, depth, slope_per, smtfinal, BEN_N_C, DETFLUX3_C, OM_CAL3_C, OXY_C, PBO_C, SO_C, SFR_OARG_C
- y_term_pub: pa
- Reference publication: Anderson, Stephenson, Behrens & Rowden (2022), Global Change Biology, DOI 10.1111/gcb.16389; README.txt Dryad (dataset 10.5061/dryad.41ns1rnht) documente colonne-par-colonne les 12 fichiers presence/absence par taxon (lat, lon, pa, puis les variables environnementales). Le README documente 12 variables nommees explicitement ; le CSV reel en contient 14 (sand et PBO_C en plus, non fabriquees, presentes telles quelles dans le fichier telecharge). Estimateurs de reference fixes le 2026-08-15 sur random_forest/random_forest_spatial (deja disponibles dans le package spatialtidymodels), memes 12 taxons du meme depot.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

### Formule - niveau systeme

- formula_used: pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C
- License evidence: DataCite API record for DOI 10.5061/dryad.41ns1rnht (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: binary
- x_terms_used: carbonate, mud, sand, bpi_fine, depth, slope_per, smtfinal, BEN_N_C, DETFLUX3_C, OM_CAL3_C, OXY_C, PBO_C, SO_C, SFR_OARG_C
- y_term_used: pa
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
    formula: "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C"
    response: "pa"
    predictors: ["carbonate", "mud", "sand", "bpi_fine", "depth", "slope_per", "smtfinal", "BEN_N_C", "DETFLUX3_C", "OM_CAL3_C", "OXY_C", "PBO_C", "SO_C", "SFR_OARG_C"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["random_forest", "gamboost", "xgboost"]
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

- Dataset ID: `paper_coral_bathypathes`
- Dataset name: Climate change effects on deep-water corals - habitat suitability model input data
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Predicting the effects of climate change on deep-water coral distribution around New Zealand-Will there be suitable refuges for protection at the end of the 21st century?
- Paper DOI: 10.1111/gcb.16389
- Dataset DOI: 10.5061/dryad.41ns1rnht
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.41ns1rnht
- Year: 2022 (annee de depot Dryad/DataCite, non verifiee comme annee de publication de l'article -- voir Reference publication)

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C [Random Forests + Boosted Regression Trees ensemble SDM]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Anderson, Stephenson, Behrens & Rowden (2022), Global Change Biology, DOI 10.1111/gcb.16389; README.txt Dryad (dataset 10.5061/dryad.41ns1rnht) documente colonne-par-colonne les 12 fichiers presence/absence par taxon (lat, lon, pa, puis les variables environnementales). Le README documente 12 variables nommees explicitement ; le CSV reel en contient 14 (sand et PBO_C en plus, non fabriquees, presentes telles quelles dans le fichier telecharge). Estimateurs de reference fixes le 2026-08-15 sur random_forest/random_forest_spatial (deja disponibles dans le package spatialtidymodels), memes 12 taxons du meme depot."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "classification_binary_presence_absence"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Bloc estimator_eligibility complete le 2026-09-08. Meme papier/methodologie que les 11 autres coraux du meme depot (DOI 10.1111/gcb.16389, dataset DOI 10.5061/dryad.41ns1rnht) deja resolus (Random Forest + Boosted Regression Trees documentes dans les fiches soeurs) -- N plus petit ici (390, specimens museaux via GBIF) mais meme formule (pa ~ memes covariables) et meme papier. Ancien blocage 'current_package_regression_only' resolu a la source (bug du script d'export, corrige le 2026-09-08)."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Bloc estimator_eligibility complete le 2026-09-08. Meme papier/methodologie que les 11 autres coraux du meme depot (DOI 10.1111/gcb.16389, dataset DOI 10.5061/dryad.41ns1rnht) deja resolus (Random Forest + Boosted Regression Trees documentes dans les fiches soeurs) -- N plus petit ici (390, specimens museaux via GBIF) mais meme formule (pa ~ memes covariables) et meme papier. Ancien blocage 'current_package_regression_only' resolu a la source (bug du script d'export, corrige le 2026-09-08).

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready"
  eligible_estimators:
    - estimator: ols
      basis: generated_candidate
      source_ref: "Routage binaire ajoute au harnais cette semaine (glm(family=binomial()))."
      notes: "Meme papier que les 11 autres fiches coral_* (DOI 10.1111/gcb.16389) -- eligibilite basee sur la capacite technique du harnais."
    - estimator: gam_spatial
      basis: generated_candidate
      source_ref: "Routage binaire ajoute au harnais cette semaine (mgcv::gam(family=binomial()))."
      notes: "Capacite technique du harnais, coherent avec le reste de la famille coral_*."
    - estimator: random_forest
      basis: published_model
      source_ref: "Fiches soeurs coral_* (meme DOI 10.1111/gcb.16389) : \"Modeles de suitabilite d'habitat (HSM) pour coraux profonds en Nouvelle-Zelande avec Random Forests et Boosted Regression Trees\"."
      notes: "Random Forest est la methode publiee pour cette famille de donnees (meme etude, espece differente, N plus petit car specimens museaux)."
    - estimator: xgboost
      basis: published_model
      source_ref: "Fiches soeurs coral_* mentionnent des Boosted Regression Trees (BRT) -- xgboost est l'estimateur boosting le plus proche disponible."
      notes: "Analogue a la methode BRT documentee pour cette famille de donnees, sans etre l'implementation exacte des auteurs."
    - estimator: sar_probit
      basis: generated_candidate
      source_ref: "Nouvel estimateur ajoute cette semaine pour reponse binaire (ProbitSpatial, DGP=SAR)."
      notes: "Capacite technique du harnais."
    - estimator: sem_probit
      basis: generated_candidate
      source_ref: "Nouvel estimateur ajoute cette semaine pour reponse binaire (ProbitSpatial, DGP=SEM)."
      notes: "Capacite technique du harnais."
  conditionally_eligible_estimators: []
  ineligible_reason: "Bloc estimator_eligibility complete le 2026-09-08. Meme papier/methodologie que les 11 autres coraux du meme depot (DOI 10.1111/gcb.16389, dataset DOI 10.5061/dryad.41ns1rnht) deja resolus (Random Forest + Boosted Regression Trees documentes dans les fiches soeurs) -- N plus petit ici (390, specimens museaux via GBIF) mais meme formule (pa ~ memes covariables) et meme papier. Ancien blocage 'current_package_regression_only' resolu a la source (bug du script d'export, corrige le 2026-09-08)."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 390
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
- Spatial extent: x [-179.996833, 179.961167], y [-53.7384167, -28.7049999]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=360deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- Reproducibility status: OK - loader R enregistre et reexecutable (`coral_bathypathes` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `coral_bathypathes` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`coral_bathypathes` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Predicting the effects of climate change on deep-water coral distribution around New Zealand-Will there be suitable refuges for protection at the end of the 21st century?

## Curation documentée — 2026-09-07

Decision conservatoire : Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : binary. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
