---
title: paper_avian_phylo_functional_distance
type: dataset
created: 2026-09-14
updated: 2026-09-07
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

- Candidate Y variables: `MPFDses`, `PDses`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `PDn`, `PDsd`, `MPDn`, `MPDsd`, `MPFDn`, `MPFDsd`, `PDe`, `MPDe`, `MPFDe`, `abs_lat`, `MPDses`, `sp_richn`
- Candidate X count in local artifact: 12
- Candidate X typology: continuous, unknown
- Published X variables from paper: PD_SES (taille d'effet standardisee de la diversite phylogenetique de Faith, en interaction avec la latitude), abs_latitude, proportion_migratory_species (source externe Dufour et al. 2019, absente de ce depot), altitude (source externe Weeks et al. 2022/Bioclim, disponible pour 16979/17099 sites dans le papier, absente de ce depot), species_richness (disponible localement : sp_richn)
- Published X count: 5
- Coordinates (x, y - excluded from X candidates): `long`, `lat`
- Identifier columns (excluded from X candidates): `site`, `site_num`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `MPFDses` | `numeric` | continuous | [-5.9103, 4.6959] | 0% |
| `PDses` | `numeric` | continuous | [-6.468, 8.8801] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `avian_phylo_functional_distance`, la ou les reponses `MPFDses`, `PDses` viennent du loader papier et/ou des preuves de l article `Global variation in the relationship between avian phylogenetic diversity and functional distance is driven by environmental context and constraints`. Les covariables X retenues sont `PDses`, `abs_lat`, `sp_richn` ; 10 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`long`, `lat`), identifiants (`site`, `site_num`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

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
| `sp_richn` | `integer` | unknown | 0% |

### Formule - niveau publication

- formula_pub: MPFD_SES ~ PD_SES * abs_latitude + proportion_migratory_species + altitude + species_richness [path analysis/SEM, lavaan cfa]
- x_terms_pub: PD_SES (taille d'effet standardisee de la diversite phylogenetique de Faith, en interaction avec la latitude), abs_latitude, proportion_migratory_species (source externe Dufour et al. 2019, absente de ce depot), altitude (source externe Weeks et al. 2022/Bioclim, disponible pour 16979/17099 sites dans le papier, absente de ce depot), species_richness (disponible localement : sp_richn)
- y_term_pub: MPFD_SES (taille d'effet standardisee de la distance fonctionnelle moyenne par paire, variable expliquee du modele le mieux ajuste)
- Reference publication: Yaxley, K.J., Skeels, A. & Foley, R.A. (2023), Global variation in the relationship between avian phylogenetic diversity and functional distance is driven by environmental context and constraints, Global Ecology and Biogeography 32:2122-2134, doi:10.1111/geb.13762 (Crossref confirme publication 2023-09-28 -- la fiche precedente et le source_ref citaient a tort '2024'). CSV original (standerdised_effect_sizes.csv) telecharge directement depuis Dryad (10.5061/dryad.05qfttf8t) -- pas une reconstruction, N=17099 assemblages d'oiseaux georeferences (grille mondiale), verifie identique au N=17,097 degres de liberte cite dans le texte. CORRECTION MAJEURE (2026-09-10, lecture directe du PDF p.2127, section 3.2) : le modele le mieux ajuste (BIC le plus bas) a pour variable expliquee MPFD_SES, pas PD_SES -- 'the two most important predictors of MPFD_SES were PD_SES and migration' (coefficients cites ci-dessus dans formula_used_divergence_note). La fiche precedente inversait Y et X (PD_SES ~ MPFD_SES), erreur non detectee lors de la premiere lecture du 2026-08-16. Le resume du papier motive aussi ce sens : PD est teste comme 'surrogate' (predicteur) de la diversite fonctionnelle, pas l'inverse. CORRECTION (2026-09-14, revue externe croisee avec relecture directe du PDF p.2127) : altitude et richesse specifique sont en realite des covariables communes aux 3 variantes de modele comparees par les auteurs ('across all three models', avec coefficient et p-value rapportes pour chacune), pas des predicteurs testes-puis-ecartes comme la fiche l'affirmait a tort -- formula_pub corrigee pour les inclure. species_richness (sp_richn) est disponible localement et ajoutee a formula_used ; altitude (Weeks et al. 2022, Bioclim, 16979/17099 sites seulement dans le papier) et la proportion d'especes migratrices (Dufour et al. 2019) restent des sources externes absentes de ce depot Dryad. Le papier utilise une path analysis / Structural Equation Model (lavaan::cfa, verifiee robuste par une variante spatiale sesem) sur un systeme de 4 equations simultanees (MPFD_SES, PD_SES, migration, richesse specifique comme variables endogenes) -- PAS un SAR/SEM-error/SDM/GWR au sens econometrie spatiale du benchmark (ambiguite de vocabulaire : 'SEM' designe ici Structural Equation Model, pas Spatial Error Model). Un terme d'interaction (PD_SES:abs_latitude) reste un simple terme produit, parfaitement calculable hors lavaan dans une regression classique -- ce n'est pas ce qui empeche la reproduction du systeme complet.

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d estimation: formule systeme generee (formula_pub confirmee mais non reprise telle quelle -- voir Note ci-dessous)
- Correspondance Python/R: aucune identifiee
- Note: formula_pub est confirmee par le texte des resultats (Yaxley et al. 2023, p.2127 : 'the model with the lowest BIC ... included both the proportion of migratory species and the interaction between PD_SES and latitude as predictors of MPFD_SES', coefficients PD_SES beta=-0.323 [-0.346,-0.23] p<0.001, Migration beta=-0.298 [-0.329,-0.267] p<0.001 ; altitude et richesse specifique sont des covariables communes aux trois variantes de modele comparees -- Altitude beta=0.032 [0.018,0.047] p<0.001, Species richness beta=-0.012 [-0.032,0.007] p=0.205). L'altitude (source externe Weeks et al. 2022, Bioclim, disponible pour 16979/17099 sites seulement dans le papier) n'est PAS dans ce depot Dryad et reste absente de formula_used ; la proportion d'especes migratrices (source externe Dufour et al. 2019) n'y est pas non plus. species_richness (sp_richn) EST disponible localement et ajoutee a formula_used. Le terme d'interaction PD_SES:abs_latitude n'est PAS en soi un obstacle -- une interaction est un simple terme produit, calculable dans n'importe quelle regression classique (PDses*abs_lat) ; ce qui manque reellement pour reproduire le papier est le systeme complet a 4 equations simultanees (path analysis lavaan::cfa sur MPFD_SES/PD_SES/migration/richesse, verifie robuste par une variante spatiale sesem) et la migration externe -- pas la syntaxe de l'interaction elle-meme. formula_used reste une regression lineaire simple sur les variables disponibles localement -- une simplification documentee, pas le systeme SEM du papier.

### Formule - niveau systeme

- formula_used: MPFDses ~ PDses + abs_lat + sp_richn
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: PDses, abs_lat, sp_richn
- y_term_used: MPFDses
- Note: CORRECTION (2026-09-10, verification PDF p.2127) : la fiche precedente avait Y et X inverses (PD_SES ~ MPFD_SES au lieu de MPFD_SES ~ PD_SES). Le texte des resultats et le resume du papier ('PD is an unreliable surrogate for functional diversity') confirment sans ambiguite que MPFD_SES est la variable expliquee (outcome) et PD_SES (en interaction avec la latitude) plus la proportion migratrice sont les predicteurs -- pas l'inverse. CORRECTION (2026-09-14, relecture suite a une revue externe) : altitude et richesse specifique avaient ete a tort exclues de formula_pub en interpretant 'very little effect' comme 'non retenues du modele' -- le texte precise en realite qu'elles sont des covariables communes aux 3 variantes de modele comparees, avec un coefficient rapporte pour chacune (altitude significative, p<0.001 ; richesse specifique non significative, p=0.205). species_richness (sp_richn) est disponible localement et ajoutee a formula_used ; altitude reste absente (source externe Weeks et al. 2022, non incluse dans ce depot).

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
    formula: "MPFDses ~ PDses + abs_lat + sp_richn"
    response: "MPFD_SES (taille d'effet standardisee de la distance fonctionnelle moyenne par paire, variable expliquee du modele le mieux ajuste)"
    predictors: ["PD_SES (taille d'effet standardisee de la diversite phylogenetique de Faith, en interaction avec la latitude)", "abs_latitude", "proportion_migratory_species (source externe Dufour et al. 2019, absente de ce depot)", "altitude (source externe Weeks et al. 2022/Bioclim, disponible pour 16979/17099 sites dans le papier, absente de ce depot)", "species_richness (disponible localement : sp_richn)"]
    role: "benchmark_simplified_specification"
    source_type: "derived_from_scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
    status: "executable_approximation"

  ml_or_selected:
    formula: "MPFDses ~ PDses + abs_lat + sp_richn"
    response: "MPFDses"
    predictors: ["PDses", "abs_lat", "sp_richn"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
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
- Year: 2023

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "MPFD_SES ~ PD_SES * abs_latitude + proportion_migratory_species + altitude + species_richness [path analysis/SEM, lavaan cfa]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: path_analysis_structural_equation_model
  source_type: scientific_publication_or_package_documentation
  source_ref: "Yaxley, K.J., Skeels, A. & Foley, R.A. (2023), Global variation in the relationship between avian phylogenetic diversity and functional distance is driven by environmental context and constraints, Global Ecology and Biogeography 32:2122-2134, doi:10.1111/geb.13762 (Crossref confirme publication 2023-09-28 -- la fiche precedente et le source_ref citaient a tort '2024'). CSV original (standerdised_effect_sizes.csv) telecharge directement depuis Dryad (10.5061/dryad.05qfttf8t) -- pas une reconstruction, N=17099 assemblages d'oiseaux georeferences (grille mondiale), verifie identique au N=17,097 degres de liberte cite dans le texte. CORRECTION MAJEURE (2026-09-10, lecture directe du PDF p.2127, section 3.2) : le modele le mieux ajuste (BIC le plus bas) a pour variable expliquee MPFD_SES, pas PD_SES -- 'the two most important predictors of MPFD_SES were PD_SES and migration' (coefficients cites ci-dessus dans formula_used_divergence_note). La fiche precedente inversait Y et X (PD_SES ~ MPFD_SES), erreur non detectee lors de la premiere lecture du 2026-08-16. Le resume du papier motive aussi ce sens : PD est teste comme 'surrogate' (predicteur) de la diversite fonctionnelle, pas l'inverse. CORRECTION (2026-09-14, revue externe croisee avec relecture directe du PDF p.2127) : altitude et richesse specifique sont en realite des covariables communes aux 3 variantes de modele comparees par les auteurs ('across all three models', avec coefficient et p-value rapportes pour chacune), pas des predicteurs testes-puis-ecartes comme la fiche l'affirmait a tort -- formula_pub corrigee pour les inclure. species_richness (sp_richn) est disponible localement et ajoutee a formula_used ; altitude (Weeks et al. 2022, Bioclim, 16979/17099 sites seulement dans le papier) et la proportion d'especes migratrices (Dufour et al. 2019) restent des sources externes absentes de ce depot Dryad. Le papier utilise une path analysis / Structural Equation Model (lavaan::cfa, verifiee robuste par une variante spatiale sesem) sur un systeme de 4 equations simultanees (MPFD_SES, PD_SES, migration, richesse specifique comme variables endogenes) -- PAS un SAR/SEM-error/SDM/GWR au sens econometrie spatiale du benchmark (ambiguite de vocabulaire : 'SEM' designe ici Structural Equation Model, pas Spatial Error Model). Un terme d'interaction (PD_SES:abs_latitude) reste un simple terme produit, parfaitement calculable hors lavaan dans une regression classique -- ce n'est pas ce qui empeche la reproduction du systeme complet."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "le papier ajuste une path analysis / Structural Equation Model (lavaan::cfa, verifiee robuste par une variante spatiale sesem) sur un systeme de 4 equations simultanees (MPFD_SES, PD_SES, migration, richesse specifique comme variables endogenes) -- pas un SAR/SEM-error/SDM/GWR au sens econometrie spatiale (attention a l'ambiguite de vocabulaire : 'SEM' du papier = Structural Equation Model, pas Spatial Error Model). formula_used (MPFDses ~ PDses + abs_lat + sp_richn) est une simplification lineaire documentee du chemin MPFD_SES du systeme complet, sans la proportion migratrice (Dufour et al. 2019) ni l'altitude (Weeks et al. 2022, Bioclim) -- toutes deux des sources externes absentes de ce depot Dryad -- promu a package_include='yes' apres validation utilisateur (session 2026-08-16, groupe A ; corrige 2026-09-10 pour l'inversion Y/X, corrige 2026-09-14 pour la specification complete du chemin MPFD_SES)"
  reason: "Y continu reel (MPFDses, taille d'effet standardisee de la distance fonctionnelle moyenne par paire -- variable expliquee du chemin le mieux ajuste du papier, PAS PDses), N=17099 assemblages d'oiseaux georeferences a l'echelle mondiale, verifie contre le degre de liberte cite dans le papier (df=17097 -> N=17099 sites). X (PDses, taille d'effet standardisee de la diversite phylogenetique de Faith, plus abs_lat et sp_richn) sont les variables du chemin MPFD_SES disponibles localement. CSV original (standerdised_effect_sizes.csv) telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (PDF p.2127, section 3.2) pour confirmer MPFD_SES comme variable expliquee et PD_SES/abs_latitude/migration/altitude/richesse specifique comme predicteurs de ce chemin."
```

- Decision: ready
- Manque principal: le papier ajuste une path analysis / Structural Equation Model (lavaan::cfa, verifiee robuste par une variante spatiale sesem) sur un systeme de 4 equations simultanees (MPFD_SES, PD_SES, migration, richesse specifique comme variables endogenes) -- pas un SAR/SEM-error/SDM/GWR au sens econometrie spatiale (attention a l'ambiguite de vocabulaire : 'SEM' du papier = Structural Equation Model, pas Spatial Error Model). formula_used (MPFDses ~ PDses + abs_lat + sp_richn) est une simplification lineaire documentee du chemin MPFD_SES du systeme complet, sans la proportion migratrice (Dufour et al. 2019) ni l'altitude (Weeks et al. 2022, Bioclim) -- toutes deux des sources externes absentes de ce depot Dryad -- promu a package_include="yes" apres validation utilisateur (session 2026-08-16, groupe A ; corrige 2026-09-10 pour l'inversion Y/X, corrige 2026-09-14 pour la specification complete du chemin MPFD_SES)
- Raison: Y continu reel (MPFDses, taille d'effet standardisee de la distance fonctionnelle moyenne par paire -- variable expliquee du chemin le mieux ajuste du papier, PAS PDses), N=17099 assemblages d'oiseaux georeferences a l'echelle mondiale, verifie contre le degre de liberte cite dans le papier (df=17097 -> N=17099 sites). X (PDses, taille d'effet standardisee de la diversite phylogenetique de Faith, plus abs_lat et sp_richn) sont les variables du chemin MPFD_SES disponibles localement. CSV original (standerdised_effect_sizes.csv) telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (PDF p.2127, section 3.2) pour confirmer MPFD_SES comme variable expliquee et PD_SES/abs_latitude/migration/altitude/richesse specifique comme predicteurs de ce chemin.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready"
  eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
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
- Spatial resolution: point observation (support reel : cellule de grille mondiale (assemblage d'oiseaux georeference, taille non precisee))
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-179.5, 179.5], y [-55.344, 83.719]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending — etendue continentale/mondiale (span=359deg) -- projection nationale non pertinente ; privilegier une projection equal-area continentale ou mondiale (ex: Albers equal-area continental, Behrmann/Mollweide pour une couverture mondiale)

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.05qfttf8t (checked 2026-09-10): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`avian_phylo_functional_distance` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `avian_phylo_functional_distance` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formula_pub confirmee et verifiee (voir Reference publication) ; formula_used est une approximation generee distincte, explicitement etiquetee comme telle (voir Bloc 1 > Statut regression canonique > Note).
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`avian_phylo_functional_distance` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Global variation in the relationship between avian phylogenetic diversity and functional distance is driven by environmental context and constraints

## Curation documentée — 2026-09-07

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

MISE A JOUR (2026-09-10) : Y corrige de PDses vers MPFDses (Y/X etaient inverses par rapport au papier, voir FORMULA_OVERRIDES) -- selected_response synchronise pour que la typologie 'Selected Y typology' s'applique a la bonne ligne du tableau Detail Y.
