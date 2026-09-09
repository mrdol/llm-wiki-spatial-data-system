---
title: paper_harbour_porpoise_response
type: dataset
created: 2026-08-15
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_harbour_porpoise_response.rds
  - DataCite_2019_HarbourPorpoiseResponsesTo_10_1098_rsos_190
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Harbour porpoise responses to pile-driving diminish over time" (DOI 10.1098/rsos.190335).

## Description du jeu de donnees

- Topic: Donnees de paper-derived : paper_harbour_porpoise_response
- Observation unit: observation spatiale du dataset "Data from: Harbour porpoise responses to pile-driving diminish over time"
- Observed population: RÃ©ponses comportementales de marsouins au bruit de battage de pieux ; dÃ©tecteurs d'Ã©cholocation et enregistreurs de bruit avec coordonnÃ©es spatiales ; rÃ©gression pour probabilitÃ© de rÃ©ponse en fonction de la distance ; 75 citations
- Geographic context: etendue sf: x [-3.955967, -2.6177], y [57.8164, 58.33725]
- Temporal context: none (cross-sectional)
- Source description: Harbour porpoise responses to pile-driving diminish over time
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1098/rsos.190335
- Dataset DOI: 10.5061/dryad.5qg30sd
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.5qg30sd
- Local raw dir: `data/raw/papers/DataCite_2019_HarbourPorpoiseResponsesTo_10_1098_rsos_190/`
- Local sf output: `data/final_datasets/sf/paper_harbour_porpoise_response.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `prop24`, `prop12`, `resp24_50`, `resp12_50`
- Candidate Y typology: continuous, binary
- Candidate X variables in local artifact: `dph24`, `dph12`, `base24`, `base12`, `distance`, `vessels24_1km`, `vessels12_1km`, `vessels24_500m`, `vessels12_500m`, `duration`, `piling_order`, `Unweighted_SS_SEL`, `NOAA_SS_SEL`, `Southall_SS_SEL`, `Aud_SS_SEL`
- Candidate X count in local artifact: 15
- Candidate X typology: continuous
- Published X variables from paper: distance, received sound exposure level, cumulative piling order, ADD use, piling duration, vessel activity
- Published X count: 6
- Coordinates (x, y - excluded from X candidates): `Longitude`, `Latitude`
- Identifier columns (excluded from X candidates): `dep_no`, `turbine`, `location`, `pod`, `POD_number`, `Location_ID`, `ADD`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `prop24` | `numeric` | continuous | [-1, 6] | 0% |
| `prop12` | `numeric` | continuous | [-1, Inf] | 2.1% |
| `resp24_50` | `integer` | binary | {0, 1} | 0% |
| `resp12_50` | `integer` | binary | {0, 1} | 2.1% |

> Selection Y/X (paper-loader / curated evidence) : Pour `harbour_porpoise_response`, la ou les reponses `prop24`, `prop12`, `resp24_50`, `resp12_50` viennent du loader papier et/ou des preuves de l article `Harbour porpoise responses to pile-driving diminish over time`. Les covariables X retenues sont `distance`, `vessels24_1km`, `duration`, `piling_order`, `Unweighted_SS_SEL`, `NOAA_SS_SEL`, `Southall_SS_SEL`, `Aud_SS_SEL` ; 7 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Longitude`, `Latitude`), identifiants (`dep_no`, `turbine`, `location`, `pod`, `POD_number`, `Location_ID`, `ADD`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : manual_review; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `dph24` | `integer` | count | 0% |
| `dph12` | `integer` | count | 0% |
| `base24` | `integer` | count | 0% |
| `base12` | `integer` | count | 0% |
| `distance` | `numeric` | continuous | 0% |
| `vessels24_1km` | `integer` | count | 0% |
| `vessels12_1km` | `integer` | count | 0% |
| `vessels24_500m` | `integer` | count | 0% |
| `vessels12_500m` | `integer` | count | 0% |
| `duration` | `numeric` | continuous | 0% |
| `piling_order` | `integer` | count | 0% |
| `Unweighted_SS_SEL` | `numeric` | continuous | 0% |
| `NOAA_SS_SEL` | `numeric` | continuous | 0% |
| `Southall_SS_SEL` | `numeric` | continuous | 0% |
| `Aud_SS_SEL` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: response_24h ~ log(distance_to_piling) * cumulative_piling_order + received_SEL + ADD + piling_duration + vessel_activity + random_effect(CPOD_site/POD) [binomial probit GLMM]
- x_terms_pub: distance, received sound exposure level, cumulative piling order, ADD use, piling duration, vessel activity
- y_term_pub: binary behavioural response and proportional DPH change after piling
- Reference publication: Graham et al. (2019), Royal Society Open Science, DOI 10.1098/rsos.190335: Material and methods model binary response with probit GLMM; distance/log distance and received SEL are used in separate models, with cumulative piling order, ADD, duration and vessel activity. CORRECTION (2026-09-09) : cette fiche indiquait a tort que le benchmark utilise `prop24` (variable continue) -- verification directe du RDS confirme que `formula_used` utilise en realite `resp24_50` (reponse binaire, seuil a 50%), coherent avec le modele probit binaire reellement publie par le papier (`prop24` existe aussi dans le RDS mais n'est pas la reponse retenue ici).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: resp24_50 ~ log(distance) * piling_order + vessels24_1km
- Formula used evidence: paper_extracted
- Recommended validation: N lignes=700; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=600. Grouper les observations du meme site/immeuble/individu dans un seul fold (cle loc_pod = location x CPOD, cf. code source des auteurs), et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.
- benchmark_task_note: Correction du 2026-09-07 -- le code source des auteurs (`Graham_BOWL_cMMMP_R_code_to_analyse_porpoise_responses_2019-05-01.R`, fourni avec le depot Dryad) montre que le papier ne modelise JAMAIS prop24 en continu : les 3 modeles 24h publies sont tous des GLMM probit binaires sur resp24_50 (m8_24, m7nz_24, m14nz_24), effet aleatoire (1|loc_pod). m8_24 (AIC=619.39) est le meilleur des 3 et correspond exactement a N=700 (variante "18 locations" du code source). formula_used reprend donc verbatim m8_24 : `resp24_50 ~ log(distance)*zorder + zvessels_1km + (1|loc_pod)`, ecrit ici sans standardisation z-score (zorder/zvessels_1km sont piling_order/vessels24_1km centres-reduits, memes variables) et sans l'effet aleatoire (non supporte par le harnais de regression actuel).
- Selected Y evidence: resp24_50 est la reponse effectivement modelisee par les auteurs (glmer probit, m8_24, AIC le plus bas des 3 variantes 24h) ; prop24 n'est qu'une colonne de donnees brutes utilisee pour construire le seuil binaire (>= -0.50 de variation = reponse), jamais regressee directement dans le papier.
- Selected Y typology: binary
- x_terms_used: distance, piling_order, vessels24_1km
- y_term_used: resp24_50
- Note: Formule verifiee verbatim par lecture directe du code R des auteurs (session du 2026-09-07), corrigeant la formule generee par le systeme (session du 2026-08-15) qui utilisait a tort prop24 en continu.

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
    formula: "resp24_50 ~ log(distance) * piling_order + vessels24_1km"
    response: "resp24_50"
    predictors: ["distance", "piling_order", "vessels24_1km"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Graham et al. (2019), Royal Society Open Science, DOI 10.1098/rsos.190335 -- verbatim m8_24 dans Graham_BOWL_cMMMP_R_code_to_analyse_porpoise_responses_2019-05-01.R (AIC=619.39, meilleur des 3 modeles 24h)."
    estimator_context: ["sar_probit", "sem_probit", "gam_spatial", "random_forest", "xgboost"]
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

- Dataset ID: `paper_harbour_porpoise_response`
- Dataset name: Data from: Harbour porpoise responses to pile-driving diminish over time
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Harbour porpoise responses to pile-driving diminish over time
- Paper DOI: 10.1098/rsos.190335
- Dataset DOI: 10.5061/dryad.5qg30sd
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.5qg30sd
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "response_24h ~ log(distance_to_piling) * cumulative_piling_order + received_SEL + ADD + piling_duration + vessel_activity + random_effect(CPOD_site/POD) [binomial probit GLMM]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Graham et al. (2019), Royal Society Open Science, DOI 10.1098/rsos.190335: Material and methods model binary response with probit GLMM; distance/log distance and received SEL are used in separate models, with cumulative piling order, ADD, duration and vessel activity. The current regression benchmark uses the continuous proportional 24h DPH change prop24 from the same response table, joined to CPOD coordinates."
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
    - estimator: sar_probit
      basis: scientific_evidence
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Probit mentionne dans la source (approxime par sar_probit/sem_probit)."
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
- N observations: 700
- k variables: 30
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-3.955967, -2.6177], y [57.8164, 58.33725]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32630 (UTM Zone 30N (EPSG:32630)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.5qg30sd (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`harbour_porpoise_response` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `harbour_porpoise_response` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`harbour_porpoise_response` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Note -- promotion en lot (2026-09-09)

Formule, reponse et covariables deja resolues (Y/X/formula_used complets avant cette passe). Seul le bloc 'Estimator eligibility' etait vide -- rempli ici avec les estimateurs generiques adaptes a la typologie Y (binary), sur decision explicite de l'utilisateur de revoir en lot les fiches 'manual_review' deja completes. Base 'scientific_evidence' reservee aux cas ou le texte de la fiche documente deja une methode precise ; sinon 'benchmark_use'/'generated_candidate' (pas de surinterpretation de la methode publiee).

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Harbour porpoise responses to pile-driving diminish over time

## Curation documentée — 2026-09-07

Correction (2026-09-07, mode production de repli) : la formule anterieure etait une adaptation continue (prop24) generee par le systeme, distincte des modeles reellement publies. Lecture du code source des auteurs (`Graham_BOWL_cMMMP_R_code_to_analyse_porpoise_responses_2019-05-01.R`, distribue avec le depot Dryad DOI 10.5061/dryad.5qg30sd) : les auteurs ne regressent jamais prop24 en continu ; leurs 3 modeles 24h publies sont des GLMM probit binaires sur resp24_50, effet aleatoire (1|loc_pod). formula_used reprend desormais verbatim le meilleur des trois (m8_24, AIC=619.39) : `resp24_50 ~ log(distance) * piling_order + vessels24_1km`. formula_status passe de generated_system_formula a paper_extracted.

Le nom paper_harbour_porpoise_decline dans la demande correspond a cette fiche existante paper_harbour_porpoise_response; aucun doublon cree.

Decision conservatoire : N lignes=700; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=600. Grouper les observations du meme site/immeuble/individu dans un seul fold (cle loc_pod), et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. La fiche et les donnees sont conservees ; aucune promotion package_include automatique (reponse desormais binaire -- necessite verification du bloc benchmark_readiness/estimator_eligibility avant toute promotion, voir CLAUDE.md mode production de repli).

Typologie de la reponse selectionnee : binary (resp24_50, corrige le 2026-09-07 -- anciennement continuous/prop24, jamais modelise ainsi par les auteurs).

Provenance des corrections : audit du 2026-09-07, inspection du RDS, du code source R des auteurs, et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
