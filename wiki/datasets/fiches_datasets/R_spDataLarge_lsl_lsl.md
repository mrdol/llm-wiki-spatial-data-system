---
title: R_spDataLarge_lsl_lsl
type: dataset
created: 2026-08-15
updated: 2026-09-16
sources:
  - data/final_datasets/sf/R_spDataLarge_lsl_lsl.rds
tags: [dataset, r-package, spatial, point]
---

Data used in the "Statistical learning for geographic data" chapter in Geocomputation with R. See <https://r.geocompx.org/spatial-cv.html> for details.

## Description du jeu de donnees

- Topic: Donnees de r-package : R_spDataLarge_lsl_lsl
- Observation unit: observation spatiale de type POINT
- Observed population: 350 enregistrements dans l’artefact local R_spDataLarge_lsl_lsl.rds; unite declaree : observation spatiale de type POINT. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: Etendue mesuree dans le RDS : x [712197.726935, 715737.726935], y [9556946.759956, 9560806.759956]; CRS non renseigne, repere/unites a documenter.
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Data used in the "Statistical learning for geographic data" chapter in Geocomputation with R. See <https://r.geocompx.org/spatial-cv.html> for details.
- Description source: package R `spDataLarge`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `lslpts`
- Candidate Y typology: categorical
- Candidate X variables: `slope`, `cplan`, `cprof`, `elev`, `log10_carea`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `lslpts` | `factor` | categorical | None | 0% |


> Selection Y/X (claude-sonnet-4-6) : lslpts est la variable réponse binaire/catégorielle indiquant la présence/absence de glissements de terrain (landslide points), typique d'un problème de classification spatiale. Les cinq autres colonnes sont des variables topographiques continues (pente, courbures planaire et profilée, altitude, aire de contribution drainée) qui constituent les covariables explicatives classiques pour modéliser la susceptibilité aux glissements de terrain.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `slope` | `numeric` | continuous | 0% |
| `cplan` | `numeric` | continuous | 0% |
| `cprof` | `numeric` | continuous | 0% |
| `elev` | `numeric` | continuous | 0% |
| `log10_carea` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: lslpts ~ slope + cplan + cprof + elev + log10_carea
- x_terms_pub: slope, cplan, cprof, elev, log10_carea
- y_term_pub: lslpts
- Reference publication: Muenchow, J., Brenning, A., Richter, R. (2012) Geomorphic process rates of landslides along a humidity gradient in the tropical Andes. Geomorphology 139-140, 271-284.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: lslpts ~ slope + cplan + cprof + elev + log10_carea
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: categorical
- x_terms_used: slope, cplan, cprof, elev, log10_carea
- y_term_used: lslpts

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "lslpts ~ slope + cplan + cprof + elev + log10_carea"
    response: "lslpts"
    predictors: ["slope, cplan, cprof, elev, log10_carea"]
    role: "simple_baseline"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Muenchow, J., Brenning, A., Richter, R. (2012) Geomorphic process rates of landslides along a humidity gradient in the tropical Andes. Geomorphology 139-140, 271-284."
    estimator_context: ["linear_regression", "kriging_auxiliary", "spatial_baseline"]
    status: "confirmed"

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
    formula: "pending"
    response: "pending"
    predictors: []
    role: "ml_candidate_features"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `R_spDataLarge_lsl_lsl`
- Dataset name: spDataLarge::lsl
- Source family: r-package
- Source: package R `spDataLarge` (version 2.2.0)
- Source URL: https://CRAN.R-project.org/package=spDataLarge
- Dataset DOI: none
- Publication DOI: 10.1016/j.geomorph.2011.10.029
- Year: 2017

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "lslpts ~ slope + cplan + cprof + elev + log10_carea"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Muenchow, J., Brenning, A., Richter, R. (2012) Geomorphic process rates of landslides along a humidity gradient in the tropical Andes. Geomorphology 139-140, 271-284."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 350
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [712197.7269, 715737.7269], y [9556946.76, 9560806.76] (EPSG:32717, via documentation)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 32717 (source: documentation du package, .rds sans CRS embarque)
- CRS nom: unknown
- CRS analyse recommande: aucune reprojection necessaire -- CRS deja projete et metrique. (EPSG:32717, WGS 84 / UTM zone 17S) (correction 2026-09-16, mode production de secours : le texte precedent affirmait a tort "CRS source non geographique ou inconnu" alors que le CRS est deja connu et renseigne ci-dessus -- incoherence interne du meme type que celle corrigee sur paper_banff_stream_temperature.)

## Bloc 6 — Reproductibilite

- License present: yes
- License name: CC0
- License URL: https://CRAN.R-project.org/package=spDataLarge
- License open: yes
- Reproducibility status: available via package R `spDataLarge`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_non_continuous_response"
  benchmark_task: "not_current_regression_benchmark"
  package_include: "no"
  has_local_rds: true
  missing_items: "route classification/binomiale/survie ou transformation continue explicite requise"
  reason: "La variable reponse ou la formule n est pas une regression continue scalaire compatible avec le benchmark actuel."
```

- Decision: not_ready_non_continuous_response
- Manque principal: route classification/binomiale/survie ou transformation continue explicite requise
- Raison: La variable reponse ou la formule n est pas une regression continue scalaire compatible avec le benchmark actuel.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: WARN - CRS absent du `.rds` source ; EPSG:32717 extrait de la documentation et reporte dans le Bloc 5.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (CC0).

## Related Pages

- Source: package R `spDataLarge`

## Curation documentée — 2026-09-07

Typologie de la reponse selectionnee : categorical. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
