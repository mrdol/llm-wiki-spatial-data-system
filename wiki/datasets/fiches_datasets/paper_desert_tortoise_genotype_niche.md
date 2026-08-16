---
title: paper_desert_tortoise_genotype_niche
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_desert_tortoise_genotype_niche.rds
  - DataCite_2019_LocalNicheDifferencesPredict_10_1111_ddi_1292
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Local niche differences predict genotype associations in sister taxa of desert tortoise" (DOI 10.1111/ddi.12927).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale du dataset "Local ecological niche models, genotype associations and environmental data for desert tortoises."
- Observed population: ModÃ¨les de niche Ã©cologique locale avec multiscale geographically weighted regression (MGWR) pour tortues du dÃ©sert
- Geographic context: etendue sf: x [-1814729.18202096, -1462765.51510254], y [1243443.86900469, 1619405.05866755]
- Temporal context: none (cross-sectional)
- Source description: Local niche differences predict genotype associations in sister taxa of desert tortoise
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/ddi.12927
- Dataset DOI: 10.5066/p91v2s8c
- Source URL: https://www.sciencebase.gov/catalog/item/5cb0e0e5e4b0c3b0065741e7
- Local raw dir: `data/raw/papers/DataCite_2019_LocalNicheDifferencesPredict_10_1111_ddi_1292/`
- Local sf output: `data/final_datasets/sf/paper_desert_tortoise_genotype_niche.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `GenAssociation`
- Candidate Y typology: rate
- Candidate X variables in local artifact: `CLIM1`, `CLIM3`, `LC`, `PHYS1`, `PHYS2`, `SOIL2`, `SOIL3`, `VEG1`, `VEG3`
- Candidate X count in local artifact: 9
- Candidate X typology: continuous
- Published X variables from paper: CLIM1, CLIM3, LC, PHYS1, PHYS2, SOIL2, SOIL3, VEG1, VEG3
- Published X count: 9
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `GenAssociation` | `numeric` | rate | [0.0025, 0.9977] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `desert_tortoise_genotype_niche`, la ou les reponses `GenAssociation` viennent du loader papier et/ou des preuves de l article `Local niche differences predict genotype associations in sister taxa of desert tortoise`. Les covariables X retenues sont `CLIM1`, `CLIM3`, `LC`, `PHYS1`, `PHYS2`, `SOIL2`, `SOIL3`, `VEG1`, `VEG3`. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : not_ready_derived_response ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `CLIM1` | `numeric` | continuous | 0% |
| `CLIM3` | `numeric` | rate | 0% |
| `LC` | `numeric` | continuous | 0% |
| `PHYS1` | `numeric` | continuous | 0% |
| `PHYS2` | `numeric` | continuous | 0% |
| `SOIL2` | `numeric` | continuous | 0% |
| `SOIL3` | `numeric` | continuous | 0% |
| `VEG1` | `numeric` | continuous | 0% |
| `VEG3` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: GenAssociation ~ CLIM1 + CLIM3 + LC + PHYS1 + PHYS2 + SOIL2 + SOIL3 + VEG1 + VEG3 [surface de sortie du modele de niche local original, pas une regression brute]
- x_terms_pub: CLIM1, CLIM3, LC, PHYS1, PHYS2, SOIL2, SOIL3, VEG1, VEG3
- y_term_pub: association genotype-habitat (surface derivee du modele de niche local)
- Reference publication: Inman, Fotheringham, Franklin, Esque, Edwards & Nussear (2019), Diversity and Distributions, DOI 10.1111/ddi.12927; le depot Dryad (10.5066/p91v2s8c) ne contient que des rasters .asc deja modelises (co-enregistres, meme grille), pas de points d'echantillon genotype bruts. GenAssociation est une sortie du modele de niche local original, pas une observation empirique -- meme categorie de prudence que beta0_gwr dans ce fichier.

### Statut regression canonique

- Statut: resolu_publication_non_executable
- Niveau de preuve: publication
- Methode d estimation: modele/formule publication confirme, non executable avec le .rds actuel
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Inman, Fotheringham, Franklin, Esque, Edwards & Nussear (2019), Diversity and Distributions, DOI 10.1111/ddi.12927; le depot Dryad (10.5066/p91v2s8c) ne contient que des rasters .asc deja modelises (co-enregistres, meme grille), pas de points d'echantillon genotype bruts. GenAssociation est une sortie du modele de niche local original, pas une observation empirique -- meme categorie de prudence que beta0_gwr dans ce fichier.

### Formule - niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Inman, Fotheringham, Franklin, Esque, Edwards & Nussear (2019), Diversity and Distributions, DOI 10.1111/ddi.12927; le depot Dryad (10.5066/p91v2s8c) ne contient que des rasters .asc deja modelises (co-enregistres, meme grille), pas de points d'echantillon genotype bruts. GenAssociation est une sortie du modele de niche local original, pas une observation empirique -- meme categorie de prudence que beta0_gwr dans ce fichier.

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

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_desert_tortoise_genotype_niche`
- Dataset name: Local ecological niche models, genotype associations and environmental data for desert tortoises.
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Local niche differences predict genotype associations in sister taxa of desert tortoise
- Paper DOI: 10.1111/ddi.12927
- Dataset DOI: 10.5066/p91v2s8c
- Source URL: https://www.sciencebase.gov/catalog/item/5cb0e0e5e4b0c3b0065741e7
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "GenAssociation ~ CLIM1 + CLIM3 + LC + PHYS1 + PHYS2 + SOIL2 + SOIL3 + VEG1 + VEG3 [surface de sortie du modele de niche local original, pas une regression brute]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Inman, Fotheringham, Franklin, Esque, Edwards & Nussear (2019), Diversity and Distributions, DOI 10.1111/ddi.12927; le depot Dryad (10.5066/p91v2s8c) ne contient que des rasters .asc deja modelises (co-enregistres, meme grille), pas de points d'echantillon genotype bruts. GenAssociation est une sortie du modele de niche local original, pas une observation empirique -- meme categorie de prudence que beta0_gwr dans ce fichier."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_derived_response"
  benchmark_task: "derived_model_output"
  package_include: "no"
  has_local_rds: true
  missing_items: "retrouver les points d'echantillonnage genotype bruts (non fournis dans le depot Dryad, uniquement des surfaces .asc deja modelisees)"
  reason: "GenAssociation est une sortie du modele de niche local original (surface interpolee), pas des observations genotype-habitat brutes -- meme categorie que beta0_gwr dans ce fichier."
```

- Decision: not_ready_derived_response
- Manque principal: retrouver les points d'echantillonnage genotype bruts (non fournis dans le depot Dryad, uniquement des surfaces .asc deja modelisees)
- Raison: GenAssociation est une sortie du modele de niche local original (surface interpolee), pas des observations genotype-habitat brutes -- meme categorie que beta0_gwr dans ce fichier.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "not_ready_derived_response"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "current package supports continuous spatial regression benchmarks; this fiche is not currently an executable continuous-regression dataset"
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 1147
- k variables: 12
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: unknown
- CRS nom: Albers_Equal_Area
- Spatial extent: x [-1814729.18202096, -1462765.51510254], y [1243443.86900469, 1619405.05866755]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`desert_tortoise_genotype_niche` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `desert_tortoise_genotype_niche` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - preuve de modele/formule publication renseignee ; formula_used reste pending car le .rds local ne contient pas le tableau Y/X requis.
- CRS: WARN - CRS absent du sf source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`desert_tortoise_genotype_niche` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Local niche differences predict genotype associations in sister taxa of desert tortoise

