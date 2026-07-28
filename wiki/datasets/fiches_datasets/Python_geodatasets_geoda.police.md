---
title: Python_geodatasets_geoda.police
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.police.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`police`).

## Description du jeu de donnees

- Topic: criminalite urbaine
- Observation unit: quartier, zone urbaine ou evenement de police selon la documentation source
- Observed population: unites spatiales ou evenements lies a la criminalite
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`police`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `CRIME`, `POLICE`
- Candidate Y typology: count
- Candidate X variables: `POP`, `INC`, `UNEMP`, `OWN`, `COLLEGE`, `WHITE`, `COMMUTE`, `TAX`, `TRANSFER`, `AREA`, `PERIMETER`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `CNTY_ID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `CRIME` | `integer` | count | [5, 1739] | 0% |
| `POLICE` | `integer` | count | [49, 10971] | 0% |


> Selection Y/X (claude-sonnet-4-6) : CRIME (nombre de crimes) et POLICE (effectifs policiers) sont les variables réponses naturelles dans un dataset 'police' à vocation criminologique/sécuritaire. Les variables socio-économiques (INC, UNEMP, OWN, COLLEGE, WHITE, COMMUTE, TAX, TRANSFER), démographiques (POP) et morphologiques (AREA, PERIMETER) constituent des covariables explicatives pertinentes ; les codes FIPS, noms et identifiants administratifs sont ignorés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `POP` | `integer` | count | 0% |
| `INC` | `integer` | count | 0% |
| `UNEMP` | `integer` | count | 0% |
| `OWN` | `integer` | count | 0% |
| `COLLEGE` | `integer` | count | 0% |
| `WHITE` | `integer` | count | 0% |
| `COMMUTE` | `integer` | count | 0% |
| `TAX` | `integer` | count | 0% |
| `TRANSFER` | `integer` | count | 0% |
| `AREA` | `numeric` | rate | 0% |
| `PERIMETER` | `numeric` | continuous | 0% |


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

- formula_used: CRIME ~ POP + INC + UNEMP + OWN + COLLEGE + WHITE + COMMUTE + TAX
- x_terms_used: POP + INC + UNEMP + OWN + COLLEGE + WHITE + COMMUTE + TAX
- y_term_used: CRIME

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.police`
- Dataset name: geodatasets::police
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
  equation_text: CRIME ~ POP + INC + UNEMP + OWN + COLLEGE + WHITE + COMMUTE + TAX
  equation_family: regression_candidate
  model_family: spatial_regression_candidate
  source_type: generated_system_formula
  source_ref: data/manifests/datasets/proposed_formula_used_audit.csv
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 82
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-91.3314, -88.2216], y [30.4225, 34.932] (EPSG:4326)
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
- Formula: CANDIDATE - formule systeme proposee, sans source publication confirmee.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`
