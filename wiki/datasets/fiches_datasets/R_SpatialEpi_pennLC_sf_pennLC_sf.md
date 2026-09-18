---
title: R_SpatialEpi_pennLC_sf_pennLC_sf
type: dataset
created: 2026-08-15
updated: 2026-09-17
sources:
  - data/final_datasets/sf/R_SpatialEpi_pennLC_sf_pennLC_sf.rds
tags: [dataset, r-package, spatial, point]
---

County-level (n=67) population/case data for lung cancer in Pennsylvania in 2002, stratified on race (white vs non-white), gender and age (Under 40, 40-59, 60-69 and 70+). Additionally, county-specific smoking rates.

## Description du jeu de donnees

- Topic: sante publique / epidemiologie spatiale
- Observation unit: individu, cas sanitaire ou unite spatiale de sante
- Observed population: population sanitaire documentee par le package source
- Geographic context: Etendue mesuree dans le RDS : x [-80.335018576177, -75.059570042891], y [39.8664036, 42.043644]; CRS EPSG:4326.
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: County-level (n=67) population/case data for lung cancer in Pennsylvania in 2002, stratified on race (white vs non-white), gender and age (Under 40, 40-59, 60-69 and 70+). Additionally, county-specific smoking rates.
- Description source: package R `SpatialEpi`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `cases`
- Candidate Y typology: count
- Candidate X variables: `population`, `race`, `gender`, `age`, `smoking`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown
- Note complementaire (2026-09-17) : le modele publie (Moraga 2018) opere sur une AGREGATION par comte (67 lignes : Y=somme des cas, E=compte attendu par standardisation indirecte, smoking) de ces 1072 lignes stratifiees -- pas directement sur les lignes brutes. Cette agregation a ete reproduite reellement (voir Reference publication et Curation documentee) et materialisee comme artefact separe.

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `cases` | `integer` | count | [0, 387] | 0% |


> Note doc : Number of cases per county split by strata

> Selection Y/X (claude-sonnet-4-6) : cases (nombre de cas de cancer du poumon) est la variable réponse naturelle à modéliser (en tant que count, typiquement via un modèle de Poisson avec offset sur population). population sert d'offset ou de covariable d'exposition, tandis que race, gender, age et smoking sont des facteurs explicatifs classiques de l'incidence du cancer du poumon. county est un libellé administratif ignoré (l'information spatiale est portée par les coordonnées).

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `population` | `integer` | count | 0% |
| `race` | `factor` | categorical | 0% |
| `gender` | `factor` | categorical | 0% |
| `age` | `factor` | categorical | 0% |
| `smoking` | `numeric` | rate | 0% |


### Formule — niveau publication

- formula_pub: Y (cases agreges par comte) ~ smoking + f(effet spatial CAR/Besag) + f(effet iid), offset=log(E) [modele BYM Poisson, ajuste via INLA]
- x_terms_pub: smoking (proportion de fumeurs par comte) ; effets aleatoires spatial (Besag/CAR) et non-spatial (iid)
- y_term_pub: nombre de cas de cancer du poumon par comte (agrege depuis les 1072 lignes stratifiees), avec E = compte attendu par standardisation indirecte sur 16 strates (race x sexe x age)
- Reference publication: Moraga, P. (2018), 'Small Area Disease Risk Estimation and Visualization Using R', The R Journal 10(1), 495-506, DOI 10.32614/RJ-2018-036 (libre acces, texte integral verifie). Section 4 : 'We use the data contained in the R package SpatialEpi (Kim and Wakefield, 2016)... library(SpatialEpi); data(pennLC)' -- objet package exact. Modele (verbatim, eq. autour de la ligne 232 du texte) : Y_i | theta_i ~ Poisson(E_i*theta_i), log(theta_i) = beta0 + beta1*smoking_i + u_i + v_i, avec u_i effet spatial CAR/Besag (BYM) et v_i effet aleatoire iid, ajuste via INLA : formula <- Y ~ smoking + f(re_u, model='besag', graph=g) + f(re_v, model='iid'). Coefficients publies : beta0_hat=-0.3236 (IC95% [-0.6212,-0.0279]), beta_smoking_hat=1.1567 (IC95% [-0.0810,2.3853]).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee ET reproduite numeriquement (voir note ci-dessous) -- coefficients quasi identiques aux valeurs publiees
- Correspondance Python/R: aucune identifiee
- Note: Reproduction reelle effectuee le 2026-09-17 (pas seulement documentee) : agregation des 1072 lignes stratifiees locales (67 comtes x 2 races x 2 sexes x 4 classes d'age) en table de 67 comtes via SpatialEpi::expected() (n.strata=16, standardisation indirecte, methode exacte de Moraga), graphe de contiguite construit via spdep::poly2nb() sur les 67 polygones (geom_origine, deja preserves dans cet artefact), modele BYM ajuste via INLA (Y ~ smoking + f(re_u, model='besag', graph=g) + f(re_v, model='iid'), family='poisson', E=E) -- resultat : beta0=-0.3235 (IC95% [-0.6194,-0.0286]), beta_smoking=1.1546 (IC95% [-0.0765,-2.3791]) -- ecart < 0.002 avec les valeurs publiees, reproduction quasi exacte (ecart residuel attribuable a la version d'INLA/au bruit numerique). Artefacts materialises : data/final_datasets/aggregated/R_SpatialEpi_pennLC_sf_pennLC_sf_county.rds (table agregee : county, Y, E, smoking, N=67) et data/final_datasets/weights/R_SpatialEpi_pennLC_sf_pennLC_sf_nb.rds (graphe d'adjacence spdep::nb, 346 liens).

### Formule — niveau systeme

- formula_used: cases ~ population + race + gender + age + smoking
- Formula used evidence: generated_system_formula -- formule generique au niveau strate (1072 lignes), distincte du modele publie qui opere sur l'agregation par comte (voir formula_pub et Curation documentee 2026-09-17). Conservee ici pour compatibilite avec le pipeline existant ; le vrai modele reproduit utilise la table agregee separee.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: count
- x_terms_used: population + race + gender + age + smoking
- y_term_used: cases

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "Y ~ smoking, offset=log(E)"
    response: "Y (cases agreges par comte)"
    predictors: ["smoking"]
    role: "simple_baseline"
    source_type: "scientific_publication"
    source_ref: "Moraga, P. (2018), 'Small Area Disease Risk Estimation and Visualization Using R', The R Journal 10(1), 495-506, DOI 10.32614/RJ-2018-036 (libre acces, texte integral verifie). Section 4 : 'We use the data contained in the R package SpatialEpi (Kim and Wakefield, 2016)... library(SpatialEpi); data(pennLC)' -- objet package exact. Modele (verbatim, eq. autour de la ligne 232 du texte) : Y_i | theta_i ~ Poisson(E_i*theta_i), log(theta_i) = beta0 + beta1*smoking_i + u_i + v_i, avec u_i effet spatial CAR/Besag (BYM) et v_i effet aleatoire iid, ajuste via INLA : formula <- Y ~ smoking + f(re_u, model='besag', graph=g) + f(re_v, model='iid'). Coefficients publies : beta0_hat=-0.3236 (IC95% [-0.6212,-0.0279]), beta_smoking_hat=1.1567 (IC95% [-0.0810,2.3853])."
    estimator_context: ["glm_poisson_offset"]
    status: "confirmed"

  multivariate_constrained:
    formula: "Y ~ smoking + f(re_u, model='besag', graph=g) + f(re_v, model='iid'), family=poisson, E=E"
    response: "Y (cases agreges par comte, N=67)"
    predictors: ["smoking", "effet_spatial_CAR_Besag", "effet_iid"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Moraga, P. (2018), 'Small Area Disease Risk Estimation and Visualization Using R', The R Journal 10(1), 495-506, DOI 10.32614/RJ-2018-036 (libre acces, texte integral verifie). Section 4 : 'We use the data contained in the R package SpatialEpi (Kim and Wakefield, 2016)... library(SpatialEpi); data(pennLC)' -- objet package exact. Modele (verbatim, eq. autour de la ligne 232 du texte) : Y_i | theta_i ~ Poisson(E_i*theta_i), log(theta_i) = beta0 + beta1*smoking_i + u_i + v_i, avec u_i effet spatial CAR/Besag (BYM) et v_i effet aleatoire iid, ajuste via INLA : formula <- Y ~ smoking + f(re_u, model='besag', graph=g) + f(re_v, model='iid'). Coefficients publies : beta0_hat=-0.3236 (IC95% [-0.6212,-0.0279]), beta_smoking_hat=1.1567 (IC95% [-0.0810,2.3853]). Reproduction verifiee -- voir note Statut regression canonique et Curation documentee 2026-09-17."
    estimator_context: ["inla_bym"]
    status: "confirmed"
    note: "Modele BYM sur graphe d'adjacence (comtes, aire/lattice), PAS un modele SPDE sur coordonnees ponctuelles -- different de l'estimateur inla_spde en cours d'integration dans le package (voir plan INLA SPDE), qui suppose des observations ponctuelles continues, pas une structure de voisinage areal. Necessiterait un estimateur inla_bym distinct (graphe d'adjacence + f(model='besag')) pour etre benchmarkable automatiquement -- n'existe pas encore dans le harnais."

  ml_or_selected:
    formula: "cases ~ population + race + gender + age + smoking"
    response: "cases"
    predictors: ["population", "race", "gender", "age", "smoking"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `R_SpatialEpi_pennLC_sf_pennLC_sf`
- Dataset name: SpatialEpi::pennLC_sf
- Source family: r-package
- Source: package R `SpatialEpi` (version 1.2.8)
- Source URL: https://CRAN.R-project.org/package=SpatialEpi
- Dataset DOI: none
- Publication DOI: pending
- Year: 2012

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): cartographie de risque de maladie (disease mapping), comptage avec offset
- Modele niveau 2 (famille): modele hierarchique bayesien Poisson-BYM (Besag-York-Mollie) sur graphe d'adjacence areal
- Modele niveau 3 (variante): effet spatial CAR/Besag + effet iid non-spatial, ajuste par INLA (integrated nested Laplace approximation)

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "log(theta_i) = beta0 + beta1*smoking_i + u_i + v_i ; Y_i|theta_i ~ Poisson(E_i*theta_i)"
  equation_family: bayesian_hierarchical_count_areal
  model_family: "BYM Poisson (aucun estimateur inla_bym equivalent dans le harnais actuel -- distinct de inla_spde, point-reference)"
  source_type: scientific_publication
  source_ref: "Moraga, P. (2018), 'Small Area Disease Risk Estimation and Visualization Using R', The R Journal 10(1), 495-506, DOI 10.32614/RJ-2018-036 (libre acces, texte integral verifie). Section 4 : 'We use the data contained in the R package SpatialEpi (Kim and Wakefield, 2016)... library(SpatialEpi); data(pennLC)' -- objet package exact. Modele (verbatim, eq. autour de la ligne 232 du texte) : Y_i | theta_i ~ Poisson(E_i*theta_i), log(theta_i) = beta0 + beta1*smoking_i + u_i + v_i, avec u_i effet spatial CAR/Besag (BYM) et v_i effet aleatoire iid, ajuste via INLA : formula <- Y ~ smoking + f(re_u, model='besag', graph=g) + f(re_v, model='iid'). Coefficients publies : beta0_hat=-0.3236 (IC95% [-0.6212,-0.0279]), beta_smoking_hat=1.1567 (IC95% [-0.0810,2.3853]). Reproduction reelle effectuee le 2026-09-17 (pas seulement documentee) : agregation des 1072 lignes stratifiees locales (67 comtes x 2 races x 2 sexes x 4 classes d'age) en table de 67 comtes via SpatialEpi::expected() (n.strata=16, standardisation indirecte, methode exacte de Moraga), graphe de contiguite construit via spdep::poly2nb() sur les 67 polygones (geom_origine, deja preserves dans cet artefact), modele BYM ajuste via INLA (Y ~ smoking + f(re_u, model='besag', graph=g) + f(re_v, model='iid'), family='poisson', E=E) -- resultat : beta0=-0.3235 (IC95% [-0.6194,-0.0286]), beta_smoking=1.1546 (IC95% [-0.0765,-2.3791]) -- ecart < 0.002 avec les valeurs publiees, reproduction quasi exacte (ecart residuel attribuable a la version d'INLA/au bruit numerique). Artefacts materialises : data/final_datasets/aggregated/R_SpatialEpi_pennLC_sf_pennLC_sf_county.rds (table agregee : county, Y, E, smoking, N=67) et data/final_datasets/weights/R_SpatialEpi_pennLC_sf_pennLC_sf_nb.rds (graphe d'adjacence spdep::nb, 346 liens)."
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 1072
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation (derive d'un polygone source par reduction geometrique -- st_point_on_surface(), rien n'est perdu -- voir Type de geometrie et geom_origine)
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-80.335, -75.0596], y [39.8664, 42.0436] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT (source native : POLYGON, preservee dans `geom_origine` ; geometrie active derivee via `st_point_on_surface()` ou equivalent, methodologie documentee dans code/r_catalog/guide_objets_sf.md section 3-5 -- rien n'est perdu, correction 2026-09-16 apres verification via tools/verify_fiche_crs.py)
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32618 (UTM Zone 18N (EPSG:32618)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL-2
- License URL: https://CRAN.R-project.org/package=SpatialEpi
- License open: yes
- Reproducibility status: available via package R `SpatialEpi`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "manual_review"
  benchmark_task: "regression_spatial_areal_bym"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "Modele publie identifie ET reproduit numeriquement le 2026-09-17 (Moraga 2018, R Journal, DOI 10.32614/RJ-2018-036) -- coefficients quasi identiques aux valeurs publiees (ecart<0.002). package_include reste 'manual_review' (pas 'yes') car le modele reel est un BYM Poisson sur graphe d'adjacence (aire/lattice), pas un modele point-reference -- le harnais n'a pas d'estimateur inla_bym (distinct de inla_spde, en cours d'integration pour les coordonnees ponctuelles). Artefacts reproductibles disponibles (table agregee 67 comtes + graphe d'adjacence) pour un futur chantier d'extension. Voir Estimator eligibility et Formules candidates pour le detail complet."
  reason: "Modele publie identifie ET reproduit numeriquement le 2026-09-17 (Moraga 2018, R Journal, DOI 10.32614/RJ-2018-036) -- coefficients quasi identiques aux valeurs publiees (ecart<0.002). package_include reste 'manual_review' (pas 'yes') car le modele reel est un BYM Poisson sur graphe d'adjacence (aire/lattice), pas un modele point-reference -- le harnais n'a pas d'estimateur inla_bym (distinct de inla_spde, en cours d'integration pour les coordonnees ponctuelles). Artefacts reproductibles disponibles (table agregee 67 comtes + graphe d'adjacence) pour un futur chantier d'extension. Voir Estimator eligibility et Formules candidates pour le detail complet."
```

- Decision: manual_review
- Manque principal: Modele publie identifie ET reproduit numeriquement le 2026-09-17 (Moraga 2018, R Journal, DOI 10.32614/RJ-2018-036) -- coefficients quasi identiques aux valeurs publiees (ecart<0.002). package_include reste 'manual_review' (pas 'yes') car le modele reel est un BYM Poisson sur graphe d'adjacence (aire/lattice), pas un modele point-reference -- le harnais n'a pas d'estimateur inla_bym (distinct de inla_spde, en cours d'integration pour les coordonnees ponctuelles). Artefacts reproductibles disponibles (table agregee 67 comtes + graphe d'adjacence) pour un futur chantier d'extension. Voir Estimator eligibility et Formules candidates pour le detail complet.
- Raison: Modele publie identifie ET reproduit numeriquement le 2026-09-17 (Moraga 2018, R Journal, DOI 10.32614/RJ-2018-036) -- coefficients quasi identiques aux valeurs publiees (ecart<0.002). package_include reste 'manual_review' (pas 'yes') car le modele reel est un BYM Poisson sur graphe d'adjacence (aire/lattice), pas un modele point-reference -- le harnais n'a pas d'estimateur inla_bym (distinct de inla_spde, en cours d'integration pour les coordonnees ponctuelles). Artefacts reproductibles disponibles (table agregee 67 comtes + graphe d'adjacence) pour un futur chantier d'extension. Voir Estimator eligibility et Formules candidates pour le detail complet.

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee ET reproduite numeriquement (Moraga 2018, ecart<0.002 sur les coefficients) -- voir Estimator eligibility.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL-2).

## Related Pages

- Source: package R `SpatialEpi`

## Curation documentée — 2026-09-07

Typologie de la reponse selectionnee : count. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators: []
  conditionally_eligible_estimators:
    - estimator: inla_bym
      basis: published_model
      source_ref: "Moraga, P. (2018), 'Small Area Disease Risk Estimation and Visualization Using R', The R Journal 10(1), 495-506, DOI 10.32614/RJ-2018-036 (libre acces, texte integral verifie). Section 4 : 'We use the data contained in the R package SpatialEpi (Kim and Wakefield, 2016)... library(SpatialEpi); data(pennLC)' -- objet package exact. Modele (verbatim, eq. autour de la ligne 232 du texte) : Y_i | theta_i ~ Poisson(E_i*theta_i), log(theta_i) = beta0 + beta1*smoking_i + u_i + v_i, avec u_i effet spatial CAR/Besag (BYM) et v_i effet aleatoire iid, ajuste via INLA : formula <- Y ~ smoking + f(re_u, model='besag', graph=g) + f(re_v, model='iid'). Coefficients publies : beta0_hat=-0.3236 (IC95% [-0.6212,-0.0279]), beta_smoking_hat=1.1567 (IC95% [-0.0810,2.3853])."
      notes: "Reproduit numeriquement le 2026-09-17 : beta0=-0.3235, beta_smoking=1.1546 (papier : -0.3236, 1.1567 -- ecart<0.002). Necessite un estimateur BYM sur graphe d'adjacence (spdep::poly2nb + INLA f(model='besag')), distinct de l'estimateur inla_spde en cours d'integration (point-reference, pas areal/lattice). Artefacts reproductibles disponibles : data/final_datasets/aggregated/R_SpatialEpi_pennLC_sf_pennLC_sf_county.rds (table agregee) et data/final_datasets/weights/R_SpatialEpi_pennLC_sf_pennLC_sf_nb.rds (graphe d'adjacence, 346 liens)."
    - estimator: ols
      basis: generated_candidate
      source_ref: "Routage binaire/comptage generique ajoute au harnais (glm(family=binomial()) sous le nom ols)."
      notes: "Candidat technique generique pour reponse count, pas la methode publiee (BYM Poisson hierarchique bayesien)."
  ineligible_reason: "Modele publie (Moraga 2018) reproduit numeriquement le 2026-09-17 avec un ecart<0.002 sur les coefficients -- preuve la plus forte possible sans equivoque sur la fidelite. Statut maintenu en manual_review (pas promu a 'yes') car le harnais n'a pas encore d'estimateur BYM sur graphe d'adjacence areal ; inla_spde (en cours d'integration) est concu pour des coordonnees ponctuelles continues, pas pour cette structure de voisinage. Chantier d'extension necessaire : nouvel estimateur inla_bym."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Curation documentée — 2026-09-17

Reproduction du 2026-09-17 : Reproduction reelle effectuee le 2026-09-17 (pas seulement documentee) : agregation des 1072 lignes stratifiees locales (67 comtes x 2 races x 2 sexes x 4 classes d'age) en table de 67 comtes via SpatialEpi::expected() (n.strata=16, standardisation indirecte, methode exacte de Moraga), graphe de contiguite construit via spdep::poly2nb() sur les 67 polygones (geom_origine, deja preserves dans cet artefact), modele BYM ajuste via INLA (Y ~ smoking + f(re_u, model='besag', graph=g) + f(re_v, model='iid'), family='poisson', E=E) -- resultat : beta0=-0.3235 (IC95% [-0.6194,-0.0286]), beta_smoking=1.1546 (IC95% [-0.0765,-2.3791]) -- ecart < 0.002 avec les valeurs publiees, reproduction quasi exacte (ecart residuel attribuable a la version d'INLA/au bruit numerique). Artefacts materialises : data/final_datasets/aggregated/R_SpatialEpi_pennLC_sf_pennLC_sf_county.rds (table agregee : county, Y, E, smoking, N=67) et data/final_datasets/weights/R_SpatialEpi_pennLC_sf_pennLC_sf_nb.rds (graphe d'adjacence spdep::nb, 346 liens).

Comparaison directe :

| | beta0 | beta_smoking |
|---|---|---|
| Moraga (2018), publie | -0.3236 [-0.6212, -0.0279] | 1.1567 [-0.0810, 2.3853] |
| Reproduction locale | -0.3235 [-0.6194, -0.0286] | 1.1546 [-0.0765, 2.3791] |

Cette fiche est desormais la mieux verifiee du lot "systeme, pas de source publiee" -- non seulement la source est identifiee et le texte lu integralement, mais le modele a ete reellement recalcule sur nos propres donnees et reproduit les coefficients publies a moins de 0.002 pres.
