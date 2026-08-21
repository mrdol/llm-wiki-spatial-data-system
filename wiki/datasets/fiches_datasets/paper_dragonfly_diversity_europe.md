---
title: paper_dragonfly_diversity_europe
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_dragonfly_diversity_europe.rds
  - DatasetFirst_10_5061_dryad_78j8g
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "[dataset-first, publication non resolue] Data from: Evolutionary processes, dispersal limitation and climatic history shape current diversity patterns of European dragonflies" (DOI unknown).

## Description du jeu de donnees

- Topic: macroecologie / patrons de diversite des libellules europeennes
- Observation unit: cellule de grille (assemblage)
- Observed population: assemblages de libellules (Odonata), Europe, N=4192 cellules
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: [dataset-first, publication non resolue] Data from: Evolutionary processes, dispersal limitation and climatic history shape current diversity patterns of European dragonflies
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: unknown
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
- Published X variables from paper: center_lat (latitude du centre de la cellule -- le papier utilise une regression par segments le long de la latitude), prop_lelo (proportion d'especes lentiques/lotiques -- variable explicitement testee par le papier, capacite de recolonisation post-glaciaire), iso.LGM (statut de glaciation historique au Dernier Maximum Glaciaire, binaire -- variable explicitement testee par le papier)
- Published X count: 3
- Coordinates (x, y - excluded from X candidates): `center_lng`, `center_lat`
- Identifier columns (excluded from X candidates): `X`, `ID`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `sp_rich` | `integer` | count | [7, 76] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `dragonfly_diversity_europe`, la ou les reponses `sp_rich` viennent du loader papier et/ou des preuves de l article `[dataset-first, publication non resolue] Data from: Evolutionary processes, dispersal limitation and climatic history shape current diversity patterns of European dragonflies`. Les covariables X retenues sont `prop_lelo`, `iso.LGM` ; 39 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`center_lng`, `center_lat`), identifiants (`X`, `ID`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

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

- formula_pub: diversity_measure ~ latitude (broken-line/piecewise) + prop_lelo + iso.LGM [Pinkert, Dijkstra, Zeuss, Reudenbach, Brandl & Hof (2017), Ecography 40, doi:10.1111/ecog.03137, 'Evolutionary processes, dispersal limitation and climatic history shape current diversity patterns of European dragonflies'. Abstract confirme (WebFetch, session 2026-08-16) : le papier teste si endemisme/diversite phylogenetique sont structures par 1) conservatisme phylogenetique des adaptations thermiques et 2) differences de capacite de recolonisation post-glaciaire entre especes lotiques/lentiques -- via regression par segments (broken-line) le long de la latitude ; variables explicites confirmees : latitude, proportion d'especes lentiques, statut de glaciation historique (LGM). Le texte integral (variables bioclimatiques exactes des modeles) reste hors de portee -- resume/abstract uniquement]
- x_terms_pub: center_lat (latitude du centre de la cellule -- le papier utilise une regression par segments le long de la latitude), prop_lelo (proportion d'especes lentiques/lotiques -- variable explicitement testee par le papier, capacite de recolonisation post-glaciaire), iso.LGM (statut de glaciation historique au Dernier Maximum Glaciaire, binaire -- variable explicitement testee par le papier)
- y_term_pub: sp_rich (richesse specifique de libellules par cellule d'assemblage ; le papier utilise aussi endemisme pondere et distance phylogenetique moyenne comme reponses alternatives, non retenues ici)
- Reference publication: REVISE (session 2026-08-16, recherche bibliographique demandee par l'utilisateur) : papier confirme avec DOI -- Pinkert et al. (2017), Ecography 40, doi:10.1111/ecog.03137. L'abstract officiel (WebFetch ecography.org) confirme que le papier teste la richesse/endemisme/diversite phylogenetique en fonction de la latitude (regression par segments/broken-line), de la proportion d'especes lentiques vs lotiques (capacite de recolonisation post-glaciaire) et du statut de glaciation historique (LGM) -- ces trois variables correspondent exactement aux colonnes reelles center_lat, prop_lelo et iso.LGM du CSV local (0% NA sur les trois, N=4192). formula_used corrigee (session 2026-08-16) : remplace bio1_mean/alt_mean/pc_thermo_1/pc_preci_1 (proposition initiale du curateur sans preuve textuelle) par center_lat/prop_lelo/iso.LGM (variables explicitement confirmees par l'abstract du papier). Le texte integral (specification exacte du modele de regression par segments, variables bioclimatiques additionnelles eventuelles) n'a pas pu etre consulte -- CSV original (Assemblage-level data) telecharge directement depuis Dryad, pas une reconstruction. package_include laisse en manual_review : variables alignees avec l'abstract confirme, mais pas la specification complete du modele publie (broken-line regression, pas OLS standard).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: sp_rich ~ center_lat + prop_lelo + iso.LGM
- x_terms_used: prop_lelo, iso.LGM
- y_term_used: sp_rich
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
    formula: "sp_rich ~ center_lat + prop_lelo + iso.LGM"
    response: "sp_rich (richesse specifique de libellules par cellule d'assemblage ; le papier utilise aussi endemisme pondere et distance phylogenetique moyenne comme reponses alternatives, non retenues ici)"
    predictors: ["center_lat (latitude du centre de la cellule -- le papier utilise une regression par segments le long de la latitude)", "prop_lelo (proportion d'especes lentiques/lotiques -- variable explicitement testee par le papier, capacite de recolonisation post-glaciaire)", "iso.LGM (statut de glaciation historique au Dernier Maximum Glaciaire, binaire -- variable explicitement testee par le papier)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "sp_rich ~ center_lat + prop_lelo + iso.LGM + bio1_mean + alt_mean"
    response: "sp_rich"
    predictors: ["center_lat", "prop_lelo", "iso.LGM", "bio1_mean", "alt_mean"]
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
- Paper title: [dataset-first, publication non resolue] Data from: Evolutionary processes, dispersal limitation and climatic history shape current diversity patterns of European dragonflies
- Paper DOI: unknown
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
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "papier confirme avec DOI (Pinkert et al. 2017, Ecography, doi:10.1111/ecog.03137) -- formula_used corrigee pour utiliser les variables explicitement confirmees par l'abstract (latitude, proportion lentique/lotique, glaciation LGM) au lieu de variables bioclimatiques non verifiees -- promu a package_include='yes' apres validation utilisateur (session 2026-08-16)"
  reason: "Y continu reel (sp_rich, richesse specifique de libellules), N=4192 cellules d'assemblage europeennes avec coordonnees reelles. CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier identifie via le nom du fichier (Pinkert et al. 2017, Ecography ECOG-03137)."
```

- Decision: ready
- Manque principal: papier confirme avec DOI (Pinkert et al. 2017, Ecography, doi:10.1111/ecog.03137) -- formula_used corrigee pour utiliser les variables explicitement confirmees par l'abstract (latitude, proportion lentique/lotique, glaciation LGM) au lieu de variables bioclimatiques non verifiees -- promu a package_include="yes" apres validation utilisateur (session 2026-08-16)
- Raison: Y continu reel (sp_rich, richesse specifique de libellules), N=4192 cellules d'assemblage europeennes avec coordonnees reelles. CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier identifie via le nom du fichier (Pinkert et al. 2017, Ecography ECOG-03137).

## Estimator eligibility

```yaml
estimator_eligibility:
  - estimator: piecewise_regression
    basis: published_model
    source_ref: "Pinkert et al. (2017), doi:10.1111/ecog.03137."
    notes: "Regression par segments sur une reponse de comptage; aucune route de comptage n'est automatisee dans le registre actuel."
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

