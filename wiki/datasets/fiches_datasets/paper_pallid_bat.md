---
title: paper_pallid_bat
type: dataset
created: 2026-08-10
updated: 2026-08-10
sources:
  - data/final_datasets/sf/paper_pallid_bat.rds
  - DataCite_2018_PrimaryProductivityExplainsSize_10_1111_1365_243
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Primary productivity explains size variation across the Pallid bat's western geographic range" (DOI 10.1111/1365-2435.13092).

## Description du jeu de donnees

- Topic: morphometrie et biogeographie animale
- Observation unit: specimen museal individuel
- Observed population: specimens de musee d'histoire naturelle geo-references via GBIF
- Geographic context: a preciser depuis l'etendue spatiale (voir Bloc 5)
- Temporal context: none (cross-sectional)
- Source description: Primary productivity explains size variation across the Pallid bat's western geographic range
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/1365-2435.13092
- Dataset DOI: 10.5061/dryad.c5805
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.c5805
- Local raw dir: `data/raw/papers/DataCite_2018_PrimaryProductivityExplainsSize_10_1111_1365_243/`
- Local sf output: `data/final_datasets/sf/paper_pallid_bat.rds`

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `centroid_size`
- Candidate Y typology: continuous
- Candidate X variables: no additional covariates beyond coordinates/identifiers (raster or grid dataset)
- Candidate X count: 0
- Candidate X typology: unknown
- Coordinates (x, y — excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): `institution`, `catalog_number`
- Variables inspected: yes (auto — generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `centroid_size` | `numeric` | continuous | [902.6937, 1171.3787] | 0% |

> Selection Y/X (paper-loader/curated evidence) : Pour `pallid_bat`, la ou les reponses `centroid_size` viennent du loader papier et/ou des preuves de l article `Primary productivity explains size variation across the Pallid bat's western geographic range`. Les covariables X retenues sont aucune covariable explicative. Les coordonnees (`lon`, `lat`), identifiants (`institution`, `catalog_number`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : needs_covariate_join ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| -- | -- | aucun candidat | -- |

### Formule — niveau publication

- formula_pub: body_size ~ net_primary_productivity + heat_conservation (temperature) [spatial autoregressive model, SAR]
- x_terms_pub: pending
- y_term_pub: centroid_size
- Reference publication: Kelly, Friedman & Santana (2018), Functional Ecology — test de la regle de Bergmann chez Antrozous pallidus via modele autoregressif spatial (SAR) ; la productivite primaire nette explique la variation de taille corporelle mieux que la conservation de chaleur ou la saisonnalite. Note : notre variable 'centroid_size' (derivee des landmarks TPS 2D) est un proxy geometrique-morphometrique, pas la mesure de taille exacte utilisee par les auteurs.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-10). Kelly, Friedman & Santana (2018), Functional Ecology — test de la regle de Bergmann chez Antrozous pallidus via modele autoregressif spatial (SAR) ; la productivite primaire nette explique la variation de taille corporelle mieux que la conservation de chaleur ou la saisonnalite. Note : notre variable 'centroid_size' (derivee des landmarks TPS 2D) est un proxy geometrique-morphometrique, pas la mesure de taille exacte utilisee par les auteurs.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: centroid_size
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-10). Kelly, Friedman & Santana (2018), Functional Ecology — test de la regle de Bergmann chez Antrozous pallidus via modele autoregressif spatial (SAR) ; la productivite primaire nette explique la variation de taille corporelle mieux que la conservation de chaleur ou la saisonnalite. Note : notre variable 'centroid_size' (derivee des landmarks TPS 2D) est un proxy geometrique-morphometrique, pas la mesure de taille exacte utilisee par les auteurs.

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

- Dataset ID: `paper_pallid_bat`
- Dataset name: Data from: Primary productivity explains size variation across the Pallid bat's (Antrozous pallidus) western geographic range
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Primary productivity explains size variation across the Pallid bat's western geographic range
- Paper DOI: 10.1111/1365-2435.13092
- Dataset DOI: 10.5061/dryad.c5805
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.c5805
- Year: unknown

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "body_size ~ net_primary_productivity + heat_conservation (temperature) [spatial autoregressive model, SAR]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Kelly, Friedman & Santana (2018), Functional Ecology — test de la regle de Bergmann chez Antrozous pallidus via modele autoregressif spatial (SAR) ; la productivite primaire nette explique la variation de taille corporelle mieux que la conservation de chaleur ou la saisonnalite. Note : notre variable 'centroid_size' (derivee des landmarks TPS 2D) est un proxy geometrique-morphometrique, pas la mesure de taille exacte utilisee par les auteurs."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "needs_covariate_join"
  benchmark_task: "regression_spatial_sar"
  package_include: "no"
  has_local_rds: true
  missing_items: "joindre NPP et variables climatiques mentionnees dans le papier"
  reason: "La formule SAR est confirmee, mais les covariables principales du papier ne sont pas dans l'extraction actuelle."
```

- Decision: needs_covariate_join
- Manque principal: joindre NPP et variables climatiques mentionnees dans le papier
- Raison: La formule SAR est confirmee, mais les covariables principales du papier ne sont pas dans l'extraction actuelle.

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 182
- k variables: 7
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 — Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-124.2623, -109.618423], y [23.5525, 48.052082]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32611 (UTM Zone 11N (EPSG:32611)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`pallid_bat` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `pallid_bat` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: WARN - Y identifiee, mais aucune covariable X detectee (grille/raster sans covariable additionnelle).
- Formula: OK - formule publication renseignee (verifiee par lecture directe du papier).
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`pallid_bat` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Primary productivity explains size variation across the Pallid bat's western geographic range

