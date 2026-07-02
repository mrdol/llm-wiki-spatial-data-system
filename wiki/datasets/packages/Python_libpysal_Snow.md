---
title: Python_libpysal_Snow
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/Python_libpysal_Snow.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `libpysal` (`Snow`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `deaths`, `deaths_r`, `deaths_nr`
- Candidate Y typology: count
- Candidate X variables: `pestfield`, `dis_pestf`, `dis_sewers`, `dis_bspump`
- Candidate X typology: categorical, continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `ID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `deaths` | `integer` | count | [0, 18] | 0% |
| `deaths_r` | `integer` | count | [0, 12] | 0% |
| `deaths_nr` | `integer` | count | [0, 18] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Ce dataset correspond aux données historiques de choléra de John Snow (Londres 1854) : les variables de décès (totaux, résidents, non-résidents) sont les réponses naturelles à modéliser. Les distances à la pompe Broad Street (dis_bspump), aux égouts (dis_sewers), au champ de pestilence (dis_pestf) et la présence du champ (pestfield) sont des covariables spatiales explicatives classiques pour ce benchmark. Note : deaths étant la somme de deaths_r et deaths_nr, il faudra éviter de les utiliser simultanément comme Y.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `pestfield` | `integer` | binary | 0% |
| `dis_pestf` | `numeric` | continuous | 0% |
| `dis_sewers` | `numeric` | continuous | 0% |
| `dis_bspump` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: deaths ~ dis_bspump + dis_sewers + dis_pestf + pestfield
- x_terms_pub: dis_bspump + dis_sewers + dis_pestf + pestfield
- y_term_pub: deaths
- Reference publication: none (aucune source verifiable retrouvee)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: candidat par analogie -- non verifie
- Niveau de preuve: analogie
- Methode d'estimation: GLM Poisson (analogie avec geoda.nydata / R_SpatialEpi_pennLC)
- Correspondance Python/R: aucune identifiee
- Note: CANDIDAT PAR ANALOGIE — non verifie. Aucune equation ajustee publiee retrouvee pour cette version agregee (N=1852) du dataset de John Snow (cholera, Londres 1854). Analogie proposee avec les modeles de comptage de cas de maladie en fonction de facteurs de proximite (geoda.nydata: CASES~PEXPOSURE+...; R_SpatialEpi pennLC_sf: Y~offset(log(E))+smoking), domaine substantiellement identique (epidemiologie spatiale de comptages ponctuels) et hypothese originale de Snow lui-meme (proximite a la pompe Broad Street comme facteur de risque).

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_libpysal_Snow`
- Dataset name: libpysal::Snow
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
  equation_text: "deaths ~ dis_bspump + dis_sewers + dis_pestf + pestfield"
  equation_family: generalized_linear
  model_family: "GLM Poisson (analogie avec geoda.nydata / R_SpatialEpi_pennLC)"
  source_type: unknown
  source_ref: "null"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 1852
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-0.1424, -0.1324], y [51.5099, 51.516] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32630 (UTM Zone 30N (EPSG:32630)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

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
