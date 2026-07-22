---
title: Python_geodatasets_geoda.lansing2
type: dataset
created: 2026-07-10
updated: 2026-07-10
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.lansing2.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`lansing2`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `PCTGRO`, `PCTCSE`, `EMP01`, `EST01`
- Candidate Y typology: continuous, count
- Candidate X variables: `POP2001`, `EST98`, `EMP98`, `MAN98`, `MAN98_12`, `MAN98_39`, `MAN01`, `OFF98`, `OFF98_12`, `OFF98_39`, `INFO98`, `INFO98_12`, `INFO98_39`, `NUMSEC`, `PCTIME`, `INDEX`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `CBSA_CODE`, `ID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PCTGRO` | `numeric` | continuous | [-29.41, 18.48] | 0% |
| `PCTCSE` | `numeric` | continuous | [-31.22, 15.46] | 0% |
| `EMP01` | `integer` | count | [7, 25590] | 0% |
| `EST01` | `integer` | count | [1, 1138] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables de croissance/changement (PCTGRO, PCTCSE) et les niveaux d'emploi/établissements en 2001 (EMP01, EST01) sont des cibles naturelles pour modéliser la dynamique économique locale. Les données de 1998 (emplois, établissements, secteurs manufacturier, bureaux, information), la population, le nombre de secteurs et l'indice composite servent de covariables explicatives ; les colonnes US-level à valeur constante (MAN98US, OFF98US, etc.) et PAY98/PAY01 (character non exploitable) sont écartées car redondantes ou inutilisables.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `POP2001` | `integer` | count | 0% |
| `EST98` | `integer` | count | 0% |
| `EMP98` | `integer` | count | 0% |
| `MAN98` | `integer` | count | 0% |
| `MAN98_12` | `integer` | count | 0% |
| `MAN98_39` | `integer` | count | 0% |
| `MAN01` | `integer` | count | 0% |
| `OFF98` | `integer` | count | 0% |
| `OFF98_12` | `integer` | count | 0% |
| `OFF98_39` | `integer` | count | 0% |
| `INFO98` | `integer` | count | 0% |
| `INFO98_12` | `integer` | count | 0% |
| `INFO98_39` | `integer` | count | 0% |
| `NUMSEC` | `integer` | count | 0% |
| `PCTIME` | `numeric` | continuous | 0% |
| `INDEX` | `integer` | count | 0% |


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

- formula_used: PCTGRO ~ POP2001 + EST98 + EMP98 + MAN98 + MAN98_12 + MAN98_39 + MAN01 + OFF98
- x_terms_used: POP2001 + EST98 + EMP98 + MAN98 + MAN98_12 + MAN98_39 + MAN01 + OFF98
- y_term_used: PCTGRO

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.lansing2`
- Dataset name: geodatasets::lansing2
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
- N observations: 46
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-85.1339, -84.1783], y [42.3923, 43.1231] (EPSG:4326)
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
