---
title: Python_geodatasets_geoda.guerry
type: dataset
created: 2026-08-15
updated: 2026-09-16
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.guerry.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`guerry`).

## Description du jeu de donnees

- Topic: Donnees de python-package : Python_geodatasets_geoda.guerry
- Observation unit: observation spatiale de type POINT
- Observed population: 85 enregistrements dans l’artefact local Python_geodatasets_geoda.guerry.rds; unite declaree : observation spatiale de type POINT. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: Etendue mesuree dans le RDS : x [-3.819848391494, 7.535220233799], y [42.624745287549, 50.534222884545]; CRS EPSG:4326.
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`guerry`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Crm_prs`, `Crm_prp`, `Litercy`, `Suicids`, `Lottery`, `Infants`
- Candidate Y typology: continuous
- Candidate X variables: `Wealth`, `Commerc`, `Clergy`, `Donatns`, `Prsttts`, `Distanc`, `Area`, `Pop1831`, `Desertn`, `Instrct`, `MainCty`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown
- Note complementaire (2026-09-16): `Region` (categorielle, 5 niveaux C/E/N/S/W, 17 obs/niveau, verifie par inspection directe du RDS) est absente de la liste Candidate X ci-dessus car cette liste est limitee aux variables continues par le script d'export ; `Region` est neanmoins un predicteur reel utilise ci-dessous car cite explicitement dans la publication (formula_pub).

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Crm_prs` | `numeric` | continuous | [5883, 37014] | 0% |
| `Crm_prp` | `numeric` | continuous | [1368, 20235] | 0% |
| `Litercy` | `numeric` | continuous | [12, 74] | 0% |
| `Suicids` | `numeric` | continuous | [3460, 163241] | 0% |
| `Lottery` | `numeric` | continuous | [1, 86] | 0% |
| `Infants` | `numeric` | continuous | [2660, 62486] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables Y candidates sont des outcomes sociaux mesurés (criminalité, suicide, illettrisme, infanticide, jeux de loterie) typiquement modélisés dans la littérature Guerry comme variables réponse. Les variables X candidates sont des indicateurs structurels, économiques ou démographiques (richesse, commerce, clergé, dons, prostitution, distance, superficie, population, désertion, instruction, type de ville) servant de covariables explicatives ; les colonnes purement administratives ou géographiques (dept, Region, Dprtmnt) et les doublons en rang (Crm_prn, Infntcd, Dntn_cl) sont ignorés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Wealth` | `numeric` | continuous | 0% |
| `Commerc` | `numeric` | continuous | 0% |
| `Clergy` | `numeric` | continuous | 0% |
| `Donatns` | `numeric` | continuous | 0% |
| `Prsttts` | `numeric` | continuous | 0% |
| `Distanc` | `numeric` | continuous | 0% |
| `Area` | `numeric` | continuous | 0% |
| `Pop1831` | `numeric` | continuous | 0% |
| `Desertn` | `numeric` | continuous | 0% |
| `Instrct` | `numeric` | continuous | 0% |
| `MainCty` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: Crm_prp ~ Region + Suicids + Litercy + Donatns + Infants + Wealth
- x_terms_pub: Region, Suicids, Litercy, Donatns, Infants, Wealth
- y_term_pub: Crm_prp
- Reference publication: Friendly, M. (2007), 'A.-M. Guerry's Moral Statistics of France: Challenges for Multivariable Spatial Analysis', Statistical Science 22(3), 368-399 (arXiv:0801.4263), page 22, section 3.3 'HE plots for Multivariate Linear Models' -- reduction univariee de l'objet R 'guerry.mod' (lm(cbind(Crime_prop, Crime_pers) ~ Region + Suicides + Literacy + Donations + Infants + Wealth)) ; les coefficients d'une regression cbind() sont identiques a ceux d'un lm() univarie separe par reponse. R2 rapporte pour Crime_prop (= Crm_prp dans ce jeu) : 0.43, superieur au 0.36 de Crime_pers (= Crm_prs). Suicides et Wealth sont les deux predicteurs individuellement significatifs pour la criminalite contre la propriete (Manova(guerry.mod, test='Roy') : p=0.007 et p=0.006 respectivement ; texte p.24 : 'Suicide and wealth are strongly related to crimes against property, but not to crimes against persons').

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule corrigee le 2026-09-16 -- l'ancienne formula_pub (Crm_prs ~ Litercy) etait une illustration bivariee de la section 3.1 (p.18) du meme papier, non le modele reellement ajuste et evalue par l'auteur. Le modele reellement publie est multi-reponses (cbind(Crime_prop, Crime_pers), p.22) ; Crm_prp est retenu ici comme reponse unique car R2=0.43 (vs 0.36 pour Crm_prs) et ses predicteurs cles (Suicids, Wealth) sont individuellement significatifs dans la publication -- voir Formules candidates > multivariate_constrained pour la specification bivariee complete.

### Formule — niveau systeme

- formula_used: Crm_prp ~ Region + Suicids + Litercy + Donatns + Infants + Wealth
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: Region, Suicids, Litercy, Donatns, Infants, Wealth
- y_term_used: Crm_prp

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "Crm_prp ~ Region + Suicids + Litercy + Donatns + Infants + Wealth"
    response: "Crm_prp"
    predictors: ["Region", "Suicids", "Litercy", "Donatns", "Infants", "Wealth"]
    role: "paper_main_specification_univariate_reduction"
    source_type: "scientific_publication"
    source_ref: "Friendly, M. (2007), 'A.-M. Guerry's Moral Statistics of France: Challenges for Multivariable Spatial Analysis', Statistical Science 22(3), 368-399 (arXiv:0801.4263), page 22, section 3.3 'HE plots for Multivariate Linear Models' -- reduction univariee de l'objet R 'guerry.mod' (lm(cbind(Crime_prop, Crime_pers) ~ Region + Suicides + Literacy + Donations + Infants + Wealth)) ; les coefficients d'une regression cbind() sont identiques a ceux d'un lm() univarie separe par reponse. R2 rapporte pour Crime_prop (= Crm_prp dans ce jeu) : 0.43, superieur au 0.36 de Crime_pers (= Crm_prs). Suicides et Wealth sont les deux predicteurs individuellement significatifs pour la criminalite contre la propriete (Manova(guerry.mod, test='Roy') : p=0.007 et p=0.006 respectivement ; texte p.24 : 'Suicide and wealth are strongly related to crimes against property, but not to crimes against persons')."
    estimator_context: ["linear_regression", "spatial_baseline"]
    status: "confirmed"

  multivariate_constrained:
    formula: "cbind(Crime_prop, Crime_pers) ~ Region + Suicides + Literacy + Donations + Infants + Wealth"
    response: "Crime_prop, Crime_pers (reponse bivariee)"
    predictors: ["Region", "Suicides", "Literacy", "Donations", "Infants", "Wealth"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Friendly, M. (2007), 'A.-M. Guerry's Moral Statistics of France: Challenges for Multivariable Spatial Analysis', Statistical Science 22(3), 368-399 (arXiv:0801.4263), page 22, section 3.3 'HE plots for Multivariate Linear Models' -- objet R 'guerry.mod', code source cite verbatim dans l'article. R2 rapporte : 0.43 pour Crime_prop, 0.36 pour Crime_pers (Manova(guerry.mod, test='Roy'))."
    estimator_context: ["multivariate_linear_model", "manova"]
    status: "confirmed"
    note: "Modele multi-reponses (deux variables Y jointes via cbind) -- le pipeline de benchmark du package attend une reponse unique, donc c'est la reduction univariee sur Crm_prp (voir 'univariate' ci-dessus) qui est retenue comme formula_used/formula_pub depuis le 2026-09-16."

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

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.guerry`
- Dataset name: geodatasets::guerry
- Source family: python-package
- Source: package Python `geodatasets`
- Source URL: https://pypi.org/project/geodatasets/
- Dataset DOI: none
- Publication DOI: pending
- Year: 2023

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Crm_prp ~ Region + Suicids + Litercy + Donatns + Infants + Wealth"
  equation_family: regression
  model_family: "reduction univariee d'un modele multivarie publie (guerry.mod)"
  source_type: scientific_publication
  source_ref: "Friendly, M. (2007), 'A.-M. Guerry's Moral Statistics of France: Challenges for Multivariable Spatial Analysis', Statistical Science 22(3), 368-399 (arXiv:0801.4263), page 22, section 3.3 'HE plots for Multivariate Linear Models' -- reduction univariee de l'objet R 'guerry.mod' (lm(cbind(Crime_prop, Crime_pers) ~ Region + Suicides + Literacy + Donations + Infants + Wealth)) ; les coefficients d'une regression cbind() sont identiques a ceux d'un lm() univarie separe par reponse. R2 rapporte pour Crime_prop (= Crm_prp dans ce jeu) : 0.43, superieur au 0.36 de Crime_pers (= Crm_prs). Suicides et Wealth sont les deux predicteurs individuellement significatifs pour la criminalite contre la propriete (Manova(guerry.mod, test='Roy') : p=0.007 et p=0.006 respectivement ; texte p.24 : 'Suicide and wealth are strongly related to crimes against property, but not to crimes against persons')."
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 85
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-3.8198, 7.5352], y [42.6247, 50.5342] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT (source native : MULTIPOLYGON, preservee dans `geom_origine` ; geometrie active derivee via `st_point_on_surface()` ou equivalent, methodologie documentee dans code/r_catalog/guide_objets_sf.md section 3-5 -- rien n'est perdu, correction 2026-09-16 apres verification via tools/verify_fiche_crs.py)
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32631 (UTM Zone 31N (EPSG:32631)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/geodatasets/
- License open: yes
- Reproducibility status: available via package Python `geodatasets`
- Code available: yes (package examples and vignettes)
- Repository: python-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_spatial_package_formula"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Formule issue d'une publication/documentation package, reponse numerique, covariables locales et support spatial disponibles. Bloc estimator_eligibility complete le 2026-09-08 avec au moins un estimateur documente (voir section Estimator eligibility) -- resout l'incoherence 'estimator_eligibility_block_missing' qui avait motive la retrogradation du 2026-09-07."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Formule issue d'une publication/documentation package, reponse numerique, covariables locales et support spatial disponibles. Bloc estimator_eligibility complete le 2026-09-08 avec au moins un estimateur documente (voir section Estimator eligibility) -- resout l'incoherence 'estimator_eligibility_block_missing' qui avait motive la retrogradation du 2026-09-07.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators:
    - estimator: ols
      basis: published_model
      source_ref: "Friendly, M. (2007), Statistical Science 22(3), 368-399, page 22, section 3.3 (guerry.mod)."
      notes: "Relation Crm_prp ~ Region + Suicids + Litercy + Donatns + Infants + Wealth documentee dans la litterature Guerry (formula_pub, reduction univariee du modele multi-reponses guerry.mod, R2=0.43 pour cette reponse) ; regression lineaire simple, aucune estimation spatiale specifique citee dans la fiche a ce jour."
  conditionally_eligible_estimators:
    - estimator: sar_lag
      basis: scientific_evidence
      source_ref: "Dray, S. and Jombart, T. (2011), 'Revisiting Guerry's data: Introducing spatial constraints in multivariate analysis', The Annals of Applied Statistics 5(4), 2278-2299, DOI: 10.1214/10-AOAS356 (deja disponible localement : corpus/papers/raw_pdf/HistData_Guerry - Revisiting Guerrys data Introducing spatial constraints in multivariate analysis.pdf). Table 2, p.6 : coefficient de Moran significatif pour Crime_pers (MC=0.411, p=0.001) et Crime_prop (MC=0.264, p=0.001) sur les memes 85 departements -- autocorrelation spatiale positive et significative confirmee pour les deux candidats Y de cette fiche (dont Crm_prp, la reponse retenue)."
      notes: "Preuve d'autocorrelation spatiale significative sur la reponse, pas une regression SAR/SEM publiee sur cette formule (Dray & Jombart font de l'analyse multivariee/ordination -- PCA, MULTISPATI, BCA -- et un test de Moran, pas de lm() spatial sur Crm_prp ~ predicteurs). Matrice de poids W reproductible et sourcee : contiguite binaire par frontiere commune, standardisee par ligne (equivalent poly2nb()+nb2listw(style='W') du package spdep, section 2.2.1 p.4-5), directement constructible depuis `geom_origine` (MULTIPOLYGON deja preservee dans le RDS de cette fiche, cf. code/r_catalog/guide_objets_sf.md section 3-5)."
    - estimator: sem_error
      basis: scientific_evidence
      source_ref: "Dray, S. and Jombart, T. (2011), 'Revisiting Guerry's data: Introducing spatial constraints in multivariate analysis', The Annals of Applied Statistics 5(4), 2278-2299, DOI: 10.1214/10-AOAS356 (deja disponible localement : corpus/papers/raw_pdf/HistData_Guerry - Revisiting Guerrys data Introducing spatial constraints in multivariate analysis.pdf). Meme Table 2/section 2.2.1 que sar_lag ci-dessus."
      notes: "Meme preuve et meme limite que sar_lag : autocorrelation spatiale significative etablie sur la reponse (Moran's I), matrice W identique disponible et sourcee, mais aucune regression SEM publiee sur guerry.mod ou sa reduction univariee."
  ineligible_reason: "Bloc estimator_eligibility complete le 2026-09-08 (etait vide/placeholder depuis l'audit du 2026-09-07, incoherence 'estimator_eligibility_block_missing'). 1 estimateur(s) documente(s) sans invention, bases exclusivement sur le texte deja present dans 'Reference publication'/'formula_pub' de cette fiche. Candidats spatiaux ajoutes le 2026-09-16, initialement sources sur une note de Friendly (2007) citant un manuscrit non publie (Whitt, 2007) ; remplaces le meme jour par Dray et Jombart (2011), papier revu par les pairs deja disponible localement, qui etablit une autocorrelation spatiale significative sur la reponse et fournit une matrice W reproductible -- toujours en conditionally_eligible (pas eligible) car aucune regression SAR/SEM publiee n'existe sur cette formule precise."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`

## Curation documentée — 2026-09-07

Decision conservatoire : Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

## Curation documentée — 2026-09-16

Formule corrigee : `formula_used`/`formula_pub` passent de `Crm_prs ~ Litercy` (illustration bivariee superficielle, section 3.1 p.18 de Friendly 2007) a `Crm_prp ~ Region + Suicids + Litercy + Donatns + Infants + Wealth` (reduction univariee du modele reellement publie et evalue par l'auteur, guerry.mod, section 3.3 p.22, meme source deja citee dans la fiche).

Choix de la reponse : entre les deux reponses du modele multivarie original (Crime_prop/Crm_prp et Crime_pers/Crm_prs), Crm_prp est retenue car mieux expliquee par le modele (R2=0.43 contre 0.36) et parce que ses predicteurs cles (Suicids, Wealth) sont individuellement significatifs dans le test MANOVA de la publication (p=0.007 et p=0.006), contrairement a Crm_prs ou seul Region ressort comme dominant. Le modele multivarie complet (les deux reponses jointes via cbind) reste documente integralement dans `formula_candidates > multivariate_constrained`.

`Region` est une covariable categorielle (5 niveaux, verifie par inspection directe du RDS le 2026-09-16) absente de la liste automatique "Candidate X" (limitee aux variables continues) mais bien presente et complete dans le jeu de donnees local ; elle est utilisee dans formula_pub/formula_used car explicitement citee dans la publication.

Provenance : lecture complete de Friendly (2007), arXiv:0801.4263, pages 18 et 22, le 2026-09-16.

Ajout du 2026-09-16 (suite) : deux candidats d'estimateurs spatiaux (`sar_lag`, `sem_error`) ajoutes en `conditionally_eligible_estimators`, motives par la note de bas de page 12 (p.22) de Friendly (2007) ou l'auteur reconnait explicitement que `guerry.mod` ignore l'autocorrelation spatiale des residus et cite Whitt, H. P. (2007), *"Modernism, internal colonialism, and the direction of violence: Suicide and crimes against persons in France, 1825-1830"*, comme exemple de traitement spatial d'une question voisine.

Verification faite avant l'ajout : la reference complete de Whitt (2007) a ete retrouvee dans la bibliographie de Friendly (2007), page 33 -- c'est un **manuscrit non publie** ("Unpublished manuscript"), sans revue, sans DOI, non consultable en ligne. Il ne traite pas non plus `guerry.mod` lui-meme (formule differente, portant sur la direction du crime/suicide). En consequence, ces deux estimateurs restent `conditionally_eligible` (candidats motives par le texte, non des reproductions verifiees) et ne sont pas promus en `eligible_estimators` -- seul `ols` (reduction univariee de guerry.mod, verifiee directement dans le PDF de la publication) reste `basis: published_model`.

Correction du 2026-09-16 (suite) : la source de `sar_lag`/`sem_error` a ete remplacee. La premiere version citait Friendly (2007, p.22, note 12) qui renvoyait a Whitt, H. P. (2007), manuscrit non publie et invérifiable (voir plus haut). Sur demande explicite de verifier la reference exacte, une recherche complementaire a identifie Dray, S. et Jombart, T. (2011), *"Revisiting Guerry's data: Introducing spatial constraints in multivariate analysis"*, The Annals of Applied Statistics 5(4), 2278-2299, DOI 10.1214/10-AOAS356 -- **un article revu par les pairs, deja present localement** (`corpus/papers/raw_pdf/HistData_Guerry - Revisiting Guerrys data Introducing spatial constraints in multivariate analysis.pdf`), qui reanalyse exactement le meme jeu de 85 departements que cette fiche.

Ce papier ne fait pas de regression SAR/SEM (il fait de l'analyse multivariee spatiale -- PCA, MULTISPATI, BCA, PCAIV-MEM), mais il apporte deux elements verifiables et directement utiles : (1) un coefficient de Moran significatif pour Crime_pers (0.411, p=0.001) et Crime_prop (0.264, p=0.001), confirmant une autocorrelation spatiale reelle sur la reponse retenue par cette fiche (Crm_prp) ; (2) une matrice de poids spatiale W reproductible et documentee (contiguite binaire par frontiere commune, standardisee par ligne -- section 2.2.1, p.4-5), directement constructible ici depuis `geom_origine` (deja preservee dans le RDS pour cet usage, cf. guide_objets_sf.md). `sar_lag`/`sem_error` restent `conditionally_eligible` (pas `eligible`) car aucune regression spatiale publiee n'existe sur `guerry.mod` ou sa reduction univariee -- seule l'autocorrelation de la reponse est etablie, pas le modele lui-meme.
