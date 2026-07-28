---
title: R_GWmodel_LondonHP_londonhp
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/R_GWmodel_LondonHP_londonhp.rds
  - data/final_datasets/sf/R_GWmodel_LondonBorough_londonborough.rds
tags: [dataset, r-package, spatial, point]
---

A house price data set with 18 hedonic variables for London in 2001.

## Description du jeu de donnees

- Topic: immobilier / prix des logements
- Observation unit: logement, transaction immobiliere ou zone residentielle selon la documentation source
- Observed population: marche immobilier documente par le package source
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: A house price data set with 18 hedonic variables for London in 2001.
- Description source: package R `GWmodel`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `PURCHASE`
- Candidate Y typology: continuous
- Candidate X variables: `FLOORSZ`, `TYPEDETCH`, `TPSEMIDTCH`, `TYPETRRD`, `TYPEBNGLW`, `TYPEFLAT`, `BLDPWW1`, `BLDPOSTW`, `BLD60S`, `BLD70S`, `BLD80S`, `BLD90S`, `BLDINTW`, `BATH2`, `BEDS2`, `GARAGE1`, `CENTHEAT`, `UNEMPLOY`, `PROF`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PURCHASE` | `numeric` | continuous | [45000, 567500] | 0% |


> Note doc : y is detached (i

> Selection Y/X (claude-sonnet-4-6) : PURCHASE (prix d'achat) est la variable réponse naturelle d'un modèle hédonique de prix immobiliers. Toutes les autres colonnes sont des attributs hédoniques du logement (surface, type, époque de construction, équipements) ou des indicateurs socio-économiques du voisinage (chômage, proportion de professions libérales), qui constituent des covariables explicatives classiques dans ce type de modèle.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `FLOORSZ` | `numeric` | continuous | 0% |
| `TYPEDETCH` | `integer` | binary | 0% |
| `TPSEMIDTCH` | `integer` | binary | 0% |
| `TYPETRRD` | `integer` | binary | 0% |
| `TYPEBNGLW` | `integer` | binary | 0% |
| `TYPEFLAT` | `integer` | binary | 0% |
| `BLDPWW1` | `integer` | binary | 0% |
| `BLDPOSTW` | `integer` | binary | 0% |
| `BLD60S` | `integer` | binary | 0% |
| `BLD70S` | `integer` | binary | 0% |
| `BLD80S` | `integer` | binary | 0% |
| `BLD90S` | `integer` | binary | 0% |
| `BLDINTW` | `integer` | binary | 0% |
| `BATH2` | `integer` | binary | 0% |
| `BEDS2` | `integer` | binary | 0% |
| `GARAGE1` | `integer` | binary | 0% |
| `CENTHEAT` | `integer` | binary | 0% |
| `UNEMPLOY` | `numeric` | rate | 0% |
| `PROF` | `numeric` | rate | 0% |


### Formule — niveau publication

- formula_pub: PURCHASE ~ FLOORSZ + PROF + BATH2
- x_terms_pub: FLOORSZ, PROF, BATH2
- y_term_pub: PURCHASE
- Reference publication: Lu, B., Charlton, M., Harris, P., Fotheringham, A.S. (2014) Geographically weighted regression with a non-Euclidean distance metric: a case study using hedonic house price data. International Journal of Geographical Information Science, 28(4): 660-681

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: R_GWmodel_LondonBorough_londonborough
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: PURCHASE ~ FLOORSZ + PROF + BATH2
- x_terms_used: FLOORSZ, PROF, BATH2
- y_term_used: PURCHASE

## Bloc 2 — Identification et DOI

- Dataset ID: `R_GWmodel_LondonHP_londonhp`
- Dataset name: GWmodel::LondonHP
- Source family: r-package
- Source: package R `GWmodel` (version 2.4.1)
- Source URL: https://CRAN.R-project.org/package=GWmodel
- Dataset DOI: none
- Publication DOI: 10.1080/13658816.2013.865739
- Year: 2013

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "PURCHASE ~ FLOORSZ + PROF + BATH2"
  equation_family: unknown
  model_family: "formule publication confirmee et utilisee"
  source_type: unknown
  source_ref: "Lu, B., Charlton, M., Harris, P., Fotheringham, A.S. (2014) Geographically weighted regression with a non-Euclidean distance metric: a case study using hedonic house price data. International Journal of Geographical Information Science, 28(4): 660-681"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 316
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [507400, 552300], y [159400, 194900] (EPSG:27700)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 27700
- CRS nom: OSGB36 / British National Grid
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://CRAN.R-project.org/package=GWmodel
- License open: yes
- Reproducibility status: available via package R `GWmodel`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Estimator eligibility

```yaml
estimator_eligibility:
  - estimator: ols
    basis: scientific_evidence
    source_ref: "Lu, Charlton, Harris & Fotheringham (2014), IJGIS."
    notes: "Hedonic house price reference model used as global baseline."
  - estimator: gam_spatial
    basis: benchmark_use
    source_ref: "spatialtidymodels package benchmark metadata."
    notes: "Useful smooth spatial baseline for the London house price data."
  - estimator: mgwrsar_gwr
    basis: scientific_evidence
    source_ref: "Lu, Charlton, Harris & Fotheringham (2014), IJGIS."
    notes: "LondonHP is a direct GWR hedonic house price case study."
  - estimator: mgwrsar_mgwr
    basis: benchmark_use
    source_ref: "spatialtidymodels package benchmark metadata."
    notes: "Useful for multiscale local coefficient tests."
  - estimator: MGWRSAR_0_kc_kv
    basis: benchmark_use
    source_ref: "spatialtidymodels package benchmark metadata."
    notes: "Useful for mixed stationary/non-stationary MGWRSAR tests without SAR autocorrelation."
  - estimator: MGWRSAR_1_kc_kv
    basis: benchmark_use
    source_ref: "spatialtidymodels package benchmark metadata."
    notes: "Useful for mixed stationary/non-stationary MGWRSAR tests with SAR autocorrelation."
```

## Fusion des sources et variantes

Cette fiche est la fiche canonique du cas d'etude London house prices. Elle conserve `LondonHP` comme table de modelisation et integre `LondonBorough` comme couche auxiliaire de contexte spatial plutot que comme fiche dataset separee.

### Sources fusionnees

| Ancienne fiche | Source package | Objet source | Artefact local | Role |
|---|---|---|---|---|
| `R_GWmodel_LondonHP_londonhp` | GWmodel | `LondonHP` | `data/final_datasets/sf/R_GWmodel_LondonHP_londonhp.rds` | fiche canonique conservee |
| `R_GWmodel_LondonBorough_londonborough` | GWmodel | `LondonBorough` | `data/final_datasets/sf/R_GWmodel_LondonBorough_londonborough.rds` | couche spatiale auxiliaire integree |

### Elements communs

- Meme cas d'etude London utilise dans les travaux GWR sur les prix immobiliers.
- Meme source package: `GWmodel`.
- Meme contexte spatial de Londres.

### Elements non communs

- `LondonHP` contient les observations de logements et la reponse de modelisation.
- `LondonBorough` fournit une geometrie administrative de contexte; ce n'est pas une table de regression equivalente.

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: OK - CRS renseigne dans le Bloc 5 (27700).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: FUSED - fiche commune pour `R_GWmodel_LondonHP_londonhp` et la couche auxiliaire `R_GWmodel_LondonBorough_londonborough`.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2)).

## Related Pages

- Source: package R `GWmodel`
