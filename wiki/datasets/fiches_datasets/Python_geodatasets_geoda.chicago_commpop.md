---
title: Python_geodatasets_geoda.chicago_commpop
type: dataset
created: 2026-07-10
updated: 2026-07-10
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.chicago_commpop.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`chicago_commpop`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `POP2010`, `POPCH`, `POPPERCH`, `popplus`, `popneg`
- Candidate Y typology: count, continuous, binary
- Candidate X variables: `POP2000`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `NID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `POP2010` | `integer` | count | [2876, 98514] | 0% |
| `POPCH` | `integer` | count | [-19013, 12895] | 0% |
| `POPPERCH` | `numeric` | continuous | [-33.9178, 124.9448] | 0% |
| `popplus` | `integer` | binary | {0, 1} | 0% |
| `popneg` | `integer` | binary | {0, 1} | 0% |


> Selection Y/X (claude-sonnet-4-6) : POP2010, POPCH, POPPERCH, popplus et popneg sont des variables réponses naturelles (population récente, variation absolue/relative, indicateurs binaires de croissance/déclin) que l'on cherche typiquement à expliquer ou prédire. POP2000 constitue la covariable explicative la plus logique, servant de baseline temporelle pour expliquer l'évolution démographique ; 'community' est un libellé géographique ignoré.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `POP2000` | `integer` | count | 0% |


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

- formula_used: POP2010 ~ POP2000
- x_terms_used: POP2000
- y_term_used: POP2010


### Formules candidates — niveau systeme

- formula_candidate_1: POP2010 ~ POP2000
- formula_candidate_1_role: recommended_default
- formula_candidate_2: POP2010 ~ POP2000
- formula_candidate_2_role: alternative_specification
- recommended_formula: formula_candidate_1
- selection_status: generated_system_formula
- selection_reason: une seule specification distincte est disponible avec les variables candidates actuelles; candidate_2 repete candidate_1 en attendant une revue manuelle.
- preprocessing_note: Les estimateurs comme xgboost, random_forest, gamboost et spboost peuvent reduire l'effet de certaines variables via leur mecanisme d'apprentissage ou de regularisation ; les modeles lineaires/spatiaux parametriques restent plus sensibles au choix explicite de X.

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.chicago_commpop`
- Dataset name: geodatasets::chicago_commpop
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

- Data type: spatial
- Structure: coupe_transversale
- N observations: 77
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-87.9047, -87.535], y [41.6655, 42.0105] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32616 (UTM Zone 16N (EPSG:32616)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

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
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`
