---
title: Python_geodatasets_geoda.home_sales
type: dataset
created: 2026-07-10
updated: 2026-07-10
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

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: pending

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: Formule systeme proposee automatiquement pour benchmark spatial ; ne pas confondre avec une formule publiee.
### Formule — niveau systeme

- formula_used: price ~ bedrooms + bathrooms + sqft_liv + sqft_lot + floors + waterfront + view + condition
- x_terms_used: bedrooms + bathrooms + sqft_liv + sqft_lot + floors + waterfront + view + condition
- y_term_used: price


### Formules candidates — niveau systeme

- formula_candidate_1: price ~ bedrooms + bathrooms + sqft_liv + sqft_lot + floors + waterfront + view + condition
- formula_candidate_1_role: recommended_default
- formula_candidate_2: price ~ bedrooms + bathrooms + sqft_liv + sqft_lot
- formula_candidate_2_role: alternative_specification
- recommended_formula: formula_candidate_1
- selection_status: generated_system_formula
- selection_reason: candidate_1 conserve la specification systeme actuelle pour comparer les estimateurs; candidate_2 est une variante parcimonieuse utile si colinearite, temps de calcul ou petits folds posent probleme.
- preprocessing_note: Les estimateurs comme xgboost, random_forest, gamboost et spboost peuvent reduire l'effet de certaines variables via leur mecanisme d'apprentissage ou de regularisation ; les modeles lineaires/spatiaux parametriques restent plus sensibles au choix explicite de X.

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
  existing_model_found: false
  equation_text: "null"
  equation_family: unknown
  model_family: "n/a"
  source_type: unknown
  source_ref: "null"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatio-temporel
- Structure: transactions_datees
- N observations: 21613
- T periods: 372
- Variable temporelle: date
- N/T profile: N_grand_T_grand
- Temporal note: dates presentes mais identifiant de ligne quasi unique; base de transactions datees, pas panel

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: transaction date (daily sales; 2014-05-02 to 2015-05-27)
- Spatial extent: x [-122.519, -121.315], y [47.1559, 47.7776] (EPSG:4326)
- Time range: 2014-05-02 to 2015-05-27
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

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - 21 436 identifiants de vente uniques sur 21 613 lignes; 177 identifiants repetes, structure transactionnelle datee plutot que panel.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`
