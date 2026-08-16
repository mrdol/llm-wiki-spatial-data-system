---
title: paper_avian_phylo_functional_distance
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_avian_phylo_functional_distance.rds
  - DataCite_2023_GlobalVariationInThe_10_1111_geb_1376
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Global variation in the relationship between avian phylogenetic diversity and functional distance is driven by environmental context and constraints" (DOI 10.1111/geb.13762).

## Description du jeu de donnees

- Topic: macroecologie / diversite phylogenetique et fonctionnelle aviaire
- Observation unit: assemblage d'oiseaux georeference (grille mondiale)
- Observed population: assemblages d'oiseaux, echelle mondiale, N=17099 sites
- Geographic context: etendue sf: x [-179.5, 179.5], y [-55.344, 83.719]
- Temporal context: none (cross-sectional)
- Source description: Global variation in the relationship between avian phylogenetic diversity and functional distance is driven by environmental context and constraints
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/geb.13762
- Dataset DOI: 10.5061/dryad.05qfttf8t
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.05qfttf8t
- Local raw dir: `data/raw/papers/DataCite_2023_GlobalVariationInThe_10_1111_geb_1376/`
- Local sf output: `data/final_datasets/sf/paper_avian_phylo_functional_distance.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `PDses`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `PDn`, `PDsd`, `MPDn`, `MPDsd`, `MPFDn`, `MPFDsd`, `PDe`, `MPDe`, `MPFDe`, `abs_lat`, `MPDses`, `MPFDses`, `sp_richn`
- Candidate X count in local artifact: 13
- Candidate X typology: continuous
- Published X variables from paper: MPFD_SES (taille d'effet standardisee de la distance fonctionnelle moyenne par paire, MPFD, calculee via analyse en coordonnees principales sur les traits AVONET), abs_latitude (latitude absolue du centroide de l'assemblage), proportion_migratory_species (proportion d'especes migratrices dans l'assemblage, basee sur Dufour et al. 2019 -- NON incluse dans ce depot, doit etre reconstruite depuis une source externe)
- Published X count: 3
- Coordinates (x, y - excluded from X candidates): `long`, `lat`
- Identifier columns (excluded from X candidates): `site`, `site_num`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PDses` | `numeric` | continuous | [-6.468, 8.8801] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `avian_phylo_functional_distance`, la ou les reponses `PDses` viennent du loader papier et/ou des preuves de l article `Global variation in the relationship between avian phylogenetic diversity and functional distance is driven by environmental context and constraints`. Les covariables X retenues sont `MPFDses`, `abs_lat` ; 11 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`long`, `lat`), identifiants (`site`, `site_num`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `PDn` | `numeric` | continuous | 0% |
| `PDsd` | `numeric` | continuous | 0% |
| `MPDn` | `numeric` | continuous | 0% |
| `MPDsd` | `numeric` | continuous | 0% |
| `MPFDn` | `numeric` | continuous | 0% |
| `MPFDsd` | `numeric` | continuous | 0% |
| `PDe` | `numeric` | continuous | 0% |
| `MPDe` | `numeric` | continuous | 0% |
| `MPFDe` | `numeric` | continuous | 0% |
| `abs_lat` | `numeric` | continuous | 0% |
| `MPDses` | `numeric` | continuous | 0% |
| `MPFDses` | `numeric` | continuous | 0% |
| `sp_richn` | `integer` | count | 0% |

### Formule - niveau publication

- formula_pub: PD_SES ~ MPFD_SES * abs_latitude + proportion_migratory_species [modele d'analyse de cheminement (path analysis / SEM, fonction cfa du package lavaan), teste en 3 variantes emboitees : (1) interaction PD_SES:abs_latitude + proportion migratrice, (2) sans interaction, (3) sans proportion migratrice ; toutes les variables standardisees moyenne 0 / ecart-type 1 avant ajustement]
- x_terms_pub: MPFD_SES (taille d'effet standardisee de la distance fonctionnelle moyenne par paire, MPFD, calculee via analyse en coordonnees principales sur les traits AVONET), abs_latitude (latitude absolue du centroide de l'assemblage), proportion_migratory_species (proportion d'especes migratrices dans l'assemblage, basee sur Dufour et al. 2019 -- NON incluse dans ce depot, doit etre reconstruite depuis une source externe)
- y_term_pub: PD_SES (taille d'effet standardisee de la diversite phylogenetique de Faith, calculee par comparaison a des assemblages nuls bases sur les biomes/realms de Dinerstein et al. 2017)
- Reference publication: Yaxley, K.J., Skeels, A. & Foley, R.A. (2024), Global variation in the relationship between avian phylogenetic diversity and functional distance is driven by environmental context and constraints, Global Ecology and Biogeography, doi:10.1111/geb.13762. CSV original (standerdised_effect_sizes.csv) telecharge directement depuis Dryad (10.5061/dryad.05qfttf8t) -- pas une reconstruction, N=17099 assemblages d'oiseaux georeferences (grille mondiale), verifie identique au N=17,097 degres de liberte cite dans le texte du papier (correlation MPFD/dispersion fonctionnelle, df=17097 -> N=17099 sites). Le papier ajuste un modele de path analysis (lavaan::cfa) sur PD_SES ~ MPFD_SES * abs_latitude + proportion migratrice ; la proportion d'especes migratrices (Dufour et al. 2019) n'est pas incluse dans ce depot Dryad (source externe requise, cf. README) et l'interaction/la structure SEM ne sont pas reproductibles telles quelles hors lavaan. formula_used retient la relation directe documentee par le titre du papier (PD_SES ~ MPFD_SES) plus abs_lat, en regression lineaire simple -- une simplification documentee, pas le modele SEM du papier. sp_richn (richesse specifique de l'assemblage) ajoutee dans ml_formula comme covariable de controle disponible localement, non testee comme telle dans le papier.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Yaxley, K.J., Skeels, A. & Foley, R.A. (2024), Global variation in the relationship between avian phylogenetic diversity and functional distance is driven by environmental context and constraints, Global Ecology and Biogeography, doi:10.1111/geb.13762. CSV original (standerdised_effect_sizes.csv) telecharge directement depuis Dryad (10.5061/dryad.05qfttf8t) -- pas une reconstruction, N=17099 assemblages d'oiseaux georeferences (grille mondiale), verifie identique au N=17,097 degres de liberte cite dans le texte du papier (correlation MPFD/dispersion fonctionnelle, df=17097 -> N=17099 sites). Le papier ajuste un modele de path analysis (lavaan::cfa) sur PD_SES ~ MPFD_SES * abs_latitude + proportion migratrice ; la proportion d'especes migratrices (Dufour et al. 2019) n'est pas incluse dans ce depot Dryad (source externe requise, cf. README) et l'interaction/la structure SEM ne sont pas reproductibles telles quelles hors lavaan. formula_used retient la relation directe documentee par le titre du papier (PD_SES ~ MPFD_SES) plus abs_lat, en regression lineaire simple -- une simplification documentee, pas le modele SEM du papier. sp_richn (richesse specifique de l'assemblage) ajoutee dans ml_formula comme covariable de controle disponible localement, non testee comme telle dans le papier.

### Formule - niveau systeme

- formula_used: PDses ~ MPFDses + abs_lat
- x_terms_used: MPFDses, abs_lat
- y_term_used: PDses
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Yaxley, K.J., Skeels, A. & Foley, R.A. (2024), Global variation in the relationship between avian phylogenetic diversity and functional distance is driven by environmental context and constraints, Global Ecology and Biogeography, doi:10.1111/geb.13762. CSV original (standerdised_effect_sizes.csv) telecharge directement depuis Dryad (10.5061/dryad.05qfttf8t) -- pas une reconstruction, N=17099 assemblages d'oiseaux georeferences (grille mondiale), verifie identique au N=17,097 degres de liberte cite dans le texte du papier (correlation MPFD/dispersion fonctionnelle, df=17097 -> N=17099 sites). Le papier ajuste un modele de path analysis (lavaan::cfa) sur PD_SES ~ MPFD_SES * abs_latitude + proportion migratrice ; la proportion d'especes migratrices (Dufour et al. 2019) n'est pas incluse dans ce depot Dryad (source externe requise, cf. README) et l'interaction/la structure SEM ne sont pas reproductibles telles quelles hors lavaan. formula_used retient la relation directe documentee par le titre du papier (PD_SES ~ MPFD_SES) plus abs_lat, en regression lineaire simple -- une simplification documentee, pas le modele SEM du papier. sp_richn (richesse specifique de l'assemblage) ajoutee dans ml_formula comme covariable de controle disponible localement, non testee comme telle dans le papier.

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
    formula: "PDses ~ MPFDses + abs_lat"
    response: "PD_SES (taille d'effet standardisee de la diversite phylogenetique de Faith, calculee par comparaison a des assemblages nuls bases sur les biomes/realms de Dinerstein et al. 2017)"
    predictors: ["MPFD_SES (taille d'effet standardisee de la distance fonctionnelle moyenne par paire, MPFD, calculee via analyse en coordonnees principales sur les traits AVONET)", "abs_latitude (latitude absolue du centroide de l'assemblage)", "proportion_migratory_species (proportion d'especes migratrices dans l'assemblage, basee sur Dufour et al. 2019 -- NON incluse dans ce depot, doit etre reconstruite depuis une source externe)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Yaxley, K.J., Skeels, A. & Foley, R.A. (2024), Global variation in the relationship between avian phylogenetic diversity and functional distance is driven by environmental context and constraints, Global Ecology and Biogeography, doi:10.1111/geb.13762. CSV original (standerdised_effect_sizes.csv) telecharge directement depuis Dryad (10.5061/dryad.05qfttf8t) -- pas une reconstruction, N=17099 assemblages d'oiseaux georeferences (grille mondiale), verifie identique au N=17,097 degres de liberte cite dans le texte du papier (correlation MPFD/dispersion fonctionnelle, df=17097 -> N=17099 sites). Le papier ajuste un modele de path analysis (lavaan::cfa) sur PD_SES ~ MPFD_SES * abs_latitude + proportion migratrice ; la proportion d'especes migratrices (Dufour et al. 2019) n'est pas incluse dans ce depot Dryad (source externe requise, cf. README) et l'interaction/la structure SEM ne sont pas reproductibles telles quelles hors lavaan. formula_used retient la relation directe documentee par le titre du papier (PD_SES ~ MPFD_SES) plus abs_lat, en regression lineaire simple -- une simplification documentee, pas le modele SEM du papier. sp_richn (richesse specifique de l'assemblage) ajoutee dans ml_formula comme covariable de controle disponible localement, non testee comme telle dans le papier."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "PDses ~ MPFDses + abs_lat + sp_richn"
    response: "PDses"
    predictors: ["MPFDses", "abs_lat", "sp_richn"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Yaxley, K.J., Skeels, A. & Foley, R.A. (2024), Global variation in the relationship between avian phylogenetic diversity and functional distance is driven by environmental context and constraints, Global Ecology and Biogeography, doi:10.1111/geb.13762. CSV original (standerdised_effect_sizes.csv) telecharge directement depuis Dryad (10.5061/dryad.05qfttf8t) -- pas une reconstruction, N=17099 assemblages d'oiseaux georeferences (grille mondiale), verifie identique au N=17,097 degres de liberte cite dans le texte du papier (correlation MPFD/dispersion fonctionnelle, df=17097 -> N=17099 sites). Le papier ajuste un modele de path analysis (lavaan::cfa) sur PD_SES ~ MPFD_SES * abs_latitude + proportion migratrice ; la proportion d'especes migratrices (Dufour et al. 2019) n'est pas incluse dans ce depot Dryad (source externe requise, cf. README) et l'interaction/la structure SEM ne sont pas reproductibles telles quelles hors lavaan. formula_used retient la relation directe documentee par le titre du papier (PD_SES ~ MPFD_SES) plus abs_lat, en regression lineaire simple -- une simplification documentee, pas le modele SEM du papier. sp_richn (richesse specifique de l'assemblage) ajoutee dans ml_formula comme covariable de controle disponible localement, non testee comme telle dans le papier."
    estimator_context: ["sem_path_analysis", "gwr", "sar_lag", "random_forest_xy"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_avian_phylo_functional_distance`
- Dataset name: Data from: Global variation in the relationship between avian phylogenetic diversity and functional distance is driven by environmental context and constraints
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Global variation in the relationship between avian phylogenetic diversity and functional distance is driven by environmental context and constraints
- Paper DOI: 10.1111/geb.13762
- Dataset DOI: 10.5061/dryad.05qfttf8t
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.05qfttf8t
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "PD_SES ~ MPFD_SES * abs_latitude + proportion_migratory_species [modele d'analyse de cheminement (path analysis / SEM, fonction cfa du package lavaan), teste en 3 variantes emboitees : (1) interaction PD_SES:abs_latitude + proportion migratrice, (2) sans interaction, (3) sans proportion migratrice ; toutes les variables standardisees moyenne 0 / ecart-type 1 avant ajustement]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Yaxley, K.J., Skeels, A. & Foley, R.A. (2024), Global variation in the relationship between avian phylogenetic diversity and functional distance is driven by environmental context and constraints, Global Ecology and Biogeography, doi:10.1111/geb.13762. CSV original (standerdised_effect_sizes.csv) telecharge directement depuis Dryad (10.5061/dryad.05qfttf8t) -- pas une reconstruction, N=17099 assemblages d'oiseaux georeferences (grille mondiale), verifie identique au N=17,097 degres de liberte cite dans le texte du papier (correlation MPFD/dispersion fonctionnelle, df=17097 -> N=17099 sites). Le papier ajuste un modele de path analysis (lavaan::cfa) sur PD_SES ~ MPFD_SES * abs_latitude + proportion migratrice ; la proportion d'especes migratrices (Dufour et al. 2019) n'est pas incluse dans ce depot Dryad (source externe requise, cf. README) et l'interaction/la structure SEM ne sont pas reproductibles telles quelles hors lavaan. formula_used retient la relation directe documentee par le titre du papier (PD_SES ~ MPFD_SES) plus abs_lat, en regression lineaire simple -- une simplification documentee, pas le modele SEM du papier. sp_richn (richesse specifique de l'assemblage) ajoutee dans ml_formula comme covariable de controle disponible localement, non testee comme telle dans le papier."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "le papier ajuste un modele de path analysis (SEM, lavaan::cfa) incluant la proportion d'especes migratrices (source externe Dufour et al. 2019, non incluse dans ce depot) et une interaction PD_SES:abs_latitude -- formula_used (PDses ~ MPFDses + abs_lat) est une simplification lineaire documentee de la relation directe testee par le papier, sans la proportion migratrice ni le terme d'interaction -- promu a package_include='yes' apres validation utilisateur (session 2026-08-16, groupe A)"
  reason: "Y continu reel (PDses, taille d'effet standardisee de la diversite phylogenetique de Faith), N=17099 assemblages d'oiseaux georeferences a l'echelle mondiale, verifie contre le degre de liberte cite dans le papier (df=17097 pour la correlation MPFD/dispersion fonctionnelle -> N=17099 sites). X (MPFDses, taille d'effet standardisee de la distance fonctionnelle) et abs_lat exactement les variables de la relation testee par le titre du papier. CSV original (standerdised_effect_sizes.csv) telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) pour confirmer PD_SES/MPFD_SES/abs_latitude comme variables du modele de path analysis (section Methods, path analysis avec lavaan)."
```

- Decision: ready
- Manque principal: le papier ajuste un modele de path analysis (SEM, lavaan::cfa) incluant la proportion d'especes migratrices (source externe Dufour et al. 2019, non incluse dans ce depot) et une interaction PD_SES:abs_latitude -- formula_used (PDses ~ MPFDses + abs_lat) est une simplification lineaire documentee de la relation directe testee par le papier, sans la proportion migratrice ni le terme d'interaction -- promu a package_include="yes" apres validation utilisateur (session 2026-08-16, groupe A)
- Raison: Y continu reel (PDses, taille d'effet standardisee de la diversite phylogenetique de Faith), N=17099 assemblages d'oiseaux georeferences a l'echelle mondiale, verifie contre le degre de liberte cite dans le papier (df=17097 pour la correlation MPFD/dispersion fonctionnelle -> N=17099 sites). X (MPFDses, taille d'effet standardisee de la distance fonctionnelle) et abs_lat exactement les variables de la relation testee par le titre du papier. CSV original (standerdised_effect_sizes.csv) telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) pour confirmer PD_SES/MPFD_SES/abs_latitude comme variables du modele de path analysis (section Methods, path analysis avec lavaan).

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
- N observations: 17099
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
- Spatial extent: x [-179.5, 179.5], y [-55.344, 83.719]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=359deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`avian_phylo_functional_distance` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `avian_phylo_functional_distance` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`avian_phylo_functional_distance` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Global variation in the relationship between avian phylogenetic diversity and functional distance is driven by environmental context and constraints

