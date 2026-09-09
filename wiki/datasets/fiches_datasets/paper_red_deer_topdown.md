---
title: paper_red_deer_topdown
type: dataset
created: 2026-08-15
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_red_deer_topdown.rds
  - DataCite_2023_NumericalTopdownEffectsOn_10_5061_dryad_0cfxpnw7w
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "unknown" (DOI unknown).

## Description du jeu de donnees

- Topic: dataset spatial spatio-temporel
- Observation unit: observation spatiale de type POINT
- Observed population: 534 enregistrements dans l’artefact local paper_red_deer_topdown.rds; unite declaree : observation spatiale de type POINT. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: etendue sf: x [-8.25, 43.45], y [37, 64.54]
- Temporal context: Synthese de sites issus de la litterature; Year_publ date les publications, temporalite d’observation a retrouver.
- Source description: unknown
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/1365-2664.14526
- Dataset DOI: 10.5061/dryad.0cfxpnw7w
- Source URL: https://doi.org/10.5061/dryad.0cfxpnw7w
- Local raw dir: `data/raw/papers/DataCite_2023_NumericalTopdownEffectsOn_10_5061_dryad_0cfxpnw7w/`
- Local sf output: `data/final_datasets/sf/paper_red_deer_topdown.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Deer_density`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Year_publ`, `hunting`, `Human_influence_index`, `Forest_integrity`, `Bear_presence`, `Wolf_presence`, `Lynx_presence`, `Nr_predators`, `Predation`, `IUCN_Catergory`, `Biogeographic`, `NDVI`, `NPP`, `Prec_all_year`, `Prec_summer`, `Min_Temp_summer`, `Min_Temp_winter`, `NDSI_Snow_Cover`, `Tree_canopy_cover`, `Palmer_drought_summer`
- Candidate X count in local artifact: 20
- Candidate X typology: continuous, categorical
- Published X variables from paper: NPP, Bear_presence/Wolf_presence/Lynx_presence, hunting, Human_influence_index, IUCN_Catergory, Prec_all_year, Min_Temp_summer/Min_Temp_winter, NDSI_Snow_Cover, Tree_canopy_cover, Palmer_drought_summer
- Published X count: 10
- Coordinates (x, y - excluded from X candidates): `Longitude`, `Latitude`
- Identifier columns (excluded from X candidates): `Country`, `Study_area`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Deer_density` | `numeric` | continuous | [0.03, 44.64] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `red_deer_topdown`, la ou les reponses `Deer_density` viennent du loader papier et/ou des preuves de l article `unknown`. Les covariables X retenues sont `NPP`, `Bear_presence`, `Wolf_presence`, `Lynx_presence`, `hunting`, `Human_influence_index`, `IUCN_Catergory`, `Prec_all_year`, `Min_Temp_summer`, `Min_Temp_winter`, `NDSI_Snow_Cover`, `Tree_canopy_cover`, `Palmer_drought_summer` ; 7 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Longitude`, `Latitude`), identifiants (`Country`, `Study_area`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : manual_review; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Year_publ` | `integer` | count | 0% |
| `hunting` | `integer` | binary | 1.1% |
| `Human_influence_index` | `numeric` | continuous | 0.6% |
| `Forest_integrity` | `numeric` | continuous | 0.7% |
| `Bear_presence` | `integer` | binary | 0% |
| `Wolf_presence` | `integer` | binary | 0% |
| `Lynx_presence` | `integer` | binary | 0% |
| `Nr_predators` | `integer` | count | 0% |
| `Predation` | `character` | categorical | 0% |
| `IUCN_Catergory` | `character` | categorical | 0% |
| `Biogeographic` | `character` | categorical | 0% |
| `NDVI` | `numeric` | rate | 0% |
| `NPP` | `numeric` | continuous | 0% |
| `Prec_all_year` | `numeric` | continuous | 0% |
| `Prec_summer` | `numeric` | continuous | 0% |
| `Min_Temp_summer` | `numeric` | continuous | 0% |
| `Min_Temp_winter` | `numeric` | continuous | 0% |
| `NDSI_Snow_Cover` | `numeric` | continuous | 0% |
| `Tree_canopy_cover` | `numeric` | continuous | 0% |
| `Palmer_drought_summer` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: Deer_density ~ NPP + Bear_presence + Wolf_presence + Lynx_presence + hunting + Human_influence_index + IUCN_Catergory + Prec_all_year + Min_Temp_summer + Min_Temp_winter + NDSI_Snow_Cover + Tree_canopy_cover + Palmer_drought_summer [Generalized Additive Model (GAM), effets top-down numeriques sur le cerf elaphe]
- x_terms_pub: NPP, Bear_presence/Wolf_presence/Lynx_presence, hunting, Human_influence_index, IUCN_Catergory, Prec_all_year, Min_Temp_summer/Min_Temp_winter, NDSI_Snow_Cover, Tree_canopy_cover, Palmer_drought_summer
- y_term_pub: Deer_density
- Reference publication: van Beeck Calkoen, S.T.S., Kuijper, D.P.J., Apollonio, M., Blondel, L., Dormann, C.F., Storch, I. & Heurich, M. (2023), Numerical top-down effects on red deer (Cervus elaphus) are mainly shaped by humans rather than large carnivores across Europe, Journal of Applied Ecology, doi:10.1111/1365-2664.14526. CSV telecharge directement depuis Dryad (10.5061/dryad.0cfxpnw7w, API OAuth) -- pas une reconstruction, N=534 sites d'etude identique au depot source (Data_SvBC_RedDeer.csv). README.md du depot documente exactement les variables : recherche litterature (annee, pays, zone d'etude, latitude, longitude, densite, chasse) + facteurs additionnels (productivite primaire nette, presence de grands carnivores, indice d'influence humaine, statut de protection, couverture forestiere, indice de secheresse de Palmer, indice de couverture neigeuse).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: Deer_density ~ NPP + Bear_presence + Wolf_presence + Lynx_presence + hunting + Human_influence_index + IUCN_Catergory + Prec_all_year + Min_Temp_summer + Min_Temp_winter + NDSI_Snow_Cover + Tree_canopy_cover + Palmer_drought_summer
- Recommended validation: N lignes=534; T declare=29; variable temporelle declaree=Year_publ; repetitions de coordonnees controlees=8. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: NPP, Bear_presence, Wolf_presence, Lynx_presence, hunting, Human_influence_index, IUCN_Catergory, Prec_all_year, Min_Temp_summer, Min_Temp_winter, NDSI_Snow_Cover, Tree_canopy_cover, Palmer_drought_summer
- y_term_used: Deer_density
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

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
    formula: "Deer_density ~ NPP + Bear_presence + Wolf_presence + Lynx_presence + hunting + Human_influence_index + IUCN_Catergory + Prec_all_year + Min_Temp_summer + Min_Temp_winter + NDSI_Snow_Cover + Tree_canopy_cover + Palmer_drought_summer"
    response: "Deer_density"
    predictors: ["NPP", "Bear_presence/Wolf_presence/Lynx_presence", "hunting", "Human_influence_index", "IUCN_Catergory", "Prec_all_year", "Min_Temp_summer/Min_Temp_winter", "NDSI_Snow_Cover", "Tree_canopy_cover", "Palmer_drought_summer"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "Deer_density ~ NPP + Bear_presence + Wolf_presence + Lynx_presence + hunting + Human_influence_index + Prec_all_year + Min_Temp_summer + Min_Temp_winter + NDSI_Snow_Cover + Tree_canopy_cover + Palmer_drought_summer"
    response: "Deer_density"
    predictors: ["NPP", "Bear_presence", "Wolf_presence", "Lynx_presence", "hunting", "Human_influence_index", "Prec_all_year", "Min_Temp_summer", "Min_Temp_winter", "NDSI_Snow_Cover", "Tree_canopy_cover", "Palmer_drought_summer"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["gam_spatial", "random_forest", "xgboost"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_red_deer_topdown`
- Dataset name: unknown
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Numerical top-down effects on red deer (Cervus elaphus) are mainly shaped by humans rather than large carnivores across Europe
- Paper DOI: 10.1111/1365-2664.14526
- Dataset DOI: 10.5061/dryad.0cfxpnw7w
- Source URL: https://doi.org/10.5061/dryad.0cfxpnw7w
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Deer_density ~ NPP + Bear_presence + Wolf_presence + Lynx_presence + hunting + Human_influence_index + IUCN_Catergory + Prec_all_year + Min_Temp_summer + Min_Temp_winter + NDSI_Snow_Cover + Tree_canopy_cover + Palmer_drought_summer [Generalized Additive Model (GAM), effets top-down numeriques sur le cerf elaphe]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "van Beeck Calkoen, S.T.S., Kuijper, D.P.J., Apollonio, M., Blondel, L., Dormann, C.F., Storch, I. & Heurich, M. (2023), Numerical top-down effects on red deer (Cervus elaphus) are mainly shaped by humans rather than large carnivores across Europe, Journal of Applied Ecology, doi:10.1111/1365-2664.14526. CSV telecharge directement depuis Dryad (10.5061/dryad.0cfxpnw7w, API OAuth) -- pas une reconstruction, N=534 sites d'etude identique au depot source (Data_SvBC_RedDeer.csv). README.md du depot documente exactement les variables : recherche litterature (annee, pays, zone d'etude, latitude, longitude, densite, chasse) + facteurs additionnels (productivite primaire nette, presence de grands carnivores, indice d'influence humaine, statut de protection, couverture forestiere, indice de secheresse de Palmer, indice de couverture neigeuse)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "manual_review"
  benchmark_task: "reference_raw_see_child_filtered_sample"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "RESOLU (2026-09-09) : le RDS local (534 lignes) est le jeu brut fusionne/deduplique, AVANT les 3 filtres du papier (exclusion de 7 sites en enclos, na.omit, Year_publ>2000). Ces filtres, reexecutes verbatim depuis 01. Model.R, reproduisent exactement les 492 sites du papier -- voir paper_red_deer_topdown_492 (benchmark_status: ready). Ce jeu PARENT (534, brut) reste manual_review car il ne correspond a aucune specification publiee telle quelle."
  reason: "CORRECTION 2026-09-09 : mismatch N=492/534 entierement explique -- differences d'etape de filtrage, pas de divergence de source. Voir paper_red_deer_topdown_492 pour la tache benchmark-ready correspondant exactement a l'echantillon publie."
```

- Decision: manual_review (voir [[paper_red_deer_topdown_492]] pour l'echantillon filtre ready)
- Manque principal: Jeu brut sans filtrage papier applique -- voir la fiche enfant pour la tache executable.
- Raison: Les 3 filtres documentes dans 01. Model.R (enclos, na.omit, Year_publ>2000) ont ete reexecutes et reproduisent exactement N=492 -- fiche enfant creee.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "Jeu brut (534 lignes, avant filtrage papier) -- voir [[paper_red_deer_topdown_492]] pour la tache benchmark-ready correspondant a l'echantillon publie (492 sites)."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 534
- k variables: 28
- T periods: 29
- Variable temporelle: Year_publ (annee de publication, pas une periode d’observation)
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (534) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 526 ; panel NON EQUILIBRE (T par unite : min=1, mediane=1, max=3). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 526 unites spatiales distinctes, pas sur les 534 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 29 distinct periods (variable: Year_publ)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-8.25, 43.45], y [37, 64.54]
- Time range: 1987 to 3000 (variable: Year_publ)
- CRS analyse recommande: pending - multi-zones (span=51.7deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- License evidence: manual_review - Paper DOI and Source URL are both marked "unknown" in this fiche, so no source page exists to check a license against (2026-08-18). Resolving this requires first identifying the source paper/dataset, which is out of scope for a license lookup alone.
- Reproducibility status: OK - loader R enregistre et reexecutable (`red_deer_topdown` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `red_deer_topdown` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`red_deer_topdown` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## ATTENTION -- un echantillon filtre executable a ete extrait de ce jeu brut, NE PAS supprimer

Ce jeu (534 lignes) est le jeu BRUT fusionne/deduplique, avant les 3 filtres documentes dans
le script de replication original `01. Model.R` (exclusion de 7 sites en enclos, na.omit,
Year_publ>2000). Ces filtres, reexecutes verbatim le 2026-09-09, reproduisent exactement les
492 sites de l'echantillon d'analyse du papier :

- [[paper_red_deer_topdown_492]] -- echantillon filtre, N=492, benchmark_status: ready, package_include: yes.

Le PARENT (cette fiche, 534 lignes brutes) reste utile pour toute analyse necessitant les
sites exclus (enclos) ou les lignes incompletes. Ne pas supprimer au pretexte que la fiche
enfant fait doublon.

## Related Pages

- [[paper_red_deer_topdown_492]]
- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: unknown

## Curation documentée — 2026-09-07

DOI article verifie sur la page Dryad : https://datadryad.org/dataset/doi%3A10.5061/dryad.0cfxpnw7w ; auteurs et DOI dataset egalement dans le README local. La source est identifiee; cette verification ne valide pas la formule comparative actuelle.

Decision conservatoire : Source liee via README et metadonnees Dryad verifiees le 2026-09-07; reconcilier les 492 sites decrits avec les 534 lignes du RDS et les exclusions du script 01.Model.R avant benchmark. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
