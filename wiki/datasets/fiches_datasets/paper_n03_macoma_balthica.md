---
title: paper_n03_macoma_balthica
type: dataset
created: 2026-09-24
updated: 2026-09-23
sources:
  - data/final_datasets/sf/paper_n03_macoma_balthica.rds
  - N03_PICAR_Z
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "A class of models for large zero-inflated spatial data" (DOI 10.1007/s13253-024-00619-9).

## Description du jeu de donnees

- Topic: Marine ecology
- Observation unit: observation spatiale du dataset "Macoma balthica abundance, Dutch Wadden Sea tidal flats"
- Observed population: 4026 point locations on Dutch Wadden Sea tidal flats, Macoma balthica bivalve counts (66 percent zeros)
- Geographic context: 4026 point locations, Dutch Wadden Sea tidal flats. Two independent spatial random fields (occurrence and prevalence), each represented via a PICAR (Moran's I + piecewise-linear) reduced-rank basis on a triangular mesh -- not a simple centroid-based kNN/distance W.
- Temporal context: none (cross-sectional)
- Source description: A class of models for large zero-inflated spatial data
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: high
- Paper DOI: 10.1007/s13253-024-00619-9
- Dataset DOI: none
- Source URL: https://github.com/benee55/PICAR_Z_Code
- Local raw dir: `data/raw/papers/N03_PICAR_Z/`
- Local sf output: `data/final_datasets/sf/paper_n03_macoma_balthica.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `macoma`
- Candidate Y typology: unknown
- Candidate X variables in local artifact: `grid`, `mgs`, `silt`, `depth`
- Candidate X count in local artifact: 4
- Candidate X typology: categorical, continuous
- Published X variables from paper: mgs, silt, depth
- Published X count: 3
- Coordinates (x, y - excluded from X candidates): `x`, `y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `macoma` | `integer` | unknown | [0, 84] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `n03_macoma_balthica`, la ou les reponses `macoma` viennent du loader papier et/ou des preuves de l article `A class of models for large zero-inflated spatial data`. Les covariables X retenues sont `mgs`, `silt`, `depth` ; 1 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`x`, `y`), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : needs_manual_review ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `grid` | `character` | categorical | 0% |
| `mgs` | `numeric` | continuous | 0% |
| `silt` | `numeric` | continuous | 0% |
| `depth` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: Occurrence: logit(pi(s)) = X(s) beta_o + W_o(s) + epsilon_o(s); prevalence conditionnelle: log(theta(s)) = X(s) beta_p + W_p(s) + epsilon_p(s), Poisson tronque en zero; X = mgs + silt + depth
- x_terms_pub: mgs, silt, depth
- y_term_pub: macoma, decompose en occurrence (macoma > 0) et abondance positive conditionnelle
- Reference publication: Lee, B.S. & Haran, M. (2024), A class of models for large zero-inflated spatial data, Journal of Agricultural, Biological and Environmental Statistics, doi:10.1007/s13253-024-00619-9 (texte integral lu, DOI et auteurs confirmes dans l'en-tete TEI, ORCID Ben Seiyon Lee 0000-0003-0658-7458). Le papier propose PICAR-Z, un modele spatial en DEUX PARTIES (hurdle) avec DEUX champs spatiaux latents independants : occurrence O(s) (Bernoulli, lien logit) et prevalence P(s) (Poisson tronque-zero, lien log, pour la variante 'count hurdle' retenue pour cette application -- comparee au modele mixture Poisson zero-inflated, comparable mais plus lent, TEI Section 6.1). Chaque champ est reduit via une base PICAR (statistique de Moran + fonctions de base lineaires par morceaux sur un maillage triangulaire de 4028 sommets). AUCUN des deux (structure hurdle a deux equations, base PICAR) n'est implemente dans spatialtidymodels -- la route la plus proche, inla_spde, est un champ SPDE a un seul processus, architecture differente. Covariables : mgs (granulometrie mediane), silt (teneur en limon), 'altitude' (nom du papier pour la colonne `depth` du CSV -- meme grandeur, pas une contradiction). N=4026 (3220 ajustement + 806 validation) correspond exactement au CSV depose -- un chiffre 'n=4029' apparaissant ailleurs dans le TEI est une citation d'un AUTRE papier (Lyashevska et al. 2016) en introduction, pas la taille de ce jeu de donnees (ecart initialement signale dans le TSV, resolu par la lecture integrale). Depot officiel des auteurs (github.com/benee55/PICAR_Z_Code, samples/datsc.csv) -- pas une reconstruction. CRS non declare dans le papier ; x/y (115522-260305 / 545432-617087) correspondent a l'emprise de la grille neerlandaise RD New/Amersfoort (EPSG:28992) pour la region du Wadden Sea avec une confiance elevee, mais reste une INFERENCE, pas un CRS declare par les auteurs.

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d estimation: formule systeme generee (formula_pub confirmee mais non reprise telle quelle -- voir Note ci-dessous)
- Correspondance Python/R: aucune identifiee
- Note: `grid` est un identifiant de cellule et non une covariable publiee. La formule executable a une seule reponse est une simplification tabulaire: elle ne reproduit ni la decomposition hurdle occurrence/prevalence, ni les deux champs spatiaux PICAR independants.

### Formule - niveau systeme

- formula_used: macoma ~ mgs + silt + depth
- x_terms_used: mgs, silt, depth
- y_term_used: macoma
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

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
    formula: "macoma ~ mgs + silt + depth"
    response: "macoma, decompose en occurrence (macoma > 0) et abondance positive conditionnelle"
    predictors: ["mgs", "silt", "depth"]
    role: "benchmark_simplified_specification"
    source_type: "derived_from_scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
    status: "executable_approximation"

  ml_or_selected:
    formula: "macoma ~ mgs + silt + depth"
    response: "macoma"
    predictors: ["mgs", "silt", "depth"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["picar_z_hurdle", "zero_truncated_poisson"]
    status: "manual_review_two_part_model_unimplemented"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_n03_macoma_balthica`
- Dataset name: Macoma balthica abundance, Dutch Wadden Sea tidal flats
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: A class of models for large zero-inflated spatial data
- Paper DOI: 10.1007/s13253-024-00619-9
- Dataset DOI: none
- Source URL: https://github.com/benee55/PICAR_Z_Code
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Occurrence: logit(pi(s)) = X(s) beta_o + W_o(s) + epsilon_o(s); prevalence conditionnelle: log(theta(s)) = X(s) beta_p + W_p(s) + epsilon_p(s), Poisson tronque en zero; X = mgs + silt + depth"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Lee & Haran (2024), A class of models for large zero-inflated spatial data, DOI 10.1007/s13253-024-00619-9; application Macoma du depot officiel PICAR_Z_Code, samples/datsc.csv."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "needs_manual_review"
  benchmark_task: "unknown"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "statut benchmark non encore curate"
  reason: "Aucune decision explicite encodee pour n03_macoma_balthica."
```

- Decision: needs_manual_review
- Manque principal: statut benchmark non encore curate
- Raison: Aucune decision explicite encodee pour n03_macoma_balthica.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "needs_manual_review"
  eligible_estimators: []
  conditionally_eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy"]
  ineligible_reason: "manual review required before package promotion"
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 4026
- k variables: 9
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 28992
- CRS nom: Amersfoort / RD New
- Spatial extent: x [115522.938443788, 260304.699243184], y [545432.724340422, 617086.775617369]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`n03_macoma_balthica` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `n03_macoma_balthica` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formula_pub confirmee et verifiee (voir Reference publication) ; formula_used est une approximation generee distincte, explicitement etiquetee comme telle (voir Bloc 1 > Statut regression canonique > Note).
- CRS: OK - CRS renseigne dans le Bloc 5 (28992).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`n03_macoma_balthica` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: A class of models for large zero-inflated spatial data
