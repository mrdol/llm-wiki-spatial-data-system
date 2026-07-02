---
title: Python_geodatasets_spdata.boston
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/Python_geodatasets_spdata.boston.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`boston`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `MEDV`, `CMEDV`, `median`, `CRIM`
- Candidate Y typology: continuous
- Candidate X variables: `ZN`, `INDUS`, `CHAS`, `NOX`, `RM`, `AGE`, `DIS`, `RAD`, `TAX`, `PTRATIO`, `B`, `LSTAT`, `POP`, `BB`, `units`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `LON`, `LAT`, `X`, `Y`
- Identifier columns (excluded from X candidates): `NOX_ID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `MEDV` | `numeric` | continuous | [5, 50] | 0% |
| `CMEDV` | `numeric` | continuous | [5, 50] | 0% |
| `median` | `numeric` | continuous | [5600, 50000] | 3.4% |
| `CRIM` | `numeric` | continuous | [0.0063, 88.9762] | 0% |


> Selection Y/X (claude-sonnet-4-6) : MEDV et CMEDV (valeur médiane des logements) sont les cibles classiques de ce benchmark immobilier, median en est une version alternative (en dollars absolus) ; CRIM (taux de criminalité) peut aussi être une variable réponse dans des études de sécurité urbaine. Les colonnes ZN, INDUS, CHAS, NOX, RM, AGE, DIS, RAD, TAX, PTRATIO, B, LSTAT, POP, BB et units sont des caractéristiques socio-économiques, environnementales et d'accessibilité typiquement utilisées comme covariables explicatives ; les colonnes de comptage de logements par tranche de prix (cu5k, c5_7_5, C7_5_10, etc.) et censored sont ignorées car redondantes avec MEDV/CMEDV ou purement descriptives de la distribution cible.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `ZN` | `numeric` | continuous | 0% |
| `INDUS` | `numeric` | continuous | 0% |
| `CHAS` | `character` | categorical | 0% |
| `NOX` | `numeric` | rate | 0% |
| `RM` | `numeric` | continuous | 0% |
| `AGE` | `numeric` | continuous | 0% |
| `DIS` | `numeric` | continuous | 0% |
| `RAD` | `numeric` | continuous | 0% |
| `TAX` | `numeric` | continuous | 0% |
| `PTRATIO` | `numeric` | continuous | 0% |
| `B` | `numeric` | continuous | 0% |
| `LSTAT` | `numeric` | continuous | 0% |
| `POP` | `integer` | count | 0% |
| `BB` | `numeric` | continuous | 0% |
| `units` | `integer` | count | 0% |


### Formule — niveau publication

- formula_pub: log(CMEDV)~CRIM+ZN+INDUS+CHAS+I(NOX^2)+I(RM^2)+AGE+log(DIS)+log(RAD)+TAX+PTRATIO+B+log(LSTAT)
- x_terms_pub: CRIM+ZN+INDUS+CHAS+I(NOX^2)+I(RM^2)+AGE+log(DIS)+log(RAD)+TAX+PTRATIO+B+log(LSTAT)
- y_term_pub: log(CMEDV)
- Reference publication: rdrr.io/cran/spData/man/boston.html

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: OLS hedonique
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_spdata.boston`
- Dataset name: geodatasets::boston
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
  equation_text: "log(CMEDV)~CRIM+ZN+INDUS+CHAS+I(NOX^2)+I(RM^2)+AGE+log(DIS)+log(RAD)+TAX+PTRATIO+B+log(LSTAT)"
  equation_family: linear
  model_family: "OLS hedonique"
  source_type: software_documentation
  source_ref: "rdrr.io/cran/spData/man/boston.html"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 506
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-71.4775, -70.689], y [42.049, 42.6364] (EPSG:4267)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4267
- CRS nom: NAD27
- CRS analyse recommande: 32619 (UTM Zone 19N (EPSG:32619)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/geodatasets/
- License open: yes
- Reproducibility status: available via package Python `geodatasets`
- Code available: yes (package examples and vignettes)
- Repository: python-package

## Quality Control

Aucune anomalie detectee.

## Related Pages

- Source: package Python `geodatasets`
