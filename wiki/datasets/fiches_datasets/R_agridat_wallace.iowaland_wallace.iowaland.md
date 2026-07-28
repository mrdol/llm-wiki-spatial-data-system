---
title: R_agridat_wallace.iowaland_wallace.iowaland
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/R_agridat_wallace.iowaland_wallace.iowaland.rds
tags: [dataset, r-package, spatial, point]
---

Iowa farmland values by county in 1925

## Description du jeu de donnees

- Topic: agriculture / rendement ou experimentation agronomique
- Observation unit: parcelle, placette experimentale ou observation agricole
- Observed population: observations agricoles documentees par le package source
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Iowa farmland values by county in 1925
- Description source: package R `agridat`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `fedval`, `stval`
- Candidate Y typology: count
- Candidate X variables: `yield`, `corn`, `grain`, `untillable`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `lat`, `long`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `fedval` | `integer` | count | [66, 173] | 0% |
| `stval` | `integer` | count | [49, 161] | 0% |


> Selection Y/X (claude-sonnet-4-6) : fedval (valeur fédérale) et stval (valeur d'état) sont les estimations de la valeur des terres agricoles, naturelles cibles de modélisation. yield (rendement), corn (part en maïs), grain (part en céréales) et untillable (part non cultivable) sont des caractéristiques agronomiques du comté utilisables comme covariables explicatives. county et fips sont des identifiants administratifs à ignorer.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `yield` | `integer` | count | 0% |
| `corn` | `integer` | count | 0% |
| `grain` | `integer` | count | 0% |
| `untillable` | `integer` | count | 0% |


### Formule — niveau publication

- formula_pub: pending (referencee dans catalogue)
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Larry Winner. Spatial Data Analysis. https://www.stat.ufl.edu/~winner/data/iowaland.txt

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d'estimation: formule candidate generee par le systeme
- Correspondance Python/R: aucune identifiee
- Note: Aucune formule publiee n'a ete confirmee; deux formules candidates ont ete produites par le systeme et la formule recommandee est reportee dans formula_used.
### Formule — niveau systeme

- formula_used: fedval ~ yield + corn + grain + untillable
- x_terms_used: yield + corn + grain + untillable
- y_term_used: fedval

## Bloc 2 — Identification et DOI

- Dataset ID: `R_agridat_wallace.iowaland_wallace.iowaland`
- Dataset name: agridat::wallace.iowaland
- Source family: r-package
- Source: package R `agridat` (version 1.26)
- Source URL: https://CRAN.R-project.org/package=agridat
- Dataset DOI: none
- Publication DOI: pending
- Year: 2011

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: fedval ~ yield + corn + grain + untillable
  equation_family: regression_candidate
  model_family: spatial_regression_candidate
  source_type: generated_system_formula
  source_ref: data/manifests/datasets/proposed_formula_used_audit.csv
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 99
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-96.216, -90.534], y [40.645, 43.378] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL-2
- License URL: https://CRAN.R-project.org/package=agridat
- License open: yes
- Reproducibility status: available via package R `agridat`
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
- Reproducibility: OK - source package et licence renseignes (GPL-2).

## Related Pages

- Source: package R `agridat`
