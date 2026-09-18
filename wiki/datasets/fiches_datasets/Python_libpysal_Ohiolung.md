---
title: Python_libpysal_Ohiolung
type: dataset
created: 2026-08-15
updated: 2026-09-18
sources:
  - data/final_datasets/sf/Python_libpysal_Ohiolung.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `libpysal` (`Ohiolung`).

## Description du jeu de donnees

- Topic: sante publique / epidemiologie spatiale
- Observation unit: individu, cas sanitaire ou unite spatiale de sante
- Observed population: population sanitaire documentee par le package source
- Geographic context: Etendue mesuree dans le RDS : x [-84.644041, -80.740437], y [38.626084, 41.781077]; CRS EPSG:4326 (corrige le 2026-09-18 -- correspond maintenant a la vraie etendue geographique de l'Ohio (USA), voir Bloc 5 > CRS note).
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `libpysal` (`Ohiolung`).
- Description source: package Python `libpysal`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `LM68`, `LF68`, `LM78`, `LF78`, `LM88`, `LF88`
- Candidate Y typology: count
- Candidate X variables: `AREA`, `POPM68`, `POPF68`, `POPM78`, `POPF78`, `POPM88`, `POPF88`, `LMW68`, `LMB68`, `LFW68`, `LFB68`, `LMW78`, `LMB78`, `LFW78`, `LFB78`, `LMW88`, `LMB88`, `LFW88`, `LFB88`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `RECORD_ID`, `COUNTYID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown
- Note complementaire (2026-09-17) : le modele publie (Xia & Carlin 1998) necessite 3 covariables externes absentes de cet artefact (proportion de fumeurs, densite de population, revenu par habitant) ainsi qu'une decomposition par tranche d'age pour l'age-standardisation -- voir Reference publication.

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `LM68` | `integer` | count | [1, 522] | 0% |
| `LF68` | `integer` | count | [0, 111] | 0% |
| `LM78` | `integer` | count | [3, 580] | 0% |
| `LF78` | `integer` | count | [0, 201] | 0% |
| `LM88` | `integer` | count | [2, 641] | 0% |
| `LF88` | `integer` | count | [1, 352] | 0% |

> Selection Y/X (claude-sonnet-4-6) : Ce dataset porte sur la mortalité pulmonaire (lung cancer) par comté de l'Ohio : les colonnes LM*/LF* représentent les décès (males/females) pour 1968, 1978, 1988 et sont les cibles naturelles, tandis que les populations de référence (POPM*, POPF*, POPMW*, etc.), la superficie (AREA) et les sous-groupes de décès par race/sexe constituent des covariables explicatives pertinentes. FIPSNO, NAME et PERIMETER sont ignorés car purement administratifs ou géométriques.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `AREA` | `integer` | count | 0% |
| `POPM68` | `integer` | count | 0% |
| `POPF68` | `integer` | count | 0% |
| `POPM78` | `integer` | count | 0% |
| `POPF78` | `integer` | count | 0% |
| `POPM88` | `integer` | count | 0% |
| `POPF88` | `integer` | count | 0% |
| `LMW68` | `integer` | count | 0% |
| `LMB68` | `integer` | count | 0% |
| `LFW68` | `integer` | count | 0% |
| `LFB68` | `integer` | count | 0% |
| `LMW78` | `integer` | count | 0% |
| `LMB78` | `integer` | count | 0% |
| `LFW78` | `integer` | count | 0% |
| `LFB78` | `integer` | count | 0% |
| `LMW88` | `integer` | count | 0% |
| `LMB88` | `integer` | count | 0% |
| `LFW88` | `integer` | count | 0% |
| `LFB88` | `integer` | count | 0% |

### Formule — niveau publication

- formula_pub: C*_ijk ~ Poisson(E_ijk*exp(eta_ijk)), eta_ijk = alpha + beta*sexe + gamma*race + delta*sexe*race + theta*smoking + kappa*urban + lambda*SES + effet_CAR + heterogeneite [modele bayesien hierarchique spatio-temporel, erreurs sur covariables, MCMC]
- x_terms_pub: sexe, race, sexe*race, proportion de fumeurs (enquete externe), densite de population (externe), revenu par habitant (externe), effets aleatoires CAR + heterogeneite
- y_term_pub: deces par cancer du poumon age-ajustes, par comte/sexe/race/annee (1968, 1978, 1988)
- Reference publication: Xia, H. & Carlin, B.P. (1998), 'Spatio-temporal models with errors in covariates: mapping Ohio lung cancer mortality', Statistics in Medicine 17(18), 2025-2043, DOI 10.1002/(SICI)1097-0258(19980930)17:18<2025::AID-SIM865>3.0.CO;2-M (texte integral verifie via corpus/papers/tei/SPATIOTEMPORAL MODELS WITH ERRORS IN COVARIATES_OHIO LUNG CANCER DATA.tei.xml, deja disponible localement). Modele (eq. 1-2) : C*_ijk ~ Poisson(E_ijk * exp(eta_ijk)), eta_ijk = alpha + beta*s_j + gamma*r_k + delta*s_j*r_k + theta*q_i + kappa*u_i + lambda*v_i + phi_i + psi_i, ou s_j=sexe, r_k=race, q_i=proportion de fumeurs actuels (enquete telephonique Ohio BRFSS 1988-1994, PAS dans cet artefact local), u_i=densite de population 1992 (proxy urbain, PAS dans cet artefact), v_i=revenu par habitant 1989 (proxy SES, PAS dans cet artefact), phi_i=effet CAR spatial, psi_i=heterogeneite non structuree. Ajuste par MCMC (Gibbs-Metropolis), pas par une regression fermee. Coefficients publies (95% credible sets) : beta in [-1.14,-0.98], gamma in [0.07,0.28], delta in [-0.37,-0.01]. C*_ijk = deces AGE-AJUSTES (via 11 tranches d'age, Table I) -- cette decomposition par age n'existe PAS dans cet artefact (LM68/LF68 etc. sont deja agreges tous ages confondus).

### Statut regression canonique

- Statut: mis de cote
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee -- necessite covariables externes absentes de cet artefact et un estimateur bayesien CAR/erreurs-sur-covariables (MCMC) sans equivalent dans le harnais
- Correspondance Python/R: aucune identifiee
- Note: Modele identifie et verifie via lecture integrale du texte (deja disponible localement). Contrairement a d'autres fiches de ce lot (police, pennLC_sf, wallace.iowaland), ce modele necessite (1) trois covariables externes non presentes dans l'artefact package (proportion de fumeurs issue d'une enquete telephonique 1988-1994, densite de population 1992, revenu par habitant 1989), (2) une decomposition par tranche d'age absente de cet artefact (les colonnes LM*/LF* sont deja agregees tous ages), et (3) un estimateur bayesien hierarchique CAR avec erreurs sur covariables ajuste par MCMC, sans equivalent dans le harnais actuel. DECISION : mis de cote plutot que resolu -- necessiterait un chantier d'ingestion de donnees externes et d'extension du harnais.

### Formule — niveau systeme

- formula_used: LM68 ~ AREA + POPM68 + POPF68 + POPM78 + POPF78 + POPM88 + POPF88 + LMW68
- Formula used evidence: generated_system_formula -- combinaison non testee par les auteurs, sans lien avec le modele publie (voir formula_pub).
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: count
- x_terms_used: AREA + POPM68 + POPF68 + POPM78 + POPF78 + POPM88 + POPF88 + LMW68
- y_term_used: LM68

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
    formula: "C*_ijk ~ Poisson(E_ijk*exp(eta_ijk)), eta_ijk = alpha + beta*sexe + gamma*race + delta*sexe*race + theta*smoking + kappa*urban + lambda*SES + CAR + heterogeneite"
    response: "deces cancer du poumon age-ajustes par comte/sexe/race/annee"
    predictors: ["sexe", "race", "sexe*race", "smoking (externe)", "urban (externe)", "SES (externe)", "effet_CAR", "heterogeneite"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Xia, H. & Carlin, B.P. (1998), 'Spatio-temporal models with errors in covariates: mapping Ohio lung cancer mortality', Statistics in Medicine 17(18), 2025-2043, DOI 10.1002/(SICI)1097-0258(19980930)17:18<2025::AID-SIM865>3.0.CO;2-M (texte integral verifie via corpus/papers/tei/SPATIOTEMPORAL MODELS WITH ERRORS IN COVARIATES_OHIO LUNG CANCER DATA.tei.xml, deja disponible localement). Modele (eq. 1-2) : C*_ijk ~ Poisson(E_ijk * exp(eta_ijk)), eta_ijk = alpha + beta*s_j + gamma*r_k + delta*s_j*r_k + theta*q_i + kappa*u_i + lambda*v_i + phi_i + psi_i, ou s_j=sexe, r_k=race, q_i=proportion de fumeurs actuels (enquete telephonique Ohio BRFSS 1988-1994, PAS dans cet artefact local), u_i=densite de population 1992 (proxy urbain, PAS dans cet artefact), v_i=revenu par habitant 1989 (proxy SES, PAS dans cet artefact), phi_i=effet CAR spatial, psi_i=heterogeneite non structuree. Ajuste par MCMC (Gibbs-Metropolis), pas par une regression fermee. Coefficients publies (95% credible sets) : beta in [-1.14,-0.98], gamma in [0.07,0.28], delta in [-0.37,-0.01]. C*_ijk = deces AGE-AJUSTES (via 11 tranches d'age, Table I) -- cette decomposition par age n'existe PAS dans cet artefact (LM68/LF68 etc. sont deja agreges tous ages confondus)."
    estimator_context: ["bayesian_hierarchical_CAR_errors_in_covariates (aucun equivalent dans le harnais actuel)"]
    status: "confirmed"
    note: "Modele reel et verifie mais non executable sur cet artefact : covariables externes manquantes (smoking/urban/SES), decomposition par age manquante, et estimateur MCMC bayesien complexe absent du harnais."

  ml_or_selected:
    formula: "LM68 ~ AREA + POPM68 + POPF68 + POPM78 + POPF78 + POPM88 + POPF88 + LMW68 + LMB68 + LFW68 + LFB68 + LMW78 + LMB78 + LFW78 + LFB78 + LMW88 + LMB88 + LFW88 + LFB88"
    response: "LM68"
    predictors: ["AREA", "POPM68", "POPF68", "POPM78", "POPF78", "POPM88", "POPF88", "LMW68", "LMB68", "LFW68", "LFB68", "LMW78", "LMB78", "LFW78", "LFB78", "LMW88", "LMB88", "LFW88", "LFB88"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "Ajoute le 2026-09-17 (nouvelle pratique standard pour les fiches a plus de 10 X : proposer une formule ML/boosting exploitant toutes les covariables disponibles pour selection automatique). Note : LMW68/LFW68/etc. sont des sous-composantes partielles de LM68/LF68 (par race) -- fuite partielle potentielle si LM68 = LMW68+LMB68 exactement ; a verifier avant usage strict, mais conserve ici car ce sont les seules covariables reellement disponibles au-dela de AREA/POP."
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_libpysal_Ohiolung`
- Dataset name: libpysal::Ohiolung
- Source family: python-package
- Source: package Python `libpysal`
- Source URL: https://pypi.org/project/libpysal/
- Dataset DOI: none
- Publication DOI: pending
- Year: 2017

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): cartographie de risque de maladie (disease mapping) spatio-temporel
- Modele niveau 2 (famille): modele hierarchique bayesien Poisson avec erreurs sur covariables (errors-in-covariates), CAR spatial + heterogeneite non structuree
- Modele niveau 3 (variante): ajustement MCMC (Gibbs-Metropolis), effets fixes sexe/race/interaction + covariables externes (smoking/urban/SES) centrees

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "C*_ijk ~ Poisson(E_ijk*exp(eta_ijk)), eta_ijk = alpha + beta*s_j + gamma*r_k + delta*s_j*r_k + theta*q_i + kappa*u_i + lambda*v_i + phi_i + psi_i"
  equation_family: bayesian_hierarchical_count_spatiotemporal_errors_in_covariates
  model_family: "Poisson-CAR bayesien avec erreurs sur covariables (aucun estimateur equivalent dans le harnais actuel)"
  source_type: scientific_publication
  source_ref: "Xia, H. & Carlin, B.P. (1998), 'Spatio-temporal models with errors in covariates: mapping Ohio lung cancer mortality', Statistics in Medicine 17(18), 2025-2043, DOI 10.1002/(SICI)1097-0258(19980930)17:18<2025::AID-SIM865>3.0.CO;2-M (texte integral verifie via corpus/papers/tei/SPATIOTEMPORAL MODELS WITH ERRORS IN COVARIATES_OHIO LUNG CANCER DATA.tei.xml, deja disponible localement). Modele (eq. 1-2) : C*_ijk ~ Poisson(E_ijk * exp(eta_ijk)), eta_ijk = alpha + beta*s_j + gamma*r_k + delta*s_j*r_k + theta*q_i + kappa*u_i + lambda*v_i + phi_i + psi_i, ou s_j=sexe, r_k=race, q_i=proportion de fumeurs actuels (enquete telephonique Ohio BRFSS 1988-1994, PAS dans cet artefact local), u_i=densite de population 1992 (proxy urbain, PAS dans cet artefact), v_i=revenu par habitant 1989 (proxy SES, PAS dans cet artefact), phi_i=effet CAR spatial, psi_i=heterogeneite non structuree. Ajuste par MCMC (Gibbs-Metropolis), pas par une regression fermee. Coefficients publies (95% credible sets) : beta in [-1.14,-0.98], gamma in [0.07,0.28], delta in [-0.37,-0.01]. C*_ijk = deces AGE-AJUSTES (via 11 tranches d'age, Table I) -- cette decomposition par age n'existe PAS dans cet artefact (LM68/LF68 etc. sont deja agreges tous ages confondus)."
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 88
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-84.6440, -80.7404], y [38.6261, 41.7811] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT (source native : POLYGON, preservee dans `geom_origine` ; geometrie active derivee via `st_point_on_surface()` ou equivalent, methodologie documentee dans code/r_catalog/guide_objets_sf.md section 3-5 -- rien n'est perdu, correction 2026-09-16 apres verification via tools/verify_fiche_crs.py)
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32617 (UTM Zone 17N (EPSG:32617)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement (corrige le 2026-09-18, voir CRS note)

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/libpysal/
- License open: yes
- Reproducibility status: available via package Python `libpysal`
- Code available: yes (package examples and vignettes)
- Repository: python-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "manual_review"
  benchmark_task: "regression_spatiotemporal_bayesian_errors_in_covariates"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "Modele publie identifie et verifie le 2026-09-17 (Xia & Carlin 1998, Statistics in Medicine, DOI verifie, texte integral lu localement -- deja dans corpus/papers/). package_include reste 'manual_review' (pas 'yes') : le modele reel necessite 3 covariables externes absentes du package (smoking, densite urbaine, revenu par habitant), une decomposition par age absente de cet artefact agrege, et un estimateur bayesien CAR/erreurs-sur-covariables (MCMC) sans equivalent dans le harnais. Mis de cote, comme paper_bumblebee_colony_reproduction et paper_medicago."
  reason: "Modele publie identifie et verifie le 2026-09-17 (Xia & Carlin 1998, Statistics in Medicine, DOI verifie, texte integral lu localement -- deja dans corpus/papers/). package_include reste 'manual_review' (pas 'yes') : le modele reel necessite 3 covariables externes absentes du package (smoking, densite urbaine, revenu par habitant), une decomposition par age absente de cet artefact agrege, et un estimateur bayesien CAR/erreurs-sur-covariables (MCMC) sans equivalent dans le harnais. Mis de cote, comme paper_bumblebee_colony_reproduction et paper_medicago."
```

- Decision: manual_review
- Manque principal: Modele publie identifie et verifie le 2026-09-17 (Xia & Carlin 1998, Statistics in Medicine, DOI verifie, texte integral lu localement -- deja dans corpus/papers/). package_include reste 'manual_review' (pas 'yes') : le modele reel necessite 3 covariables externes absentes du package (smoking, densite urbaine, revenu par habitant), une decomposition par age absente de cet artefact agrege, et un estimateur bayesien CAR/erreurs-sur-covariables (MCMC) sans equivalent dans le harnais. Mis de cote, comme paper_bumblebee_colony_reproduction et paper_medicago.
- Raison: Modele publie identifie et verifie le 2026-09-17 (Xia & Carlin 1998, Statistics in Medicine, DOI verifie, texte integral lu localement -- deja dans corpus/papers/). package_include reste 'manual_review' (pas 'yes') : le modele reel necessite 3 covariables externes absentes du package (smoking, densite urbaine, revenu par habitant), une decomposition par age absente de cet artefact agrege, et un estimateur bayesien CAR/erreurs-sur-covariables (MCMC) sans equivalent dans le harnais. Mis de cote, comme paper_bumblebee_colony_reproduction et paper_medicago.

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `libpysal`

## Curation documentée — 2026-09-07

Typologie de la reponse selectionnee : count. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "Modele publie identifie et verifie (Xia & Carlin 1998, DOI verifie, texte integral lu localement) mais non executable sur cet artefact : (1) necessite 3 covariables externes absentes du package (proportion de fumeurs issue d'une enquete telephonique Ohio BRFSS 1988-1994, densite de population 1992, revenu par habitant 1989) ; (2) necessite une decomposition par tranche d'age pour l'age-standardisation, absente des colonnes agregees LM*/LF* ; (3) estimateur bayesien hierarchique CAR avec erreurs sur covariables (MCMC Gibbs-Metropolis), sans equivalent dans le harnais actuel (different de inla_bym : ici les covariables elles-memes sont modelisees avec erreur de mesure, pas seulement l'effet spatial). Chantier necessaire : ingestion des 3 covariables externes + nouvel estimateur bayesien."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Curation documentée — 2026-09-17

Recherche du 2026-09-17 (suite a un echange avec un autre agent IA ayant identifie Xia & Carlin 1997/1998). DOI verifie via Crossref, texte integral deja disponible localement et lu en entier. Xia, H. & Carlin, B.P. (1998), 'Spatio-temporal models with errors in covariates: mapping Ohio lung cancer mortality', Statistics in Medicine 17(18), 2025-2043, DOI 10.1002/(SICI)1097-0258(19980930)17:18<2025::AID-SIM865>3.0.CO;2-M (texte integral verifie via corpus/papers/tei/SPATIOTEMPORAL MODELS WITH ERRORS IN COVARIATES_OHIO LUNG CANCER DATA.tei.xml, deja disponible localement). Modele (eq. 1-2) : C*_ijk ~ Poisson(E_ijk * exp(eta_ijk)), eta_ijk = alpha + beta*s_j + gamma*r_k + delta*s_j*r_k + theta*q_i + kappa*u_i + lambda*v_i + phi_i + psi_i, ou s_j=sexe, r_k=race, q_i=proportion de fumeurs actuels (enquete telephonique Ohio BRFSS 1988-1994, PAS dans cet artefact local), u_i=densite de population 1992 (proxy urbain, PAS dans cet artefact), v_i=revenu par habitant 1989 (proxy SES, PAS dans cet artefact), phi_i=effet CAR spatial, psi_i=heterogeneite non structuree. Ajuste par MCMC (Gibbs-Metropolis), pas par une regression fermee. Coefficients publies (95% credible sets) : beta in [-1.14,-0.98], gamma in [0.07,0.28], delta in [-0.37,-0.01]. C*_ijk = deces AGE-AJUSTES (via 11 tranches d'age, Table I) -- cette decomposition par age n'existe PAS dans cet artefact (LM68/LF68 etc. sont deja agreges tous ages confondus). Modele reel, sourced et verifie, mais explicitement mis de cote (pas 'resolu') car il necessite des donnees externes et un estimateur bayesien absents du perimetre actuel du harnais.

## Curation documentée — 2026-09-18

Correction CRS (2026-09-18) : le point actif de ce jeu etait corrompu par un CRS_OVERRIDES obsolete dans code/r_catalog/build_sf_datasets.R, qui assumait (a raison, historiquement) que le GeoJSON source etait en coordonnees projetees et lui appliquait une reinterpretation UTM/State Plane + reprojection. Verification directe (2026-09-18) du GeoJSON source actuellement telecharge par le pipeline (data/downloads/software/python_datasets/geojson/) montre qu'il est desormais deja correctement declare en CRS84 (WGS84) avec de vraies coordonnees en degres -- la source a du etre re-telechargee/normalisee depuis l'ecriture de cette table, sans que la table de correction soit mise a jour en consequence. Appliquer l'ancienne correction a des degres deja corrects les reinterpretait comme des metres, produisant un point degenere (x[-85.49,-85.49] y[0.0003,0.0004]). Retire de CRS_OVERRIDES le 2026-09-18 ; jeu reconstruit sans transformation (deja geographique, aucune correction necessaire). Nouvelle etendue verifiee : correspond exactement a l'Ohio (USA). Meme classe de bug que celle trouvee et corrigee le meme jour sur Baltimore/eire, mais avec une cause differente (source changee sous le pipeline, pas un CRS jamais documente).
