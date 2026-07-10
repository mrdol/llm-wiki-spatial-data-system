---
title: Python_geodatasets_geoda.charleston2
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.charleston2.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`charleston2`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `INDEX`, `PCTGRO`, `PCTCSE`, `PCTIME`, `EMP01`, `PAY01`
- Candidate Y typology: count, continuous
- Candidate X variables: `POP2001`, `EST98`, `EMP98`, `PAY98`, `EST01`, `MAN98`, `MAN01`, `OFF98`, `OFF01`, `INFO98`, `INFO01`, `MAN98_12`, `MAN98_39`, `MAN01_12`, `MAN01_39`, `OFF98_12`, `OFF98_39`, `OFF01_12`, `OFF01_39`, `INFO98_12`, `INFO98_39`, `INFO01_12`, `INFO01_39`, `NUMSEC`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `CBSA_CODE`, `ID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `INDEX` | `integer` | count | [32, 75] | 0% |
| `PCTGRO` | `numeric` | continuous | [-16.67, 41.67] | 0% |
| `PCTCSE` | `numeric` | continuous | [-20.02, 37.07] | 0% |
| `PCTIME` | `numeric` | continuous | [-2.26, 2.81] | 0% |
| `EMP01` | `integer` | count | [8, 26428] | 0% |
| `PAY01` | `integer` | count | [201, 658214] | 0% |


> Selection Y/X (claude-sonnet-4-6) : INDEX (indice composite, plage 32-75) et les variables de croissance/changement (PCTGRO, PCTCSE, PCTIME) sont des cibles naturelles pour modéliser la dynamique économique locale ; EMP01 et PAY01 peuvent aussi servir de variables réponses pour l'emploi et la masse salariale. Les variables de structure économique par secteur (manufacturing, office, info) en 1998 et 2001, ainsi que la population et le nombre d'établissements, constituent des covariables explicatives pertinentes ; les colonnes à valeur constante (MAN98US, OFF98US, etc.) et les flags catégoriels sont ignorés comme non informatifs.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `POP2001` | `integer` | count | 0% |
| `EST98` | `integer` | count | 0% |
| `EMP98` | `integer` | count | 0% |
| `PAY98` | `integer` | count | 0% |
| `EST01` | `integer` | count | 0% |
| `MAN98` | `integer` | count | 0% |
| `MAN01` | `integer` | count | 0% |
| `OFF98` | `integer` | count | 0% |
| `OFF01` | `integer` | count | 0% |
| `INFO98` | `integer` | count | 0% |
| `INFO01` | `integer` | count | 0% |
| `MAN98_12` | `integer` | count | 0% |
| `MAN98_39` | `integer` | count | 0% |
| `MAN01_12` | `integer` | count | 0% |
| `MAN01_39` | `integer` | count | 0% |
| `OFF98_12` | `integer` | count | 0% |
| `OFF98_39` | `integer` | count | 0% |
| `OFF01_12` | `integer` | count | 0% |
| `OFF01_39` | `integer` | count | 0% |
| `INFO98_12` | `integer` | count | 0% |
| `INFO98_39` | `integer` | count | 0% |
| `INFO01_12` | `integer` | count | 0% |
| `INFO01_39` | `integer` | count | 0% |
| `NUMSEC` | `integer` | count | 0% |


### Formule — niveau publication

- formula_pub: none (aucune regression canonique documentee -- recherche manuelle exhaustive menee)
- x_terms_pub: none
- y_term_pub: none
- Reference publication: none (aucune source verifiable retrouvee)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: mauvais candidat
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: Aucune regression canonique documentee retrouvee dans la litterature ou la documentation du package pour ce jeu de donnees lors de la recherche manuelle exhaustive (web + sources primaires). [Revue Tache 4 (2026-07-02) : aucune analogie structurelle pertinente identifiee avec un bon candidat existant -- statut inchange plutot que forcer un rapprochement faible.] Raison : PCTIME/etablissements d'entreprise par secteur -- aucun bon candidat de la banque ne couvre ce domaine (economie des etablissements/emploi sectoriel).

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.charleston2`
- Dataset name: geodatasets::charleston2
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
  model_family: "unknown"
  source_type: unknown
  source_ref: "null"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 42
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_1

> **Correction metadonnees (Tache 2, juillet 2026)** — PCTIME (variable de taux/pourcentage, ex. part du temps de trajet) comptait 40 valeurs uniques sur 42 lignes et a ete prise a tort pour un axe temporel repete ; ce dataset est une coupe transversale de census tracts (croise avec le pattern PCTIME identique sur hickory2/lansing2).
## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-80.7892, -79.4579], y [32.5674, 33.4085] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32617 (UTM Zone 17N (EPSG:32617)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

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
