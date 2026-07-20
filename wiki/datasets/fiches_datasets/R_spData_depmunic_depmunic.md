---
title: R_spData_depmunic_depmunic
type: dataset
created: 2026-07-10
updated: 2026-07-10
sources:
  - data/final_datasets/sf/R_spData_depmunic_depmunic.rds
tags: [dataset, r-package, spatial, point]
---

The geographic boundaries of departments (sf) of the municipality of Athens. This is accompanied by various characteristics in these areas.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `airbnb`, `pop_rest`
- Candidate Y typology: continuous
- Candidate X variables: `museums`, `population`, `greensp`, `area`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `airbnb` | `numeric` | continuous | [144, 2171] | 0% |
| `pop_rest` | `numeric` | continuous | [2735, 16531] | 0% |


> Selection Y/X (claude-sonnet-4-6) : airbnb (densité de locations touristiques) et pop_rest (population résidente restante ou flottante) sont des variables-réponses plausibles reflétant des phénomènes socio-économiques à expliquer. museums, population, greensp et area constituent des covariables explicatives caractérisant l'attractivité, la démographie et la morphologie des départements athéniens. num_dep est un identifiant ordinal sans valeur explicative.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `museums` | `numeric` | continuous | 0% |
| `population` | `numeric` | continuous | 0% |
| `greensp` | `numeric` | continuous | 0% |
| `area` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: y_{i,j} = rho * W_i * y + x'_{i,j} * beta + z'_j * gamma + theta_j + epsilon_{i,j}; theta_j = lambda * M_j * theta + mu_j
- x_terms_pub: x_{i,j} (lower-level covariates), z_j (higher-level covariates), W_i (lower-level spatial weights matrix), M_j (higher-level spatial weights matrix)
- y_term_pub: y_{i,j} (outcome for lower-level unit i in higher-level unit j)
- Reference publication: Dong, G. and Harris, R. (2014) Spatial Autoregressive Models for Geographically Hierarchical Data Structures. Geographical Analysis.

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_spData_depmunic_depmunic`
- Dataset name: spData::depmunic
- Source family: r-package
- Source: package R `spData` (version 2.3.4)
- Source URL: https://CRAN.R-project.org/package=spData
- Dataset DOI: none
- Publication DOI: 10.1111/gean.12049
- Year: 2017

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "y_{i,j} = rho * W_i * y + x'_{i,j} * beta + z'_j * gamma + theta_j + epsilon_{i,j}; theta_j = lambda * M_j * theta + mu_j"
  equation_family: unknown
  model_family: "n/a"
  source_type: unknown
  source_ref: "Dong, G. and Harris, R. (2014) Spatial Autoregressive Models for Geographically Hierarchical Data Structures. Geographical Analysis."
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 7
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [23.7042, 23.7657], y [37.9625, 38.0204] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32634 (UTM Zone 34N (EPSG:32634)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: CC0
- License URL: https://CRAN.R-project.org/package=spData
- License open: yes
- Reproducibility status: available via package R `spData`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (CC0).

## Related Pages

- Source: package R `spData`
