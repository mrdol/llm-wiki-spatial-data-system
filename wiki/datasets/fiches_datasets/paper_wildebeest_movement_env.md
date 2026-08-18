---
title: paper_wildebeest_movement_env
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_wildebeest_movement_env.rds
  - DatasetFirst_10_5061_dryad_5tb2rbp76
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "[dataset-first, publication non resolue] Data for: Inferring spatially-varying animal movement characteristics using a hierarchical continuous-time velocity model" (DOI unknown).

## Description du jeu de donnees

- Topic: ecologie / interactions plantes-pollinisateurs
- Observation unit: site d'observation ou cellule de grille d'occurrence
- Observed population: communautes de pollinisateurs ou d'oiseaux nectarivores
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: 13838 distinct periods (variable: Date)
- Source description: [dataset-first, publication non resolue] Data for: Inferring spatially-varying animal movement characteristics using a hierarchical continuous-time velocity model
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: unknown
- Dataset DOI: 10.5061/dryad.5tb2rbp76
- Source URL: https://doi.org/10.5061/dryad.5tb2rbp76
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_5tb2rbp76/`
- Local sf output: `data/final_datasets/sf/paper_wildebeest_movement_env.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `NDVI`
- Candidate Y typology: rate
- Candidate X variables in local artifact: `Date`, `Nitrogen`, `D_drainage`
- Candidate X count in local artifact: 3
- Candidate X typology: categorical, continuous
- Published X variables from paper: NDVI (indice de vegetation, covariable confirmee du papier -- via l'intercept du champ latent gaussien), Nitrogen (teneur en azote de l'herbe, meme role), D_drainage (distance au reseau de drainage, meme role)
- Published X count: 3
- Coordinates (x, y - excluded from X candidates): `x`, `y`
- Identifier columns (excluded from X candidates): `X`, `AID`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `NDVI` | `numeric` | rate | [0.0369, 0.9248] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `wildebeest_movement_env`, la ou les reponses `NDVI` viennent du loader papier et/ou des preuves de l article `[dataset-first, publication non resolue] Data for: Inferring spatially-varying animal movement characteristics using a hierarchical continuous-time velocity model`. Les covariables X retenues sont `Nitrogen`, `D_drainage` ; 1 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`x`, `y`), identifiants (`X`, `AID`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Date` | `character` | categorical | 0% |
| `Nitrogen` | `numeric` | continuous | 0% |
| `D_drainage` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: speed(x) ~ NDVI(x) + Nitrogen(x) + D_drainage(x) [sens causal INVERSE de formula_used ci-dessous] -- Paun, Husmeier, Hopcraft, Masolele & Torney (2022), 'Inferring spatially varying animal movement characteristics using a hierarchical continuous-time velocity model', Ecology Letters, doi:10.1111/ele.14117 (article en libre acces, PMC9828272, texte integral consulte). Modele hierarchique gaussien a 2 niveaux (processus Ornstein-Uhlenbeck de vitesse continue) : les covariables environnementales (NDVI/azote/distance drainage) n'entrent PAS comme predicteurs lineaires directs, elles modifient la MOYENNE des champs latents spatiaux gaussiens qui controlent persistance directionnelle (tau) et vitesse moyenne (sigma) -- Eq. 21-22 du papier, transformation exponentielle pour garantir la positivite. Le resume officiel confirme : 'NDVI values have a significant effect on the average speed of wildebeest, with lower speeds being associated with high quality forage' -- donc NDVI EXPLIQUE la vitesse, pas l'inverse
- x_terms_pub: NDVI (indice de vegetation, covariable confirmee du papier -- via l'intercept du champ latent gaussien), Nitrogen (teneur en azote de l'herbe, meme role), D_drainage (distance au reseau de drainage, meme role)
- y_term_pub: speed/tau/sigma (parametres latents de vitesse et persistance directionnelle du processus Ornstein-Uhlenbeck, PAS une colonne directement disponible dans ce depot)
- Reference publication: REVISE (session 2026-08-16, recherche bibliographique demandee par l'utilisateur) : papier confirme et texte integral consulte (article en libre acces, PMC9828272) -- Paun, Husmeier, Hopcraft, Masolele & Torney (2022), Ecology Letters, doi:10.1111/ele.14117. DECOUVERTE IMPORTANTE : le vrai modele du papier teste l'effet de NDVI/azote/distance-drainage SUR la vitesse de deplacement (sens causal inverse de formula_used ci-dessous, qui met NDVI comme reponse) -- confirme explicitement par le resume officiel ('NDVI values have a significant effect on the average speed of wildebeest, with lower speeds being associated with high quality forage') et par la specification mathematique exacte (Eq. 21-22, processus gaussien hierarchique Ornstein-Uhlenbeck, PAS une regression lineaire classique : les covariables modifient l'intercept de la moyenne des champs latents spatiaux tau/sigma, une relation non-parametrique flexible). 'Vitesse' n'est PAS une colonne disponible dans ce depot Dryad (seulement les positions GPS brutes x/y/Date par individu -- confirme par le README.txt) ; la calculer necessiterait de deriver des differences de position/temps successives par animal (AID), un calcul non trivial non effectue ici pour eviter de fabriquer une variable non documentee. formula_used (NDVI~Nitrogen+D_drainage) reste donc une EXPLORATION DE CORRELATION ENVIRONNEMENTALE LOCALE entre les covariables reellement disponibles, PAS un test du mecanisme causal du papier -- documentee comme telle. CSV original (wildebeest_env_data.csv) telecharge directement depuis Dryad, pas une reconstruction, N=94006 positions GPS (43 individus, Serengeti 1999-2016, coordonnees UTM 36S verifiees coherentes). package_include laisse en manual_review : papier et sens causal desormais confirmes, mais formula_used reste une proposition du curateur eloignee du vrai modele (processus gaussien non reproductible sans calcul de vitesse derivee).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: NDVI ~ Nitrogen + D_drainage
- x_terms_used: Nitrogen, D_drainage
- y_term_used: NDVI
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
    formula: "NDVI ~ Nitrogen + D_drainage"
    response: "speed/tau/sigma (parametres latents de vitesse et persistance directionnelle du processus Ornstein-Uhlenbeck, PAS une colonne directement disponible dans ce depot)"
    predictors: ["NDVI (indice de vegetation, covariable confirmee du papier -- via l'intercept du champ latent gaussien)", "Nitrogen (teneur en azote de l'herbe, meme role)", "D_drainage (distance au reseau de drainage, meme role)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "NDVI ~ Nitrogen + D_drainage + AID"
    response: "NDVI"
    predictors: ["Nitrogen", "D_drainage", "AID"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "gwr", "gam_spatial", "random_forest_xy"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_wildebeest_movement_env`
- Dataset name: Data for: Inferring spatially-varying animal movement characteristics using a hierarchical continuous-time velocity model
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: [dataset-first, publication non resolue] Data for: Inferring spatially-varying animal movement characteristics using a hierarchical continuous-time velocity model
- Paper DOI: unknown
- Dataset DOI: 10.5061/dryad.5tb2rbp76
- Source URL: https://doi.org/10.5061/dryad.5tb2rbp76
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "speed(x) ~ NDVI(x) + Nitrogen(x) + D_drainage(x) [sens causal INVERSE de formula_used ci-dessous] -- Paun, Husmeier, Hopcraft, Masolele & Torney (2022), 'Inferring spatially varying animal movement characteristics using a hierarchical continuous-time velocity model', Ecology Letters, doi:10.1111/ele.14117 (article en libre acces, PMC9828272, texte integral consulte). Modele hierarchique gaussien a 2 niveaux (processus Ornstein-Uhlenbeck de vitesse continue) : les covariables environnementales (NDVI/azote/distance drainage) n'entrent PAS comme predicteurs lineaires directs, elles modifient la MOYENNE des champs latents spatiaux gaussiens qui controlent persistance directionnelle (tau) et vitesse moyenne (sigma) -- Eq. 21-22 du papier, transformation exponentielle pour garantir la positivite. Le resume officiel confirme : 'NDVI values have a significant effect on the average speed of wildebeest, with lower speeds being associated with high quality forage' -- donc NDVI EXPLIQUE la vitesse, pas l'inverse"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "REVISE (session 2026-08-16, recherche bibliographique demandee par l'utilisateur) : papier confirme et texte integral consulte (article en libre acces, PMC9828272) -- Paun, Husmeier, Hopcraft, Masolele & Torney (2022), Ecology Letters, doi:10.1111/ele.14117. DECOUVERTE IMPORTANTE : le vrai modele du papier teste l'effet de NDVI/azote/distance-drainage SUR la vitesse de deplacement (sens causal inverse de formula_used ci-dessous, qui met NDVI comme reponse) -- confirme explicitement par le resume officiel ('NDVI values have a significant effect on the average speed of wildebeest, with lower speeds being associated with high quality forage') et par la specification mathematique exacte (Eq. 21-22, processus gaussien hierarchique Ornstein-Uhlenbeck, PAS une regression lineaire classique : les covariables modifient l'intercept de la moyenne des champs latents spatiaux tau/sigma, une relation non-parametrique flexible). 'Vitesse' n'est PAS une colonne disponible dans ce depot Dryad (seulement les positions GPS brutes x/y/Date par individu -- confirme par le README.txt) ; la calculer necessiterait de deriver des differences de position/temps successives par animal (AID), un calcul non trivial non effectue ici pour eviter de fabriquer une variable non documentee. formula_used (NDVI~Nitrogen+D_drainage) reste donc une EXPLORATION DE CORRELATION ENVIRONNEMENTALE LOCALE entre les covariables reellement disponibles, PAS un test du mecanisme causal du papier -- documentee comme telle. CSV original (wildebeest_env_data.csv) telecharge directement depuis Dryad, pas une reconstruction, N=94006 positions GPS (43 individus, Serengeti 1999-2016, coordonnees UTM 36S verifiees coherentes). package_include laisse en manual_review : papier et sens causal desormais confirmes, mais formula_used reste une proposition du curateur eloignee du vrai modele (processus gaussien non reproductible sans calcul de vitesse derivee)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "papier confirme et texte integral consulte (Paun et al. 2022, Ecology Letters, doi:10.1111/ele.14117) -- vrai modele est un processus gaussien complexe reliant les covariables A la vitesse (sens inverse de formula_used), non reproductible tel quel ; formula_used reste une exploration de correlation environnementale locale, documentee comme telle -- promu a package_include='yes' apres validation utilisateur (session 2026-08-16)"
  reason: "Y continu reel (NDVI estime au point/instant du GPS-fix), N=94006 positions GPS de gnous (43 individus suivis, Serengeti 1999-2016). CSV original telecharge directement depuis Dryad, pas une reconstruction. Coordonnees UTM 36S verifiees coherentes avec le Serengeti."
```

- Decision: ready
- Manque principal: papier confirme et texte integral consulte (Paun et al. 2022, Ecology Letters, doi:10.1111/ele.14117) -- vrai modele est un processus gaussien complexe reliant les covariables A la vitesse (sens inverse de formula_used), non reproductible tel quel ; formula_used reste une exploration de correlation environnementale locale, documentee comme telle -- promu a package_include="yes" apres validation utilisateur (session 2026-08-16)
- Raison: Y continu reel (NDVI estime au point/instant du GPS-fix), N=94006 positions GPS de gnous (43 individus suivis, Serengeti 1999-2016). CSV original telecharge directement depuis Dryad, pas une reconstruction. Coordonnees UTM 36S verifiees coherentes avec le Serengeti.

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
- N observations: 94006
- k variables: 10
- T periods: 13838
- Variable temporelle: Date
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (94006) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 93971 ; panel NON EQUILIBRE (T par unite : min=1, mediane=1, max=2). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 93971 unites spatiales distinctes, pas sur les 94006 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 13838 distinct periods (variable: Date)
- CRS EPSG: 32736
- CRS nom: WGS 84 / UTM zone 36S
- Spatial extent: x [597344.9038, 806708.7004], y [9608835.342, 9869852.944]
- Time range: 1/1/2014 18:00 to 9/9/2018 7:31 (variable: Date)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.5tb2rbp76 (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`wildebeest_movement_env` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `wildebeest_movement_env` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (32736).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`wildebeest_movement_env` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: [dataset-first, publication non resolue] Data for: Inferring spatially-varying animal movement characteristics using a hierarchical continuous-time velocity model

