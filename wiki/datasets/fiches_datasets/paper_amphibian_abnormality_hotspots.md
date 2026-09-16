---
title: paper_amphibian_abnormality_hotspots
type: dataset
created: 2026-09-14
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_amphibian_abnormality_hotspots.rds
  - DatasetFirst_10_5061_dryad_dc25r
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Localized Hotspots Drive Continental Geography of Abnormal Amphibians on U.S. Wildlife Refuges" (DOI 10.1371/journal.pone.0077467).

## Description du jeu de donnees

- Topic: ecotoxicologie / anomalies amphibiennes
- Observation unit: evenement de collecte (site x date)
- Observed population: amphibiens examines sur les refuges fauniques nationaux USFWS, Etats-Unis (2000-2009)
- Geographic context: Etendue mesuree dans le RDS : x [-161.87543, -67.2583], y [26.04285, 67.21632]; CRS EPSG:4326.
- Temporal context: none (cross-sectional)
- Source description: Localized Hotspots Drive Continental Geography of Abnormal Amphibians on U.S. Wildlife Refuges
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1371/journal.pone.0077467
- Dataset DOI: 10.5061/dryad.dc25r
- Source URL: https://doi.org/10.5061/dryad.dc25r
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_dc25r/`
- Local sf output: `data/final_datasets/sf/paper_amphibian_abnormality_hotspots.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `sk_plus_eye_ab_percent`, `all_ab_percent`, `sk_ab_percent`, `eye_ab_percent`, `disease_percent`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `sampling_date`, `species`, `sp_coded`, `avg_gosner`, `avg_svl`, `sk_plus_eye_abnormal_count`, `sk_abnormal_count`, `eye_abnormal_count`, `surface_abnormal_count`, `surface_ab_percent`, `disease_abnormal_count`, `abnormal_count`, `total_frogs`, `SITE_ALIAS`, `SITE_DATE`, `SITE_TIME`, `ORIGINAL_LATITUDE`, `ORIGINAL_LONGITUDE`, `ELEVATION`, `DATUM`, `GPS_MODEL`, `AREA`, `WATER_DEPTH`, `HABITAT_TYPE`, `SITE_COMMENTS`
- Candidate X count in local artifact: 25
- Candidate X typology: unknown, categorical, continuous
- Published X variables from paper: Corrected_LATITUDE/Corrected_LONGITUDE (terme spatial non-lineaire principal du GAMM, s(lat,long)), site.year (effet aleatoire unique concatene du GAMM -- PAS des effets separes REFUGE/REGION, cf. Note)
- Published X count: 2
- Coordinates (x, y - excluded from X candidates): `Corrected_LONGITUDE`, `Corrected_LATITUDE`
- Identifier columns (excluded from X candidates): `collection_id`, `site_id`, `REFUGE`, `REGION`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `sk_plus_eye_ab_percent` | `numeric` | continuous | [0, 40] | 0% |
| `all_ab_percent` | `numeric` | continuous | [0, 97.5] | 0% |
| `sk_ab_percent` | `numeric` | continuous | [0, 40] | 0% |
| `eye_ab_percent` | `numeric` | continuous | [0, 7.14] | 0% |
| `disease_percent` | `numeric` | continuous | [0, 6.56] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `amphibian_abnormality_hotspots`, la ou les reponses `sk_plus_eye_ab_percent`, `all_ab_percent`, `sk_ab_percent`, `eye_ab_percent`, `disease_percent` viennent du loader papier et/ou des preuves de l article `Localized Hotspots Drive Continental Geography of Abnormal Amphibians on U.S. Wildlife Refuges`. Les covariables X retenues sont `Corrected_LATITUDE`, `Corrected_LONGITUDE` ; 25 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Corrected_LONGITUDE`, `Corrected_LATITUDE`), identifiants (`collection_id`, `site_id`, `REFUGE`, `REGION`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `sampling_date` | `Date` | unknown | 0.2% |
| `species` | `character` | categorical | 0% |
| `sp_coded` | `character` | categorical | 0% |
| `avg_gosner` | `numeric` | continuous | 1% |
| `avg_svl` | `numeric` | continuous | 0% |
| `sk_plus_eye_abnormal_count` | `integer` | unknown | 0% |
| `sk_abnormal_count` | `integer` | unknown | 0% |
| `eye_abnormal_count` | `integer` | unknown | 0% |
| `surface_abnormal_count` | `integer` | unknown | 0% |
| `surface_ab_percent` | `numeric` | continuous | 0% |
| `disease_abnormal_count` | `integer` | unknown | 0% |
| `abnormal_count` | `integer` | unknown | 0% |
| `total_frogs` | `integer` | unknown | 0% |
| `SITE_ALIAS` | `character` | categorical | 12% |
| `SITE_DATE` | `character` | categorical | 0% |
| `SITE_TIME` | `character` | categorical | 11.7% |
| `ORIGINAL_LATITUDE` | `numeric` | continuous | 0% |
| `ORIGINAL_LONGITUDE` | `numeric` | continuous | 0% |
| `ELEVATION` | `numeric` | continuous | 37.1% |
| `DATUM` | `character` | categorical | 2.2% |
| `GPS_MODEL` | `character` | categorical | 15.1% |
| `AREA` | `integer` | unknown | 9.4% |
| `WATER_DEPTH` | `character` | categorical | 36.3% |
| `HABITAT_TYPE` | `character` | categorical | 1.5% |
| `SITE_COMMENTS` | `character` | categorical | 13% |

### Formule - niveau publication

- formula_pub: sk_plus_eye_ab_percent ~ s(Corrected_LATITUDE, Corrected_LONGITUDE) + (1|site.year) [GAMM, binomial/logit]
- x_terms_pub: Corrected_LATITUDE/Corrected_LONGITUDE (terme spatial non-lineaire principal du GAMM, s(lat,long)), site.year (effet aleatoire unique concatene du GAMM -- PAS des effets separes REFUGE/REGION, cf. Note)
- y_term_pub: sk_plus_eye_ab_percent (pourcentage d'amphibiens d'une collecte presentant AU MOINS une anomalie squelettique OU oculaire -- categorie combinee definie dans README_for_CoreDataset.txt, distincte de all_ab_percent qui inclut EN PLUS les categories surface et maladie). CORRECTION (2026-09-10) : la fiche precedente utilisait a tort all_ab_percent comme Y en affirmant une correspondance exacte au papier -- le GAMM du papier est explicitement decrit comme ajuste sur 'skeletal and eye abnormality prevalence', qui correspond au nom et a la definition README de sk_plus_eye_ab_percent, pas de all_ab_percent.
- Reference publication: Reeves, Medley, Pinkney, Holyoak, Johnson & Lannoo (2013) (auteurs corriges le 2026-09-14 -- confirmes via le TEI local, Crossref et OpenAlex ; l'attribution anterieure 'Gray, M.J., Rogers, J.D., Miller, D.L. et al.' etait fausse, aucun de ces noms ne figure sur ce papier), Localized Hotspots Drive Continental Geography of Abnormal Amphibians on U.S. Wildlife Refuges, PLoS ONE 8(11): e77467, doi:10.1371/journal.pone.0077467. CoreDataset.csv (675 evenements de collecte) joint a Site.csv (666 sites apres dedoublonnage de 4 SITE_ID dupliques dans le depot source) via site_id, telecharge directement depuis Dryad (10.5061/dryad.dc25r, isSupplementTo/primary_article) -- pas une reconstruction. 77/675 evenements sans coordonnee valide (protection d'especes listees federalement, documente dans README_for_Site.txt) sont exclus (N final=598), pas imputes. CORRECTION (2026-09-10, verification directe TEI + README_for_CoreDataset.txt) : la fiche precedente affirmait a tort 'Y et coordonnees correspondent exactement a la description du papier' en utilisant all_ab_percent et (1|REFUGE)+(1|REGION) comme effets aleatoires du GAMM. Le texte TEI (section 'Spatially explicit analyses') confirme que (a) le GAMM cite est ajuste sur 'skeletal and eye abnormality prevalence' = sk_plus_eye_ab_percent (nom et definition confirmes par README_for_CoreDataset.txt, categorie combinee squelettique+oculaire, distincte de all_ab_percent qui inclut aussi surface+maladie), avec famille binomiale et lien logit (PQL, 1000 iterations) ; (b) l'effet aleatoire du GAMM est un terme UNIQUE concatene 'site.year', retenu apres comparaison AIC de plusieurs structures (Region/Refuge/Site/Year/Species, nested/non-nested, Table S6) -- PAS des effets separes (1|REFUGE)+(1|REGION) ; (c) la structure nichee site/refuge/region (53%/28%/17% de variance) provient d'un modele DIFFERENT et plus simple ('simple variance components analysis', sans effet fixe), utilise uniquement pour le partitionnement de variance, jamais combine avec le smooth s(lat,long) dans le meme modele. Year=2013 ajoute (citation Gray et al. 2013 sans ambiguite ; aucun bib_key/record KG associe a ce dataset dans paper_dataset_uses.json, donc pas de derivation automatique possible).

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d estimation: formule systeme generee (formula_pub confirmee mais non reprise telle quelle -- voir Note ci-dessous)
- Correspondance Python/R: aucune identifiee
- Note: formula_pub est confirmee par le texte de l'article (section 'Spatially explicit analyses', GAMM mgcv, famille binomiale/lien logit, effet aleatoire 'site.year'), mais n'est pas reproduite telle quelle : le harnais actuel ne modelise ni le lien logit/famille binomiale, ni l'effet aleatoire site.year, ni le smooth s(lat,long) dans sa forme GAMM native. formula_used est une approximation continue (lien identite) generee, avec REFUGE/REGION en covariables categoriques plates plutot qu'en effet aleatoire imbrique -- une simplification documentee, pas la specification publiee. Le smooth complet reste disponible via ml_formula (variante gam_spatial).

### Formule - niveau systeme

- formula_used: sk_plus_eye_ab_percent ~ Corrected_LATITUDE + Corrected_LONGITUDE + REFUGE + REGION
- Recommended validation: N lignes=598; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=201. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: Corrected_LATITUDE, Corrected_LONGITUDE
- y_term_used: sk_plus_eye_ab_percent
- Note: mgcv, distribution binomiale + lien logit, estimation PQL (1000 iterations), terme spatial non-lineaire lat/long, effet aleatoire UNIQUE concatene 'site.year' (retenu par comparaison AIC contre Region/Refuge/Site/Year/Species nested et non-nested) ; analyse complementaire par Getis-Ord Gi* pour la detection de hotspots (echantillon au niveau site, pas le GAMM). Modele SEPARE de variance partitioning (aucun effet fixe, effets aleatoires nested site/refuge/region) pour les % de variance par echelle spatiale (site=53%, refuge=28%, region=17%) -- pas le meme modele que le GAMM. Voir formula_used_divergence_note pour l'ecart avec formula_used.

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
    formula: "sk_plus_eye_ab_percent ~ Corrected_LATITUDE + Corrected_LONGITUDE + REFUGE + REGION"
    response: "sk_plus_eye_ab_percent (pourcentage d'amphibiens d'une collecte presentant AU MOINS une anomalie squelettique OU oculaire -- categorie combinee definie dans README_for_CoreDataset.txt, distincte de all_ab_percent qui inclut EN PLUS les categories surface et maladie). CORRECTION (2026-09-10) : la fiche precedente utilisait a tort all_ab_percent comme Y en affirmant une correspondance exacte au papier -- le GAMM du papier est explicitement decrit comme ajuste sur 'skeletal and eye abnormality prevalence', qui correspond au nom et a la definition README de sk_plus_eye_ab_percent, pas de all_ab_percent."
    predictors: ["Corrected_LATITUDE/Corrected_LONGITUDE (terme spatial non-lineaire principal du GAMM, s(lat,long))", "site.year (effet aleatoire unique concatene du GAMM -- PAS des effets separes REFUGE/REGION, cf. Note)"]
    role: "benchmark_simplified_specification"
    source_type: "derived_from_scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
    status: "executable_approximation"

  ml_or_selected:
    formula: "sk_plus_eye_ab_percent ~ Corrected_LATITUDE + Corrected_LONGITUDE + REFUGE + REGION"
    response: "sk_plus_eye_ab_percent"
    predictors: ["Corrected_LATITUDE", "Corrected_LONGITUDE", "REFUGE", "REGION"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["gam_spatial", "gamm", "random_forest", "xgboost"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_amphibian_abnormality_hotspots`
- Dataset name: Data from: Localized hotspots drive continental geography of abnormal amphibians on U.S. wildlife refuges
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Localized Hotspots Drive Continental Geography of Abnormal Amphibians on U.S. Wildlife Refuges
- Paper DOI: 10.1371/journal.pone.0077467
- Dataset DOI: 10.5061/dryad.dc25r
- Source URL: https://doi.org/10.5061/dryad.dc25r
- Year: 2013

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "sk_plus_eye_ab_percent ~ s(Corrected_LATITUDE, Corrected_LONGITUDE) + (1|site.year) [GAMM, binomial/logit]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Reeves, Medley, Pinkney, Holyoak, Johnson & Lannoo (2013) (auteurs corriges le 2026-09-14 -- confirmes via le TEI local, Crossref et OpenAlex ; l'attribution anterieure 'Gray, M.J., Rogers, J.D., Miller, D.L. et al.' etait fausse, aucun de ces noms ne figure sur ce papier), Localized Hotspots Drive Continental Geography of Abnormal Amphibians on U.S. Wildlife Refuges, PLoS ONE 8(11): e77467, doi:10.1371/journal.pone.0077467. CoreDataset.csv (675 evenements de collecte) joint a Site.csv (666 sites apres dedoublonnage de 4 SITE_ID dupliques dans le depot source) via site_id, telecharge directement depuis Dryad (10.5061/dryad.dc25r, isSupplementTo/primary_article) -- pas une reconstruction. 77/675 evenements sans coordonnee valide (protection d'especes listees federalement, documente dans README_for_Site.txt) sont exclus (N final=598), pas imputes. CORRECTION (2026-09-10, verification directe TEI + README_for_CoreDataset.txt) : la fiche precedente affirmait a tort 'Y et coordonnees correspondent exactement a la description du papier' en utilisant all_ab_percent et (1|REFUGE)+(1|REGION) comme effets aleatoires du GAMM. Le texte TEI (section 'Spatially explicit analyses') confirme que (a) le GAMM cite est ajuste sur 'skeletal and eye abnormality prevalence' = sk_plus_eye_ab_percent (nom et definition confirmes par README_for_CoreDataset.txt, categorie combinee squelettique+oculaire, distincte de all_ab_percent qui inclut aussi surface+maladie), avec famille binomiale et lien logit (PQL, 1000 iterations) ; (b) l'effet aleatoire du GAMM est un terme UNIQUE concatene 'site.year', retenu apres comparaison AIC de plusieurs structures (Region/Refuge/Site/Year/Species, nested/non-nested, Table S6) -- PAS des effets separes (1|REFUGE)+(1|REGION) ; (c) la structure nichee site/refuge/region (53%/28%/17% de variance) provient d'un modele DIFFERENT et plus simple ('simple variance components analysis', sans effet fixe), utilise uniquement pour le partitionnement de variance, jamais combine avec le smooth s(lat,long) dans le meme modele. Year=2013 ajoute (citation Gray et al. 2013 sans ambiguite ; aucun bib_key/record KG associe a ce dataset dans paper_dataset_uses.json, donc pas de derivation automatique possible)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Y/X/formula_used deja resolus ; estimateurs generiques (continuous) ajoutes en revue de lot du 2026-09-09."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Y/X/formula_used deja resolus ; estimateurs generiques (continuous) ajoutes en revue de lot du 2026-09-09.

## Estimator eligibility

```yaml
estimator_eligibility:
  eligible_estimators:
    - estimator: gam_spatial
      basis: scientific_evidence
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "GAM mentionne dans la source."
    - estimator: ols
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Regression lineaire standard, baseline generique pour reponse continue."
    - estimator: random_forest
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Alternative ML non-parametrique generique, Y continu."
    - estimator: xgboost
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Alternative ML non-parametrique generique, Y continu."
  conditionally_eligible_estimators: []
  ineligible_reason: "n/a -- estimateurs generiques eligibles (voir eligible_estimators)."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 598
- k variables: 38
- T periods: 383 (corrige 2026-09-07 -- voir note ci-dessous)
- Variable temporelle: sampling_date
- N/T profile: N_moyen_T_grand
- Note T corrigee (session 2026-09-07, verification directe du `.rds`) : la colonne `sampling_date` (classe Date, correctement parsee, 1 seule valeur NA sur 598) existe dans les donnees avec 383 dates distinctes (2000-05-25 a 2009-10-02, ~10 saisons de terrain) mais n'avait pas ete reportee comme variable temporelle ici (T=1/n/a etait errone). Une colonne alternative `SITE_DATE` (263 valeurs distinctes) existe egalement. Coherent avec la confirmation TEI deja documentee (session 2026-09-07) : "Multi-year hotspot survey design explicitly described; sites revisited across survey years." Grouper la CV par site_id (ou REFUGE/REGION), et respecter la chronologie (annee de sampling_date) si l'objectif est prospectif.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-161.87543, -67.2583], y [26.04285, 67.21632]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=94.6deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.dc25r (checked 2026-09-10): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`amphibian_abnormality_hotspots` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `amphibian_abnormality_hotspots` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formula_pub confirmee et verifiee (voir Reference publication) ; formula_used est une approximation generee distincte, explicitement etiquetee comme telle (voir Bloc 1 > Statut regression canonique > Note).
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20%: ELEVATION (NA=37.1%), WATER_DEPTH (NA=36.3%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`amphibian_abnormality_hotspots` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Localized Hotspots Drive Continental Geography of Abnormal Amphibians on U.S. Wildlife Refuges

## Curation documentée — 2026-09-07

Decision conservatoire : N lignes=598; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=201. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

MISE A JOUR (2026-09-10) : hold_estimators desactive -- la suspension du 2026-09-07 avait ete levee par la revue en lot du 2026-09-09 (Estimator eligibility rempli directement dans le .md), mais ce JSON n'avait jamais ete mis a jour en consequence ; une regeneration Rscript a donc silencieusement republie l'etat suspendu (hold_estimators=true, previous_eligibility) et efface aussi la correction Bloc 4 T-periods du 2026-09-07 (celle-ci n'avait jamais ete capturee dans ce JSON du tout). Les deux sections sont desormais protegees via reviewed_sections.

## Note -- promotion en lot (2026-09-09)

Formule, reponse et covariables deja resolues (Y/X/formula_used complets avant cette passe). Seul le bloc 'Estimator eligibility' etait vide -- rempli ici avec les estimateurs generiques adaptes a la typologie Y (continuous), sur decision explicite de l'utilisateur de revoir en lot les fiches 'manual_review' deja completes. Base 'scientific_evidence' reservee aux cas ou le texte de la fiche documente deja une methode precise ; sinon 'benchmark_use'/'generated_candidate' (pas de surinterpretation de la methode publiee).
