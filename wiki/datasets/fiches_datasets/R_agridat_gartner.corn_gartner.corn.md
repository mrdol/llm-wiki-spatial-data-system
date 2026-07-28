---
title: R_agridat_gartner.corn_gartner.corn
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/R_agridat_gartner.corn_gartner.corn.rds
tags: [dataset, r-package, spatial, point]
---

Yield monitor data from a corn field in Minnesota

## Description du jeu de donnees

- Topic: agriculture / rendement ou experimentation agronomique
- Observation unit: parcelle, placette experimentale ou observation agricole
- Observed population: observations agricoles documentees par le package source
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: colonnes date/time presentes mais traitees comme attributs transactionnels
- Source description: Yield monitor data from a corn field in Minnesota
- Description source: package R `agridat`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `mass`, `moist`
- Candidate Y typology: continuous
- Candidate X variables: `dist`, `elev`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `long`, `lat`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `mass` | `numeric` | continuous | [0, 48.99] | 0% |
| `moist` | `numeric` | continuous | [14.9, 19.3] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Dans un yield monitor de maïs, 'mass' (masse récoltée) est la variable réponse principale (rendement), et 'moist' (humidité du grain) est une seconde cible agronomique d'intérêt. 'elev' (élévation topographique) et 'dist' (distance parcourue) sont des covariables spatiales explicatives pertinentes ; 'time' et 'T' semblent redondants (même plage), et 'seconds' a une variance quasi nulle (3-4s), rendant ces trois colonnes inutiles comme features.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `dist` | `integer` | count | 0% |
| `elev` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Suman Rakshit, Adrian Baddeley, Katia Stefanova, Karyn Reeves, Kefei Chen, Zhanglong Cao, Fiona Evans, Mark Gibberd (2020). Novel approach to the analysis of spatially-varying treatment effects in on-farm experiments. Field Crops Research, 255, 15 September 2020, 107783. https://doi.org/10.1016/j.fcr.2020.107783

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d'estimation: formule candidate generee par le systeme
- Correspondance Python/R: aucune identifiee
- Note: Aucune formule publiee n'a ete confirmee; deux formules candidates ont ete produites par le systeme et la formule recommandee est reportee dans formula_used.
### Formule — niveau systeme

- formula_used: mass ~ dist + elev
- x_terms_used: dist + elev
- y_term_used: mass

## Bloc 2 — Identification et DOI

- Dataset ID: `R_agridat_gartner.corn_gartner.corn`
- Dataset name: agridat::gartner.corn
- Source family: r-package
- Source: package R `agridat` (version 1.26)
- Source URL: https://CRAN.R-project.org/package=agridat
- Dataset DOI: none
- Publication DOI: pending
- Year: 2011

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: mass ~ dist + elev
  equation_family: regression_candidate
  model_family: spatial_regression_candidate
  source_type: generated_system_formula
  source_ref: data/manifests/datasets/proposed_formula_used_audit.csv
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 4949
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: colonnes date/time presentes mais traitees comme attributs transactionnels

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-93.9784, -93.9735], y [43.921, 43.9273] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL-2
- License URL: https://CRAN.R-project.org/package=agridat
- License open: yes
- Reproducibility status: available via package R `agridat`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: CANDIDATE - formule systeme proposee, sans source publication confirmee.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL-2).

## Related Pages

- Source: package R `agridat`
