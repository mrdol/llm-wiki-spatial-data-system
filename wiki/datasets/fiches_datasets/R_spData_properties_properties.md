---
title: R_spData_properties_properties
type: dataset
created: 2026-08-15
updated: 2026-09-15
sources:
  - data/final_datasets/sf/R_spData_properties_properties.rds
tags: [dataset, r-package, spatial, point]
---

A dataset of apartments in the municipality of Athens for 2017. Point location of the properties is given together with their main characteristics and the distance to the closest metro/train station.

## Description du jeu de donnees

- Topic: immobilier / prix des logements
- Observation unit: logement, transaction immobiliere ou zone residentielle selon la documentation source
- Observed population: marche immobilier documente par le package source
- Geographic context: Etendue mesuree dans le RDS : x [23.704688991728, 23.778956991646], y [37.95137598729, 38.027182987125]; CRS EPSG:4326.
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: A dataset of apartments in the municipality of Athens for 2017. Point location of the properties is given together with their main characteristics and the distance to the closest metro/train station.
- Description source: package R `spData`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `price`, `prpsqm`
- Candidate Y typology: continuous
- Candidate X variables: `size`, `age`, `dist_metro`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `id`
- Variables inspected: yes (auto — export_sf_metadata.R ; correction 2026-09-15, verification tools::Rd_db("spData") + package HSAR)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `price` | `integer` | continuous | [8000, 5500000] | 0% |
| `prpsqm` | `numeric` | continuous | [207.5472, 9166.6667] | 0% |

> Correction 2026-09-15 (mode production de secours, tools::Rd_db("spData")) : `price` (prix total en euros) et `size` (Detail X ci-dessous, surface en m2) etaient a tort typees "count" ; ce sont des grandeurs continues (monetaire, surface), pas des denombrements.

> Selection Y/X (claude-sonnet-4-6) : Le prix total (price) et le prix au m² (prpsqm) sont les variables réponses naturelles d'un modèle hédonique immobilier. La taille, l'âge du bien et la distance au métro sont des covariables explicatives classiques de la valeur immobilière ; noter que price et prpsqm ne doivent pas être utilisés simultanément comme Y car ils sont redondants (l'un est dérivé de l'autre et de size).

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `size` | `integer` | continuous | 0% |
| `age` | `numeric` | continuous | 0% |
| `dist_metro` | `numeric` | continuous | 0% |

### Formule — niveau publication

- formula_pub: prpsqm ~ size + age + greensp + population + museums + airbnb
- x_terms_pub: size, age, greensp, population, museums, airbnb
- y_term_pub: prpsqm
- Reference publication: Formule reelle verifiee dans la vignette officielle du package R `HSAR` (Hierarchical Spatial Autoregressive Model, CRAN, https://cran.r-project.org/web/packages/HSAR/vignettes/HSAR.html, verifiee 2026-09-15) : `res.formula <- prpsqm ~ size + age + greensp + population + museums + airbnb` ; `res <- hsar(res.formula, data=model.data, W=W, M=M, Delta=Delta, burnin=500, Nsim=1000)`. `properties` ET `depmunic` sont les deux jeux de donnees de demonstration du package HSAR, qui implemente la methodologie de Dong, G. & Harris, R. (2015), "Spatial Autoregressive Models for Geographically Hierarchical Data Structures," Geographical Analysis 47(2):173-191, DOI 10.1111/gean.12049 (Crossref-verifie ; annee corrigee de 2014 vers 2015, erreur deja presente dans une version anterieure de cette fiche). Cette formule est un modele HIERARCHIQUE a deux niveaux : `prpsqm`, `size`, `age` proviennent de `properties` (niveau 1, logement) ; `greensp` (espaces verts, m2), `population`, `museums`, `airbnb` proviennent de `depmunic` (niveau 2, departement municipal, 7 unites), rattaches a chaque logement par jointure spatiale (`sf::st_join`) selon la vignette. IMPORTANT : `depmunic` a ete supprime du corpus wiki lors d'un nettoyage anterieur (lot des "29 fiches package de faible qualite", 2026-09-XX) -- les 4 covariables de niveau 2 (greensp/population/museums/airbnb) ne sont donc PAS disponibles dans cette fiche seule ; formula_used ci-dessous se limite honnetement aux variables reellement presentes dans `properties`.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: verbatim
- Methode d'estimation: Hierarchical SAR (hsar()), formule confirmee verbatim dans la vignette officielle du package HSAR
- Correspondance Python/R: aucune identifiee
- Note: Verification 2026-09-15 (mode production de secours) : la reference "Dong & Harris (2014)" deja presente dans une version anterieure de cette fiche n'etait pas fabriquee -- confirmee reelle et pertinente via recherche web : `properties`/`depmunic` sont precisement les jeux de donnees de demonstration du package `HSAR`, qui implemente cette methodologie. La vignette officielle du package (lue integralement) fournit l'equation exacte et le code d'execution complet. Correction de l'annee de publication (2015, pas 2014, DOI Crossref-verifie).

### Formule — niveau systeme

- formula_used: prpsqm ~ size + age
- Selected Y evidence: Sous-ensemble honnete de formula_pub limite aux variables reellement presentes dans cette fiche (properties seule) ; greensp/population/museums/airbnb necessitent depmunic (supprime du corpus), voir Reference publication.
- Selected Y typology: continuous
- x_terms_used: size + age
- y_term_used: prpsqm

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "prpsqm ~ size + age + greensp + population + museums + airbnb"
    response: "prpsqm"
    predictors: ["size", "age", "greensp", "population", "museums", "airbnb"]
    role: "paper_main_specification"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Vignette officielle package HSAR (CRAN) + Dong & Harris (2015), Geographical Analysis 47(2):173-191, DOI 10.1111/gean.12049 -- formule hierarchique verbatim, necessite depmunic (supprime du corpus) pour les covariables de niveau 2"
    estimator_context: ["hsar", "mgwrsar_gwr"]
    status: "confirmed_requires_companion_dataset"

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
    formula: "prpsqm ~ size + age + dist_metro"
    response: "prpsqm"
    predictors: ["size", "age", "dist_metro"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

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

- Modele niveau 1 (tache): regression
- Modele niveau 2 (famille): spatial_autoregressive_hierarchique
- Modele niveau 3 (variante): HSAR (Hierarchical Spatial Autoregressive Model, package R `HSAR`)

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "prpsqm ~ size + age + greensp + population + museums + airbnb"
  equation_family: spatial_autoregressive_hierarchical
  model_family: "HSAR -- confirme verbatim par la vignette officielle du package HSAR"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Vignette HSAR (CRAN) ; Dong & Harris (2015), DOI 10.1111/gean.12049"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 1000
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

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

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "manual_review"
  benchmark_task: "regression_spatial_hierarchical_needs_companion_dataset"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "La formule reelle et verifiee (HSAR) necessite les covariables de niveau 2 du jeu de donnees compagnon `depmunic` (greensp, population, museums, airbnb), supprime du corpus wiki lors d'un nettoyage anterieur. Restaurer depmunic et effectuer la jointure spatiale (st_join) documentee dans la vignette HSAR avant promotion en tant que benchmark HSAR complet. Une formule partielle (prpsqm ~ size + age) reste utilisable avec les estimateurs standards en attendant."
  reason: "Formule publication verifiee et forte (vignette officielle du package), mais incomplete sans le jeu de donnees compagnon supprime -- revue manuelle requise pour decider de la restauration de depmunic ou du maintien d'une formule partielle."
```

- Decision: manual_review
- Manque principal: La formule reelle et verifiee (HSAR) necessite les covariables de niveau 2 du jeu de donnees compagnon `depmunic` (greensp, population, museums, airbnb), supprime du corpus wiki lors d'un nettoyage anterieur. Restaurer depmunic et effectuer la jointure spatiale (st_join) documentee dans la vignette HSAR avant promotion en tant que benchmark HSAR complet. Une formule partielle (prpsqm ~ size + age) reste utilisable avec les estimateurs standards en attendant.
- Raison: Formule publication verifiee et forte (vignette officielle du package), mais incomplete sans le jeu de donnees compagnon supprime -- revue manuelle requise pour decider de la restauration de depmunic ou du maintien d'une formule partielle.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes. Correction 2026-09-15 : price/size reclasses "count" -> "continuous".
- Formula: OK - formule confirmee verbatim dans la vignette officielle du package HSAR (2026-09-15) ; necessite le jeu de donnees compagnon `depmunic` (supprime du corpus) pour les covariables de niveau 2, documente honnetement.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (CC0).

## Related Pages

- Source: package R `spData`

## Curation documentée — 2026-09-07

Verification 2026-09-15 (mode production de secours, tools::Rd_db("spData") + recherche web approfondie) : la reference "Dong & Harris (2014)" deja presente etait suspectee non pertinente (le papier original de 2015 etudie des parcelles de terrain a Pekin, pas des appartements a Athenes) -- verification confirme qu'elle est en fait EXACTE et bien documentee : `properties` et `depmunic` sont precisement les jeux de donnees de demonstration du package R `HSAR` (Hierarchical Spatial Autoregressive Model), qui implemente la methodologie de cet article. La vignette officielle du package (lue integralement, https://cran.r-project.org/web/packages/HSAR/vignettes/HSAR.html) fournit l'equation exacte et le code complet : `prpsqm ~ size + age + greensp + population + museums + airbnb`, un modele hierarchique a deux niveaux (properties = niveau logement, depmunic = niveau departement municipal, 7 unites, rattachees par jointure spatiale st_join). Annee de publication corrigee (2015, pas 2014, DOI Crossref-verifie 10.1111/gean.12049). Limitation honnetement documentee : `depmunic` a ete supprime du corpus wiki lors d'un nettoyage anterieur ("29 fiches package de faible qualite") -- les covariables de niveau 2 ne sont donc pas disponibles ici ; formula_used se limite a prpsqm~size+age (sous-ensemble reel, pas invente). Correction typologique : price/size reclasses "count" -> "continuous".
