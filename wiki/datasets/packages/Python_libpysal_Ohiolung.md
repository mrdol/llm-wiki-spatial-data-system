---
title: Python_libpysal_Ohiolung
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/Python_libpysal_Ohiolung.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `libpysal` (`Ohiolung`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `LM68`, `LF68`, `LM78`, `LF78`, `LM88`, `LF88`
- Candidate Y typology: count
- Candidate X variables: `AREA`, `POPM68`, `POPF68`, `POPM78`, `POPF78`, `POPM88`, `POPF88`, `LMW68`, `LMB68`, `LFW68`, `LFB68`, `LMW78`, `LMB78`, `LFW78`, `LFB78`, `LMW88`, `LMB88`, `LFW88`, `LFB88`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `RECORD_ID`, `COUNTYID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `LM68` | `integer` | count | [1, 522] | 0% |
| `LF68` | `integer` | count | [0, 111] | 0% |
| `LM78` | `integer` | count | [3, 580] | 0% |
| `LF78` | `integer` | count | [0, 201] | 0% |
| `LM88` | `integer` | count | [2, 641] | 0% |
| `LF88` | `integer` | count | [1, 352] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Ce dataset porte sur la mortalité pulmonaire (lung cancer) par comté de l'Ohio : les colonnes LM*/LF* représentent les décès (males/females) pour 1968, 1978, 1988 et sont les cibles naturelles, tandis que les populations de référence (POPM*, POPF*, POPMW*, etc.), la superficie (AREA) et les sous-groupes de décès par race/sexe constituent des covariables explicatives pertinentes. FIPSNO, NAME et PERIMETER sont ignorés car purement administratifs ou géométriques.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `AREA` | `integer` | count | 0% |
| `POPM68` | `integer` | count | 0% |
| `POPF68` | `integer` | count | 0% |
| `POPM78` | `integer` | count | 0% |
| `POPF78` | `integer` | count | 0% |
| `POPM88` | `integer` | count | 0% |
| `POPF88` | `integer` | count | 0% |
| `LMW68` | `integer` | count | 0% |
| `LMB68` | `integer` | count | 0% |
| `LFW68` | `integer` | count | 0% |
| `LFB68` | `integer` | count | 0% |
| `LMW78` | `integer` | count | 0% |
| `LMB78` | `integer` | count | 0% |
| `LFW78` | `integer` | count | 0% |
| `LFB78` | `integer` | count | 0% |
| `LMW88` | `integer` | count | 0% |
| `LMB88` | `integer` | count | 0% |
| `LFW88` | `integer` | count | 0% |
| `LFB88` | `integer` | count | 0% |


### Formule — niveau publication

- formula_pub: kappa_ijkt = mu + s_j*alpha + r_k*beta + s_j*r_k*gamma + p_i*rho + c_t + phi_it (Poisson)
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Xia & Carlin (1998), DOI:10.1002/(SICI)1097-0258(19980930)17:18<2025

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: Bayesien hierarchique CAR
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_libpysal_Ohiolung`
- Dataset name: libpysal::Ohiolung
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
  equation_text: "kappa_ijkt = mu + s_j*alpha + r_k*beta + s_j*r_k*gamma + p_i*rho + c_t + phi_it (Poisson)"
  equation_family: bayesian_latent_field
  model_family: "Bayesien hierarchique CAR"
  source_type: software_documentation
  source_ref: "Xia & Carlin (1998), DOI:10.1002/(SICI)1097-0258(19980930)17:18<2025"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 88
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-85.4895, -85.4895], y [0.0003, 0.0004] (EPSG:4326)
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

Aucune anomalie detectee.

## Related Pages

- Source: package Python `libpysal`
