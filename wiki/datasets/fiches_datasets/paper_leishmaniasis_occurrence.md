---
title: paper_leishmaniasis_occurrence
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_leishmaniasis_occurrence.rds
  - DataCite_2014_GlobalDistributionMapsOf_10_7554_elife_02
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Global distribution maps of the leishmaniases" (DOI 10.7554/elife.02851).

## Description du jeu de donnees

- Topic: epidemiologie / distribution mondiale de la leishmaniose
- Observation unit: occurrence ponctuelle
- Observed population: cas de leishmaniose cutanee, mucocutanee et viscerale, echelle mondiale, N=7762 occurrences
- Geographic context: etendue sf: x [-106.0679, 125.57], y [-29.35, 50.7742]
- Temporal context: 52 distinct periods (variable: YEAR)
- Source description: Global distribution maps of the leishmaniases
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.7554/elife.02851
- Dataset DOI: 10.5061/dryad.05f5h
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.05f5h
- Local raw dir: `data/raw/papers/DataCite_2014_GlobalDistributionMapsOf_10_7554_elife_02/`
- Local sf output: `data/final_datasets/sf/paper_leishmaniasis_occurrence.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `DISEASE`
- Candidate Y typology: categorical
- Candidate X variables in local artifact: `SOURCE_TYPE`, `ADMIN_LEVEL`, `YEAR`, `COUNTRY`
- Candidate X count in local artifact: 4
- Candidate X typology: categorical, continuous
- Published X variables from paper: YEAR (annee du releve), SOURCE_TYPE (type de source bibliographique), ADMIN_LEVEL (niveau administratif de la localisation), COUNTRY (pays)
- Published X count: 4
- Coordinates (x, y - excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `OCCURRENCE_ID`, `LOCATION_TYPE`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `DISEASE` | `character` | categorical | n/a | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `leishmaniasis_occurrence`, la ou les reponses `DISEASE` viennent du loader papier et/ou des preuves de l article `Global distribution maps of the leishmaniases`. Les covariables X retenues sont `YEAR`, `SOURCE_TYPE`, `ADMIN_LEVEL`, `COUNTRY`. Les coordonnees (`X`, `Y`), identifiants (`OCCURRENCE_ID`, `LOCATION_TYPE`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `SOURCE_TYPE` | `character` | categorical | 0% |
| `ADMIN_LEVEL` | `numeric` | continuous | 0% |
| `YEAR` | `numeric` | continuous | 0% |
| `COUNTRY` | `character` | categorical | 0% |

### Formule - niveau publication

- formula_pub: P(occurrence) ~ [modele boosted regression trees (BRT) sur points de presence, pour cartographier la niche environnementale de la leishmaniose cutanee et viscerale a l'echelle mondiale, avec covariables climatiques/environnementales et generation de pseudo-absences]
- x_terms_pub: YEAR (annee du releve), SOURCE_TYPE (type de source bibliographique), ADMIN_LEVEL (niveau administratif de la localisation), COUNTRY (pays)
- y_term_pub: DISEASE (type clinique de leishmaniose au point d'occurrence : Cutaneous, Mucocutaneous, Visceral -- classification a 3 classes)
- Reference publication: Pigott et al. (2014), Global distribution maps of the leishmaniases, eLife, doi:10.7554/elife.02851. Le papier compile des points d'occurrence bibliographiques de leishmaniose cutanee et viscerale a l'echelle mondiale et ajuste des modeles boosted regression trees (BRT) avec covariables environnementales/climatiques et pseudo-absences generees pour cartographier le risque. Les fichiers deposes (CL_final_dataset.xlsx, VL_final_dataset.xlsx) ne contiennent que les points de presence reels (pas de pseudo-absences, ni les covariables environnementales du modele BRT complet, qui necessitent des rasters climatiques externes non inclus dans ce depot). formula_used reformule en classification du type clinique (Cutaneous/Mucocutaneous/Visceral) a partir des seules variables presentes dans le depot (annee, source, niveau administratif, pays), une simplification documentee -- pas le modele BRT du papier. Donnees brutes (CL_final_dataset.xlsx + VL_final_dataset.xlsx, localites de type 'point' uniquement) telechargees directement depuis Dryad (10.5061/dryad.05f5h) -- pas une reconstruction, N=7762 occurrences ponctuelles, echelle mondiale.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Pigott et al. (2014), Global distribution maps of the leishmaniases, eLife, doi:10.7554/elife.02851. Le papier compile des points d'occurrence bibliographiques de leishmaniose cutanee et viscerale a l'echelle mondiale et ajuste des modeles boosted regression trees (BRT) avec covariables environnementales/climatiques et pseudo-absences generees pour cartographier le risque. Les fichiers deposes (CL_final_dataset.xlsx, VL_final_dataset.xlsx) ne contiennent que les points de presence reels (pas de pseudo-absences, ni les covariables environnementales du modele BRT complet, qui necessitent des rasters climatiques externes non inclus dans ce depot). formula_used reformule en classification du type clinique (Cutaneous/Mucocutaneous/Visceral) a partir des seules variables presentes dans le depot (annee, source, niveau administratif, pays), une simplification documentee -- pas le modele BRT du papier. Donnees brutes (CL_final_dataset.xlsx + VL_final_dataset.xlsx, localites de type 'point' uniquement) telechargees directement depuis Dryad (10.5061/dryad.05f5h) -- pas une reconstruction, N=7762 occurrences ponctuelles, echelle mondiale.

### Formule - niveau systeme

- formula_used: DISEASE ~ YEAR + SOURCE_TYPE + ADMIN_LEVEL + COUNTRY
- x_terms_used: YEAR, SOURCE_TYPE, ADMIN_LEVEL, COUNTRY
- y_term_used: DISEASE
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Pigott et al. (2014), Global distribution maps of the leishmaniases, eLife, doi:10.7554/elife.02851. Le papier compile des points d'occurrence bibliographiques de leishmaniose cutanee et viscerale a l'echelle mondiale et ajuste des modeles boosted regression trees (BRT) avec covariables environnementales/climatiques et pseudo-absences generees pour cartographier le risque. Les fichiers deposes (CL_final_dataset.xlsx, VL_final_dataset.xlsx) ne contiennent que les points de presence reels (pas de pseudo-absences, ni les covariables environnementales du modele BRT complet, qui necessitent des rasters climatiques externes non inclus dans ce depot). formula_used reformule en classification du type clinique (Cutaneous/Mucocutaneous/Visceral) a partir des seules variables presentes dans le depot (annee, source, niveau administratif, pays), une simplification documentee -- pas le modele BRT du papier. Donnees brutes (CL_final_dataset.xlsx + VL_final_dataset.xlsx, localites de type 'point' uniquement) telechargees directement depuis Dryad (10.5061/dryad.05f5h) -- pas une reconstruction, N=7762 occurrences ponctuelles, echelle mondiale.

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
    formula: "DISEASE ~ YEAR + SOURCE_TYPE + ADMIN_LEVEL + COUNTRY"
    response: "DISEASE (type clinique de leishmaniose au point d'occurrence : Cutaneous, Mucocutaneous, Visceral -- classification a 3 classes)"
    predictors: ["YEAR (annee du releve)", "SOURCE_TYPE (type de source bibliographique)", "ADMIN_LEVEL (niveau administratif de la localisation)", "COUNTRY (pays)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Pigott et al. (2014), Global distribution maps of the leishmaniases, eLife, doi:10.7554/elife.02851. Le papier compile des points d'occurrence bibliographiques de leishmaniose cutanee et viscerale a l'echelle mondiale et ajuste des modeles boosted regression trees (BRT) avec covariables environnementales/climatiques et pseudo-absences generees pour cartographier le risque. Les fichiers deposes (CL_final_dataset.xlsx, VL_final_dataset.xlsx) ne contiennent que les points de presence reels (pas de pseudo-absences, ni les covariables environnementales du modele BRT complet, qui necessitent des rasters climatiques externes non inclus dans ce depot). formula_used reformule en classification du type clinique (Cutaneous/Mucocutaneous/Visceral) a partir des seules variables presentes dans le depot (annee, source, niveau administratif, pays), une simplification documentee -- pas le modele BRT du papier. Donnees brutes (CL_final_dataset.xlsx + VL_final_dataset.xlsx, localites de type 'point' uniquement) telechargees directement depuis Dryad (10.5061/dryad.05f5h) -- pas une reconstruction, N=7762 occurrences ponctuelles, echelle mondiale."
    estimator_context: ["random_forest", "gamboost", "xgboost"]
    status: "confirmed"

  ml_or_selected:
    formula: "DISEASE ~ YEAR + SOURCE_TYPE + ADMIN_LEVEL + COUNTRY"
    response: "DISEASE"
    predictors: ["YEAR", "SOURCE_TYPE", "ADMIN_LEVEL", "COUNTRY"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Pigott et al. (2014), Global distribution maps of the leishmaniases, eLife, doi:10.7554/elife.02851. Le papier compile des points d'occurrence bibliographiques de leishmaniose cutanee et viscerale a l'echelle mondiale et ajuste des modeles boosted regression trees (BRT) avec covariables environnementales/climatiques et pseudo-absences generees pour cartographier le risque. Les fichiers deposes (CL_final_dataset.xlsx, VL_final_dataset.xlsx) ne contiennent que les points de presence reels (pas de pseudo-absences, ni les covariables environnementales du modele BRT complet, qui necessitent des rasters climatiques externes non inclus dans ce depot). formula_used reformule en classification du type clinique (Cutaneous/Mucocutaneous/Visceral) a partir des seules variables presentes dans le depot (annee, source, niveau administratif, pays), une simplification documentee -- pas le modele BRT du papier. Donnees brutes (CL_final_dataset.xlsx + VL_final_dataset.xlsx, localites de type 'point' uniquement) telechargees directement depuis Dryad (10.5061/dryad.05f5h) -- pas une reconstruction, N=7762 occurrences ponctuelles, echelle mondiale."
    estimator_context: ["glm_logistic", "random_forest", "random_forest_xy", "xgboost", "gwr"]
    status: "executable_binary_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_leishmaniasis_occurrence`
- Dataset name: Data from: Global distribution maps of the Leishmaniases
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Global distribution maps of the leishmaniases
- Paper DOI: 10.7554/elife.02851
- Dataset DOI: 10.5061/dryad.05f5h
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.05f5h
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "P(occurrence) ~ [modele boosted regression trees (BRT) sur points de presence, pour cartographier la niche environnementale de la leishmaniose cutanee et viscerale a l'echelle mondiale, avec covariables climatiques/environnementales et generation de pseudo-absences]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Pigott et al. (2014), Global distribution maps of the leishmaniases, eLife, doi:10.7554/elife.02851. Le papier compile des points d'occurrence bibliographiques de leishmaniose cutanee et viscerale a l'echelle mondiale et ajuste des modeles boosted regression trees (BRT) avec covariables environnementales/climatiques et pseudo-absences generees pour cartographier le risque. Les fichiers deposes (CL_final_dataset.xlsx, VL_final_dataset.xlsx) ne contiennent que les points de presence reels (pas de pseudo-absences, ni les covariables environnementales du modele BRT complet, qui necessitent des rasters climatiques externes non inclus dans ce depot). formula_used reformule en classification du type clinique (Cutaneous/Mucocutaneous/Visceral) a partir des seules variables presentes dans le depot (annee, source, niveau administratif, pays), une simplification documentee -- pas le modele BRT du papier. Donnees brutes (CL_final_dataset.xlsx + VL_final_dataset.xlsx, localites de type 'point' uniquement) telechargees directement depuis Dryad (10.5061/dryad.05f5h) -- pas une reconstruction, N=7762 occurrences ponctuelles, echelle mondiale."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "classification_binary_presence_absence_sdm"
  package_include: "yes"
  has_local_rds: true
  missing_items: "le papier ajuste un modele BRT sur presence/pseudo-absence avec covariables climatiques externes (rasters non inclus dans ce depot) -- formula_used reformule en classification du type clinique a partir des seules variables presentes (pas de pseudo-absences, pas de covariables environnementales) -- promu a package_include='yes' apres validation utilisateur (session 2026-08-16, groupe A)"
  reason: "Y categoriel reel (type clinique de leishmaniose, 3 classes), N=7762 occurrences ponctuelles reelles avec coordonnees mondiales, covariables administratives/temporelles reelles. Fichiers originaux (localites 'point' uniquement) telecharges directement depuis Dryad, pas une reconstruction. Papier deja identifie (Pigott et al. 2014, eLife) et PDF deja integre."
```

- Decision: ready
- Manque principal: le papier ajuste un modele BRT sur presence/pseudo-absence avec covariables climatiques externes (rasters non inclus dans ce depot) -- formula_used reformule en classification du type clinique a partir des seules variables presentes (pas de pseudo-absences, pas de covariables environnementales) -- promu a package_include="yes" apres validation utilisateur (session 2026-08-16, groupe A)
- Raison: Y categoriel reel (type clinique de leishmaniose, 3 classes), N=7762 occurrences ponctuelles reelles avec coordonnees mondiales, covariables administratives/temporelles reelles. Fichiers originaux (localites 'point' uniquement) telecharges directement depuis Dryad, pas une reconstruction. Papier deja identifie (Pigott et al. 2014, eLife) et PDF deja integre.

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

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 7762
- k variables: 10
- T periods: 52
- Variable temporelle: YEAR
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (7762) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 2771 ; panel NON EQUILIBRE (T par unite : min=1, mediane=1, max=31). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 2771 unites spatiales distinctes, pas sur les 7762 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 52 distinct periods (variable: YEAR)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-106.0679, 125.57], y [-29.35, 50.7742]
- Time range: 1958 to 2013 (variable: YEAR)
- CRS analyse recommande: pending - multi-zones (span=231.6deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`leishmaniasis_occurrence` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `leishmaniasis_occurrence` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`leishmaniasis_occurrence` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Global distribution maps of the leishmaniases

