---
title: paper_sfbay_contaminated_sites
type: dataset
created: 2026-08-16
updated: 2026-09-07
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
- Geographic context: Etendue mesuree dans le RDS : x [-122.6498456, -121.8702426], y [37.385456, 38.3224]; CRS EPSG:4326.
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
- Candidate X variables in local artifact: `COUNTY`, `SITE_TYPE`, `ACRES_numeric`, `RESTRICTED`, `gridcode`
- Candidate X count in local artifact: 5
- Candidate X typology: categorical, continuous
- Published X variables from paper: gridcode
- Published X count: 1
- Coordinates (x, y - excluded from X candidates): `LONGITUDE`, `LATITUDE`
- Identifier/excluded columns (excluded from X candidates): `FID_DTSC_S`, `FID_Rise_S` (ID de polygone ArcGIS, pas une covariable -- voir Note), `STATUS` (fuite de cible totale envers is_open_case -- voir Note), `ACRES` (version texte brute, remplacee par `ACRES_numeric`)
- Variables inspected: yes (auto - generate_fiches_papers.R), corrige par inspection manuelle du README du depot (2026-09-09)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `is_open_case` | `integer` | binary | {0, 1} | 0% |

> Selection Y/X (corrigee, 2026-09-09) : deux problemes trouves par inspection directe du RDS et du README du depot brut.
> 1. **`STATUS` retire** : fuite de cible totale envers `is_open_case` -- tableau croise confirme que STATUS determine directement is_open_case (ex. 'Active'/'Refer: *' -> 1 ; 'No Further Action'/'Certified' -> 0), c'est litteralement la colonne source dont `is_open_case` a ete derive. Ne jamais l'utiliser comme X.
> 2. **`FID_Rise_S` retire** : le README du depot (`data/raw/papers/DatasetFirst_10_6078_d15x4n/README.md`) confirme que les shapefiles source (`OpenSites_Kh1_SLR1m_RGWorInund`) sont deja le resultat d'un outil d'intersection ArcGIS -- `FID_Rise_S` (10 valeurs distinctes, prefixe 'FID' = Feature ID standard ArcGIS) est l'identifiant du polygone de remontee de nappe joint spatialement, pas une covariable substantielle ; sa signification exacte (quel ordre/quelle hierarchie entre les 10 polygones) n'est pas documentee, et il etait de toute facon type a tort en continu (un ID de polygone n'a pas d'ordre numerique). `gridcode` en revanche EST documente explicitement dans le README (reclassification raster : cellules avec >= 0.1016m/4" de remontee de nappe -> 1, sinon 0) -- conserve comme la seule covariable directement issue de la methode du papier.
> Remplacement par des covariables reelles et documentees : `SITE_TYPE` (type de site de contamination), `RESTRICTED` (restriction d'usage du sol), `COUNTY` (comte), `ACRES_numeric` (superficie du site, nettoyee depuis le champ texte original -- valeurs '< 1' laissees NA plutot que devinees). Statut benchmark actuel : ready.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `gridcode` | `numeric` | binary | 0% |
| `SITE_TYPE` | `character` | categorical | 0.1% |
| `RESTRICTED` | `character` | categorical | 0.1% |
| `COUNTY` | `character` | categorical | 0% |
| `ACRES_numeric` | `numeric` | continuous | 30.5% |

### Formule - niveau publication

- formula_pub: is_open_case ~ gridcode (zone de remontee de nappe >= 4 pouces, reclassification README) [le papier compare la vulnerabilite des sites contamines (statut ouvert/actif vs ferme) aux zones de remontee de nappe phreatique (GWR) et d'inondation par elevation du niveau marin, sur les bases de donnees Envirostor (DTSC) et GeoTracker (SWRCB) combinees pour la baie de San Francisco. CORRECTION 2026-09-09 : FID_Rise_S retire (ID de polygone ArcGIS, pas une covariable -- voir Note Bloc 1)]
- x_terms_pub: gridcode
- y_term_pub: is_open_case
- Reference publication: Hill, Hirshfeld, Lindquist, Cook & Warner (2023), Rising Coastal Groundwater as a Result of Sea-Level Rise Will Influence Contaminated Coastal Sites and Underground Infrastructure, Earth's Future, doi:10.1029/2023ef003825. Le papier combine les bases Envirostor (DTSC) et GeoTracker (SWRCB) pour cartographier les sites contamines de la baie de San Francisco et evalue leur vulnerabilite a la remontee de nappe phreatique (GWR) et a l'inondation cotiere sous un scenario d'elevation du niveau marin de 1m ; il classe explicitement les sites en 'open' (investigation/remediation active) vs 'closed' (remediation terminee, residus de contamination possibles). Donnees brutes (shapefiles ClosedSites/OpenSites_Kh1_SLR1m_RGWorInund, zip nomme d'apres les auteurs du papier HillHirshfeldLindquistCookWarner) telechargees directement depuis Dryad (10.6078/d15x4n, fichier de 782MB deconseille au telechargement automatique par la taille -- recupere manuellement par l'utilisateur, session 2026-08-16) -- pas une reconstruction, N=802 sites uniques (dedoublonnage necessaire : les tables sources contenaient des doublons par site issus de jointures spatiales multiples), coordonnees reelles (baie de San Francisco).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: is_open_case ~ gridcode + SITE_TYPE + RESTRICTED + COUNTY
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: binary
- x_terms_used: gridcode, SITE_TYPE, RESTRICTED, COUNTY
- y_term_used: is_open_case
- Note: CORRECTION 2026-09-09 (voir Note Bloc 1) -- FID_Rise_S (ID de polygone, pas une covariable) et STATUS (fuite de cible) retires. `gridcode` (seule variable directement issue de la methode du papier) conserve ; `SITE_TYPE`/`RESTRICTED`/`COUNTY` ajoutes comme covariables reelles et completes (>=99.9% non-NA). `ACRES_numeric` disponible (nettoye depuis le champ texte original) mais non retenu dans la formule principale (30.5% de NA, casserait le complete-case sur ~245 lignes) -- utilisable dans une variante etendue si besoin.

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
    formula: "is_open_case ~ gridcode + SITE_TYPE + RESTRICTED + COUNTY"
    response: "is_open_case"
    predictors: ["gridcode", "SITE_TYPE", "RESTRICTED", "COUNTY"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "gridcode : README du depot (reclassification GW-rise >=4 pouces). SITE_TYPE/RESTRICTED/COUNTY : attributs reels du shapefile, pas le papier lui-meme. CORRECTION 2026-09-09 : FID_Rise_S (ID de polygone) retire, voir Bloc 1 Note."
    estimator_context: ["random_forest", "gamboost", "xgboost"]
    status: "confirmed_corrected"

  ml_or_selected:
    formula: "is_open_case ~ gridcode + SITE_TYPE + RESTRICTED + COUNTY + ACRES_numeric"
    response: "is_open_case"
    predictors: ["gridcode", "SITE_TYPE", "RESTRICTED", "COUNTY", "ACRES_numeric"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir multivariate_constrained -- variante etendue avec ACRES_numeric (30.5% NA, non retenue par defaut)."
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
  equation_text: "is_open_case ~ gridcode + SITE_TYPE + RESTRICTED + COUNTY [le papier compare la vulnerabilite des sites contamines (statut ouvert/actif vs ferme) aux zones de remontee de nappe phreatique (GWR = Groundwater Rise, PAS Geographically Weighted Regression) et d'inondation par elevation du niveau marin. CORRECTION 2026-09-09 : FID_Rise_S retire (ID de polygone, pas une covariable)]"
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
      notes: "Probit spatial (SAR) -- pertinent si dependance spatiale genuine, non confirme specifiquement pour ce jeu."
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

## Note -- promotion en lot (2026-09-09)

Formule, reponse et covariables deja resolues (Y/X/formula_used complets avant cette passe). Seul le bloc 'Estimator eligibility' etait vide -- rempli ici avec les estimateurs generiques adaptes a la typologie Y (binary), sur decision explicite de l'utilisateur de revoir en lot les fiches 'manual_review' deja completes. Base 'scientific_evidence' reservee aux cas ou le texte de la fiche documente deja une methode precise ; sinon 'benchmark_use'/'generated_candidate' (pas de surinterpretation de la methode publiee).

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Rising Coastal Groundwater as a Result of Sea-Level Rise Will Influence Contaminated Coastal Sites and Underground Infrastructure

## Curation documentée — 2026-09-07

Decision conservatoire : Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : binary. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
