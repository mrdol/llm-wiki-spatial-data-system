---
title: R_gstat_oxford_oxford
type: dataset
created: 2026-08-15
updated: 2026-09-07
sources:
  - data/final_datasets/sf/R_gstat_oxford_oxford.rds
tags: [dataset, r-package, spatial, point]
---

Data: 126 soil augerings on a 100 x 100m square grid, with 6 columns and 21 rows. Grid is oriented with long axis North-north-west to South-south-east Origin of grid is South-south-east point, 100m outside grid.

## Description du jeu de donnees

- Topic: Donnees de r-package : R_gstat_oxford_oxford
- Observation unit: observation spatiale de type POINT
- Observed population: 126 enregistrements dans l’artefact local R_gstat_oxford_oxford.rds; unite declaree : observation spatiale de type POINT. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: Etendue mesuree dans le RDS : x [100, 600], y [100, 2100]; CRS non renseigne, repere/unites a documenter.
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Data: 126 soil augerings on a 100 x 100m square grid, with 6 columns and 21 rows. Grid is oriented with long axis North-north-west to South-south-east Origin of grid is South-south-east point, 100m outside grid.
- Description source: package R `gstat`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `PROFCLASS`, `MAPCLASS`, `DEPTHCM`, `DEP2LIME`, `PCLAY1`, `PCLAY2`, `OM1`, `CEC1`, `PH1`, `PHOS1`, `POT1`, `MG1`
- Candidate Y typology: categorical, continuous
- Candidate X variables: `ELEV`, `VAL1`, `CHR1`, `LIME1`, `VAL2`, `CHR2`, `LIME2`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `XCOORD`, `YCOORD`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PROFCLASS` | `factor` | categorical | None | 0% |
| `MAPCLASS` | `factor` | categorical | None | 0% |
| `DEPTHCM` | `numeric` | continuous | [10, 91] | 0% |
| `DEP2LIME` | `numeric` | continuous | [20, 90] | 0% |
| `PCLAY1` | `numeric` | continuous | [10, 37] | 0% |
| `PCLAY2` | `numeric` | continuous | [10, 40] | 0% |
| `OM1` | `numeric` | continuous | [2.6, 13.1] | 0% |
| `CEC1` | `numeric` | continuous | [7, 43] | 0% |
| `PH1` | `numeric` | continuous | [4.2, 7.7] | 0% |
| `PHOS1` | `numeric` | continuous | [1.7, 25] | 0% |
| `POT1` | `numeric` | continuous | [83, 847] | 0% |
| `MG1` | `numeric` | continuous | [19, 308] | 0% |


> Selection Y/X (claude-sonnet-4-6) : L'élévation (ELEV) et les attributs de terrain/horizon (VAL, CHR, LIME pour les couches 1 et 2) sont des covariables explicatives naturelles dans un contexte de cartographie pédologique. Les propriétés chimiques et physiques du sol mesurées (pH, matière organique, CEC, phosphore, potassium, magnésium, argile, profondeur, profondeur à la limite calcaire) ainsi que les classes de profil/carte constituent des cibles typiques pour la prédiction spatiale ; PROFILE est ignoré car c'est un simple identifiant de sondage.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `ELEV` | `numeric` | continuous | 0% |
| `VAL1` | `numeric` | continuous | 0% |
| `CHR1` | `numeric` | continuous | 0% |
| `LIME1` | `numeric` | continuous | 0% |
| `VAL2` | `numeric` | continuous | 0% |
| `CHR2` | `numeric` | continuous | 0% |
| `LIME2` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Burrough, P.A. & McDonnell, R.A. (1998). Principles of Geographical Information Systems. Oxford University Press, Oxford. ISBN 978-0-19-823365-7. TYPE: manuel (livre), pas un article -- aucun DOI n'existe pour un ouvrage de ce type. Lien : https://openlibrary.org/isbn/9780198233657 (fiche verifiee : titre, auteurs et annee correspondent exactement).

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: PROFCLASS ~ ELEV + VAL1 + CHR1 + LIME1 + VAL2 + CHR2 + LIME2
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: categorical
- x_terms_used: ELEV + VAL1 + CHR1 + LIME1 + VAL2 + CHR2 + LIME2
- y_term_used: PROFCLASS

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
    formula: "PROFCLASS ~ ELEV + VAL1 + CHR1 + LIME1 + VAL2 + CHR2 + LIME2"
    response: "PROFCLASS"
    predictors: ["ELEV", "VAL1", "CHR1", "LIME1", "VAL2", "CHR2", "LIME2"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `R_gstat_oxford_oxford`
- Dataset name: gstat::oxford
- Source family: r-package
- Source: package R `gstat` (version 2.1.6)
- Source URL: https://CRAN.R-project.org/package=gstat
- Dataset DOI: none
- Publication DOI: none
- Year: 2003

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "PROFCLASS ~ ELEV + VAL1 + CHR1 + LIME1 + VAL2 + CHR2 + LIME2"
  equation_family: regression_candidate
  model_family: "regression_candidate"
  source_type: generated_system_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 126
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [100, 600], y [100, 2100] (grille de terrain locale non projetee, pas de CRS)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: not_applicable (grille de terrain locale non projetee)
- CRS nom: not_applicable (repere local, non georeference)
- CRS analyse recommande: not_applicable — XCOORD/YCOORD sont une grille de terrain locale non projetee (documentation gstat::oxford : "non-projected field coordinates", origine a 100m au sud-sud-est de la grille), pas des coordonnees geographiques ; aucune reprojection ne peut etre deduite sans georeferencement externe.

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
- Formula: PENDING - formule publication non encore etablie.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2.0)).

## Related Pages

- Source: package R `gstat`

## Curation documentée — 2026-09-07

Typologie de la reponse selectionnee : categorical. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

Verification 2026-09-15 (mode production de secours, tools::Rd_db("gstat")) : documentation confirmee -- leve de sols par P.A. Burrough (1967, Berkshire Downs, Oxfordshire, UK), 126 sondages sur grille 100x100m ; reference = un manuel (Burrough & McDonnell 1998, Oxford University Press), pas un article -- Publication DOI corrige de "pending" a "none" (les manuels n'ont pas de DOI). XCOORD/YCOORD explicitement decrites comme "non-projected field coordinates" dans la doc -- CRS corrige de "unknown [lookup required]" (implique une recherche possible) a "not_applicable" (rien a chercher, ce sont des coordonnees de terrain non georeferencees).

Complement 2026-09-15 : reference explicitement etiquetee comme un manuel (pas un article scientifique), avec lien de reference verifie (Open Library, ISBN 9780198233657 confirme resoudre vers le bon titre/auteurs/annee).
