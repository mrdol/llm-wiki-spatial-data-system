---
title: paper_crane
type: dataset
created: 2026-09-14
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_crane.rds
  - DataCite_2022_BalancingStructuralComplexityWith_10_1111_2041_210
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Balancing structural complexity with ecological insight in Spatio-temporal species distribution models" (DOI 10.1111/2041-210x.13957).

## Description du jeu de donnees

- Topic: distribution d'espece / demographie de population
- Observation unit: observation ponctuelle de presence
- Observed population: population reintroduite de grues (Grus grus)
- Geographic context: etendue sf: x [233643.173683893, 862162.495815702], y [22773.8203577613, 626978.465950806]
- Temporal context: 5 distinct periods (variable: ti)
- Source description: Balancing structural complexity with ecological insight in Spatio-temporal species distribution models
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/2041-210x.13957
- Dataset DOI: 10.5061/dryad.2z34tmpps
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.2z34tmpps
- Local raw dir: `data/raw/papers/DataCite_2022_BalancingStructuralComplexityWith_10_1111_2041_210/`
- Local sf output: `data/final_datasets/sf/paper_crane.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `mark`
- Candidate Y typology: binary
- Candidate X variables in local artifact: `ti`, `Urb_Den_cov`, `PA_Ratio_cov`, `Area_cov`
- Candidate X count in local artifact: 4
- Candidate X typology: unknown, continuous
- Published X variables from paper: Urb_Den_cov (densite des zones urbanisees dans un buffer terrestre de 10 km), PA_Ratio_cov (ratio perimetre/aire de la zone humide), Area_cov (surface de la zone humide)
- Published X count: 3
- Coordinates (x, y - excluded from X candidates): `x`, `y`, `x_m`, `y_m`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `mark` | `integer` | binary | {0, 1} | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `crane`, la ou les reponses `mark` viennent du loader papier et/ou des preuves de l article `Balancing structural complexity with ecological insight in Spatio-temporal species distribution models`. Les covariables X retenues sont `ti`, `Urb_Den_cov`, `PA_Ratio_cov`, `Area_cov`. Les coordonnees (`x`, `y`, `x_m`, `y_m`), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : not_ready_current_package ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `ti` | `integer` | unknown | 0% |
| `Urb_Den_cov` | `numeric` | continuous | 0% |
| `PA_Ratio_cov` | `numeric` | continuous | 0% |
| `Area_cov` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: logit(P(s,t)) = beta0 + alpha1*Urb_Den_cov + alpha2*PA_Ratio_cov + alpha3*Area_cov + M(s,t) [INLA/SPDE, bayesien]
- x_terms_pub: Urb_Den_cov (densite des zones urbanisees dans un buffer terrestre de 10 km), PA_Ratio_cov (ratio perimetre/aire de la zone humide), Area_cov (surface de la zone humide)
- y_term_pub: O_{s,t} / mark (presence-absence d'un couple reproducteur de grues au site s, annee t ; variable Bernoulli, notee 'mark' dans l'artefact local)
- Reference publication: Laxton, Rodriguez de Rivera, Soriano-Redondo & Illian (2023) (auteurs corriges le 2026-09-14 -- verifies via le TEI local et Crossref ; l'attribution anterieure 'Laxton, Illian, Bachl & O'Hara' etait fausse, Bachl et O'Hara sont des auteurs d'articles cites en bibliographie de ce papier -- ex. inlabru -- pas des auteurs de ce papier), Methods in Ecology and Evolution 14(1):162-172, DOI 10.1111/2041-210X.13957, Section 2.2 'Single-field models', Eq. (1)-(2) p.165: O_{s,t} ~ Bernoulli(P(s,t)), P(s,t) = logit^-1(beta0 + sum_i alpha_i*x_i(s,t) + M(s,t)), avec les 3 covariables environnementales explicitement nommees ('the density of surrounding urbanised areas ... wetland perimeter-to-area ratio, and wetland extent') correspondant aux colonnes locales Urb_Den_cov/PA_Ratio_cov/Area_cov. 'ti' (variable temporelle presente dans l'artefact local) n'est PAS l'une des 3 covariables x_i du papier : c'est l'indice temporel qui structure le champ aleatoire gaussien spatio-temporel M(s,t) (options IID ou AR1, Section 2.2), pas un terme a effet fixe. formula_used garde 'ti' comme covariable simplifiee (approximation GLM plate, sans champ aleatoire spatio-temporel ni lien logit reproduit par le harnais actuel) -- ce n'est pas la specification publiee, seulement une candidate executable la plus proche. Paper precedemment non lu lors du remplissage de FORMULA_OVERRIDES (formula_pub restait 'pending' malgre un Statut/Reference publication deja renseignes) ; corrige le 2026-09-10 apres lecture directe du texte (Eq. 1-2, p.164-166).

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d estimation: formule systeme generee (formula_pub confirmee mais non reprise telle quelle -- voir Note ci-dessous)
- Correspondance Python/R: aucune identifiee
- Note: formula_pub est confirmee et verifiee dans le texte de l'article (Eq. 1-2 p.165 : lien logit, modele binomial hierarchique bayesien, champ aleatoire gaussien spatio-temporel M(s,t) approxime par SPDE/INLA), mais n'est pas reproduite telle quelle : le harnais actuel ne modelise ni le lien logit ni ce champ latent spatio-temporel. formula_used est une approximation GLM plate generee, qui ajoute en outre 'ti' comme covariable a effet fixe alors que dans le papier 'ti' structure le champ aleatoire (IID/AR1), pas un terme x_i.

### Formule - niveau systeme

- formula_used: mark ~ ti + Urb_Den_cov + PA_Ratio_cov + Area_cov
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: binary
- x_terms_used: ti, Urb_Den_cov, PA_Ratio_cov, Area_cov
- y_term_used: mark
- Note: Eq. 1-2 p.165 : modele binomial presence/absence hierarchique bayesien, champ aleatoire gaussien spatio-temporel M(s,t) approxime par SPDE, ajuste avec R-INLA/inlabru ; variante etendue Eq. 4 ajoute un second champ G(s) issu d'un processus ponctuel des zones humides. Voir formula_used_divergence_note pour l'ecart avec formula_used.

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
    formula: "logit(P(s,t)) = beta0 + alpha1*Urb_Den_cov + alpha2*PA_Ratio_cov + alpha3*Area_cov + M(s,t)"
    response: "O_{s,t} / mark (presence-absence d'un couple reproducteur de grues au site s, annee t ; variable Bernoulli, notee 'mark' dans l'artefact local)"
    predictors: ["Urb_Den_cov (densite des zones urbanisees dans un buffer terrestre de 10 km)", "PA_Ratio_cov (ratio perimetre/aire de la zone humide)", "Area_cov (surface de la zone humide)"]
    role: "benchmark_simplified_specification"
    source_type: "derived_from_scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["random_forest", "gamboost", "xgboost"]
    status: "executable_approximation"

  ml_or_selected:
    formula: "mark ~ ti + Urb_Den_cov + PA_Ratio_cov + Area_cov"
    response: "mark"
    predictors: ["ti", "Urb_Den_cov", "PA_Ratio_cov", "Area_cov"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated_candidate_binary_panel"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_crane`
- Dataset name: Transformed crane data from: Balancing structural complexity with ecological insight in spatio-temporal species distribution models
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Balancing structural complexity with ecological insight in Spatio-temporal species distribution models
- Paper DOI: 10.1111/2041-210x.13957
- Dataset DOI: 10.5061/dryad.2z34tmpps
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.2z34tmpps
- Year: 2022 (annee de depot Dryad/DataCite, non verifiee comme annee de publication de l'article -- voir Reference publication)

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "logit(P(s,t)) = beta0 + alpha1*Urb_Den_cov + alpha2*PA_Ratio_cov + alpha3*Area_cov + M(s,t) [INLA/SPDE, bayesien]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Laxton, Rodriguez de Rivera, Soriano-Redondo & Illian (2023) (auteurs corriges le 2026-09-14 -- verifies via le TEI local et Crossref ; l'attribution anterieure 'Laxton, Illian, Bachl & O'Hara' etait fausse, Bachl et O'Hara sont des auteurs d'articles cites en bibliographie de ce papier -- ex. inlabru -- pas des auteurs de ce papier), Methods in Ecology and Evolution 14(1):162-172, DOI 10.1111/2041-210X.13957, Section 2.2 'Single-field models', Eq. (1)-(2) p.165: O_{s,t} ~ Bernoulli(P(s,t)), P(s,t) = logit^-1(beta0 + sum_i alpha_i*x_i(s,t) + M(s,t)), avec les 3 covariables environnementales explicitement nommees ('the density of surrounding urbanised areas ... wetland perimeter-to-area ratio, and wetland extent') correspondant aux colonnes locales Urb_Den_cov/PA_Ratio_cov/Area_cov. 'ti' (variable temporelle presente dans l'artefact local) n'est PAS l'une des 3 covariables x_i du papier : c'est l'indice temporel qui structure le champ aleatoire gaussien spatio-temporel M(s,t) (options IID ou AR1, Section 2.2), pas un terme a effet fixe. formula_used garde 'ti' comme covariable simplifiee (approximation GLM plate, sans champ aleatoire spatio-temporel ni lien logit reproduit par le harnais actuel) -- ce n'est pas la specification publiee, seulement une candidate executable la plus proche. Paper precedemment non lu lors du remplissage de FORMULA_OVERRIDES (formula_pub restait 'pending' malgre un Statut/Reference publication deja renseignes) ; corrige le 2026-09-10 apres lecture directe du texte (Eq. 1-2, p.164-166)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_current_package"
  benchmark_task: "binary_panel_or_presence_absence"
  package_include: "no"
  has_local_rds: true
  missing_items: "support binaire/panel et schema CV adapte"
  reason: "Reponse binaire et structure temporelle."
```

- Decision: not_ready_current_package
- Manque principal: support binaire/panel et schema CV adapte
- Raison: Reponse binaire et structure temporelle.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "not_ready_current_package"
  eligible_estimators: []
  conditionally_eligible_estimators: ["random_forest", "random_forest_xy", "gamboost", "xgboost", "xgboost_xy", "gam_spatial", "sar_probit", "sem_probit"]
  ineligible_reason: "reponse binaire ET structure panel spatial : aucune route du package ne gere cette combinaison aujourd'hui (sar_probit/sem_probit sont cross-sectionnels ; le harnais panel -- 70-panel-spatial.R -- ne gere que le Y continu). random_forest/gamboost/xgboost/gam_spatial restent des alternatives generiques ignorant la structure panel ; sar_probit/sem_probit necessiteraient de traiter chaque periode separement (non implemente) et une matrice W fiable (voir Bloc 5 / CRS note)."
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 12630
- k variables: 12
- T periods: 5
- Variable temporelle: ti
- N/T profile: N_grand_T_moyen

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 5 distinct periods (variable: ti)
- CRS EPSG: unknown
- CRS nom: unknown
- Spatial extent: x [233643.173683893, 862162.495815702], y [22773.8203577613, 626978.465950806]
- Time range: 1 to 5 (variable: ti)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu
- CRS note: hypothese testee et ecartee (session 2026-09-10) -- l'etendue x/y (234-862 km, 23-627 km, Angleterre, grue eurasienne) est numeriquement compatible avec le British National Grid (EPSG:27700) en km, mais le loader (code/r_catalog/build_sf_datasets_papers.R, fonction load_crane) documente deja que le README Dryad ne precise pas la zone UTM, ET que les coordonnees sont 'aleatoirement transformees' par les auteurs pour proteger les sites de nidification -- pas les vraies positions. Assigner un CRS, meme correct, ne rendrait donc pas ces positions geographiquement exploitables : ne pas assigner de CRS ni construire de matrice de voisinage sur ce jeu tant que ce point n'est pas leve.

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.2z34tmpps (checked 2026-09-14): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`crane` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `crane` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formula_pub confirmee et verifiee (voir Reference publication) ; formula_used est une approximation generee distincte, explicitement etiquetee comme telle (voir Bloc 1 > Statut regression canonique > Note).
- CRS: WARN (verifie) - CRS absent du sf source ; caveat documente, voir Bloc 5 > CRS note.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`crane` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Balancing structural complexity with ecological insight in Spatio-temporal species distribution models

## Curation documentée — 2026-09-07

Typologie de la reponse selectionnee : binary. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
