---
title: Python_geodatasets_spdata.nydata
type: dataset
created: 2026-08-15
updated: 2026-09-07
sources:
  - data/final_datasets/sf/Python_geodatasets_spdata.nydata.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`nydata`).

## Description du jeu de donnees

- Topic: Donnees de python-package : Python_geodatasets_spdata.nydata
- Observation unit: observation spatiale de type POINT
- Observed population: 281 enregistrements dans l’artefact local Python_geodatasets_spdata.nydata.rds; unite declaree : observation spatiale de type POINT. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: Etendue mesuree dans le RDS : x [-79.489382167001, -79.489369768719], y [0.0003791993086784, 0.0003908593749902]; CRS EPSG:4326.
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`nydata`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `TRACTCAS`, `PROPCAS`, `Z`
- Candidate Y typology: continuous, rate
- Candidate X variables: `POP8`, `PCTOWNHOME`, `PCTAGE65P`, `AVGIDIST`, `PEXPOSURE`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `AREAKEY`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `TRACTCAS` | `numeric` | continuous | [0, 9.29] | 0% |
| `PROPCAS` | `numeric` | rate | [0, 0.007] | 0% |
| `Z` | `numeric` | continuous | [-1.9206, 4.7105] | 0% |


> Selection Y/X (claude-sonnet-4-6) : TRACTCAS (nombre de cas par tract), PROPCAS (proportion de cas) et Z (vraisemblablement un score standardisé de cas, typique du dataset NY leukemia) sont des cibles épidémiologiques naturelles. POP8, PCTOWNHOME, PCTAGE65P, AVGIDIST et PEXPOSURE sont des covariables explicatives classiques (démographie, statut résidentiel, structure d'âge, distance inverse moyenne à une source, exposition estimée). AREANAME est un libellé géographique ignoré.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `POP8` | `numeric` | continuous | 0% |
| `PCTOWNHOME` | `numeric` | rate | 0% |
| `PCTAGE65P` | `numeric` | rate | 0% |
| `AVGIDIST` | `numeric` | continuous | 0% |
| `PEXPOSURE` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: Cases ~ PEXPOSURE + PCTAGE65P + PCTOWNHOME + offset(log(POP8))
- x_terms_pub: PEXPOSURE, PCTAGE65P, PCTOWNHOME
- y_term_pub: Cases (TRACTCAS dans cet artefact)
- Reference publication: Waller, L. and C. Gotway (2004) Applied Spatial Statistics for Public Health Data, Ch. 9, Wiley. Formule confirmee par reproduction dans Bivand, Pebesma & Gomez-Rubio (2008) Applied Spatial Data Analysis with R (coefficients rapportes : PEXPOSURE 0.153, PCTOWNHOME -0.359, PCTAGE65P 4.050). Meme jeu de donnees que [[R_spData_nydata_nydata]] (colonnes identiques verifiees le 2026-09-08 : AREAKEY, AREANAME, AVGIDIST, PCTAGE65P, PCTOWNHOME, PEXPOSURE, POP8, PROPCAS, TRACTCAS, N=281). Note : formula_used ci-dessous differe legerement de ce modele publie (specification executable distincte utilisant TRACTCAS directement plutot que l'offset log-Poisson, et incluant AVGIDIST) -- deja en place avant cette correction, non modifiee ici.

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: TRACTCAS ~ POP8 + PCTOWNHOME + PCTAGE65P + AVGIDIST + PEXPOSURE
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: POP8 + PCTOWNHOME + PCTAGE65P + AVGIDIST + PEXPOSURE
- y_term_used: TRACTCAS

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
    formula: "TRACTCAS ~ POP8 + PCTOWNHOME + PCTAGE65P + AVGIDIST + PEXPOSURE"
    response: "TRACTCAS"
    predictors: ["POP8", "PCTOWNHOME", "PCTAGE65P", "AVGIDIST", "PEXPOSURE"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_spdata.nydata`
- Dataset name: geodatasets::nydata
- Source family: python-package
- Source: package Python `geodatasets`
- Source URL: https://pypi.org/project/geodatasets/
- Dataset DOI: none
- Publication DOI: pending
- Year: 2023

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "TRACTCAS ~ POP8 + PCTOWNHOME + PCTAGE65P + AVGIDIST + PEXPOSURE"
  equation_family: regression_candidate
  model_family: "regression_candidate"
  source_type: generated_system_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 281
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-79.4894, -79.4894], y [0.0004, 0.0004] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32617 (UTM Zone 17N (EPSG:32617)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

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
      basis: scientific_evidence
      source_ref: "Waller, L. and Gotway, C. (2004) Applied Spatial Statistics for Public Health Data, Ch. 9, Wiley ; coefficients reproduits par Bivand, Pebesma & Gomez-Rubio (2008)."
      notes: "Formule Cases ~ PEXPOSURE+PCTAGE65P+PCTOWNHOME+offset(log(POP8)) avec coefficients exacts rapportes (PEXPOSURE 0.153, PCTOWNHOME -0.359, PCTAGE65P 4.050) -- preuve la plus forte du lot, deux sources convergentes."
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
- Missing values: WARN - variables avec NA > 20% : AREANAME (NA=29.5%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`

## Curation documentée — 2026-09-07

Decision conservatoire : Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
