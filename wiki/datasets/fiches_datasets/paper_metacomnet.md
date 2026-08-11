---
title: paper_metacomnet
type: dataset
created: 2026-08-11
updated: 2026-08-11
sources:
  - data/final_datasets/sf/paper_metacomnet.rds
  - DataCite_2021_MetacomnetARandomForest_10_1111_2041_210
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "MetaComNet: A random forest-based framework for making spatial predictions of plant-pollinator interactions" (DOI 10.1111/2041-210x.13762).

## Description du jeu de donnees

- Topic: ecologie / interactions plantes-pollinisateurs
- Observation unit: site d'observation ou cellule de grille d'occurrence
- Observed population: communautes de pollinisateurs ou d'oiseaux nectarivores
- Geographic context: etendue sf: x [10.990725, 11.192735], y [60.085292, 60.318768]
- Temporal context: none (cross-sectional)
- Source description: MetaComNet: A random forest-based framework for making spatial predictions of plant-pollinator interactions
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/2041-210x.13762
- Dataset DOI: 10.5061/dryad.n02v6wwzn
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.n02v6wwzn
- Local raw dir: `data/raw/papers/DataCite_2021_MetacomnetARandomForest_10_1111_2041_210/`
- Local sf output: `data/final_datasets/sf/paper_metacomnet.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Number`, `Occurrence`
- Candidate Y typology: count, binary
- Candidate X variables in local artifact: `DCA1`, `DCA2`, `DCA3`, `DCA4`, `BeeDCA1`, `BeeDCA2`, `BeeDCA3`, `BeeDCA4`, `Solitary`, `PlantFreq`, `MASL`, `LnscpH`, `LndscpGR`, `DistSand`, `NearestOcc`, `RegionalCommonness`, `FacOccurrence`
- Candidate X count in local artifact: 17
- Candidate X typology: continuous, categorical
- Published X variables from paper: DCA1, DCA2, DCA3, DCA4, BeeDCA1, BeeDCA2, BeeDCA3, BeeDCA4, Solitary, PlantFreq, MASL, LnscpH
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `Site`, `SiteBee`, `SitePlant`, `SitePlantBee`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Number` | `integer` | count | [0, 27] | 0% |
| `Occurrence` | `integer` | binary | {0, 1} | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `metacomnet`, la ou les reponses `Number`, `Occurrence` viennent du loader papier et/ou des preuves de l article `MetaComNet: A random forest-based framework for making spatial predictions of plant-pollinator interactions`. Les covariables X retenues sont `DCA1`, `DCA2`, `DCA3`, `DCA4`, `BeeDCA1`, `BeeDCA2`, `BeeDCA3`, `BeeDCA4`, `Solitary`, `PlantFreq`, `MASL`, `LnscpH` ; 5 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (`Site`, `SiteBee`, `SitePlant`, `SitePlantBee`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : not_ready_current_package ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `DCA1` | `numeric` | continuous | 0% |
| `DCA2` | `numeric` | continuous | 0% |
| `DCA3` | `numeric` | continuous | 0% |
| `DCA4` | `numeric` | continuous | 0% |
| `BeeDCA1` | `numeric` | continuous | 0% |
| `BeeDCA2` | `numeric` | continuous | 0% |
| `BeeDCA3` | `numeric` | continuous | 0% |
| `BeeDCA4` | `numeric` | continuous | 0% |
| `Solitary` | `logical` | binary | 0% |
| `PlantFreq` | `numeric` | continuous | 0% |
| `MASL` | `numeric` | continuous | 0% |
| `LnscpH` | `numeric` | continuous | 0% |
| `LndscpGR` | `numeric` | rate | 0% |
| `DistSand` | `numeric` | continuous | 0% |
| `NearestOcc` | `numeric` | continuous | 0% |
| `RegionalCommonness` | `integer` | count | 0% |
| `FacOccurrence` | `character` | categorical | 0% |

### Formule - niveau publication

- formula_pub: pending
- x_terms_pub: DCA1, DCA2, DCA3, DCA4, BeeDCA1, BeeDCA2, BeeDCA3, BeeDCA4, Solitary, PlantFreq, MASL, LnscpH
- y_term_pub: Number
- Reference publication: DataCite dataset DOI 10.5061/dryad.n02v6wwzn; Publication DOI 10.1111/2041-210x.13762

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule - niveau systeme

- formula_used: Number ~ DCA1 + DCA2 + DCA3 + DCA4 + BeeDCA1 + BeeDCA2 + BeeDCA3 + BeeDCA4 + Solitary + PlantFreq + MASL + LnscpH + ... (5 covariables au total, voir Candidate X variables)
- x_terms_used: DCA1, DCA2, DCA3, DCA4, BeeDCA1, BeeDCA2, BeeDCA3, BeeDCA4, Solitary, PlantFreq, MASL, LnscpH
- y_term_used: Number
- Note: formule candidate generee automatiquement (Y ~ toutes les covariables X detectees), PAS une formule publiee ou verifiee dans le papier source - a confirmer par revue manuelle.

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
    formula: "Number ~ DCA1 + DCA2 + DCA3 + DCA4 + BeeDCA1 + BeeDCA2 + BeeDCA3 + BeeDCA4 + Solitary + PlantFreq + MASL + LnscpH + ... (5 covariables au total, voir Candidate X variables)"
    response: "Number"
    predictors: ["DCA1", "DCA2", "DCA3", "DCA4", "BeeDCA1", "BeeDCA2", "BeeDCA3", "BeeDCA4", "Solitary", "PlantFreq", "MASL", "LnscpH"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/raw/papers (loader-derived, no published equation located)"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_metacomnet`
- Dataset name: MetaComNet: A random forest-based framework for making spatial prediction of plant-pollinator interactions
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: MetaComNet: A random forest-based framework for making spatial predictions of plant-pollinator interactions
- Paper DOI: 10.1111/2041-210x.13762
- Dataset DOI: 10.5061/dryad.n02v6wwzn
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.n02v6wwzn
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "pending"
  equation_family: generated_system_candidate
  model_family: unknown
  source_type: generated_system_formula
  source_ref: "data/raw/papers (loader-derived, no published equation located)"
  confidence: low
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_current_package"
  benchmark_task: "classification_or_count_rf"
  package_include: "no"
  has_local_rds: true
  missing_items: "route classification/count et specification de reponse adaptee"
  reason: "Le papier utilise une logique Random Forest sur occurrences/interactions, pas une regression continue standard."
```

- Decision: not_ready_current_package
- Manque principal: route classification/count et specification de reponse adaptee
- Raison: Le papier utilise une logique Random Forest sur occurrences/interactions, pas une regression continue standard.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "not_ready_current_package"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "current package supports continuous spatial regression benchmarks; this fiche is not currently an executable continuous-regression dataset"
  rule: "paper fiches are eligible only when response, predictors, coordinates/geometry and required W are executable in the local artifact"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 9594
- k variables: 25
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [10.990725, 11.192735], y [60.085292, 60.318768]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32632 (UTM Zone 32N (EPSG:32632)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`metacomnet` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `metacomnet` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: PENDING - formule publication non encore etablie (formule candidate systeme fournie a la place).
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`metacomnet` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: MetaComNet: A random forest-based framework for making spatial predictions of plant-pollinator interactions

