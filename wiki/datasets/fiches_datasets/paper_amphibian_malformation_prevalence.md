---
title: paper_amphibian_malformation_prevalence
type: dataset
created: 2026-09-14
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_amphibian_malformation_prevalence.rds
  - DataCite_2010_MultipleStressorsAndThe_10_1890_09_0879_
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Multiple stressors and the cause of amphibian abnormalities" (DOI 10.1890/09-0879.1).

## Description du jeu de donnees

- Topic: Donnees de paper-derived : paper_amphibian_malformation_prevalence
- Observation unit: observation spatiale du dataset "Data from: Multiple stressors and the cause of amphibian abnormalities"
- Observed population: Régression logistique pour prédire anomalies chez grenouilles en Alaska ; 21 zones humides avec coordonnées ; variables contaminants, prédateurs, parasites ; comparaison de modèles AIC ; 33 citations
- Geographic context: etendue sf: x [-151.37911, -150.00838], y [60.20227, 60.78709]
- Temporal context: none (cross-sectional)
- Source description: Multiple stressors and the cause of amphibian abnormalities
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1890/09-0879.1
- Dataset DOI: 10.5061/dryad.sq72d
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.sq72d
- Local raw dir: `data/raw/papers/DataCite_2010_MultipleStressorsAndThe_10_1890_09_0879_/`
- Local sf output: `data/final_datasets/sf/paper_amphibian_malformation_prevalence.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `prevalence_abnormal`, `prevalence_skel_ab`, `prevalence_eye_ab`, `prevalence_surf_ab`, `prevalence_bleeding_inj`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `n_frogs`, `ROADDISTANCE`, `RoadType`
- Candidate X count in local artifact: 3
- Candidate X typology: unknown, categorical
- Published X variables from paper: inorganic contaminants (Metal PCA2, composante d'ACP sur les metaux), larval dragonfly abundance (predateur), organic contaminants (organic PCA2, composante d'ACP sur les contaminants organiques), metamorph size (covariable obligatoire, tous modeles squelettiques), developmental stage (covariable obligatoire, tous modeles squelettiques)
- Published X count: 5
- Coordinates (x, y - excluded from X candidates): `LONGITUDE`, `LATITUDE`
- Identifier columns (excluded from X candidates): `SITE`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `prevalence_abnormal` | `numeric` | continuous | [1.8182, 31.0345] | 0% |
| `prevalence_skel_ab` | `numeric` | continuous | [0, 15.5172] | 0% |
| `prevalence_eye_ab` | `numeric` | continuous | [0, 8.6957] | 0% |
| `prevalence_surf_ab` | `numeric` | continuous | [0, 23.6] | 0% |
| `prevalence_bleeding_inj` | `numeric` | continuous | [0, 24] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `amphibian_malformation_prevalence`, la ou les reponses `prevalence_abnormal`, `prevalence_skel_ab`, `prevalence_eye_ab`, `prevalence_surf_ab`, `prevalence_bleeding_inj` viennent du loader papier et/ou des preuves de l article `Multiple stressors and the cause of amphibian abnormalities`. Les covariables X retenues sont `ROADDISTANCE`, `RoadType` ; 1 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`LONGITUDE`, `LATITUDE`), identifiants (`SITE`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `n_frogs` | `integer` | unknown | 0% |
| `ROADDISTANCE` | `integer` | unknown | 40.7% |
| `RoadType` | `character` | categorical | 40.7% |

### Formule - niveau publication

- formula_pub: prevalence_skel_ab ~ inorganic_contaminants_metal_PCA2 + dragonfly_abundance + organic_contaminants_PCA2 + metamorph_size + developmental_stage [logistique, selection AIC]
- x_terms_pub: inorganic contaminants (Metal PCA2, composante d'ACP sur les metaux), larval dragonfly abundance (predateur), organic contaminants (organic PCA2, composante d'ACP sur les contaminants organiques), metamorph size (covariable obligatoire, tous modeles squelettiques), developmental stage (covariable obligatoire, tous modeles squelettiques)
- y_term_pub: prevalence_skel_ab (prevalence d'anomalies squelettiques par site, agregee localement depuis 9011 individus 2000-2012, seuil n>=50/site repris du Table 1 -- CORRECTION 2026-09-10 : remplace prevalence_abnormal (toutes anomalies confondues), qui ne correspond a AUCUN modele publie -- le papier analyse separement squelettique (72% des cas, formula_pub ci-dessus) et oculaire (28%, modele different), jamais une categorie combinee).
- Reference publication: Reeves et al. (2010), Ecological Monographs 80(3):423-440, DOI 10.1890/09-0879.1 ; verifie le 2026-08-13 sur le texte integral (corpus/papers/raw_pdf/Reeves2010Multiple.pdf, remplace ce jour apres correction d'un PDF errone). Le Table 1 de l'article publie une prevalence de malformations par site (2004-2006, seuil >=50 metamorphes) et documente aussi la distance a la route et le type de route par site (colonnes 'Distance to road (km)'/'Road type', memes champs que RoadsInfo.csv). Les autres X du modele logistique publie (dragonflies, contaminants organiques/inorganiques, UVB, temperature) ne sont PAS dans le depot Dryad 10.5061/dryad.sq72d telecharge (celui-ci contient les donnees individuelles FrogAbnormalities.csv, les coordonnees SiteLocations.csv et RoadsInfo.csv, pas les mesures de contaminants/predateurs/UVB par site). prevalence_abnormal/prevalence_skel_ab/prevalence_eye_ab sont agreges depuis 9011 individus (2000-2012, fenetre plus large que 2004-2006 dans le papier) en reprenant le seuil de fiabilite n>=50 du Table 1. Le texte de l'introduction du papier motive explicitement ROADDISTANCE/RoadType comme covariable pertinente ('abnormality frequency was higher... at road-accessible sites', Reeves et al. 2008 cite dans l'intro). CORRECTION (2026-09-10, verification directe TEI) : (a) formula_pub precisait seulement 3 des 5 termes du 'best model step 3' publie (taille et stade de developpement manquaient, alors qu'ils sont des covariables obligatoires dans TOUS les modeles squelettiques du papier) ; (b) Y utilisait a tort prevalence_abnormal (agregat toutes anomalies), alors que le papier n'analyse jamais cette categorie combinee -- seulement squelettique (72% des cas, best model documente) et oculaire (28%, modele different avec predateurs coleopteres) separement. Y bascule sur prevalence_skel_ab pour correspondre au LHS deja annonce par formula_pub. Year=2010 ajoute (citation Reeves et al. 2010 sans ambiguite).

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d estimation: formule systeme generee (formula_pub confirmee mais non reprise telle quelle -- voir Note ci-dessous)
- Correspondance Python/R: aucune identifiee
- Note: formula_pub est confirmee par le texte integral (Reeves et al. 2010, section 'Statistical assessment of skeletal abnormalities', best model step 3 = Metal PCA2 + larval dragonfly abundance + organic PCA2 + taille + stade), mais aucun des X publies (contaminants, predateurs, UVB, temperature, taille, stade) n'est present dans le depot Dryad brut telecharge -- seuls ROADDISTANCE/RoadType (32/54 sites) sont disponibles localement, motives par l'introduction du papier ('abnormality frequency was higher... at road-accessible sites') mais PAS le modele logistique final retenu par selection AIC.

### Formule - niveau systeme

- formula_used: prevalence_skel_ab ~ ROADDISTANCE + RoadType
- Formula used evidence: reconstructed_from_data
- x_terms_used: ROADDISTANCE, RoadType
- y_term_used: prevalence_skel_ab
- Note: Reeves et al. 2010, 'best model step 3' pour les anomalies squelettiques (72% des cas) : Metal PCA2 + larval dragonfly abundance + organic PCA2, taille et stade de developpement inclus comme covariables obligatoires dans TOUS les modeles squelettiques (justifie par Reeves et al. 2008). Modele SEPARE pour les anomalies oculaires (28% des cas, best model = predatory beetle abundance + developmental stage + size), non retenu ici comme formula_pub principale. X publies (predateurs, contaminants, UVB, temperature, taille, stade) non presents dans le depot Dryad brut. Voir formula_used_divergence_note pour l'ecart avec formula_used.

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
    formula: "prevalence_skel_ab ~ ROADDISTANCE + RoadType"
    response: "prevalence_skel_ab (prevalence d'anomalies squelettiques par site, agregee localement depuis 9011 individus 2000-2012, seuil n>=50/site repris du Table 1 -- CORRECTION 2026-09-10 : remplace prevalence_abnormal (toutes anomalies confondues), qui ne correspond a AUCUN modele publie -- le papier analyse separement squelettique (72% des cas, formula_pub ci-dessus) et oculaire (28%, modele different), jamais une categorie combinee)."
    predictors: ["inorganic contaminants (Metal PCA2, composante d'ACP sur les metaux)", "larval dragonfly abundance (predateur)", "organic contaminants (organic PCA2, composante d'ACP sur les contaminants organiques)", "metamorph size (covariable obligatoire, tous modeles squelettiques)", "developmental stage (covariable obligatoire, tous modeles squelettiques)"]
    role: "benchmark_simplified_specification"
    source_type: "derived_from_scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
    status: "executable_approximation"

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

- Dataset ID: `paper_amphibian_malformation_prevalence`
- Dataset name: Data from: Multiple stressors and the cause of amphibian abnormalities
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Multiple stressors and the cause of amphibian abnormalities
- Paper DOI: 10.1890/09-0879.1
- Dataset DOI: 10.5061/dryad.sq72d
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.sq72d
- Year: 2010

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "prevalence_skel_ab ~ inorganic_contaminants_metal_PCA2 + dragonfly_abundance + organic_contaminants_PCA2 + metamorph_size + developmental_stage [logistique, selection AIC]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Reeves et al. (2010), Ecological Monographs 80(3):423-440, DOI 10.1890/09-0879.1 ; verifie le 2026-08-13 sur le texte integral (corpus/papers/raw_pdf/Reeves2010Multiple.pdf, remplace ce jour apres correction d'un PDF errone). Le Table 1 de l'article publie une prevalence de malformations par site (2004-2006, seuil >=50 metamorphes) et documente aussi la distance a la route et le type de route par site (colonnes 'Distance to road (km)'/'Road type', memes champs que RoadsInfo.csv). Les autres X du modele logistique publie (dragonflies, contaminants organiques/inorganiques, UVB, temperature) ne sont PAS dans le depot Dryad 10.5061/dryad.sq72d telecharge (celui-ci contient les donnees individuelles FrogAbnormalities.csv, les coordonnees SiteLocations.csv et RoadsInfo.csv, pas les mesures de contaminants/predateurs/UVB par site). prevalence_abnormal/prevalence_skel_ab/prevalence_eye_ab sont agreges depuis 9011 individus (2000-2012, fenetre plus large que 2004-2006 dans le papier) en reprenant le seuil de fiabilite n>=50 du Table 1. Le texte de l'introduction du papier motive explicitement ROADDISTANCE/RoadType comme covariable pertinente ('abnormality frequency was higher... at road-accessible sites', Reeves et al. 2008 cite dans l'intro). CORRECTION (2026-09-10, verification directe TEI) : (a) formula_pub precisait seulement 3 des 5 termes du 'best model step 3' publie (taille et stade de developpement manquaient, alors qu'ils sont des covariables obligatoires dans TOUS les modeles squelettiques du papier) ; (b) Y utilisait a tort prevalence_abnormal (agregat toutes anomalies), alors que le papier n'analyse jamais cette categorie combinee -- seulement squelettique (72% des cas, best model documente) et oculaire (28%, modele different avec predateurs coleopteres) separement. Y bascule sur prevalence_skel_ab pour correspondre au LHS deja annonce par formula_pub. Year=2010 ajoute (citation Reeves et al. 2010 sans ambiguite)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "X limite a ROADDISTANCE/RoadType (32/54 sites, NA ailleurs) -- les contaminants/predateurs/UVB du modele publie ne sont pas dans le depot Dryad brut ; version continue derivee du Y binaire individuel, pas une reproduction exacte du Table 1 de l'article (fenetre temporelle plus large, 2000-2012 vs 2004-2006)"
  reason: "Y continu et defendable (prevalence_abnormal/prevalence_skel_ab/prevalence_eye_ab agreges depuis 9011 individus, seuil n>=50/site repris du Table 1 de Reeves et al. 2010), coordonnees reelles (SiteLocations.csv), X partiel mais reel et motive par le papier (ROADDISTANCE/RoadType), artefact local utilisable -- promu le 2026-08-13 apres correction du PDF errone et telechargement complet du depot Dryad (85 fichiers, dont FrogAbnormalities.csv absent du telechargement initial partiel)."
```

- Decision: ready
- Manque principal: X limite a ROADDISTANCE/RoadType (32/54 sites, NA ailleurs) -- les contaminants/predateurs/UVB du modele publie ne sont pas dans le depot Dryad brut ; version continue derivee du Y binaire individuel, pas une reproduction exacte du Table 1 de l'article (fenetre temporelle plus large, 2000-2012 vs 2004-2006)
- Raison: Y continu et defendable (prevalence_abnormal/prevalence_skel_ab/prevalence_eye_ab agreges depuis 9011 individus, seuil n>=50/site repris du Table 1 de Reeves et al. 2010), coordonnees reelles (SiteLocations.csv), X partiel mais reel et motive par le papier (ROADDISTANCE/RoadType), artefact local utilisable -- promu le 2026-08-13 apres correction du PDF errone et telechargement complet du depot Dryad (85 fichiers, dont FrogAbnormalities.csv absent du telechargement initial partiel).

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready"
  eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
  conditionally_eligible_estimators: []
  ineligible_reason: ""
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 54
- k variables: 13
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-151.37911, -150.00838], y [60.20227, 60.78709]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32605 (UTM Zone 5N (EPSG:32605)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.sq72d (checked 2026-09-10): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`amphibian_malformation_prevalence` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `amphibian_malformation_prevalence` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formula_pub confirmee et verifiee (voir Reference publication) ; formula_used est une approximation generee distincte, explicitement etiquetee comme telle (voir Bloc 1 > Statut regression canonique > Note).
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20%: ROADDISTANCE (NA=40.7%), RoadType (NA=40.7%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`amphibian_malformation_prevalence` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Multiple stressors and the cause of amphibian abnormalities

## Curation documentée — 2026-09-07

Annotation de formula_used deplacee ici : X partiel : seul le sous-ensemble route/contamination humaine du papier est present dans le depot brut, disponible pour 32/54 sites. Le modele execute est une reconstruction partielle ; formula_pub conserve la specification du papier.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

MISE A JOUR (2026-09-10) : Y corrige de prevalence_abnormal vers prevalence_skel_ab (voir FORMULA_OVERRIDES / formula_pub) -- le bullet formula_used ci-dessus mis a jour en consequence pour ne pas ecraser la correction a la regeneration.
