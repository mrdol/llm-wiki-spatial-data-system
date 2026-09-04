---
title: paper_checkerspot_phenology
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_checkerspot_phenology.rds
  - DatasetFirst_10_5061_dryad_rr4xgxdhk
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Phenological mismatch is less important than total nectar availability for checkerspot butterflies" (DOI 10.1002/ecy.4461).

## Description du jeu de donnees

- Topic: phenologie / decalage phenologique et papillons
- Observation unit: occurrence de musee/citizen-science georeferencee
- Observed population: papillon demi-lune de Baltimore (Euphydryas phaeton), Amerique du Nord, 1877-2017, N=1989 occurrences
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: 128 distinct periods (variable: year)
- Source description: Phenological mismatch is less important than total nectar availability for checkerspot butterflies
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1002/ecy.4461
- Dataset DOI: 10.5061/dryad.rr4xgxdhk
- Source URL: https://doi.org/10.5061/dryad.rr4xgxdhk
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_rr4xgxdhk/`
- Local sf output: `data/final_datasets/sf/paper_checkerspot_phenology.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `startDayOfYear`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `basisOfRecord`, `scientificName`, `eventDate`, `year`, `month`, `day`, `dayCode`, `lifeStage`, `lifeStageNotes`, `generalNotes`, `locationNotes`, `stateProvince`, `county`, `municipality`, `locality`, `coordinateUncertaintyInMeters`, `coordinateSource`, `picture`, `within.year.duplicate...place.`, `within.year.duplicate...county.`
- Candidate X count in local artifact: 20
- Candidate X typology: categorical
- Published X variables from paper: decimalLatitude (gradient latitudinal), year (tendance temporelle, changement climatique)
- Published X count: 2
- Coordinates (x, y - excluded from X candidates): `decimalLongitude`, `decimalLatitude`
- Identifier columns (excluded from X candidates): `ocurrenceID`, `collectionCode`, `database`, `recordedBy`, `id`, `lat2`, `lon2`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `startDayOfYear` | `numeric` | continuous | [97, 268] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `checkerspot_phenology`, la ou les reponses `startDayOfYear` viennent du loader papier et/ou des preuves de l article `Phenological mismatch is less important than total nectar availability for checkerspot butterflies`. Les covariables X retenues sont `year` ; 19 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`decimalLongitude`, `decimalLatitude`), identifiants (`ocurrenceID`, `collectionCode`, `database`, `recordedBy`, `id`, `lat2`, `lon2`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `basisOfRecord` | `character` | categorical | 0% |
| `scientificName` | `character` | categorical | 0% |
| `eventDate` | `character` | categorical | 0% |
| `year` | `character` | categorical | 0% |
| `month` | `character` | categorical | 0% |
| `day` | `character` | categorical | 0% |
| `dayCode` | `character` | categorical | 0% |
| `lifeStage` | `character` | categorical | 0% |
| `lifeStageNotes` | `character` | categorical | 70.3% |
| `generalNotes` | `character` | categorical | 91.2% |
| `locationNotes` | `character` | categorical | 79.3% |
| `stateProvince` | `character` | categorical | 0.1% |
| `county` | `character` | categorical | 21.7% |
| `municipality` | `character` | categorical | 83% |
| `locality` | `character` | categorical | 13.6% |
| `coordinateUncertaintyInMeters` | `character` | categorical | 44.9% |
| `coordinateSource` | `character` | categorical | 8.8% |
| `picture` | `character` | categorical | 0% |
| `within.year.duplicate...place.` | `character` | categorical | 56.4% |
| `within.year.duplicate...county.` | `character` | categorical | 72.6% |

### Formule - niveau publication

- formula_pub: startDayOfYear ~ latitude + year [analyse de decalage phenologique sur 140 ans d'archives de musee/citizen-science de papillons demi-lune de Baltimore (Baltimore checkerspot, Euphydryas phaeton), comparee a la disponibilite de nectar sur le terrain]
- x_terms_pub: decimalLatitude (gradient latitudinal), year (tendance temporelle, changement climatique)
- y_term_pub: startDayOfYear (jour julien de premiere observation/collection du papillon demi-lune de Baltimore, proxy de phenologie de vol)
- Reference publication: Auteurs non individualises dans les metadonnees locales (2024), Phenological mismatch is less important than total nectar availability for checkerspot butterflies, Ecology, doi:10.1002/ecy.4461. Le papier compare la phenologie historique (archives de musee/citizen-science, 1877-2017) du papillon demi-lune de Baltimore (Euphydryas phaeton, dossier bcbformattedFINAL.csv) a des mesures de terrain de disponibilite de nectar (transects.csv, nectar.csv) sur des sites nommes sans coordonnees precises -- formula_used utilise uniquement le sous-jeu georeference (occurrences de musee avec decimalLatitude/decimalLongitude reelles) pour une regression continue latitude-annee, standard pour ce type d'etude phenologique. PDF non recupere localement (bloque par anti-bot Wiley, 403) -- confirme via OpenAlex et le depot Zenodo du code d'analyse associe (10.5281/zenodo.13760920). Donnees brutes telechargees directement depuis Dryad (10.5061/dryad.rr4xgxdhk) -- pas une reconstruction, N=1989 occurrences georeferencees.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: startDayOfYear ~ decimalLatitude + year
- x_terms_used: year
- y_term_used: startDayOfYear
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
    formula: "startDayOfYear ~ decimalLatitude + year"
    response: "startDayOfYear (jour julien de premiere observation/collection du papillon demi-lune de Baltimore, proxy de phenologie de vol)"
    predictors: ["decimalLatitude (gradient latitudinal)", "year (tendance temporelle, changement climatique)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "startDayOfYear ~ decimalLatitude + decimalLongitude + year"
    response: "startDayOfYear"
    predictors: ["decimalLatitude", "decimalLongitude", "year"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "gam_spatial", "random_forest", "gwr"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_checkerspot_phenology`
- Dataset name: Phenological mismatch is less important than total nectar availability for checkerspot butterflies
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Phenological mismatch is less important than total nectar availability for checkerspot butterflies
- Paper DOI: 10.1002/ecy.4461
- Dataset DOI: 10.5061/dryad.rr4xgxdhk
- Source URL: https://doi.org/10.5061/dryad.rr4xgxdhk
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "startDayOfYear ~ latitude + year [analyse de decalage phenologique sur 140 ans d'archives de musee/citizen-science de papillons demi-lune de Baltimore (Baltimore checkerspot, Euphydryas phaeton), comparee a la disponibilite de nectar sur le terrain]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Auteurs non individualises dans les metadonnees locales (2024), Phenological mismatch is less important than total nectar availability for checkerspot butterflies, Ecology, doi:10.1002/ecy.4461. Le papier compare la phenologie historique (archives de musee/citizen-science, 1877-2017) du papillon demi-lune de Baltimore (Euphydryas phaeton, dossier bcbformattedFINAL.csv) a des mesures de terrain de disponibilite de nectar (transects.csv, nectar.csv) sur des sites nommes sans coordonnees precises -- formula_used utilise uniquement le sous-jeu georeference (occurrences de musee avec decimalLatitude/decimalLongitude reelles) pour une regression continue latitude-annee, standard pour ce type d'etude phenologique. PDF non recupere localement (bloque par anti-bot Wiley, 403) -- confirme via OpenAlex et le depot Zenodo du code d'analyse associe (10.5281/zenodo.13760920). Donnees brutes telechargees directement depuis Dryad (10.5061/dryad.rr4xgxdhk) -- pas une reconstruction, N=1989 occurrences georeferencees."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "le papier compare phenologie historique et disponibilite de nectar sur le terrain (sites nommes sans coordonnees) ; formula_used utilise uniquement le sous-jeu georeference (occurrences de musee), pas la comparaison complete du papier ; PDF non recupere localement (bloque anti-bot) -- promu a package_include='yes' apres validation utilisateur (session 2026-08-16, groupe A)"
  reason: "Y continu reel (jour julien d'observation), N=1989 occurrences de musee/citizen-science georeferencees (1877-2017, Amerique du Nord), covariables latitude/annee reelles pour une analyse phenologie-climat standard. CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier identifie via OpenAlex (le paper_doi initial pointait vers le depot Zenodo du code, pas l'article)."
```

- Decision: ready
- Manque principal: le papier compare phenologie historique et disponibilite de nectar sur le terrain (sites nommes sans coordonnees) ; formula_used utilise uniquement le sous-jeu georeference (occurrences de musee), pas la comparaison complete du papier ; PDF non recupere localement (bloque anti-bot) -- promu a package_include="yes" apres validation utilisateur (session 2026-08-16, groupe A)
- Raison: Y continu reel (jour julien d'observation), N=1989 occurrences de musee/citizen-science georeferencees (1877-2017, Amerique du Nord), covariables latitude/annee reelles pour une analyse phenologie-climat standard. CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier identifie via OpenAlex (le paper_doi initial pointait vers le depot Zenodo du code, pas l'article).

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

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 1989
- k variables: 33
- T periods: 128
- Variable temporelle: year
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (1989) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 1174 ; panel NON EQUILIBRE (T par unite : min=1, mediane=1, max=24). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 1174 unites spatiales distinctes, pas sur les 1989 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 128 distinct periods (variable: year)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-100, -60.6667], y [29.7555113, 50]
- Time range: 1877 to 2017 (variable: year)
- CRS analyse recommande: pending - multi-zones (span=39.3deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.rr4xgxdhk (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`checkerspot_phenology` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `checkerspot_phenology` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20%: lifeStageNotes (NA=70.3%), generalNotes (NA=91.2%), locationNotes (NA=79.3%), county (NA=21.7%), municipality (NA=83%), coordinateUncertaintyInMeters (NA=44.9%), recordedBy (NA=36.1%), within.year.duplicate...place. (NA=56.4%), within.year.duplicate...county. (NA=72.6%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`checkerspot_phenology` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Phenological mismatch is less important than total nectar availability for checkerspot butterflies

