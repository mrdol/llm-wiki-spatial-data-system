---
title: paper_harbour_porpoise_response
type: dataset
created: 2026-08-15
updated: 2026-09-09
sources:
  - data/final_datasets/sf/paper_harbour_porpoise_response.rds
  - DataCite_2019_HarbourPorpoiseResponsesTo_10_1098_rsos_190
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Harbour porpoise responses to pile-driving diminish over time" (DOI 10.1098/rsos.190335).

## Description du jeu de donnees

- Topic: réponses comportementales des marsouins au battage de pieux
- Observation unit: site/détecteur CPOD × événement de battage
- Observed population: observations acoustiques au parc éolien Beatrice ; table source conservée et sous-échantillons propres aux modèles
- Geographic context: etendue sf: x [-3.955967, -2.6177], y [57.8164, 58.33725]
- Temporal context: observations répétées, fenêtres après battage de 12 h et 24 h
- Source description: Harbour porpoise responses to pile-driving diminish over time
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1098/rsos.190335
- Dataset DOI: 10.5061/dryad.5qg30sd
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.5qg30sd
- Local raw dir: `data/raw/papers/DataCite_2019_HarbourPorpoiseResponsesTo_10_1098_rsos_190/`
- Local sf output: `data/final_datasets/sf/paper_harbour_porpoise_response.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `resp24_50`, `resp12_50` ; `prop24` et `prop12` servent à construire les réponses binaires
- Candidate Y typology: binary
- Candidate X variables in local artifact: `distance`, `piling_order`, `vessels24_1km`, `Aud_SS_SEL`, `ADD`, `vessels12_500m` pour les trois modèles du tableau 1
- Candidate X count in local artifact: 6 (union de trois modèles distincts)
- Candidate X typology: continuous, categorical
- Published X count: 3 pour (a), 3 pour (b), 4 pour (c), avant développement de l'interaction
- Presence of imputed X: unknown
- Coordinates (x, y - excluded from X candidates): `Longitude`, `Latitude`, `X`, `Y`
- Identifier columns (excluded from X candidates): `dep_no`, `turbine`, `location`, `pod`, `POD_number`, `Location_ID` ; location et pod définissent l'effet aléatoire
- Variables inspected: yes (source CSV, RDS et code R des auteurs)

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `resp24_50` | `integer` | binary | {0, 1} | 2.1% |
| `resp12_50` | `integer` | binary | {0, 1} | 3.5% |

> Selection Y/X (paper-loader / curated evidence) : Les auteurs définissent une réponse par une diminution de plus de 50 % des heures de détection (DPH) après battage, sur 24 h (`resp24_50`, modèles a/b) ou 12 h (`resp12_50`, modèle c), reprises du CSV sans reconstruire le seuil. `dph24`, `base24`, `dph12`, `base12`, `prop24`, `prop12` participent au calcul de Y et ne sont pas des prédicteurs indépendants. Les covariables X retenues varient par modèle du tableau 1 : `distance`, `piling_order`, `vessels24_1km` pour (a) ; `Aud_SS_SEL`, `piling_order`, `vessels24_1km` pour (b) ; `distance`, `piling_order`, `ADD`, `vessels12_500m` pour (c). Les coordonnées (`Longitude`, `Latitude`, `X`, `Y`), identifiants (`dep_no`, `turbine`, `location`, `pod`, `POD_number`, `Location_ID`) sont exclus de X ; `location`/`pod` définissent l'effet aléatoire `loc_pod`. Statut benchmark actuel : not_ready_estimator_support ; package_include: no (GLMM probit hors harnais actuel).

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `distance` | `numeric` | continuous (log) | 0% |
| `piling_order` | `integer` | continuous (centré-réduit : zorder) | 0% |
| `vessels24_1km` | `integer` | count (centré-réduit : zvessels_1km) | 0% |
| `vessels12_500m` | `integer` | count (centré-réduit : zvessels_500) | 0% |
| `Aud_SS_SEL` | `numeric` | continuous (centré-réduit : zASS_SEL) | 0% |
| `ADD` | `character` | binary {N, Y} | 0% |

> Note : `ADD` est une covariable binaire du modèle (c), pas un identifiant. `Aud_SS_SEL` correspond à l'exposition sonore pondérée par l'audiogramme (ASS_SEL dans le tableau). Les autres pondérations acoustiques (`Unweighted_SS_SEL`, `NOAA_SS_SEL`, `Southall_SS_SEL`) sont conservées dans les données mais ne sont pas ajoutées simultanément à la distance dans une formule unique.

### Formule - niveau publication

- formula_pub: resp24_50 ~ log(distance) * piling_order + vessels24_1km [modèle (a), m8_24 ; voir tableau ci-dessous pour (b) et (c)]
- x_terms_pub: distance, ordre de battage, activité des navires, exposition acoustique pondérée, ADD selon le modèle
- y_term_pub: resp24_50 pour (a)/(b), resp12_50 pour (c)
- Reference publication: Graham et al. (2019), Royal Society Open Science 6:190335, DOI 10.1098/rsos.190335, tableau 1 page 7 et code R Dryad.

| Modèle du tableau 1 | Formule du code auteur, avec effet aléatoire | N analysé | AIC reproduit |
|---|---|---|---|
| (a), m8_24 | `resp24_50 ~ log(distance) * zorder + zvessels_1km + (1 \| loc_pod)` | 654 | 619.3854 |
| (b), m14nz_24 | `resp24_50 ~ zASS_SEL * zorder + zvessels_1km + (1 \| loc_pod)` | 654 | 620.9744 |
| (c), m7_12 | `resp12_50 ~ log(distance) * zorder + ADD + zvessels_500 + (1 \| loc_pod)` | 623 | 653.3871 |

Les trois ajustements ont été réexécutés avec `lme4::glmer(..., family=binomial(link="probit"))` ; leurs AIC correspondent aux valeurs arrondies 619.4, 621.0 et 653.4 du tableau. Le modèle acoustique non pondéré `m7nz_24` n'est pas la troisième ligne de ce tableau.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: tableau PDF contrôlé visuellement et modèles reproduits avec le code auteur
- Methode d estimation: GLMM binomial, lien probit, intercept aléatoire pour location × pod
- Note: Un GLMM probit avec effet aléatoire n'est pas un SAR-probit ou SEM-probit.

### Formule - niveau systeme

- formula_used: resp24_50 ~ log(distance) * scale(piling_order) + scale(vessels24_1km) + (1 | loc_pod)
- Formula used evidence: paper_extracted
- Response link function: probit
- Selected Y typology: binary
- Selected Y evidence: modèle (a) du tableau 1 ; les modèles (b) et (c) restent documentés séparément
- x_terms_used: distance, piling_order, vessels24_1km
- y_term_used: resp24_50
- Recommended validation: respecter les groupes location × pod et les événements de battage ; pas de découpage aléatoire naïf des lignes
- Note: Formule initialement destinée à lme4 après préparation auteur. Depuis le 2026-09-09, `gam_spatial` traduit automatiquement `(1 | loc_pod)` en lisseur d'effet aléatoire mgcv `s(loc_pod, bs="re")` (equivalent REML a un intercept aleatoire, verifie empiriquement contre lme4::glmer sur donnees synthetiques) et applique le lien probit declare ci-dessus. `zorder`/`zvessels_1km` (noms du code source, section suivante) sont remplaces par `scale(piling_order)`/`scale(vessels24_1km)` : memes variables centrees-reduites, mais calculables directement depuis les colonnes reellement presentes dans le RDS (`zorder` et `zvessels_1km` n'y existent pas sous ce nom). Fit reussi sur les donnees reelles (707/722 lignes completes) -- voir Estimator eligibility. Ce n'est PAS une reproduction exacte de glmer() : gam_spatial ajoute systematiquement un lisseur spatial global s(longitude, latitude), absent du modele publie.

Préparation publiée : exclure `turbine == "D11"`, conserver `base24 > 0` et `dph24` non manquant pour (a)/(b), ou `base12 > 0` et `dph12` non manquant pour (c). Construire `loc_pod = paste(location, pod, sep="_")`. Centrer-réduire l'ordre, les navires et l'exposition sur le sous-échantillon du modèle : `zorder`, `zvessels_1km`, `zvessels_500`, `zASS_SEL` sont les noms du code source.

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
    formula: "resp24_50 ~ log(distance) * scale(piling_order) + scale(vessels24_1km) + (1 | loc_pod)"
    response: "resp24_50"
    predictors: ["distance", "piling_order", "vessels24_1km"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Graham et al. (2019), Royal Society Open Science, DOI 10.1098/rsos.190335 -- modele (a)/m8_24, tableau 1 page 7 et code R Dryad (AIC reproduit=619.3854). Modeles (b) m14nz_24 et (c) m7_12 documentes separement, voir tableau Bloc 1."
    estimator_context: ["gam_spatial"]
    status: "confirmed_benchmark_use_approximation"

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

Les trois spécifications effectivement publiées sont données dans le tableau du Bloc 1. Aucune régression continue sur prop24 ni formule réunissant toutes les expositions n'est retenue.

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_harbour_porpoise_response`
- Dataset name: Data from: Harbour porpoise responses to pile-driving diminish over time
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Harbour porpoise responses to pile-driving diminish over time
- Paper DOI: 10.1098/rsos.190335
- Dataset DOI: 10.5061/dryad.5qg30sd
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.5qg30sd
- Year: 2019

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): réponse comportementale binaire à 24 h ou 12 h
- Modele niveau 2 (famille): GLMM binomial à lien probit
- Modele niveau 3 (variante): modèles (a), (b), (c) du tableau 1, effet aléatoire location × pod

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Trois spécifications du tableau 1 reproduites dans le Bloc 1, avec effet aléatoire."
  model_family: "binomial probit GLMM"
  source_type: scientific_publication
  source_ref: "10.1098/rsos.190335, tableau 1 page 7 et code R Dryad"
  confidence: high
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_binary"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "gam_spatial traduit (1 | loc_pod) en s(loc_pod, bs='re') et applique le lien probit declare -- fit+predict verifies de bout en bout sur les 707/722 lignes completes (session du 2026-09-09). Approximation REML d'un GLMM, pas une reproduction exacte de glmer() (gam_spatial ajoute un lisseur spatial s(longitude, latitude) absent du modele publie)."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: gam_spatial traduit (1 | loc_pod) en s(loc_pod, bs="re") et applique le lien probit declare -- fit+predict verifies de bout en bout sur les 707/722 lignes completes (session du 2026-09-09).

## Estimator eligibility

```yaml
estimator_eligibility:
  eligible_estimators:
    - estimator: gam_spatial
      basis: benchmark_use
      source_ref: "Session du 2026-09-09 -- add_spatial_smooth_to_formula() (R/13-benchmark-spatial.R) traduit (1 | loc_pod) en s(loc_pod, bs='re'), lien probit applique via glm_link. Fit+predict verifies de bout en bout sur les donnees reelles (707/722 lignes completes)."
      notes: "Approximation REML d'un GLMM binomial probit, pas une reproduction exacte de glmer() : gam_spatial ajoute systematiquement un lisseur spatial global s(longitude, latitude), absent du modele publie (a)/m8_24. Coefficients non directement comparables a ceux du tableau 1."
  conditionally_eligible_estimators: []
  ineligible_reason: "SAR-probit et SEM-probit (ProbitSpatial) modelisent la dependance spatiale via une matrice de voisinage, pas via un intercept aleatoire groupe echangeable -- mecanisme different, pas une reproduction de ce modele."
  rule: "Conserver la méthode du papier ; une famille voisine ne constitue pas une reproduction."
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: observations répétées par site/détecteur et événement de battage
- N observations: 722
- k variables: 31
- T periods: not_applicable
- Variable temporelle: événements de battage identifiés par turbine et piling_order ; fenêtres de 12 h et 24 h
- N/T profile: mesures répétées ; pas une coupe indépendante ni un panel annuel équilibré
- Note: 33 colonnes dont 2 géométries ; k=31 attributs hors géométrie, distinct des 3/3/4 prédicteurs des modèles. L'ancien RDS de 700 lignes excluait les observations invalides à 24 h et perdait 7 lignes valides pour le modèle à 12 h. La table source de 722 lignes est maintenant préservée ; les modèles publiés utilisent respectivement 654, 654 et 623 lignes après leurs propres filtres. Colonne `loc_pod` ajoutée le 2026-09-09 (`paste(location, pod, sep="_")`, 99 groupes distincts) : `formula_used` la referençait deja mais le RDS ne la materialisait pas -- corrige pour que le harnais puisse effectivement charger le dataset (ancien RDS sans loc_pod sauvegarde dans data/interim/dataset_review_2026-09-09/).

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: fenêtres de réponse de 12 h et 24 h après des événements de battage
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-3.955967, -2.6177], y [57.8164, 58.33725]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32630 (UTM Zone 30N (EPSG:32630)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.5qg30sd (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`harbour_porpoise_response` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `harbour_porpoise_response` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Variables: réponses binaires du CSV conservées ; ADD remis parmi les covariables du modèle (c).
- Formula: trois formules du tableau 1 vérifiées et ajustées avec lme4 ; AIC reproduits.
- Geometry: coordonnées jointes par dep_no ; mesures répétées au même site conservées.
- Missing values: valeurs manquantes ou non finies possibles dans les proportions ; exclusions distinctes selon la fenêtre de réponse.
- Duplicates: lignes répétées géographiquement justifiées par les mesures successives ; pas de dédoublonnage spatial.
- Reproducibility: loader corrigé ; source CSV et code auteur conservés ; sauvegarde du RDS antérieur dans data/interim/dataset_review_2026-09-09/.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Harbour porpoise responses to pile-driving diminish over time
