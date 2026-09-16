---
title: paper_bean_landrace_gap_sdm
type: dataset
created: 2026-09-14
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_bean_landrace_gap_sdm.rds
  - DataCite_2020_AGapAnalysisModelling_10_1111_ddi_1304
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "A gap analysis modelling framework to prioritize collecting for ex situ conservation of crop landraces" (DOI 10.1111/ddi.13046).

## Description du jeu de donnees

- Topic: Donnees de paper-derived : paper_bean_landrace_gap_sdm
- Observation unit: observation spatiale du dataset "A gap analysis modeling framework to prioritize collecting for ex situ conservation of crop landraces"
- Observed population: Modélisation de distribution spatiale de variétés traditionnelles de haricot commun ; gap analysis avec prédicteurs environnementaux et socioéconomiques ; domaine agriculture/conservation ex situ ; 35 citations
- Geographic context: etendue sf: x [-117.033, -34.9], y [-38.45, 32.616667]
- Temporal context: none (cross-sectional)
- Source description: A gap analysis modelling framework to prioritize collecting for ex situ conservation of crop landraces
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/ddi.13046
- Dataset DOI: 10.5061/dryad.866t1g1n0
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.866t1g1n0
- Local raw dir: `data/raw/papers/DataCite_2020_AGapAnalysisModelling_10_1111_ddi_1304/`
- Local sf output: `data/final_datasets/sf/paper_bean_landrace_gap_sdm.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `status_H_01`
- Candidate Y typology: binary
- Candidate X variables in local artifact: `bio_1`, `bio_2`, `bio_3`, `bio_4`, `bio_5`, `bio_6`, `bio_7`, `bio_8`, `bio_9`, `bio_10`, `bio_11`, `bio_12`, `bio_13`, `bio_14`, `bio_15`, `bio_16`, `bio_17`, `bio_18`, `bio_19`, `srad`, `wspd`, `wvap`, `alt`, `PETa`, `thorn`, `moist`, `conti`, `ember`, `gdd0`, `gdd5`, `t10`, `tminwq`, `tmaxcq`, `PETcq`, `PETdq`, `PETs`, `PETwaq`, `PETweq`, `therm`, `drym`, `urban`, `distgp1`, `popdens`, `rivers`, `irri`, `access`, `aharv`, `prod`, `yield`, `genepool_andean_01`
- Candidate X count in local artifact: 50
- Candidate X typology: continuous, categorical
- Published X variables from paper: WorldClim bioclimatic variables (16 candidates, bio_1-19), solar radiation, wind speed, water vapor pressure, altitude, potential evapotranspiration (+ variantes ENVIREM), population density, accessibility (temps de trajet), distance to primary genepool wild relatives, distance to rivers, irrigation fraction, harvested area, production, yield
- Published X count: 14
- Coordinates (x, y - excluded from X candidates): `longitude`, `latitude`
- Identifier columns (excluded from X candidates): `source`, `status`, `genepool`, `ethnic`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `status_H_01` | `integer` | binary | {0, 1} | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `bean_landrace_gap_sdm`, la ou les reponses `status_H_01` viennent du loader papier et/ou des preuves de l article `A gap analysis modelling framework to prioritize collecting for ex situ conservation of crop landraces`. Les covariables X retenues sont `bio_1`, `bio_12`, `alt`, `PETa`, `popdens`, `access`, `distgp1`, `rivers`, `irri`, `aharv`, `prod`, `yield` ; 38 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`longitude`, `latitude`), identifiants (`source`, `status`, `genepool`, `ethnic`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `bio_1` | `numeric` | continuous | 0% |
| `bio_2` | `numeric` | continuous | 0% |
| `bio_3` | `numeric` | continuous | 0% |
| `bio_4` | `numeric` | continuous | 0% |
| `bio_5` | `numeric` | continuous | 0% |
| `bio_6` | `numeric` | continuous | 0% |
| `bio_7` | `numeric` | continuous | 0% |
| `bio_8` | `numeric` | continuous | 0% |
| `bio_9` | `numeric` | continuous | 0% |
| `bio_10` | `numeric` | continuous | 0% |
| `bio_11` | `numeric` | continuous | 0% |
| `bio_12` | `numeric` | continuous | 0% |
| `bio_13` | `numeric` | continuous | 0% |
| `bio_14` | `numeric` | continuous | 0% |
| `bio_15` | `numeric` | continuous | 0% |
| `bio_16` | `numeric` | continuous | 0% |
| `bio_17` | `numeric` | continuous | 0% |
| `bio_18` | `numeric` | continuous | 0% |
| `bio_19` | `numeric` | continuous | 0% |
| `srad` | `numeric` | continuous | 0% |
| `wspd` | `numeric` | continuous | 0% |
| `wvap` | `numeric` | continuous | 0% |
| `alt` | `numeric` | continuous | 0% |
| `PETa` | `numeric` | continuous | 0% |
| `thorn` | `numeric` | continuous | 0% |
| `moist` | `numeric` | continuous | 0% |
| `conti` | `numeric` | continuous | 0% |
| `ember` | `numeric` | continuous | 0% |
| `gdd0` | `numeric` | continuous | 0% |
| `gdd5` | `numeric` | continuous | 0% |
| `t10` | `numeric` | continuous | 0% |
| `tminwq` | `numeric` | continuous | 0% |
| `tmaxcq` | `numeric` | continuous | 0% |
| `PETcq` | `numeric` | continuous | 0% |
| `PETdq` | `numeric` | continuous | 0% |
| `PETs` | `numeric` | continuous | 0% |
| `PETwaq` | `numeric` | continuous | 0% |
| `PETweq` | `numeric` | continuous | 0% |
| `therm` | `numeric` | continuous | 0% |
| `drym` | `numeric` | continuous | 0% |
| `urban` | `numeric` | continuous | 0% |
| `distgp1` | `numeric` | continuous | 0% |
| `popdens` | `numeric` | continuous | 0% |
| `rivers` | `numeric` | continuous | 0% |
| `irri` | `numeric` | continuous | 0% |
| `access` | `numeric` | continuous | 0% |
| `aharv` | `numeric` | continuous | 0% |
| `prod` | `numeric` | continuous | 0% |
| `yield` | `numeric` | continuous | 0% |
| `genepool_andean_01` | `integer` | binary | 0% |

### Formule - niveau publication

- formula_pub: landrace occurrence ~ 23 predicteurs VIF/PCA-selectionnes (16 climatiques + 7 non-climatiques) [MaxEnt/maxnet, puis score de gap seuillee]
- x_terms_pub: WorldClim bioclimatic variables (16 candidates, bio_1-19), solar radiation, wind speed, water vapor pressure, altitude, potential evapotranspiration (+ variantes ENVIREM), population density, accessibility (temps de trajet), distance to primary genepool wild relatives, distance to rivers, irrigation fraction, harvested area, production, yield
- y_term_pub: status_H_01 : indicateur binaire de provenance des occurrences (1 = releve herbier/GBIF hors genebank, 0 = accession de genebank), calcule depuis la colonne brute `status` du Dataset S1 du papier -- PAS une sortie du MaxEnt SDM ni du score de gap (verification directe du fichier source, aucune colonne de ce type n'existe localement)
- Reference publication: Ramirez-Villegas, Khoury, Achicanoy, Mendez, Diaz, Sosa, Debouck, Kehel & Guarino (2020), A gap analysis modelling framework to prioritize collecting for ex situ conservation of crop landraces, Diversity and Distributions, DOI 10.1111/ddi.13046 (Ramirez-Villegas, Julian est le premier auteur, Khoury, Colin est le 2e). Dryad 10.5061/dryad.866t1g1n0, README.txt local documente les 50 variables candidates (Table S2.1) avec definitions/unites/sources completes. Methode du papier confirmee par lecture directe du TEI (section 2.4.1) : MaxEnt (package R 'maxnet'), presence/pseudo-absence, K=5 cross-validation, variables sub-selectionnees par VIF (<10) + PCA (contribution >=15% au PC1) parmi les 50 candidates -- 23 retenues (16 climatiques + 7 non-climatiques) pour le meilleur modele ('both' config climat+non-climat). CORRECTION 2026-09-14 (verification directe de dataset_s1_revised2.xlsx + TEI section 2.1) : le fichier local est le Dataset S1 du papier, c.a.d. le jeu d'occurrences COMPILE utilise en ENTREE du MaxEnt (21561 lignes, colonnes source/status/genepool + coordonnees + 50 covariables candidates), pas une sortie du gap analysis. La colonne `status` (G=genebank accession, majoritaire ; H=releve herbier/GBIF independant, ~8% des lignes) code la provenance de chaque occurrence -- confirme par le TEI ('Additional occurrences were gathered from GBIF ... to provide independent data from non-genebank sources'). status_H_01 = as.integer(status=="H") est donc une metadonnee de provenance des points d'entree, pas le score de gap ou une sortie MaxEnt. formula_used est une tache de classification binaire construite par le systeme sur cette metadonnee, en reutilisant le pool de covariables environnementales/socioeconomiques documente par le papier -- voir formula_used_divergence_note.

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d estimation: formule systeme generee (formula_pub confirmee mais non reprise telle quelle -- voir Note ci-dessous)
- Correspondance Python/R: aucune identifiee
- Note: CORRECTION 2026-09-14 (relecture critique externe + verification directe du fichier source) : la version precedente de cette note affirmait a tort que status_H_01 etait 'probablement' un score de gap derive du MaxEnt. Verifie faux par inspection directe de dataset_s1_revised2.xlsx (feuille bean_predicted_bd_americas, 21561 lignes, colonnes source/status/genepool/coordonnees/50 covariables) : aucune colonne de score de gap, de priorite de collecte ou de sortie MaxEnt n'existe dans ce fichier -- seulement 3 colonnes de metadonnees de provenance (source, status, genepool). status_H_01 est calcule par le loader R (`df$status_H_01 <- as.integer(df$status == "H")`) directement depuis la colonne brute `status` du jeu d'occurrences compile (Dataset S1 du papier, section 2.1 du TEI: 'Our full occurrence dataset for P. vulgaris is available in Dataset S1'), qui code si chaque occurrence provient d'une accession de genebank (G, 19831/21561 lignes -- CIAT/Genesys/USDA/WIEWS) ou d'un releve herbier/GBIF independant (H, 1730/21561 lignes -- confirme par le TEI: 'Additional occurrences were gathered from GBIF ... 25,670 observations from herbaria, botanic gardens and other plant repositories, to provide independent data from non-genebank sources'). C'est donc une metadonnee de provenance des points d'occurrence UTILISES EN ENTREE du MaxEnt du papier, pas une sortie de son pipeline de gap analysis (qui produit S_CON/S_ACC/S_ENV, seuilles puis sommes en une carte 0-3, jamais materialisee dans cet artefact local). formula_used est donc une tache de classification binaire entierement construite par le systeme (provenance genebank vs herbier/GBIF, prediction a partir de covariables environnementales/socioeconomiques du meme pool candidat que le papier), et non une approximation du pipeline SDM+gap du papier -- a ne plus presenter comme tel.

### Formule - niveau systeme

- formula_used: status_H_01 ~ bio_1 + bio_12 + alt + PETa + popdens + access + distgp1 + rivers + irri + aharv + prod + yield
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: binary
- x_terms_used: bio_1, bio_12, alt, PETa, popdens, access, distgp1, rivers, irri, aharv, prod, yield
- y_term_used: status_H_01
- Note: 23 des 50 variables candidates documentees (Table S2.1 du depot, README.txt local) ont ete retenues par les auteurs apres filtrage VIF (<10) + PCA (contribution >=15% au premier axe) -- 16 climatiques + 7 non-climatiques d'apres le texte, mais la liste exacte des 23 survivantes n'est disponible que dans le detail de Table S2.1 (non extrait de ce TEI). Les 12 covariables de formula_used (bio_1, bio_12, alt, PETa, popdens, access, distgp1, rivers, irri, aharv, prod, yield) sont un sous-ensemble plausible et documente de ce pool candidat (couvrant climat + non-climat comme le papier le souligne), pas confirme comme etant exactement les 23 survivantes du filtrage VIF/PCA. Point verifie separement : la colonne locale `ethnic` (texte, 75 groupes ethniques nommes, ex. 'Argentinians', 'Quechua') est un champ de provenance categoriel de l'accession, PAS la covariable numerique 'geographic distribution of ethnic groups' (Weidmann et al. 2010) listee en variable #47 du Tableau S2.1 -- meme nom de colonne, source differente ; exclue de X a raison, mais pour cause de non-numerique/haute-cardinalite, pas en tant qu'identifiant.

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
    formula: "status_H_01 ~ selected climate, accessibility and agricultural predictors"
    response: "status_H_01 : indicateur binaire de provenance des occurrences (1 = releve herbier/GBIF hors genebank, 0 = accession de genebank), calcule depuis la colonne brute `status` du Dataset S1 du papier -- PAS une sortie du MaxEnt SDM ni du score de gap (verification directe du fichier source, aucune colonne de ce type n'existe localement)"
    predictors: ["WorldClim bioclimatic variables (16 candidates, bio_1-19)", "solar radiation", "wind speed", "water vapor pressure", "altitude", "potential evapotranspiration (+ variantes ENVIREM)", "population density", "accessibility (temps de trajet)", "distance to primary genepool wild relatives", "distance to rivers", "irrigation fraction", "harvested area", "production", "yield"]
    role: "benchmark_simplified_specification"
    source_type: "derived_from_scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["random_forest", "gamboost", "xgboost"]
    status: "executable_approximation"

  ml_or_selected:
    formula: "status_H_01 ~ climate + accessibility + agricultural predictors"
    response: "status_H_01"
    predictors: ["bio_1", "bio_12", "alt", "PETa", "popdens", "access", "distgp1", "rivers", "irri", "aharv", "prod", "yield"]
    role: "ml_candidate_features"
    source_type: "derived_from_scientific_publication_plus_local_dataset_metadata"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["random_forest", "xgboost", "gamboost"]
    status: "executable_provenance_classification_task"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_bean_landrace_gap_sdm`
- Dataset name: A gap analysis modeling framework to prioritize collecting for ex situ conservation of crop landraces
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: A gap analysis modelling framework to prioritize collecting for ex situ conservation of crop landraces
- Paper DOI: 10.1111/ddi.13046
- Dataset DOI: 10.5061/dryad.866t1g1n0
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.866t1g1n0
- Year: 2020

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "landrace occurrence ~ 23 predicteurs VIF/PCA-selectionnes (16 climatiques + 7 non-climatiques) [MaxEnt/maxnet, puis score de gap seuillee]"
  equation_family: sdm_maxent_then_locally_constructed_binary_classification
  model_family: species_distribution_modeling
  source_type: scientific_publication_or_package_documentation
  source_ref: "Ramirez-Villegas, Khoury, Achicanoy, Mendez, Diaz, Sosa, Debouck, Kehel & Guarino (2020), A gap analysis modelling framework to prioritize collecting for ex situ conservation of crop landraces, Diversity and Distributions, DOI 10.1111/ddi.13046 (Ramirez-Villegas, Julian est le premier auteur, Khoury, Colin est le 2e). Dryad 10.5061/dryad.866t1g1n0, README.txt local documente les 50 variables candidates (Table S2.1) avec definitions/unites/sources completes. Methode du papier confirmee par lecture directe du TEI (section 2.4.1) : MaxEnt (package R 'maxnet'), presence/pseudo-absence, K=5 cross-validation, variables sub-selectionnees par VIF (<10) + PCA (contribution >=15% au PC1) parmi les 50 candidates -- 23 retenues (16 climatiques + 7 non-climatiques) pour le meilleur modele ('both' config climat+non-climat). CORRECTION 2026-09-14 (verification directe de dataset_s1_revised2.xlsx + TEI section 2.1) : le fichier local est le Dataset S1 du papier, c.a.d. le jeu d'occurrences COMPILE utilise en ENTREE du MaxEnt (21561 lignes, colonnes source/status/genepool + coordonnees + 50 covariables candidates), pas une sortie du gap analysis. La colonne `status` (G=genebank accession, majoritaire ; H=releve herbier/GBIF independant, ~8% des lignes) code la provenance de chaque occurrence -- confirme par le TEI ('Additional occurrences were gathered from GBIF ... to provide independent data from non-genebank sources'). status_H_01 = as.integer(status=='H') est donc une metadonnee de provenance des points d'entree, pas le score de gap ou une sortie MaxEnt. formula_used est une tache de classification binaire construite par le systeme sur cette metadonnee, en reutilisant le pool de covariables environnementales/socioeconomiques documente par le papier -- voir formula_used_divergence_note."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_binary"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Y/X/formula_used deja resolus ; estimateurs generiques (binary) ajoutes en revue de lot du 2026-09-09."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Y/X/formula_used deja resolus ; estimateurs generiques (binary) ajoutes en revue de lot du 2026-09-09.

## Estimator eligibility

```yaml
estimator_eligibility:
  eligible_estimators:
    - estimator: ols
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Regression (famille binomiale) generique pour reponse binaire."
    - estimator: gam_spatial
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "GAM (famille binomiale), baseline generique pour reponse binaire."
    - estimator: random_forest
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Alternative ML de classification generique, Y binaire."
    - estimator: xgboost
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Alternative ML de classification generique, Y binaire."
    - estimator: sar_probit
      basis: generated_candidate
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Probit spatial (SAR) -- pertinent si dependance spatiale genuine sur Y binaire, non confirme specifiquement pour ce jeu."
    - estimator: sem_probit
      basis: generated_candidate
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Probit spatial (SEM) -- idem sar_probit."
  conditionally_eligible_estimators: []
  ineligible_reason: "n/a -- estimateurs generiques eligibles (voir eligible_estimators)."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 21543
- k variables: 59
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-117.033, -34.9], y [-38.45, 32.616667]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=82.1deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.866t1g1n0 (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`bean_landrace_gap_sdm` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `bean_landrace_gap_sdm` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formula_pub confirmee et verifiee (voir Reference publication) ; formula_used est une approximation generee distincte, explicitement etiquetee comme telle (voir Bloc 1 > Statut regression canonique > Note).
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`bean_landrace_gap_sdm` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: A gap analysis modelling framework to prioritize collecting for ex situ conservation of crop landraces

## Curation documentée — 2026-09-07

Decision conservatoire : Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : binary. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
