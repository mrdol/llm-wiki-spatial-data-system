---
title: Python_geodatasets_geoda.nyc
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.nyc.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`nyc`).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`nyc`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `rent2008`, `rentpct08`, `kids2009`, `pubast00`, `hhsiz08`
- Candidate Y typology: count, continuous
- Candidate X variables: `forhis06`, `forhis07`, `forhis08`, `forhis09`, `forwh06`, `forwh07`, `forwh08`, `forwh09`, `hhsiz1990`, `hhsiz00`, `hhsiz02`, `hhsiz05`, `kids2000`, `kids2005`, `kids2006`, `kids2007`, `kids2008`, `rent2002`, `rent2005`, `rentpct02`, `rentpct05`, `pubast90`, `yrhom02`, `yrhom05`, `yrhom08`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `code`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `rent2008` | `integer` | count | [0, 2900] | 0% |
| `rentpct08` | `numeric` | continuous | [0, 47.3805] | 0% |
| `kids2009` | `numeric` | continuous | [0, 48.1308] | 0% |
| `pubast00` | `numeric` | continuous | [0.8981, 23.4318] | 0% |
| `hhsiz08` | `numeric` | continuous | [1.5443, 3.2223] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables les plus récentes (rent2008, rentpct08, kids2009, pubast00, hhsiz08) sont retenues comme cibles plausibles car elles représentent des outcomes socio-économiques d'intérêt (loyer, part d'enfants, aide publique, taille du ménage) à la date la plus récente du dataset. Les séries temporelles antérieures et les variables structurelles (composition ethnique, durée de résidence) constituent des covariables explicatives naturelles ; name, subborough et bor_subb sont ignorés car purement administratifs/géographiques.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `forhis06` | `numeric` | continuous | 0% |
| `forhis07` | `numeric` | continuous | 0% |
| `forhis08` | `numeric` | continuous | 0% |
| `forhis09` | `numeric` | continuous | 0% |
| `forwh06` | `numeric` | continuous | 0% |
| `forwh07` | `numeric` | continuous | 0% |
| `forwh08` | `numeric` | continuous | 0% |
| `forwh09` | `numeric` | continuous | 0% |
| `hhsiz1990` | `numeric` | continuous | 0% |
| `hhsiz00` | `numeric` | continuous | 0% |
| `hhsiz02` | `numeric` | continuous | 0% |
| `hhsiz05` | `numeric` | continuous | 0% |
| `kids2000` | `numeric` | continuous | 0% |
| `kids2005` | `numeric` | continuous | 0% |
| `kids2006` | `numeric` | continuous | 0% |
| `kids2007` | `numeric` | continuous | 0% |
| `kids2008` | `numeric` | continuous | 0% |
| `rent2002` | `integer` | count | 0% |
| `rent2005` | `integer` | count | 0% |
| `rentpct02` | `numeric` | continuous | 0% |
| `rentpct05` | `numeric` | continuous | 0% |
| `pubast90` | `numeric` | continuous | 0% |
| `yrhom02` | `numeric` | continuous | 0% |
| `yrhom05` | `numeric` | continuous | 0% |
| `yrhom08` | `numeric` | continuous | 0% |


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
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.nyc`
- Dataset name: geodatasets::nyc
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
- N observations: 55
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-74.1942, -73.736], y [40.5369, 40.891] (EPSG:4326)
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
- Formula: PENDING - formule publication non encore etablie.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`
