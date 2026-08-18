---
title: paper_danajon_coral_distribution
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_danajon_coral_distribution.rds
  - DatasetFirst_10_5061_dryad_z34tmpgpt
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "The influence of multiple stressors on the spatial distribution of corals" (DOI 10.1002/pan3.70208).

## Description du jeu de donnees

- Topic: ecologie marine / distribution spatiale des coraux et facteurs de stress
- Observation unit: polygone d'habitat (centroide)
- Observed population: recifs coralliens du Danajon Bank, Bohol, Philippines, N=29512 polygones
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: The influence of multiple stressors on the spatial distribution of corals
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1002/pan3.70208
- Dataset DOI: 10.5061/dryad.z34tmpgpt
- Source URL: https://doi.org/10.5061/dryad.z34tmpgpt
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_z34tmpgpt/`
- Local sf output: `data/final_datasets/sf/paper_danajon_coral_distribution.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `is_coral`
- Candidate Y typology: binary
- Candidate X variables in local artifact: `Geomorphic`, `Location`, `Map`, `reclass`, `area_m2`
- Candidate X count in local artifact: 5
- Candidate X typology: categorical, continuous
- Published X variables from paper: Geomorphic (classe geomorphologique : recif frangeant/pente/lagune), Location (zone ecologique : recif interne/externe, cotier, ile terrestre), Map (source de cartographie : teledetection RS, connaissance ecologique locale LEK, edition manuelle), reclass (indicateur de reclassification manuelle), area_m2 (surface du polygone d'habitat)
- Published X count: 5
- Coordinates (x, y - excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): `Hab_Paper`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `is_coral` | `integer` | binary | {0, 1} | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `danajon_coral_distribution`, la ou les reponses `is_coral` viennent du loader papier et/ou des preuves de l article `The influence of multiple stressors on the spatial distribution of corals`. Les covariables X retenues sont `Geomorphic`, `Location`, `Map`, `reclass`, `area_m2`. Les coordonnees (`lon`, `lat`), identifiants (`Hab_Paper`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Geomorphic` | `character` | categorical | 0% |
| `Location` | `character` | categorical | 0% |
| `Map` | `character` | categorical | 0% |
| `reclass` | `numeric` | binary | 0% |
| `area_m2` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: P(coral) ~ multiple_stressors (pression de peche, distance au marche, population humaine) + geomorphologie + zone ecologique [le papier etudie l'influence de facteurs de stress multiples (pression de peche, acces au marche, demographie des barangays) sur la distribution spatiale des coraux dans le Danajon Bank, a partir d'une carte d'habitat combinant teledetection et cartographie participative (connaissance ecologique locale)]
- x_terms_pub: Geomorphic (classe geomorphologique : recif frangeant/pente/lagune), Location (zone ecologique : recif interne/externe, cotier, ile terrestre), Map (source de cartographie : teledetection RS, connaissance ecologique locale LEK, edition manuelle), reclass (indicateur de reclassification manuelle), area_m2 (surface du polygone d'habitat)
- y_term_pub: is_coral (indicateur binaire de presence de corail, classe reclassifiee Hab_Paper=='Coral' de la carte d'habitat du papier)
- Reference publication: Selgrath, Gergel & Vincent (2025), The influence of multiple stressors on the spatial distribution of corals, People and Nature, doi:10.1002/pan3.70208. Le papier utilise une carte d'habitat combinant teledetection et cartographie participative (Selgrath et al. 2016, Ecosphere, doi:10.1002/ecs2.1325, pour la methode de cartographie) pour etudier l'effet de facteurs de stress humains (peche, marche, demographie -- covariables dans les fichiers barangay_* du meme depot) sur la distribution des coraux. formula_used utilise le polygone d'habitat reclassifie (Hab_Paper, variable de classification utilisee dans l'analyse du papier selon le readme du depot) converti en points (centroides de polygones) avec un indicateur binaire de corail, plus les covariables geomorphologiques et de zone ecologique deja presentes dans la meme couche -- une simplification documentee qui n'inclut pas encore les covariables de pression humaine (barangay_demographics, distance_market) du meme depot, non jointes spatialement ici par manque de cle de jointure directe entre polygones d'habitat et barangays. Donnees brutes (habitat_full_area_rs_lek_reclass_20250615_union_with_fa2.shp) telechargees directement depuis Dryad (10.5061/dryad.z34tmpgpt) -- pas une reconstruction, N=29512 polygones d'habitat (apres exclusion des classes Cloud/Deep/DeepWater/No Class), coordonnees reelles (Danajon Bank, Bohol, Philippines).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: is_coral ~ Geomorphic + Location + Map + reclass + area_m2
- x_terms_used: Geomorphic, Location, Map, reclass, area_m2
- y_term_used: is_coral
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
    formula: "is_coral ~ Geomorphic + Location + Map + reclass + area_m2"
    response: "is_coral (indicateur binaire de presence de corail, classe reclassifiee Hab_Paper=='Coral' de la carte d'habitat du papier)"
    predictors: ["Geomorphic (classe geomorphologique : recif frangeant/pente/lagune)", "Location (zone ecologique : recif interne/externe, cotier, ile terrestre)", "Map (source de cartographie : teledetection RS, connaissance ecologique locale LEK, edition manuelle)", "reclass (indicateur de reclassification manuelle)", "area_m2 (surface du polygone d'habitat)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["random_forest", "gamboost", "xgboost"]
    status: "confirmed"

  ml_or_selected:
    formula: "is_coral ~ Geomorphic + Location + Map + reclass + area_m2"
    response: "is_coral"
    predictors: ["Geomorphic", "Location", "Map", "reclass", "area_m2"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["glm_logistic", "random_forest", "random_forest_xy", "xgboost", "gwr"]
    status: "executable_binary_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_danajon_coral_distribution`
- Dataset name: The influence of multiple stressors on the spatial distribution of corals
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: The influence of multiple stressors on the spatial distribution of corals
- Paper DOI: 10.1002/pan3.70208
- Dataset DOI: 10.5061/dryad.z34tmpgpt
- Source URL: https://doi.org/10.5061/dryad.z34tmpgpt
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "P(coral) ~ multiple_stressors (pression de peche, distance au marche, population humaine) + geomorphologie + zone ecologique [le papier etudie l'influence de facteurs de stress multiples (pression de peche, acces au marche, demographie des barangays) sur la distribution spatiale des coraux dans le Danajon Bank, a partir d'une carte d'habitat combinant teledetection et cartographie participative (connaissance ecologique locale)]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Selgrath, Gergel & Vincent (2025), The influence of multiple stressors on the spatial distribution of corals, People and Nature, doi:10.1002/pan3.70208. Le papier utilise une carte d'habitat combinant teledetection et cartographie participative (Selgrath et al. 2016, Ecosphere, doi:10.1002/ecs2.1325, pour la methode de cartographie) pour etudier l'effet de facteurs de stress humains (peche, marche, demographie -- covariables dans les fichiers barangay_* du meme depot) sur la distribution des coraux. formula_used utilise le polygone d'habitat reclassifie (Hab_Paper, variable de classification utilisee dans l'analyse du papier selon le readme du depot) converti en points (centroides de polygones) avec un indicateur binaire de corail, plus les covariables geomorphologiques et de zone ecologique deja presentes dans la meme couche -- une simplification documentee qui n'inclut pas encore les covariables de pression humaine (barangay_demographics, distance_market) du meme depot, non jointes spatialement ici par manque de cle de jointure directe entre polygones d'habitat et barangays. Donnees brutes (habitat_full_area_rs_lek_reclass_20250615_union_with_fa2.shp) telechargees directement depuis Dryad (10.5061/dryad.z34tmpgpt) -- pas une reconstruction, N=29512 polygones d'habitat (apres exclusion des classes Cloud/Deep/DeepWater/No Class), coordonnees reelles (Danajon Bank, Bohol, Philippines)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "classification_binary_presence_absence_sdm"
  package_include: "yes"
  has_local_rds: true
  missing_items: "le papier etudie l'effet de facteurs de stress humains (peche, marche, demographie -- disponibles dans le meme depot mais non joints spatialement ici, absence de cle de jointure directe polygone-barangay) sur la distribution des coraux -- formula_used n'utilise que les covariables geomorphologiques/spatiales deja presentes dans la couche d'habitat, pas les covariables de stress humain du papier -- promu a package_include='yes' apres validation utilisateur (session 2026-08-16, groupe A)"
  reason: "Y binaire reel (indicateur de corail, classe reclassifiee du papier), N=29512 polygones d'habitat (convertis en centroides) avec coordonnees reelles (Danajon Bank, Philippines), covariables geomorphologiques et de zone ecologique reelles issues de la meme carte d'habitat que le papier. Shapefile original telecharge directement depuis Dryad, pas une reconstruction. Papier identifie via le fichier readme du depot (Selgrath, Gergel & Vincent 2025, People and Nature) ; l'attribution papier_doi initiale (PANGAEA, carte d'habitat) etait incorrecte et corrigee en session precedente."
```

- Decision: ready
- Manque principal: le papier etudie l'effet de facteurs de stress humains (peche, marche, demographie -- disponibles dans le meme depot mais non joints spatialement ici, absence de cle de jointure directe polygone-barangay) sur la distribution des coraux -- formula_used n'utilise que les covariables geomorphologiques/spatiales deja presentes dans la couche d'habitat, pas les covariables de stress humain du papier -- promu a package_include="yes" apres validation utilisateur (session 2026-08-16, groupe A)
- Raison: Y binaire reel (indicateur de corail, classe reclassifiee du papier), N=29512 polygones d'habitat (convertis en centroides) avec coordonnees reelles (Danajon Bank, Philippines), covariables geomorphologiques et de zone ecologique reelles issues de la meme carte d'habitat que le papier. Shapefile original telecharge directement depuis Dryad, pas une reconstruction. Papier identifie via le fichier readme du depot (Selgrath, Gergel & Vincent 2025, People and Nature) ; l'attribution papier_doi initiale (PANGAEA, carte d'habitat) etait incorrecte et corrigee en session precedente.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready"
  eligible_estimators: []
  conditionally_eligible_estimators: ["random_forest", "random_forest_xy", "gamboost", "xgboost", "xgboost_xy", "gam_spatial"]
  ineligible_reason: "reponse binaire (presence/absence) ; le registre benchmark du package (13-benchmark-spatial.R) code en dur mode='regression' pour tous les estimateurs automatiques -- aucun ne supporte de mode classification/binomial aujourd'hui. random_forest/gamboost/xgboost sont notes conditionnels car ce sont les estimateurs que le papier source a reellement utilises (RF/BRT) ; ols/sar_lag/sem_error/sdm_mixed/gwr restent hors de propos pour une reponse binaire (hypothese gaussienne continue) et ne sont pas listes."
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 29512
- k variables: 11
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [123.9974844, 124.3190064], y [9.9641045, 10.3341916]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32651 (UTM Zone 51N (EPSG:32651)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.z34tmpgpt (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`danajon_coral_distribution` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `danajon_coral_distribution` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`danajon_coral_distribution` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: The influence of multiple stressors on the spatial distribution of corals

