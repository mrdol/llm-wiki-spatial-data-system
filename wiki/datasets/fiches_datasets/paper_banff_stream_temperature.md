---
title: paper_banff_stream_temperature
type: dataset
created: 2026-09-14
updated: 2026-09-16
sources:
  - data/final_datasets/sf/paper_banff_stream_temperature.rds
  - DatasetFirst_10_5061_dryad_crjdfn391
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Statistical stream temperature modelling with SSN and INLA: an introduction for conservation practitioners" (DOI 10.1139/cjfas-2023-0136).

## Description du jeu de donnees

- Topic: hydrologie / temperature des cours d'eau (modelisation SSN)
- Observation unit: site de mesure de temperature (logger)
- Observed population: cours d'eau, Parc national de Banff, Alberta, N=110 sites
- Geographic context: Etendue mesuree dans le RDS : x [580218, 612127], y [5642845, 5701082]; CRS EPSG:32611.
- Temporal context: none (cross-sectional)
- Source description: Statistical stream temperature modelling with SSN and INLA: an introduction for conservation practitioners
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: high
- Paper DOI: 10.1139/cjfas-2023-0136
- Dataset DOI: 10.5061/dryad.crjdfn391
- Source URL: https://doi.org/10.5061/dryad.crjdfn391
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_crjdfn391/`
- Local sf output: `data/final_datasets/sf/paper_banff_stream_temperature.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `WaterTemp`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Year_`, `LE`, `Elev`, `RSlope`, `h2oAreaKm2`, `logRCA`
- Candidate X count in local artifact: 6
- Candidate X typology: unknown, categorical, continuous
- Published X variables from paper: Elev (elevation du site, m, standardisee S.Elev/Elev.std dans les scripts), RSlope (pente du cours d'eau, standardisee S.RSlope/RSlope.std), LE (indicateur binaire d'effet lac en amont, LEf/LEf1 dans les scripts)
- Published X count: 3
- Coordinates (x, y - excluded from X candidates): `Easting`, `Northing`
- Identifier columns (excluded from X candidates): `ID`, `LoggerID`, `S_N`, `WSf`, `Waterbody`, `HUC10`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `WaterTemp` | `numeric` | continuous | [2.6, 13.6] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `banff_stream_temperature`, la ou les reponses `WaterTemp` viennent du loader papier et/ou des preuves de l article `Statistical stream temperature modelling with SSN and INLA: an introduction for conservation practitioners`. Les covariables X retenues sont `Elev`, `RSlope`, `LE` ; 3 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Easting`, `Northing`), identifiants (`ID`, `LoggerID`, `S_N`, `WSf`, `Waterbody`, `HUC10`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Year_` | `integer` | unknown | 0% |
| `LE` | `integer` | binary | 0% |
| `Elev` | `integer` | continuous | 0% |
| `RSlope` | `numeric` | continuous | 0% |
| `h2oAreaKm2` | `numeric` | continuous | 0% |
| `logRCA` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: WaterTemp ~ Elev + RSlope + LE [SSN glmssn + INLA barrier model, effet aleatoire HUC10]
- x_terms_pub: Elev (elevation du site, m, standardisee S.Elev/Elev.std dans les scripts), RSlope (pente du cours d'eau, standardisee S.RSlope/RSlope.std), LE (indicateur binaire d'effet lac en amont, LEf/LEf1 dans les scripts)
- y_term_pub: WaterTemp (temperature moyenne d'aout du cours d'eau, degres C, mesuree par logger)
- Reference publication: Struthers, Gutowsky, Lucas, Mochnacz, Carli & Taylor (2024), Statistical stream temperature modelling with SSN and INLA: an introduction for conservation practitioners, Canadian Journal of Fisheries and Aquatic Sciences 81:417-432, doi:10.1139/cjfas-2023-0136 (Crossref confirme publication en ligne 2024-04-01 -- la fiche precedente citait a tort '2023' et les pages '417-232', DOI 'unknown'). CSV original (bnp_data_June2022_V5.csv) telecharge directement depuis Dryad (10.5061/dryad.crjdfn391) -- pas une reconstruction, N=110 sites de mesure de temperature, Parc national de Banff, coordonnees UTM Zone 11N. CORRECTION MAJEURE (2026-09-14, recherche web + lecture directe des scripts R des auteurs via leur depot Zenodo 10.5281/zenodo.7942855, SSN_R-Script.R et INLA_R-Script.R -- rapatries dans data/raw/papers/DatasetFirst_10_5061_dryad_crjdfn391/ pour archivage local) : le modele final RETENU par les auteurs (pas seulement teste) est WaterTemp ~ Elev + RSlope + LE, confirme IDENTIQUEMENT par les deux approches (SSN glmssn ligne 263 ; INLA barrier model lignes 270-303, avec en plus un effet aleatoire iid sur HUC10/watershed). Les termes logRCA et h2oAreaKm2, presents dans la fiche precedente, ne figurent PAS dans le modele final -- ce sont des candidats explores puis ecartes (ex. modeles td3/tu3 du script SSN). CONFIRMATION INDEPENDANTE (2026-09-14, PDF obtenu par l'utilisateur, traite via GROBID, TEI local desormais disponible) : le texte du papier confirme mot pour mot -- 'The fitted model (SSN-1) included all fixed terms (i.e., elevation, reach slope, and lake effect)... we also fit an equivalent nonspatial model (SSN-2)... while retaining all fixed terms and the HUC-10 random effect' ; et explique explicitement pourquoi logRCA est absent -- 'upstream drainage area... was dropped because of collinearity with elevation (r=0.82) and had a higher VIF score'. Fichier bnp_data_preds_June2022_V5.csv (grille de prediction, 642 lignes) present dans le meme depot mais non utilise ici (pas de Y, utile seulement pour du krigeage). package_include laisse en manual_review du fait de l'ecart de methode (covariance de reseau/effet aleatoire non reproduits).

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d estimation: formule systeme generee (formula_pub confirmee mais non reprise telle quelle -- voir Note ci-dessous)
- Correspondance Python/R: aucune identifiee
- Note: formula_pub est confirmee par lecture directe des scripts R des auteurs (Zenodo 10.5281/zenodo.7942855, deposes avec le papier) : SSN_R-Script.R ligne 263, modele SSN final retenu -- 'Final <- glmssn(WaterTemp ~ S.Elev + S.RSlope + LEf, data, ...)' -- et INLA_R-Script.R lignes 270-303, modele INLA (barrier model) -- 'f2 <- y ~ -1 + y.intercept + RSlope.std + Elev.std + LEf1 + f(spatial.field, model=barrier.model) + f(HUC10f, model='iid', ...)'. Les DEUX modeles (SSN et INLA) convergent exactement sur les memes 3 predicteurs (Elev, RSlope, LE), standardises avant ajustement (prefixe S./.std) -- ni logRCA ni h2oAreaKm2 n'apparaissent dans le modele final retenu (ce sont des variables candidates testees en exploration, ex. td3/tu3 dans le script SSN, mais pas retenues). formula_used reprend exactement ces 3 variables (toutes disponibles localement, y compris LE) en regression lineaire simple -- il manque la structure de covariance spatiale sur reseau (glmssn, tail-up/tail-down) et le champ spatial barrier + effet aleatoire HUC10 (watershed) du modele INLA, une simplification documentee mais desormais sur les VRAIES variables du papier.

### Formule - niveau systeme

- formula_used: WaterTemp ~ Elev + RSlope + LE
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: Elev, RSlope, LE
- y_term_used: WaterTemp
- Note: CORRECTION MAJEURE (2026-09-14, lecture directe des scripts R des auteurs, Zenodo 10.5281/zenodo.7942855) : la fiche precedente utilisait h2oAreaKm2+logRCA (jamais dans le modele final des auteurs) et omettait LE (present dans les DEUX modeles finaux, SSN et INLA). HUC10 (watershed) sert d'effet aleatoire dans le modele INLA -- actuellement exclue comme simple identifiant dans cette fiche, disponible localement si une route avec effet aleatoire groupe est souhaitee (cf. support (1|groupe) via gam_spatial/mgcv ajoute au package le 2026-09-10).

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
    formula: "WaterTemp ~ Elev + RSlope + LE"
    response: "WaterTemp (temperature moyenne d'aout du cours d'eau, degres C, mesuree par logger)"
    predictors: ["Elev (elevation du site, m, standardisee S.Elev/Elev.std dans les scripts)", "RSlope (pente du cours d'eau, standardisee S.RSlope/RSlope.std)", "LE (indicateur binaire d'effet lac en amont, LEf/LEf1 dans les scripts)"]
    role: "benchmark_simplified_specification"
    source_type: "derived_from_scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
    status: "executable_approximation"

  ml_or_selected:
    formula: "WaterTemp ~ Elev + RSlope + LE + h2oAreaKm2 + logRCA"
    response: "WaterTemp"
    predictors: ["Elev", "RSlope", "LE", "h2oAreaKm2", "logRCA"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "gwr", "sar_error", "random_forest_xy"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_banff_stream_temperature`
- Dataset name: Data from: Statistical stream temperature modelling with SSN and INLA: an introduction for conservation practitioners
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Statistical stream temperature modelling with SSN and INLA: an introduction for conservation practitioners
- Paper DOI: 10.1139/cjfas-2023-0136
- Dataset DOI: 10.5061/dryad.crjdfn391
- Source URL: https://doi.org/10.5061/dryad.crjdfn391
- Year: 2024

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "WaterTemp ~ Elev + RSlope + LE [SSN glmssn + INLA barrier model, effet aleatoire HUC10]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Struthers, Gutowsky, Lucas, Mochnacz, Carli & Taylor (2024), Statistical stream temperature modelling with SSN and INLA: an introduction for conservation practitioners, Canadian Journal of Fisheries and Aquatic Sciences 81:417-432, doi:10.1139/cjfas-2023-0136 (Crossref confirme publication en ligne 2024-04-01 -- la fiche precedente citait a tort '2023' et les pages '417-232', DOI 'unknown'). CSV original (bnp_data_June2022_V5.csv) telecharge directement depuis Dryad (10.5061/dryad.crjdfn391) -- pas une reconstruction, N=110 sites de mesure de temperature, Parc national de Banff, coordonnees UTM Zone 11N. CORRECTION MAJEURE (2026-09-14, recherche web + lecture directe des scripts R des auteurs via leur depot Zenodo 10.5281/zenodo.7942855, SSN_R-Script.R et INLA_R-Script.R -- rapatries dans data/raw/papers/DatasetFirst_10_5061_dryad_crjdfn391/ pour archivage local) : le modele final RETENU par les auteurs (pas seulement teste) est WaterTemp ~ Elev + RSlope + LE, confirme IDENTIQUEMENT par les deux approches (SSN glmssn ligne 263 ; INLA barrier model lignes 270-303, avec en plus un effet aleatoire iid sur HUC10/watershed). Les termes logRCA et h2oAreaKm2, presents dans la fiche precedente, ne figurent PAS dans le modele final -- ce sont des candidats explores puis ecartes (ex. modeles td3/tu3 du script SSN). CONFIRMATION INDEPENDANTE (2026-09-14, PDF obtenu par l'utilisateur, traite via GROBID, TEI local desormais disponible) : le texte du papier confirme mot pour mot -- 'The fitted model (SSN-1) included all fixed terms (i.e., elevation, reach slope, and lake effect)... we also fit an equivalent nonspatial model (SSN-2)... while retaining all fixed terms and the HUC-10 random effect' ; et explique explicitement pourquoi logRCA est absent -- 'upstream drainage area... was dropped because of collinearity with elevation (r=0.82) and had a higher VIF score'. Fichier bnp_data_preds_June2022_V5.csv (grille de prediction, 642 lignes) present dans le meme depot mais non utilise ici (pas de Y, utile seulement pour du krigeage). package_include laisse en manual_review du fait de l'ecart de methode (covariance de reseau/effet aleatoire non reproduits)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous_comparative_not_ssn"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "CORRECTION 2026-09-09 : verifie directement dans le RDS -- Year_ ne prend qu'une seule valeur (2018) sur les 110 lignes, T=1 est donc correct, pas une incoherence (l'ancienne reserve comparait a tort la presence de la colonne Year_ a la declaration T=1). Promu comme tache COMPARATIVE explicitement distincte du modele SSN/INLA du papier (reseau hydrographique) : W standard (distance euclidienne sur Easting/Northing), pas une matrice de flux sur reseau -- voir Note ci-dessous."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: CORRECTION 2026-09-09 : verifie directement dans le RDS -- Year_ ne prend qu'une seule valeur (2018) sur les 110 lignes, T=1 est donc correct, pas une incoherence (l'ancienne reserve comparait a tort la presence de la colonne Year_ a la declaration T=1). Promu comme tache COMPARATIVE explicitement distincte du modele SSN/INLA du papier (reseau hydrographique) : W standard (distance euclidienne sur Easting/Northing), pas une matrice de flux sur reseau -- voir Note ci-dessous.

## Estimator eligibility

```yaml
estimator_eligibility:
  eligible_estimators:
    - estimator: ols
      basis: benchmark_use
      source_ref: "Comparateur non-spatial standard -- le papier utilise SSN/INLA (reseau hydrographique), pas OLS."
      notes: "Regression lineaire simple sur les covariables reelles retenues par le modele final des auteurs (Elev, RSlope, LE -- confirme par lecture directe de leurs scripts R, Zenodo 10.5281/zenodo.7942855)."
    - estimator: gam_spatial
      basis: benchmark_use
      source_ref: "Approximation spatiale generique (W euclidienne sur Easting/Northing), PAS une reproduction du modele SSN sur reseau hydrographique du papier."
      notes: "Tache comparative explicitement distincte de SSN -- ne pretend pas capturer la connectivite du reseau (flux amont/aval) ni l'effet aleatoire HUC10 du modele INLA des auteurs."
    - estimator: inla_spde
      basis: benchmark_use
      source_ref: "Ajoute le 2026-09-18. Le papier utilise reellement INLA, mais un modele barrier (geometrie non convexe du reseau hydrographique) + effet aleatoire iid sur HUC10 (Struthers et al. 2024, INLA_R-Script.R lignes 270-303) -- inla_spde_reg() n'implemente ni la barriere ni l'effet aleatoire groupe, seulement un champ SPDE/Matern standard sur l'espace euclidien."
      notes: "Comparateur spatial generique (meme limite que gam_spatial ci-dessus : W/champ euclidien sur Easting/Northing, pas le reseau hydrographique) -- pas une reproduction du modele INLA barrier+HUC10 des auteurs."
    - estimator: random_forest
      basis: benchmark_use
      source_ref: "Aucune -- comparateur ML generique, Y continu."
      notes: "Comparateur ML, pas le modele publie."
  conditionally_eligible_estimators: []
  ineligible_reason: "n/a -- estimateurs eligibles comme tache comparative (voir eligible_estimators), explicitement non equivalente au modele SSN/INLA publie."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 110
- k variables: 18
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 32611
- CRS nom: WGS 84 / UTM zone 11N
- Spatial extent: x [580218, 612127], y [5642845, 5701082]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: aucune reprojection necessaire -- CRS deja projete et metrique (EPSG:32611, WGS 84 / UTM zone 11N), adapte directement au calcul de distances/voisinage pour cette etendue locale (Banff, Alberta).

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.crjdfn391 (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`banff_stream_temperature` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `banff_stream_temperature` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formula_pub confirmee et verifiee (voir Reference publication) ; formula_used est une approximation generee distincte, explicitement etiquetee comme telle (voir Bloc 1 > Statut regression canonique > Note).
- CRS: OK - CRS renseigne dans le Bloc 5 (32611).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`banff_stream_temperature` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Statistical stream temperature modelling with SSN and INLA: an introduction for conservation practitioners

## Curation documentée — 2026-09-07

Decision conservatoire : 110 réponses WaterTemp et quatre X complets; SSN/INLA sur réseau hydrographique, simplification curateur. La fiche dit T=1, le loader déclare Year_. Examiner les années et le réseau; promouvoir seulement une tâche comparative explicitement distincte de SSN, avec construction W documentée. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

MISE A JOUR (2026-09-14) : variables corrigees dans les notes Estimator eligibility (Elev, RSlope, LE -- pas h2oAreaKm2/logRCA, retires apres lecture directe des scripts R des auteurs sur Zenodo).

Correction 2026-09-16 (mode production de secours) : incoherence interne detectee -- le Bloc 5 renseignait deja correctement CRS EPSG:32611 / WGS 84 UTM zone 11N (verifie par inspection directe du .rds : geom_point et geom_origine partagent ce meme CRS, bbox coherente avec la region de Banff, Alberta), mais le champ 'CRS analyse recommande' affichait encore le texte de gabarit par defaut "pending - CRS source non geographique ou inconnu", contredisant directement les deux lignes precedentes. Le jeu de donnees a bel et bien un CRS connu et documente ; corrige pour refleter qu'aucune reprojection n'est necessaire (deja en projection metrique locale adaptee).
