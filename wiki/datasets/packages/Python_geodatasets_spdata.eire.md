---
title: Python_geodatasets_spdata.eire
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/Python_geodatasets_spdata.eire.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`eire`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `INCOME`, `POPCHG`, `RETSALE`
- Candidate Y typology: continuous
- Candidate X variables: `A`, `towns`, `pale`, `size`, `ROADACC`, `OWNCONS`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `INCOME` | `numeric` | continuous | [5297, 164631] | 0% |
| `POPCHG` | `numeric` | continuous | [60, 142] | 0% |
| `RETSALE` | `numeric` | continuous | [1885, 89424] | 0% |


> Selection Y/X (claude-sonnet-4-6) : INCOME, POPCHG et RETSALE sont des variables socio-économiques classiquement utilisées comme cibles dans des modèles spatiaux (revenus, croissance démographique, ventes au détail). Les autres variables numériques (superficie A, taux d'urbanisation towns, indicateur historique pale, taille size, accessibilité routière ROADACC, occupation des logements OWNCONS) constituent des covariables explicatives plausibles ; la colonne names est ignorée car purement administrative.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `A` | `numeric` | continuous | 0% |
| `towns` | `numeric` | rate | 0% |
| `pale` | `numeric` | binary | 0% |
| `size` | `numeric` | continuous | 0% |
| `ROADACC` | `numeric` | continuous | 0% |
| `OWNCONS` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: A~towns+pale
- x_terms_pub: towns+pale
- y_term_pub: A
- Reference publication: rdrr.io/cran/spData/man/eire.html

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: OLS
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_spdata.eire`
- Dataset name: geodatasets::eire
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
  equation_text: "A~towns+pale"
  equation_family: linear
  model_family: "OLS"
  source_type: software_documentation
  source_ref: "rdrr.io/cran/spData/man/eire.html"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 26
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-101.7923, 125.2857], y [-70.305, 72.45] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: pending — multi-zones (span=227.1deg) -- projection nationale recommandee

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
