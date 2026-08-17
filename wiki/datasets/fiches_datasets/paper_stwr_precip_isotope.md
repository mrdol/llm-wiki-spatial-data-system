---
title: paper_stwr_precip_isotope
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_stwr_precip_isotope.rds
  - MediumPriorityRetry_10_5281_zenodo_3637689
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "A spatiotemporal weighted regression model (STWR v1.0) for analyzing local nonstationarity in space and time" (DOI 10.5194/gmd-13-6149-2020).

## Description du jeu de donnees

- Topic: geochimie / isotopes des precipitations et modelisation spatio-temporelle
- Observation unit: station de mesure
- Observed population: stations de mesure d'isotopes de precipitation, nord-est des Etats-Unis, N=272
- Geographic context: Journal-first discovery: paper published in a spatial-econometrics-scoped journal (see tools/harvest_journal_first.py DEFAULT_SOURCES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: A spatiotemporal weighted regression model (STWR v1.0) for analyzing local nonstationarity in space and time
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: low
- Paper DOI: 10.5194/gmd-13-6149-2020
- Dataset DOI: 10.5281/zenodo.3637689
- Source URL: 10.5281/zenodo.3637689
- Local raw dir: `data/raw/papers/MediumPriorityRetry_10_5281_zenodo_3637689/`
- Local sf output: `data/final_datasets/sf/paper_stwr_precip_isotope.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `d2h`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Elevation`, `ppt`, `tmean`
- Candidate X count in local artifact: 3
- Candidate X typology: continuous
- Published X variables from paper: ppt (precipitation totale journaliere, pluie + neige fondue), tmean (temperature moyenne journaliere), height/Elevation (elevation du site)
- Published X count: 3
- Coordinates (x, y - excluded from X candidates): `Longitude`, `Latitude`
- Identifier columns (excluded from X candidates): `timestamp`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `d2h` | `numeric` | continuous | [-170.6813, -17.0496] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `stwr_precip_isotope`, la ou les reponses `d2h` viennent du loader papier et/ou des preuves de l article `A spatiotemporal weighted regression model (STWR v1.0) for analyzing local nonstationarity in space and time`. Les covariables X retenues sont `ppt`, `tmean`, `Elevation`. Les coordonnees (`Longitude`, `Latitude`), identifiants (`timestamp`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Elevation` | `integer` | continuous | 0% |
| `ppt` | `numeric` | continuous | 0% |
| `tmean` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: d2h ~ ppt + tmean + height [Eq. 21 du papier : modele de regression spatio-temporelle ponderee (STWR), compare a GWR et GTWR, sur les isotopes d'hydrogene des precipitations (delta2H) dans le nord-est des Etats-Unis]
- x_terms_pub: ppt (precipitation totale journaliere, pluie + neige fondue), tmean (temperature moyenne journaliere), height/Elevation (elevation du site)
- y_term_pub: d2h (isotope d'hydrogene des precipitations, delta2H, per mille)
- Reference publication: Que et al. (2020), A spatiotemporal weighted regression model (STWR v1.0) for analyzing local nonstationarity in space and time, Geoscientific Model Development, doi:10.5194/gmd-13-6149-2020. Le papier presente l'equation exacte (Eq. 21) : y = b0 + b1*ppt + b2*tmean + b3*height + e, appliquee a un jeu de donnees reel de 272 points de mesure d'isotopes d'hydrogene des precipitations dans le nord-est des Etats-Unis ('272 points for model calibration', correspond exactement a N=272 du fichier precip_isotope_D3.csv). Donnees brutes telechargees directement depuis le depot logiciel Zenodo du papier (10.5281/zenodo.3637689) -- pas une reconstruction, formule et N confirmes par lecture directe du texte (TEI).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: d2h ~ ppt + tmean + Elevation
- x_terms_used: ppt, tmean, Elevation
- y_term_used: d2h
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
    formula: "d2h ~ ppt + tmean + Elevation"
    response: "d2h (isotope d'hydrogene des precipitations, delta2H, per mille)"
    predictors: ["ppt (precipitation totale journaliere, pluie + neige fondue)", "tmean (temperature moyenne journaliere)", "height/Elevation (elevation du site)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "d2h ~ ppt + tmean + Elevation"
    response: "d2h"
    predictors: ["ppt", "tmean", "Elevation"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "gwr", "sar_lag", "sem_error", "random_forest"]
    status: "confirmed_continuous_response"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_stwr_precip_isotope`
- Dataset name: 10.5281/zenodo.3637689
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: A spatiotemporal weighted regression model (STWR v1.0) for analyzing local nonstationarity in space and time
- Paper DOI: 10.5194/gmd-13-6149-2020
- Dataset DOI: 10.5281/zenodo.3637689
- Source URL: 10.5281/zenodo.3637689
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "d2h ~ ppt + tmean + height [Eq. 21 du papier : modele de regression spatio-temporelle ponderee (STWR), compare a GWR et GTWR, sur les isotopes d'hydrogene des precipitations (delta2H) dans le nord-est des Etats-Unis]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Que et al. (2020), A spatiotemporal weighted regression model (STWR v1.0) for analyzing local nonstationarity in space and time, Geoscientific Model Development, doi:10.5194/gmd-13-6149-2020. Le papier presente l'equation exacte (Eq. 21) : y = b0 + b1*ppt + b2*tmean + b3*height + e, appliquee a un jeu de donnees reel de 272 points de mesure d'isotopes d'hydrogene des precipitations dans le nord-est des Etats-Unis ('272 points for model calibration', correspond exactement a N=272 du fichier precip_isotope_D3.csv). Donnees brutes telechargees directement depuis le depot logiciel Zenodo du papier (10.5281/zenodo.3637689) -- pas une reconstruction, formule et N confirmes par lecture directe du texte (TEI)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun -- CSV original telecharge directement depuis le depot logiciel Zenodo du papier, N=272 identique au chiffre publie"
  reason: "Y continu reel (delta2H, isotope d'hydrogene des precipitations), N=272 stations avec coordonnees reelles (nord-est des Etats-Unis), covariables exactement celles de l'equation 21 du papier (precipitation, temperature, elevation). CSV original telecharge directement depuis Zenodo, pas une reconstruction. Formule et N confirmes par lecture directe du texte integral (correspondance exacte : 272 points de calibration cites dans le papier = N du fichier)."
```

- Decision: ready
- Manque principal: aucun -- CSV original telecharge directement depuis le depot logiciel Zenodo du papier, N=272 identique au chiffre publie
- Raison: Y continu reel (delta2H, isotope d'hydrogene des precipitations), N=272 stations avec coordonnees reelles (nord-est des Etats-Unis), covariables exactement celles de l'equation 21 du papier (precipitation, temperature, elevation). CSV original telecharge directement depuis Zenodo, pas une reconstruction. Formule et N confirmes par lecture directe du texte integral (correspondance exacte : 272 points de calibration cites dans le papier = N du fichier).

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
- N observations: 272
- k variables: 9
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-124.053, -68.8349], y [34.27935, 44.734433]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=55.2deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`stwr_precip_isotope` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `stwr_precip_isotope` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`stwr_precip_isotope` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: A spatiotemporal weighted regression model (STWR v1.0) for analyzing local nonstationarity in space and time

