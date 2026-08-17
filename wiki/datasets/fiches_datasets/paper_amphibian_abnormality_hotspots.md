---
title: paper_amphibian_abnormality_hotspots
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_amphibian_abnormality_hotspots.rds
  - DatasetFirst_10_5061_dryad_dc25r
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Localized Hotspots Drive Continental Geography of Abnormal Amphibians on U.S. Wildlife Refuges" (DOI 10.1371/journal.pone.0077467).

## Description du jeu de donnees

- Topic: ecotoxicologie / anomalies amphibiennes
- Observation unit: evenement de collecte (site x date)
- Observed population: amphibiens examines sur les refuges fauniques nationaux USFWS, Etats-Unis (2000-2009)
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: Localized Hotspots Drive Continental Geography of Abnormal Amphibians on U.S. Wildlife Refuges
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1371/journal.pone.0077467
- Dataset DOI: 10.5061/dryad.dc25r
- Source URL: https://doi.org/10.5061/dryad.dc25r
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_dc25r/`
- Local sf output: `data/final_datasets/sf/paper_amphibian_abnormality_hotspots.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `all_ab_percent`, `sk_ab_percent`, `eye_ab_percent`, `disease_percent`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `sampling_date`, `species`, `sp_coded`, `avg_gosner`, `avg_svl`, `sk_plus_eye_abnormal_count`, `sk_plus_eye_ab_percent`, `sk_abnormal_count`, `eye_abnormal_count`, `surface_abnormal_count`, `surface_ab_percent`, `disease_abnormal_count`, `abnormal_count`, `total_frogs`, `SITE_ALIAS`, `SITE_DATE`, `SITE_TIME`, `ORIGINAL_LATITUDE`, `ORIGINAL_LONGITUDE`, `ELEVATION`, `DATUM`, `GPS_MODEL`, `AREA`, `WATER_DEPTH`, `HABITAT_TYPE`, `SITE_COMMENTS`
- Candidate X count in local artifact: 26
- Candidate X typology: unknown, categorical, continuous
- Published X variables from paper: Corrected_LATITUDE/Corrected_LONGITUDE (terme spatial non-lineaire principal du GAMM), REFUGE (131 refuges USFWS, effet aleatoire), REGION (9 regions USFWS, effet aleatoire)
- Published X count: 3
- Coordinates (x, y - excluded from X candidates): `Corrected_LONGITUDE`, `Corrected_LATITUDE`
- Identifier columns (excluded from X candidates): `collection_id`, `site_id`, `REFUGE`, `REGION`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `all_ab_percent` | `numeric` | continuous | [0, 97.5] | 0% |
| `sk_ab_percent` | `numeric` | continuous | [0, 40] | 0% |
| `eye_ab_percent` | `numeric` | continuous | [0, 7.14] | 0% |
| `disease_percent` | `numeric` | continuous | [0, 6.56] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `amphibian_abnormality_hotspots`, la ou les reponses `all_ab_percent`, `sk_ab_percent`, `eye_ab_percent`, `disease_percent` viennent du loader papier et/ou des preuves de l article `Localized Hotspots Drive Continental Geography of Abnormal Amphibians on U.S. Wildlife Refuges`. Les covariables X retenues sont `sampling_date`, `species`, `sp_coded`, `avg_gosner`, `avg_svl`, `sk_plus_eye_abnormal_count`, `sk_plus_eye_ab_percent`, `sk_abnormal_count`, `eye_abnormal_count`, `surface_abnormal_count`, `surface_ab_percent`, `disease_abnormal_count` ; 14 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Corrected_LONGITUDE`, `Corrected_LATITUDE`), identifiants (`collection_id`, `site_id`, `REFUGE`, `REGION`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `sampling_date` | `Date` | unknown | 0.2% |
| `species` | `character` | categorical | 0% |
| `sp_coded` | `character` | categorical | 0% |
| `avg_gosner` | `numeric` | continuous | 1% |
| `avg_svl` | `numeric` | continuous | 0% |
| `sk_plus_eye_abnormal_count` | `integer` | count | 0% |
| `sk_plus_eye_ab_percent` | `numeric` | continuous | 0% |
| `sk_abnormal_count` | `integer` | count | 0% |
| `eye_abnormal_count` | `integer` | count | 0% |
| `surface_abnormal_count` | `integer` | count | 0% |
| `surface_ab_percent` | `numeric` | continuous | 0% |
| `disease_abnormal_count` | `integer` | count | 0% |
| `abnormal_count` | `integer` | count | 0% |
| `total_frogs` | `integer` | count | 0% |
| `SITE_ALIAS` | `character` | categorical | 12% |
| `SITE_DATE` | `character` | categorical | 0% |
| `SITE_TIME` | `character` | categorical | 11.7% |
| `ORIGINAL_LATITUDE` | `numeric` | continuous | 0% |
| `ORIGINAL_LONGITUDE` | `numeric` | continuous | 0% |
| `ELEVATION` | `numeric` | continuous | 37.1% |
| `DATUM` | `character` | categorical | 2.2% |
| `GPS_MODEL` | `character` | categorical | 15.1% |
| `AREA` | `integer` | count | 9.4% |
| `WATER_DEPTH` | `character` | categorical | 36.3% |
| `HABITAT_TYPE` | `character` | categorical | 1.5% |
| `SITE_COMMENTS` | `character` | categorical | 13% |

### Formule - niveau publication

- formula_pub: all_ab_percent ~ s(Corrected_LATITUDE, Corrected_LONGITUDE) + (1|REFUGE) + (1|REGION) [Generalized Additive Mixed Model (GAMM), termes spatiaux non-lineaires latitude/longitude + effets aleatoires imbriques site/refuge/region ; analyse complementaire par statistique Getis-Ord Gi* pour la detection de hotspots]
- x_terms_pub: Corrected_LATITUDE/Corrected_LONGITUDE (terme spatial non-lineaire principal du GAMM), REFUGE (131 refuges USFWS, effet aleatoire), REGION (9 regions USFWS, effet aleatoire)
- y_term_pub: all_ab_percent (pourcentage d'amphibiens presentant une anomalie squelettique/oculaire dans une collecte)
- Reference publication: Gray, M.J., Rogers, J.D., Miller, D.L. et al. (2013), Localized Hotspots Drive Continental Geography of Abnormal Amphibians on U.S. Wildlife Refuges, PLoS ONE 8(11): e77467, doi:10.1371/journal.pone.0077467. CoreDataset.csv (675 evenements de collecte) joint a Site.csv (666 sites apres dedoublonnage de 4 SITE_ID dupliques dans le depot source) via site_id, telecharge directement depuis Dryad (10.5061/dryad.dc25r, isSupplementTo/primary_article) -- pas une reconstruction. 77/675 evenements sans coordonnee valide (protection d'especes listees federalement, documente dans README_for_Site.txt) sont exclus (N final=598), pas imputes. Y et coordonnees correspondent exactement a la description du papier (variance partitioning site/refuge/region, GAMM lat/long non-lineaire, Getis-Ord Gi* pour la detection de clusters).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: all_ab_percent ~ Corrected_LATITUDE + Corrected_LONGITUDE + REFUGE + REGION
- x_terms_used: sampling_date, species, sp_coded, avg_gosner, avg_svl, sk_plus_eye_abnormal_count, sk_plus_eye_ab_percent, sk_abnormal_count, eye_abnormal_count, surface_abnormal_count, surface_ab_percent, disease_abnormal_count
- y_term_used: all_ab_percent
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
    formula: "all_ab_percent ~ Corrected_LATITUDE + Corrected_LONGITUDE + REFUGE + REGION"
    response: "all_ab_percent (pourcentage d'amphibiens presentant une anomalie squelettique/oculaire dans une collecte)"
    predictors: ["Corrected_LATITUDE/Corrected_LONGITUDE (terme spatial non-lineaire principal du GAMM)", "REFUGE (131 refuges USFWS, effet aleatoire)", "REGION (9 regions USFWS, effet aleatoire)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "all_ab_percent ~ Corrected_LATITUDE + Corrected_LONGITUDE + REFUGE + REGION"
    response: "all_ab_percent"
    predictors: ["Corrected_LATITUDE", "Corrected_LONGITUDE", "REFUGE", "REGION"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["gam_spatial", "gamm", "random_forest", "xgboost"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_amphibian_abnormality_hotspots`
- Dataset name: Data from: Localized hotspots drive continental geography of abnormal amphibians on U.S. wildlife refuges
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Localized Hotspots Drive Continental Geography of Abnormal Amphibians on U.S. Wildlife Refuges
- Paper DOI: 10.1371/journal.pone.0077467
- Dataset DOI: 10.5061/dryad.dc25r
- Source URL: https://doi.org/10.5061/dryad.dc25r
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "all_ab_percent ~ s(Corrected_LATITUDE, Corrected_LONGITUDE) + (1|REFUGE) + (1|REGION) [Generalized Additive Mixed Model (GAMM), termes spatiaux non-lineaires latitude/longitude + effets aleatoires imbriques site/refuge/region ; analyse complementaire par statistique Getis-Ord Gi* pour la detection de hotspots]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Gray, M.J., Rogers, J.D., Miller, D.L. et al. (2013), Localized Hotspots Drive Continental Geography of Abnormal Amphibians on U.S. Wildlife Refuges, PLoS ONE 8(11): e77467, doi:10.1371/journal.pone.0077467. CoreDataset.csv (675 evenements de collecte) joint a Site.csv (666 sites apres dedoublonnage de 4 SITE_ID dupliques dans le depot source) via site_id, telecharge directement depuis Dryad (10.5061/dryad.dc25r, isSupplementTo/primary_article) -- pas une reconstruction. 77/675 evenements sans coordonnee valide (protection d'especes listees federalement, documente dans README_for_Site.txt) sont exclus (N final=598), pas imputes. Y et coordonnees correspondent exactement a la description du papier (variance partitioning site/refuge/region, GAMM lat/long non-lineaire, Getis-Ord Gi* pour la detection de clusters)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous_rate"
  package_include: "yes"
  has_local_rds: true
  missing_items: "77/675 evenements de collecte sans coordonnee valide exclus (proteection d'especes listees federalement documentee dans README_for_Site.txt), pas imputes -- N=598 final vs 675 collectes au total ; 4 SITE_ID dupliques dans le depot source dedoublonnes (garde la ligne avec coordonnees valides)"
  reason: "Y continu reel (all_ab_percent, % d'anomalies), coordonnees GPS reelles corrigees (Corrected_LATITUDE/LONGITUDE), N=598 sur 131 refuges USFWS / 9 regions. CSV original telecharge directement depuis Dryad (isSupplementTo/primary_article), pas une reconstruction. Papier lu integralement (TEI) : formule confirmee (GAMM spatial non-lineaire lat/long + effets aleatoires imbriques site/refuge/region)."
```

- Decision: ready
- Manque principal: 77/675 evenements de collecte sans coordonnee valide exclus (proteection d'especes listees federalement documentee dans README_for_Site.txt), pas imputes -- N=598 final vs 675 collectes au total ; 4 SITE_ID dupliques dans le depot source dedoublonnes (garde la ligne avec coordonnees valides)
- Raison: Y continu reel (all_ab_percent, % d'anomalies), coordonnees GPS reelles corrigees (Corrected_LATITUDE/LONGITUDE), N=598 sur 131 refuges USFWS / 9 regions. CSV original telecharge directement depuis Dryad (isSupplementTo/primary_article), pas une reconstruction. Papier lu integralement (TEI) : formule confirmee (GAMM spatial non-lineaire lat/long + effets aleatoires imbriques site/refuge/region).

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
- N observations: 598
- k variables: 38
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-161.87543, -67.2583], y [26.04285, 67.21632]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=94.6deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`amphibian_abnormality_hotspots` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `amphibian_abnormality_hotspots` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20%: ELEVATION (NA=37.1%), WATER_DEPTH (NA=36.3%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`amphibian_abnormality_hotspots` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Localized Hotspots Drive Continental Geography of Abnormal Amphibians on U.S. Wildlife Refuges

