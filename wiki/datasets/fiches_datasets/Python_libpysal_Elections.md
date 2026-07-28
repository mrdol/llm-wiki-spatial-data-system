---
title: Python_libpysal_Elections
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/Python_libpysal_Elections.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `libpysal` (`Elections`).

## Description du jeu de donnees

- Topic: elections et comportement electoral
- Observation unit: circonscription, bureau de vote ou unite administrative
- Observed population: resultats electoraux ou population votante
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `libpysal` (`Elections`).
- Description source: package Python `libpysal`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `pct_dem_16`, `pct_gop_16`, `pct_pt_16`, `pct_dem_12`, `pct_gop_12`, `pct_pt_12`
- Candidate Y typology: rate, continuous
- Candidate X variables: `ALAND`, `AWATER`, `PST045214`, `PST120214`, `POP010210`, `AGE135214`, `AGE295214`, `AGE775214`, `SEX255214`, `RHI125214`, `RHI225214`, `RHI325214`, `RHI425214`, `RHI625214`, `RHI725214`, `RHI825214`, `POP715213`, `POP645213`, `POP815213`, `EDU635213`, `EDU685213`, `VET605213`, `LFE305213`, `HSG445213`, `HSG096213`, `HSG495213`, `HSD310213`, `INC910213`, `INC110213`, `PVY020213`, `BZA115213`, `SBO315207`, `SBO115207`, `SBO215207`, `SBO415207`, `SBO015207`, `LND110210`, `POP060210`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `GEOID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `pct_dem_16` | `numeric` | rate | [0.0314, 0.9285] | 0% |
| `pct_gop_16` | `numeric` | rate | [0.0412, 0.9527] | 0% |
| `pct_pt_16` | `numeric` | continuous | [-0.9164, 0.8872] | 0% |
| `pct_dem_12` | `numeric` | rate | [0.0345, 0.9335] | 0% |
| `pct_gop_12` | `numeric` | rate | [0.0601, 0.9586] | 0% |
| `pct_pt_12` | `numeric` | continuous | [-0.9241, 0.8735] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables cibles (Y) sont les parts de votes démocrate/républicain et les scores de point en 2016 et 2012, qui sont les résultats électoraux à expliquer/prédire. Les covariables (X) regroupent les caractéristiques socio-démographiques, économiques, éducatives, raciales, immobilières et géographiques des comtés susceptibles d'expliquer le comportement électoral ; les colonnes de votes bruts (Demvotes, GOPvotes, total, diff) sont exclues car redondantes avec les taux cibles, et les codes FIPS/noms de lieux sont ignorés comme identifiants administratifs.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `ALAND` | `numeric` | continuous | 0% |
| `AWATER` | `numeric` | continuous | 0% |
| `PST045214` | `numeric` | continuous | 0% |
| `PST120214` | `numeric` | continuous | 0% |
| `POP010210` | `numeric` | continuous | 0% |
| `AGE135214` | `numeric` | continuous | 0% |
| `AGE295214` | `numeric` | continuous | 0% |
| `AGE775214` | `numeric` | continuous | 0% |
| `SEX255214` | `numeric` | continuous | 0% |
| `RHI125214` | `numeric` | continuous | 0% |
| `RHI225214` | `numeric` | continuous | 0% |
| `RHI325214` | `numeric` | continuous | 0% |
| `RHI425214` | `numeric` | continuous | 0% |
| `RHI625214` | `numeric` | continuous | 0% |
| `RHI725214` | `numeric` | continuous | 0% |
| `RHI825214` | `numeric` | continuous | 0% |
| `POP715213` | `numeric` | continuous | 0% |
| `POP645213` | `numeric` | continuous | 0% |
| `POP815213` | `numeric` | continuous | 0% |
| `EDU635213` | `numeric` | continuous | 0% |
| `EDU685213` | `numeric` | continuous | 0% |
| `VET605213` | `numeric` | continuous | 0% |
| `LFE305213` | `numeric` | continuous | 0% |
| `HSG445213` | `numeric` | continuous | 0% |
| `HSG096213` | `numeric` | continuous | 0% |
| `HSG495213` | `numeric` | continuous | 0% |
| `HSD310213` | `numeric` | continuous | 0% |
| `INC910213` | `numeric` | continuous | 0% |
| `INC110213` | `numeric` | continuous | 0% |
| `PVY020213` | `numeric` | continuous | 0% |
| `BZA115213` | `numeric` | continuous | 0% |
| `SBO315207` | `numeric` | continuous | 0% |
| `SBO115207` | `numeric` | continuous | 0% |
| `SBO215207` | `numeric` | continuous | 0% |
| `SBO415207` | `numeric` | continuous | 0% |
| `SBO015207` | `numeric` | continuous | 0% |
| `LND110210` | `numeric` | continuous | 0% |
| `POP060210` | `numeric` | continuous | 0% |


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

- formula_used: pct_dem_16 ~ ALAND + AWATER + PST045214 + PST120214 + POP010210 + AGE135214 + AGE295214 + AGE775214
- x_terms_used: ALAND + AWATER + PST045214 + PST120214 + POP010210 + AGE135214 + AGE295214 + AGE775214
- y_term_used: pct_dem_16

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_libpysal_Elections`
- Dataset name: libpysal::Elections
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
  equation_text: pct_dem_16 ~ ALAND + AWATER + PST045214 + PST120214 + POP010210 + AGE135214 + AGE295214 + AGE775214
  equation_family: regression_candidate
  model_family: spatial_regression_candidate
  source_type: generated_system_formula
  source_ref: data/manifests/datasets/proposed_formula_used_audit.csv
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 3108
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-124.2124, -67.5503], y [24.6797, 48.8769] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: pending — multi-zones (span=56.7deg) -- projection nationale recommandee

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
