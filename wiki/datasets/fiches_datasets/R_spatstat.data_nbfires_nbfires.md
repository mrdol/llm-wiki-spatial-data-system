---
title: R_spatstat.data_nbfires_nbfires
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/R_spatstat.data_nbfires_nbfires.rds
tags: [dataset, r-package, spatial, point]
---

Point patterns created from yearly records, provided by the New Brunswick Department of Natural Resources, of all fires falling under their jurisdiction for the years 1987 to 2003 inclusive (with the year 1988 omitted until further notice).

## Description du jeu de donnees

- Topic: dataset spatial spatio-temporel
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: dimension temporelle structurelle detectee
- Source description: Point patterns created from yearly records, provided by the New Brunswick Department of Natural Resources, of all fires falling under their jurisdiction for the years 1987 to 2003 inclusive (with the year 1988 omitted until further notice).
- Description source: package R `spatstat.data`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `fnl.size`
- Candidate Y typology: continuous
- Candidate X variables: `year`, `fire.type`, `dis.julian`, `out.julian`, `cause`, `ign.src`
- Candidate X typology: categorical, continuous
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `fnl.size` | `numeric` | continuous | [0, 4871] | 0% |


> Selection Y/X (claude-sonnet-4-6) : La taille finale du feu (fnl.size) est la variable réponse naturelle pour modéliser l'intensité/étendue des incendies. Les covariables explicatives incluent l'année, le type de feu, les dates julienne de découverte et d'extinction (proxy de durée), la cause et la source d'ignition ; la colonne T est ignorée car trop peu informative sans contexte clair.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `year` | `factor` | categorical | 0% |
| `fire.type` | `factor` | categorical | 0% |
| `dis.julian` | `numeric` | continuous | 1.6% |
| `out.julian` | `numeric` | continuous | 0.4% |
| `cause` | `factor` | categorical | 0% |
| `ign.src` | `factor` | categorical | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Turner, Rolf (2009) Point patterns of forest fire locations. Environmental and Ecological Statistics, 16, 197–223.

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d'estimation: formule candidate generee par le systeme
- Correspondance Python/R: aucune identifiee
- Note: Aucune formule publiee n'a ete confirmee; deux formules candidates ont ete produites par le systeme et la formule recommandee est reportee dans formula_used.
### Formule — niveau systeme

- formula_used: fnl.size ~ year + fire.type + dis.julian + out.julian + cause + ign.src
- x_terms_used: year + fire.type + dis.julian + out.julian + cause + ign.src
- y_term_used: fnl.size

## Bloc 2 — Identification et DOI

- Dataset ID: `R_spatstat.data_nbfires_nbfires`
- Dataset name: spatstat.data::nbfires
- Source family: r-package
- Source: package R `spatstat.data` (version 3.1.9)
- Source URL: https://CRAN.R-project.org/package=spatstat.data
- Dataset DOI: none
- Publication DOI: 10.1007/s10651-007-0085-1
- Year: 2017

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: fnl.size ~ year + fire.type + dis.julian + out.julian + cause + ign.src
  equation_family: regression_candidate
  model_family: spatial_regression_candidate
  source_type: generated_system_formula
  source_ref: data/manifests/datasets/proposed_formula_used_audit.csv
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatio-temporel
- Structure: panel
- N observations: 7108
- T periods: 16
- Variable temporelle: year
- N/T profile: N_grand_T_grand
- Temporal note: dimension temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: pending inspection
- Spatial extent: x [13.194, 988.4683], y [5.4899, 956.1334] (CRS unknown)
- Time range: pending inspection
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://CRAN.R-project.org/package=spatstat.data
- License open: yes
- Reproducibility status: available via package R `spatstat.data`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: CANDIDATE - formule systeme proposee, sans source publication confirmee.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2)).

## Related Pages

- Source: package R `spatstat.data`
