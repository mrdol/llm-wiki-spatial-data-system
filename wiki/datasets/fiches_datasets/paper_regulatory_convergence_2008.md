---
title: paper_regulatory_convergence_2008
type: dataset
created: 2026-09-09
updated: 2026-09-09
sources:
  - data/final_datasets/sf/paper_regulatory_convergence_2008.rds
  - data/raw/papers/DataCite_2019_RegulatoryConvergenceInThe_10_1093_isq_sqz0/Jones & Zeitz - Replication.do
  - DataCite_2019_RegulatoryConvergenceInThe_10_1093_isq_sqz0
tags: [dataset, paper-derived, spatial, point]
---

Coupe transversale 2008 (Table 2 du papier), extraite le 2026-09-09 du jeu panel parent [[paper_regulatory_convergence]], a partir du fichier de replication Stata original de l'article "Regulatory Convergence in the Financial Periphery: How Interdependence Shapes Regulators' Decisions" (Jones & Zeitz 2019, International Studies Quarterly, DOI 10.1093/isq/sqz068).

## Description du jeu de donnees

- Topic: economie politique internationale / regulation financiere bancaire
- Observation unit: pays/juridiction de la peripherie financiere (hors membres du Comite de Bale, `net_bcbs==0`)
- Observed population: 110 juridictions peripherique en 2008 (sous-ensemble du panel parent, N total parent = 2972 sur 18 annees)
- Geographic context: etendue sf (110 pays) x [-102.25, 177.98], y [-54.02, 79.96]
- Temporal context: coupe transversale, annee 2008 uniquement
- Source description: Regulatory Convergence in the Financial Periphery -- Table 2, colonne "2008 cross-section"
- Description confidence: high (formule et sous-echantillon confirmes par lecture directe du fichier de replication Stata `Jones & Zeitz - Replication.do`, lignes 85-110)
- Paper DOI: 10.1093/isq/sqz068
- Dataset DOI: 10.7910/dvn/vbnpjs
- Source URL: https://dataverse.harvard.edu/citation?persistentId=doi:10.7910/DVN/VBNPJS
- Local raw dir: `data/raw/papers/DataCite_2019_RegulatoryConvergenceInThe_10_1093_isq_sqz0/`
- Local sf output: `data/final_datasets/sf/paper_regulatory_convergence_2008.rds`
- Parent dataset: `paper_regulatory_convergence` (sous-ensemble transversal -- ne pas compter comme source independante)

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `bii_index`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Lreceiveforeign_wght_bin`, `Lsendingabroad_wght_bin`, `Lnetwork_spw_bin`, `Lsovrating_spw_same`, `Ltradebin30_wght`, `Lprivcredit1`, `Lfdi_in_gdp1`, `Lpolity`, `Lcpi`, `Lcbiw`, `Lbankcon1`, `Limf_iiiyr`, `region`
- Candidate X count in local artifact: 13
- Candidate X typology: continuous, binary, categorical
- Published X variables from paper: Lreceiveforeign_wght_bin, Lsendingabroad_wght_bin, Lnetwork_spw_bin, Lsovrating_spw_same, Ltradebin30_wght, Lprivcredit1, Lfdi_in_gdp1, Lpolity, Lcpi, Lcbiw, Lbankcon1, Limf_iiiyr, region (region dummies, `ib3.region`)
- Published X count: 13
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `iso`, `iso_a2`, `country`, `year`, `net_bcbs` (filtre d'echantillon, exclu de X -- voir Note ci-dessous)
- Variables inspected: yes (verification directe du .do file de replication, session 2026-09-09)
- Presence of imputed X: no (NA laisses tels quels, suppression listwise geree par l'estimateur -- coherent avec l'option `robust` de Stata qui fait deja une suppression listwise)

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `bii_index` | `numeric` | continuous | [0, 10] | 0% |

> Selection Y/X (verbatim, fichier de replication) : Pour `paper_regulatory_convergence_2008`, la reponse est `bii_index` (indice d'adoption des standards Basel II/III), PAS `net_bcbs` (variable binaire utilisee dans le .do file uniquement comme **filtre d'echantillon** -- `keep if net_bcbs==0 & year==2008` -- pour restreindre l'analyse aux juridictions peripheriques hors Comite de Bale, jamais comme variable dependante). Les covariables X sont les variables de "spatial lag" deja precalculees (`Lnetwork_spw_bin`, `Lsovrating_spw_same`, `Ltradebin30_wght`, `Lreceiveforeign_wght_bin`, `Lsendingabroad_wght_bin`), plus les controles (`Lprivcredit1`, `Lfdi_in_gdp1`, `Lpolity`, `Lcpi`, `Lcbiw`, `Lbankcon1`, `Limf_iiiyr`) et les effets fixes regionaux (`region`, base = region 3). Statut benchmark actuel : ready; voir bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Lreceiveforeign_wght_bin` | `numeric` | continuous | 0% |
| `Lsendingabroad_wght_bin` | `numeric` | continuous | 0% |
| `Lnetwork_spw_bin` | `numeric` | continuous | 0% |
| `Lsovrating_spw_same` | `numeric` | continuous | 0% |
| `Ltradebin30_wght` | `numeric` | continuous | 4.5% |
| `Lprivcredit1` | `numeric` | continuous | 3.6% |
| `Lfdi_in_gdp1` | `numeric` | continuous | 2.7% |
| `Lpolity` | `numeric` | continuous | 3.6% |
| `Lcpi` | `numeric` | continuous | 3.6% |
| `Lcbiw` | `numeric` | continuous | 4.5% |
| `Lbankcon1` | `numeric` | continuous | 5.5% |
| `Limf_iiiyr` | `numeric` | binary | 0% |
| `region` | `numeric` | categorical | 0% |

### Formule - niveau publication

- formula_pub: bii_index ~ Lreceiveforeign_wght_bin + Lsendingabroad_wght_bin + Lnetwork_spw_bin + Lsovrating_spw_same + Ltradebin30_wght + Lprivcredit1 + Lfdi_in_gdp1 + Lpolity + Lcpi + Lcbiw + Lbankcon1 + Limf_iiiyr + factor(region)
- x_terms_pub: Lreceiveforeign_wght_bin, Lsendingabroad_wght_bin, Lnetwork_spw_bin, Lsovrating_spw_same, Ltradebin30_wght, Lprivcredit1, Lfdi_in_gdp1, Lpolity, Lcpi, Lcbiw, Lbankcon1, Limf_iiiyr, region
- y_term_pub: bii_index
- Reference publication: Jones & Zeitz (2019), International Studies Quarterly 63(4), doi:10.1093/isq/sqz068. Table 2, colonne "2008 cross-section". Fichier de replication Stata `Jones & Zeitz - Replication.do`, ligne 61 (specification exploratoire identique) et lignes 85-110 (Table 2 formelle) : `reg bii_index Lreceiveforeign_wght_bin Lsendingabroad_wght_bin Lnetwork_spw_bin Lsovrating_spw_same Ltradebin30_wght Lprivcredit1 Lfdi_in_gdp1 Lpolity Lcpi Lcbiw Lbankcon1 Limf_iiiyr ib3.region if net_bcbs==0 & year==2008, robust`. Correction du 2026-09-09 : la fiche parent indiquait par erreur `y_term_pub: net_bcbs` (lecture du 2026-08-15, limitee aux 2 premieres pages de l'article, sans le fichier de replication).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: verbatim
- Methode d estimation: formule confirmee verbatim dans le fichier de replication Stata original (correspondance exacte des noms de variables avec le RDS local)
- Correspondance Python/R: aucune identifiee
- Note: Correction du 2026-09-09 -- lecture du fichier de replication `Jones & Zeitz - Replication.do` (fourni avec les donnees brutes, non lu lors de la premiere passe du 2026-08-15). Le modele principal (Table 2) est une regression lineaire simple (Stata `reg`, erreurs robustes) sur des variables de decalage spatial DEJA precalculees dans les donnees -- aucune matrice W a construire pour reproduire ce modele. Les blocs de matrices bruts (`rf07_*`, `st07_*`, `sov07_*`, `net07_*`, `trade07_*`, 2271 colonnes au total, non retenues ici) servent uniquement a un modele de robustesse plus avance (Spatial-GMM/GS2SLS, Tables A6-A9), non reproduit dans cette fiche -- voir fiche parent pour le detail.

### Formule - niveau systeme

- formula_used: bii_index ~ Lreceiveforeign_wght_bin + Lsendingabroad_wght_bin + Lnetwork_spw_bin + Lsovrating_spw_same + Ltradebin30_wght + Lprivcredit1 + Lfdi_in_gdp1 + Lpolity + Lcpi + Lcbiw + Lbankcon1 + Limf_iiiyr + region
- Formula used evidence: verbatim
- Recommended validation: N lignes=110; N spatial=110; T declare=1. Coupe transversale (T=1) -- pas de fuite temporelle possible au sein de cette coupe ; aucune coordonnee dupliquee (chaque pays apparait une fois en 2008). Complete-case N (toutes variables Y/X non manquantes) = 96 -- coherent avec la suppression listwise faite par Stata `reg ..., robust`.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; `net_bcbs` (variable de filtre, deja appliquee) ne pilote pas cette tache.
- Selected Y typology: continuous
- x_terms_used: Lreceiveforeign_wght_bin, Lsendingabroad_wght_bin, Lnetwork_spw_bin, Lsovrating_spw_same, Ltradebin30_wght, Lprivcredit1, Lfdi_in_gdp1, Lpolity, Lcpi, Lcbiw, Lbankcon1, Limf_iiiyr, region
- y_term_used: bii_index
- Note: Identique a formula_pub -- reproduction directe de la Table 2 (2008) du papier, verifiee verbatim dans le fichier de replication.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "bii_index ~ Lnetwork_spw_bin"
    response: "bii_index"
    predictors: ["Lnetwork_spw_bin"]
    role: "simple_baseline"
    source_type: "scientific_publication"
    source_ref: "Jones & Zeitz - Replication.do, ligne 97 (specification 'spatial lags individually: network membership')."
    estimator_context: ["ols"]
    status: "confirmed"

  multivariate_constrained:
    formula: "bii_index ~ Lreceiveforeign_wght_bin + Lsendingabroad_wght_bin + Lnetwork_spw_bin + Lsovrating_spw_same + Ltradebin30_wght + Lprivcredit1 + Lfdi_in_gdp1 + Lpolity + Lcpi + Lcbiw + Lbankcon1 + Limf_iiiyr + region"
    response: "bii_index"
    predictors: ["Lreceiveforeign_wght_bin", "Lsendingabroad_wght_bin", "Lnetwork_spw_bin", "Lsovrating_spw_same", "Ltradebin30_wght", "Lprivcredit1", "Lfdi_in_gdp1", "Lpolity", "Lcpi", "Lcbiw", "Lbankcon1", "Limf_iiiyr", "region"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Jones & Zeitz - Replication.do, lignes 85-110 (Table 2, 2008 cross-section)."
    estimator_context: ["ols"]
    status: "confirmed"

  ml_or_selected:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "ml_candidate_features"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_regulatory_convergence_2008`
- Dataset name: Replication Data for: Regulatory Convergence in the Financial Periphery -- coupe transversale 2008
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Regulatory Convergence in the Financial Periphery: How Interdependence Shapes Regulators' Decisions
- Paper DOI: 10.1093/isq/sqz068
- Dataset DOI: 10.7910/dvn/vbnpjs
- Source URL: https://dataverse.harvard.edu/citation?persistentId=doi:10.7910/DVN/VBNPJS
- Year: 2008
- Parent dataset: `paper_regulatory_convergence` (sous-ensemble transversal -- ne pas compter comme source independante)

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression continue (OLS, erreurs robustes)
- Modele niveau 2 (famille): regression lineaire multiple avec covariables de decalage spatial precalculees
- Modele niveau 3 (variante): Table 2 (2008), robustesse alternative = Spatial-GMM/GS2SLS avec matrices W explicites (Tables A6-A9, non reproduit ici)

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "bii_index ~ Lreceiveforeign_wght_bin + Lsendingabroad_wght_bin + Lnetwork_spw_bin + Lsovrating_spw_same + Ltradebin30_wght + Lprivcredit1 + Lfdi_in_gdp1 + Lpolity + Lcpi + Lcbiw + Lbankcon1 + Limf_iiiyr + ib3.region [Stata: reg ..., robust]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: linear_regression_with_precomputed_spatial_lags
  source_type: scientific_publication_or_package_documentation
  source_ref: "Jones & Zeitz (2019), International Studies Quarterly 63(4), doi:10.1093/isq/sqz068. Fichier de replication Stata Jones & Zeitz - Replication.do, lignes 85-110 (Table 2, 2008 cross-section)."
  confidence: high
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous_cross_section"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Formule Table 2 (2008) confirmee verbatim dans le fichier de replication Stata original ; Y continu (bii_index), X = variables de spatial lag deja precalculees + controles + effets fixes regionaux, tous presents dans le RDS local. Sous-ensemble genere le 2026-09-09 (code/r_catalog/build_ted_can... non applicable ici -- voir scratch build_regconv_2008.R documente en Bloc 6)."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Formule Table 2 (2008) confirmee verbatim dans le fichier de replication Stata original ; tous les termes presents dans le RDS local.

## Estimator eligibility

```yaml
estimator_eligibility:
  eligible_estimators:
    - estimator: ols
      basis: scientific_evidence
      source_ref: "Jones & Zeitz - Replication.do, lignes 85-110 : `reg bii_index ... ib3.region if net_bcbs==0 & year==2008, robust` -- regression lineaire multiple, methode exacte de la Table 2 publiee."
      notes: "Reproduction directe et complete de la specification publiee (aux erreurs-type robustes pres, non modelisees explicitement par notre harnais OLS standard)."
    - estimator: random_forest
      basis: generated_candidate
      source_ref: "Aucune -- alternative non-parametrique generique pour comparaison, Y continu."
      notes: "Comparateur ML, pas le modele publie."
    - estimator: xgboost
      basis: generated_candidate
      source_ref: "Aucune -- alternative non-parametrique generique pour comparaison, Y continu."
      notes: "Comparateur ML, pas le modele publie."
  conditionally_eligible_estimators:
    - estimator: sar_lag
      basis: generated_candidate
      source_ref: "Le papier propose un modele Spatial-GMM/GS2SLS (Tables A6-A9) avec 5 matrices W distinctes (banques entrantes, banques sortantes, souverain, reseau, commerce) construites depuis les blocs bruts rf07_*/st07_*/sov07_*/net07_*/trade07_* (non retenus dans ce sous-ensemble)."
      notes: "Necessiterait de materialiser les 5 matrices W (voir fiche parent, Bloc 1, colonnes brutes) et un estimateur SARAR (lag+erreur combines) que le harnais ne supporte pas nativement aujourd'hui (spregress/GS2SLS Stata). Non implemente -- chantier separe si les 5 W deviennent necessaires."
  ineligible_reason: "n/a -- estimateur principal (ols) eligible avec preuve scientifique directe."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 110
- k variables: 13
- T periods: 1
- Variable temporelle: year (fixee a 2008)
- N/T profile: N_grand_T_petit
- Note N/T (session 2026-09-09) : Coupe transversale (2008) du panel principal [[paper_regulatory_convergence]] -- extraite pour reproduire exactement la Table 2 du papier (`net_bcbs==0 & year==2008`). T=1 est correct pour cette coupe. N spatial = 110 (aucune coordonnee dupliquee, chaque pays apparait une fois).

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation (pays/juridiction)
- Temporal resolution: 2008 (annuelle)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-102.25017, 177.97595], y [-54.015925, 79.958143]
- Time range: 2008 (variable: year)
- CRS analyse recommande: pending - multi-continents (span mondial) -- pas de projection unique pertinente ; analyse en WGS84 ou par region recommandee (voir X `region`)

## Bloc 6 - Reproductibilite

- License present: yes
- License name: herite du parent [[paper_regulatory_convergence]]
- License URL: https://dataverse.harvard.edu/citation?persistentId=doi:10.7910/DVN/VBNPJS
- License open: yes
- License evidence: Herite du parent -- Dataverse Harvard, DOI 10.7910/dvn/vbnpjs.
- Reproducibility status: OK - genere par script R documente (`build_regconv_2008.R`, scratchpad session 2026-09-09) a partir du parent [[paper_regulatory_convergence]] : filtre `year==2008 & net_bcbs==0 & !is.na(bii_index) & !is.na(iso)`, colonnes Y/X/region/identifiants uniquement (colonnes brutes de matrices exclues).
- Code available: yes (script documente, a rapatrier dans `code/r_catalog/` si ce sous-ensemble est reutilise)
- Repository: paper-derived (voir fiche parent [[paper_regulatory_convergence]])

## Quality Control

- Schema: OK - fiche derivee du format Bloc 1-6 de la fiche parent [[paper_regulatory_convergence]].
- Variables: OK - Y (`bii_index`) et X (13 variables) confirmes verbatim dans le fichier de replication Stata.
- Formula: OK - formule identique a la Table 2 publiee, executable avec les colonnes presentes dans le RDS.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT), 110 pays, aucun doublon de coordonnees au sein de cette coupe.
- Missing values: OK - NA residuels (0-5.5% selon la colonne) coherents avec la suppression listwise Stata (`robust` -> N effectif = 96 sur 110).
- Duplicates: OK - aucun doublon (coupe transversale, une ligne par pays).
- Reproducibility: OK - filtre et colonnes documentes, source brute (fichier .do) tracee.

## Related Pages

- [[paper_regulatory_convergence]]
- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Regulatory Convergence in the Financial Periphery: How Interdependence Shapes Regulators' Decisions

## Curation documentée — 2026-09-09

Fiche generee par decoupage transversal du panel parent [[paper_regulatory_convergence]] (annee 2008, filtre `net_bcbs==0`), suite a la lecture du fichier de replication Stata original `Jones & Zeitz - Replication.do` (present dans les donnees brutes mais non lu lors de la premiere passe du 2026-08-15, qui s'etait limitee au resume/abstract de l'article et avait laisse `y_term_pub: net_bcbs` par erreur -- `net_bcbs` est en realite une variable de filtre d'echantillon, jamais la reponse).

Ce fichier de replication documente aussi une remarque du co-encadrant du stage (Emmanuel) sur le traitement des matrices W non-geographiques (voir `extensions_projet_2026-09/matrice_W_originale/README.md`) : les blocs de matrices `rf07_*`/`st07_*`/`sov07_*`/`net07_*`/`trade07_*` sont les 5 matrices de liens (banques entrantes, banques sortantes, souverain, reseau, commerce) au sens du cas 3 de cette methodologie (geometrie relationnelle complexe, sans geometrie d'origine geographique) -- mais elles ne sont PAS necessaires pour reproduire le modele principal (Table 2), qui utilise des variables de decalage spatial deja precalculees comme covariables ordinaires. Elles ne serviraient qu'a la variante de robustesse Spatial-GMM/GS2SLS (Tables A6-A9), documentee mais non implementee dans cette fiche (voir Estimator eligibility > conditionally_eligible_estimators).

Provenance des corrections : investigation du 2026-09-09, lecture directe de `data/raw/papers/DataCite_2019_RegulatoryConvergenceInThe_10_1093_isq_sqz0/Jones & Zeitz - Replication.do`, script `build_regconv_2008.R` (scratchpad).
