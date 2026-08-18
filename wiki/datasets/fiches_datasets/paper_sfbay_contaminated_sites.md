---
title: paper_sfbay_contaminated_sites
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_sfbay_contaminated_sites.rds
  - DatasetFirst_10_6078_d15x4n
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Rising Coastal Groundwater as a Result of Sea-Level Rise Will Influence Contaminated Coastal Sites and Underground Infrastructure" (DOI 10.1029/2023ef003825).

## Description du jeu de donnees

- Topic: risque environnemental / remontee de nappe et sites contamines
- Observation unit: site contamine (DTSC/SWRCB)
- Observed population: sites contamines de la baie de San Francisco, N=802 sites
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: Rising Coastal Groundwater as a Result of Sea-Level Rise Will Influence Contaminated Coastal Sites and Underground Infrastructure
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1029/2023ef003825
- Dataset DOI: 10.6078/d15x4n
- Source URL: https://doi.org/10.6078/d15x4n
- Local raw dir: `data/raw/papers/DatasetFirst_10_6078_d15x4n/`
- Local sf output: `data/final_datasets/sf/paper_sfbay_contaminated_sites.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `is_open_case`
- Candidate Y typology: binary
- Candidate X variables in local artifact: `COUNTY`, `SITE_TYPE`, `ACRES`, `STATUS`, `RESTRICTED`, `gridcode`, `FID_Rise_S`
- Candidate X count in local artifact: 7
- Candidate X typology: categorical, continuous
- Published X variables from paper: FID_Rise_S (classe de risque de remontee de nappe phreatique sous scenario d'elevation du niveau marin de 1m, 10 classes), gridcode (indicateur de zone d'inondation cotiere), COUNTY (comte)
- Published X count: 3
- Coordinates (x, y - excluded from X candidates): `LONGITUDE`, `LATITUDE`
- Identifier columns (excluded from X candidates): `FID_DTSC_S`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `is_open_case` | `integer` | binary | {0, 1} | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `sfbay_contaminated_sites`, la ou les reponses `is_open_case` viennent du loader papier et/ou des preuves de l article `Rising Coastal Groundwater as a Result of Sea-Level Rise Will Influence Contaminated Coastal Sites and Underground Infrastructure`. Les covariables X retenues sont `FID_Rise_S`, `gridcode`, `COUNTY` ; 4 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`LONGITUDE`, `LATITUDE`), identifiants (`FID_DTSC_S`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `COUNTY` | `character` | categorical | 0% |
| `SITE_TYPE` | `character` | categorical | 0.1% |
| `ACRES` | `character` | categorical | 30.4% |
| `STATUS` | `character` | categorical | 0% |
| `RESTRICTED` | `character` | categorical | 0.1% |
| `gridcode` | `numeric` | binary | 0% |
| `FID_Rise_S` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: is_open_case ~ FID_Rise_S (niveau de risque de remontee de nappe) + gridcode (zone d'inondation) [le papier compare la vulnerabilite des sites contamines (statut ouvert/actif vs ferme) aux zones de remontee de nappe phreatique (GWR) et d'inondation par elevation du niveau marin, sur les bases de donnees Envirostor (DTSC) et GeoTracker (SWRCB) combinees pour la baie de San Francisco]
- x_terms_pub: FID_Rise_S (classe de risque de remontee de nappe phreatique sous scenario d'elevation du niveau marin de 1m, 10 classes), gridcode (indicateur de zone d'inondation cotiere), COUNTY (comte)
- y_term_pub: is_open_case (statut du site contamine : 1=ouvert/actif en investigation-remediation, 0=ferme/remediation terminee -- residus de contamination possibles meme fermes)
- Reference publication: Hill, Hirshfeld, Lindquist, Cook & Warner (2023), Rising Coastal Groundwater as a Result of Sea-Level Rise Will Influence Contaminated Coastal Sites and Underground Infrastructure, Earth's Future, doi:10.1029/2023ef003825. Le papier combine les bases Envirostor (DTSC) et GeoTracker (SWRCB) pour cartographier les sites contamines de la baie de San Francisco et evalue leur vulnerabilite a la remontee de nappe phreatique (GWR) et a l'inondation cotiere sous un scenario d'elevation du niveau marin de 1m ; il classe explicitement les sites en 'open' (investigation/remediation active) vs 'closed' (remediation terminee, residus de contamination possibles). Donnees brutes (shapefiles ClosedSites/OpenSites_Kh1_SLR1m_RGWorInund, zip nomme d'apres les auteurs du papier HillHirshfeldLindquistCookWarner) telechargees directement depuis Dryad (10.6078/d15x4n, fichier de 782MB deconseille au telechargement automatique par la taille -- recupere manuellement par l'utilisateur, session 2026-08-16) -- pas une reconstruction, N=802 sites uniques (dedoublonnage necessaire : les tables sources contenaient des doublons par site issus de jointures spatiales multiples), coordonnees reelles (baie de San Francisco).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: is_open_case ~ FID_Rise_S + gridcode + COUNTY
- x_terms_used: FID_Rise_S, gridcode, COUNTY
- y_term_used: is_open_case
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

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
    formula: "is_open_case ~ FID_Rise_S + gridcode + COUNTY"
    response: "is_open_case (statut du site contamine : 1=ouvert/actif en investigation-remediation, 0=ferme/remediation terminee -- residus de contamination possibles meme fermes)"
    predictors: ["FID_Rise_S (classe de risque de remontee de nappe phreatique sous scenario d'elevation du niveau marin de 1m, 10 classes)", "gridcode (indicateur de zone d'inondation cotiere)", "COUNTY (comte)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["random_forest", "gamboost", "xgboost"]
    status: "confirmed"

  ml_or_selected:
    formula: "is_open_case ~ FID_Rise_S + gridcode + COUNTY + ACRES"
    response: "is_open_case"
    predictors: ["FID_Rise_S", "gridcode", "COUNTY", "ACRES"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["glm_logistic", "random_forest", "random_forest_xy", "xgboost", "gwr"]
    status: "executable_binary_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_sfbay_contaminated_sites`
- Dataset name: Sea level rise, groundwater rise, and contaminated sites in the San Francisco Bay Area, and Superfund Sites in the contiguous United States
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Rising Coastal Groundwater as a Result of Sea-Level Rise Will Influence Contaminated Coastal Sites and Underground Infrastructure
- Paper DOI: 10.1029/2023ef003825
- Dataset DOI: 10.6078/d15x4n
- Source URL: https://doi.org/10.6078/d15x4n
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "is_open_case ~ FID_Rise_S (niveau de risque de remontee de nappe) + gridcode (zone d'inondation) [le papier compare la vulnerabilite des sites contamines (statut ouvert/actif vs ferme) aux zones de remontee de nappe phreatique (GWR) et d'inondation par elevation du niveau marin, sur les bases de donnees Envirostor (DTSC) et GeoTracker (SWRCB) combinees pour la baie de San Francisco]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Hill, Hirshfeld, Lindquist, Cook & Warner (2023), Rising Coastal Groundwater as a Result of Sea-Level Rise Will Influence Contaminated Coastal Sites and Underground Infrastructure, Earth's Future, doi:10.1029/2023ef003825. Le papier combine les bases Envirostor (DTSC) et GeoTracker (SWRCB) pour cartographier les sites contamines de la baie de San Francisco et evalue leur vulnerabilite a la remontee de nappe phreatique (GWR) et a l'inondation cotiere sous un scenario d'elevation du niveau marin de 1m ; il classe explicitement les sites en 'open' (investigation/remediation active) vs 'closed' (remediation terminee, residus de contamination possibles). Donnees brutes (shapefiles ClosedSites/OpenSites_Kh1_SLR1m_RGWorInund, zip nomme d'apres les auteurs du papier HillHirshfeldLindquistCookWarner) telechargees directement depuis Dryad (10.6078/d15x4n, fichier de 782MB deconseille au telechargement automatique par la taille -- recupere manuellement par l'utilisateur, session 2026-08-16) -- pas une reconstruction, N=802 sites uniques (dedoublonnage necessaire : les tables sources contenaient des doublons par site issus de jointures spatiales multiples), coordonnees reelles (baie de San Francisco)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "classification_binary_presence_absence_sdm"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun -- shapefiles originaux (sous-ensemble cible extrait du zip complet de 782MB) telecharges directement depuis Dryad, N=802 sites uniques apres dedoublonnage documente"
  reason: "Y binaire reel (statut ouvert/ferme du site contamine, explicitement defini et analyse par le papier), N=802 sites uniques avec coordonnees reelles (baie de San Francisco), covariables de risque de remontee de nappe et d'inondation exactement celles du papier (memes noms de champs que la geodatabase source). Shapefiles originaux telecharges directement depuis Dryad, pas une reconstruction. Papier identifie via correspondance exacte du nom de fichier zip (HillHirshfeldLindquistCookWarner) avec les auteurs, texte integral lu (TEI) pour confirmer la definition open/closed et les covariables de risque."
```

- Decision: ready
- Manque principal: aucun -- shapefiles originaux (sous-ensemble cible extrait du zip complet de 782MB) telecharges directement depuis Dryad, N=802 sites uniques apres dedoublonnage documente
- Raison: Y binaire reel (statut ouvert/ferme du site contamine, explicitement defini et analyse par le papier), N=802 sites uniques avec coordonnees reelles (baie de San Francisco), covariables de risque de remontee de nappe et d'inondation exactement celles du papier (memes noms de champs que la geodatabase source). Shapefiles originaux telecharges directement depuis Dryad, pas une reconstruction. Papier identifie via correspondance exacte du nom de fichier zip (HillHirshfeldLindquistCookWarner) avec les auteurs, texte integral lu (TEI) pour confirmer la definition open/closed et les covariables de risque.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready"
  eligible_estimators: []
  conditionally_eligible_estimators: ["random_forest", "random_forest_xy", "gamboost", "xgboost", "xgboost_xy", "gam_spatial"]
  ineligible_reason: "reponse binaire (presence/absence) ; le registre benchmark du package (13-benchmark-spatial.R) code en dur mode='regression' pour tous les estimateurs automatiques -- aucun ne supporte de mode classification/binomial aujourd'hui. random_forest/gamboost/xgboost sont notes conditionnels car ce sont les estimateurs que le papier source a reellement utilises (RF/BRT) ; ols/sar_lag/sem_error/sdm_mixed/gwr restent hors de propos pour une reponse binaire (hypothese gaussienne continue) et ne sont pas listes."
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 802
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
- Spatial extent: x [-122.6498456, -121.8702426], y [37.385456, 38.3224]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32610 (UTM Zone 10N (EPSG:32610)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.6078/d15x4n (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`sfbay_contaminated_sites` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `sfbay_contaminated_sites` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20%: ACRES (NA=30.4%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`sfbay_contaminated_sites` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Rising Coastal Groundwater as a Result of Sea-Level Rise Will Influence Contaminated Coastal Sites and Underground Infrastructure

