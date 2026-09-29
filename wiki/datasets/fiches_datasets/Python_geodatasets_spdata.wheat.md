---
title: Python_geodatasets_spdata.wheat
type: dataset
created: 2026-08-15
updated: 2026-09-16
sources:
  - data/final_datasets/sf/Python_geodatasets_spdata.wheat.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`wheat`).

## Description du jeu de donnees

- Topic: agriculture / rendement ou experimentation agronomique
- Observation unit: parcelle, placette experimentale ou observation agricole
- Observed population: observations agricoles documentees par le package source
- Geographic context: Etendue mesuree dans le RDS : x [2.51, 62.75], y [3, 65.7]; CRS WGS 84.
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`wheat`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `yield`
- Candidate Y typology: continuous
- Candidate X variables: `r`, `c`, `lat1`
- Candidate X typology: categorical, continuous
- Coordinates (x, y — excluded from X candidates): `lat`, `lon`, `X`, `Y`
- Identifier columns (excluded from X candidates): `SP_ID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `yield` | `numeric` | continuous | [2.73, 5.16] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Selection Y/X corrigee depuis la documentation source : `yield` est la variable reponse naturelle. `r` et `c` decrivent les lignes et colonnes des centres de parcelles; elles sont donc des covariables de position/grille utiles pour capter un effet spatial de champ. `lat1` conserve le gradient nord-sud transforme de la documentation.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `r` | `character` | categorical | 0% |
| `c` | `character` | categorical | 0% |
| `lat1` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: yield ~ X1 + s(X2)  [E(Y_ij \| X1_ij, X2_ij) = beta0 + beta1*X1_ij + g2(X2_ij)]
- x_terms_pub: X1 (terme lineaire, =Y_(i-1,j)+Y_(i+1,j)), s(X2) (terme non-parametrique lisse, X2=Y_(i,j-1)+Y_(i,j+1)) -- sommes des voisins nord-sud/est-ouest, derivees des indices de grille r/c, non presentes telles quelles dans le .rds
- y_term_pub: yield (grain yield de Mercer & Hall -- non distingue du straw yield dans la doc du package)
- Reference publication: Gao, J., Lu, Z. & Tjostheim, D. (2006), 'Estimation in semiparametric spatial regression', The Annals of Statistics 34(3), 1395-1435, DOI: 10.1214/009053606000000317 (DOI verifie via Crossref ; contenu verifie mot pour mot via le pre-print libre identique, MPRA paper 11991, la version publiee etant payante). Analyse le jeu de rendement de ble Mercer & Hall (1911) : confirme dans le texte -- '500 wheat plots, each 11 ft by 10.82 ft., arranged in a 20x25 rectangle' -- correspondance exacte avec ce jeu (meme structure de grille, memes references croisees Besag 1974/Cressie 1993 deja citees ailleurs dans cette fiche). Modele principal retenu par les auteurs (section 4, eq. 4.3) : regression spatiale autoregressive semi-parametrique partiellement lineaire E(Y_ij | X1_ij, X2_ij) = beta0 + beta1*X1_ij + g2(X2_ij), ou X1_ij = Y_(i-1,j)+Y_(i+1,j) et X2_ij = Y_(i,j-1)+Y_(i,j+1) sont des sommes des rendements des parcelles VOISINES (modele autoregressif sur grille, pas des covariables exogenes) -- doivent etre construites depuis les indices de grille r/c, non presentes telles quelles dans le .rds actuel. Coefficients estimes : beta0=1.311, beta1=0.335 (verifies verbatim : 'resulting in the estimates beta0=1.311, beta1=0.335'), variance residuelle 0.1081. Y_ij designe le grain yield -- Mercer & Hall (1911) ont mesure grain yield ET straw yield ; la correspondance exacte de la colonne `yield` de ce jeu avec le grain yield specifiquement n'est pas confirmee dans la doc du package spData (mais c'est la version standard reutilisee dans toute la litterature citee ici). Modele alternatif plus simple, cite et compare dans le meme papier (Table 1, eq. 4.1) : schema auto-normal de Besag, J. (1974), 'Spatial interaction and the statistical analysis of lattice systems', JRSS B 36(2), 192-225, Tables 8 et 10 p.221 -- entierement lineaire E(Y_ij|voisins) = gamma0 + gamma1*X1_ij + gamma2*X2_ij, gamma1 estime a 0.343 (Table 8) ou 0.350 (Table 10) selon le schema de codage.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee (necessite construction prealable de covariables derivees X1/X2)
- Correspondance Python/R: aucune identifiee
- Note: Formule Gao, Lu & Tjostheim (2006) confirmee le 2026-09-16 par lecture integrale du texte (pre-print libre identique a la version publiee payante). Renverse la conclusion du 2026-09-16 plus tot ce jour (voir Curation documentee) qui indiquait a tort qu'aucune regression publiee n'existait -- cette premiere conclusion n'avait pas cherche au-dela de la documentation du package. Modele autoregressif spatial sur grille (les "covariables" sont des sommes de valeurs Y voisines, pas des variables exogenes) avec un terme non-parametrique -- necessite une etape de construction de covariables non encore realisee dans cette fiche, donc formula_used n'est pas encore alignee sur formula_pub.

### Formule — niveau systeme

- formula_used: yield ~ r + c + lat1
- Formula used evidence: formula_used reste la formule generee par le systeme (candidate ml_or_selected) ; formula_pub (Gao et al. 2006) necessite la construction prealable des covariables derivees X1/X2 (sommes de voisins nord-sud/est-ouest depuis les indices de grille r/c), non encore realisee -- non promue en formula_used pour eviter d'inventer un pipeline non teste.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: r + c + lat1
- y_term_used: yield

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "yield ~ X1 + X2  [E(Y_ij|voisins) = gamma0 + gamma1*X1_ij + gamma2*X2_ij]"
    response: "yield"
    predictors: ["X1 (=Y_(i-1,j)+Y_(i+1,j))", "X2 (=Y_(i,j-1)+Y_(i,j+1))"]
    role: "simple_baseline"
    source_type: "scientific_publication"
    source_ref: "Besag, J. (1974), 'Spatial interaction and the statistical analysis of lattice systems', JRSS B 36(2), 192-225, Tables 8 et 10, p.221 (schema auto-normal du premier ordre, entierement lineaire) ; reproduit et compare dans Gao, Lu & Tjostheim (2006), Annals of Statistics 34(3), 1395-1435, Table 1, eq.(4.1). Coefficient gamma1 estime : 0.343 (Table 8) ou 0.350 (Table 10) selon le schema de codage utilise par Besag."
    estimator_context: ["linear_regression", "spatial_autoregression", "car_model"]
    status: "confirmed"

  multivariate_constrained:
    formula: "yield ~ X1 + s(X2)  [E(Y_ij|X1,X2) = beta0 + beta1*X1_ij + g2(X2_ij)]"
    response: "yield"
    predictors: ["X1 (=Y_(i-1,j)+Y_(i+1,j), terme lineaire)", "X2 (=Y_(i,j-1)+Y_(i,j+1), terme non-parametrique g2)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Gao, J., Lu, Z. & Tjostheim, D. (2006), 'Estimation in semiparametric spatial regression', Annals of Statistics 34(3), 1395-1435, DOI 10.1214/009053606000000317, section 4, eq.(4.3) -- modele semi-parametrique partiellement lineaire retenu par les auteurs comme meilleur ajustement (g2 non-lineaire, point de rupture x=7.8). Coefficients estimes beta0=1.311, beta1=0.335 (verifies verbatim dans le texte integral du pre-print libre MPRA 11991, contenu identique a la version publiee). Variance residuelle 0.1081 (vs 0.1099-0.1100 pour les schemas auto-normaux entierement lineaires de Besag)."
    estimator_context: ["gam_spatial", "semiparametric_regression", "car_model"]
    status: "confirmed"

  ml_or_selected:
    formula: "yield ~ r + c + lat1"
    response: "yield"
    predictors: ["r", "c", "lat1"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_spdata.wheat`
- Dataset name: geodatasets::wheat
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
  equation_text: "E(Y_ij | X1_ij, X2_ij) = beta0 + beta1*X1_ij + g2(X2_ij) [Gao, Lu & Tjostheim 2006, eq. 4.3]"
  equation_family: regression
  model_family: "spatial autoregression semi-parametrique partiellement lineaire (modele CAR sur grille)"
  source_type: scientific_publication
  source_ref: "Gao, J., Lu, Z. & Tjostheim, D. (2006), Annals of Statistics 34(3), 1395-1435, DOI 10.1214/009053606000000317, section 4, eq.(4.3). Coefficients beta0=1.311, beta1=0.335 verifies verbatim dans le texte integral (pre-print libre MPRA 11991)."
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 500
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation (derive d'un polygone source par reduction geometrique -- st_point_on_surface(), rien n'est perdu -- voir Type de geometrie et geom_origine)
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [2.51, 62.75], y [3, 65.7] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT (source native : POLYGON, preservee dans `geom_origine` ; geometrie active derivee via `st_point_on_surface()` ou equivalent, methodologie documentee dans code/r_catalog/guide_objets_sf.md section 3-5 -- rien n'est perdu, correction 2026-09-16 apres verification via tools/verify_fiche_crs.py)
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: pending — multi-zones (span=60.2deg) -- etendue compatible avec un grand pays/une region ; verifier qu'une projection nationale/regionale existe et convient a cette zone avant de l'utiliser, sinon envisager une projection continentale equal-area

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
  benchmark_status: "manual_review"
  benchmark_task: "regression_spatial_validated_generated_formula"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "Recherche complementaire du 2026-09-16 (suite a l'echange avec un autre agent IA, verifiee independamment via Crossref + lecture integrale du texte du pre-print libre correspondant a l'article publie) a identifie deux modeles publies pour ce jeu exact (Mercer & Hall 1911) -- Besag (1974) et Gao, Lu & Tjostheim (2006) -- annulant la conclusion precedente du meme jour ('aucune regression publiee'). package_include reste 'manual_review' (pas 'yes') car ces modeles sont des autoregressions spatiales sur grille dont les covariables (X1, X2 = sommes des rendements des parcelles voisines nord-sud/est-ouest) doivent etre construites depuis les indices de grille r/c -- etape de feature engineering non encore realisee. formula_used (yield ~ r + c + lat1) reste la formule generee par le systeme en attendant cette construction. Voir Estimator eligibility et Formules candidates pour le detail complet."
  reason: "Recherche complementaire du 2026-09-16 (suite a l'echange avec un autre agent IA, verifiee independamment via Crossref + lecture integrale du texte du pre-print libre correspondant a l'article publie) a identifie deux modeles publies pour ce jeu exact (Mercer & Hall 1911) -- Besag (1974) et Gao, Lu & Tjostheim (2006) -- annulant la conclusion precedente du meme jour ('aucune regression publiee'). package_include reste 'manual_review' (pas 'yes') car ces modeles sont des autoregressions spatiales sur grille dont les covariables (X1, X2 = sommes des rendements des parcelles voisines nord-sud/est-ouest) doivent etre construites depuis les indices de grille r/c -- etape de feature engineering non encore realisee. formula_used (yield ~ r + c + lat1) reste la formule generee par le systeme en attendant cette construction. Voir Estimator eligibility et Formules candidates pour le detail complet."
```

- Decision: manual_review
- Manque principal: Recherche complementaire du 2026-09-16 (suite a l'echange avec un autre agent IA, verifiee independamment via Crossref + lecture integrale du texte du pre-print libre correspondant a l'article publie) a identifie deux modeles publies pour ce jeu exact (Mercer & Hall 1911) -- Besag (1974) et Gao, Lu & Tjostheim (2006) -- annulant la conclusion precedente du meme jour ('aucune regression publiee'). package_include reste 'manual_review' (pas 'yes') car ces modeles sont des autoregressions spatiales sur grille dont les covariables (X1, X2 = sommes des rendements des parcelles voisines nord-sud/est-ouest) doivent etre construites depuis les indices de grille r/c -- etape de feature engineering non encore realisee. formula_used (yield ~ r + c + lat1) reste la formule generee par le systeme en attendant cette construction. Voir Estimator eligibility et Formules candidates pour le detail complet.
- Raison: Recherche complementaire du 2026-09-16 (suite a l'echange avec un autre agent IA, verifiee independamment via Crossref + lecture integrale du texte du pre-print libre correspondant a l'article publie) a identifie deux modeles publies pour ce jeu exact (Mercer & Hall 1911) -- Besag (1974) et Gao, Lu & Tjostheim (2006) -- annulant la conclusion precedente du meme jour ('aucune regression publiee'). package_include reste 'manual_review' (pas 'yes') car ces modeles sont des autoregressions spatiales sur grille dont les covariables (X1, X2 = sommes des rendements des parcelles voisines nord-sud/est-ouest) doivent etre construites depuis les indices de grille r/c -- etape de feature engineering non encore realisee. formula_used (yield ~ r + c + lat1) reste la formule generee par le systeme en attendant cette construction. Voir Estimator eligibility et Formules candidates pour le detail complet.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators:
    - estimator: ols
      basis: published_model
      source_ref: "Besag, J. (1974), JRSS B 36(2), 192-225, Tables 8 et 10, p.221 ; reproduit dans Gao, Lu & Tjostheim (2006), Annals of Statistics 34(3), 1395-1435, Table 1, eq.(4.1)."
      notes: "Schema auto-normal du premier ordre, entierement lineaire (gamma0+gamma1*X1+gamma2*X2) -- directement ajustable via lm()/glm() UNE FOIS X1 (=Y_(i-1,j)+Y_(i+1,j)) et X2 (=Y_(i,j-1)+Y_(i,j+1)) construits depuis les indices de grille r/c (non presents tels quels dans le .rds actuel)."
    - estimator: gam_spatial
      basis: published_model
      source_ref: "Gao, J., Lu, Z. & Tjostheim, D. (2006), Annals of Statistics 34(3), 1395-1435, DOI 10.1214/009053606000000317, section 4, eq.(4.3)."
      notes: "Modele partiellement lineaire retenu par les auteurs comme meilleur ajustement (beta0=1.311, beta1=0.335, terme g2 non-parametrique avec point de rupture ~7.8) -- correspond structurellement a mgcv::gam(yield ~ X1 + s(X2)), le moteur reel de gam_spatial. Meme prerequis que ols ci-dessus : X1/X2 doivent etre construits depuis r/c avant utilisation."
  conditionally_eligible_estimators: []
  ineligible_reason: "Recherche complementaire du 2026-09-16 a identifie deux modeles publies pour ce jeu exact (Mercer & Hall 1911) -- Besag (1974) et Gao, Lu & Tjostheim (2006), DOI verifie, coefficients confirmes par lecture integrale du texte -- annulant la conclusion precedente du meme jour ('aucune regression publiee'). Statut maintenu en manual_review (pas promu a 'yes') car formula_used ne correspond pas encore a ces modeles : X1/X2 (sommes des rendements voisins) doivent etre construits depuis les indices de grille r/c, etape non encore realisee dans cette fiche."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee (Gao, Lu & Tjostheim 2006 ; Besag 1974) -- necessite construction de covariables derivees X1/X2 avant execution, voir Estimator eligibility.
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

Synchronisation du 2026-09-16 : le texte de `benchmark_readiness.reason`/`missing_items` decrivait encore l'etat non resolu du 2026-09-07 ('estimator_eligibility_block_missing, conserver la decision en attendant le traitement des constats'), alors que le bloc `Estimator eligibility` avait deja ete rempli entre-temps avec une conclusion definitive et sourcee (aucun estimateur eligible -- jeu Mercer & Hall 1911 d'autocorrelation spatiale, pas de regression Y~X publiee). Le texte de readiness a ete mis a jour pour refleter cette conclusion deja etablie, au lieu de laisser croire que l'analyse restait a faire. Aucun champ de decision (`benchmark_status`/`package_include`, tous deux `manual_review`) n'a change -- seule la justification textuelle a ete resynchronisee.

Correction du 2026-09-16 (suite) : la conclusion ci-dessus ('aucune specification de regression publiee') est ANNULEE. Recherche complementaire menee suite a un echange avec un autre agent IA (ChatGPT) ayant propose la reference Gao, Lu & Tjostheim (2006) -- verifiee independamment avant toute integration (DOI confirme via Crossref ; contenu verifie mot pour mot via le texte integral du pre-print libre identique, MPRA paper 11991, la version publiee de l'Annals of Statistics etant payante).

Deux modeles publies identifies pour ce jeu exact (Mercer & Hall 1911, meme grille 20x25/500 parcelles) : (1) Besag (1974), schema auto-normal entierement lineaire (Tables 8/10, gamma1=0.343/0.350) ; (2) Gao, Lu & Tjostheim (2006), modele semi-parametrique partiellement lineaire retenu comme meilleur ajustement (eq. 4.3, beta0=1.311, beta1=0.335, coefficients verifies verbatim dans le texte). Les deux sont des autoregressions spatiales sur grille : les "covariables" X1/X2 sont des sommes des rendements des parcelles voisines (nord-sud et est-ouest), pas des variables exogenes -- elles doivent etre construites depuis les indices de grille r/c, etape non encore realisee dans cette fiche. formula_pub/Bloc 3/Estimator eligibility mis a jour en consequence ; formula_used et benchmark_status/package_include restent inchanges (manual_review) en attendant cette construction.
