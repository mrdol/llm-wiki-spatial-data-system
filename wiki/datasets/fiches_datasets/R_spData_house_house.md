---
title: R_spData_house_house
type: dataset
created: 2026-08-15
updated: 2026-09-15
sources:
  - data/final_datasets/sf/R_spData_house_house.rds
tags: [dataset, r-package, spatial, point]
---

Data on 25,357 single family homes sold in Lucas County, Ohio, 1993-1998 from the county auditor, together with an ‘nb’ neighbour object constructed as a sphere of influence graph from projected coordinates.

## Description du jeu de donnees

- Topic: immobilier / prix des logements
- Observation unit: logement, transaction immobiliere ou zone residentielle selon la documentation source
- Observed population: marche immobilier documente par le package source
- Geographic context: Etendue mesuree dans le RDS : x [-83.882392, -83.239929], y [41.416896, 41.732258]; CRS EPSG:4326.
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Data on 25,357 single family homes sold in Lucas County, Ohio, 1993-1998 from the county auditor, together with an ‘nb’ neighbour object constructed as a sphere of influence graph from projected coordinates.
- Description source: package R `spData`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `price`, `avalue`
- Candidate Y typology: continuous
- Candidate X variables: `yrbuilt`, `stories`, `TLA`, `wall`, `beds`, `baths`, `halfbaths`, `frontage`, `depth`, `garage`, `garagesqft`, `rooms`, `lotsize`, `s1993`, `s1994`, `s1995`, `s1996`, `s1997`, `s1998`, `syear`, `age`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `price` | `integer` | continuous | [2000, 875000] | 0% |
| `avalue` | `integer` | continuous | [1714, 788114] | 0% |

> Note typologie corrigee (2026-09-08) : `price`/`avalue` sont des prix immobiliers (dollars entiers, Lucas County OH, confirme via `tools::Rd_db("spData")` -- "price: a numeric vector") -- classes en `integer` cote R car sans decimales, mais ce sont des grandeurs monetaires continues, pas des denombrements. L'heuristique de detection automatique confond a tort "classe R integer" et "typologie count".

> Correction 2026-09-15 (mode production de secours, verification tools::Rd_db("spData")) : la meme confusion "integer -> count" identifiee en 2026-09-08 pour Y affectait aussi plusieurs variables X ci-dessous (`yrbuilt`, `TLA`, `frontage`, `depth`, `garagesqft`, `lotsize`) -- ce sont des mesures continues (annee, surface en pieds carres, distances, surface de garage, superficie du terrain), pas des denombrements. Seule `rooms` (nombre de pieces) est un veritable denombrement et reste "count". Corrige dans le Detail X.

> Selection Y/X (claude-sonnet-4-6) : Le prix de vente (price) est la cible naturelle d'un modèle hédonique immobilier ; la valeur cadastrale (avalue) peut aussi servir de variable réponse alternative. Les caractéristiques structurelles du logement (surface, chambres, salles de bain, garage, etc.), du terrain (frontage, depth, lotsize), de l'âge et de l'année de vente constituent les covariables explicatives classiques. Les colonnes sdate et T sont exclues car redondantes avec syear/s199x.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `yrbuilt` | `integer` | continuous | 0% |
| `stories` | `factor` | categorical | 0% |
| `TLA` | `integer` | continuous | 0% |
| `wall` | `factor` | categorical | 0% |
| `beds` | `numeric` | continuous | 0% |
| `baths` | `numeric` | continuous | 0% |
| `halfbaths` | `numeric` | continuous | 0% |
| `frontage` | `integer` | continuous | 0% |
| `depth` | `integer` | continuous | 0% |
| `garage` | `factor` | categorical | 0% |
| `garagesqft` | `integer` | continuous | 0% |
| `rooms` | `integer` | count | 0% |
| `lotsize` | `integer` | continuous | 0% |
| `s1993` | `integer` | binary | 0% |
| `s1994` | `integer` | binary | 0% |
| `s1995` | `integer` | binary | 0% |
| `s1996` | `integer` | binary | 0% |
| `s1997` | `integer` | binary | 0% |
| `s1998` | `integer` | binary | 0% |
| `syear` | `factor` | categorical | 0% |
| `age` | `numeric` | continuous | 0% |

### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Pace, R. Kelley and Barry, Ronald (1997) Quick Computation of Spatial Autoregressive Estimators. Geographical Analysis, 29(3), 232-247, DOI 10.1111/j.1538-4632.1997.tb00959.x (Crossref-verifie 2026-09-15). Article methodologique (calcul d'estimateurs SAR), ne specifie pas d'equation hedonique exacte pour ce jeu de donnees -- formula_pub reste honnetement "pending".

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: price ~ yrbuilt + stories + TLA + wall + beds + baths + halfbaths + frontage
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: yrbuilt + stories + TLA + wall + beds + baths + halfbaths + frontage
- y_term_used: price

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
    formula: "price ~ yrbuilt + stories + TLA + wall + beds + baths + halfbaths + frontage"
    response: "price"
    predictors: ["yrbuilt", "stories", "TLA", "wall", "beds", "baths", "halfbaths", "frontage"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `R_spData_house_house`
- Dataset name: spData::house
- Source family: r-package
- Source: package R `spData` (version 2.3.4)
- Source URL: https://CRAN.R-project.org/package=spData
- Dataset DOI: none
- Publication DOI: 10.1111/j.1538-4632.1997.tb00959.x
- Year: 2017

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "price ~ yrbuilt + stories + TLA + wall + beds + baths + halfbaths + frontage"
  equation_family: regression_candidate
  model_family: "regression_candidate"
  source_type: generated_system_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 25357
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-83.8824, -83.2399], y [41.4169, 41.7323] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32617 (UTM Zone 17N (EPSG:32617)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

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
  benchmark_task: "review_continuous"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "Reclasse le 2026-09-08 : Y (price/avalue) est continu, pas count (voir Bloc 1) -- ce n'est donc PAS un cas de routage binaire/count a documenter, mais un cas de regression continue classique necessitant sa propre revue individuelle (formula_pub encore pending malgre la reference Pace & Barry 1997 deja citee ; formula_status=unavailable). Hors perimetre du lot binaire/count traite le 2026-09-08."
  reason: "Reclasse le 2026-09-08 : Y (price/avalue) est continu, pas count (voir Bloc 1) -- ce n'est donc PAS un cas de routage binaire/count a documenter, mais un cas de regression continue classique necessitant sa propre revue individuelle (formula_pub encore pending malgre la reference Pace & Barry 1997 deja citee ; formula_status=unavailable). Hors perimetre du lot binaire/count traite le 2026-09-08."
```

- Decision: manual_review
- Manque principal: formula_pub a completer a partir de Pace & Barry (1997) avant toute promotion -- revue individuelle requise, distincte du lot binaire/count.
- Raison: Reclasse le 2026-09-08 : Y (price/avalue) est continu, pas count -- hors perimetre du lot binaire/count traite ce jour.


## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes. Correction 2026-09-15 : plusieurs variables X (yrbuilt, TLA, frontage, depth, garagesqft, lotsize) reclassees de "count" vers "continuous" (meme bug de detection deja identifie sur Y en 2026-09-08, etendu ici a X).
- Formula: PENDING - formule publication non encore etablie ; Pace & Barry (1997) est un article methodologique (calcul SAR) sans equation hedonique explicite pour ce jeu de donnees. DOI ajoute 2026-09-15 (10.1111/j.1538-4632.1997.tb00959.x).
- CRS: WARN - incoherence detectee 2026-09-15 (mode production de secours, inspection directe du .rds) : la geometrie active `geom_point` est correctement reprojetee en EPSG:4326 (WGS84, verifie -83.88/41.42 etc.), mais les colonnes numeriques `X`/`Y` du data.frame contiennent encore les valeurs projetees d'origine en metres (Lambert Conformal Conic, Ohio North State Plane NAD83 -- confirme identique au proj4string natif de spData::house). Incoherence interne au fichier .rds (pas seulement un probleme de documentation) : toute utilisation directe des colonnes X/Y comme coordonnees WGS84 serait erronee. `geom_origine` conserve correctement la geometrie source dans sa projection native. Correction du .rds hors perimetre d'une revue de fiche (necessite de re-deriver X/Y via st_coordinates(geom_point), voir code/r_catalog/guide_objets_sf.md section 4) -- signale pour correction ulterieure du pipeline de conversion sf.
- Geometry: OK - type geometrique controle (POINT) ; geom_origine (source, Lambert Ohio) et geom_point (WGS84) tous deux presents et coherents entre eux.
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (CC0).

## Related Pages

- Source: package R `spData`

## Curation documentée — 2026-09-07

Verification 2026-09-15 (mode production de secours, tools::Rd_db("spData") + inspection directe du .rds) : (1) etendu la correction de typologie deja appliquee a Y en 2026-09-08 (confusion classe R "integer" / typologie "count") a six variables X mal classees (yrbuilt, TLA, frontage, depth, garagesqft, lotsize -- mesures continues, pas des denombrements) ; seule `rooms` reste correctement "count". (2) DOI de Pace & Barry (1997) trouve et verifie via Crossref (10.1111/j.1538-4632.1997.tb00959.x), meme article que celui deja cite pour R_spData_elect80_elect80 -- reste toutefois un article methodologique sur le calcul d'estimateurs SAR, sans equation hedonique explicite pour ce jeu de donnees precis, donc formula_pub reste honnetement "pending". (3) Incoherence CRS reelle decouverte par inspection directe du .rds : la geometrie active geom_point est bien reprojetee en EPSG:4326 (coordonnees WGS84 verifiees : -83.88 a -83.24 / 41.42 a 41.73, coherentes avec Lucas County OH), mais les colonnes numeriques separees X/Y du data.frame contiennent encore les valeurs projetees d'origine en metres (Lambert Conformal Conic Ohio North State Plane, identique au proj4string natif verifie de spData::house) -- un ecart d'un facteur ~10^6 entre les deux representations des memes points. Documentee honnetement en Quality Control comme un bug de pipeline de conversion sf (colonnes X/Y non re-derivees de geom_point apres reprojection), pas corrigee ici (hors perimetre d'une revue de fiche texte).
