---
title: R_gstat_wind_wind.loc
type: dataset
created: 2026-08-15
updated: 2026-09-16
sources:
  - data/final_datasets/sf/R_gstat_wind_wind.loc.rds
tags: [dataset, r-package, spatial, point]
---

Daily average wind speeds for 1961-1978 at 12 synoptic meteorological stations in the Republic of Ireland (Haslett and raftery 1989). Wind speeds are in knots (1 knot = 0.5418 m/s), at each of the stations in the order given in Fig.4 of Haslett and Raftery (1989, see below)

## Description du jeu de donnees

- Topic: Donnees de r-package : R_gstat_wind_wind.loc
- Observation unit: observation spatiale de type POINT
- Observed population: 12 enregistrements dans l’artefact local R_gstat_wind_wind.loc.rds; unite declaree : observation spatiale de type POINT. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: Etendue mesuree dans le RDS : x [1, 12], y [1, 12]; CRS non renseigne, repere/unites a documenter.
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Daily average wind speeds for 1961-1978 at 12 synoptic meteorological stations in the Republic of Ireland (Haslett and raftery 1989). Wind speeds are in knots (1 knot = 0.5418 m/s), at each of the stations in the order given in Fig.4 of Haslett and Raftery (1989, see below)
- Description source: package R `gstat`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `MeanWind`
- Candidate Y typology: continuous
- Candidate X variables: not identified by LLM classification — manual review required
- Candidate X typology: unknown
- Coordinates (x, y — excluded from X candidates): `Latitude`, `Longitude`, `X`, `Y`
- Identifier columns (excluded from X candidates): `Code`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `MeanWind` | `numeric` | continuous | [3.25, 8.03] | 0% |


> Selection Y/X (claude-sonnet-4-6) : MeanWind (vitesse moyenne du vent en nœuds) est la seule variable quantitative mesurée et constitue naturellement la variable réponse à modéliser spatialement. Station est un label administratif/géographique identifiant les sites de mesure, non pertinent comme covariable explicative au sens strict (et déjà exclu comme identifiant).

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| — | — | aucun candidat | — |


### Formule — niveau publication

- formula_pub: not_applicable - table de localisation des stations uniquement (Station, Code, Latitude, Longitude, MeanWind), pas les donnees modelisees. Le modele spatio-temporel de Haslett & Raftery porte sur l'objet separe `wind` (series quotidiennes de vitesse de vent transformees), non present dans ce depot.
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Haslett, J. and Raftery, A. E. (1989) Space-time Modelling with Long-memory Dependence: Assessing Ireland's Wind Power Resource. Applied Statistics.

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

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

- Dataset ID: `R_gstat_wind_wind.loc`
- Dataset name: gstat::wind
- Source family: r-package
- Source: package R `gstat` (version 2.1.6)
- Source URL: https://CRAN.R-project.org/package=gstat
- Dataset DOI: none
- Publication DOI: 10.2307/2347679
- Year: 2003

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "null"
  equation_family: n/a
  model_family: "n/a"
  source_type: none_found
  source_ref: "null"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 12
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [1, 12], y [1, 12] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84 (Latitude/Longitude fournies en degres-minutes-secondes dans la documentation gstat::wind, a convertir via char2dms())
- CRS analyse recommande: reprojection recommandee vers un CRS metrique local (ex. Irish Transverse Mercator, EPSG:2157) -- coordonnees actuellement en WGS84 geographique (degres), peu adaptees au calcul direct de distances/voisinage pour ce reseau de stations en Irlande.

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
  benchmark_status: "not_ready_missing_formula"
  benchmark_task: "not_current_regression_benchmark"
  package_include: "no"
  has_local_rds: true
  missing_items: "formule Y ~ X executable manquante"
  reason: "Aucune formule systeme ou publication n est disponible pour ce jeu de donnees package."
```

- Decision: not_ready_missing_formula
- Manque principal: formule Y ~ X executable manquante
- Raison: Aucune formule systeme ou publication n est disponible pour ce jeu de donnees package.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: WARN - Y identifiee, mais X non identifiees automatiquement.
- Formula: PENDING - formule publication non encore etablie.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2.0)).

## Related Pages

- Source: package R `gstat`

## Curation documentée — 2026-09-07

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

Verification 2026-09-15 (mode production de secours, tools::Rd_db("gstat")) : DOI resolu (10.2307/2347679, verifie via Crossref) pour Haslett & Raftery (1989), Applied Statistics 38:1-50. CRS confirme WGS84 (Latitude/Longitude en DMS dans wind.loc, converties via sp::char2dms() dans les exemples officiels du package). formula_pub reste a juste titre not_applicable -- wind.loc est la table de localisation des stations, le modele spatio-temporel de Haslett & Raftery porte sur l'objet separe `wind` (series quotidiennes), absent de ce depot -- decision deja bien fondee, non modifiee.

Correction 2026-09-16 (mode production de secours) : le champ 'CRS analyse recommande' affirmait a tort que le CRS source etait non geographique/inconnu alors qu'il etait deja renseigne juste au-dessus -- corrige (voir le champ lui-meme pour le texte actuel).
