---
title: Python_libpysal_georgia
type: dataset
created: 2026-08-15
updated: 2026-09-16
sources:
  - data/final_datasets/sf/Python_libpysal_georgia.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `libpysal` (`georgia`).

## Description du jeu de donnees

- Topic: Donnees de python-package : Python_libpysal_georgia
- Observation unit: observation spatiale de type POINT
- Observed population: 159 enregistrements dans l’artefact local Python_libpysal_georgia.rds; unite declaree : administrative or school-related spatial unit. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: Etendue mesuree dans le RDS : x [-91.489509967779, -91.489470235928], y [0.0002770273345197, 0.000314684180655]; CRS EPSG:4326.
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `libpysal` (`georgia`).
- Description source: package Python `libpysal`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `PctPov`, `PctBach`, `PctBlack`
- Candidate Y typology: continuous
- Candidate X variables: `AREA`, `PERIMETER`, `TotPop90`, `PctRural`, `PctEld`, `PctFB`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `Latitude`, `X`, `Y`
- Identifier columns (excluded from X candidates): `G_UTM_ID`, `AreaKey`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PctPov` | `numeric` | continuous | [2.6, 35.9] | 0% |
| `PctBach` | `numeric` | continuous | [4.2, 37.5] | 0% |
| `PctBlack` | `numeric` | continuous | [0, 79.64] | 0% |


> Selection Y/X (claude-sonnet-4-6) : PctPov (taux de pauvreté), PctBach (niveau d'éducation) et PctBlack (composition démographique) sont des variables socio-économiques classiquement modélisées comme réponses dans des études de géographie humaine. Les covariables retenues capturent la taille (AREA, PERIMETER), la population (TotPop90), le caractère rural (PctRural), la structure par âge (PctEld) et l'immigration (PctFB) ; G_UTM_ semble être un identifiant interne et Longitud une coordonnée redondante, tous deux exclus.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `AREA` | `numeric` | continuous | 0% |
| `PERIMETER` | `numeric` | continuous | 0% |
| `TotPop90` | `integer` | count | 0% |
| `PctRural` | `numeric` | continuous | 0% |
| `PctEld` | `numeric` | continuous | 0% |
| `PctFB` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: PctBach ~ PctRural + PctEld + PctFB + PctPov
- x_terms_pub: PctRural, PctEld, PctFB, PctPov
- y_term_pub: PctBach
- Reference publication: GWmodel, documentation primaire gwr.bootstrap, Examples, manuel CRAN p.46 : https://stat.ethz.ch/CRAN/web/packages/GWmodel/GWmodel.pdf (consulte le 2026-09-07).

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: R_GWmodel_GeorgiaCounties_Gedu.counties
- Note: n/a

### Formule — niveau systeme

- formula_used: PctBach ~ PctRural + PctEld + PctFB + PctPov
- Formula used evidence: pub
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: PctRural + PctEld + PctFB + PctPov
- y_term_used: PctBach
- Note (2026-09-07) : la formule systeme substituait auparavant PctBlack (composition demographique) a PctPov (taux de pauvrete) sans justification technique documentee -- PctPov est present sans donnee manquante dans le jeu. Alignee sur formula_pub pour eviter d'utiliser une variable de composition raciale comme covariable sans justification scientifique explicite, dans la meme logique que la controverse de la variable "B" du jeu Boston Housing documentee dans la revue des jeux de benchmark. Verifier si des resultats de benchmark deja publies (rapport de stage, slides) citaient l'ancienne formule avant de les reutiliser.

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
    formula: "PctBach ~ PctRural + PctFB + PctBlack + PctEld"
    response: "PctBach"
    predictors: ["PctRural", "PctFB", "PctBlack", "PctEld"]
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

- Dataset ID: `Python_libpysal_georgia`
- Dataset name: libpysal::georgia
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
  equation_text: "PctBach ~ PctRural + PctFB + PctBlack + PctEld"
  equation_family: regression
  model_family: "regression"
  source_type: published_or_manual_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 159
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-91.4895, -91.4895], y [0.0003, 0.0003] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT (source native : MULTIPOLYGON, preservee dans `geom_origine` ; geometrie active derivee via `st_point_on_surface()` ou equivalent, methodologie documentee dans code/r_catalog/guide_objets_sf.md section 3-5 -- rien n'est perdu, correction 2026-09-16 apres verification via tools/verify_fiche_crs.py)
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32615 (UTM Zone 15N (EPSG:32615)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

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
  missing_items: "aucun blocage automatique detecte; conserver la trace de validation dans data/manifests/datasets/package_generated_formula_validation_2026-08.csv"
  reason: "Formule generee par le systeme mais validee contre le .rds local: reponse numerique, covariables presentes, model.frame executable et effectif suffisant."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte; conserver la trace de validation dans data/manifests/datasets/package_generated_formula_validation_2026-08.csv
- Raison: Formule generee par le systeme mais validee contre le .rds local: reponse numerique, covariables presentes, model.frame executable et effectif suffisant.

## Estimator eligibility

```yaml
estimator_eligibility:
  - estimator: ols
    basis: benchmark_use
    source_ref: "Georgia education example, libpysal/GWmodel."
    notes: "Continuous spatial education dataset with projected coordinates."
  - estimator: gam_spatial
    basis: benchmark_use
    source_ref: "Georgia education example, libpysal/GWmodel."
    notes: "Useful for testing smooth spatial baseline models."
  - estimator: mgwrsar_gwr
    basis: benchmark_use
    source_ref: "Georgia education example, libpysal/GWmodel."
    notes: "Useful for testing geographically weighted regression routes."
  - estimator: mgwrsar_mgwr
    basis: benchmark_use
    source_ref: "Georgia education example, libpysal/GWmodel."
    notes: "Useful for testing multiscale geographically weighted regression routes."
```


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: WARN - groupe de versions suspectes `georgia`; autres versions: R_GWmodel_Georgia_Gedu.df, R_spgwr_georgia_gSRDF
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `libpysal`
- Duplicate/version candidate: [[R_GWmodel_Georgia_Gedu.df]]
- Duplicate/version candidate: [[R_spgwr_georgia_gSRDF]]

## Curation documentée — 2026-09-07

L’exemple primaire de GWmodel est conserve dans formula_pub. La formule actuelle de l’alias remplace PctPov par PctBlack; l’equivalence exacte n’est pas attestee. formula_used est conservee et explicitement classee comme variante systeme, sans attribuer ce choix au papier. Aucune promotion effectuee.

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
