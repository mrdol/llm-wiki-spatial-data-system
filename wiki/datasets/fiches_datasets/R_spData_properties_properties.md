---
title: R_spData_properties_properties
type: dataset
created: 2026-07-10
updated: 2026-07-10
sources:
  - data/final_datasets/sf/R_spData_properties_properties.rds
tags: [dataset, r-package, spatial, point]
---

A dataset of apartments in the municipality of Athens for 2017. Point location of the properties is given together with their main characteristics and the distance to the closest metro/train station.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `price`, `prpsqm`
- Candidate Y typology: count, continuous
- Candidate X variables: `size`, `age`, `dist_metro`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `id`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `price` | `integer` | count | [8000, 5500000] | 0% |
| `prpsqm` | `numeric` | continuous | [207.5472, 9166.6667] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Le prix total (price) et le prix au m² (prpsqm) sont les variables réponses naturelles d'un modèle hédonique immobilier. La taille, l'âge du bien et la distance au métro sont des covariables explicatives classiques de la valeur immobilière ; noter que price et prpsqm ne doivent pas être utilisés simultanément comme Y car ils sont redondants (l'un est dérivé de l'autre et de size).

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `size` | `integer` | count | 0% |
| `age` | `numeric` | continuous | 0% |
| `dist_metro` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Dong, G. and Harris, R. (2014) Spatial Autoregressive Models for Geographically Hierarchical Data Structures. Geographical Analysis.

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: Formule systeme proposee automatiquement pour benchmark spatial ; ne pas confondre avec une formule publiee.
### Formule — niveau systeme

- formula_used: price ~ size + age + dist_metro
- x_terms_used: size + age + dist_metro
- y_term_used: price


### Formules candidates — niveau systeme

- formula_candidate_1: price ~ size + age + dist_metro
- formula_candidate_1_role: recommended_default
- formula_candidate_2: price ~ size + age + dist_metro
- formula_candidate_2_role: alternative_specification
- recommended_formula: formula_candidate_1
- selection_status: generated_system_formula
- selection_reason: une seule specification distincte est disponible avec les variables candidates actuelles; candidate_2 repete candidate_1 en attendant une revue manuelle.
- preprocessing_note: Les estimateurs comme xgboost, random_forest, gamboost et spboost peuvent reduire l'effet de certaines variables via leur mecanisme d'apprentissage ou de regularisation ; les modeles lineaires/spatiaux parametriques restent plus sensibles au choix explicite de X.

## Bloc 2 — Identification et DOI

- Dataset ID: `R_spData_properties_properties`
- Dataset name: spData::properties
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
  equation_text: "null"
  equation_family: unknown
  model_family: "n/a"
  source_type: unknown
  source_ref: "Dong, G. and Harris, R. (2014) Spatial Autoregressive Models for Geographically Hierarchical Data Structures. Geographical Analysis."
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 1000
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [23.7047, 23.779], y [37.9514, 38.0272] (EPSG:4326)
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
- Formula: PENDING - formule publication non encore etablie.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (CC0).

## Related Pages

- Source: package R `spData`
