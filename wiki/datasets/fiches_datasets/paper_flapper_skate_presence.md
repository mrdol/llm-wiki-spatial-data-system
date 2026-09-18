---
title: paper_flapper_skate_presence
type: dataset
created: 2026-09-14
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_flapper_skate_presence.rds
  - DataCite_2025_OnTheBrinkMapping_10_1002_ece3_716
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "On the Brink: Mapping the Last Strongholds of the Critically Endangered Flapper Skate ( Dipturus intermedius )" (DOI 10.1002/ece3.71650).

## Description du jeu de donnees

- Topic: Donnees de paper-derived : paper_flapper_skate_presence
- Observation unit: observation spatiale du dataset "Data from: On the brink: Mapping the last strongholds of the critically endangered flapper skate ( Dipturus intermedius )"
- Observed population: Ã‰cologie marine spatiale : distribution flapper skate, Bayesian spatial binomial GAMM, covariables environnementales, pression de pÃªche, coordonnÃ©es gÃ©ographiques
- Geographic context: etendue sf: x [-14.908, 10.0467], y [48.21, 61.8933]
- Temporal context: none (cross-sectional)
- Source description: On the Brink: Mapping the Last Strongholds of the Critically Endangered Flapper Skate ( Dipturus intermedius )
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1002/ece3.71650
- Dataset DOI: 10.5061/dryad.w0vt4b954
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.w0vt4b954
- Local raw dir: `data/raw/papers/DataCite_2025_OnTheBrinkMapping_10_1002_ece3_716/`
- Local sf output: `data/final_datasets/sf/paper_flapper_skate_presence.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `present_01`
- Candidate Y typology: binary
- Candidate X variables in local artifact: `haul_dur`, `present`, `current`, `dcoast`, `bath`, `btemp`, `xm`, `ym`, `xkm`, `ykm`, `fishing_hours`, `pp_mean`
- Candidate X count in local artifact: 12
- Candidate X typology: unknown, categorical, continuous
- Published X variables from paper: bath, dcoast, current, pp_mean, fishing_hours
- Published X count: 5
- Coordinates (x, y - excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): `survey`, `ship`, `year`, `quarter`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `present_01` | `integer` | binary | {0, 1} | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `flapper_skate_presence`, la ou les reponses `present_01` viennent du loader papier et/ou des preuves de l article `On the Brink: Mapping the Last Strongholds of the Critically Endangered Flapper Skate ( Dipturus intermedius )`. Les covariables X retenues sont `bath`, `dcoast`, `current`, `pp_mean`, `fishing_hours` ; 7 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`lon`, `lat`), identifiants (`survey`, `ship`, `year`, `quarter`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `haul_dur` | `integer` | unknown | 0% |
| `present` | `integer` | binary | 0% |
| `current` | `numeric` | rate | 0% |
| `dcoast` | `numeric` | continuous | 0% |
| `bath` | `integer` | unknown | 0% |
| `btemp` | `numeric` | continuous | 0% |
| `xm` | `numeric` | continuous | 0% |
| `ym` | `numeric` | continuous | 0% |
| `xkm` | `numeric` | continuous | 0% |
| `ykm` | `numeric` | continuous | 0% |
| `fishing_hours` | `numeric` | continuous | 0% |
| `pp_mean` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: presence_absence ~ depth + distance_to_coast + current + benthic_productivity + fishing_pressure [INLA/SPDE presence-absence model with cloglog link, champ spatial SPDE explicite]
- x_terms_pub: bath, dcoast, current, pp_mean, fishing_hours
- y_term_pub: flapper skate presence/absence by survey haul
- Reference publication: Loca, Collins, Garbett, McGeady, Thorburn & McGonigle (2025) (auteurs corriges le 2026-09-14 -- verifies via le TEI local Loca2025OnThe.tei.xml et Crossref ; l'attribution anterieure 'Bacheler et al.' etait fausse, aucun auteur de ce nom ne figure sur le papier), Ecology and Evolution, DOI 10.1002/ece3.71650; Dryad 10.5061/dryad.w0vt4b954. The README and model_script.R provide full_dataset.csv with haul-level flapper skate presence/absence, lon/lat, bathymetry, distance to coast, current, bottom temperature, benthic productivity and fishing pressure. Le papier ajuste un modele INLA/SPDE (champ aleatoire spatial explicite, lien cloglog). Correction (2026-09-08, lecture TEI approfondie, Loca2025OnThe.tei.xml) : btemp (bottom temperature) a ete RETIRE par les auteurs de leur modele final pour cause de colinearite ("bottom temperature was dropped from the analysis"). formula_used/x_terms_used/formula_pub corriges pour ne plus inclure btemp, qui restait a tort dans la specification executable malgre son exclusion documentee par le papier. La colonne btemp reste disponible dans Detail X (candidate non retenue).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

### Formule - niveau systeme

- formula_used: present_01 ~ bath + dcoast + current + pp_mean + fishing_hours
- License evidence: DataCite API record for DOI 10.5061/dryad.w0vt4b954 (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: binary
- x_terms_used: bath, dcoast, current, pp_mean, fishing_hours
- y_term_used: present_01
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
    formula: "present_01 ~ bath + dcoast + current + pp_mean + fishing_hours"
    response: "flapper skate presence/absence by survey haul"
    predictors: ["bath", "dcoast", "current", "pp_mean", "fishing_hours"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["random_forest", "gamboost", "xgboost"]
    status: "confirmed"

  ml_or_selected:
    formula: "present_01 ~ bath + dcoast + current + pp_mean + fishing_hours"
    response: "present_01"
    predictors: ["bath", "dcoast", "current", "pp_mean", "fishing_hours"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["random_forest", "xgboost", "gamboost"]
    status: "executable_binary_sdm_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_flapper_skate_presence`
- Dataset name: Data from: On the brink: Mapping the last strongholds of the critically endangered flapper skate ( Dipturus intermedius )
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: On the Brink: Mapping the Last Strongholds of the Critically Endangered Flapper Skate ( Dipturus intermedius )
- Paper DOI: 10.1002/ece3.71650
- Dataset DOI: 10.5061/dryad.w0vt4b954
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.w0vt4b954
- Year: 2025 (annee de depot Dryad/DataCite, non verifiee comme annee de publication de l'article -- voir Reference publication)

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "presence_absence ~ depth + distance_to_coast + current + benthic_productivity + fishing_pressure [INLA/SPDE presence-absence model with cloglog link, champ spatial SPDE explicite]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Loca, Collins, Garbett, McGeady, Thorburn & McGonigle (2025) (auteurs corriges le 2026-09-14 -- verifies via le TEI local Loca2025OnThe.tei.xml et Crossref ; l'attribution anterieure 'Bacheler et al.' etait fausse, aucun auteur de ce nom ne figure sur le papier), Ecology and Evolution, DOI 10.1002/ece3.71650; Dryad 10.5061/dryad.w0vt4b954. The README and model_script.R provide full_dataset.csv with haul-level flapper skate presence/absence, lon/lat, bathymetry, distance to coast, current, bottom temperature, benthic productivity and fishing pressure. Le papier ajuste un modele INLA/SPDE (champ aleatoire spatial explicite, lien cloglog). Correction (2026-09-08, lecture TEI approfondie, Loca2025OnThe.tei.xml) : btemp (bottom temperature) a ete RETIRE par les auteurs de leur modele final pour cause de colinearite ('bottom temperature was dropped from the analysis'). formula_used/x_terms_used/formula_pub corriges pour ne plus inclure btemp, qui restait a tort dans la specification executable malgre son exclusion documentee par le papier. La colonne btemp reste disponible dans Detail X (candidate non retenue)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "classification_binary_presence_absence"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Bloc estimator_eligibility complete le 2026-09-08. Papier confirme via lecture TEI approfondie (Loca2025OnThe.tei.xml) : modele INLA/SPDE avec champ aleatoire spatial explicite (GMRF), lien cloglog -- dependance spatiale reelle et documentee, cas ideal pour sar_probit/sem_probit. Correction associee : btemp retire de formula_used/x_terms_used/formula_pub (les auteurs l'ont exclu de leur modele final pour colinearite)."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Bloc estimator_eligibility complete le 2026-09-08. Papier confirme via lecture TEI approfondie (Loca2025OnThe.tei.xml) : modele INLA/SPDE avec champ aleatoire spatial explicite (GMRF), lien cloglog -- dependance spatiale reelle et documentee, cas ideal pour sar_probit/sem_probit. Correction associee : btemp retire de formula_used/x_terms_used/formula_pub (les auteurs l'ont exclu de leur modele final pour colinearite).

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators:
    - estimator: sar_probit
      basis: scientific_evidence
      source_ref: "Loca et al. (2025) (auteurs corriges le 2026-09-14, voir source_ref FORMULA_OVERRIDES), Ecology and Evolution, DOI 10.1002/ece3.71650 -- modele INLA/SPDE avec champ spatial explicite, lien cloglog, sur reponse binaire presence/absence."
      notes: "SAR probit est l'estimateur du harnais le plus proche du cadre publie (dependance spatiale explicite + reponse binaire) ; l'implementation exacte SPDE/INLA des auteurs n'est pas disponible dans le harnais, ceci est un estimateur analogue, pas une reproduction exacte."
    - estimator: sem_probit
      basis: scientific_evidence
      source_ref: "Loca et al. (2025) (auteurs corriges le 2026-09-14, voir source_ref FORMULA_OVERRIDES), Ecology and Evolution, DOI 10.1002/ece3.71650 -- meme justification que sar_probit."
      notes: "Estimateur analogue au cadre spatial publie, pas une reproduction exacte de SPDE/INLA."
    - estimator: ols
      basis: generated_candidate
      source_ref: "Routage binaire ajoute au harnais cette semaine (glm(family=binomial()))."
      notes: "Capacite technique du harnais ; ne modelise pas la dependance spatiale contrairement au modele publie."
    - estimator: random_forest
      basis: generated_candidate
      source_ref: "response_typologies inclut 'binary' pour random_forest depuis la mise a jour du registre cette semaine."
      notes: "Capacite technique du harnais, comparateur non-spatial."
  conditionally_eligible_estimators: []
  ineligible_reason: "Bloc estimator_eligibility complete le 2026-09-08. Papier confirme via lecture TEI approfondie (Loca2025OnThe.tei.xml) : modele INLA/SPDE avec champ aleatoire spatial explicite (GMRF), lien cloglog -- dependance spatiale reelle et documentee, cas ideal pour sar_probit/sem_probit. Correction associee : btemp retire de formula_used/x_terms_used/formula_pub (les auteurs l'ont exclu de leur modele final pour colinearite)."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 13151
- k variables: 21
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-14.908, 10.0467], y [48.21, 61.8933]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending — multi-zones (span=25deg) -- etendue compatible avec un grand pays/une region ; verifier qu'une projection nationale/regionale existe et convient a cette zone avant de l'utiliser, sinon envisager une projection continentale equal-area

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- Reproducibility status: OK - loader R enregistre et reexecutable (`flapper_skate_presence` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `flapper_skate_presence` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`flapper_skate_presence` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: On the Brink: Mapping the Last Strongholds of the Critically Endangered Flapper Skate ( Dipturus intermedius )

## Curation documentée — 2026-09-07

Decision conservatoire : Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : binary. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
