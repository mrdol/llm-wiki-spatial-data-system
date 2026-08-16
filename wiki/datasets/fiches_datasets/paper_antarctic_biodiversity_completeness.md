---
title: paper_antarctic_biodiversity_completeness
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_antarctic_biodiversity_completeness.rds
  - DatasetFirst_10_5281_zenodo_13988131
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Advances and shortfalls in the knowledge of Antarctic terrestrial biodiversity (Pertierra et al. 2024, Science -- titre/auteurs/annee/revue identifies via le README du depot Zenodo, DOI non resolu)" (DOI unknown).

## Description du jeu de donnees

- Topic: biodiversite / completude d'inventaires en Antarctique
- Observation unit: cellule de grille Antarctique
- Observed population: cellules de grille d'inventaire biodiversite, Antarctique, N=1518
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: Advances and shortfalls in the knowledge of Antarctic terrestrial biodiversity (Pertierra et al. 2024, Science -- titre/auteurs/annee/revue identifies via le README du depot Zenodo, DOI non resolu)
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: unknown
- Dataset DOI: 10.5281/zenodo.13988131
- Source URL: https://doi.org/10.5281/zenodo.13988131
- Local raw dir: `data/raw/papers/DatasetFirst_10_5281_zenodo_13988131/`
- Local sf output: `data/final_datasets/sf/paper_antarctic_biodiversity_completeness.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Cmpltns`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Shp_Lng`, `Shap_Ar`, `Records`, `Obsrvd_`, `Richnss`, `Slope`, `Ratio`
- Candidate X count in local artifact: 7
- Candidate X typology: continuous
- Published X variables from paper: Records (nombre d'enregistrements d'occurrence dans la cellule, proxy d'effort d'echantillonnage -- entree independante du calcul KnowBR), Shap_Ar (aire de la cellule de grille -- geometrie independante)
- Published X count: 2
- Coordinates (x, y - excluded from X candidates): `true_lon`, `true_lat`
- Identifier columns (excluded from X candidates): `OBJECTID`, `PagNmbr`, `OID_`, `PageNam`, `FID_1`, `ORIG_FID`, `Latitude`, `Longitude`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Cmpltns` | `numeric` | continuous | [0, 99.0513] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `antarctic_biodiversity_completeness`, la ou les reponses `Cmpltns` viennent du loader papier et/ou des preuves de l article `Advances and shortfalls in the knowledge of Antarctic terrestrial biodiversity (Pertierra et al. 2024, Science -- titre/auteurs/annee/revue identifies via le README du depot Zenodo, DOI non resolu)`. Les covariables X retenues sont `Records`, `Shap_Ar` ; 5 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`true_lon`, `true_lat`), identifiants (`OBJECTID`, `PagNmbr`, `OID_`, `PageNam`, `FID_1`, `ORIG_FID`, `Latitude`, `Longitude`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Shp_Lng` | `integer` | count | 0% |
| `Shap_Ar` | `numeric` | continuous | 0% |
| `Records` | `integer` | count | 0% |
| `Obsrvd_` | `integer` | count | 0% |
| `Richnss` | `numeric` | continuous | 0% |
| `Slope` | `numeric` | rate | 0% |
| `Ratio` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: [CONFIRME (session 2026-08-16) : pas de formule Y~X dans le papier pour cette table. Le script R original des auteurs (SUPPORTING FILE 4 Spatial Completeness R CODE.R, present dans ce meme depot) utilise uniquement KnowBR::KnowBPolygon() pour produire Estimators.csv (= ce CSV) suivi d'une visualisation cartographique -- aucune regression ajustee, confirmant que Cmpltns est un diagnostic descriptif, pas une variable expliquee. Source : Pertierra et al. (2025), 'Advances and shortfalls in knowledge of Antarctic terrestrial and freshwater biodiversity', Science 387:609-615, doi:10.1126/science.adk2118 (DOI trouve par recherche web, annee/pages corrigees -- README local disait a tort '2024')]
- x_terms_pub: Records (nombre d'enregistrements d'occurrence dans la cellule, proxy d'effort d'echantillonnage -- entree independante du calcul KnowBR), Shap_Ar (aire de la cellule de grille -- geometrie independante)
- y_term_pub: Cmpltns (completude de l'inventaire biodiversite par cellule de grille Antarctique, %, calculee via le package KnowBR a partir de courbes d'accumulation d'especes, estimateur de Ugland et al. 2003)
- Reference publication: REVISE (session 2026-08-16, recherche bibliographique demandee par l'utilisateur) : papier retrouve et DOI corrige -- Pertierra et al. (2025, pas 2024), 'Advances and shortfalls in knowledge of Antarctic terrestrial and freshwater biodiversity', Science 387:609-615, doi:10.1126/science.adk2118. Le script R original des auteurs est present dans ce meme depot (SUPPORTING FILE 4 Spatial Completeness R CODE.R) et confirme sans ambiguite que le pipeline se limite a KnowBR::KnowBPolygon() (calcul de completude par courbe d'accumulation d'especes) suivi d'une carte -- aucune regression Y~X publiee sur cette table. DECOUVERTE METHODOLOGIQUE IMPORTANTE (documentation officielle CRAN du package KnowBR, Lobo et al.) : Slope et Obsrvd_ (richesse observee) sont des INGREDIENTS DIRECTS du calcul de Completeness lui-meme (la completude = richesse observee / richesse extrapolee par la courbe d'accumulation, dont Slope est la pente finale) -- les inclure comme covariables X d'une regression Cmpltns~... serait quasi-circulaire (tautologique par construction de l'algorithme), pas une relation causale testable. formula_used corrigee (session 2026-08-16) : Slope et Obsrvd_ retires, ne restent que Records (entree brute independante, proxy d'effort d'echantillonnage) et Shap_Ar (geometrie de cellule, independante). CSV original (SUPPORTING FILE 3 Antarctic Inventories Spatial Completeness.csv) telecharge directement depuis Zenodo -- pas une reconstruction, N=1518 cellules de grille Antarctique. VERIFICATION EMPIRIQUE (session 2026-08-16) : les colonnes 'Latitude'/'Longitude' du CSV source sont inversees (colonne 'Latitude' variant sur [-175,176], plage de longitude ; colonne 'Longitude' variant sur [-89.6,-60.2], plage de latitude coherente avec l'Antarctique) -- corrige dans le loader (true_lat=Longitude, true_lon=Latitude), verifie geographiquement valide apres correction. package_include laisse en manual_review : formule corrigee pour eviter la circularite mais reste une proposition du curateur, le papier lui-meme ne publie aucune regression sur cette table.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). REVISE (session 2026-08-16, recherche bibliographique demandee par l'utilisateur) : papier retrouve et DOI corrige -- Pertierra et al. (2025, pas 2024), 'Advances and shortfalls in knowledge of Antarctic terrestrial and freshwater biodiversity', Science 387:609-615, doi:10.1126/science.adk2118. Le script R original des auteurs est present dans ce meme depot (SUPPORTING FILE 4 Spatial Completeness R CODE.R) et confirme sans ambiguite que le pipeline se limite a KnowBR::KnowBPolygon() (calcul de completude par courbe d'accumulation d'especes) suivi d'une carte -- aucune regression Y~X publiee sur cette table. DECOUVERTE METHODOLOGIQUE IMPORTANTE (documentation officielle CRAN du package KnowBR, Lobo et al.) : Slope et Obsrvd_ (richesse observee) sont des INGREDIENTS DIRECTS du calcul de Completeness lui-meme (la completude = richesse observee / richesse extrapolee par la courbe d'accumulation, dont Slope est la pente finale) -- les inclure comme covariables X d'une regression Cmpltns~... serait quasi-circulaire (tautologique par construction de l'algorithme), pas une relation causale testable. formula_used corrigee (session 2026-08-16) : Slope et Obsrvd_ retires, ne restent que Records (entree brute independante, proxy d'effort d'echantillonnage) et Shap_Ar (geometrie de cellule, independante). CSV original (SUPPORTING FILE 3 Antarctic Inventories Spatial Completeness.csv) telecharge directement depuis Zenodo -- pas une reconstruction, N=1518 cellules de grille Antarctique. VERIFICATION EMPIRIQUE (session 2026-08-16) : les colonnes 'Latitude'/'Longitude' du CSV source sont inversees (colonne 'Latitude' variant sur [-175,176], plage de longitude ; colonne 'Longitude' variant sur [-89.6,-60.2], plage de latitude coherente avec l'Antarctique) -- corrige dans le loader (true_lat=Longitude, true_lon=Latitude), verifie geographiquement valide apres correction. package_include laisse en manual_review : formule corrigee pour eviter la circularite mais reste une proposition du curateur, le papier lui-meme ne publie aucune regression sur cette table.

### Formule - niveau systeme

- formula_used: Cmpltns ~ Records + Shap_Ar
- x_terms_used: Records, Shap_Ar
- y_term_used: Cmpltns
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). REVISE (session 2026-08-16, recherche bibliographique demandee par l'utilisateur) : papier retrouve et DOI corrige -- Pertierra et al. (2025, pas 2024), 'Advances and shortfalls in knowledge of Antarctic terrestrial and freshwater biodiversity', Science 387:609-615, doi:10.1126/science.adk2118. Le script R original des auteurs est present dans ce meme depot (SUPPORTING FILE 4 Spatial Completeness R CODE.R) et confirme sans ambiguite que le pipeline se limite a KnowBR::KnowBPolygon() (calcul de completude par courbe d'accumulation d'especes) suivi d'une carte -- aucune regression Y~X publiee sur cette table. DECOUVERTE METHODOLOGIQUE IMPORTANTE (documentation officielle CRAN du package KnowBR, Lobo et al.) : Slope et Obsrvd_ (richesse observee) sont des INGREDIENTS DIRECTS du calcul de Completeness lui-meme (la completude = richesse observee / richesse extrapolee par la courbe d'accumulation, dont Slope est la pente finale) -- les inclure comme covariables X d'une regression Cmpltns~... serait quasi-circulaire (tautologique par construction de l'algorithme), pas une relation causale testable. formula_used corrigee (session 2026-08-16) : Slope et Obsrvd_ retires, ne restent que Records (entree brute independante, proxy d'effort d'echantillonnage) et Shap_Ar (geometrie de cellule, independante). CSV original (SUPPORTING FILE 3 Antarctic Inventories Spatial Completeness.csv) telecharge directement depuis Zenodo -- pas une reconstruction, N=1518 cellules de grille Antarctique. VERIFICATION EMPIRIQUE (session 2026-08-16) : les colonnes 'Latitude'/'Longitude' du CSV source sont inversees (colonne 'Latitude' variant sur [-175,176], plage de longitude ; colonne 'Longitude' variant sur [-89.6,-60.2], plage de latitude coherente avec l'Antarctique) -- corrige dans le loader (true_lat=Longitude, true_lon=Latitude), verifie geographiquement valide apres correction. package_include laisse en manual_review : formule corrigee pour eviter la circularite mais reste une proposition du curateur, le papier lui-meme ne publie aucune regression sur cette table.

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
    formula: "Cmpltns ~ Records + Shap_Ar"
    response: "Cmpltns (completude de l'inventaire biodiversite par cellule de grille Antarctique, %, calculee via le package KnowBR a partir de courbes d'accumulation d'especes, estimateur de Ugland et al. 2003)"
    predictors: ["Records (nombre d'enregistrements d'occurrence dans la cellule, proxy d'effort d'echantillonnage -- entree independante du calcul KnowBR)", "Shap_Ar (aire de la cellule de grille -- geometrie independante)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "REVISE (session 2026-08-16, recherche bibliographique demandee par l'utilisateur) : papier retrouve et DOI corrige -- Pertierra et al. (2025, pas 2024), 'Advances and shortfalls in knowledge of Antarctic terrestrial and freshwater biodiversity', Science 387:609-615, doi:10.1126/science.adk2118. Le script R original des auteurs est present dans ce meme depot (SUPPORTING FILE 4 Spatial Completeness R CODE.R) et confirme sans ambiguite que le pipeline se limite a KnowBR::KnowBPolygon() (calcul de completude par courbe d'accumulation d'especes) suivi d'une carte -- aucune regression Y~X publiee sur cette table. DECOUVERTE METHODOLOGIQUE IMPORTANTE (documentation officielle CRAN du package KnowBR, Lobo et al.) : Slope et Obsrvd_ (richesse observee) sont des INGREDIENTS DIRECTS du calcul de Completeness lui-meme (la completude = richesse observee / richesse extrapolee par la courbe d'accumulation, dont Slope est la pente finale) -- les inclure comme covariables X d'une regression Cmpltns~... serait quasi-circulaire (tautologique par construction de l'algorithme), pas une relation causale testable. formula_used corrigee (session 2026-08-16) : Slope et Obsrvd_ retires, ne restent que Records (entree brute independante, proxy d'effort d'echantillonnage) et Shap_Ar (geometrie de cellule, independante). CSV original (SUPPORTING FILE 3 Antarctic Inventories Spatial Completeness.csv) telecharge directement depuis Zenodo -- pas une reconstruction, N=1518 cellules de grille Antarctique. VERIFICATION EMPIRIQUE (session 2026-08-16) : les colonnes 'Latitude'/'Longitude' du CSV source sont inversees (colonne 'Latitude' variant sur [-175,176], plage de longitude ; colonne 'Longitude' variant sur [-89.6,-60.2], plage de latitude coherente avec l'Antarctique) -- corrige dans le loader (true_lat=Longitude, true_lon=Latitude), verifie geographiquement valide apres correction. package_include laisse en manual_review : formule corrigee pour eviter la circularite mais reste une proposition du curateur, le papier lui-meme ne publie aucune regression sur cette table."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "Cmpltns ~ Records + Shap_Ar"
    response: "Cmpltns"
    predictors: ["Records", "Shap_Ar"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "REVISE (session 2026-08-16, recherche bibliographique demandee par l'utilisateur) : papier retrouve et DOI corrige -- Pertierra et al. (2025, pas 2024), 'Advances and shortfalls in knowledge of Antarctic terrestrial and freshwater biodiversity', Science 387:609-615, doi:10.1126/science.adk2118. Le script R original des auteurs est present dans ce meme depot (SUPPORTING FILE 4 Spatial Completeness R CODE.R) et confirme sans ambiguite que le pipeline se limite a KnowBR::KnowBPolygon() (calcul de completude par courbe d'accumulation d'especes) suivi d'une carte -- aucune regression Y~X publiee sur cette table. DECOUVERTE METHODOLOGIQUE IMPORTANTE (documentation officielle CRAN du package KnowBR, Lobo et al.) : Slope et Obsrvd_ (richesse observee) sont des INGREDIENTS DIRECTS du calcul de Completeness lui-meme (la completude = richesse observee / richesse extrapolee par la courbe d'accumulation, dont Slope est la pente finale) -- les inclure comme covariables X d'une regression Cmpltns~... serait quasi-circulaire (tautologique par construction de l'algorithme), pas une relation causale testable. formula_used corrigee (session 2026-08-16) : Slope et Obsrvd_ retires, ne restent que Records (entree brute independante, proxy d'effort d'echantillonnage) et Shap_Ar (geometrie de cellule, independante). CSV original (SUPPORTING FILE 3 Antarctic Inventories Spatial Completeness.csv) telecharge directement depuis Zenodo -- pas une reconstruction, N=1518 cellules de grille Antarctique. VERIFICATION EMPIRIQUE (session 2026-08-16) : les colonnes 'Latitude'/'Longitude' du CSV source sont inversees (colonne 'Latitude' variant sur [-175,176], plage de longitude ; colonne 'Longitude' variant sur [-89.6,-60.2], plage de latitude coherente avec l'Antarctique) -- corrige dans le loader (true_lat=Longitude, true_lon=Latitude), verifie geographiquement valide apres correction. package_include laisse en manual_review : formule corrigee pour eviter la circularite mais reste une proposition du curateur, le papier lui-meme ne publie aucune regression sur cette table."
    estimator_context: ["ols", "gwr", "random_forest", "sar_lag"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_antarctic_biodiversity_completeness`
- Dataset name: Supplementary Files to: Advances and shortfalls in the knowledge of Antarctic terrestrial biodiversity
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Advances and shortfalls in the knowledge of Antarctic terrestrial biodiversity (Pertierra et al. 2024, Science -- titre/auteurs/annee/revue identifies via le README du depot Zenodo, DOI non resolu)
- Paper DOI: unknown
- Dataset DOI: 10.5281/zenodo.13988131
- Source URL: https://doi.org/10.5281/zenodo.13988131
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "[CONFIRME (session 2026-08-16) : pas de formule Y~X dans le papier pour cette table. Le script R original des auteurs (SUPPORTING FILE 4 Spatial Completeness R CODE.R, present dans ce meme depot) utilise uniquement KnowBR::KnowBPolygon() pour produire Estimators.csv (= ce CSV) suivi d'une visualisation cartographique -- aucune regression ajustee, confirmant que Cmpltns est un diagnostic descriptif, pas une variable expliquee. Source : Pertierra et al. (2025), 'Advances and shortfalls in knowledge of Antarctic terrestrial and freshwater biodiversity', Science 387:609-615, doi:10.1126/science.adk2118 (DOI trouve par recherche web, annee/pages corrigees -- README local disait a tort '2024')]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "REVISE (session 2026-08-16, recherche bibliographique demandee par l'utilisateur) : papier retrouve et DOI corrige -- Pertierra et al. (2025, pas 2024), 'Advances and shortfalls in knowledge of Antarctic terrestrial and freshwater biodiversity', Science 387:609-615, doi:10.1126/science.adk2118. Le script R original des auteurs est present dans ce meme depot (SUPPORTING FILE 4 Spatial Completeness R CODE.R) et confirme sans ambiguite que le pipeline se limite a KnowBR::KnowBPolygon() (calcul de completude par courbe d'accumulation d'especes) suivi d'une carte -- aucune regression Y~X publiee sur cette table. DECOUVERTE METHODOLOGIQUE IMPORTANTE (documentation officielle CRAN du package KnowBR, Lobo et al.) : Slope et Obsrvd_ (richesse observee) sont des INGREDIENTS DIRECTS du calcul de Completeness lui-meme (la completude = richesse observee / richesse extrapolee par la courbe d'accumulation, dont Slope est la pente finale) -- les inclure comme covariables X d'une regression Cmpltns~... serait quasi-circulaire (tautologique par construction de l'algorithme), pas une relation causale testable. formula_used corrigee (session 2026-08-16) : Slope et Obsrvd_ retires, ne restent que Records (entree brute independante, proxy d'effort d'echantillonnage) et Shap_Ar (geometrie de cellule, independante). CSV original (SUPPORTING FILE 3 Antarctic Inventories Spatial Completeness.csv) telecharge directement depuis Zenodo -- pas une reconstruction, N=1518 cellules de grille Antarctique. VERIFICATION EMPIRIQUE (session 2026-08-16) : les colonnes 'Latitude'/'Longitude' du CSV source sont inversees (colonne 'Latitude' variant sur [-175,176], plage de longitude ; colonne 'Longitude' variant sur [-89.6,-60.2], plage de latitude coherente avec l'Antarctique) -- corrige dans le loader (true_lat=Longitude, true_lon=Latitude), verifie geographiquement valide apres correction. package_include laisse en manual_review : formule corrigee pour eviter la circularite mais reste une proposition du curateur, le papier lui-meme ne publie aucune regression sur cette table."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "papier confirme (Pertierra et al. 2025, Science, doi:10.1126/science.adk2118) -- script R original des auteurs retrouve dans le depot, confirme aucune regression publiee ; formula_used corrigee pour eviter la circularite methodologique (Slope/Obsrvd_ retires, ingredients directs du calcul KnowBR) -- promu a package_include='yes' apres validation utilisateur (session 2026-08-16)"
  reason: "Y continu reel (Cmpltns, completude d'inventaire biodiversite, indice KnowBR), N=1518 cellules de grille Antarctique avec coordonnees reelles. CSV original telecharge directement depuis Zenodo, pas une reconstruction. Bug d'inversion Latitude/Longitude dans le CSV source detecte et corrige empiriquement (verifie geographiquement valide apres correction : latitude [-89.6,-60.2], coherent avec l'Antarctique)."
```

- Decision: ready
- Manque principal: papier confirme (Pertierra et al. 2025, Science, doi:10.1126/science.adk2118) -- script R original des auteurs retrouve dans le depot, confirme aucune regression publiee ; formula_used corrigee pour eviter la circularite methodologique (Slope/Obsrvd_ retires, ingredients directs du calcul KnowBR) -- promu a package_include="yes" apres validation utilisateur (session 2026-08-16)
- Raison: Y continu reel (Cmpltns, completude d'inventaire biodiversite, indice KnowBR), N=1518 cellules de grille Antarctique avec coordonnees reelles. CSV original telecharge directement depuis Zenodo, pas une reconstruction. Bug d'inversion Latitude/Longitude dans le CSV source detecte et corrige empiriquement (verifie geographiquement valide apres correction : latitude [-89.6,-60.2], coherent avec l'Antarctique).

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
- N observations: 1518
- k variables: 20
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-175.2329739, 176.2378637], y [-89.6447261, -60.2477987]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=351.5deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`antarctic_biodiversity_completeness` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `antarctic_biodiversity_completeness` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`antarctic_biodiversity_completeness` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Advances and shortfalls in the knowledge of Antarctic terrestrial biodiversity (Pertierra et al. 2024, Science -- titre/auteurs/annee/revue identifies via le README du depot Zenodo, DOI non resolu)

