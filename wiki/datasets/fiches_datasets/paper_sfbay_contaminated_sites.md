---
title: paper_sfbay_contaminated_sites
type: dataset
created: 2026-08-16
updated: 2026-09-09
sources:
  - data/final_datasets/sf/paper_sfbay_contaminated_sites.rds
  - DatasetFirst_10_6078_d15x4n
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Rising Coastal Groundwater as a Result of Sea-Level Rise Will Influence Contaminated Coastal Sites and Underground Infrastructure" (DOI 10.1029/2023ef003825).

## Description du jeu de donnees

- Topic: risque environnemental / remontee de nappe et sites contamines
- Observation unit: site contamine (DTSC/SWRCB)
- Observed population: 5 297 enregistrements des couches régionales exposées : 1 480 ouverts et 3 817 fermés ; ce périmètre ne comprend pas tous les sites de la baie.
- Geographic context: Emprise du RDS reconstruit : longitude [-122.6583, -121.8596], latitude [37.38546, 38.32510], EPSG:4326.
- Temporal context: none (cross-sectional)
- Source description: Rising Coastal Groundwater as a Result of Sea-Level Rise Will Influence Contaminated Coastal Sites and Underground Infrastructure
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1029/2023ef003825
- Dataset DOI: 10.6078/d15x4n
- Source URL: https://doi.org/10.6078/d15x4n
- Local raw dir: `data/raw/papers/DatasetFirst_10_6078_d15x4n/`
- Local sf output: `data/final_datasets/sf/paper_sfbay_contaminated_sites.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `is_open_case` (classement ouvert/fermé du fichier source ; aucune réponse de régression publiée)
- Candidate Y typology: binary
- Candidate X variables in local artifact: aucune sélection de régression attribuable au papier
- Candidate X typology: unknown
- Published X variables from paper: sans objet pour une formule de régression ; zones d'exposition et catégories de vulnérabilité pour les analyses SIG et Kendall
- Published X count: sans objet
- Presence of imputed X: unknown
- Coordinates (x, y - excluded from X candidates): `X`, `Y`, dérivés de la géométrie source ; `LATITUDE` et `LONGITUDE` sont des attributs conservés et ne remplacent pas cette géométrie
- Identifier/excluded columns (excluded from X candidates): `FID_DTSC_S`, `FID_WRCB_S`, `FID_Inun_S`, `FID_Rise_S`, identifiants de site et champs de provenance
- Variables inspected: yes (RDS reconstruit et shapefiles comparés le 2026-09-09)

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `is_open_case` | `integer` | binary | {0, 1} | 0% |

> Note : `is_open_case` (1 = shapefile OpenSites, n=1480 ; 0 = shapefile ClosedSites, n=3817) décrit le fichier d'origine ; ce n'est pas la variable dépendante d'un modèle publié par le papier. Les champs de statut et de provenance divulguent cette étiquette et ne doivent pas devenir ses prédicteurs.

> Selection Y/X (paper-loader / curated evidence) : Pour `sfbay_contaminated_sites`, aucune réponse Y ni jeu de covariables X n'est retenu : le papier ne publie pas de régression sur ces couches (superpositions SIG et corrélation de Kendall uniquement, cf. Reference publication). `is_open_case` reste documenté comme candidate Y non retenue. Les coordonnées (`X`, `Y`, `LATITUDE`, `LONGITUDE`), identifiants (`FID_DTSC_S`, `FID_WRCB_S`, `FID_Inun_S`, `FID_Rise_S`, identifiants de site) et champs de provenance sont exclus de toute liste X. Statut benchmark actuel : not_ready_no_published_regression ; package_include: no.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `gridcode` | `integer` | not_applicable (aucune régression publiée) | 0% |
| `SITE_TYPE` | `character` | not_applicable | variable |
| `RESTRICTED` | `character` | not_applicable | variable |
| `COUNTY` | `character` | not_applicable | 0% |
| `ACRES` | `numeric` | not_applicable | variable |
| `GLOBAL_ID` | `character` | not_applicable (identifiant) | variable |
| `ENVIROSTOR` | `character` | not_applicable (identifiant) | variable |
| `STATUS_SHO` | `character` | not_applicable | variable |

> Note : les 75 attributs des shapefiles sont conservés (liste ci-dessus non exhaustive), dont les identifiants DTSC/WRCB. Leur présence ne prouve pas leur emploi comme X dans une régression : le papier ne publie aucune régression sur ces couches (superpositions SIG et corrélation de Kendall uniquement). Le README documente une reclassification du raster de remontée de nappe au seuil de 0,1016 m ; cela ne fait pas de `gridcode` une covariable publiée. Les couches sont déjà sélectionnées pour une exposition à la remontée de nappe OU à l'inondation : ne pas interpréter automatiquement `gridcode=0` comme un site non exposé. Les champs des deux bases fusionnées comportent des valeurs manquantes et des zéros techniques.

### Formule - niveau publication

- formula_pub: not_applicable
- x_terms_pub: not_applicable
- y_term_pub: not_applicable
- Reference publication: Hill, K., Hirschfeld, D., Lindquist, C., Cook, F. et Warner, S. (2023), Earth's Future, DOI 10.1029/2023EF003825. Méthodes : superpositions et comptages SIG ; tau de Kendall pour l'association avec la vulnérabilité sociale. Le papier ne présente pas `is_open_case ~ gridcode`.

### Statut regression canonique

- Statut: not_applicable
- Niveau de preuve: papier et README du dépôt contrôlés
- Methode d estimation: analyse d'exposition spatiale ; corrélation de rang de Kendall
- Note: La régression auparavant attribuée au papier était construite par le système et cette attribution est retirée.

### Formule - niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending
- Note: Aucune nouvelle tâche de classification n'est substituée à l'analyse publiée. Les anciennes formules sont conservées uniquement dans la sauvegarde d'audit, hors des champs actifs.

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
    formula: "not_applicable"
    response: "not_applicable"
    predictors: []
    role: "paper_main_specification"
    source_type: "none_found"
    source_ref: "Hill et al. (2023), Earth's Future, DOI 10.1029/2023EF003825 -- le papier ne publie aucune regression Y~X sur ces couches (superpositions SIG et correlation de Kendall uniquement)."
    estimator_context: []
    status: "unavailable"

  ml_or_selected:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "ml_candidate_features"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_sfbay_contaminated_sites`
- Dataset name: Sea level rise, groundwater rise, and contaminated sites in the San Francisco Bay Area, and Superfund Sites in the contiguous United States
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Rising Coastal Groundwater as a Result of Sea-Level Rise Will Influence Contaminated Coastal Sites and Underground Infrastructure
- Paper DOI: 10.1029/2023ef003825
- Dataset DOI: 10.6078/d15x4n
- Source URL: https://doi.org/10.6078/d15x4n
- Year: 2023

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): cartographie et comptage des sites exposés
- Modele niveau 2 (famille): superposition SIG ; corrélation de Kendall
- Modele niveau 3 (variante): scénario SLR 1 m, conductivité Kh1 pour ces couches

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "Aucune régression Y ~ X sur le statut ouvert/fermé dans le papier."
  equation_family: not_applicable
  model_family: "Analyse SIG et corrélation de Kendall"
  source_type: scientific_publication
  source_ref: "10.1029/2023EF003825 ; README Dryad 10.6078/D15X4N"
  confidence: high
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_no_published_regression"
  benchmark_task: "not_applicable"
  package_include: "no"
  has_local_rds: true
  missing_items: "Pas de tâche de régression publiée à reproduire sur ces couches."
  reason: "Pas de tâche de régression publiée à reproduire sur ces couches."
```

- Decision: not_ready_no_published_regression
- Manque principal: Pas de tâche de régression publiée à reproduire sur ces couches.
- Raison: Données conservées dans la banque ; le statut ne vaut pas admission au benchmark automatique.

## Estimator eligibility

```yaml
estimator_eligibility:
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "RF, XGBoost, SAR-probit et SEM-probit ne sont pas les méthodes du papier. Aucune régression automatique retenue."
  rule: "Conserver la méthode du papier ; une famille voisine ne constitue pas une reproduction."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 5297
- k variables: 79
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit
- Note: 81 colonnes au total, dont 2 géométries ; k compte les 79 attributs hors géométrie, pas des covariables de modèle. 75 attributs source + is_open_case + source_file + X + Y. Les 5 297 lignes sont les enregistrements des couches fournies, pas une affirmation de 5 297 coordonnées uniques.

L'ancien N=802 provenait d'un dédoublonnage erroné sur FID_DTSC_S : 3 596 lignes fermées et 900 lignes ouvertes ont la valeur 0 dans ce champ. Le loader les traitait comme le même site. La reconstruction préserve désormais les 3 817 + 1 480 lignes et leur géométrie source, sans dédoublonnage arbitraire.
Contrôle géométrique supplémentaire : 5 297 géométries ponctuelles distinctes dans le RDS reconstruit.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-122.6583, -121.8596], y [37.38546, 38.32510]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32610 (UTM Zone 10N (EPSG:32610)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.6078/d15x4n (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK pour la conversion des couches source ; aucune reproduction de régression revendiquée.
- Code available: yes (loader `sfbay_contaminated_sites` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: blocs existants conservés.
- Variables: 75 attributs source préservés ; aucune attribution automatique Y/X au papier.
- Formula: not_applicable pour le papier ; aucune formule de benchmark active.
- CRS: source EPSG:3717, transformée en EPSG:4326 à partir de la géométrie du shapefile.
- Geometry: POINT ; coordonnées source préservées par transformation.
- Missing values: champs DTSC/WRCB non uniformes ; zéros techniques distincts de mesures réelles.
- Duplicates: aucun dédoublonnage sur FID_DTSC_S ; comptages source exactement conservés.
- Reproducibility: loader corrigé, ancienne version RDS sauvegardée dans data/interim/dataset_review_2026-09-09/.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Rising Coastal Groundwater as a Result of Sea-Level Rise Will Influence Contaminated Coastal Sites and Underground Infrastructure
