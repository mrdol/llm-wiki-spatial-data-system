---
title: paper_spatial_confounding_diabetes
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_spatial_confounding_diabetes.rds
  - DatasetFirst_10_5281_zenodo_21300380
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "[dataset-first, publication non resolue] Compiled Data for "Spatial Confounding in Multivariate Areal Data Analysis"" (DOI unknown).

## Description du jeu de donnees

- Topic: sante publique / epidemiologie spatiale des comtes americains
- Observation unit: comte americain (polygone)
- Observed population: comtes des Etats-Unis, N=2984 (couverture quasi nationale)
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: [dataset-first, publication non resolue] Compiled Data for "Spatial Confounding in Multivariate Areal Data Analysis"
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: unknown
- Dataset DOI: 10.5281/zenodo.21300380
- Source URL: https://doi.org/10.5281/zenodo.21300380
- Local raw dir: `data/raw/papers/DatasetFirst_10_5281_zenodo_21300380/`
- Local sf output: `data/final_datasets/sf/paper_spatial_confounding_diabetes.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `diabetes_pct_est`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `STATEFP`, `COUNTYFP`, `COUNTYNS`, `AFFGEOID`, `GEOID`, `LSAD`, `ALAND`, `AWATER`, `obesity_pct_est`, `diabetes_cancer_mortality`, `PCT_18YOUNGER10`, `PCT_65OLDER10`, `PCT_HISP10`, `PCT_LACCESS_POP15`, `PCT_NHBLACK10`, `RECFACPTH16`, `physical_inactivity_2015`, `pcps_2015_100k`, `outpatient_visits_2015_100k`, `urban_percent_2010`, `hs_dipl_percent_2011_15`, `unemployment_2015`, `med_hh_inc_2015`, `poverty_rate_2015`, `snap_pct_2015`, `uninsured_2015`
- Candidate X count in local artifact: 26
- Candidate X typology: categorical, continuous
- Published X variables from paper: Les 15 predicteurs exacts du papier (Poverty Rate, Median Income, Unemployment, SNAP Assistance, Uninsured Rate, PCP Density, Outpatient Visits, Low Access, Physical Inactivity, Recreation Facilities, HS Diploma Rate, Percent NH-Black, Percent Hispanic, Percent >=65, Percent <=18, Urban Percent), tous verifies presents dans RDA_data.csv
- Published X count: 1
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `fips`, `NAME`, `State`, `County`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `diabetes_pct_est` | `numeric` | continuous | [3.7, 17.4] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `spatial_confounding_diabetes`, la ou les reponses `diabetes_pct_est` viennent du loader papier et/ou des preuves de l article `[dataset-first, publication non resolue] Compiled Data for "Spatial Confounding in Multivariate Areal Data Analysis"`. Les covariables X retenues sont `PCT_18YOUNGER10`, `PCT_65OLDER10`, `PCT_HISP10`, `PCT_LACCESS_POP15`, `PCT_NHBLACK10`, `RECFACPTH16`, `physical_inactivity_2015`, `pcps_2015_100k`, `outpatient_visits_2015_100k`, `urban_percent_2010`, `hs_dipl_percent_2011_15`, `unemployment_2015`, `med_hh_inc_2015`, `poverty_rate_2015`, `snap_pct_2015`, `uninsured_2015` ; 10 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (`fips`, `NAME`, `State`, `County`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `STATEFP` | `character` | categorical | 0% |
| `COUNTYFP` | `character` | categorical | 0% |
| `COUNTYNS` | `character` | categorical | 0% |
| `AFFGEOID` | `character` | categorical | 0% |
| `GEOID` | `character` | categorical | 0% |
| `LSAD` | `character` | categorical | 0% |
| `ALAND` | `numeric` | continuous | 0% |
| `AWATER` | `numeric` | continuous | 0% |
| `obesity_pct_est` | `numeric` | continuous | 0% |
| `diabetes_cancer_mortality` | `numeric` | continuous | 0% |
| `PCT_18YOUNGER10` | `numeric` | continuous | 0% |
| `PCT_65OLDER10` | `numeric` | continuous | 0% |
| `PCT_HISP10` | `numeric` | continuous | 0% |
| `PCT_LACCESS_POP15` | `numeric` | continuous | 0% |
| `PCT_NHBLACK10` | `numeric` | continuous | 0% |
| `RECFACPTH16` | `numeric` | rate | 0% |
| `physical_inactivity_2015` | `numeric` | continuous | 0% |
| `pcps_2015_100k` | `numeric` | continuous | 0% |
| `outpatient_visits_2015_100k` | `numeric` | continuous | 0% |
| `urban_percent_2010` | `numeric` | continuous | 0% |
| `hs_dipl_percent_2011_15` | `numeric` | continuous | 0% |
| `unemployment_2015` | `numeric` | continuous | 0% |
| `med_hh_inc_2015` | `integer` | count | 0% |
| `poverty_rate_2015` | `numeric` | continuous | 0% |
| `snap_pct_2015` | `numeric` | rate | 0% |
| `uninsured_2015` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: [obesity_pct_est, diabetes_pct_est, diabetes_cancer_mortality] ~ XB_S + G + E_S [Wu, K.L. & Banerjee, S., 'Spatial Confounding in Multivariate Areal Data Analysis', arXiv:2505.07232 (texte integral libre acces consulte, session 2026-08-16). Modele areolaire bayesien coregionalise MULTIVARIE (3 reponses simultanees, structure spatiale BYM2 partagee via matrice de dependance M), avec 15 predicteurs exacts groupes en 5 domaines : contexte economique (Poverty Rate, Median Income, Unemployment, SNAP Assistance), contexte sanitaire (Uninsured Rate, PCP Density, Outpatient Visits, Low Access), environnement (Physical Inactivity, Recreation Facilities), education (HS Diploma Rate), demographie (Percent NH-Black, Percent Hispanic, Percent >=65, Percent <=18, Urban Percent). CORRESPONDANCE VERIFIEE A 100% (session 2026-08-16) entre les 15 predicteurs du papier et les colonnes reelles de RDA_data.csv -- ce depot Zenodo est manifestement le jeu de donnees original des auteurs, pas une source secondaire]
- x_terms_pub: Les 15 predicteurs exacts du papier (Poverty Rate, Median Income, Unemployment, SNAP Assistance, Uninsured Rate, PCP Density, Outpatient Visits, Low Access, Physical Inactivity, Recreation Facilities, HS Diploma Rate, Percent NH-Black, Percent Hispanic, Percent >=65, Percent <=18, Urban Percent), tous verifies presents dans RDA_data.csv
- y_term_pub: diabetes_pct_est (prevalence du diabete diagnostique chez les adultes de 20 ans et plus, ajustee sur l'age, 2015, US Diabetes Surveillance System) -- le papier utilise en realite 3 reponses simultanees dans un modele multivarie : obesity_pct_est, diabetes_pct_est, diabetes_cancer_mortality
- Reference publication: CONFIRMED (session 2026-08-16, recherche bibliographique demandee par l'utilisateur) : papier retrouve avec certitude quasi-absolue -- Wu, K.L. & Banerjee, S., 'Spatial Confounding in Multivariate Areal Data Analysis', arXiv:2505.07232, texte integral libre acces consulte. Le papier analyse des donnees de comtes americains sur obesite/diabete/mortalite par cancer lie au diabete avec un modele areolaire bayesien coregionalise multivarie (Y=XB_S+G+E_S, structure BYM2 partagee entre les 3 reponses via une matrice de dependance M), 15 predicteurs exacts groupes en 5 domaines de determinants sanitaires (economique, sanitaire, environnemental, educatif, demographique). CORRESPONDANCE VERIFIEE A 100% : les 15 predicteurs cites dans le papier (Poverty Rate->poverty_rate_2015, Median Income->med_hh_inc_2015, Unemployment->unemployment_2015, SNAP Assistance->snap_pct_2015, Uninsured Rate->uninsured_2015, PCP Density->pcps_2015_100k, Outpatient Visits->outpatient_visits_2015_100k, Low Access->PCT_LACCESS_POP15, Physical Inactivity->physical_inactivity_2015, Recreation Facilities->RECFACPTH16, HS Diploma Rate->hs_dipl_percent_2011_15, Percent NH-Black->PCT_NHBLACK10, Percent Hispanic->PCT_HISP10, Percent >=65->PCT_65OLDER10, Percent <=18->PCT_18YOUNGER10, Urban Percent->urban_percent_2010) correspondent tous exactement aux colonnes de RDA_data.csv, et diabetes_cancer_mortality (une des 3 reponses du modele multivarie du papier) est deja une colonne du depot -- ce Zenodo est manifestement le jeu de donnees original de Wu & Banerjee, pas une source secondaire. formula_used corrigee (session 2026-08-16) : passe de 6 covariables choisies par analogie a la totalite des 15 predicteurs exacts du papier (obesity_pct_est retiree du role de covariable et notee comme reponse multivariee alternative du vrai modele, mais gardee en ml_formula comme covariable disponible pour un usage benchmark simple univariee). Le vrai modele du papier reste multivarie (3 reponses simultanees, structure BYM2 coregionalisee) -- non reproductible tel quel par une regression univariee simple, formula_used documente donc une regression classique diabetes_pct_est~X sur les vrais predicteurs, pas le modele multivarie complet. RDA_data.csv (2984 comtes americains) telecharge directement depuis Zenodo -- pas une reconstruction. Geometrie jointe par code FIPS (5 chiffres, zero-pad corrige) au shapefile officiel Census cb_2017_us_county_500k inclus dans le meme depot -- pas une reconstruction, N=2984/2984 comtes joints (couverture complete). package_include laisse en manual_review : papier et predicteurs desormais confirmes a 100%, mais formula_used reste une simplification univariee du vrai modele multivarie coregionalise.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: diabetes_pct_est ~ PCT_18YOUNGER10 + PCT_65OLDER10 + PCT_HISP10 + PCT_LACCESS_POP15 + PCT_NHBLACK10 + RECFACPTH16 + physical_inactivity_2015 + pcps_2015_100k + outpatient_visits_2015_100k + urban_percent_2010 + hs_dipl_percent_2011_15 + unemployment_2015 + med_hh_inc_2015 + poverty_rate_2015 + snap_pct_2015 + uninsured_2015
- x_terms_used: PCT_18YOUNGER10, PCT_65OLDER10, PCT_HISP10, PCT_LACCESS_POP15, PCT_NHBLACK10, RECFACPTH16, physical_inactivity_2015, pcps_2015_100k, outpatient_visits_2015_100k, urban_percent_2010, hs_dipl_percent_2011_15, unemployment_2015, med_hh_inc_2015, poverty_rate_2015, snap_pct_2015, uninsured_2015
- y_term_used: diabetes_pct_est
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "diabetes_pct_est ~ PCT_18YOUNGER10 + PCT_65OLDER10 + PCT_HISP10 + PCT_LACCESS_POP15 + PCT_NHBLACK10 + RECFACPTH16 + physical_inactivity_2015 + pcps_2015_100k + outpatient_visits_2015_100k + urban_percent_2010 + hs_dipl_percent_2011_15 + unemployment_2015 + med_hh_inc_2015 + poverty_rate_2015 + snap_pct_2015 + uninsured_2015"
    response: "diabetes_pct_est (prevalence du diabete diagnostique chez les adultes de 20 ans et plus, ajustee sur l'age, 2015, US Diabetes Surveillance System) -- le papier utilise en realite 3 reponses simultanees dans un modele multivarie : obesity_pct_est, diabetes_pct_est, diabetes_cancer_mortality"
    predictors: ["Les 15 predicteurs exacts du papier (Poverty Rate, Median Income, Unemployment, SNAP Assistance, Uninsured Rate, PCP Density, Outpatient Visits, Low Access, Physical Inactivity, Recreation Facilities, HS Diploma Rate, Percent NH-Black, Percent Hispanic, Percent >=65, Percent <=18, Urban Percent), tous verifies presents dans RDA_data.csv"]
    role: "simple_baseline"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "spatial_baseline"]
    status: "confirmed"

  multivariate_constrained:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "paper_main_specification"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

  ml_or_selected:
    formula: "diabetes_pct_est ~ PCT_18YOUNGER10 + PCT_65OLDER10 + PCT_HISP10 + PCT_LACCESS_POP15 + PCT_NHBLACK10 + RECFACPTH16 + physical_inactivity_2015 + pcps_2015_100k + outpatient_visits_2015_100k + urban_percent_2010 + hs_dipl_percent_2011_15 + unemployment_2015 + med_hh_inc_2015 + poverty_rate_2015 + snap_pct_2015 + uninsured_2015 + obesity_pct_est"
    response: "diabetes_pct_est"
    predictors: ["PCT_18YOUNGER10", "PCT_65OLDER10", "PCT_HISP10", "PCT_LACCESS_POP15", "PCT_NHBLACK10", "RECFACPTH16", "physical_inactivity_2015", "pcps_2015_100k", "outpatient_visits_2015_100k", "urban_percent_2010", "hs_dipl_percent_2011_15", "unemployment_2015", "med_hh_inc_2015", "poverty_rate_2015", "snap_pct_2015", "uninsured_2015", "obesity_pct_est"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sar_error", "car_besag", "bym2", "gwr", "random_forest"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_spatial_confounding_diabetes`
- Dataset name: Compiled Data for "Spatial Confounding in Multivariate Areal Data Analysis"
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: [dataset-first, publication non resolue] Compiled Data for "Spatial Confounding in Multivariate Areal Data Analysis"
- Paper DOI: unknown
- Dataset DOI: 10.5281/zenodo.21300380
- Source URL: https://doi.org/10.5281/zenodo.21300380
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "[obesity_pct_est, diabetes_pct_est, diabetes_cancer_mortality] ~ XB_S + G + E_S [Wu, K.L. & Banerjee, S., 'Spatial Confounding in Multivariate Areal Data Analysis', arXiv:2505.07232 (texte integral libre acces consulte, session 2026-08-16). Modele areolaire bayesien coregionalise MULTIVARIE (3 reponses simultanees, structure spatiale BYM2 partagee via matrice de dependance M), avec 15 predicteurs exacts groupes en 5 domaines : contexte economique (Poverty Rate, Median Income, Unemployment, SNAP Assistance), contexte sanitaire (Uninsured Rate, PCP Density, Outpatient Visits, Low Access), environnement (Physical Inactivity, Recreation Facilities), education (HS Diploma Rate), demographie (Percent NH-Black, Percent Hispanic, Percent >=65, Percent <=18, Urban Percent). CORRESPONDANCE VERIFIEE A 100% (session 2026-08-16) entre les 15 predicteurs du papier et les colonnes reelles de RDA_data.csv -- ce depot Zenodo est manifestement le jeu de donnees original des auteurs, pas une source secondaire]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "CONFIRMED (session 2026-08-16, recherche bibliographique demandee par l'utilisateur) : papier retrouve avec certitude quasi-absolue -- Wu, K.L. & Banerjee, S., 'Spatial Confounding in Multivariate Areal Data Analysis', arXiv:2505.07232, texte integral libre acces consulte. Le papier analyse des donnees de comtes americains sur obesite/diabete/mortalite par cancer lie au diabete avec un modele areolaire bayesien coregionalise multivarie (Y=XB_S+G+E_S, structure BYM2 partagee entre les 3 reponses via une matrice de dependance M), 15 predicteurs exacts groupes en 5 domaines de determinants sanitaires (economique, sanitaire, environnemental, educatif, demographique). CORRESPONDANCE VERIFIEE A 100% : les 15 predicteurs cites dans le papier (Poverty Rate->poverty_rate_2015, Median Income->med_hh_inc_2015, Unemployment->unemployment_2015, SNAP Assistance->snap_pct_2015, Uninsured Rate->uninsured_2015, PCP Density->pcps_2015_100k, Outpatient Visits->outpatient_visits_2015_100k, Low Access->PCT_LACCESS_POP15, Physical Inactivity->physical_inactivity_2015, Recreation Facilities->RECFACPTH16, HS Diploma Rate->hs_dipl_percent_2011_15, Percent NH-Black->PCT_NHBLACK10, Percent Hispanic->PCT_HISP10, Percent >=65->PCT_65OLDER10, Percent <=18->PCT_18YOUNGER10, Urban Percent->urban_percent_2010) correspondent tous exactement aux colonnes de RDA_data.csv, et diabetes_cancer_mortality (une des 3 reponses du modele multivarie du papier) est deja une colonne du depot -- ce Zenodo est manifestement le jeu de donnees original de Wu & Banerjee, pas une source secondaire. formula_used corrigee (session 2026-08-16) : passe de 6 covariables choisies par analogie a la totalite des 15 predicteurs exacts du papier (obesity_pct_est retiree du role de covariable et notee comme reponse multivariee alternative du vrai modele, mais gardee en ml_formula comme covariable disponible pour un usage benchmark simple univariee). Le vrai modele du papier reste multivarie (3 reponses simultanees, structure BYM2 coregionalisee) -- non reproductible tel quel par une regression univariee simple, formula_used documente donc une regression classique diabetes_pct_est~X sur les vrais predicteurs, pas le modele multivarie complet. RDA_data.csv (2984 comtes americains) telecharge directement depuis Zenodo -- pas une reconstruction. Geometrie jointe par code FIPS (5 chiffres, zero-pad corrige) au shapefile officiel Census cb_2017_us_county_500k inclus dans le meme depot -- pas une reconstruction, N=2984/2984 comtes joints (couverture complete). package_include laisse en manual_review : papier et predicteurs desormais confirmes a 100%, mais formula_used reste une simplification univariee du vrai modele multivarie coregionalise."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "papier retrouve avec certitude (Wu & Banerjee, arXiv:2505.07232) -- correspondance verifiee a 100% entre les 15 predicteurs du papier et les colonnes locales ; le vrai modele reste multivarie (3 reponses coregionalisees BYM2), formula_used simplifie en regression univariee -- promu a package_include='yes' apres validation utilisateur (session 2026-08-16)"
  reason: "Y continu reel (diabetes_pct_est, prevalence du diabete ajustee sur l'age), N=2984/2984 comtes americains joints (couverture complete). CSV original (RDA_data.csv) et shapefile officiel Census (cb_2017_us_county_500k) telecharges directement depuis Zenodo -- pas une reconstruction. Chaque variable est sourcee individuellement dans RDA_data_variables.csv (US HHS County Level Area Health Resources Files, US Diabetes Surveillance System, USDA Food Environment Atlas, CDC WONDER). Jointure par code FIPS verifiee empiriquement (bug de zero-padding detecte et corrige, N passe de 2689 a 2984/2984 apres correction)."
```

- Decision: ready
- Manque principal: papier retrouve avec certitude (Wu & Banerjee, arXiv:2505.07232) -- correspondance verifiee a 100% entre les 15 predicteurs du papier et les colonnes locales ; le vrai modele reste multivarie (3 reponses coregionalisees BYM2), formula_used simplifie en regression univariee -- promu a package_include="yes" apres validation utilisateur (session 2026-08-16)
- Raison: Y continu reel (diabetes_pct_est, prevalence du diabete ajustee sur l'age), N=2984/2984 comtes americains joints (couverture complete). CSV original (RDA_data.csv) et shapefile officiel Census (cb_2017_us_county_500k) telecharges directement depuis Zenodo -- pas une reconstruction. Chaque variable est sourcee individuellement dans RDA_data_variables.csv (US HHS County Level Area Health Resources Files, US Diabetes Surveillance System, USDA Food Environment Atlas, CDC WONDER). Jointure par code FIPS verifiee empiriquement (bug de zero-padding detecte et corrige, N passe de 2689 a 2984/2984 apres correction).

## Estimator eligibility

```yaml
estimator_eligibility:
  - estimator: bym2_multivariate
    basis: published_model
    source_ref: "Wu et Banerjee (2025), arXiv:2505.07232."
    notes: "Modele areolaire bayesien coregionalise publie; aucune route multivariee BYM2 n'est encore automatisee. Des comparateurs univaries continus sont donc proposes selon la typologie du jeu."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 2984
- k variables: 33
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4269
- CRS nom: NAD83
- Spatial extent: x [-163.919047182681, -67.5502697982904], y [19.588965, 69.676327]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=96.4deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Attribution 4.0 International
- License URL: https://creativecommons.org/licenses/by/4.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5281/zenodo.21300380 (checked 2026-08-18): rightsList = 'Creative Commons Attribution 4.0 International'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`spatial_confounding_diabetes` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `spatial_confounding_diabetes` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4269).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`spatial_confounding_diabetes` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: [dataset-first, publication non resolue] Compiled Data for "Spatial Confounding in Multivariate Areal Data Analysis"

