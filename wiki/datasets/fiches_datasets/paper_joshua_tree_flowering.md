---
title: paper_joshua_tree_flowering
type: dataset
created: 2026-09-14
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_joshua_tree_flowering.rds
  - DataCite_2024_Reconstructing120YearsOf_10_1111_ele_1447
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Reconstructing 120 years of climate change impacts on Joshua tree flowering" (DOI 10.1111/ele.14478).

## Description du jeu de donnees

- Topic: Phenologie de Joshua tree
- Observation unit: site d'observation ou cellule de grille d'occurrence
- Observed population: Sorties de hindcast de floraison de Joshua tree, incluant des differences entre periodes; observations binaires flr a traiter separement.
- Geographic context: etendue sf: x [-118.6666666, -112.7916662], y [33.7916662, 38.0833332]
- Temporal context: none (cross-sectional)
- Source description: Reconstructing 120 years of climate change impacts on Joshua tree flowering
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/ele.14478
- Dataset DOI: 10.5061/dryad.9kd51c5rr
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.9kd51c5rr
- Local raw dir: `data/raw/papers/DataCite_2024_Reconstructing120YearsOf_10_1111_ele_1447/`
- Local sf output: `data/final_datasets/sf/paper_joshua_tree_flowering.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `flyrs`
- Candidate Y typology: unknown
- Candidate X variables in local artifact: `Delta.Y1.2..PPT..mm.`, `Delta.Y0.1..PPT..mm.`, `Max.VPD.Y0...hPa.`, `Delta.Y0.1..Min.VPD..hPa.`, `Min.Temp.Y0...degree.C.`, `Delta.Y0.1..Max.Temp..degree.C.`
- Candidate X count in local artifact: 6
- Candidate X typology: continuous
- Published X variables from paper: Delta[Y1-2]*PPT, Delta[Y0-1]*PPT, Max VPD[Y0], Delta[Y0-1]*Min VPD, Delta[Y0-1]*Max Temp, Min Temp[Y0]
- Published X count: 6
- Coordinates (x, y - excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): `timeframe`, `ri.model`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `flyrs` | `integer` | continuous | [-7, 20] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `joshua_tree_flowering`, la ou les reponses `flyrs` viennent du loader papier et/ou des preuves de l article `Reconstructing 120 years of climate change impacts on Joshua tree flowering`. Les covariables X retenues sont `Delta.Y1.2..PPT..mm.`, `Delta.Y0.1..PPT..mm.`, `Max.VPD.Y0...hPa.`, `Delta.Y0.1..Min.VPD..hPa.`, `Min.Temp.Y0...degree.C.`, `Delta.Y0.1..Max.Temp..degree.C.`. Les coordonnees (`lon`, `lat`), identifiants (`timeframe`, `ri.model`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : not_ready_main_benchmark; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Delta.Y1.2..PPT..mm.` | `numeric` | continuous | 0% |
| `Delta.Y0.1..PPT..mm.` | `numeric` | continuous | 0% |
| `Max.VPD.Y0...hPa.` | `numeric` | continuous | 0% |
| `Delta.Y0.1..Min.VPD..hPa.` | `numeric` | continuous | 0% |
| `Min.Temp.Y0...degree.C.` | `numeric` | continuous | 0% |
| `Delta.Y0.1..Max.Temp..degree.C.` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: flowering indicator ~ annual precipitation + maximum/minimum temperature + vapor-pressure-deficit predictors [BART classification]; hindcast flowering years ~ selected climate deltas [continuous model output]
- x_terms_pub: Delta[Y1-2]*PPT, Delta[Y0-1]*PPT, Max VPD[Y0], Delta[Y0-1]*Min VPD, Delta[Y0-1]*Max Temp, Min Temp[Y0]
- y_term_pub: binary flowering event indicator for model training; predicted number of flowering years for hindcast summaries
- Reference publication: Yoder et al. (2024), Ecology Letters, DOI 10.1111/ele.14478: Sections Data compilation, Predictor selection and Hindcasting state that binary flowering observations were modelled with BART and then hindcast to 1900. The Dryad output archive contains jotr_flowering_predictors_change.csv, which reports continuous predicted flowering years (flyrs) by 4 km grid cell/timeframe with the six selected climate-change predictors. formula_used uses this continuous hindcast output, not the raw binary flr training response.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

### Formule - niveau systeme

- formula_used: flyrs ~ Delta.Y1.2..PPT..mm. + Delta.Y0.1..PPT..mm. + Max.VPD.Y0...hPa. + Delta.Y0.1..Min.VPD..hPa. + Delta.Y0.1..Max.Temp..degree.C. + Min.Temp.Y0...degree.C.
- License evidence: DataCite API record for DOI 10.5061/dryad.9kd51c5rr (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Formula used evidence: generated_system_formula
- Recommended validation: N lignes=11133; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=7422. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.
- benchmark_task_note: flyrs est un produit de hindcast incluant des differences negatives entre periodes, pas la reponse binaire observee flr.
- Selected Y evidence: flyrs est un produit de hindcast incluant des differences negatives entre periodes, pas la reponse binaire observee flr.
- Selected Y typology: continuous
- x_terms_used: Delta.Y1.2..PPT..mm., Delta.Y0.1..PPT..mm., Max.VPD.Y0...hPa., Delta.Y0.1..Min.VPD..hPa., Min.Temp.Y0...degree.C., Delta.Y0.1..Max.Temp..degree.C.
- y_term_used: flyrs
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
    formula: "flyrs ~ selected annual weather deltas from the BART hindcast"
    response: "binary flowering event indicator for model training; predicted number of flowering years for hindcast summaries"
    predictors: ["Delta[Y1-2]*PPT", "Delta[Y0-1]*PPT", "Max VPD[Y0]", "Delta[Y0-1]*Min VPD", "Delta[Y0-1]*Max Temp", "Min Temp[Y0]"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "flyrs ~ selected climate deltas"
    response: "flyrs"
    predictors: ["Delta.Y1.2..PPT..mm.", "Delta.Y0.1..PPT..mm.", "Max.VPD.Y0...hPa.", "Delta.Y0.1..Min.VPD..hPa.", "Delta.Y0.1..Max.Temp..degree.C.", "Min.Temp.Y0...degree.C."]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["random_forest", "xgboost", "gamboost"]
    status: "confirmed_continuous_hindcast_response"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_joshua_tree_flowering`
- Dataset name: Data from: Reconstructing 120 years of climate change impacts on Joshua tree flowering
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Reconstructing 120 years of climate change impacts on Joshua tree flowering
- Paper DOI: 10.1111/ele.14478
- Dataset DOI: 10.5061/dryad.9kd51c5rr
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.9kd51c5rr
- Year: 2024 (annee de depot Dryad/DataCite, non verifiee comme annee de publication de l'article -- voir Reference publication)

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "flowering indicator ~ annual precipitation + maximum/minimum temperature + vapor-pressure-deficit predictors [BART classification]; hindcast flowering years ~ selected climate deltas [continuous model output]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Yoder et al. (2024), Ecology Letters, DOI 10.1111/ele.14478: Sections Data compilation, Predictor selection and Hindcasting state that binary flowering observations were modelled with BART and then hindcast to 1900. The Dryad output archive contains jotr_flowering_predictors_change.csv, which reports continuous predicted flowering years (flyrs) by 4 km grid cell/timeframe with the six selected climate-change predictors. formula_used uses this continuous hindcast output, not the raw binary flr training response."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_main_benchmark"
  benchmark_task: "source_or_specialized_task_only"
  package_include: "no"
  has_local_rds: true
  missing_items: "Y flyrs est une sortie de hindcast BART, avec 689 valeurs négatives (différences entre périodes); routage count incompatible. Description de pollinisateurs/oiseaux sans rapport avec Joshua tree. Isoler cette tâche de sortie modèle; privilégier les observations flr originales du dépôt, avec route binaire et sélection climatique publiée. Corriger la description et les périodes."
  reason: "Y flyrs est une sortie de hindcast BART, avec 689 valeurs négatives (différences entre périodes); routage count incompatible. Description de pollinisateurs/oiseaux sans rapport avec Joshua tree. Isoler cette tâche de sortie modèle; privilégier les observations flr originales du dépôt, avec route binaire et sélection climatique publiée. Corriger la description et les périodes."
```

- Decision: not_ready_main_benchmark
- Manque principal: Y flyrs est une sortie de hindcast BART, avec 689 valeurs négatives (différences entre périodes); routage count incompatible. Description de pollinisateurs/oiseaux sans rapport avec Joshua tree. Isoler cette tâche de sortie modèle; privilégier les observations flr originales du dépôt, avec route binaire et sélection climatique publiée. Corriger la description et les périodes.
- Raison: Y flyrs est une sortie de hindcast BART, avec 689 valeurs négatives (différences entre périodes); routage count incompatible. Description de pollinisateurs/oiseaux sans rapport avec Joshua tree. Isoler cette tâche de sortie modèle; privilégier les observations flr originales du dépôt, avec route binaire et sélection climatique publiée. Corriger la description et les périodes.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "not_ready_main_benchmark"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "Y flyrs est une sortie de hindcast BART, avec 689 valeurs négatives (différences entre périodes); routage count incompatible. Description de pollinisateurs/oiseaux sans rapport avec Joshua tree. Isoler cette tâche de sortie modèle; privilégier les observations flr originales du dépôt, avec route binaire et sélection climatique publiée. Corriger la description et les périodes."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 11133
- k variables: 13
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-118.6666666, -112.7916662], y [33.7916662, 38.0833332]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32611 (UTM Zone 11N (EPSG:32611)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- Reproducibility status: OK - loader R enregistre et reexecutable (`joshua_tree_flowering` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `joshua_tree_flowering` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`joshua_tree_flowering` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Reconstructing 120 years of climate change impacts on Joshua tree flowering

## Curation documentée — 2026-09-07

La formule executee est une adaptation de la source, distincte des modeles publies : Y flyrs est une sortie de hindcast BART, avec 689 valeurs négatives (différences entre périodes); routage count incompatible. Description de pollinisateurs/oiseaux sans rapport avec Joshua tree.

Decision conservatoire : Y flyrs est une sortie de hindcast BART, avec 689 valeurs négatives (différences entre périodes); routage count incompatible. Description de pollinisateurs/oiseaux sans rapport avec Joshua tree. Isoler cette tâche de sortie modèle; privilégier les observations flr originales du dépôt, avec route binaire et sélection climatique publiée. Corriger la description et les périodes. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : continuous. flyrs est un produit de hindcast incluant des differences negatives entre periodes, pas la reponse binaire observee flr.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
