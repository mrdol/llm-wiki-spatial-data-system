---
title: Python_libpysal_chicagoSDOH
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/Python_libpysal_chicagoSDOH.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `libpysal` (`chicagoSDOH`).

## Description du jeu de donnees

- Topic: socio-demographie territoriale
- Observation unit: unite de recensement ou unite administrative
- Observed population: population territoriale documentee par le package source
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `libpysal` (`chicagoSDOH`).
- Description source: package Python `libpysal`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `YPLL_rate`, `YEARS_LOST`, `PCRIMERT15`, `VCRIMERT15`, `COI_ct`, `HIS_ct`, `ForclRt`, `FORCLRISK`, `HealthLit`, `CmTm14`, `MEANMI_14`
- Candidate Y typology: continuous, count, rate
- Candidate X variables: `PDENS14`, `CarC14P`, `CTA14P`, `Undr514P`, `Wht14P`, `Blk14P`, `Hisp14P`, `Pop2014`, `FACHANGE`, `EP_PCI`, `EP_MUNIT`, `EP_GROUPQ`, `SSWS2USE`, `SchHP_Mi`, `BrownF_Mi`, `MEANMI_07`, `MEANMI_11`, `EP_MINRTY`, `Ovr6514P`, `EP_AGE17`, `EP_DISABL`, `EP_NOHSDP`, `EP_LIMENG`, `EP_SNGPNT`, `Pov14`, `PerCap14`, `Unemp14`, `EP_UNINSUR`, `EP_CROWD`, `EP_NOVEH`, `ChldPvt14`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `COORD_X`, `COORD_Y`, `X`, `Y`
- Identifier columns (excluded from X candidates): `ID`, `OBJECTID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `YPLL_rate` | `numeric` | continuous | [95.1518, 28970.9762] | 0% |
| `YEARS_LOST` | `integer` | count | [11, 3279] | 0% |
| `PCRIMERT15` | `numeric` | rate | [0.0036, 0.2847] | 0% |
| `VCRIMERT15` | `numeric` | rate | [0.0019, 0.1505] | 0% |
| `COI_ct` | `numeric` | continuous | [-1.5435, 0.9948] | 0% |
| `HIS_ct` | `numeric` | continuous | [6.7075, 75.0689] | 0% |
| `ForclRt` | `numeric` | continuous | [0, 33.33] | 0% |
| `FORCLRISK` | `numeric` | continuous | [0.2, 100] | 0% |
| `HealthLit` | `numeric` | continuous | [125.865, 271.895] | 0% |
| `CmTm14` | `numeric` | continuous | [13.7, 58.3] | 0% |
| `MEANMI_14` | `numeric` | continuous | [0.1057, 3.1174] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables Y candidates regroupent des indicateurs de santé publique (YPLL_rate, YEARS_LOST), de criminalité (PCRIMERT15, VCRIMERT15), d'opportunité/stress socioéconomique (COI_ct, HIS_ct), de saisie immobilière (ForclRt, FORCLRISK), de mobilité (CmTm14, MEANMI_14) et de littératie en santé (HealthLit), qui sont des outcomes typiques dans les analyses SDOH. Les variables X candidates couvrent les déterminants sociaux classiques : démographie, pauvreté, chômage, éducation, logement, accessibilité et composition raciale/ethnique ; les colonnes purement administratives (TRACTCE10, geoid10, commarea, district, region, regionno, districtno), géométriques (Shape_Leng, Shape_Area) et les indicateurs binaires redondants avec leurs versions continues (CAR, NOCAR, CTA, WHT50PCT, BLCK50PCT, HISP50PCT, Wht, Blk, Hisp) sont exclus.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `PDENS14` | `numeric` | rate | 0% |
| `CarC14P` | `numeric` | continuous | 0% |
| `CTA14P` | `numeric` | continuous | 0% |
| `Undr514P` | `numeric` | continuous | 0% |
| `Wht14P` | `numeric` | continuous | 0% |
| `Blk14P` | `numeric` | continuous | 0% |
| `Hisp14P` | `numeric` | continuous | 0% |
| `Pop2014` | `integer` | count | 0% |
| `FACHANGE` | `numeric` | continuous | 0% |
| `EP_PCI` | `integer` | count | 0% |
| `EP_MUNIT` | `integer` | count | 0% |
| `EP_GROUPQ` | `numeric` | continuous | 0% |
| `SSWS2USE` | `numeric` | continuous | 0% |
| `SchHP_Mi` | `numeric` | continuous | 0% |
| `BrownF_Mi` | `numeric` | continuous | 0% |
| `MEANMI_07` | `numeric` | continuous | 0% |
| `MEANMI_11` | `numeric` | continuous | 0% |
| `EP_MINRTY` | `numeric` | continuous | 0% |
| `Ovr6514P` | `numeric` | continuous | 0% |
| `EP_AGE17` | `numeric` | continuous | 0% |
| `EP_DISABL` | `numeric` | continuous | 0% |
| `EP_NOHSDP` | `numeric` | continuous | 0% |
| `EP_LIMENG` | `integer` | count | 0% |
| `EP_SNGPNT` | `numeric` | continuous | 0% |
| `Pov14` | `numeric` | continuous | 0% |
| `PerCap14` | `integer` | count | 0% |
| `Unemp14` | `numeric` | continuous | 0% |
| `EP_UNINSUR` | `numeric` | continuous | 0% |
| `EP_CROWD` | `numeric` | continuous | 0% |
| `EP_NOVEH` | `numeric` | continuous | 0% |
| `ChldPvt14` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: pending

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d'estimation: formule candidate generee par le systeme
- Correspondance Python/R: aucune identifiee
- Note: Aucune formule publiee n'a ete confirmee; deux formules candidates ont ete produites par le systeme et la formule recommandee est reportee dans formula_used.
### Formule — niveau systeme

- formula_used: YPLL_rate ~ PDENS14 + CarC14P + CTA14P + Undr514P + Wht14P + Blk14P + Hisp14P + Pop2014
- x_terms_used: PDENS14 + CarC14P + CTA14P + Undr514P + Wht14P + Blk14P + Hisp14P + Pop2014
- y_term_used: YPLL_rate

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
    formula: "YPLL_rate ~ PDENS14 + CarC14P + CTA14P + Undr514P + Wht14P + Blk14P + Hisp14P + Pop2014"
    response: "YPLL_rate"
    predictors: ["PDENS14", "CarC14P", "CTA14P", "Undr514P", "Wht14P", "Blk14P", "Hisp14P", "Pop2014"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_libpysal_chicagoSDOH`
- Dataset name: libpysal::chicagoSDOH
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
  existing_model_found: false
  equation_text: YPLL_rate ~ PDENS14 + CarC14P + CTA14P + Undr514P + Wht14P + Blk14P + Hisp14P + Pop2014
  equation_family: regression_candidate
  model_family: spatial_regression_candidate
  source_type: generated_system_formula
  source_ref: data/manifests/datasets/proposed_formula_used_audit.csv
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 791
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-87.8468, -87.5299], y [41.6509, 42.021] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32616 (UTM Zone 16N (EPSG:32616)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/libpysal/
- License open: yes
- Reproducibility status: available via package Python `libpysal`
- Code available: yes (package examples and vignettes)
- Repository: python-package

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: CANDIDATE - formule systeme proposee, sans source publication confirmee.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `libpysal`
