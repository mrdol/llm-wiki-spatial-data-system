---
title: paper_metacomnet
type: dataset
created: 2026-09-14
updated: 2026-09-07
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
- Candidate Y typology: unknown, binary
- Candidate X variables in local artifact: `DCA1`, `DCA2`, `DCA3`, `DCA4`, `BeeDCA1`, `BeeDCA2`, `BeeDCA3`, `BeeDCA4`, `Solitary`, `PlantFreq`, `MASL`, `LnscpH`, `LndscpGR`, `DistSand`, `NearestOcc`, `RegionalCommonness`, `FacOccurrence`
- Candidate X count in local artifact: 17
- Candidate X typology: continuous, categorical, unknown
- Published X variables from paper: RegionalCommonness, NearestOcc, BeeDCA1, BeeDCA2, BeeDCA3, BeeDCA4, Solitary, PlantFreq, DCA1, DCA2, DCA3, DCA4, MASL, LndscpGR, LnscpH, DistSand
- Published X count: 16
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `Site`, `SiteBee`, `SitePlant`, `SitePlantBee`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Number` | `integer` | count | [0, 27] | 0% |
| `Occurrence` | `integer` | binary | {0, 1} | 0% |

> Selection Y/X (paper-loader / curated evidence) : Les covariables X retenues sont les 16 predicteurs reels documentes par le papier (Table 1-2) : RegionalCommonness, NearestOcc, BeeDCA1-4, Solitary, PlantFreq, DCA1-4, MASL, LndscpGR, LnscpH, DistSand. `FacOccurrence` (17e colonne candidate du .rds) est EXCLUE : verification empirique (2026-09-10) confirme une correspondance bijective parfaite avec la variable reponse `Occurrence` (X0<->0, X1<->1, 9594/9594 lignes) -- c'est la version factorielle de l'autre reponse publiee (Table 2), pas une covariable ; l'inclure aurait constitue une fuite de donnees pour predire `Number`.

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
| `RegionalCommonness` | `integer` | unknown | 0% |
| `FacOccurrence` | `character` | categorical | 0% |

### Formule - niveau publication

- formula_pub: Number ~ RegionalCommonness + NearestOcc + BeeDCA1 + BeeDCA2 + BeeDCA3 + BeeDCA4 + Solitary + PlantFreq + DCA1 + DCA2 + DCA3 + DCA4 + MASL + LndscpGR + LnscpH + DistSand [Random Forest, ranger]
- x_terms_pub: RegionalCommonness, NearestOcc, BeeDCA1, BeeDCA2, BeeDCA3, BeeDCA4, Solitary, PlantFreq, DCA1, DCA2, DCA3, DCA4, MASL, LndscpGR, LnscpH, DistSand
- y_term_pub: Number (nombre d'interactions observees entre une espece d'abeille et une espece de plante sur un site) ; Occurrence (presence/absence de cette meme interaction, {0,1}) est un second Y publie avec la meme importance -- le papier ajuste 3 modeles RF : classification sur Occurrence, regression sur Occurrence, regression sur Number (Table 2, Section 2.2)
- Reference publication: Sydenham, Venter, Reitan, Rasmussen, Skrindo, Skoog, Hanevik, Hegland, Dupont, Nielsen, Chipperfield & Rusch (2022), 'MetaComNet: A random forest-based framework for making spatial predictions of plant-pollinator interactions', Methods in Ecology and Evolution 13(3):500-513, DOI 10.1111/2041-210X.13762 (recu 2 septembre 2021, accepte 12 octobre 2021, publie 2022). Table 1-2 documentent exactement les colonnes presentes dans le depot Dryad (10.5061/dryad.n02v6wwzn) : reponses Number/Occurrence par combinaison abeille x plante x site (N=9594=39x44x16, verifie), predicteurs bee/plant/site. Random Forest (Breiman 2001, package ranger via caret) est explicitement la methode publiee, pour 3 strategies de modelisation (classification Occurrence, regression Occurrence, regression Number).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee (verifiee 2026-09-10)
- Correspondance Python/R: aucune identifiee
- Note: Formule etablie par lecture directe du PDF (2026-09-10, Table 1-2 p.503-504 + Section 2.2 p.504-505) : N=9594 = 39 especes d'abeilles x 44 especes de plantes x 16 sites (correspondance exacte confirmee). 16 predicteurs reels retrouves un a un dans le Table 1/2 (Regional Commonness, Distance to conspecifics, DCA1-4 abeille/plante, sociality Bombus, abondance locale de la plante, elevation, grassland 250m, Shannon landscape 250m, distance aux sols sableux). ERREUR CORRIGEE : `FacOccurrence` (17e colonne candidate) etait inclus a tort dans formula_used comme covariable -- verification empirique sur le .rds (2026-09-10) confirme une correspondance bijective parfaite avec `Occurrence` (FacOccurrence='X0' ssi Occurrence=0, 'X1' ssi Occurrence=1, 9594/9594 lignes, aucun croisement) : c'est la version factorielle de l'AUTRE variable reponse du papier (Table 2 : "Occurrence... transformed into a two-level categorical variable for models using classification trees"), pas une covariable -- fuite de donnees (l'autre reponse servait de predicteur). Retiree de x_terms_pub/formula_used. Occurrence reste une deuxieme cible Y legitime et documentee (non retenue comme formula_used ici, qui cible Number), a traiter si besoin comme un second modele plutot que remplacer Number.

### Formule - niveau systeme

- formula_used: Number ~ DCA1 + DCA2 + DCA3 + DCA4 + BeeDCA1 + BeeDCA2 + BeeDCA3 + BeeDCA4 + Solitary + PlantFreq + MASL + LnscpH + LndscpGR + DistSand + NearestOcc + RegionalCommonness + FacOccurrence
- Formula used evidence: generated_system_formula
- benchmark_task_note: Number est un comptage; Occurrence est une autre reponse binaire.
- Selected Y evidence: Number est un comptage; Occurrence est une autre reponse binaire.
- Selected Y typology: count
- x_terms_used: DCA1, DCA2, DCA3, DCA4, BeeDCA1, BeeDCA2, BeeDCA3, BeeDCA4, Solitary, PlantFreq, MASL, LnscpH, LndscpGR, DistSand, NearestOcc, RegionalCommonness, FacOccurrence
- y_term_used: Number
- Note: Sydenham et al. (2022), Table 1-2 : Random Forest regression trees (Breiman 2001, ranger/caret) ; modele jumeau sur Occurrence (presence/absence) via arbres de classification, memes predicteurs. Voir yx_selection_note pour l'exclusion de FacOccurrence (fuite de donnees).

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
    formula: "Number ~ DCA1 + DCA2 + DCA3 + DCA4 + BeeDCA1 + BeeDCA2 + BeeDCA3 + BeeDCA4 + Solitary + PlantFreq + MASL + LnscpH + LndscpGR + DistSand + NearestOcc + RegionalCommonness"
    response: "Number (nombre d'interactions observees entre une espece d'abeille et une espece de plante sur un site) ; Occurrence (presence/absence de cette meme interaction, {0,1}) est un second Y publie avec la meme importance -- le papier ajuste 3 modeles RF : classification sur Occurrence, regression sur Occurrence, regression sur Number (Table 2, Section 2.2)"
    predictors: ["RegionalCommonness", "NearestOcc", "BeeDCA1", "BeeDCA2", "BeeDCA3", "BeeDCA4", "Solitary", "PlantFreq", "DCA1", "DCA2", "DCA3", "DCA4", "MASL", "LndscpGR", "LnscpH", "DistSand"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["random_forest", "gamboost", "xgboost"]
    status: "confirmed"

  ml_or_selected:
    formula: "Number ~ DCA1 + DCA2 + DCA3 + DCA4 + BeeDCA1 + BeeDCA2 + BeeDCA3 + BeeDCA4 + Solitary + PlantFreq + MASL + LnscpH + LndscpGR + DistSand + NearestOcc + RegionalCommonness"
    response: "Number"
    predictors: ["DCA1", "DCA2", "DCA3", "DCA4", "BeeDCA1", "BeeDCA2", "BeeDCA3", "BeeDCA4", "Solitary", "PlantFreq", "MASL", "LnscpH", "LndscpGR", "DistSand", "NearestOcc", "RegionalCommonness"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["random_forest", "random_forest_xy", "xgboost", "xgboost_xy"]
    status: "confirmed"
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
- Year: 2022

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Number ~ RegionalCommonness + NearestOcc + BeeDCA1 + BeeDCA2 + BeeDCA3 + BeeDCA4 + Solitary + PlantFreq + DCA1 + DCA2 + DCA3 + DCA4 + MASL + LndscpGR + LnscpH + DistSand [Random Forest, ranger]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Sydenham, Venter, Reitan, Rasmussen, Skrindo, Skoog, Hanevik, Hegland, Dupont, Nielsen, Chipperfield & Rusch (2022), 'MetaComNet: A random forest-based framework for making spatial predictions of plant-pollinator interactions', Methods in Ecology and Evolution 13(3):500-513, DOI 10.1111/2041-210X.13762 (recu 2 septembre 2021, accepte 12 octobre 2021, publie 2022). Table 1-2 documentent exactement les colonnes presentes dans le depot Dryad (10.5061/dryad.n02v6wwzn) : reponses Number/Occurrence par combinaison abeille x plante x site (N=9594=39x44x16, verifie), predicteurs bee/plant/site. Random Forest (Breiman 2001, package ranger via caret) est explicitement la methode publiee, pour 3 strategies de modelisation (classification Occurrence, regression Occurrence, regression Number)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_current_package"
  benchmark_task: "classification_or_count_rf"
  package_include: "no"
  has_local_rds: true
  missing_items: "formule et 16 covariables reelles desormais etablies (verifie 2026-09-10, Table 1-2 du papier) et la fuite de donnees FacOccurrence corrigee -- reste a verifier concretement que la route classification/count du harnais (ajoutee 2026-09-04) fonctionne de bout en bout sur ce Y=Number (compte, plage [0,27], probablement surdisperse/zero-inflate) et sur Y=Occurrence (second Y publie, non modelise ici)"
  reason: "Le papier ajuste 3 modeles Random Forest (Breiman 2001) : classification sur Occurrence, regression sur Occurrence, regression sur Number -- desormais documente avec formule/covariables reelles (voir FORMULA_OVERRIDES). Pas encore promu : verification d'execution de bout en bout non faite pour ce jeu specifique."
```

- Decision: not_ready_current_package
- Manque principal: formule et 16 covariables reelles desormais etablies (verifie 2026-09-10, Table 1-2 du papier) et la fuite de donnees FacOccurrence corrigee -- reste a verifier concretement que la route classification/count du harnais (ajoutee 2026-09-04) fonctionne de bout en bout sur ce Y=Number (compte, plage [0,27], probablement surdisperse/zero-inflate) et sur Y=Occurrence (second Y publie, non modelise ici)
- Raison: Le papier ajuste 3 modeles Random Forest (Breiman 2001) : classification sur Occurrence, regression sur Occurrence, regression sur Number -- desormais documente avec formule/covariables reelles (voir FORMULA_OVERRIDES). Pas encore promu : verification d'execution de bout en bout non faite pour ce jeu specifique.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "not_ready_current_package"
  eligible_estimators: []
  conditionally_eligible_estimators: ["random_forest", "random_forest_xy", "gamboost", "xgboost", "xgboost_xy", "gam_spatial", "sar_probit", "sem_probit"]
  ineligible_reason: "reponse binaire (presence/absence) ; random_forest/gamboost/xgboost/gam_spatial sont des alternatives generiques, sar_probit/sem_probit (ProbitSpatial::ProbitSpatialFit(), ajoute 2026-09-04) sont le moteur spatial dedie -- tous notes conditionnels le temps de verifier au cas par cas qu'une matrice W fiable est constructible sur la geometrie locale (voir Bloc 5 / CRS note) ; ols/sar_lag/sem_error/sdm_mixed/mgwrsar_gwr restent hors de propos (hypothese gaussienne continue)."
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
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
- Spatial resolution: point observation (support reel : incertain : site d'observation ponctuel OU cellule de grille d'occurrence selon la source (voir Observation unit))
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [10.990725, 11.192735], y [60.085292, 60.318768]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32632 (UTM Zone 32N (EPSG:32632)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.n02v6wwzn (checked 2026-09-14): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`metacomnet` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `metacomnet` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - Statut 'resolu' documente et intentionnel (voir Bloc 1 > Statut regression canonique > Note) ; ne pas retraiter sans revue.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`metacomnet` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: MetaComNet: A random forest-based framework for making spatial predictions of plant-pollinator interactions

## Curation documentée — 2026-09-07

La formule systeme enumere les 17 covariables deja declarees dans Candidate X variables et presentes dans le RDS. L’ancienne ellipse etait un defaut du rendu; cette liste demeure une proposition systeme, sans preuve de specification publiee et sans promotion. Sa pertinence scientifique reste en revue.

Typologie de la reponse selectionnee : count. Number est un comptage; Occurrence est une autre reponse binaire.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
