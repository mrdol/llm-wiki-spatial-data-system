---
title: Python_libpysal_Baltimore
type: dataset
created: 2026-08-15
updated: 2026-09-18
sources:
  - data/final_datasets/sf/Python_libpysal_Baltimore.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `libpysal` (`Baltimore`).

## Description du jeu de donnees

- Topic: Donnees de python-package : Python_libpysal_Baltimore
- Observation unit: observation spatiale de type POINT
- Observed population: 211 enregistrements dans l’artefact local Python_libpysal_Baltimore.rds; unite declaree : observation spatiale de type POINT. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: Etendue mesuree dans le RDS : x [860, 987.5], y [505.5, 581]; CRS non renseigne, repere/unites a documenter (corrige le 2026-09-18 -- l'ancien bbox [-40,87.5]/[-41,34.5] et l'etiquette WGS84 venaient d'une fausse detection de CRS geographique, voir Bloc 5 > CRS note).
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `libpysal` (`Baltimore`).
- Description source: package Python `libpysal`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `PRICE`
- Candidate Y typology: continuous
- Candidate X variables: `NROOM`, `DWELL`, `NBATH`, `PATIO`, `FIREPL`, `AC`, `BMENT`, `NSTOR`, `GAR`, `AGE`, `CITCOU`, `LOTSZ`, `SQFT`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PRICE` | `numeric` | continuous | [3.5, 165] | 0% |


> Selection Y/X (claude-sonnet-4-6) : PRICE (prix immobilier, variable continue) est la cible naturelle d'un modèle hédonique de prix de logement. Toutes les autres colonnes décrivent des caractéristiques structurelles ou locatives du bien (surface, nombre de pièces, équipements, âge, etc.) et constituent des covariables explicatives classiques. STATION est ignoré car il s'agit vraisemblablement d'un identifiant de station/observation sans valeur explicative intrinsèque.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `NROOM` | `numeric` | continuous | 0% |
| `DWELL` | `numeric` | binary | 0% |
| `NBATH` | `numeric` | continuous | 0% |
| `PATIO` | `numeric` | binary | 0% |
| `FIREPL` | `numeric` | binary | 0% |
| `AC` | `numeric` | binary | 0% |
| `BMENT` | `numeric` | continuous | 0% |
| `NSTOR` | `numeric` | continuous | 0% |
| `GAR` | `numeric` | continuous | 0% |
| `AGE` | `numeric` | continuous | 0% |
| `CITCOU` | `numeric` | binary | 0% |
| `LOTSZ` | `numeric` | continuous | 0% |
| `SQFT` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: PRICE ~ NROOM + NBATH + PATIO + FIREPL + AC + GAR + AGE + LOTSZ + SQFT
- x_terms_pub: NROOM, NBATH, PATIO, FIREPL, AC, GAR, AGE, LOTSZ, SQFT
- y_term_pub: PRICE
- Reference publication: Dubin, Robin A. (1992). Spatial autocorrelation and neighborhood quality. Regional Science and Urban Economics 22(3), 433-452. NOTE (confiance moyenne) : formule hedonique standard reproduite par les packages derives de ce jeu de donnees (hspm/spregimes) ; texte original de Dubin non accessible (paywall) pour verifier exactement la liste de covariables/forme fonctionnelle. Meme jeu de donnees que [[R_spData_baltimore_baltimore]] (colonnes identiques verifiees le 2026-09-08 : AC, AGE, BMENT, CITCOU, DWELL, FIREPL, GAR, LOTSZ, NBATH, NROOM, NSTOR, PATIO, PRICE, SQFT, STATION, N=211) ; formula_used ci-dessous correspond deja exactement a ce modele.

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: PRICE ~ NROOM + NBATH + PATIO + FIREPL + AC + GAR + AGE + LOTSZ + SQFT
- CRS note: Corrige le 2026-09-18 : le .rds portait auparavant une etiquette CRS WGS84 (EPSG:4326) fausse, heritee d'un defaut de lecture GeoJSON sans CRS declare ; les coordonnees brutes (x~860-987, y~505-581) sont en realite dans le meme systeme local que R_spData_baltimore_baltimore (bbox identique), documente par CRAN spData::baltimore et GeoDa comme 'X,Y on Maryland grid, projection type unknown' -- aucun EPSG ne peut etre invente. Le pipeline (code/r_catalog/build_sf_datasets.R, CRS_OVERRIDES) efface desormais explicitement cette fausse etiquette (st_set_crs(NA)) au lieu de la laisser filer. Avant correction, le 'CRS analyse recommande' affichait a tort 'multi-zones (span=127.5deg) -- projection nationale recommandee', un artefact du bbox corrompu.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: NROOM + NBATH + PATIO + FIREPL + AC + GAR + AGE + LOTSZ + SQFT
- y_term_used: PRICE

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
    formula: "PRICE ~ NROOM + NBATH + PATIO + FIREPL + AC + GAR + AGE + LOTSZ + SQFT"
    response: "PRICE"
    predictors: ["NROOM", "NBATH", "PATIO", "FIREPL", "AC", "GAR", "AGE", "LOTSZ", "SQFT"]
    role: "paper_main_specification"
    source_type: "published_or_manual_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
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

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_libpysal_Baltimore`
- Dataset name: libpysal::Baltimore
- Source family: python-package
- Source: package Python `libpysal`
- Source URL: https://pypi.org/project/libpysal/
- Dataset DOI: none
- Publication DOI: pending
- Year: 2017

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "PRICE ~ NROOM + NBATH + PATIO + FIREPL + AC + GAR + AGE + LOTSZ + SQFT"
  equation_family: regression
  model_family: "regression"
  source_type: published_or_manual_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 211
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [860, 987.5], y [505.5, 581] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/libpysal/
- License open: yes
- Reproducibility status: available via package Python `libpysal`
- Code available: yes (package examples and vignettes)
- Repository: python-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_spatial_validated_generated_formula"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Formule generee par le systeme mais validee contre le .rds local: reponse numerique, covariables presentes, model.frame executable et effectif suffisant. formula_pub egalement documente le 2026-09-08 par correspondance avec le jeu homologue du package R (colonnes identiques verifiees). Bloc estimator_eligibility complete le 2026-09-08 -- resout l'incoherence 'estimator_eligibility_block_missing' qui avait motive la retrogradation du 2026-09-07."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Formule generee par le systeme mais validee contre le .rds local: reponse numerique, covariables presentes, model.frame executable et effectif suffisant. formula_pub egalement documente le 2026-09-08 par correspondance avec le jeu homologue du package R (colonnes identiques verifiees). Bloc estimator_eligibility complete le 2026-09-08 -- resout l'incoherence 'estimator_eligibility_block_missing' qui avait motive la retrogradation du 2026-09-07.


## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators:
    - estimator: ols
      basis: published_model
      source_ref: "Dubin, Robin A. (1992). Regional Science and Urban Economics 22(3), 433-452 (confiance moyenne, texte original paywall)."
      notes: "Formule hedonique PRICE ~ NROOM+NBATH+PATIO+FIREPL+AC+GAR+AGE+LOTSZ+SQFT reproduite par les packages derives (hspm/spregimes) ; confiance moyenne car texte source non verifie directement."
  conditionally_eligible_estimators: []
  ineligible_reason: "Bloc estimator_eligibility complete le 2026-09-08 (etait vide/placeholder depuis l'audit du 2026-09-07, incoherence 'estimator_eligibility_block_missing'). 1 estimateur(s) documente(s) sans invention, bases exclusivement sur le texte deja present dans 'Reference publication'/'formula_pub' de cette fiche."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: WARN - doublon exact detecte et version retenue; doublons ecartes: Python_libpysal_baltim
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `libpysal`
- Duplicate/version candidate: [[Python_libpysal_baltim]]

## Curation documentée — 2026-09-07

Decision conservatoire : Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

## Curation documentée — 2026-09-18

Correction CRS (2026-09-18) : le pipeline de construction sf (code/r_catalog/build_sf_datasets.R) etiquetait a tort ce jeu en WGS84 (EPSG:4326) alors que ses coordonnees sont dans un systeme local inconnu ('Maryland grid, projection type unknown' -- CRAN spData::baltimore, doc GeoDa). Confirme par comparaison directe avec le jumeau R_spData_baltimore_baltimore.rds (memes 211 lignes, memes colonnes STATION/PRICE/..., bbox x[860,987.5] y[505.5,581] identique, et CRS correctement NA cote R). Le bbox precedemment affiche dans cette fiche (x[-40,87.5], y[-41,34.5]) provenait de cette fausse etiquette appliquee aux memes coordonnees brutes. Correction : CRS_OVERRIDES efface desormais explicitement l'etiquette (au lieu de ne rien faire), et cette correction s'applique maintenant avant toute derivation geometrique. Aucun EPSG n'est invente : le CRS reste documente comme inconnu, conformement a la source.
