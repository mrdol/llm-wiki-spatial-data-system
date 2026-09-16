---
title: warehouse_ted_can_2015_nuts3
type: dataset
created: 2026-09-04
updated: 2026-09-15
sources:
  - data/final_datasets/sf/warehouse_ted_can_2015_nuts3.rds
  - https://data.europa.eu/data/datasets/ted-csv
tags: [dataset, warehouse, TED, NUTS3, public-procurement, spatial-benchmark]
---

# warehouse_ted_can_2015_nuts3

## Description du jeu de donnees

- Topic: marches publics europeens agreges au niveau NUTS3.
- Observation unit: region NUTS3 en 2015.
- Observed population: avis d'attribution de marches publics TED localisables par code NUTS3.
- Geographic context: Europe, geometries NUTS3 GISCO 2013.
- Temporal context: coupe transversale 2015.
- Source description: TED V2.2 Contract Award Notices CSV subset; geometries Eurostat GISCO NUTS 2013.
- Description confidence: medium.
- Source URL: https://data.europa.eu/data/datasets/ted-csv
- Local raw dir: data/raw/warehouse/warehouse_ted_can_2015_nuts3/
- Local sf output: data/final_datasets/sf/warehouse_ted_can_2015_nuts3.rds

## Bloc 1 - Formule et variables

### Variables

- Candidate Y variables: `log_mean_award_value_eur`, `log_total_award_value_eur`.
- Candidate Y typology: continuous.
- Candidate X variables in local artifact: `mean_number_offers`, `single_bid_share`, `share_services`, `share_works`, `share_eu_funds`, `share_gpa`, `share_framework_agreement`, `share_electronic_auction`, `share_cpv45_construction`, `share_cpv71_arch_engineering`, `share_cpv72_it_services`, `share_cpv90_environment`.
- Candidate X count in local artifact: 12.
- ML candidate X variables in local artifact: `n_award_rows`, `n_source_rows`, `mean_number_offers`, `single_bid_share`, `mean_number_awards`, `share_services`, `share_works`, `share_supplies`, `share_eu_funds`, `share_gpa`, `share_framework_agreement`, `share_electronic_auction`, `share_subcontracted`, `share_cpv45_construction`, `share_cpv33_medical`, `share_cpv71_arch_engineering`, `share_cpv72_it_services`, `share_cpv90_environment`.
- ML candidate X count in local artifact: 18.
- Candidate X typology: continuous/rate.
- Coordinates: polygon geometry NUTS3; coordinates are not used as X by default.
- Identifier columns: `nuts_code`, `nuts_name`, `country_code`, `year`.
- Variables inspected: yes, by `build_ted_can_2015_nuts3.R`.
- Presence of imputed X: no (ajoute 2026-09-15). Aucune covariable X n'est imputee -- la seule region NUTS3 avec une variable de formule manquante est retiree (voir Bloc 4, "NUTS3 regions dropped because formula variables contain NA: 1"), pas remplacee par une valeur estimee. Les lignes TED couvrant plusieurs NUTS3 sont reparties a poids egal entre les regions concernees (voir Bloc 4, "Multi-NUTS3 rows split with equal weights") -- une regle d'allocation documentee, pas une imputation de valeur manquante.

> Selection Y/X (warehouse-loader / curated evidence) : Pour `warehouse_ted_can_2015_nuts3`, la reponse `log_mean_award_value_eur` decrit la valeur moyenne des marches attribues par region NUTS3 apres transformation `log1p`. Les covariables X de la formule commune decrivent la concurrence (`mean_number_offers`, `single_bid_share`), la composition des contrats, les fonds europeens, les accords-cadres, l'enchere electronique et quelques familles CPV. Le bloc `ml_or_selected` expose aussi les volumes regionaux, le nombre moyen de lots attribues, les fournitures, la sous-traitance et les familles CPV supplementaires afin que les modeles machine learning puissent effectuer leur selection de variables. Les variables directement derivees de la valeur attribuee cible (`mean_award_value_eur`, `total_award_value_eur`, `log_total_award_value_eur`) et les variables incompletes restent exclues de X. Les identifiants et la geometrie sont aussi exclus. La formule est une formule systeme documentee depuis les champs TED, pas une formule publiee dans un article.

### Formule - niveau publication

- formula_pub: not_applicable_warehouse_source
- x_terms_pub: not_applicable
- y_term_pub: not_applicable
- Reference publication: none. Source administrative officielle, sans papier empirique associe.
- Related literature: Fazekas and Czibik (2021) use TED 2006-2015 to construct regional public spending quality indicators; GTI (2026) publishes regional annual TED indicators; other TED studies use competition indicators, single-bid proxies or NUTS3 geography. These sources support the relevance of the variables but do not make this dataset a direct paper replication.

### Formule - niveau systeme

- formula_used: `log_mean_award_value_eur ~ mean_number_offers + single_bid_share + share_services + share_works + share_eu_funds + share_gpa + share_framework_agreement + share_electronic_auction + share_cpv45_construction + share_cpv71_arch_engineering + share_cpv72_it_services + share_cpv90_environment`
- x_terms_used: see Candidate X variables.
- y_term_used: `log_mean_award_value_eur`.
- Note: formule derivee pour produire une tache de regression continue a partir d'un entrepot officiel. Elle doit rester distinguee des formules issues d'articles scientifiques. La formule commune sert a comparer les estimateurs sur le meme X ; la formule ML complete sert a comparer des pipelines capables de selectionner automatiquement les variables.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "log_mean_award_value_eur ~ mean_number_offers"
    response: "log_mean_award_value_eur"
    predictors: ["mean_number_offers"]
    role: "simple_baseline"
    source_type: "warehouse_fields"
    source_ref: "TED CAN 2015 fields aggregated by NUTS3"
    estimator_context: ["ols", "gam_spatial", "random_forest", "xgboost", "sar_lag", "sem_error", "sdm_mixed"]
    status: "system_generated_documented"

  multivariate_constrained:
    formula: "log_mean_award_value_eur ~ mean_number_offers + single_bid_share + share_services + share_works + share_eu_funds + share_gpa + share_framework_agreement + share_electronic_auction + share_cpv45_construction + share_cpv71_arch_engineering + share_cpv72_it_services + share_cpv90_environment"
    response: "log_mean_award_value_eur"
    predictors: ["mean_number_offers", "single_bid_share", "share_services", "share_works", "share_eu_funds", "share_gpa", "share_framework_agreement", "share_electronic_auction", "share_cpv45_construction", "share_cpv71_arch_engineering", "share_cpv72_it_services", "share_cpv90_environment"]
    role: "warehouse_benchmark_specification"
    source_type: "official_administrative_source"
    source_ref: "TED V2.2 CAN CSV fields + GISCO NUTS3 2013 geometries"
    estimator_context: ["ols", "gam_spatial", "random_forest", "xgboost", "sar_lag", "sem_error", "sdm_mixed"]
    status: "system_generated_documented"

  ml_or_selected:
    formula: "log_mean_award_value_eur ~ n_award_rows + n_source_rows + mean_number_offers + single_bid_share + mean_number_awards + share_services + share_works + share_supplies + share_eu_funds + share_gpa + share_framework_agreement + share_electronic_auction + share_subcontracted + share_cpv45_construction + share_cpv33_medical + share_cpv71_arch_engineering + share_cpv72_it_services + share_cpv90_environment"
    response: "log_mean_award_value_eur"
    predictors: ["n_award_rows", "n_source_rows", "mean_number_offers", "single_bid_share", "mean_number_awards", "share_services", "share_works", "share_supplies", "share_eu_funds", "share_gpa", "share_framework_agreement", "share_electronic_auction", "share_subcontracted", "share_cpv45_construction", "share_cpv33_medical", "share_cpv71_arch_engineering", "share_cpv72_it_services", "share_cpv90_environment"]
    role: "ml_candidate_features"
    source_type: "official_administrative_source"
    source_ref: "TED V2.2 CAN CSV fields aggregated by NUTS3; broader feature set for RF/XGBoost/boosting variable selection"
    estimator_context: ["random_forest", "xgboost", "gamboost"]
    status: "system_generated_documented"
```

### Litterature associee

- Fazekas and Czibik (2021), DOI `10.1080/00343404.2021.1902975`: TED 2006-2015, indicateurs regionaux de qualite de la depense publique.
- Government Transparency Institute (2026): donnees annuelles agregees TED 2011-2025 aux niveaux national et regional.
- Tatrai, Vorosmarty and Juhasz (2024): analyse de la concurrence dans les marches publics a partir de TED.
- Wachs, Fazekas and Kertesz (2021): risque de corruption dans les marches publics, avec usage d'indicateurs de soumission unique.
- Herz and Varela-Irimia (2020), *Journal of Economic Geography* 20(6):1359-1405, DOI `10.1093/jeg/lbaa001` (correction 2026-09-15 : la fiche citait a tort "2017" -- 2017 n'est ni le preprint MPRA #76401 ni la version publiee ; verifie via Oxford Academic) : modele de gravite sur ~1,8M d'attributions TED geolocalisees a l'echelle NUTS3, effets frontiere nationaux/regionaux -- PAS un modele SAR/SEM/SDM, la dependance spatiale n'est pas modelisee par un W explicite.
- Fazekas, M. (2017), *"Assessing the Quality of Government at the Regional Level Using Public Procurement Data"*, European Commission, DG Regional and Urban Policy, Working Paper WP 12/2017 (ajout 2026-09-15, PDF lu integralement) : construit des indicateurs de gouvernance (transparence/concurrence/efficacite/corruption) depuis TED 2006-2015 (>4M contrats), NUTS2/NUTS3, avec une section "regional convergence" (4.2.1) -- verifie : purement descriptif (cartes, indicateurs composites, tests de dispersion), aucune regression spatiale (SAR/SEM/GWR) malgre le niveau NUTS3. Reference methodologique directe (meme source TED, meme construction d'indicateurs regionaux) pour la validite des variables candidates de cette fiche, pas une formule reproductible.
- Fazekas, Toth, Wachs and Abdou (2026), *"Public procurement cartels: A large-sample testing of screens using machine learning"*, International Journal of Industrial Organization, vol. 104 (ajout 2026-09-15, DOI non confirme -- voir ScienceDirect PII S0167718725000943) : random forest sur donnees TED, mais au niveau contrat/entreprise pour une classification cartel/non-cartel, pas une regression regionale ; les auteurs notent explicitement que "regional codes do not necessarily capture the geographical scope of markets", une reserve contre l'agregation NUTS3 a garder en tete pour cette fiche.
- Csaki and Prier (2018), *"Quality Issues of Public Procurement Open Data"*, dans *Electronic Government and the Information Systems Perspective* (EGOVIS 2018), pp. 177-191, DOI `10.1007/978-3-319-98349-3_14` (ajout 2026-09-15) : telechargent le TED CSV le 17 janvier 2017, limitent l'analyse a 2009-2015, fichiers CN et CAN, citent explicitement le "TED Processed Database Notes & Codebook Version 2.2" -- meme generation V2.2 que le fichier source de cette fiche (`TED_V2.2_CAN.zip`). Analyse des problemes de qualite, doublons et niveaux d'observation, pas une formule de regression.
- Duguay, Rauter and Samuels (2023), *Journal of Accounting Research* 61(4):1159-1224, DOI `10.1111/1475-679X.12479` (ajout 2026-09-15) : effet de l'ouverture des donnees TED sur la concurrence dans les procedures d'attribution, identification par les seuils europeens de marches publics ; pas une regression spatiale.
- Potin, Labatut, Morand and Largeron (2023), *Scientific Data* 10:303, DOI `10.1038/s41597-023-02213-z` (ajout 2026-09-15) : construisent FOPPA, une base nettoyee des marches publics francais 2010-2020 a partir d'un sous-ensemble TED (fichiers CAN) -- reference directe pour les problemes pratiques du TED (identifiants manquants, doublons, champs melanges) pertinents pour cette fiche.
- Deschamps, Genre-Grandpierre and Morand (2025), *Cybergeo* (ajout 2026-09-15) : utilisent FOPPA (donc TED) pour analyser les interactions spatiales entre acheteurs et fournisseurs francais a plusieurs echelles (region/departement/commune), comparent distance euclidienne, contiguite et flux -- analyse explicitement descriptive/exploratoire, pas une regression SAR/SEM/SDM.

Recherche documentee (2026-09-15, requetes web multiples : TED+GWR, TED+INLA/bayesien, TED+Moran/spatial-lag, TED+machine learning regional) : aucune publication combinant le TED CSV (a fortiori la generation V2.2 2009-2015 de cette fiche) et une regression spatiale explicite (SAR/SEM/SDM/GWR/INLA) ou un pipeline de ML spatial n'a ete trouvee. Les usages spatiaux existants du TED restent soit des modeles de gravite (Herz and Varela-Irimia), soit des analyses descriptives des interactions spatiales (Deschamps et al.). Des methodes d'econometrie spatiale existent bien pour la detection de collusion dans les marches publics (Moran's I sur residus d'encheres, ex. cartels bresiliens/suedois), mais jamais appliquees a TED. Ces references restent des preuves de contexte pour l'exploitation spatiale des donnees TED. Elles ne sont pas utilisees comme formule publiee directe pour ce jeu de donnees -- `formula_pub: not_applicable_warehouse_source` reste donc correct, ce n'est pas une lacune de recherche mais un vide reel dans la litterature.

## Bloc 2 - Identification et source

- Dataset ID: `warehouse_ted_can_2015_nuts3`
- Dataset name: TED contract award notices 2015 aggregated by NUTS3
- Source family: warehouse-derived
- Source: Tenders Electronic Daily / data.europa.eu
- Paper DOI: none
- Dataset DOI: none
- Source URL: https://data.europa.eu/data/datasets/ted-csv
- Geometry source: Eurostat GISCO NUTS 2013 level 3
- Year: 2015

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression continue.
- Modele niveau 2 (famille): modeles globaux, modeles spatiaux avec W reconstruite depuis polygones NUTS3, modeles ML avec effets spatiaux implicites ou coordonnees optionnelles.
- Modele niveau 3 (variante): OLS/GAM/RF/XGBoost/SAR/SEM/SDM selon les besoins du benchmark.

## Bloc 4 - Structure N/T

- Data type: spatial (ajoute 2026-09-15).
- N observations: 1043 regions NUTS3 avec information TED exploitable (libelle complete 2026-09-15, valeur inchangee ; anciennement "N:").
- T periods: 1 (libelle complete 2026-09-15, valeur inchangee ; anciennement "T:").
- N/T profile: N_moyen_T_petit (ajoute 2026-09-15, `profil_nt()` : N=1043 -> N_moyen sous le seuil courant N>=5000 ; T=1 -> T_petit).
- T variable: `year`.
- Structure: coupe transversale spatiale.
- Raw TED rows: 542376.
- Raw rows with usable NUTS3: 244729.
- Multi-NUTS3 rows split with equal weights: 5246.
- NUTS3 regions dropped because formula variables contain NA: 1.

## Bloc 5 - Spatialisation

- Geometry: NUTS3 polygons.
- CRS: WGS 84.
- Spatial resolution: NUTS3 (polygone administratif regional) (ajoute 2026-09-15).
- Temporal resolution: not applicable (coupe transversale, annee 2015 uniquement) (ajoute 2026-09-15).
- Spatial extent: x [-31.25928, 34.58835], y [27.73494, 71.17354], EPSG:4326 (ajoute 2026-09-15, calcule directement depuis `sf::st_bbox()` sur le `.rds`). L'etendue depasse largement le continent europeen car les regions NUTS incluent les territoires ultra-peripheriques (Canaries, Guadeloupe, Guyane, Martinique, Mayotte, Reunion, Acores, Madere).
- Time range: not applicable (coupe transversale, annee 2015 uniquement) (ajoute 2026-09-15).
- W: not stored. Reconstructible from NUTS3 polygon contiguity or centroid distance in the benchmark.
- CRS/geography note: NUTS 2013 geometry is used because the archive covers 2015. Mixed or lower-level NUTS strings are not assigned artificially to NUTS3.

## Bloc 6 - Qualite et promotion

- License present: yes (ajoute 2026-09-15).
- License name: European Commission reuse notice (COM_REUSE) (ajoute 2026-09-15, verifie dans les metadonnees DCAT-AP JSON-LD officielles de data.europa.eu pour la distribution effectivement utilisee, "TED V2.2 - Contract award notice 2009-2015" -- `dct:license` = `http://publications.europa.eu/resource/authority/licence/COM_REUSE`). Ce n'est PAS CC BY 4.0 : d'autres distributions plus recentes du meme jeu TED sont sous CC BY 4.0, mais pas celle-ci.
- License URL: http://publications.europa.eu/resource/authority/licence/COM_REUSE (base legale : Decision de la Commission du 12 decembre 2011, 2011/833/UE).
- License open: yes (reutilisation autorisee sous la seule condition de mentionner la source ; pas une licence SPDX standard comme CC-BY/MIT, mais equivalente en pratique a une reutilisation libre avec attribution).
- License evidence: metadonnees DCAT-AP JSON-LD de data.europa.eu (`https://data.europa.eu/api/hub/repo/datasets/ted-csv.jsonld`), distribution correspondant exactement au fichier local `TED_V2.2_CAN.zip` (accessURL identique), verifie 2026-09-15.
- Reproducibility status: OK - loader R enregistre et reexecutable (`build_ted_can_2015_nuts3.R` dans `code/r_catalog/`) ; source brute (`TED_V2.2_CAN.zip`, `NUTS_RG_10M_2013_4326_LEVL_3.geojson`) conservee localement dans `data/raw/warehouse/warehouse_ted_can_2015_nuts3/` (ajoute 2026-09-15).
- Code available: yes (loader `build_ted_can_2015_nuts3.R`).
- Repository: warehouse-derived (voir `inst/kg/paper_dataset_uses.json`, `paper_id: dataset:warehouse:ted_can_2015_nuts3`).

```yaml
benchmark_readiness:
  benchmark_status: "ready_needs_review"
  benchmark_task: "continuous_regression"
  package_include: "manual_review"
  benchmark_missing_items: []
  benchmark_readiness_reason: "Artefact sf lisible, Y continue, plusieurs X disponibles et support spatial polygonal. Revue manuelle conservee car la formule est systeme/documentee et la source TED V2.2 est une version obsolete pour reference."
```

## Estimator eligibility

Ajoute 2026-09-15 (mode production de secours) : aucune reproduction de papier n'est possible ici (aucune regression spatiale publiee sur TED, voir Litterature associee) -- les candidats ci-dessous sont retenus sur la seule base des caracteristiques verifiees du `.rds` (N=1043 polygones NUTS3, geometrie MULTIPOLYGON reelle CRS WGS 84, Y continue `log_mean_award_value_eur` sans valeur manquante, 12 X continues/taux), pas d'une reproduction revendiquee.

```yaml
estimator_eligibility:
  eligible_estimators:
    - estimator: ols
      basis: benchmark_use
      source_ref: "Aucune -- baseline non spatiale standard."
      notes: "Regression lineaire sur les 12 X continues/taux retenues dans formula_used."
    - estimator: gam_spatial
      basis: benchmark_use
      source_ref: "Aucune -- approximation spatiale generique (lisseur sur centroides NUTS3)."
      notes: "Pas une reproduction : aucun papier n'ajuste ce lisseur sur ce jeu."
    - estimator: random_forest
      basis: benchmark_use
      source_ref: "Aucune -- comparateur ML generique."
      notes: "Y continu, X numeriques propres, pas d'obstacle technique."
    - estimator: xgboost
      basis: benchmark_use
      source_ref: "Aucune -- comparateur ML generique."
      notes: "Idem random_forest."
    - estimator: sar_lag
      basis: benchmark_use
      source_ref: "Aucune -- W constructible par contiguite polygonale (spdep::poly2nb), pas publiee."
      notes: "Geometrie polygonale NUTS3 authentique (verifie dans le .rds) -- W de contiguite plus defendable ici que sur la plupart des jeux POINT du corpus, mais reste une construction du projet, pas une reproduction."
    - estimator: sem_error
      basis: benchmark_use
      source_ref: "Aucune -- meme W que sar_lag."
      notes: "Idem sar_lag."
    - estimator: sdm_mixed
      basis: benchmark_use
      source_ref: "Aucune -- meme W que sar_lag."
      notes: "Idem sar_lag."
  conditionally_eligible_estimators:
    - estimator: mgwrsar_gwr
      basis: benchmark_use
      source_ref: "Aucune reproduction -- plausible vu l'heterogeneite regionale documentee par Fazekas (2017, WP 12/2017) entre Europe du Sud/Mediterranee et Europe du Nord/Ouest sur des indicateurs TED comparables."
      notes: "Non teste sur ce jeu specifique ; conditionnel jusqu'a validation empirique (convergence, temps de calcul a N=1043)."
    - estimator: spmoran_esf
      basis: benchmark_use
      source_ref: "Aucune reproduction -- coordonnees de centroides NUTS3 suffisantes."
      notes: "Non teste sur ce jeu specifique."
    - estimator: spmoran_resf
      basis: benchmark_use
      source_ref: "Aucune reproduction -- meme base que spmoran_esf."
      notes: "Non teste sur ce jeu specifique."
    - estimator: inla_spde
      basis: benchmark_use
      source_ref: "Aucune reproduction -- estimateur ajoute au package le 2026-09-14/15, famille gaussienne sur coordonnees de centroides NUTS3."
      notes: "Non teste sur ce jeu specifique ; aucun obstacle technique identifie (Y continu, coordonnees disponibles via centroides polygone)."
  ineligible_reason: "n/a -- aucun estimateur n'est exclu par construction ; tous les candidats ci-dessus sont classes 'benchmark_use' (comparateur), pas 'paper_replication', faute de formule spatiale publiee sur TED (voir Litterature associee)."
  rule: "Revue de la tache avant selection des routes ; aucune promotion automatique. Support spatial reel (polygones NUTS3) mais aucune dependance spatiale documentee dans la litterature -- tout estimateur spatial ici est un choix de benchmark, pas une reproduction."
```

### Quality control

- Schema: Bloc 1-6 compatible.
- Source caveat: TED signale ce sous-ensemble V2.2 comme obsolete / reference only; eviter les comparaisons temporelles avec d'autres annees sans controle supplementaire.
- Geometry caveat: les lignes sans NUTS3 exploitable ne sont pas forcees dans une region.
- Package promotion: possible apres validation humaine de la specification systeme et du poids spatial retenu.

## Related Pages

- Source: Tenders Electronic Daily (TED) (csv subset) - public procurement notices, data.europa.eu (https://data.europa.eu/data/datasets/ted-csv).
- Geometries: Eurostat GISCO, NUTS 2013 level 3.
- Voir "Litterature associee" (Bloc 1) pour les references sur les usages scientifiques de TED et l'etat de la litterature en econometrie spatiale/ML appliquee a ce jeu.
