---
title: paper_amazon_tree_dominance
type: dataset
created: 2026-09-14
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_amazon_tree_dominance.rds
  - DataCite_2023_UnderstandingDifferentDominancePatterns_10_1111_ele_1435
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Understanding different dominance patterns in western Amazonian forests" (DOI 10.1111/ele.14351).

## Description du jeu de donnees

- Topic: ecologie forestiere / inventaire de biomasse
- Observation unit: placette d'inventaire forestier
- Observed population: placettes CTFT/ONF, foret tropicale humide
- Geographic context: etendue sf: x [-76.6372222, -67.0446316], y [-14.8244912, 4.14]
- Temporal context: none (cross-sectional)
- Source description: Understanding different dominance patterns in western Amazonian forests
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/ele.14351
- Dataset DOI: 10.5061/dryad.pk0p2ngsd
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.pk0p2ngsd
- Local raw dir: `data/raw/papers/DataCite_2023_UnderstandingDifferentDominancePatterns_10_1111_ele_1435/`
- Local sf output: `data/final_datasets/sf/paper_amazon_tree_dominance.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `mean_local_relative_abundance`
- Candidate Y typology: rate
- Candidate X variables in local artifact: `total_individuals`, `n_presence_plots`, `n_total_plots_habitat`, `regional_frequency`, `habitat_floodplain`, `habitat_swamp`, `habitat_white_sand`
- Candidate X count in local artifact: 7
- Candidate X typology: continuous, unknown, categorical
- Published X variables from paper: regional_frequency (proportion de parcelles de l'habitat ou l'espece est presente), habitat_type (categoriel, 4 niveaux : terra firme/floodplain/swamp/white sand), interaction regional_frequency:habitat_type (pentes differentes par habitat, cf. Note)
- Published X count: 3
- Coordinates (x, y - excluded from X candidates): `Longitude`, `Latitude`
- Identifier columns (excluded from X candidates): `Species`, `Forest_type`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `mean_local_relative_abundance` | `numeric` | rate | [0.0089, 0.4615] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `amazon_tree_dominance`, la ou les reponses `mean_local_relative_abundance` viennent du loader papier et/ou des preuves de l article `Understanding different dominance patterns in western Amazonian forests`. Les covariables X retenues sont `regional_frequency`, `habitat_floodplain`, `habitat_swamp`, `habitat_white_sand` ; 3 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Longitude`, `Latitude`), identifiants (`Species`, `Forest_type`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `total_individuals` | `numeric` | continuous | 0% |
| `n_presence_plots` | `numeric` | continuous | 0% |
| `n_total_plots_habitat` | `integer` | unknown | 0% |
| `regional_frequency` | `numeric` | rate | 0% |
| `habitat_floodplain` | `integer` | binary | 0% |
| `habitat_swamp` | `integer` | binary | 0% |
| `habitat_white_sand` | `integer` | binary | 0% |

### Formule - niveau publication

- formula_pub: mean_local_relative_abundance ~ regional_frequency * habitat_type [beta regression, logit, mgcv::gam]
- x_terms_pub: regional_frequency (proportion de parcelles de l'habitat ou l'espece est presente), habitat_type (categoriel, 4 niveaux : terra firme/floodplain/swamp/white sand), interaction regional_frequency:habitat_type (pentes differentes par habitat, cf. Note)
- y_term_pub: mean_local_relative_abundance (abondance locale relative moyenne des especes dominantes, moyennee sur les parcelles ou l'espece est presente)
- Reference publication: Matas-Granados, Draper, Cayuela, de Aledo, Arellano, Ben Saadi, Baker, Phillips, Honorio Coronado, Ruokolainen, Garcia-Villacorta, Roucoux, Gueze, Valderrama Sandoval, Fine, Amasifuen Guerra, Zarate Gomez, Stevenson Diaz, Monteagudo-Mendoza, Vasquez Martinez, Socolar, Disney, del Aguila Pasquel, Flores Llampazo, Vega Arenas, Reyna Huaymacari, Grandez Rios & Macia (2024), Understanding different dominance patterns in western Amazonian forests, Ecology Letters 27:e14351, DOI 10.1111/ele.14351 (accepte 23 nov. 2023, publie 2024 -- 'Ecology Letters. 2024;27:e14351' est la citation officielle du journal, corrige de 'Matas Granados et al. (2023)' precedent). CORRECTION (2026-09-10, verification directe PDF+TEI) : le modele beta-regression teste explicitement l'interaction regional_frequency:habitat_type comme 'the most complex model' (comparaison AIC), et le texte des resultats confirme que la pente de regional_frequency differe significativement selon l'habitat -- la formule additive precedente (sans interaction) ne pouvait pas reproduire ce resultat central du papier (Figure 2a montre 4 courbes de formes tres differentes par habitat, pas de simples decalages verticaux). Le local loader reconstruit la table espece-dominante x habitat depuis Raw_to_ecology3.csv et Metadata4.csv : p_ij = abondance de l'espece i dans la parcelle j / total d'individus dans la parcelle j, especes dominantes selectionnees jusqu'a 50% de dominance cumulee par habitat (D_i, seuil de Draper et al. 2019 / ter Steege et al. 2013), regional_frequency = parcelles ou l'espece est presente / total de parcelles de l'habitat. N=221 especes-habitat dans l'artefact local, proche mais pas identique a la somme publiee des especes dominantes par habitat (106 terra firme + 73 floodplain + 20 swamp + 18 white sand = 217, texte p.5) -- ecart de 4 non explique, a signaler comme ecart mineur non resolu plutot que suppose identique. Le modele publie (beta, lien logit) n'est pas une famille explicitement enregistree dans le harnais actuel (ols/gam_spatial/sar_lag/sem_error/sdm_mixed/random_forest/xgboost/gwr/probit) -- gam_spatial (mgcv::gam) pourrait en principe accepter family=betar() mais ce n'est pas verifie dans le code du package a ce jour, a traiter comme une approximation non confirmee, pas une reproduction exacte.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Matas-Granados et al. (2024), Ecology Letters 27:e14351, section 'Local abundance-regional frequency relationship by habitat type', p.4-6. Modele le plus complexe teste inclut explicitement l'INTERACTION entre regional_frequency et habitat_type, comparaison par AIC (difference>2 = modele ecarte) ; confirme par le texte des resultats -- la pente regional_frequency differe par habitat ('the relationship was more negative in white sand, followed by swamp, floodplain and terra firme'), ce qui exige l'interaction (une simple ordonnee a l'origine differente ne suffirait pas).

### Formule - niveau systeme

- formula_used: mean_local_relative_abundance ~ regional_frequency + habitat_floodplain + habitat_swamp + habitat_white_sand + regional_frequency:habitat_floodplain + regional_frequency:habitat_swamp + regional_frequency:habitat_white_sand
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: rate
- x_terms_used: regional_frequency, habitat_floodplain, habitat_swamp, habitat_white_sand
- y_term_used: mean_local_relative_abundance
- Note: Matas-Granados et al. (2024), Ecology Letters 27:e14351, section 'Local abundance-regional frequency relationship by habitat type', p.4-6. Modele le plus complexe teste inclut explicitement l'INTERACTION entre regional_frequency et habitat_type, comparaison par AIC (difference>2 = modele ecarte) ; confirme par le texte des resultats -- la pente regional_frequency differe par habitat ('the relationship was more negative in white sand, followed by swamp, floodplain and terra firme'), ce qui exige l'interaction (une simple ordonnee a l'origine differente ne suffirait pas).

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
    formula: "mean_local_relative_abundance ~ regional_frequency * habitat_type"
    response: "mean_local_relative_abundance (abondance locale relative moyenne des especes dominantes, moyennee sur les parcelles ou l'espece est presente)"
    predictors: ["regional_frequency (proportion de parcelles de l'habitat ou l'espece est presente)", "habitat_type (categoriel, 4 niveaux : terra firme/floodplain/swamp/white sand)", "interaction regional_frequency:habitat_type (pentes differentes par habitat, cf. Note)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
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

- Dataset ID: `paper_amazon_tree_dominance`
- Dataset name: Understanding different dominance patterns in western Amazonian forests
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Understanding different dominance patterns in western Amazonian forests
- Paper DOI: 10.1111/ele.14351
- Dataset DOI: 10.5061/dryad.pk0p2ngsd
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.pk0p2ngsd
- Year: 2024

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "mean_local_relative_abundance ~ regional_frequency * habitat_type [beta regression, logit, mgcv::gam]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: beta_regression_logit_link_gam_betar
  source_type: scientific_publication_or_package_documentation
  source_ref: "Matas-Granados, Draper, Cayuela, de Aledo, Arellano, Ben Saadi, Baker, Phillips, Honorio Coronado, Ruokolainen, Garcia-Villacorta, Roucoux, Gueze, Valderrama Sandoval, Fine, Amasifuen Guerra, Zarate Gomez, Stevenson Diaz, Monteagudo-Mendoza, Vasquez Martinez, Socolar, Disney, del Aguila Pasquel, Flores Llampazo, Vega Arenas, Reyna Huaymacari, Grandez Rios & Macia (2024), Understanding different dominance patterns in western Amazonian forests, Ecology Letters 27:e14351, DOI 10.1111/ele.14351 (accepte 23 nov. 2023, publie 2024 -- 'Ecology Letters. 2024;27:e14351' est la citation officielle du journal, corrige de 'Matas Granados et al. (2023)' precedent). CORRECTION (2026-09-10, verification directe PDF+TEI) : le modele beta-regression teste explicitement l'interaction regional_frequency:habitat_type comme 'the most complex model' (comparaison AIC), et le texte des resultats confirme que la pente de regional_frequency differe significativement selon l'habitat -- la formule additive precedente (sans interaction) ne pouvait pas reproduire ce resultat central du papier (Figure 2a montre 4 courbes de formes tres differentes par habitat, pas de simples decalages verticaux). Le local loader reconstruit la table espece-dominante x habitat depuis Raw_to_ecology3.csv et Metadata4.csv : p_ij = abondance de l'espece i dans la parcelle j / total d'individus dans la parcelle j, especes dominantes selectionnees jusqu'a 50% de dominance cumulee par habitat (D_i, seuil de Draper et al. 2019 / ter Steege et al. 2013), regional_frequency = parcelles ou l'espece est presente / total de parcelles de l'habitat. N=221 especes-habitat dans l'artefact local, proche mais pas identique a la somme publiee des especes dominantes par habitat (106 terra firme + 73 floodplain + 20 swamp + 18 white sand = 217, texte p.5) -- ecart de 4 non explique, a signaler comme ecart mineur non resolu plutot que suppose identique. Le modele publie (beta, lien logit) n'est pas une famille explicitement enregistree dans le harnais actuel (ols/gam_spatial/sar_lag/sem_error/sdm_mixed/random_forest/xgboost/gwr/probit) -- gam_spatial (mgcv::gam) pourrait en principe accepter family=betar() mais ce n'est pas verifie dans le code du package a ce jour, a traiter comme une approximation non confirmee, pas une reproduction exacte."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous_proportion"
  package_include: "yes"
  has_local_rds: true
  missing_items: "coordonnees = centroide des occurrences de l'espece dans l'habitat, car l'unite statistique publiee est espece/habitat et non un point individuel unique"
  reason: "Le loader reconstruit la table espece/habitat du papier depuis les arbres bruts et les metadonnees de parcelles : mean local abundance, regional frequency et habitat type. La reponse est continue dans (0,1), compatible avec un benchmark de regression avec reserve sur l'unite spatiale centroide."
```

- Decision: ready
- Manque principal: coordonnees = centroide des occurrences de l'espece dans l'habitat, car l'unite statistique publiee est espece/habitat et non un point individuel unique
- Raison: Le loader reconstruit la table espece/habitat du papier depuis les arbres bruts et les metadonnees de parcelles : mean local abundance, regional frequency et habitat type. La reponse est continue dans (0,1), compatible avec un benchmark de regression avec reserve sur l'unite spatiale centroide.

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
- N observations: 221
- k variables: 14
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-76.6372222, -67.0446316], y [-14.8244912, 4.14]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32719 (UTM Zone 19S (EPSG:32719)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal (CC0 1.0)
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.pk0p2ngsd (checked 2026-09-10): rightsList = 'Creative Commons Zero v1.0 Universal (CC0 1.0)'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`amazon_tree_dominance` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `amazon_tree_dominance` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`amazon_tree_dominance` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Understanding different dominance patterns in western Amazonian forests

## Curation documentée — 2026-09-07

Typologie de la reponse selectionnee : rate. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
