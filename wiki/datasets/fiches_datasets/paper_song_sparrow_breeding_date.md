---
title: paper_song_sparrow_breeding_date
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_song_sparrow_breeding_date.rds
  - DatasetFirst_10_5061_dryad_n0513
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Direct and indirect genetic and fine‐scale location effects on breeding date in song sparrows" (DOI 10.1111/1365-2656.12575).

## Description du jeu de donnees

- Topic: ecologie evolutive / genetique quantitative de la phenologie de reproduction
- Observation unit: nid (evenement de reproduction)
- Observed population: bruants chanteurs (Melospiza melodia), ile de Mandarte, Colombie-Britannique, Canada, N=1040 nids
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: 38 distinct periods (variable: year)
- Source description: Direct and indirect genetic and fine‐scale location effects on breeding date in song sparrows
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/1365-2656.12575
- Dataset DOI: 10.5061/dryad.n0513
- Source URL: https://doi.org/10.5061/dryad.n0513
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_n0513/`
- Local sf output: `data/final_datasets/sf/paper_song_sparrow_breeding_date.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Breeding_Date`
- Candidate Y typology: count
- Candidate X variables in local artifact: `year`, `male_f`, `male_age`, `male_is`, `female_f`, `female_age`, `female_is`
- Candidate X count in local artifact: 7
- Candidate X typology: continuous, categorical
- Published X variables from paper: female_f/male_f (coefficient de consanguinite), female_age/male_age (classe d'age: 1, 2-4, 5+), female_is/male_is (statut immigrant: 0=residente, 1=immigrante)
- Published X count: 3
- Coordinates (x, y - excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): `nestrec`, `female.animal_Num`, `female.factor_Num`, `male.animal_Num`, `male.factor_Num`, `female_father_Num`, `female_mother_Num`, `Cell_ID_16mDiam`, `UTM_X`, `UTM_Y`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Breeding_Date` | `integer` | count | [57, 171] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `song_sparrow_breeding_date`, la ou les reponses `Breeding_Date` viennent du loader papier et/ou des preuves de l article `Direct and indirect genetic and fine‐scale location effects on breeding date in song sparrows`. Les covariables X retenues sont `female_f`, `female_age`, `female_is`, `male_f`, `male_age`, `male_is` ; 1 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`lon`, `lat`), identifiants (`nestrec`, `female.animal_Num`, `female.factor_Num`, `male.animal_Num`, `male.factor_Num`, `female_father_Num`, `female_mother_Num`, `Cell_ID_16mDiam`, `UTM_X`, `UTM_Y`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `year` | `integer` | count | 0% |
| `male_f` | `numeric` | rate | 0% |
| `male_age` | `character` | categorical | 0% |
| `male_is` | `integer` | binary | 0% |
| `female_f` | `numeric` | rate | 0% |
| `female_age` | `character` | categorical | 0% |
| `female_is` | `integer` | binary | 0% |

### Formule - niveau publication

- formula_pub: y = Xb + Z1*a_female + Z2*a_male + Z3*PI_female + Z4*PI_male + Z5*Year + e [modele animal quantitatif-genetique (mixed model) avec effets fixes b (coefficients de consanguinite, classes d'age, statut immigrant, par sexe) et effets aleatoires genetiques additifs (matrice de parente A issue du pedigree), effets individuels permanents, annee et residus ; trois variantes spatiales ajoutent en plus des effets de localisation de nid]
- x_terms_pub: female_f/male_f (coefficient de consanguinite), female_age/male_age (classe d'age: 1, 2-4, 5+), female_is/male_is (statut immigrant: 0=residente, 1=immigrante)
- y_term_pub: Breeding_Date (date de premiere ponte, jour julien depuis le 1er janvier)
- Reference publication: Germain, Wolak, Arcese, Losdat & Reid (2016), Direct and indirect genetic and fine-scale location effects on breeding date in song sparrows, Journal of Animal Ecology, doi:10.1111/1365-2656.12575. Le papier ajuste un modele animal quantitatif-genetique complet (equation 1 du texte : y = Xb + Z1a' + Z2a'' + Z3PI' + Z4PI'' + Z5Y + e) avec effets aleatoires genetiques (pedigree, matrice A) et de localisation spatiale non reproductibles sans le pedigree complet et le solveur animal model. formula_used retient exactement la partie effets fixes (b) du papier : consanguinite, classe d'age et statut immigrant, separement pour la femelle et le male. Donnees brutes (Main_Dataset.txt) telechargees directement depuis Dryad (10.5061/dryad.n0513) -- pas une reconstruction, N=1040 nids, ile de Mandarte, Colombie-Britannique, Canada, coordonnees UTM reelles converties en WGS84.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Germain, Wolak, Arcese, Losdat & Reid (2016), Direct and indirect genetic and fine-scale location effects on breeding date in song sparrows, Journal of Animal Ecology, doi:10.1111/1365-2656.12575. Le papier ajuste un modele animal quantitatif-genetique complet (equation 1 du texte : y = Xb + Z1a' + Z2a'' + Z3PI' + Z4PI'' + Z5Y + e) avec effets aleatoires genetiques (pedigree, matrice A) et de localisation spatiale non reproductibles sans le pedigree complet et le solveur animal model. formula_used retient exactement la partie effets fixes (b) du papier : consanguinite, classe d'age et statut immigrant, separement pour la femelle et le male. Donnees brutes (Main_Dataset.txt) telechargees directement depuis Dryad (10.5061/dryad.n0513) -- pas une reconstruction, N=1040 nids, ile de Mandarte, Colombie-Britannique, Canada, coordonnees UTM reelles converties en WGS84.

### Formule - niveau systeme

- formula_used: Breeding_Date ~ female_f + female_age + female_is + male_f + male_age + male_is
- x_terms_used: female_f, female_age, female_is, male_f, male_age, male_is
- y_term_used: Breeding_Date
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Germain, Wolak, Arcese, Losdat & Reid (2016), Direct and indirect genetic and fine-scale location effects on breeding date in song sparrows, Journal of Animal Ecology, doi:10.1111/1365-2656.12575. Le papier ajuste un modele animal quantitatif-genetique complet (equation 1 du texte : y = Xb + Z1a' + Z2a'' + Z3PI' + Z4PI'' + Z5Y + e) avec effets aleatoires genetiques (pedigree, matrice A) et de localisation spatiale non reproductibles sans le pedigree complet et le solveur animal model. formula_used retient exactement la partie effets fixes (b) du papier : consanguinite, classe d'age et statut immigrant, separement pour la femelle et le male. Donnees brutes (Main_Dataset.txt) telechargees directement depuis Dryad (10.5061/dryad.n0513) -- pas une reconstruction, N=1040 nids, ile de Mandarte, Colombie-Britannique, Canada, coordonnees UTM reelles converties en WGS84.

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
    formula: "Breeding_Date ~ female_f + female_age + female_is + male_f + male_age + male_is"
    response: "Breeding_Date (date de premiere ponte, jour julien depuis le 1er janvier)"
    predictors: ["female_f/male_f (coefficient de consanguinite)", "female_age/male_age (classe d'age: 1, 2-4, 5+)", "female_is/male_is (statut immigrant: 0=residente, 1=immigrante)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Germain, Wolak, Arcese, Losdat & Reid (2016), Direct and indirect genetic and fine-scale location effects on breeding date in song sparrows, Journal of Animal Ecology, doi:10.1111/1365-2656.12575. Le papier ajuste un modele animal quantitatif-genetique complet (equation 1 du texte : y = Xb + Z1a' + Z2a'' + Z3PI' + Z4PI'' + Z5Y + e) avec effets aleatoires genetiques (pedigree, matrice A) et de localisation spatiale non reproductibles sans le pedigree complet et le solveur animal model. formula_used retient exactement la partie effets fixes (b) du papier : consanguinite, classe d'age et statut immigrant, separement pour la femelle et le male. Donnees brutes (Main_Dataset.txt) telechargees directement depuis Dryad (10.5061/dryad.n0513) -- pas une reconstruction, N=1040 nids, ile de Mandarte, Colombie-Britannique, Canada, coordonnees UTM reelles converties en WGS84."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "Breeding_Date ~ female_f + female_age + female_is + male_f + male_age + male_is + year"
    response: "Breeding_Date"
    predictors: ["female_f", "female_age", "female_is", "male_f", "male_age", "male_is", "year"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Germain, Wolak, Arcese, Losdat & Reid (2016), Direct and indirect genetic and fine-scale location effects on breeding date in song sparrows, Journal of Animal Ecology, doi:10.1111/1365-2656.12575. Le papier ajuste un modele animal quantitatif-genetique complet (equation 1 du texte : y = Xb + Z1a' + Z2a'' + Z3PI' + Z4PI'' + Z5Y + e) avec effets aleatoires genetiques (pedigree, matrice A) et de localisation spatiale non reproductibles sans le pedigree complet et le solveur animal model. formula_used retient exactement la partie effets fixes (b) du papier : consanguinite, classe d'age et statut immigrant, separement pour la femelle et le male. Donnees brutes (Main_Dataset.txt) telechargees directement depuis Dryad (10.5061/dryad.n0513) -- pas une reconstruction, N=1040 nids, ile de Mandarte, Colombie-Britannique, Canada, coordonnees UTM reelles converties en WGS84."
    estimator_context: ["ols", "gam_spatial", "random_forest", "xgboost", "gwr"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_song_sparrow_breeding_date`
- Dataset name: Data from: Direct and indirect genetic and fine-scale location effects on breeding date in song sparrows
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Direct and indirect genetic and fine‐scale location effects on breeding date in song sparrows
- Paper DOI: 10.1111/1365-2656.12575
- Dataset DOI: 10.5061/dryad.n0513
- Source URL: https://doi.org/10.5061/dryad.n0513
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "y = Xb + Z1*a_female + Z2*a_male + Z3*PI_female + Z4*PI_male + Z5*Year + e [modele animal quantitatif-genetique (mixed model) avec effets fixes b (coefficients de consanguinite, classes d'age, statut immigrant, par sexe) et effets aleatoires genetiques additifs (matrice de parente A issue du pedigree), effets individuels permanents, annee et residus ; trois variantes spatiales ajoutent en plus des effets de localisation de nid]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Germain, Wolak, Arcese, Losdat & Reid (2016), Direct and indirect genetic and fine-scale location effects on breeding date in song sparrows, Journal of Animal Ecology, doi:10.1111/1365-2656.12575. Le papier ajuste un modele animal quantitatif-genetique complet (equation 1 du texte : y = Xb + Z1a' + Z2a'' + Z3PI' + Z4PI'' + Z5Y + e) avec effets aleatoires genetiques (pedigree, matrice A) et de localisation spatiale non reproductibles sans le pedigree complet et le solveur animal model. formula_used retient exactement la partie effets fixes (b) du papier : consanguinite, classe d'age et statut immigrant, separement pour la femelle et le male. Donnees brutes (Main_Dataset.txt) telechargees directement depuis Dryad (10.5061/dryad.n0513) -- pas une reconstruction, N=1040 nids, ile de Mandarte, Colombie-Britannique, Canada, coordonnees UTM reelles converties en WGS84."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun -- fichier original telecharge directement depuis Dryad, N=1040 identique au depot source ; formula_used retient uniquement la partie effets fixes du modele animal publie (les effets aleatoires genetiques bases sur le pedigree et les effets de localisation spatiale ne sont pas reproductibles sans le pedigree complet)"
  reason: "Y continu reel (date de premiere ponte, jour julien), N=1040 nids avec coordonnees UTM reelles converties en WGS84 (ile de Mandarte, BC, Canada), covariables de consanguinite/age/statut immigrant exactement celles du papier (equation 1, partie effets fixes b). Fichier original telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) pour confirmer la specification exacte des effets fixes."
```

- Decision: ready
- Manque principal: aucun -- fichier original telecharge directement depuis Dryad, N=1040 identique au depot source ; formula_used retient uniquement la partie effets fixes du modele animal publie (les effets aleatoires genetiques bases sur le pedigree et les effets de localisation spatiale ne sont pas reproductibles sans le pedigree complet)
- Raison: Y continu reel (date de premiere ponte, jour julien), N=1040 nids avec coordonnees UTM reelles converties en WGS84 (ile de Mandarte, BC, Canada), covariables de consanguinite/age/statut immigrant exactement celles du papier (equation 1, partie effets fixes b). Fichier original telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) pour confirmer la specification exacte des effets fixes.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready"
  eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
  conditionally_eligible_estimators: []
  ineligible_reason: ""
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 1040
- k variables: 23
- T periods: 38
- Variable temporelle: year
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (1040) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 763 ; panel NON EQUILIBRE (T par unite : min=1, mediane=1, max=8). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 763 unites spatiales distinctes, pas sur les 1040 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 38 distinct periods (variable: year)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-123.2910534, -123.2833151], y [48.6320847, 48.6353377]
- Time range: 1976 to 2014 (variable: year)
- CRS analyse recommande: 32610 (UTM Zone 10N (EPSG:32610)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`song_sparrow_breeding_date` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `song_sparrow_breeding_date` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`song_sparrow_breeding_date` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Direct and indirect genetic and fine‐scale location effects on breeding date in song sparrows

