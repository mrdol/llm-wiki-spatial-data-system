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
- Candidate X variables in local artifact: `COUNTY`, `SITE_TYPE`, `ACRES`, `STATUS`, `RESTRICTED`, `gridcode`, `FID_Rise_S`
- Candidate X count in local artifact: 7
- Candidate X typology: categorical, continuous
- Published X variables from paper: FID_Rise_S, gridcode, COUNTY
- Published X count: 3
- Coordinates (x, y - excluded from X candidates): `LONGITUDE`, `LATITUDE`
- Identifier columns (excluded from X candidates): `FID_DTSC_S`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `is_open_case` | `integer` | binary | {0, 1} | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `sfbay_contaminated_sites`, la ou les reponses `is_open_case` viennent du loader papier et/ou des preuves de l article `Rising Coastal Groundwater as a Result of Sea-Level Rise Will Influence Contaminated Coastal Sites and Underground Infrastructure`. Les covariables X retenues sont `FID_Rise_S`, `gridcode`, `COUNTY` ; 4 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`LONGITUDE`, `LATITUDE`), identifiants (`FID_DTSC_S`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : manual_review; la promotion package reste conditionnee au bloc benchmark_readiness.

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
- x_terms_pub: FID_Rise_S, gridcode, COUNTY
- y_term_pub: is_open_case
- Reference publication: Hill, Hirshfeld, Lindquist, Cook & Warner (2023), Rising Coastal Groundwater as a Result of Sea-Level Rise Will Influence Contaminated Coastal Sites and Underground Infrastructure, Earth's Future, doi:10.1029/2023ef003825. Le papier combine les bases Envirostor (DTSC) et GeoTracker (SWRCB) pour cartographier les sites contamines de la baie de San Francisco et evalue leur vulnerabilite a la remontee de nappe phreatique (GWR) et a l'inondation cotiere sous un scenario d'elevation du niveau marin de 1m ; il classe explicitement les sites en 'open' (investigation/remediation active) vs 'closed' (remediation terminee, residus de contamination possibles). Donnees brutes (shapefiles ClosedSites/OpenSites_Kh1_SLR1m_RGWorInund, zip nomme d'apres les auteurs du papier HillHirshfeldLindquistCookWarner) telechargees directement depuis Dryad (10.6078/d15x4n, fichier de 782MB deconseille au telechargement automatique par la taille -- recupere manuellement par l'utilisateur, session 2026-08-16) -- pas une reconstruction, N=802 sites uniques (dedoublonnage necessaire : les tables sources contenaient des doublons par site issus de jointures spatiales multiples), coordonnees reelles (baie de San Francisco).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: is_open_case ~ FID_Rise_S + gridcode + COUNTY
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: binary
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
    response: "is_open_case"
    predictors: ["FID_Rise_S", "gridcode", "COUNTY"]
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
  benchmark_status: "manual_review"
  benchmark_task: "review_binary"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache."
  reason: "Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache."
```

- Decision: manual_review
- Manque principal: Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Raison: Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache."
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

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Rising Coastal Groundwater as a Result of Sea-Level Rise Will Influence Contaminated Coastal Sites and Underground Infrastructure

## Curation documentée — 2026-09-07

Decision conservatoire : Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : binary. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
