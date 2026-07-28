---
title: Python_geodatasets_spdata.columbus
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/Python_geodatasets_spdata.columbus.rds
  - data/final_datasets/sf/R_spdep_oldcol_COL.OLD.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`columbus`).

## Description du jeu de donnees

- Topic: criminalite urbaine
- Observation unit: quartier, zone urbaine ou evenement de police selon la documentation source
- Observed population: unites spatiales ou evenements lies a la criminalite
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`columbus`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `CRIME`, `HOVAL`
- Candidate Y typology: continuous
- Candidate X variables: `INC`, `OPEN`, `PLUMB`, `DISCBD`, `NSA`, `NSB`, `EW`, `CP`, `AREA`, `PERIMETER`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `POLYID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `CRIME` | `numeric` | continuous | [0.1783, 68.892] | 0% |
| `HOVAL` | `numeric` | continuous | [17.9, 96.4] | 0% |


> Selection Y/X (claude-sonnet-4-6) : CRIME (taux de criminalité) et HOVAL (valeur des logements) sont les deux variables réponses classiques du dataset Columbus, utilisées comme cibles dans la littérature de spatiale. INC (revenu), OPEN (espaces ouverts), PLUMB (plomberie défectueuse), DISCBD (distance au CBD), les indicateurs binaires de zone (NSA, NSB, EW, CP) ainsi que AREA et PERIMETER constituent des covariables explicatives plausibles ; COLUMBUS_, COLUMBUS_I, NEIG, THOUS et NEIGNO sont des identifiants/codes redondants ignorés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `INC` | `numeric` | continuous | 0% |
| `OPEN` | `numeric` | continuous | 0% |
| `PLUMB` | `numeric` | continuous | 0% |
| `DISCBD` | `numeric` | continuous | 0% |
| `NSA` | `numeric` | binary | 0% |
| `NSB` | `numeric` | binary | 0% |
| `EW` | `numeric` | binary | 0% |
| `CP` | `numeric` | binary | 0% |
| `AREA` | `numeric` | rate | 0% |
| `PERIMETER` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: CRIME ~ HOVAL + INC
- x_terms_pub: HOVAL + INC
- y_term_pub: CRIME
- Reference publication: Anselin, Luc (1988) Spatial Econometrics: Methods and Models. Dordrecht: Kluwer Academic, Table 12.1, p. 189.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: R_spdep_oldcol_COL.OLD
- Note: Formule identifiee via la documentation du package equivalent `R_spdep_oldcol_COL.OLD` -- meme jeu de donnees sous-jacent (propagation automatique Tache 3, a confirmer par revue manuelle).

### Formule — niveau systeme

- formula_used: CRIME ~ HOVAL + INC
- x_terms_used: HOVAL + INC
- y_term_used: CRIME

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_spdata.columbus`
- Dataset name: geodatasets::columbus
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
  existing_model_found: true
  equation_text: "CRIME ~ HOVAL + INC"
  equation_family: unknown
  model_family: "formule publication confirmee et utilisee"
  source_type: unknown
  source_ref: "Anselin, Luc (1988) Spatial Econometrics: Methods and Models. Dordrecht: Kluwer Academic, Table 12.1, p. 189."
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 49
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_1
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [6.1659, 10.9621], y [11.0409, 14.4377] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32632 (UTM Zone 32N (EPSG:32632)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/geodatasets/
- License open: yes
- Reproducibility status: available via package Python `geodatasets`
- Code available: yes (package examples and vignettes)
- Repository: python-package

## Estimator eligibility

```yaml
estimator_eligibility:
  - estimator: ols
    basis: scientific_evidence
    source_ref: "Anselin, Luc (1988) Spatial Econometrics: Methods and Models, Chapter 12 Columbus crime example."
    pages: "191-192"
    pdf_pages: "203-204"
    tables: ["12.3"]
    notes: "OLS regression with diagnostics for spatial effects, formula CRIME ~ INC + HOUSE/HOVAL."
  - estimator: sar_lag
    basis: scientific_evidence
    source_ref: "Anselin, Luc (1988) Spatial Econometrics: Methods and Models, Chapter 12 Columbus crime example."
    pages: "192-194"
    pdf_pages: "204-206"
    tables: ["12.4", "12.5"]
    notes: "Mixed regressive spatial autoregressive model with W_CRIME."
  - estimator: sem_error
    basis: scientific_evidence
    source_ref: "Anselin, Luc (1988) Spatial Econometrics: Methods and Models, Chapter 12 Columbus crime example."
    pages: "194-196"
    pdf_pages: "206-208"
    tables: ["12.6", "12.7"]
    notes: "ML estimation of the model with spatially dependent error terms."
  - estimator: sdm_mixed
    basis: scientific_evidence
    source_ref: "Anselin, Luc (1988) Spatial Econometrics: Methods and Models, Chapter 12 Columbus crime example."
    pages: "196-197"
    pdf_pages: "208-209"
    tables: ["12.8"]
    notes: "Spatial Durbin model with W_CRIME, W_INC and W_HOUSE."
  - estimator: spmoran_esf
    basis: benchmark_use
    source_ref: "spatialtidymodels package tests on Columbus; method source must be Murakami/spmoran, not Anselin 1988."
    notes: "Benchmark route only until a paper-source relation is curated."
  - estimator: spmoran_resf
    basis: benchmark_use
    source_ref: "spatialtidymodels package tests on Columbus; method source must be Murakami/spmoran, not Anselin 1988."
    notes: "Benchmark route only until a paper-source relation is curated."
```

## Fusion des sources et variantes

Cette fiche est la fiche canonique du cas d'etude Columbus crime. Elle fusionne les sources Python `geodatasets::spdata.columbus` et R `spdep::COL.OLD`, qui documentent le meme jeu de donnees historique utilise pour les exemples d'econometrie spatiale d'Anselin.

### Sources fusionnees

| Ancienne fiche | Source package | Objet source | Artefact local | Role |
|---|---|---|---|---|
| `Python_geodatasets_spdata.columbus` | geodatasets / spData | `spdata.columbus` | `data/final_datasets/sf/Python_geodatasets_spdata.columbus.rds` | fiche canonique conservee |
| `R_spdep_oldcol_COL.OLD` | spdep | `COL.OLD` | `data/final_datasets/sf/R_spdep_oldcol_COL.OLD.rds` | source R integree puis retiree comme fiche separee |

### Elements communs

- Meme cas d'etude: criminalite et variables socio-economiques dans les quartiers de Columbus.
- Meme formule de reference: `CRIME ~ HOVAL + INC`.
- Meme usage methodologique: comparaison OLS, SAR, SEM et variantes spatiales.

### Elements non communs

- Les noms d'objets et le package source different selon l'ecosysteme Python ou R.
- Les metadonnees de provenance conservent les deux chemins d'artefacts pour permettre de retracer les deux sources.

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: FUSED - fiche commune pour `Python_geodatasets_spdata.columbus` et `R_spdep_oldcol_COL.OLD`.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`
