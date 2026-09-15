---
title: paper_sugarglider_occupancy
type: dataset
created: 2026-09-14
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_sugarglider_occupancy.rds
  - DatasetFirst_10_5061_dryad_4xgxd259g
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Occupancy patterns of the introduced, predatory sugar glider in Tasmanian forests" (DOI 10.1111/aec.12583).

## Description du jeu de donnees

- Topic: ecologie / occupation d'espece introduite predatrice
- Observation unit: site de detection (camera/appel)
- Observed population: planeur du sucre (Petaurus breviceps, espece introduite predatrice), Southern Forest, Tasmanie, N=100 sites
- Geographic context: Etendue mesuree dans le RDS : x [146.8177108, 147.0843991], y [-43.4253773, -43.0707424]; CRS EPSG:4326.
- Temporal context: none (cross-sectional)
- Source description: Occupancy patterns of the introduced, predatory sugar glider in Tasmanian forests
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/aec.12583
- Dataset DOI: 10.5061/dryad.4xgxd259g
- Source URL: https://doi.org/10.5061/dryad.4xgxd259g
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_4xgxd259g/`
- Local sf output: `data/final_datasets/sf/paper_sugarglider_occupancy.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `n_detections`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `mat200`, `mat500`, `mat1000`, `mat1500`, `mat2000`, `elev`
- Candidate X count in local artifact: 6
- Candidate X typology: continuous
- Published X variables from paper: mat200-mat2000 (etendue de foret mature dans des tampons de 200 a 2000m), elev (elevation)
- Published X count: 2
- Coordinates (x, y - excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): `site`, `easting`, `northing`, `survey1`, `survey2`, `survey3`, `survey4`, `survey5`, `d1`, `d2`, `d3`, `d4`, `d5`, `temp1`, `temp2`, `temp3`, `temp4`, `temp5`, `wind1`, `wind2`, `wind3`, `wind4`, `wind5`, `moon1`, `moon2`, `moon3`, `moon4`, `moon5`, `owl1`, `owl2`, `owl3`, `owl4`, `owl5`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `n_detections` | `numeric` | count | [0, 4] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `sugarglider_occupancy`, la ou les reponses `n_detections` viennent du loader papier et/ou des preuves de l article `Occupancy patterns of the introduced, predatory sugar glider in Tasmanian forests`. Les covariables X retenues sont `mat200`, `mat500`, `mat1000`, `mat1500`, `mat2000`, `elev`. Les coordonnees (`lon`, `lat`), identifiants (`site`, `easting`, `northing`, `survey1`, `survey2`, `survey3`, `survey4`, `survey5`, `d1`, `d2`, `d3`, `d4`, `d5`, `temp1`, `temp2`, `temp3`, `temp4`, `temp5`, `wind1`, `wind2`, `wind3`, `wind4`, `wind5`, `moon1`, `moon2`, `moon3`, `moon4`, `moon5`, `owl1`, `owl2`, `owl3`, `owl4`, `owl5`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `mat200` | `numeric` | rate | 0% |
| `mat500` | `numeric` | rate | 0% |
| `mat1000` | `numeric` | rate | 0% |
| `mat1500` | `numeric` | rate | 0% |
| `mat2000` | `numeric` | rate | 0% |
| `elev` | `integer` | continuous | 0% |

### Formule - niveau publication

- formula_pub: psi(occupancy) ~ mature_forest_extent(200-2000m) + elev ; p(detection) ~ temperature + wind + moonlight + owl_playback [modele d'occupation-detection (site-occupancy model), naive occupancy = 0.79, detectabilite = 0.52 +/- 0.03 sur 5 visites]
- x_terms_pub: mat200-mat2000 (etendue de foret mature dans des tampons de 200 a 2000m), elev (elevation)
- y_term_pub: n_detections (nombre de detections de planeur du sucre sur 5 visites de site, proxy continu/comptage d'occupation)
- Reference publication: Allen, Webb, Alves, Heinsohn & Stojanovic (2018) (auteurs corriges le 2026-09-14 -- confirmes via Crossref ; 'Cooper' n'est pas un auteur de ce papier, les vrais 3e et 4e auteurs sont Alves et Heinsohn), Occupancy patterns of the introduced, predatory sugar glider in Tasmanian forests, Austral Ecology, doi:10.1111/aec.12583. Le papier ajuste un modele d'occupation-detection sur 100 sites du Southern Forest, Tasmanie (naive occupancy=0.79, confirme empiriquement : 79/100 sites avec au moins une detection dans les donnees locales). formula_used utilise le nombre total de detections (n_detections, somme des 5 visites) comme proxy continu de l'occupation, contre les covariables d'habitat reelles du papier (etendue de foret mature a plusieurs echelles de tampon, elevation) ; les covariables de detectabilite (temperature, vent, lune, appel de chouette) restent disponibles dans l'artefact local mais ne sont pas retenues dans formula_used (elles modelisent p, pas psi, dans le cadre occupation-detection original). Donnees brutes (Sugarglider.csv) telechargees directement depuis Dryad (10.5061/dryad.4xgxd259g, depot reutilisant les donnees originales de Stojanovic pour un papier methodologique sur la dependance spatiale) -- pas une reconstruction, N=100 sites, coordonnees reelles (Southern Forest, Tasmanie, converties de UTM zone 55S vers WGS84).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

### Formule - niveau systeme

- formula_used: n_detections ~ mat200 + mat500 + mat1000 + mat1500 + mat2000 + elev
- License evidence: DataCite API record for DOI 10.5061/dryad.4xgxd259g (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- benchmark_task_note: n_detections denombre les detections; occupation et detectabilite doivent rester distinguees.
- Selected Y evidence: n_detections denombre les detections; occupation et detectabilite doivent rester distinguees.
- Selected Y typology: count
- x_terms_used: mat200, mat500, mat1000, mat1500, mat2000, elev
- y_term_used: n_detections
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

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
    formula: "n_detections ~ mat200 + mat500 + mat1000 + mat1500 + mat2000 + elev"
    response: "n_detections (nombre de detections de planeur du sucre sur 5 visites de site, proxy continu/comptage d'occupation)"
    predictors: ["mat200-mat2000 (etendue de foret mature dans des tampons de 200 a 2000m)", "elev (elevation)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "n_detections ~ mat200 + mat500 + mat1000 + mat1500 + mat2000 + elev"
    response: "n_detections"
    predictors: ["mat200", "mat500", "mat1000", "mat1500", "mat2000", "elev"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["glm_logistic", "random_forest", "random_forest_xy", "xgboost", "gwr"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_sugarglider_occupancy`
- Dataset name: Using machine learning to model nontraditional spatial dependence in occupancy data
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Occupancy patterns of the introduced, predatory sugar glider in Tasmanian forests
- Paper DOI: 10.1111/aec.12583
- Dataset DOI: 10.5061/dryad.4xgxd259g
- Source URL: https://doi.org/10.5061/dryad.4xgxd259g
- Year: 2018

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "psi(occupancy) ~ mature_forest_extent(200-2000m) + elev ; p(detection) ~ temperature + wind + moonlight + owl_playback [modele d'occupation-detection (site-occupancy model), naive occupancy = 0.79, detectabilite = 0.52 +/- 0.03 sur 5 visites]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Allen, Webb, Alves, Heinsohn & Stojanovic (2018) (auteurs corriges le 2026-09-14 -- confirmes via Crossref ; 'Cooper' n'est pas un auteur de ce papier, les vrais 3e et 4e auteurs sont Alves et Heinsohn), Occupancy patterns of the introduced, predatory sugar glider in Tasmanian forests, Austral Ecology, doi:10.1111/aec.12583. Le papier ajuste un modele d'occupation-detection sur 100 sites du Southern Forest, Tasmanie (naive occupancy=0.79, confirme empiriquement : 79/100 sites avec au moins une detection dans les donnees locales). formula_used utilise le nombre total de detections (n_detections, somme des 5 visites) comme proxy continu de l'occupation, contre les covariables d'habitat reelles du papier (etendue de foret mature a plusieurs echelles de tampon, elevation) ; les covariables de detectabilite (temperature, vent, lune, appel de chouette) restent disponibles dans l'artefact local mais ne sont pas retenues dans formula_used (elles modelisent p, pas psi, dans le cadre occupation-detection original). Donnees brutes (Sugarglider.csv) telechargees directement depuis Dryad (10.5061/dryad.4xgxd259g, depot reutilisant les donnees originales de Stojanovic pour un papier methodologique sur la dependance spatiale) -- pas une reconstruction, N=100 sites, coordonnees reelles (Southern Forest, Tasmanie, converties de UTM zone 55S vers WGS84)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_count"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Y/X/formula_used deja resolus ; estimateurs generiques (count) ajoutes en revue de lot du 2026-09-09."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Y/X/formula_used deja resolus ; estimateurs generiques (count) ajoutes en revue de lot du 2026-09-09.

## Estimator eligibility

```yaml
estimator_eligibility:
  eligible_estimators:
    - estimator: ols
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Regression (famille Poisson) generique pour reponse de comptage."
    - estimator: gam_spatial
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "GAM (famille Poisson), baseline generique pour reponse de comptage."
    - estimator: xgboost
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Alternative ML generique (objectif Poisson), Y comptage. random_forest exclu -- pas de mode Poisson natif dans ranger/parsnip."
  conditionally_eligible_estimators: []
  ineligible_reason: "n/a -- estimateurs generiques eligibles (voir eligible_estimators)."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 100
- k variables: 44
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [146.8177108, 147.0843991], y [-43.4253773, -43.0707424]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32755 (UTM Zone 55S (EPSG:32755)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- Reproducibility status: OK - loader R enregistre et reexecutable (`sugarglider_occupancy` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `sugarglider_occupancy` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20%: survey5 (NA=76%), d5 (NA=77%), temp5 (NA=76%), wind5 (NA=76%), moon5 (NA=76%), owl5 (NA=76%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`sugarglider_occupancy` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Occupancy patterns of the introduced, predatory sugar glider in Tasmanian forests

## Curation documentée — 2026-09-07

Le nom paper_sugar_glider dans la demande correspond a paper_sugarglider_occupancy. Depot local de reutilisation : 10.5061/dryad.4xgxd259g ; depot original cite : 10.5061/dryad.xgxd254bt ; article de l’etude originale : 10.1111/aec.12583. Les deux DOI Dryad sont des datasets, pas des articles; relation DERIVED_FROM conservee dans le KG. Verification : https://datadryad.org/dataset/doi%3A10.5061/dryad.4xgxd259g .

Decision conservatoire : Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. n_detections denombre les detections; occupation et detectabilite doivent rester distinguees. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : count. n_detections denombre les detections; occupation et detectabilite doivent rester distinguees.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
