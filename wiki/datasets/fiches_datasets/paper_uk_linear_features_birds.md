---
title: paper_uk_linear_features_birds
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_uk_linear_features_birds.rds
  - DatasetFirst_10_5061_dryad_m5g04
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "A national‐scale model of linear features improves predictions of farmland biodiversity" (DOI 10.1111/1365-2664.12912).

## Description du jeu de donnees

- Topic: ecologie agricole / elements lineaires du paysage (haies) et biodiversite
- Observation unit: carre de 1km (site de suivi BBS)
- Observed population: oiseaux communs (Breeding Bird Survey), Royaume-Uni, N=3312 sites
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: A national‐scale model of linear features improves predictions of farmland biodiversity
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: low
- Paper DOI: 10.1111/1365-2664.12912
- Dataset DOI: 10.5061/dryad.m5g04
- Source URL: https://doi.org/10.5061/dryad.m5g04
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_m5g04/`
- Local sf output: `data/final_datasets/sf/paper_uk_linear_features_birds.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `total_bird_abundance`
- Candidate Y typology: count
- Candidate X variables in local artifact: `LinearFeaturesLength`, `WoodyLinearFeaturesLength`
- Candidate X count in local artifact: 2
- Candidate X typology: continuous
- Published X variables from paper: LinearFeaturesLength (longueur totale d'elements lineaires, ex. haies, autour du site), WoodyLinearFeaturesLength (longueur d'elements lineaires ligneux)
- Published X count: 2
- Coordinates (x, y - excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): `SiteID`, `GridSquare1km`, `Survey`, `easting`, `northing`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `total_bird_abundance` | `integer` | count | [1, 687] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `uk_linear_features_birds`, la ou les reponses `total_bird_abundance` viennent du loader papier et/ou des preuves de l article `A national‐scale model of linear features improves predictions of farmland biodiversity`. Les covariables X retenues sont `LinearFeaturesLength`, `WoodyLinearFeaturesLength`. Les coordonnees (`lon`, `lat`), identifiants (`SiteID`, `GridSquare1km`, `Survey`, `easting`, `northing`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `LinearFeaturesLength` | `numeric` | continuous | 0% |
| `WoodyLinearFeaturesLength` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: abundance_species_i ~ LinearFeaturesLength + WoodyLinearFeaturesLength + [covariables d'habitat national] [modeles d'abondance par espece (18 especes d'oiseaux, 24 especes de papillons) sur 3723 (BBS) et 1547 (UKBMS) sites de suivi au Royaume-Uni, comparant modeles avec/sans le jeu de donnees national de haies/elements lineaires]
- x_terms_pub: LinearFeaturesLength (longueur totale d'elements lineaires, ex. haies, autour du site), WoodyLinearFeaturesLength (longueur d'elements lineaires ligneux)
- y_term_pub: total_bird_abundance (abondance totale d'oiseaux toutes especes BBS confondues, agregation communautaire des comptages individuels par espece publies par le papier)
- Reference publication: Sullivan et al. (2017), A national-scale model of linear features improves predictions of farmland biodiversity, Journal of Applied Ecology, doi:10.1111/1365-2664.12912. Le papier ajuste des modeles d'abondance par espece (18 oiseaux BBS, 24 papillons UKBMS) avec un jeu de donnees national d'elements lineaires (haies) comme covariable. Le depot Dryad original contenait 2 fichiers -- seul le fichier de covariables (elements lineaires) avait ete recupere lors du harvest initial ; le fichier de donnees d'abondance par espece (Species abundance data from Sullivan et al...) a ete identifie et telecharge separement via l'API Dryad (session 2026-08-16, apres verification qu'il existait bien sur le depot). formula_used agrege l'abondance BBS toutes especes (reponse communautaire) plutot que les 18 modeles par espece du papier. Coordonnees converties depuis les references de grille nationale britannique (British National Grid, ex. 'TQ5114') vers WGS84 via le package rnrfa::osg_parse (conversion deterministe standard, verifiee sur references de test connues). Donnees brutes telechargees directement depuis Dryad (10.5061/dryad.m5g04) -- pas une reconstruction, N=3312 sites (intersection BBS x elements lineaires), Royaume-Uni.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: total_bird_abundance ~ LinearFeaturesLength + WoodyLinearFeaturesLength
- x_terms_used: LinearFeaturesLength, WoodyLinearFeaturesLength
- y_term_used: total_bird_abundance
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

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
    formula: "total_bird_abundance ~ LinearFeaturesLength + WoodyLinearFeaturesLength"
    response: "total_bird_abundance (abondance totale d'oiseaux toutes especes BBS confondues, agregation communautaire des comptages individuels par espece publies par le papier)"
    predictors: ["LinearFeaturesLength (longueur totale d'elements lineaires, ex. haies, autour du site)", "WoodyLinearFeaturesLength (longueur d'elements lineaires ligneux)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "total_bird_abundance ~ LinearFeaturesLength + WoodyLinearFeaturesLength"
    response: "total_bird_abundance"
    predictors: ["LinearFeaturesLength", "WoodyLinearFeaturesLength"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "gam_spatial", "random_forest", "gwr"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_uk_linear_features_birds`
- Dataset name: Data from: A national-scale model of linear features improves predictions of farmland biodiversity
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: A national‐scale model of linear features improves predictions of farmland biodiversity
- Paper DOI: 10.1111/1365-2664.12912
- Dataset DOI: 10.5061/dryad.m5g04
- Source URL: https://doi.org/10.5061/dryad.m5g04
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "abundance_species_i ~ LinearFeaturesLength + WoodyLinearFeaturesLength + [covariables d'habitat national] [modeles d'abondance par espece (18 especes d'oiseaux, 24 especes de papillons) sur 3723 (BBS) et 1547 (UKBMS) sites de suivi au Royaume-Uni, comparant modeles avec/sans le jeu de donnees national de haies/elements lineaires]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Sullivan et al. (2017), A national-scale model of linear features improves predictions of farmland biodiversity, Journal of Applied Ecology, doi:10.1111/1365-2664.12912. Le papier ajuste des modeles d'abondance par espece (18 oiseaux BBS, 24 papillons UKBMS) avec un jeu de donnees national d'elements lineaires (haies) comme covariable. Le depot Dryad original contenait 2 fichiers -- seul le fichier de covariables (elements lineaires) avait ete recupere lors du harvest initial ; le fichier de donnees d'abondance par espece (Species abundance data from Sullivan et al...) a ete identifie et telecharge separement via l'API Dryad (session 2026-08-16, apres verification qu'il existait bien sur le depot). formula_used agrege l'abondance BBS toutes especes (reponse communautaire) plutot que les 18 modeles par espece du papier. Coordonnees converties depuis les references de grille nationale britannique (British National Grid, ex. 'TQ5114') vers WGS84 via le package rnrfa::osg_parse (conversion deterministe standard, verifiee sur references de test connues). Donnees brutes telechargees directement depuis Dryad (10.5061/dryad.m5g04) -- pas une reconstruction, N=3312 sites (intersection BBS x elements lineaires), Royaume-Uni."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "le papier publie 18 modeles d'abondance par espece, pas une regression communautaire -- formula_used agrege l'abondance BBS toutes especes (simplification documentee) ; coordonnees dependent d'une conversion BNG->WGS84 via package externe (rnrfa), verifiee sur references connues mais non issue directement du depot -- promu a package_include='yes' apres validation utilisateur (session 2026-08-16, groupe A)"
  reason: "Y continu/comptage reel (abondance totale d'oiseaux BBS), N=3312 sites avec coordonnees reelles (Royaume-Uni, converties depuis references de grille nationale britannique), covariables d'elements lineaires exactement celles du papier. Fichier de donnees d'abondance manquant du harvest initial retrouve et telecharge directement depuis Dryad (session 2026-08-16), pas une reconstruction."
```

- Decision: ready
- Manque principal: le papier publie 18 modeles d'abondance par espece, pas une regression communautaire -- formula_used agrege l'abondance BBS toutes especes (simplification documentee) ; coordonnees dependent d'une conversion BNG->WGS84 via package externe (rnrfa), verifiee sur references connues mais non issue directement du depot -- promu a package_include="yes" apres validation utilisateur (session 2026-08-16, groupe A)
- Raison: Y continu/comptage reel (abondance totale d'oiseaux BBS), N=3312 sites avec coordonnees reelles (Royaume-Uni, converties depuis references de grille nationale britannique), covariables d'elements lineaires exactement celles du papier. Fichier de donnees d'abondance manquant du harvest initial retrouve et telecharge directement depuis Dryad (session 2026-08-16), pas une reconstruction.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready"
  eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
  conditionally_eligible_estimators: []
  ineligible_reason: ""
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 3312
- k variables: 12
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-7.4971858, 1.7271628], y [50.0781545, 60.5883474]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32630 (UTM Zone 30N (EPSG:32630)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`uk_linear_features_birds` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `uk_linear_features_birds` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`uk_linear_features_birds` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: A national‐scale model of linear features improves predictions of farmland biodiversity

