---
title: R_spData_depmunic_depmunic
type: dataset
created: 2026-06-30
updated: 2026-07-01
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

- formula_pub: y_ij = rho*W_i*y + x'_ij*beta + z'_j*gamma + theta_j (modele hierarchique spatial general, Dong & Harris 2014) — NON instancie sur les colonnes reelles
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Dong, G. and Harris, R. (2014) Spatial Autoregressive Models for Geographically Hierarchical Data Structures. Geographical Analysis. DOI:10.1111/gean.12049

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: a verifier
- Niveau de preuve: article
- Methode d'estimation: Modele autoregressif spatial hierarchique (SAR multi-niveaux)
- Correspondance Python/R: aucune identifiee
- Note: La formule presente (enrichissement anterieur) est l'equation generique de la classe de modeles du papier Dong & Harris (notation y_ij/x_ij/z_j), pas une instanciation sur les colonnes reelles (airbnb, pop_rest, museums, population, greensp, area). Candidat par analogie propose : airbnb~museums+population+greensp+area (OLS), coherent avec la structure hedonique/attractivite du departement, mais NON verifie dans une source explicitement chiffree sur ce jeu precis (N=7, tres petit echantillon).

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
  existing_model_found: true
  equation_text: "y_ij = rho*W_i*y + x'_ij*beta + z'_j*gamma + theta_j (modele hierarchique spatial general, Dong & Harris 2014) — NON instancie sur les colonnes reelles"
  equation_family: spatial_lag
  model_family: "Modele autoregressif spatial hierarchique (SAR multi-niveaux)"
  source_type: full_paper
  source_ref: "Dong, G. and Harris, R. (2014) Spatial Autoregressive Models for Geographically Hierarchical Data Structures. Geographical Analysis. DOI:10.1111/gean.12049"
  confidence: medium
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

Aucune anomalie detectee.

## Related Pages

- Source: package R `spData`
