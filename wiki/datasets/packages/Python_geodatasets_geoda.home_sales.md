---
title: Python_geodatasets_geoda.home_sales
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.home_sales.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`home_sales`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `price`
- Candidate Y typology: continuous
- Candidate X variables: `bedrooms`, `bathrooms`, `sqft_liv`, `sqft_lot`, `floors`, `waterfront`, `view`, `condition`, `grade`, `sqft_above`, `sqft_basmt`, `yr_built`, `yr_renov`, `sqft_liv15`, `sqft_lot15`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `lat`, `long`, `X`, `Y`
- Identifier columns (excluded from X candidates): `id`, `zipcode`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `price` | `numeric` | continuous | [75000, 7700000] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Le prix de vente (`price`) est la variable réponse naturelle pour un dataset de transactions immobilières. Les caractéristiques physiques, structurelles et de qualité du bien (surface, pièces, étages, vue, condition, grade, ancienneté, rénovation, surfaces voisinage) constituent des covariables explicatives classiques pour modéliser ce prix. Les colonnes `date` et `T` sont ignorées car trop ambiguës ou purement administratives sans information exploitable directe.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `bedrooms` | `numeric` | continuous | 0% |
| `bathrooms` | `numeric` | continuous | 0% |
| `sqft_liv` | `numeric` | continuous | 0% |
| `sqft_lot` | `numeric` | continuous | 0% |
| `floors` | `numeric` | continuous | 0% |
| `waterfront` | `numeric` | binary | 0% |
| `view` | `numeric` | continuous | 0% |
| `condition` | `numeric` | continuous | 0% |
| `grade` | `numeric` | continuous | 0% |
| `sqft_above` | `numeric` | continuous | 0% |
| `sqft_basmt` | `numeric` | continuous | 0% |
| `yr_built` | `numeric` | continuous | 0% |
| `yr_renov` | `numeric` | continuous | 0% |
| `sqft_liv15` | `numeric` | continuous | 0% |
| `sqft_lot15` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: price~bs(x1)+bs(x2)+bs(x3)+bs(x4)+bs(x5)+fact_date (splines) et price~sqft_liv (SEM)
- x_terms_pub: bs(x1)+bs(x2)+bs(x3)+bs(x4)+bs(x5)+fact_date (splines) et price~sqft_liv (SEM)
- y_term_pub: price
- Reference publication: rstudio-pubs-static.s3.amazonaws.com/155304_cc51f448116744069664b35e7762999f.html ; arxiv.org/pdf/2507.07113

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: Splines / SEM (erreur spatiale)
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.home_sales`
- Dataset name: geodatasets::home_sales
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
  equation_text: "price~bs(x1)+bs(x2)+bs(x3)+bs(x4)+bs(x5)+fact_date (splines) et price~sqft_liv (SEM)"
  equation_family: spatial_error
  model_family: "Splines / SEM (erreur spatiale)"
  source_type: software_documentation
  source_ref: "rstudio-pubs-static.s3.amazonaws.com/155304_cc51f448116744069664b35e7762999f.html ; arxiv.org/pdf/2507.07113"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 21613
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_1

> **Correction metadonnees (Tache 2, juillet 2026)** — `date` est la date de vente propre a chaque transaction individuelle (King County house sales) — chaque ligne est une vente distincte, pas une unite spatiale suivie repetee dans le temps ; ce n'est pas un panel au sens N unites x T periodes. `date`/`fact_date` reste une covariable pertinente (utilisee comme terme dans la formule publiee) mais ne definit pas un axe T.
## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-122.519, -121.315], y [47.1559, 47.7776] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32610 (UTM Zone 10N (EPSG:32610)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

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
