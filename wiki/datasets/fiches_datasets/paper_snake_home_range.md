---
title: paper_snake_home_range
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_snake_home_range.rds
  - DataCite_2020_EctothermyAndTheMacroecology_10_25338_b85g98
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Ectothermy and the macroecology of home range scaling in snakes" (DOI 10.1111/geb.13225).

## Description du jeu de donnees

- Topic: macroecologie / mise a l'echelle du domaine vital
- Observation unit: espece de serpent (moyenne d'etude)
- Observed population: 113 especes de serpents, estimations de domaine vital compilees depuis la litterature
- Geographic context: etendue sf: x [-122.358631, 153.440319], y [-35.154131, 55.667364]
- Temporal context: none (cross-sectional)
- Source description: Ectothermy and the macroecology of home range scaling in snakes
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/geb.13225
- Dataset DOI: 10.25338/b85g98
- Source URL: https://datadryad.org/dataset/doi:10.25338/b85g98
- Local raw dir: `data/raw/papers/DataCite_2020_EctothermyAndTheMacroecology_10_25338_b85g98/`
- Local sf output: `data/final_datasets/sf/paper_snake_home_range.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `X100MCP`, `X95MCP`, `X100KD`, `X95KD`
- Candidate Y typology: continuous, binary
- Candidate X variables in local artifact: `Elevation`, `MaleMass`, `FemaleMass`, `Male100MCP`, `Male95MCP`, `Male95KD`, `Male90KD`, `Female100MCP`, `Female95MCP`, `Female95KD`, `Female90KD`, `NotesHR`, `NotesMass`, `NPP`, `Total_Precip`, `MeanAnnualTemp`, `IUCN_habitats`, `Aquatic_index`
- Candidate X count in local artifact: 18
- Candidate X typology: continuous, categorical
- Published X variables from paper: Mass (masse corporelle, log-transformee), IUCN_habitats (largeur de niche d'habitat), Aquatic_index (indice d'aquaticite), Elevation, NPP (productivite primaire nette), MeanAnnualTemp, Total_Precip
- Published X count: 7
- Coordinates (x, y - excluded from X candidates): `Longitude`, `Latitude`
- Identifier columns (excluded from X candidates): `Citation`, `Family`, `TreeTaxon`, `StudySpeciesName`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `X100MCP` | `numeric` | continuous | [1.29, 159.3] | 62.4% |
| `X95MCP` | `numeric` | continuous | [3.54, 65] | 93.6% |
| `X100KD` | `logical` | binary | {0, 1} | 100% |
| `X95KD` | `numeric` | continuous | [0.67, 177.07] | 78.9% |

> Selection Y/X (paper-loader / curated evidence) : Pour `snake_home_range`, la ou les reponses `X100MCP`, `X95MCP`, `X100KD`, `X95KD` viennent du loader papier et/ou des preuves de l article `Ectothermy and the macroecology of home range scaling in snakes`. Les covariables X retenues sont `MaleMass`, `IUCN_habitats`, `Aquatic_index`, `Elevation`, `NPP`, `MeanAnnualTemp`, `Total_Precip` ; 11 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Longitude`, `Latitude`), identifiants (`Citation`, `Family`, `TreeTaxon`, `StudySpeciesName`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Elevation` | `integer` | continuous | 0% |
| `MaleMass` | `numeric` | continuous | 6.4% |
| `FemaleMass` | `numeric` | continuous | 1.8% |
| `Male100MCP` | `numeric` | continuous | 32.1% |
| `Male95MCP` | `numeric` | continuous | 92.7% |
| `Male95KD` | `numeric` | continuous | 69.7% |
| `Male90KD` | `numeric` | continuous | 98.2% |
| `Female100MCP` | `numeric` | continuous | 32.1% |
| `Female95MCP` | `numeric` | continuous | 92.7% |
| `Female95KD` | `numeric` | continuous | 69.7% |
| `Female90KD` | `numeric` | continuous | 98.2% |
| `NotesHR` | `character` | categorical | 0% |
| `NotesMass` | `character` | categorical | 0% |
| `NPP` | `numeric` | continuous | 0% |
| `Total_Precip` | `numeric` | continuous | 0% |
| `MeanAnnualTemp` | `numeric` | continuous | 0% |
| `IUCN_habitats` | `integer` | count | 1.8% |
| `Aquatic_index` | `numeric` | rate | 1.8% |

### Formule - niveau publication

- formula_pub: HR ~ log(Mass) + IUCN_habitats + Aquatic_index + Elevation + NPP + MeanAnnualTemp + Total_Precip + (1|study) + (1|species) [Modele Lineaire Mixte (LMM), package lme4, intercepts aleatoires etude/espece, comparaison de modeles emboites par AICc]
- x_terms_pub: Mass (masse corporelle, log-transformee), IUCN_habitats (largeur de niche d'habitat), Aquatic_index (indice d'aquaticite), Elevation, NPP (productivite primaire nette), MeanAnnualTemp, Total_Precip
- y_term_pub: HR (taille du domaine vital, home range, methodes MCP/Kernel Density selon l'etude source)
- Reference publication: Todd, B.D. & Nowakowski, A.J. (2021), Ectothermy and the macroecology of home range scaling in snakes, Global Ecology and Biogeography, doi:10.1111/geb.13225. CSV original (todd_and_nowakowski_snake_home_range_full_dataset.csv) telecharge directement depuis le depot DataCite/Dryad (10.25338/b85g98) -- pas une reconstruction, N=113 especes, N=109 apres exclusion des 4 lignes sans coordonnees. Les noms de colonnes numeriques (100MCP, 95MCP, 100KD, 95KD) sont automatiquement prefixes 'X' par R a la lecture (100MCP -> X100MCP) -- comportement standard de read.csv/make.names, pas une erreur de donnee. X100MCP retenu comme Y principal (41/109 valeurs non-NA, differentes etudes ayant utilise differentes methodes d'estimation du domaine vital -- NA reel documente, pas fabrique).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Todd, B.D. & Nowakowski, A.J. (2021), Ectothermy and the macroecology of home range scaling in snakes, Global Ecology and Biogeography, doi:10.1111/geb.13225. CSV original (todd_and_nowakowski_snake_home_range_full_dataset.csv) telecharge directement depuis le depot DataCite/Dryad (10.25338/b85g98) -- pas une reconstruction, N=113 especes, N=109 apres exclusion des 4 lignes sans coordonnees. Les noms de colonnes numeriques (100MCP, 95MCP, 100KD, 95KD) sont automatiquement prefixes 'X' par R a la lecture (100MCP -> X100MCP) -- comportement standard de read.csv/make.names, pas une erreur de donnee. X100MCP retenu comme Y principal (41/109 valeurs non-NA, differentes etudes ayant utilise differentes methodes d'estimation du domaine vital -- NA reel documente, pas fabrique).

### Formule - niveau systeme

- formula_used: X100MCP ~ MaleMass + IUCN_habitats + Aquatic_index + Elevation + NPP + MeanAnnualTemp + Total_Precip
- x_terms_used: MaleMass, IUCN_habitats, Aquatic_index, Elevation, NPP, MeanAnnualTemp, Total_Precip
- y_term_used: X100MCP
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Todd, B.D. & Nowakowski, A.J. (2021), Ectothermy and the macroecology of home range scaling in snakes, Global Ecology and Biogeography, doi:10.1111/geb.13225. CSV original (todd_and_nowakowski_snake_home_range_full_dataset.csv) telecharge directement depuis le depot DataCite/Dryad (10.25338/b85g98) -- pas une reconstruction, N=113 especes, N=109 apres exclusion des 4 lignes sans coordonnees. Les noms de colonnes numeriques (100MCP, 95MCP, 100KD, 95KD) sont automatiquement prefixes 'X' par R a la lecture (100MCP -> X100MCP) -- comportement standard de read.csv/make.names, pas une erreur de donnee. X100MCP retenu comme Y principal (41/109 valeurs non-NA, differentes etudes ayant utilise differentes methodes d'estimation du domaine vital -- NA reel documente, pas fabrique).

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
    formula: "X100MCP ~ MaleMass + IUCN_habitats + Aquatic_index + Elevation + NPP + MeanAnnualTemp + Total_Precip"
    response: "HR (taille du domaine vital, home range, methodes MCP/Kernel Density selon l'etude source)"
    predictors: ["Mass (masse corporelle, log-transformee)", "IUCN_habitats (largeur de niche d'habitat)", "Aquatic_index (indice d'aquaticite)", "Elevation", "NPP (productivite primaire nette)", "MeanAnnualTemp", "Total_Precip"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Todd, B.D. & Nowakowski, A.J. (2021), Ectothermy and the macroecology of home range scaling in snakes, Global Ecology and Biogeography, doi:10.1111/geb.13225. CSV original (todd_and_nowakowski_snake_home_range_full_dataset.csv) telecharge directement depuis le depot DataCite/Dryad (10.25338/b85g98) -- pas une reconstruction, N=113 especes, N=109 apres exclusion des 4 lignes sans coordonnees. Les noms de colonnes numeriques (100MCP, 95MCP, 100KD, 95KD) sont automatiquement prefixes 'X' par R a la lecture (100MCP -> X100MCP) -- comportement standard de read.csv/make.names, pas une erreur de donnee. X100MCP retenu comme Y principal (41/109 valeurs non-NA, differentes etudes ayant utilise differentes methodes d'estimation du domaine vital -- NA reel documente, pas fabrique)."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "X100MCP ~ MaleMass + IUCN_habitats + Aquatic_index + Elevation + NPP + MeanAnnualTemp + Total_Precip"
    response: "X100MCP"
    predictors: ["MaleMass", "IUCN_habitats", "Aquatic_index", "Elevation", "NPP", "MeanAnnualTemp", "Total_Precip"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Todd, B.D. & Nowakowski, A.J. (2021), Ectothermy and the macroecology of home range scaling in snakes, Global Ecology and Biogeography, doi:10.1111/geb.13225. CSV original (todd_and_nowakowski_snake_home_range_full_dataset.csv) telecharge directement depuis le depot DataCite/Dryad (10.25338/b85g98) -- pas une reconstruction, N=113 especes, N=109 apres exclusion des 4 lignes sans coordonnees. Les noms de colonnes numeriques (100MCP, 95MCP, 100KD, 95KD) sont automatiquement prefixes 'X' par R a la lecture (100MCP -> X100MCP) -- comportement standard de read.csv/make.names, pas une erreur de donnee. X100MCP retenu comme Y principal (41/109 valeurs non-NA, differentes etudes ayant utilise differentes methodes d'estimation du domaine vital -- NA reel documente, pas fabrique)."
    estimator_context: ["mixed_effects_model", "gwr", "random_forest"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_snake_home_range`
- Dataset name: Data from: Ectothermy and the macroecology of home range scaling in snakes
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Ectothermy and the macroecology of home range scaling in snakes
- Paper DOI: 10.1111/geb.13225
- Dataset DOI: 10.25338/b85g98
- Source URL: https://datadryad.org/dataset/doi:10.25338/b85g98
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "HR ~ log(Mass) + IUCN_habitats + Aquatic_index + Elevation + NPP + MeanAnnualTemp + Total_Precip + (1|study) + (1|species) [Modele Lineaire Mixte (LMM), package lme4, intercepts aleatoires etude/espece, comparaison de modeles emboites par AICc]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Todd, B.D. & Nowakowski, A.J. (2021), Ectothermy and the macroecology of home range scaling in snakes, Global Ecology and Biogeography, doi:10.1111/geb.13225. CSV original (todd_and_nowakowski_snake_home_range_full_dataset.csv) telecharge directement depuis le depot DataCite/Dryad (10.25338/b85g98) -- pas une reconstruction, N=113 especes, N=109 apres exclusion des 4 lignes sans coordonnees. Les noms de colonnes numeriques (100MCP, 95MCP, 100KD, 95KD) sont automatiquement prefixes 'X' par R a la lecture (100MCP -> X100MCP) -- comportement standard de read.csv/make.names, pas une erreur de donnee. X100MCP retenu comme Y principal (41/109 valeurs non-NA, differentes etudes ayant utilise differentes methodes d'estimation du domaine vital -- NA reel documente, pas fabrique)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "X100MCP (Y principal) non-NA pour 41/109 lignes seulement -- differentes etudes sources ayant utilise differentes methodes d'estimation du domaine vital (MCP vs kernel density), NA reel documente dans le depot, pas impute ni fabrique"
  reason: "Y continu reel (domaine vital, methode MCP), coordonnees GPS reelles (Latitude/Longitude) pour 109/113 especes, covariables ecologiques/biogeographiques exactes du papier (masse, habitat, elevation, NPP, temperature, precipitation). CSV original telecharge directement depuis le depot DataCite/Dryad du papier, pas une reconstruction. Papier lu integralement (TEI) pour confirmer le cadre LMM (lme4, intercepts aleatoires etude/espece)."
```

- Decision: ready
- Manque principal: X100MCP (Y principal) non-NA pour 41/109 lignes seulement -- differentes etudes sources ayant utilise differentes methodes d'estimation du domaine vital (MCP vs kernel density), NA reel documente dans le depot, pas impute ni fabrique
- Raison: Y continu reel (domaine vital, methode MCP), coordonnees GPS reelles (Latitude/Longitude) pour 109/113 especes, covariables ecologiques/biogeographiques exactes du papier (masse, habitat, elevation, NPP, temperature, precipitation). CSV original telecharge directement depuis le depot DataCite/Dryad du papier, pas une reconstruction. Papier lu integralement (TEI) pour confirmer le cadre LMM (lme4, intercepts aleatoires etude/espece).

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
- N observations: 109
- k variables: 30
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-122.358631, 153.440319], y [-35.154131, 55.667364]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=275.8deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`snake_home_range` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `snake_home_range` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20%: Male100MCP (NA=32.1%), Male95MCP (NA=92.7%), Male95KD (NA=69.7%), Male90KD (NA=98.2%), Female100MCP (NA=32.1%), Female95MCP (NA=92.7%), Female95KD (NA=69.7%), Female90KD (NA=98.2%), X100MCP (NA=62.4%), X95MCP (NA=93.6%), X100KD (NA=100%), X95KD (NA=78.9%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`snake_home_range` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Ectothermy and the macroecology of home range scaling in snakes

