---
title: Python_geodatasets_geoda.lasrosas
type: dataset
created: 2026-07-10
updated: 2026-07-10
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.lasrosas.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`lasrosas`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `YIELD`
- Candidate Y typology: continuous
- Candidate X variables: `N`, `N2`, `TOPO`, `BV`, `BV2`, `NXBV`, `SAT`, `SAT2`, `NXSAT`, `BVXT2`, `BVXT3`, `BVXT4`, `BV2XT2`, `BV2XT3`, `BV2XT4`, `SATXT2`, `SATXT3`, `SATXT4`, `SAT2XT2`, `SAT2XT3`, `SAT2XT4`, `NXTOP2`, `NXTOP3`, `NXTOP4`, `N2XTOP2`, `N2XTOP3`, `N2XTOP4`, `TOP2`, `TOP3`, `TOP4`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `LONGITUDE`, `LATITUDE`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `YIELD` | `numeric` | continuous | [31.23, 90.38] | 0% |


> Selection Y/X (claude-sonnet-4-6) : YIELD (rendement agricole en continu) est la variable réponse naturelle de ce dataset d'expérimentation agronomique issu de Las Rosas. Les autres colonnes représentent des covariables explicatives : dose d'azote (N, N2), topographie (TOPO, TOP2-4 indicatrices de classe), interactions azote×topographie (NXTOP*, N2XTOP*), et variables pédologiques/spectrales (BV, SAT) avec leurs termes quadratiques et interactions croisées, formant typiquement la structure d'un modèle de réponse à l'azote spatialement hétérogène. OBS est un simple index d'observation, ignoré.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `N` | `numeric` | continuous | 0% |
| `N2` | `numeric` | continuous | 0% |
| `TOPO` | `integer` | count | 0% |
| `BV` | `numeric` | continuous | 0% |
| `BV2` | `numeric` | continuous | 0% |
| `NXBV` | `numeric` | continuous | 0% |
| `SAT` | `numeric` | continuous | 0% |
| `SAT2` | `numeric` | continuous | 0% |
| `NXSAT` | `numeric` | continuous | 0% |
| `BVXT2` | `numeric` | continuous | 0% |
| `BVXT3` | `numeric` | continuous | 0% |
| `BVXT4` | `numeric` | continuous | 0% |
| `BV2XT2` | `numeric` | continuous | 0% |
| `BV2XT3` | `numeric` | continuous | 0% |
| `BV2XT4` | `numeric` | continuous | 0% |
| `SATXT2` | `numeric` | continuous | 0% |
| `SATXT3` | `numeric` | continuous | 0% |
| `SATXT4` | `numeric` | continuous | 0% |
| `SAT2XT2` | `numeric` | continuous | 0% |
| `SAT2XT3` | `numeric` | continuous | 0% |
| `SAT2XT4` | `numeric` | continuous | 0% |
| `NXTOP2` | `integer` | count | 0% |
| `NXTOP3` | `integer` | count | 0% |
| `NXTOP4` | `integer` | count | 0% |
| `N2XTOP2` | `integer` | count | 0% |
| `N2XTOP3` | `integer` | count | 0% |
| `N2XTOP4` | `integer` | count | 0% |
| `TOP2` | `integer` | count | 0% |
| `TOP3` | `integer` | count | 0% |
| `TOP4` | `integer` | count | 0% |


### Formule — niveau publication

- formula_pub: yield ~ 1 + nitro + I(nitro^2)
- x_terms_pub: 1 + nitro + I(nitro^2)
- y_term_pub: yield
- Reference publication: Bongiovanni and Lowenberg-DeBoer (2000). Nitrogen management in corn with a spatial regression model. Proceedings of the Fifth International Conference on Precision Agriculture.

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: R_agridat_lasrosas.corn_lasrosas.corn
- Note: Formule identifiee via la documentation du package equivalent `R_agridat_lasrosas.corn_lasrosas.corn` -- meme jeu de donnees sous-jacent (propagation automatique Tache 3, a confirmer par revue manuelle).

### Formule — niveau systeme

- formula_used: yield ~ 1 + nitro + I(nitro^2)
- x_terms_used: 1 + nitro + I(nitro^2)
- y_term_used: yield

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.lasrosas`
- Dataset name: geodatasets::lasrosas
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
  existing_model_found: false
  equation_text: "yield ~ 1 + nitro + I(nitro^2) (referencee dans catalogue)"
  equation_family: unknown
  model_family: "n/a"
  source_type: unknown
  source_ref: "Bongiovanni and Lowenberg-DeBoer (2000). Nitrogen management in corn with a spatial regression model. Proceedings of the Fifth International Conference on Precision Agriculture."
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 1738
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-63.8489, -63.8418], y [-33.0523, -33.0501] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32720 (UTM Zone 20S (EPSG:32720)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/geodatasets/
- License open: yes
- Reproducibility status: available via package Python `geodatasets`
- Code available: yes (package examples and vignettes)
- Repository: python-package

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`
