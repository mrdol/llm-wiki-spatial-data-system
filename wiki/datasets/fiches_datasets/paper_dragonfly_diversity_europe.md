---
title: paper_dragonfly_diversity_europe
type: dataset
created: 2026-08-16
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_dragonfly_diversity_europe.rds
  - DatasetFirst_10_5061_dryad_78j8g
  - corpus/papers/tei/Pinkert2017Evolutionary.tei.xml
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Data from: Evolutionary processes, dispersal limitation and climatic history shape current diversity patterns of European dragonflies" (DOI 10.1111/ecog.03137).

## Description du jeu de donnees

- Topic: macroecologie / patrons de diversite des libellules europeennes
- Observation unit: cellule de grille (assemblage)
- Observed population: assemblages de libellules (Odonata), Europe, N=4192 cellules
- Geographic context: Etendue mesuree dans le RDS : x [-10.8254325, 63.6436464], y [35.8820412, 70.9768118]; CRS EPSG:4326.
- Temporal context: none (cross-sectional)
- Source description: Data from: Evolutionary processes, dispersal limitation and climatic history shape current diversity patterns of European dragonflies
- Description source: paper_dataset_uses.json + lecture directe du papier + TEI confirme (PDF fourni par l'utilisateur, converti via GROBID le 2026-09-08)
- Description confidence: high (corrige 2026-09-08)
- Paper DOI: 10.1111/ecog.03137
- Dataset DOI: 10.5061/dryad.78j8g
- Source URL: https://doi.org/10.5061/dryad.78j8g
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_78j8g/`
- Local sf output: `data/final_datasets/sf/paper_dragonfly_diversity_europe.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `sp_rich`
- Candidate Y typology: count
- Candidate X variables in local artifact: `alt_mean`, `bio1_mean`, `bio2_mean`, `bio3_mean`, `bio4_mean`, `bio5_mean`, `bio6_mean`, `bio7_mean`, `bio8_mean`, `bio9_mean`, `bio10_mean`, `bio11_mean`, `bio12_mean`, `bio13_mean`, `bio14_mean`, `bio15_mean`, `bio16_mean`, `bio17_mean`, `bio18_mean`, `bio19_mean`, `pc_thermo_1`, `pc_thermo_2`, `pc_preci_1`, `pc_preci_2`, `prop_lelo`, `sum_lentic`, `sum_lotic`, `sum_real_lentic`, `sum_real_lotic`, `TTD`, `MPD`, `SES_MPD`, `geomean_CWE`, `mean_CWE`, `iso.LGM`, `iso.LGM.col`, `TTD_lotic`, `resid_TTD_lentic`, `resid_TTD`, `resid_FPD`, `optional`
- Candidate X count in local artifact: 41
- Candidate X typology: continuous, categorical
- Published X variables from paper: pc_thermo_1, pc_thermo_2, pc_preci_1, pc_preci_2, prop_lelo, iso.LGM
- Published X count: 6
- Coordinates (x, y - excluded from X candidates): `center_lng`, `center_lat`
- Identifier columns (excluded from X candidates): `X`, `ID`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `sp_rich` | `integer` | count | [7, 76] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `dragonfly_diversity_europe`, la ou les reponses `sp_rich` viennent du loader papier et/ou des preuves de l article `Data from: Evolutionary processes, dispersal limitation and climatic history shape current diversity patterns of European dragonflies`. Les covariables X retenues sont `pc_thermo_1`, `pc_thermo_2`, `pc_preci_1`, `pc_preci_2`, `prop_lelo`, `iso.LGM` (corrige 2026-09-08, voir correction ci-dessous -- ce sont exactement les 6 predicteurs du Table 1 du papier) ; 35 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`center_lng`, `center_lat`), identifiants (`X`, `ID`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `alt_mean` | `numeric` | continuous | 0% |
| `bio1_mean` | `numeric` | continuous | 0% |
| `bio2_mean` | `numeric` | continuous | 0% |
| `bio3_mean` | `numeric` | continuous | 0% |
| `bio4_mean` | `numeric` | continuous | 0% |
| `bio5_mean` | `numeric` | continuous | 0% |
| `bio6_mean` | `numeric` | continuous | 0% |
| `bio7_mean` | `numeric` | continuous | 0% |
| `bio8_mean` | `numeric` | continuous | 0% |
| `bio9_mean` | `numeric` | continuous | 0% |
| `bio10_mean` | `numeric` | continuous | 0% |
| `bio11_mean` | `numeric` | continuous | 0% |
| `bio12_mean` | `numeric` | continuous | 0% |
| `bio13_mean` | `numeric` | continuous | 0% |
| `bio14_mean` | `numeric` | continuous | 0% |
| `bio15_mean` | `numeric` | continuous | 0% |
| `bio16_mean` | `numeric` | continuous | 0% |
| `bio17_mean` | `numeric` | continuous | 0% |
| `bio18_mean` | `numeric` | continuous | 0% |
| `bio19_mean` | `numeric` | continuous | 0% |
| `pc_thermo_1` | `numeric` | continuous | 0% |
| `pc_thermo_2` | `numeric` | continuous | 0% |
| `pc_preci_1` | `numeric` | continuous | 0% |
| `pc_preci_2` | `numeric` | continuous | 0% |
| `prop_lelo` | `numeric` | rate | 0% |
| `sum_lentic` | `integer` | count | 0% |
| `sum_lotic` | `integer` | count | 0% |
| `sum_real_lentic` | `integer` | count | 0% |
| `sum_real_lotic` | `integer` | count | 0% |
| `TTD` | `numeric` | continuous | 0% |
| `MPD` | `numeric` | rate | 0% |
| `SES_MPD` | `numeric` | continuous | 0% |
| `geomean_CWE` | `numeric` | rate | 0% |
| `mean_CWE` | `numeric` | rate | 0% |
| `iso.LGM` | `integer` | binary | 0% |
| `iso.LGM.col` | `character` | categorical | 0% |
| `TTD_lotic` | `numeric` | continuous | 0% |
| `resid_TTD_lentic` | `numeric` | continuous | 0% |
| `resid_TTD` | `numeric` | continuous | 0% |
| `resid_FPD` | `numeric` | continuous | 0% |
| `optional` | `logical` | binary | 0% |

### Formule - niveau publication

- formula_pub: sp_rich ~ pc_thermo_1 + pc_thermo_2 + pc_preci_1 + pc_preci_2 + prop_lelo + iso.LGM [Pinkert, Dijkstra, Zeuss, Reudenbach, Brandl & Hof (2017), Ecography 40, doi:10.1111/ecog.03137, Table 1 -- GAM (mgcv::gam) avec famille gamma pour la richesse, quasi-Poisson pour l'endemisme (CWE), gaussienne pour SES MPD]
- x_terms_pub: pc_thermo_1, pc_thermo_2, pc_preci_1, pc_preci_2, prop_lelo, iso.LGM
- y_term_pub: sp_rich
- Reference publication: Pinkert et al. (2017), Ecography 40, doi:10.1111/ecog.03137, "Evolutionary processes, dispersal limitation and climatic history shape current diversity patterns of European dragonflies".
- CORRECTION FINALE (2026-09-08, PDF fourni par l'utilisateur, converti en TEI via GROBID, texte integral Material and Methods + Table 1 lus directement) : le modele reellement publie (Table 1, "Regression models") est un GAM (mgcv, Wood 2011) avec 5 mesures de diversite modelisees separement (Richness=gamma, CWE/endemisme=quasi-Poisson, TTD=gamma, SES MPD=gaussienne, PD de Faith=gamma), predicteurs = 4 composantes PCA du climat (pc_thermo_1/2, pc_preci_1/2 -- "four principal components that describe temperature and precipitation") + proportion lentique/lotique (prop_lelo) + isotherme LGM (iso.LGM, code 1=zone non glaciee au sud, 0=zone glaciee au nord -- confirme exactement par le codage binaire deja present dans notre RDS). La latitude (`center_lat`) n'est PAS un predicteur du modele GAM principal (Table 1) -- elle sert uniquement a une analyse SEPAREE de regression par segments (broken-line, package `segmented`) pour detecter des ruptures de pente dans les relations diversite~latitude, une analyse complementaire distincte, pas le modele de regression principal. La correction du 2026-08-16 (base sur l'abstract seul) avait a tort remplace pc_thermo_1/pc_preci_1 (proposition initiale correcte du curateur) par center_lat -- cette session retablit les variables PCA, desormais confirmees par le texte integral et deja disponibles telles quelles dans le RDS local (aucune reconstruction necessaire).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et corrigee (GAM, famille gamma pour la richesse)
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du texte integral (PDF fourni par l'utilisateur, session du 2026-09-08), corrigeant la reconstruction partielle du 2026-08-16 basee sur l'abstract seul. Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: sp_rich ~ pc_thermo_1 + pc_thermo_2 + pc_preci_1 + pc_preci_2 + prop_lelo + iso.LGM
- Selected Y evidence: Ligne Detail Y correspondant a formula_used, desormais alignee sur le modele Table 1 du papier (GAM, famille gamma).
- Selected Y typology: count
- x_terms_used: pc_thermo_1, pc_thermo_2, pc_preci_1, pc_preci_2, prop_lelo, iso.LGM
- y_term_used: sp_rich
- Note: Formule corrigee le 2026-09-08 par lecture du texte integral (Table 1) -- remplace l'ancienne formule (center_lat + prop_lelo + iso.LGM) qui confondait le modele GAM principal avec l'analyse separee de regression par segments contre la latitude. Voir 'Reference publication' ci-dessus pour la citation complete.

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
    formula: "sp_rich ~ pc_thermo_1 + pc_thermo_2 + pc_preci_1 + pc_preci_2 + prop_lelo + iso.LGM"
    response: "sp_rich"
    predictors: ["pc_thermo_1", "pc_thermo_2", "pc_preci_1", "pc_preci_2", "prop_lelo", "iso.LGM"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Pinkert et al. (2017), Ecography 40, doi:10.1111/ecog.03137, Table 1 -- GAM (mgcv), famille gamma pour la richesse."
    estimator_context: ["gam_spatial"]
    status: "confirmed"

  ml_or_selected:
    formula: "sp_rich ~ pc_thermo_1 + pc_thermo_2 + pc_preci_1 + pc_preci_2 + prop_lelo + iso.LGM + bio1_mean + alt_mean"
    response: "sp_rich"
    predictors: ["pc_thermo_1", "pc_thermo_2", "pc_preci_1", "pc_preci_2", "prop_lelo", "iso.LGM", "bio1_mean", "alt_mean"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_error", "gwr", "random_forest"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_dragonfly_diversity_europe`
- Dataset name: Data from: Evolutionary processes, dispersal limitation and climatic history shape current diversity patterns of European dragonflies
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Evolutionary processes, dispersal limitation and climatic history shape current diversity patterns of European dragonflies
- Paper DOI: 10.1111/ecog.03137
- Dataset DOI: 10.5061/dryad.78j8g
- Source URL: https://doi.org/10.5061/dryad.78j8g
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "diversity_measure ~ latitude (broken-line/piecewise) + prop_lelo + iso.LGM [Pinkert, Dijkstra, Zeuss, Reudenbach, Brandl & Hof (2017), Ecography 40, doi:10.1111/ecog.03137, 'Evolutionary processes, dispersal limitation and climatic history shape current diversity patterns of European dragonflies'. Abstract confirme (WebFetch, session 2026-08-16) : le papier teste si endemisme/diversite phylogenetique sont structures par 1) conservatisme phylogenetique des adaptations thermiques et 2) differences de capacite de recolonisation post-glaciaire entre especes lotiques/lentiques -- via regression par segments (broken-line) le long de la latitude ; variables explicites confirmees : latitude, proportion d'especes lentiques, statut de glaciation historique (LGM). Le texte integral (variables bioclimatiques exactes des modeles) reste hors de portee -- resume/abstract uniquement]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "REVISE (session 2026-08-16, recherche bibliographique demandee par l'utilisateur) : papier confirme avec DOI -- Pinkert et al. (2017), Ecography 40, doi:10.1111/ecog.03137. L'abstract officiel (WebFetch ecography.org) confirme que le papier teste la richesse/endemisme/diversite phylogenetique en fonction de la latitude (regression par segments/broken-line), de la proportion d'especes lentiques vs lotiques (capacite de recolonisation post-glaciaire) et du statut de glaciation historique (LGM) -- ces trois variables correspondent exactement aux colonnes reelles center_lat, prop_lelo et iso.LGM du CSV local (0% NA sur les trois, N=4192). formula_used corrigee (session 2026-08-16) : remplace bio1_mean/alt_mean/pc_thermo_1/pc_preci_1 (proposition initiale du curateur sans preuve textuelle) par center_lat/prop_lelo/iso.LGM (variables explicitement confirmees par l'abstract du papier). Le texte integral (specification exacte du modele de regression par segments, variables bioclimatiques additionnelles eventuelles) n'a pas pu etre consulte -- CSV original (Assemblage-level data) telecharge directement depuis Dryad, pas une reconstruction. package_include laisse en manual_review : variables alignees avec l'abstract confirme, mais pas la specification complete du modele publie (broken-line regression, pas OLS standard)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_count_gam_gamma_confirmed"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Bloc complete le 2026-09-08 apres lecture du texte integral (PDF fourni par l'utilisateur, converti en TEI via GROBID). formula_used corrigee pour utiliser les 6 vrais predicteurs du modele publie (Table 1 : pc_thermo_1/2, pc_preci_1/2, prop_lelo, iso.LGM), tous deja disponibles dans le RDS local sans reconstruction. gam_spatial (famille gamma) est l'estimateur scientifiquement fonde -- le papier utilise mgcv::gam avec cette famille exacte."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Bloc complete le 2026-09-08 apres lecture du texte integral (PDF fourni par l'utilisateur, converti en TEI via GROBID). formula_used corrigee pour utiliser les 6 vrais predicteurs du modele publie (Table 1 : pc_thermo_1/2, pc_preci_1/2, prop_lelo, iso.LGM), tous deja disponibles dans le RDS local sans reconstruction. gam_spatial (famille gamma) est l'estimateur scientifiquement fonde -- le papier utilise mgcv::gam avec cette famille exacte.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators:
    - estimator: gam_spatial
      basis: scientific_evidence
      source_ref: "Pinkert et al. (2017), Ecography 40, doi:10.1111/ecog.03137, Table 1 -- \"generalized additive models implemented in the R package mgcv (Wood 2011)... richness... = gamma distribution\"."
      notes: "Modele final publie, verbatim (6 predicteurs : pc_thermo_1/2, pc_preci_1/2, prop_lelo, iso.LGM). Necessite un lien/famille gamma pour reproduire exactement -- a verifier que le harnais l'autorise (mgcv::gam supporte nativement Gamma(link=log))."
    - estimator: ols
      basis: benchmark_use
      source_ref: "Comparateur non-spatial standard (le papier utilise GAM, pas OLS, pour le modele principal)."
      notes: "Approximation lineaire, pas le modele publie."
  conditionally_eligible_estimators: []
  ineligible_reason: "Bloc complete le 2026-09-08 apres lecture du texte integral (PDF fourni par l'utilisateur, converti en TEI via GROBID). formula_used corrigee pour utiliser les 6 vrais predicteurs du modele publie (Table 1 : pc_thermo_1/2, pc_preci_1/2, prop_lelo, iso.LGM), tous deja disponibles dans le RDS local sans reconstruction. gam_spatial (famille gamma) est l'estimateur scientifiquement fonde -- le papier utilise mgcv::gam avec cette famille exacte."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 4192
- k variables: 47
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-10.8254325, 63.6436464], y [35.8820412, 70.9768118]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=74.5deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.78j8g (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`dragonfly_diversity_europe` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `dragonfly_diversity_europe` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`dragonfly_diversity_europe` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: [dataset-first, publication non resolue] Data from: Evolutionary processes, dispersal limitation and climatic history shape current diversity patterns of European dragonflies

## Curation documentée — 2026-09-07

Decision conservatoire : Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : count. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
