---
title: paper_coral_madrepora
type: dataset
created: 2026-09-14
updated: 2026-09-17
sources:
  - data/final_datasets/sf/paper_coral_madrepora.rds
  - DataCite_2022_PredictingTheEffectsOf_10_1111_gcb_1638
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Predicting the effects of climate change on deep-water coral distribution around New Zealand-Will there be suitable refuges for protection at the end of the 21st century?" (DOI 10.1111/gcb.16389).

## Description du jeu de donnees

- Topic: Donnees de paper-derived : paper_coral_madrepora
- Observation unit: observation spatiale du dataset "Climate change effects on deep-water corals - habitat suitability model input data"
- Observed population: Modèles de suitabilité d'habitat (HSM) pour coraux profonds en Nouvelle-Zélande avec Random Forests et Boosted Regression Trees ; prédictions spatiales sous changement climatique ; correspond au périmètre spatial random forest / boosting spatial / climate / biodiversity / spatial prediction
- Geographic context: etendue sf: x [-179.9999165, 179.988083], y [-56.3349991, -24.766701]
- Temporal context: none (cross-sectional)
- Source description: Predicting the effects of climate change on deep-water coral distribution around New Zealand-Will there be suitable refuges for protection at the end of the 21st century?
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/gcb.16389
- Dataset DOI: 10.5061/dryad.41ns1rnht
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.41ns1rnht
- Local raw dir: `data/raw/papers/DataCite_2022_PredictingTheEffectsOf_10_1111_gcb_1638/`
- Local sf output: `data/final_datasets/sf/paper_coral_madrepora.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `pa`
- Candidate Y typology: binary
- Candidate X variables in local artifact: `carbonate`, `mud`, `sand`, `bpi_fine`, `depth`, `slope_per`, `smtfinal`, `BEN_N_C`, `DETFLUX3_C`, `OXY_C`, `PBO_C`, `SFR_OARG_C`, `SO_C`, `OM_CAL3_C`
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

> Selection Y/X (paper-loader / curated evidence) : Pour `coral_madrepora`, la ou les reponses `pa` viennent du loader papier et/ou des preuves de l article `Predicting the effects of climate change on deep-water coral distribution around New Zealand-Will there be suitable refuges for protection at the end of the 21st century?`. Les covariables X retenues sont `carbonate`, `mud`, `sand`, `bpi_fine`, `depth`, `slope_per`, `smtfinal`, `BEN_N_C`, `DETFLUX3_C`, `OM_CAL3_C`, `OXY_C`, `PBO_C`, `SO_C`, `SFR_OARG_C`. Les coordonnees (`lon`, `lat`), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : manual_review; la promotion package reste conditionnee au bloc benchmark_readiness.

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
| `OXY_C` | `numeric` | continuous | 0% |
| `PBO_C` | `numeric` | continuous | 0% |
| `SFR_OARG_C` | `numeric` | continuous | 0% |
| `SO_C` | `numeric` | continuous | 0% |
| `OM_CAL3_C` | `numeric` | continuous | 1.6% |

### Formule - niveau publication

- formula_pub: pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C [Random Forests + Boosted Regression Trees ensemble SDM]
- x_terms_pub: carbonate, mud, sand, bpi_fine, depth, slope_per, smtfinal, BEN_N_C, DETFLUX3_C, OM_CAL3_C, OXY_C, PBO_C, SO_C, SFR_OARG_C
- y_term_pub: pa
- Reference publication: CORRECTION 2026-09-14 (etendue depuis coral_bathypathes, meme depot Dryad/meme papier, formule verifiee independamment) : Anderson, Stephenson, Behrens & Rowden (2022), Global Change Biology, DOI 10.1111/gcb.16389; README.txt Dryad (dataset 10.5061/dryad.41ns1rnht) documente colonne-par-colonne les 12 fichiers presence/absence par taxon (lat, lon, pa, puis les variables environnementales) -- madrepora est l'un de ces 12 taxons, memes 14 covariables confirmees presentes dans l'artefact local (Candidate X count=14, identique a coral_bathypathes). Estimateurs de reference fixes le 2026-08-15 sur random_forest/random_forest_spatial (deja disponibles dans le package spatialtidymodels).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

### Formule - niveau systeme

- formula_used: pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OXY_C + PBO_C + SFR_OARG_C + SO_C + OM_CAL3_C
- License evidence: DataCite API record for DOI 10.5061/dryad.41ns1rnht (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Formula used evidence: generated_system_formula
- x_terms_used: carbonate, mud, sand, bpi_fine, depth, slope_per, smtfinal, BEN_N_C, DETFLUX3_C, OXY_C, PBO_C, SFR_OARG_C, SO_C, OM_CAL3_C
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

- Dataset ID: `paper_coral_madrepora`
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
  source_ref: "CORRECTION 2026-09-14 (etendue depuis coral_bathypathes, meme depot Dryad/meme papier, formule verifiee independamment) : Anderson, Stephenson, Behrens & Rowden (2022), Global Change Biology, DOI 10.1111/gcb.16389; README.txt Dryad (dataset 10.5061/dryad.41ns1rnht) documente colonne-par-colonne les 12 fichiers presence/absence par taxon (lat, lon, pa, puis les variables environnementales) -- madrepora est l'un de ces 12 taxons, memes 14 covariables confirmees presentes dans l'artefact local (Candidate X count=14, identique a coral_bathypathes). Estimateurs de reference fixes le 2026-08-15 sur random_forest/random_forest_spatial (deja disponibles dans le package spatialtidymodels)."
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
  reason: "Promu le 2026-09-17 : Anderson, Stephenson, Behrens & Rowden (2022), Global Change Biology, DOI 10.1111/gcb.16389 -- reponse `pa` (presence/absence, binaire), 14 covariables confirmees identiques au README Dryad (10.5061/dryad.41ns1rnht), random_forest et xgboost documentes comme methode reellement publiee (basis: published_model, voir Estimator eligibility). L'ancien blocage 'current_package_regression_only' etait un bug du script d'export (code/package_metadata/export_spatialtidymodels_metadata.py, verification textuelle codee en dur sur benchmark_task contenant 'classification'/'presence_absence', deja corrige a la source -- voir Estimator eligibility.ineligible_reason). Toutes les conditions de promotion (reponse defendable, covariables, support spatial, preuve de modele publie, artefact local) sont reunies."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Promu le 2026-09-17 : Anderson, Stephenson, Behrens & Rowden (2022), Global Change Biology, DOI 10.1111/gcb.16389 -- reponse `pa` (presence/absence, binaire), 14 covariables confirmees identiques au README Dryad (10.5061/dryad.41ns1rnht), random_forest et xgboost documentes comme methode reellement publiee (basis: published_model, voir Estimator eligibility). L'ancien blocage 'current_package_regression_only' etait un bug du script d'export (code/package_metadata/export_spatialtidymodels_metadata.py, verification textuelle codee en dur sur benchmark_task contenant 'classification'/'presence_absence', deja corrige a la source -- voir Estimator eligibility.ineligible_reason). Toutes les conditions de promotion (reponse defendable, covariables, support spatial, preuve de modele publie, artefact local) sont reunies.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready"
  eligible_estimators:
    - estimator: ols
      basis: generated_candidate
      source_ref: "Routage binaire/comptage ajoute au harnais cette semaine (glm(family=binomial()) sous le nom ols) ; verifie par la suite de tests du package."
      notes: "Regression (famille binomiale) generique pour reponse binaire. CORRECTION 2026-09-14 : formula_pub desormais confirme (meme papier/formule que coral_bathypathes, Anderson et al. 2022, DOI 10.1111/gcb.16389) -- ols reste un candidat generique technique, pas la methode publiee (RF/BRT)."
    - estimator: gam_spatial
      basis: generated_candidate
      source_ref: "Routage binaire ajoute au harnais cette semaine (mgcv::gam(family=binomial()))."
      notes: "GAM (famille binomiale), baseline generique pour reponse binaire. Meme correction 2026-09-14 : formula_pub desormais confirme, gam_spatial reste un candidat generique technique, pas la methode publiee (RF/BRT)."
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
- N observations: 496
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
- Spatial extent: x [-179.9999165, 179.988083], y [-56.3349991, -24.766701]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending — etendue continentale/mondiale (span=360deg) -- projection nationale non pertinente ; privilegier une projection equal-area continentale ou mondiale (ex: Albers equal-area continental, Behrmann/Mollweide pour une couverture mondiale)

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- Reproducibility status: OK - loader R enregistre et reexecutable (`coral_madrepora` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `coral_madrepora` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`coral_madrepora` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Predicting the effects of climate change on deep-water coral distribution around New Zealand-Will there be suitable refuges for protection at the end of the 21st century?

## Curation documentée — 2026-09-07

La formule systeme enumere les 14 covariables deja declarees dans Candidate X variables et presentes dans le RDS. L’ancienne ellipse etait un defaut du rendu; cette liste demeure une proposition systeme, sans preuve de specification publiee et sans promotion. Sa pertinence scientifique reste en revue.

Decision conservatoire : Ancienne declaration yes incoherente avec les conditions du registre : current_package_regression_only. Conserver la décision actuelle jusqu’au traitement des constats. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
