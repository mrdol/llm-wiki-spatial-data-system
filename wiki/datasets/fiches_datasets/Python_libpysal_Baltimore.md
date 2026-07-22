---
title: Python_libpysal_Baltimore
type: dataset
created: 2026-07-10
updated: 2026-07-10
sources:
  - data/final_datasets/sf/Python_libpysal_Baltimore.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `libpysal` (`Baltimore`).

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
- x_terms_pub: NROOM + NBATH + PATIO + FIREPL + AC + GAR + AGE + LOTSZ + SQFT
- y_term_pub: PRICE
- Reference publication: PySAL spreg ML_Lag documentation example on Baltimore (`baltim.dbf`/`baltim_q.gal`); Dubin, Robin A. (1992), Spatial autocorrelation and neighborhood quality, Regional Science and Urban Economics 22(3), 433-452.

### Statut regression canonique

- Statut: resolved
- Niveau de preuve: official_software_documentation
- Methode d'estimation: spatial lag / hedonic regression
- Correspondance Python/R: aucune identifiee
- Note: La documentation `spData::baltimore` confirme le jeu de prix hedoniques ; la formule exécutable est prise dans l'exemple officiel PySAL `spreg.ML_Lag`.

### Formule — niveau systeme

- formula_used: PRICE ~ NROOM + NBATH + PATIO + FIREPL + AC + GAR + AGE + LOTSZ + SQFT
- x_terms_used: NROOM + NBATH + PATIO + FIREPL + AC + GAR + AGE + LOTSZ + SQFT
- y_term_used: PRICE

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
  equation_family: linear
  model_family: "spatial lag / hedonic regression"
  source_type: official_software_documentation
  source_ref: "PySAL spreg ML_Lag documentation example on Baltimore (`baltim.dbf`/`baltim_q.gal`); Dubin, Robin A. (1992), Spatial autocorrelation and neighborhood quality, Regional Science and Urban Economics 22(3), 433-452."
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 211
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-40, 87.5], y [-41, 34.5] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: pending — multi-zones (span=127.5deg) -- projection nationale recommandee

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
- Formula: PENDING - formule publication non encore etablie.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `libpysal`
