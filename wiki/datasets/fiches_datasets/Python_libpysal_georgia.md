---
title: Python_libpysal_georgia
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/Python_libpysal_georgia.rds
  - data/final_datasets/sf/R_GWmodel_GeorgiaCounties_Gedu.counties.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `libpysal` (`georgia`).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
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

- formula_pub: PctBach~PctRural+PctFB+PctBlack+PctEld
- x_terms_pub: PctRural+PctFB+PctBlack+PctEld
- y_term_pub: PctBach
- Reference publication: Fotheringham, Brunsdon & Charlton (2002), Wiley

### Statut regression canonique

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: GWR
- Correspondance Python/R: R_GWmodel_GeorgiaCounties_Gedu.counties
- Note: Formule identifiee via la documentation du package equivalent `R_GWmodel_GeorgiaCounties_Gedu.counties` -- meme jeu de donnees sous-jacent (propagation automatique Tache 3, a confirmer par revue manuelle).

### Formule — niveau systeme

- formula_used: PctBach ~ PctRural + PctFB + PctBlack + PctEld
- x_terms_used: PctRural + PctFB + PctBlack + PctEld
- y_term_used: PctBach

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
  equation_text: PctBach ~ PctRural + PctFB + PctBlack + PctEld
  equation_family: regression
  model_family: published_or_manual_regression
  source_type: published_or_manual_formula
  source_ref: data/manifests/datasets/proposed_formula_used_audit.csv
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
- Type de geometrie: POINT
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

## Fusion des sources et variantes

Cette fiche est la fiche canonique du cas d'etude Georgia. Elle fusionne la source Python `libpysal::georgia` et la source R `GWmodel::GeorgiaCounties / Gedu.counties`, toutes deux utilisees pour des exemples de regression spatiale et de GWR.

### Sources fusionnees

| Ancienne fiche | Source package | Objet source | Artefact local | Role |
|---|---|---|---|---|
| `Python_libpysal_georgia` | libpysal | `georgia` | `data/final_datasets/sf/Python_libpysal_georgia.rds` | fiche canonique conservee |
| `R_GWmodel_GeorgiaCounties_Gedu.counties` | GWmodel | `Gedu.counties` | `data/final_datasets/sf/R_GWmodel_GeorgiaCounties_Gedu.counties.rds` | source R integree puis retiree comme fiche separee |

### Elements communs

- Meme territoire: comtes de Georgia.
- Meme famille d'usage: modelisation socio-demographique spatiale et GWR.
- Meme reponse de benchmark actuelle: `PctBach`.

### Elements non communs

- La source R `GWmodel` est directement liee aux exemples GWR.
- La source Python `libpysal` facilite les usages PySAL et libpysal.

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: FUSED - fiche commune pour `Python_libpysal_georgia` et `R_GWmodel_GeorgiaCounties_Gedu.counties`.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `libpysal`
