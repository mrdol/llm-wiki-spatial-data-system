---
title: Python_geodatasets_geoda.nyc_neighborhoods
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.nyc_neighborhoods.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`nyc_neighborhoods`).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`nyc_neighborhoods`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `UEMPRATE`, `struggling`, `poor`, `poororstru`, `gini`
- Candidate Y typology: rate, count, categorical
- Candidate X variables: `poptot`, `popover18`, `popinlabou`, `households`, `hispanic`, `african`, `asian`, `european`, `otherethni`, `mixed`, `onlybachel`, `onlycolleg`, `onlyhighsc`, `onlymaster`, `onlydoctor`, `onlylessth`, `onlyprofes`, `lessthanhi`, `withssi`, `withsocial`, `withpubass`, `comm_15_29`, `comm_30_44`, `comm_45_59`, `comm_60_89`, `comm90plus`, `medianinco`, `medianage`, `HHsize`, `male`, `female`, `boroname`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `cartodb_id`, `borocode`, `ntacode`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `UEMPRATE` | `numeric` | rate | [0, 0.5698] | 0% |
| `struggling` | `integer` | count | [0, 27502] | 0% |
| `poor` | `integer` | count | [0, 36334] | 0% |
| `poororstru` | `integer` | count | [0, 63836] | 0% |
| `gini` | `character` | categorical | None | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables Y candidates sont des indicateurs socio-économiques synthétiques de vulnérabilité ou d'inégalité à expliquer spatialement (taux de chômage, pauvreté, précarité, indice de Gini). Les variables X candidates couvrent la structure démographique (population, âge, genre), la composition ethnique, le niveau d'éducation, les transferts sociaux, les temps de trajet domicile-travail, le revenu médian et la taille des ménages — toutes covariables explicatives classiques en spatial ML ; les colonnes purement nominatives (ntaname, field_1) et les sous-totaux redondants (popunemplo, maleunempl, etc. déjà résumés dans UEMPRATE) sont ignorés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `poptot` | `integer` | count | 0% |
| `popover18` | `integer` | count | 0% |
| `popinlabou` | `integer` | count | 0% |
| `households` | `integer` | count | 0% |
| `hispanic` | `integer` | count | 0% |
| `african` | `integer` | count | 0% |
| `asian` | `integer` | count | 0% |
| `european` | `integer` | count | 0% |
| `otherethni` | `integer` | count | 0% |
| `mixed` | `integer` | count | 0% |
| `onlybachel` | `integer` | count | 0% |
| `onlycolleg` | `integer` | count | 0% |
| `onlyhighsc` | `integer` | count | 0% |
| `onlymaster` | `integer` | count | 0% |
| `onlydoctor` | `integer` | count | 0% |
| `onlylessth` | `integer` | count | 0% |
| `onlyprofes` | `integer` | count | 0% |
| `lessthanhi` | `integer` | count | 0% |
| `withssi` | `integer` | count | 0% |
| `withsocial` | `integer` | count | 0% |
| `withpubass` | `integer` | count | 0% |
| `comm_15_29` | `integer` | count | 0% |
| `comm_30_44` | `integer` | count | 0% |
| `comm_45_59` | `integer` | count | 0% |
| `comm_60_89` | `integer` | count | 0% |
| `comm90plus` | `integer` | count | 0% |
| `medianinco` | `character` | categorical | 0% |
| `medianage` | `character` | categorical | 0% |
| `HHsize` | `character` | categorical | 0% |
| `male` | `integer` | count | 0% |
| `female` | `integer` | count | 0% |
| `boroname` | `character` | categorical | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: pending

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d'estimation: formule candidate generee par le systeme
- Correspondance Python/R: aucune identifiee
- Note: Aucune formule publiee n'a ete confirmee; deux formules candidates ont ete produites par le systeme et la formule recommandee est reportee dans formula_used.
### Formule — niveau systeme

- formula_used: UEMPRATE ~ poptot + popover18 + popinlabou + households + hispanic + african + asian + european
- x_terms_used: poptot + popover18 + popinlabou + households + hispanic + african + asian + european
- y_term_used: UEMPRATE

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "simple_baseline"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

  multivariate_constrained:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "paper_main_specification"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

  ml_or_selected:
    formula: "UEMPRATE ~ poptot + popover18 + popinlabou + households + hispanic + african + asian + european"
    response: "UEMPRATE"
    predictors: ["poptot", "popover18", "popinlabou", "households", "hispanic", "african", "asian", "european"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.nyc_neighborhoods`
- Dataset name: geodatasets::nyc_neighborhoods
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
  equation_text: UEMPRATE ~ poptot + popover18 + popinlabou + households + hispanic + african + asian + european
  equation_family: regression_candidate
  model_family: spatial_regression_candidate
  source_type: generated_system_formula
  source_ref: data/manifests/datasets/proposed_formula_used_audit.csv
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 195
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-74.2295, -73.7091], y [40.5273, 40.8999] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32618 (UTM Zone 18N (EPSG:32618)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

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
- Formula: CANDIDATE - formule systeme proposee, sans source publication confirmee.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`
