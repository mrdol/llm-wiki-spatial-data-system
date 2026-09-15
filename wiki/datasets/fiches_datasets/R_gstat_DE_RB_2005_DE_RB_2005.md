---
title: R_gstat_DE_RB_2005_DE_RB_2005
type: dataset
created: 2026-08-15
updated: 2026-09-07
sources:
  - data/final_datasets/sf/R_gstat_DE_RB_2005_DE_RB_2005.rds
tags: [dataset, r-package, spatial, point]
---

Spatio-temporal data set with rural background PM10 concentrations in Germany 2005 (airbase v6).

## Description du jeu de donnees

- Topic: dataset spatial spatio-temporel
- Observation unit: observation spatiale de type POINT
- Observed population: 23230 enregistrements dans l’artefact local R_gstat_DE_RB_2005_DE_RB_2005.rds; unite declaree : observation spatiale de type POINT. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: Etendue mesuree dans le RDS : x [307809.2950771025, 907374.8163783394], y [5295751.875273415, 6086661.149044107]; CRS EPSG:32632 (UTM zone 32N, WGS84) -- confirme dans le `proj4string` de l'objet `SpatialPointsDataFrame` source du package `gstat` (`+init=epsg:32632 +proj=utm +zone=32 +datum=WGS84`), non embarque dans le `.rds` local.
- Temporal context: dimension temporelle structurelle detectee
- Source description: Spatio-temporal data set with rural background PM10 concentrations in Germany 2005 (airbase v6).
- Description source: package R `gstat`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `PM10`, `annual_mean_PM10`
- Candidate Y typology: continuous
- Candidate X variables: `station_altitude`, `type_of_station`, `station_type_of_area`, `street_type`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `coords.x1`, `coords.x2`, `X`, `Y`
- Identifier columns (excluded from X candidates): `sp.ID`, `station_european_code`, `country_iso_code`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PM10` | `numeric` | continuous | [0, 177] | 0% |
| `annual_mean_PM10` | `numeric` | continuous | [9.8073, 27.7456] | 0% |


> Selection Y/X (claude-sonnet-4-6) : PM10 (mesure instantanée/journalière) et annual_mean_PM10 (agrégat annuel) sont les variables réponse naturelles pour modéliser la concentration en particules fines ; station_altitude, type_of_station, station_type_of_area et street_type sont des covariables explicatives classiques capturant le contexte géographique et environnemental des stations. Les colonnes temporelles (time, endTime, station_start_date, station_end_date), l'index ..1 et T (facteur ambigu/redondant) sont ignorés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `station_altitude` | `integer` | continuous | 0% |
| `type_of_station` | `factor` | categorical | 0% |
| `station_type_of_area` | `factor` | categorical | 0% |
| `street_type` | `factor` | categorical | 0% |


### Formule — niveau publication

- formula_pub: PM10 ~ 1
- x_terms_pub: aucun (krigeage ordinaire — la syntaxe gstat `~1` denote l'absence de tendance externe/covariable, ce n'est pas un champ laisse vide par erreur)
- y_term_pub: PM10
- Reference publication: Gräler B., Pebesma E., Heuvelink G. (2016) Spatio-Temporal Interpolation using gstat. The R Journal, 8(1), 204–218, DOI 10.32614/RJ-2016-014. Formule verifiee directement dans le code publie par les auteurs (legende Figure 7, demo `stkrige-prediction` du package) : `krigeST(PM10 ~1, data = DE_RB_2005[, tIDS], newdata = DE_pred, fitSumMetricModel, nmax = 50, stAni = fitMetricModel$stAni / 24 / 3600)`.

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d'estimation: formule systeme generee a partir des covariables locales (formula_pub est confirmee et verifiee dans le code publie, mais correspond a un krigeage ordinaire `~1` sans covariable — non utilisable telle quelle pour un benchmark de regression supervisee Y ~ X)
- Correspondance Python/R: aucune identifiee
- Note: Formule publiee (`PM10 ~ 1`, krigeage ordinaire) verifiee dans le code R des auteurs (appel `krigeST()`, Figure 7 de l'article) — voir section precedente. Ce n'est PAS la formule retenue comme formula_used : le benchmark package necessite au moins une covariable X, donc formula_used bascule sur le candidat `ml_or_selected` (genere a partir des covariables de station reellement presentes dans l'artefact local), explicitement etiquete comme genere et non publie.

### Formule — niveau systeme

- formula_used: PM10 ~ station_altitude + type_of_station + station_type_of_area + street_type
- Formula used evidence: generated_system_formula (distincte de formula_pub — voir Note ci-dessus)
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: station_altitude, type_of_station, station_type_of_area, street_type
- y_term_used: PM10

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "PM10 ~ 1"
    response: "PM10"
    predictors: []
    role: "simple_baseline"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Gräler, Pebesma & Heuvelink (2016), The R Journal 8(1):204-218, DOI 10.32614/RJ-2016-014 -- formule verifiee dans le code publie (krigeST(PM10 ~1, ...), legende Figure 7)"
    estimator_context: ["kriging_ordinary", "spatiotemporal_covariance_baseline"]
    status: "confirmed"

  multivariate_constrained:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "paper_main_specification"
    source_type: "none_found"
    source_ref: "Le papier ne publie aucune formule de regression multivariee sur ce jeu -- sa contribution porte sur la modelisation de la covariance/du variogramme spatio-temporel (modeles separable, produit-somme, metrique, sum-metric) pour le krigeage, pas sur une regression Y ~ X avec les covariables de station."
    estimator_context: []
    status: "unavailable"

  ml_or_selected:
    formula: "PM10 ~ station_altitude + type_of_station + station_type_of_area + street_type"
    response: "PM10"
    predictors: ["station_altitude", "type_of_station", "station_type_of_area", "street_type"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "Covariables de station presentes dans l'artefact local (cf. Detail X), non utilisees par la formule publiee (krigeage ordinaire ~1) -- candidate generee pour un usage ML/benchmark futur, pas une formule publiee ou verifiee dans l'article. Retenue comme formula_used (voir section 'Formule - niveau systeme')."
    estimator_context: ["random_forest", "xgboost", "gam_spatial"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `R_gstat_DE_RB_2005_DE_RB_2005`
- Dataset name: gstat::DE_RB_2005
- Source family: r-package
- Source: package R `gstat` (version 2.1.6)
- Source URL: https://CRAN.R-project.org/package=gstat
- Dataset DOI: none
- Publication DOI: 10.32614/RJ-2016-014
- Year: 2003

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "PM10 ~ 1"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Gräler B., Pebesma E., Heuvelink G. (2016) Spatio-Temporal Interpolation using gstat. The R Journal, 8(1), 204–218"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatio-temporel
- Structure: panel
- N observations: 23230
- T periods: 365
- Variable temporelle: time
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (23230) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 69 ; panel NON EQUILIBRE (T par unite : min=79, mediane=357, max=365). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 69 unites spatiales distinctes, pas sur les 23230 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.
- Temporal note: dimension temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: pending inspection
- Spatial extent: x [307809.2951, 907374.8164], y [5295751.8753, 6086661.149] (EPSG:32632, via documentation)
- Time range: pending inspection
- Type de geometrie: POINT
- CRS EPSG: 32632 (source: proj4string de l'objet SpatialPointsDataFrame du package `gstat`, .rds local sans CRS embarque)
- CRS nom: WGS 84 / UTM zone 32N
- CRS analyse recommande: 32632 (deja une projection metrique adaptee, aucune reprojection necessaire)

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2.0)
- License URL: https://CRAN.R-project.org/package=gstat
- License open: yes
- Reproducibility status: available via package R `gstat`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "formula_used generee (ml_or_selected) a partir des covariables de station reellement documentees (station_altitude, type_of_station, station_type_of_area, street_type) -- la formule publiee est un krigeage `~1` sans covariable, non utilisable telle quelle pour un benchmark supervise Y~X ; panel spatio-temporel non equilibre reel (69 stations, T par station de 79 a 365 jours, cf. Bloc 4) -- utiliser un schema de validation croisee regroupe par station pour eviter toute fuite entre train et test."
  reason: "Y continu reel (PM10), covariables X reelles issues des metadonnees de station (pas inventees, cf. Detail X). Formule publiee confirmee mais non exploitable pour une regression supervisee (krigeage ordinaire sans covariable) ; formula_used bascule donc sur la formule candidate generee, explicitement etiquetee comme telle (source_type: generated_system_formula). Un jeu de donnees genere/panel non equilibre ne bloque pas package_include a lui seul (convention deja appliquee ailleurs, ex. paper_fhb_ensembling) -- documenter le besoin de CV groupe par station suffit."
```

- Decision: ready
- Manque principal: formula_used generee (pas publiee) ; schema de CV groupe par station recommande vu la structure panel non equilibree
- Raison: Y et X reels et locaux ; formule publiee non exploitable en regression supervisee (krigeage `~1`) donc formula_used repose sur la candidate generee ml_or_selected ; structure panel documentee mais non bloquante.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK (verifie 2026-09-10) - formula_pub `PM10 ~ 1` confirmee dans le code source publie par les auteurs (`krigeST()`, Figure 7) ; DOI publication renseigne (10.32614/RJ-2016-014). Ce krigeage ordinaire n'a pas de covariable, donc formula_used est deliberement distincte : formule generee (ml_or_selected) a partir des covariables de station deja documentees en Detail X (station_altitude, type_of_station, station_type_of_area, street_type), etiquetee explicitement comme generee et non publiee.
- CRS: OK (resolu 2026-09-10) - CRS absent du `.rds` local, mais confirme dans le proj4string de l'objet source du package `gstat` (EPSG:32632) et reporte dans le Bloc 5.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2.0)).

## Related Pages

- Source: package R `gstat`

## Curation documentée — 2026-09-07

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
