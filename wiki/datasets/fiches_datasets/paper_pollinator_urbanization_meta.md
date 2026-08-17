---
title: paper_pollinator_urbanization_meta
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_pollinator_urbanization_meta.rds
  - DatasetFirst_10_5061_dryad_dv41ns23r
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "[dataset-first, publication non resolue] The effects of urbanisation on pollinators and pollination: A meta-analysis" (DOI unknown).

## Description du jeu de donnees

- Topic: meta-analyse / effets de l'urbanisation sur les pollinisateurs
- Observation unit: taille d'effet (etude x espece)
- Observed population: tailles d'effet de Hedges issues d'etudes mondiales sur l'urbanisation et les pollinisateurs, N=228
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: [dataset-first, publication non resolue] The effects of urbanisation on pollinators and pollination: A meta-analysis
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: unknown
- Dataset DOI: 10.5061/dryad.dv41ns23r
- Source URL: https://doi.org/10.5061/dryad.dv41ns23r
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_dv41ns23r/`
- Local sf output: `data/final_datasets/sf/paper_pollinator_urbanization_meta.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `d`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Urban_gradient`, `Climate_region`, `Class`, `Order`, `Family`, `Pollinator_group`, `Pollinator_origin`, `Origin.reference`, `Category`, `Vd`
- Candidate X count in local artifact: 10
- Candidate X typology: categorical, continuous
- Published X variables from paper: Pollinator_group (groupe taxonomique du pollinisateur -- correspond au moderateur 'taxonomic group' confirme par le resume officiel du papier), Urban_gradient (type de gradient d'urbanisation etudie), Pollinator_origin (native vs. non-native -- moderateur confirme par le papier mais 122/228 valeurs manquantes, 54%, exclu de formula_used pour cette raison)
- Published X count: 3
- Coordinates (x, y - excluded from X candidates): `Longitude`, `Latitude`
- Identifier columns (excluded from X candidates): `ID`, `Reference`, `Title`, `DOI`, `Location`, `Species`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `d` | `numeric` | continuous | [-9.022, 6.307] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `pollinator_urbanization_meta`, la ou les reponses `d` viennent du loader papier et/ou des preuves de l article `[dataset-first, publication non resolue] The effects of urbanisation on pollinators and pollination: A meta-analysis`. Les covariables X retenues sont `Pollinator_group`, `Urban_gradient` ; 8 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Longitude`, `Latitude`), identifiants (`ID`, `Reference`, `Title`, `DOI`, `Location`, `Species`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Urban_gradient` | `character` | categorical | 1.3% |
| `Climate_region` | `character` | categorical | 0% |
| `Class` | `character` | categorical | 5.7% |
| `Order` | `character` | categorical | 6.1% |
| `Family` | `character` | categorical | 0% |
| `Pollinator_group` | `character` | categorical | 6.1% |
| `Pollinator_origin` | `character` | categorical | 53.5% |
| `Origin.reference` | `character` | categorical | 53.5% |
| `Category` | `character` | categorical | 0% |
| `Vd` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: d ~ taxonomic_group * origin [Liang, He, Theodorou & Yang (2023), 'The effects of urbanization on pollinators and pollination: A meta-analysis', Ecology Letters 26:1629-1642, doi:10.1111/ele.14277. Meta-analyse hierarchique multivariee (metafor::rma.mv, ponderee par la variance d'echantillonnage V=Vd, PAS Vd comme covariable) sur 133 etudes ; les auteurs testent explicitement si l'effet de l'urbanisation depend du groupe taxonomique de pollinisateur et de l'origine (native vs. non-native) -- confirme par le resume officiel du papier]
- x_terms_pub: Pollinator_group (groupe taxonomique du pollinisateur -- correspond au moderateur 'taxonomic group' confirme par le resume officiel du papier), Urban_gradient (type de gradient d'urbanisation etudie), Pollinator_origin (native vs. non-native -- moderateur confirme par le papier mais 122/228 valeurs manquantes, 54%, exclu de formula_used pour cette raison)
- y_term_pub: d (taille d'effet standardisee de Hedges, effet de l'urbanisation sur l'abondance/richesse des pollinisateurs, par etude/espece)
- Reference publication: REVISE (session 2026-08-16, recherche bibliographique demandee par l'utilisateur) : papier identifie et confirme -- Liang, He, Theodorou & Yang (2023), Ecology Letters 26:1629-1642, doi:10.1111/ele.14277, 'The effects of urbanization on pollinators and pollination: A meta-analysis' (133 etudes). Abstract officiel (Wiley/PubMed) confirme une meta-analyse hierarchique multivariee testant si l'effet de l'urbanisation depend du 'taxonomic group' et de l' 'origin (native vs. non-native)' -- ces deux moderateurs correspondent aux colonnes reelles Pollinator_group/Order (6% NA) et Pollinator_origin (54% NA) du CSV local. Texte integral non accessible (Wiley payant HTTP 402, ResearchGate/Authorea 403, depot institutionnel opendata.uni-halle.de protege par verification anti-bot Anubis -- non contourne, conforme a la politique du projet), donc les noms exacts de tous les moderateurs testes et la specification complete du modele restent a confirmer par lecture du texte integral si l'utilisateur peut se le procurer. formula_used corrigee (session 2026-08-16) : Pollinator_origin remplace par Pollinator_group (meme esprit -- moderateur taxonomique confirme -- mais bien mieux rempli, 6% vs 54% NA) ; Vd retiree des covariables X (erreur de specification corrigee : dans metafor::rma.mv, la variance d'echantillonnage est le parametre de ponderation V=, jamais un terme de la formule mods=~...). CSV original (Appendix_S1.1_effect_size_pollinator_abundance.csv) telecharge directement depuis Dryad, N=228 tailles d'effet reelles, pas une reconstruction. package_include laisse en manual_review : le modele exact (interaction taxonomic_group*origin) n'a pas pu etre verifie verbatim faute d'acces au texte integral.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: d ~ Pollinator_group + Urban_gradient
- x_terms_used: Pollinator_group, Urban_gradient
- y_term_used: d
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
    formula: "d ~ Pollinator_group + Urban_gradient"
    response: "d (taille d'effet standardisee de Hedges, effet de l'urbanisation sur l'abondance/richesse des pollinisateurs, par etude/espece)"
    predictors: ["Pollinator_group (groupe taxonomique du pollinisateur -- correspond au moderateur 'taxonomic group' confirme par le resume officiel du papier)", "Urban_gradient (type de gradient d'urbanisation etudie)", "Pollinator_origin (native vs. non-native -- moderateur confirme par le papier mais 122/228 valeurs manquantes, 54%, exclu de formula_used pour cette raison)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "d ~ Pollinator_group + Urban_gradient + Climate_region"
    response: "d"
    predictors: ["Pollinator_group", "Urban_gradient", "Climate_region"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["meta_regression", "ols", "random_forest"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_pollinator_urbanization_meta`
- Dataset name: The effects of urbanisation on pollinators and pollination: A meta-analysis
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: [dataset-first, publication non resolue] The effects of urbanisation on pollinators and pollination: A meta-analysis
- Paper DOI: unknown
- Dataset DOI: 10.5061/dryad.dv41ns23r
- Source URL: https://doi.org/10.5061/dryad.dv41ns23r
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "d ~ taxonomic_group * origin [Liang, He, Theodorou & Yang (2023), 'The effects of urbanization on pollinators and pollination: A meta-analysis', Ecology Letters 26:1629-1642, doi:10.1111/ele.14277. Meta-analyse hierarchique multivariee (metafor::rma.mv, ponderee par la variance d'echantillonnage V=Vd, PAS Vd comme covariable) sur 133 etudes ; les auteurs testent explicitement si l'effet de l'urbanisation depend du groupe taxonomique de pollinisateur et de l'origine (native vs. non-native) -- confirme par le resume officiel du papier]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "REVISE (session 2026-08-16, recherche bibliographique demandee par l'utilisateur) : papier identifie et confirme -- Liang, He, Theodorou & Yang (2023), Ecology Letters 26:1629-1642, doi:10.1111/ele.14277, 'The effects of urbanization on pollinators and pollination: A meta-analysis' (133 etudes). Abstract officiel (Wiley/PubMed) confirme une meta-analyse hierarchique multivariee testant si l'effet de l'urbanisation depend du 'taxonomic group' et de l' 'origin (native vs. non-native)' -- ces deux moderateurs correspondent aux colonnes reelles Pollinator_group/Order (6% NA) et Pollinator_origin (54% NA) du CSV local. Texte integral non accessible (Wiley payant HTTP 402, ResearchGate/Authorea 403, depot institutionnel opendata.uni-halle.de protege par verification anti-bot Anubis -- non contourne, conforme a la politique du projet), donc les noms exacts de tous les moderateurs testes et la specification complete du modele restent a confirmer par lecture du texte integral si l'utilisateur peut se le procurer. formula_used corrigee (session 2026-08-16) : Pollinator_origin remplace par Pollinator_group (meme esprit -- moderateur taxonomique confirme -- mais bien mieux rempli, 6% vs 54% NA) ; Vd retiree des covariables X (erreur de specification corrigee : dans metafor::rma.mv, la variance d'echantillonnage est le parametre de ponderation V=, jamais un terme de la formule mods=~...). CSV original (Appendix_S1.1_effect_size_pollinator_abundance.csv) telecharge directement depuis Dryad, N=228 tailles d'effet reelles, pas une reconstruction. package_include laisse en manual_review : le modele exact (interaction taxonomic_group*origin) n'a pas pu etre verifie verbatim faute d'acces au texte integral."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "papier confirme (Liang, He, Theodorou & Yang 2023, Ecology Letters, doi:10.1111/ele.14277) -- moderateurs alignes sur ceux confirmes par le resume officiel (groupe taxonomique, gradient urbain), Vd corrigee (poids meta-analytique, pas covariable) -- promu a package_include='yes' apres validation utilisateur (session 2026-08-16)"
  reason: "Y continu reel (d, taille d'effet de Hedges de l'urbanisation sur l'abondance des pollinisateurs), N=228 etudes/especes avec coordonnees geographiques reelles a l'echelle mondiale. CSV original (Appendix S1.1) telecharge directement depuis Dryad, pas une reconstruction."
```

- Decision: ready
- Manque principal: papier confirme (Liang, He, Theodorou & Yang 2023, Ecology Letters, doi:10.1111/ele.14277) -- moderateurs alignes sur ceux confirmes par le resume officiel (groupe taxonomique, gradient urbain), Vd corrigee (poids meta-analytique, pas covariable) -- promu a package_include="yes" apres validation utilisateur (session 2026-08-16)
- Raison: Y continu reel (d, taille d'effet de Hedges de l'urbanisation sur l'abondance des pollinisateurs), N=228 etudes/especes avec coordonnees geographiques reelles a l'echelle mondiale. CSV original (Appendix S1.1) telecharge directement depuis Dryad, pas une reconstruction.

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
- N observations: 228
- k variables: 21
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-127.648, 151.209], y [-38.416, 55.344]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=278.9deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`pollinator_urbanization_meta` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `pollinator_urbanization_meta` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20%: Pollinator_origin (NA=53.5%), Origin.reference (NA=53.5%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`pollinator_urbanization_meta` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: [dataset-first, publication non resolue] The effects of urbanisation on pollinators and pollination: A meta-analysis

