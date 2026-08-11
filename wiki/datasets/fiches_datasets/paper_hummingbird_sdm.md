---
title: paper_hummingbird_sdm
type: dataset
created: 2026-08-10
updated: 2026-08-10
sources:
  - data/final_datasets/sf/paper_hummingbird_sdm.rds
  - DataCite_2023_IntegratedSpeciesDistributionModels_10_1111_geb_1379
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Integrated species distribution models to account for sampling biases and improve range-wide occurrence predictions" (DOI 10.1111/geb.13792).

## Description du jeu de donnees

- Topic: ecologie / interactions plantes-pollinisateurs
- Observation unit: site d'observation ou cellule de grille d'occurrence
- Observed population: communautes de pollinisateurs ou d'oiseaux nectarivores
- Geographic context: a preciser depuis l'etendue spatiale (voir Bloc 5)
- Temporal context: none (cross-sectional)
- Source description: Integrated species distribution models to account for sampling biases and improve range-wide occurrence predictions
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/geb.13792
- Dataset DOI: 10.5061/dryad.k98sf7mdg
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.k98sf7mdg
- Local raw dir: `data/raw/papers/DataCite_2023_IntegratedSpeciesDistributionModels_10_1111_geb_1379/`
- Local sf output: `data/final_datasets/sf/paper_hummingbird_sdm.rds`

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `species_richness`, `n_occurrences`
- Candidate Y typology: count
- Candidate X variables: no additional covariates beyond coordinates/identifiers (raster or grid dataset)
- Candidate X count: 0
- Candidate X typology: unknown
- Coordinates (x, y — excluded from X candidates): `cell_lon`, `cell_lat`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `species_richness` | `integer` | count | [1, 50] | 0% |
| `n_occurrences` | `integer` | count | [1, 739] | 0% |

> Selection Y/X (paper-loader/curated evidence) : Pour `hummingbird_sdm`, la ou les reponses `species_richness`, `n_occurrences` viennent du loader papier et/ou des preuves de l article `Integrated species distribution models to account for sampling biases and improve range-wide occurrence predictions`. Les covariables X retenues sont aucune covariable explicative. Les coordonnees (`cell_lon`, `cell_lat`), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : not_ready_current_package ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| -- | -- | aucun candidat | -- |

### Formule — niveau publication

- formula_pub: log(lambda_PO) = alpha_PO + beta*x + g(s) ; logit(lambda_PA) = alpha_PA + beta*x + g(s) [modele integre PO+PA, effet spatial latent partage g(s)]
- x_terms_pub: pending
- y_term_pub: species_richness
- Reference publication: Makinen, Merow & Jetz (2023), Global Ecology and Biogeography, Table 1 — SDM integre combinant donnees presence-seule (GBIF) et presence-absence (checklists Andes du Nord) pour 71 especes de colibris, via un processus de Poisson log-lineaire (PO) et un modele Bernoulli (PA) partageant un effet spatial latent g(s).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-10). Makinen, Merow & Jetz (2023), Global Ecology and Biogeography, Table 1 — SDM integre combinant donnees presence-seule (GBIF) et presence-absence (checklists Andes du Nord) pour 71 especes de colibris, via un processus de Poisson log-lineaire (PO) et un modele Bernoulli (PA) partageant un effet spatial latent g(s).

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: species_richness
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-10). Makinen, Merow & Jetz (2023), Global Ecology and Biogeography, Table 1 — SDM integre combinant donnees presence-seule (GBIF) et presence-absence (checklists Andes du Nord) pour 71 especes de colibris, via un processus de Poisson log-lineaire (PO) et un modele Bernoulli (PA) partageant un effet spatial latent g(s).

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
    formula: "pending"
    response: "pending"
    predictors: []
    role: "ml_candidate_features"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `paper_hummingbird_sdm`
- Dataset name: Data from: Integrated species distribution models to account for sampling biases and improve range wide occurrence predictions
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Integrated species distribution models to account for sampling biases and improve range-wide occurrence predictions
- Paper DOI: 10.1111/geb.13792
- Dataset DOI: 10.5061/dryad.k98sf7mdg
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.k98sf7mdg
- Year: unknown

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "log(lambda_PO) = alpha_PO + beta*x + g(s) ; logit(lambda_PA) = alpha_PA + beta*x + g(s) [modele integre PO+PA, effet spatial latent partage g(s)]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Makinen, Merow & Jetz (2023), Global Ecology and Biogeography, Table 1 — SDM integre combinant donnees presence-seule (GBIF) et presence-absence (checklists Andes du Nord) pour 71 especes de colibris, via un processus de Poisson log-lineaire (PO) et un modele Bernoulli (PA) partageant un effet spatial latent g(s)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_current_package"
  benchmark_task: "species_distribution_model"
  package_include: "no"
  has_local_rds: true
  missing_items: "route SDM presence-only/presence-absence et covariables environnementales completes"
  reason: "Le modele du papier est un SDM integre, pas une regression continue standard."
```

- Decision: not_ready_current_package
- Manque principal: route SDM presence-only/presence-absence et covariables environnementales completes
- Raison: Le modele du papier est un SDM integre, pas une regression continue standard.

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 275
- k variables: 6
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 — Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-89.5, -34.5], y [-39.5, 14.5]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending — multi-zones (span=55deg) -- projection nationale recommandee

## Bloc 6 — Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`hummingbird_sdm` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `hummingbird_sdm` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: WARN - Y identifiee, mais aucune covariable X detectee (grille/raster sans covariable additionnelle).
- Formula: OK - formule publication renseignee (verifiee par lecture directe du papier).
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`hummingbird_sdm` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Integrated species distribution models to account for sampling biases and improve range-wide occurrence predictions

