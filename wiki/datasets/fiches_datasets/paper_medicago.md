---
title: paper_medicago
type: dataset
created: 2026-09-14
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_medicago.rds
  - DataCite_2022_NicheConservatismLimitsThe_10_1111_ecog_060
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Niche conservatism limits the distribution of Medicago in the tropics" (DOI 10.1111/ecog.06085).

## Description du jeu de donnees

- Topic: biogeographie vegetale / gradients de richesse
- Observation unit: cellule de grille (100x100 km)
- Observed population: especes du genre Medicago
- Geographic context: etendue sf: x [-155.6728855, 177.8818578], y [-54.5346168, 70.8729427]
- Temporal context: none (cross-sectional)
- Source description: Niche conservatism limits the distribution of Medicago in the tropics
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/ecog.06085
- Dataset DOI: 10.5061/dryad.280gb5mrw
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.280gb5mrw
- Local raw dir: `data/raw/papers/DataCite_2022_NicheConservatismLimitsThe_10_1111_ecog_060/`
- Local sf output: `data/final_datasets/sf/paper_medicago.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `richness`, `annual`, `perennial`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `MAT`, `MTCQ`, `PET`, `WI`, `Solar_rad`, `MI`, `MAP`, `PDQ`, `AET`, `WD`, `DRT`, `TSN`, `ART`, `PSN`, `MATR`, `MAPR`, `Ele_range`, `Ele_std`, `LGMmat_ano`, `LGMmap_ano`, `LGMmtcq_ano`, `MHmat_ano`, `MHmap_ano`, `MHmtcq_ano`
- Candidate X count in local artifact: 24
- Candidate X typology: continuous
- Published X variables from paper: MAT, MTCQ, PET, WI, Solar_rad, MI, MAP, PDQ, AET, WD, DRT, TSN, ART, PSN, MATR, MAPR, Ele_range, Ele_std, LGMmat_ano, LGMmap_ano, LGMmtcq_ano, MHmat_ano, MHmap_ano, MHmtcq_ano
- Published X count: 24
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `GRIDCODE`, `Continent`, `Biome`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `richness` | `numeric` | count | [1, 41] | 0% |
| `annual` | `numeric` | continuous | [0, 37] | 0% |
| `perennial` | `numeric` | continuous | [0, 12] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `medicago`, la ou les reponses `richness`, `annual`, `perennial` viennent du loader papier et/ou des preuves de l article `Niche conservatism limits the distribution of Medicago in the tropics`. Les covariables X retenues sont `MAT`, `MTCQ`, `PET`, `WI`, `Solar_rad` ; 19 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (`GRIDCODE`, `Continent`, `Biome`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : manual_review; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `MAT` | `numeric` | continuous | 0% |
| `MTCQ` | `numeric` | continuous | 0% |
| `PET` | `numeric` | continuous | 0% |
| `WI` | `numeric` | continuous | 0% |
| `Solar_rad` | `numeric` | continuous | 0% |
| `MI` | `numeric` | continuous | 0% |
| `MAP` | `numeric` | continuous | 0% |
| `PDQ` | `numeric` | continuous | 0% |
| `AET` | `numeric` | continuous | 0% |
| `WD` | `numeric` | continuous | 0% |
| `DRT` | `numeric` | continuous | 0% |
| `TSN` | `numeric` | continuous | 0% |
| `ART` | `numeric` | continuous | 0% |
| `PSN` | `numeric` | continuous | 0% |
| `MATR` | `numeric` | continuous | 0% |
| `MAPR` | `numeric` | continuous | 0% |
| `Ele_range` | `numeric` | continuous | 0% |
| `Ele_std` | `numeric` | continuous | 0% |
| `LGMmat_ano` | `numeric` | continuous | 0% |
| `LGMmap_ano` | `numeric` | continuous | 0% |
| `LGMmtcq_ano` | `numeric` | continuous | 0% |
| `MHmat_ano` | `numeric` | continuous | 0% |
| `MHmap_ano` | `numeric` | continuous | 0% |
| `MHmtcq_ano` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: richness ~ environmental_energy_PC1 [GWR, fixed kernel, AICc bandwidth] ; richness ~ each climatic variable / environmental-category PC1 [negative binomial GLM]
- x_terms_pub: MAT, MTCQ, PET, WI, Solar_rad, MI, MAP, PDQ, AET, WD, DRT, TSN, ART, PSN, MATR, MAPR, Ele_range, Ele_std, LGMmat_ano, LGMmap_ano, LGMmtcq_ano, MHmat_ano, MHmap_ano, MHmtcq_ano
- y_term_pub: species richness of Medicago on 100 x 100 km grid cells
- Reference publication: Yang, Bian, Ren, Liu & Shrestha (2022), Ecography e06085, Sections Environmental variables and Models/statistical analyses: the paper maps Medicago richness on 100 x 100 km grid cells, evaluates 24 environmental variables with negative-binomial GLMs and category PC1s, then uses GWR to explore the richness-environmental-energy relationship across latitude. formula_used keeps the documented environmental-energy group available in the local .rds (MAT, MTCQ, PET, WI, Solar_rad) as the canonical executable GWR/GLM benchmark formula.

### Statut regression canonique

- Statut: mis de cote
- Niveau de preuve: publication
- Methode d estimation: formule adaptee/reconstruite a partir des variables du depot -- ne reproduit PAS la methode exacte du papier (voir correction 2026-09-08)
- Correspondance Python/R: aucune identifiee
- Note: Correction (2026-09-08, lecture TEI approfondie) : confirme -- les GLM binomiaux-negatifs du papier sont univaries (une seule variable climatique a la fois : "we used univariate generalized linear models (GLMs) to evaluate the effects of each climatic variable"), et le GWR ne porte que sur un PC1 agrege ("environmental energy"), jamais sur les 5 variables brutes MAT+MTCQ+PET+WI+Solar_rad simultanement comme le fait formula_used. Le papier n'ajuste donc jamais ce modele multivarie precis. DECISION UTILISATEUR (2026-09-08) : mis de cote explicitement plutot que resolu -- necessite un pretraitement PCA et une orchestration multi-modeles univaries absents du pipeline actuel ; ne pas promouvoir package_include=yes avant cette extension.

### Formule - niveau systeme

- formula_used: richness ~ MAT + MTCQ + PET + WI + Solar_rad
- License evidence: DataCite API record for DOI 10.5061/dryad.280gb5mrw (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- benchmark_task_note: richesse specifique observee : denombrement, sans transformation continue imposee.
- Selected Y evidence: richesse specifique observee : denombrement, sans transformation continue imposee.
- Selected Y typology: count
- x_terms_used: MAT, MTCQ, PET, WI, Solar_rad
- y_term_used: richness
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
    formula: "richness ~ MAT + MTCQ + PET + WI + Solar_rad"
    response: "species richness of Medicago on 100 x 100 km grid cells"
    predictors: ["MAT", "MTCQ", "PET", "WI", "Solar_rad", "MI", "MAP", "PDQ", "AET", "WD", "DRT", "TSN", "ART", "PSN", "MATR", "MAPR", "Ele_range", "Ele_std", "LGMmat_ano", "LGMmap_ano", "LGMmtcq_ano", "MHmat_ano", "MHmap_ano", "MHmtcq_ano"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
    status: "confirmed"

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

- Dataset ID: `paper_medicago`
- Dataset name: Niche conservatism limits the distribution of Medicago in the tropics
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Niche conservatism limits the distribution of Medicago in the tropics
- Paper DOI: 10.1111/ecog.06085
- Dataset DOI: 10.5061/dryad.280gb5mrw
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.280gb5mrw
- Year: 2022 (annee de depot Dryad/DataCite, non verifiee comme annee de publication de l'article -- voir Reference publication)

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "richness ~ environmental_energy_PC1 [GWR, fixed kernel, AICc bandwidth] ; richness ~ each climatic variable / environmental-category PC1 [negative binomial GLM]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Yang, Bian, Ren, Liu & Shrestha (2022), Ecography e06085, Sections Environmental variables and Models/statistical analyses: the paper maps Medicago richness on 100 x 100 km grid cells, evaluates 24 environmental variables with negative-binomial GLMs and category PC1s, then uses GWR to explore the richness-environmental-energy relationship across latitude. formula_used keeps the documented environmental-energy group available in the local .rds (MAT, MTCQ, PET, WI, Solar_rad) as the canonical executable GWR/GLM benchmark formula."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "manual_review"
  benchmark_task: "review_count"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. richesse specifique observee : denombrement, sans transformation continue imposee."
  reason: "Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. richesse specifique observee : denombrement, sans transformation continue imposee."
```

- Decision: manual_review
- Manque principal: Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. richesse specifique observee : denombrement, sans transformation continue imposee.
- Raison: Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. richesse specifique observee : denombrement, sans transformation continue imposee.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "DECISION UTILISATEUR (2026-09-08) : option (b) -- mis de cote explicitement. La methode publiee (GLM univaries, une variable climatique a la fois, puis GWR sur un PC1 agrege 'energie environnementale') necessite une etape de pretraitement PCA absente du pipeline actuel, et un paradigme multi-modeles univaries different de la regression multivariee unique du harnais. En attente d'un futur chantier d'extension (pipeline de pretraitement PCA + orchestration multi-modeles univaries). formula_used (richness ~ 5 variables simultanees) reste documente comme une combinaison additive non testee par les auteurs -- ne pas promouvoir package_include=yes avant cette extension."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 8297
- k variables: 32
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-155.6728855, 177.8818578], y [-54.5346168, 70.8729427]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=333.6deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- Reproducibility status: OK - loader R enregistre et reexecutable (`medicago` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `medicago` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - Statut 'mis de cote' documente et intentionnel (voir Bloc 1 > Statut regression canonique > Note) ; ne pas retraiter sans revue.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`medicago` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Niche conservatism limits the distribution of Medicago in the tropics

## Curation documentée — 2026-09-07

Decision conservatoire : Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. richesse specifique observee : denombrement, sans transformation continue imposee. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : count. richesse specifique observee : denombrement, sans transformation continue imposee.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
