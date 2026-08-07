---
title: R_gstat_jura_jura.val
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/R_gstat_jura_jura.val.rds
  - data/final_datasets/sf/R_gstat_jura_jura.pred.rds
tags: [dataset, r-package, spatial, point]
---

The jura data set from Pierre Goovaerts' book (see references below). It contains four ‘data.frame’s: prediction.dat, validation.dat and transect.dat and juragrid.dat, and three ‘data.frame’s with consistently coded land use and rock type factors, as well as geographic coordinates. The examples below show how to transform these into spatial (sp) ob...

## Description du jeu de donnees

- Topic: agriculture / rendement ou experimentation agronomique
- Observation unit: parcelle, placette experimentale ou observation agricole
- Observed population: observations agricoles documentees par le package source
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: The jura data set from Pierre Goovaerts' book (see references below). It contains four ‘data.frame’s: prediction.dat, validation.dat and transect.dat and juragrid.dat, and three ‘data.frame’s with consistently coded land use and rock type factors, as well as geographic coordinates. The examples below show how to transform these into spatial (sp) ob...
- Description source: package R `gstat`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Cd`, `Pb`, `Zn`, `Cu`, `Ni`, `Co`, `Cr`
- Candidate Y typology: continuous
- Candidate X variables: `Landuse`, `Rock`
- Candidate X typology: categorical
- Coordinates (x, y — excluded from X candidates): `Xloc`, `Yloc`, `long`, `lat`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Cd` | `numeric` | continuous | [0.325, 3.78] | 0% |
| `Pb` | `numeric` | continuous | [18.68, 300] | 0% |
| `Zn` | `numeric` | continuous | [25, 259.84] | 0% |
| `Cu` | `numeric` | continuous | [3.552, 154.6] | 0% |
| `Ni` | `numeric` | continuous | [1.98, 43.68] | 0% |
| `Co` | `numeric` | continuous | [1.652, 20.6] | 0% |
| `Cr` | `numeric` | continuous | [3.32, 70] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les concentrations en métaux lourds (Cd, Pb, Zn, Cu, Ni, Co, Cr) sont des variables réponses classiques en géostatistique environnementale, chacune pouvant être la cible d'une modélisation spatiale. Landuse et Rock sont des covariables catégorielles explicatives naturelles (facteurs contrôlant la distribution des métaux dans le sol), et ne constituent pas des cibles de prédiction pertinentes.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Landuse` | `factor` | categorical | 0% |
| `Rock` | `factor` | categorical | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Goovaerts, P. (1997) Geostatistics for Natural Resources Evaluation. Oxford University Press, Applied Geostatistics Series, New York, 483 p. [Appendix C describes and provides the Jura data set]

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d'estimation: formule candidate generee par le systeme
- Correspondance Python/R: aucune identifiee
- Note: Aucune formule publiee n'a ete confirmee; deux formules candidates ont ete produites par le systeme et la formule recommandee est reportee dans formula_used.
### Formule — niveau systeme

- formula_used: Cd ~ Landuse + Rock
- x_terms_used: Landuse + Rock
- y_term_used: Cd

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
    formula: "Cd ~ Landuse + Rock"
    response: "Cd"
    predictors: ["Landuse", "Rock"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `R_gstat_jura_jura.val`
- Dataset name: gstat::jura
- Source family: r-package
- Source: package R `gstat` (version 2.1.6)
- Source URL: https://CRAN.R-project.org/package=gstat
- Dataset DOI: none
- Publication DOI: pending
- Year: 2003

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: Cd ~ Landuse + Rock
  equation_family: regression_candidate
  model_family: spatial_regression_candidate
  source_type: generated_system_formula
  source_ref: data/manifests/datasets/proposed_formula_used_audit.csv
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 100
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [6.8258, 6.8813], y [47.1161, 47.1589] (EPSG:4326, via documentation)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326 (source: documentation du package, .rds sans CRS embarque)
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2.0)
- License URL: https://CRAN.R-project.org/package=gstat
- License open: yes
- Reproducibility status: available via package R `gstat`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Fusion des sources et variantes

Cette fiche est la fiche canonique du cas d'etude Jura. Elle fusionne les objets `jura.val` et `jura.pred` du package `gstat`, qui forment deux volets complementaires d'un meme cas d'etude geostatistique.

### Sources fusionnees

| Ancienne fiche | Source package | Objet source | Artefact local | Role |
|---|---|---|---|---|
| `R_gstat_jura_jura.val` | gstat | `jura.val` | `data/final_datasets/sf/R_gstat_jura_jura.val.rds` | fiche canonique conservee |
| `R_gstat_jura_jura.pred` | gstat | `jura.pred` | `data/final_datasets/sf/R_gstat_jura_jura.pred.rds` | grille ou volet de prediction integre |

### Elements communs

- Meme source package: `gstat`.
- Meme cas d'etude Jura pour des exemples geostatistiques.
- Les deux objets servent ensemble a l'apprentissage et/ou a la prediction spatiale.

### Elements non communs

- `jura.val` porte les observations de validation.
- `jura.pred` porte le support de prediction; ce n'est pas un dataset empirique independant.

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: CANDIDATE - formule systeme proposee, sans source publication confirmee.
- CRS: WARN - CRS absent du `.rds` source ; EPSG:4326 extrait de la documentation et reporte dans le Bloc 5.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: FUSED - fiche commune pour `R_gstat_jura_jura.val` et `R_gstat_jura_jura.pred`; autres fichiers apparentes non fusionnes ici: R_gstat_jura_prediction.dat, R_gstat_jura_validation.dat.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2.0)).

## Related Pages

- Source: package R `gstat`
- Duplicate/version candidate: [[R_gstat_jura_prediction.dat]]
- Duplicate/version candidate: [[R_gstat_jura_validation.dat]]
