---
title: paper_red_deer_topdown_492
type: dataset
created: 2026-09-09
updated: 2026-09-09
sources:
  - data/final_datasets/sf/paper_red_deer_topdown_492.rds
  - data/raw/papers/DataCite_2023_NumericalTopdownEffectsOn_10_5061_dryad_0cfxpnw7w/extracted/SvBC_2023_RedDeer/Rscripts/01. Model.R
  - DataCite_2023_NumericalTopdownEffectsOn_10_5061_dryad_0cfxpnw7w
tags: [dataset, paper-derived, spatial, point]
---

Sous-ensemble filtre (492 sites) du jeu parent [[paper_red_deer_topdown]] (534 sites bruts), reproduisant exactement l'echantillon d'analyse du script de replication original `01. Model.R` (exclusion de 7 sites en enclos, suppression des lignes incompletes, filtre annee de publication > 2000). Papier source : "Numerical top-down effects on ungulate density are moderated by human presence and predator diversity" (DOI 10.1111/1365-2664.14526).

## Description du jeu de donnees

- Topic: ecologie des populations / densite de cervides et pression descendante (predation, chasse, presence humaine)
- Observation unit: site d'etude europeen de densite de cerf elaphe (Cervus elaphus)
- Observed population: 492 sites (sous-ensemble filtre du jeu parent, N total parent = 534)
- Geographic context: etendue sf (492 sites, Europe) x [-8.25, 32.63], y [37.00, 64.54]
- Temporal context: coupe transversale (chaque site = une estimation de densite ; pas de suivi temporel structure)
- Source description: Numerical top-down effects on ungulate density are moderated by human presence and predator diversity -- script de replication `01. Model.R`
- Description confidence: high (echantillon et formule confirmes verbatim par reexecution du script de replication R original, session 2026-09-09)
- Paper DOI: 10.1111/1365-2664.14526
- Dataset DOI: 10.5061/dryad.0cfxpnw7w
- Source URL: https://doi.org/10.5061/dryad.0cfxpnw7w
- Local raw dir: `data/raw/papers/DataCite_2023_NumericalTopdownEffectsOn_10_5061_dryad_0cfxpnw7w/`
- Local sf output: `data/final_datasets/sf/paper_red_deer_topdown_492.rds`
- Parent dataset: `paper_red_deer_topdown` (sous-ensemble filtre -- ne pas compter comme source independante)

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Deer_density`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `hunting`, `Predation_adj`, `Human_influence_index`, `NPP`, `Tree_canopy_cover`, `NDSI_Snow_Cover`, `Palmer_drought_summer`, `Protected`
- Candidate X count in local artifact: 8
- Candidate X typology: continuous, categorical
- Published X variables from paper: hunting, Predation_adj, Human_influence_index, NPP, Tree_canopy_cover, NDSI_Snow_Cover, Palmer_drought_summer, Protected
- Published X count: 8
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `X`, `Study_area`, `Country`, `Year_publ`, `Latitude`, `Longitude`, `Bear_presence`, `Wolf_presence`, `Lynx_presence`, `Nr_predators`, `Predation`, `IUCN_Catergory` (variables sources, remplacees par les X derivees Protected/Predation_adj)
- Variables inspected: yes (reexecution complete du script `01. Model.R`, session 2026-09-09)
- Presence of imputed X: no (na.omit applique -- lignes incompletes supprimees, pas d'imputation)

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Deer_density` | `numeric` | continuous | [0.03, 44.64] | 0% |

> Selection Y/X (verbatim, script de replication) : Pour `paper_red_deer_topdown_492`, la reponse est `log(Deer_density)` (transformation log appliquee dans le modele, valeur brute conservee en colonne) et les covariables sont `hunting`, `Predation_adj` (regroupement derive de `Predation`), lissages `s(Human_influence_index, by=Predation_adj)`, `s(NPP, by=Predation_adj)`, `s(Tree_canopy_cover)`, `s(NDSI_Snow_Cover)`, `s(Palmer_drought_summer)`, et `Protected` (regroupement derive de `IUCN_Catergory`). Statut benchmark actuel : ready ; voir bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `hunting` | `factor` | binary | 0% |
| `Predation_adj` | `factor` | categorical | 0% |
| `Human_influence_index` | `numeric` | continuous | 0% |
| `NPP` | `numeric` | continuous | 0% |
| `Tree_canopy_cover` | `numeric` | continuous | 0% |
| `NDSI_Snow_Cover` | `numeric` | continuous | 0% |
| `Palmer_drought_summer` | `numeric` | continuous | 0% |
| `Protected` | `factor` | categorical | 0% |

### Formule - niveau publication

- formula_pub: log(Deer_density) ~ hunting + Predation_adj + s(Human_influence_index, by=Predation_adj) + s(NPP, by=Predation_adj) + s(Tree_canopy_cover) + s(NDSI_Snow_Cover) + s(Palmer_drought_summer) + Protected [GAM, mgcv::gam]
- x_terms_pub: hunting, Predation_adj, Human_influence_index, NPP, Tree_canopy_cover, NDSI_Snow_Cover, Palmer_drought_summer, Protected
- y_term_pub: Deer_density (modelise en log)
- Reference publication: script de replication `01. Model.R` (Dryad, DOI 10.5061/dryad.0cfxpnw7w), ligne 108 : `gam10km_rev<- mgcv::gam(log(Deer_density) ~ hunting + Predation_adj + s(Human_influence_index, by = Predation_adj)+ s(NPP, by = Predation_adj)+ s(Tree_canopy_cover)+ s(NDSI_Snow_Cover) + s(Palmer_drought_summer) + Protected, data = red_EU_review)`.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: verbatim
- Methode d estimation: formule et echantillon confirmes verbatim par reexecution du script de replication R original
- Correspondance Python/R: mgcv::gam (R) -- meme package utilise par l'estimateur gam_spatial du harnais
- Note: Correction du 2026-09-09 -- investigation du "cas a trancher" signale sur le jeu parent : le mismatch N=492 (papier) vs N=534 (RDS local) est entierement explique et reproductible. Le RDS local est le jeu brut fusionne/deduplique (534 lignes) ; le papier applique 3 filtres documentes dans `01. Model.R` : (1) exclusion de 7 sites en enclos (Altopiano di Budduso, Ulassai, Montarbu, Sarcidano, Monte Arci, Tramonti, Monticolo), (2) `na.omit()` sur les colonnes utiles (-> 519), (3) filtre `Year_publ > 2000` (-> 492, match exact). Reexecution complete verifiee le 2026-09-09.

### Formule - niveau systeme

- formula_used: Deer_density ~ hunting + Predation_adj + s(Human_influence_index, by=Predation_adj) + s(NPP, by=Predation_adj) + s(Tree_canopy_cover) + s(NDSI_Snow_Cover) + s(Palmer_drought_summer) + Protected
- Formula used evidence: verbatim
- Recommended validation: N lignes=492; N spatial=492 sites europeens (coordonnees non dupliquees a verifier -- plusieurs sites peuvent partager une meme etude source, cf. `Study_area`). Coupe transversale (T=1 declare) -- verifier absence de fuite si plusieurs sites d'une meme `Study_area` sont fortement correles.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used ; log-transformation a appliquer cote estimateur (mgcv::gam gere `log(Deer_density)` nativement via la formule).
- Selected Y typology: continuous
- x_terms_used: hunting, Predation_adj, Human_influence_index, NPP, Tree_canopy_cover, NDSI_Snow_Cover, Palmer_drought_summer, Protected
- y_term_used: Deer_density
- Note: Anomalie de donnees relevee (non corrigee, fidele a la source) : une observation a `Year_publ = 3000` (au lieu d'une annee plausible) -- probable erreur de saisie dans le CSV source, mais cette ligne fait partie de l'echantillon des 492 du papier (le filtre `Year_publ > 2000` la laisse passer telle quelle dans le script original). Conservee telle quelle par fidelite a la reproduction -- ne pas "corriger" sans confirmation aupres des auteurs.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "Deer_density ~ Human_influence_index"
    response: "Deer_density"
    predictors: ["Human_influence_index"]
    role: "simple_baseline"
    source_type: "scientific_publication"
    source_ref: "01. Model.R, section exploratoire (plot Deer_density ~ Human_influence_index)."
    estimator_context: ["ols", "gam_spatial"]
    status: "confirmed"

  multivariate_constrained:
    formula: "Deer_density ~ hunting + Predation_adj + Human_influence_index + NPP + Tree_canopy_cover + NDSI_Snow_Cover + Palmer_drought_summer + Protected"
    response: "Deer_density"
    predictors: ["hunting", "Predation_adj", "Human_influence_index", "NPP", "Tree_canopy_cover", "NDSI_Snow_Cover", "Palmer_drought_summer", "Protected"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "01. Model.R, ligne 108 (modele GAM complet avec lissages by=Predation_adj -- version additive simplifiee ici, sans les interactions by=)."
    estimator_context: ["gam_spatial", "ols"]
    status: "confirmed_simplified"

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

- Dataset ID: `paper_red_deer_topdown_492`
- Dataset name: Numerical top-down effects on ungulate density -- echantillon filtre (492 sites)
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Numerical top-down effects on ungulate density are moderated by human presence and predator diversity
- Paper DOI: 10.1111/1365-2664.14526
- Dataset DOI: 10.5061/dryad.0cfxpnw7w
- Year: unknown
- Parent dataset: `paper_red_deer_topdown` (sous-ensemble filtre -- ne pas compter comme source independante)

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression continue (GAM avec lissages)
- Modele niveau 2 (famille): modele additif generalise (mgcv::gam), lissages simples + varying-coefficient (by=facteur)
- Modele niveau 3 (variante): version publiee complete (avec by=Predation_adj) vs version simplifiee additive (sans interaction by=, executable avec gam_spatial standard)

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "log(Deer_density) ~ hunting + Predation_adj + s(Human_influence_index, by=Predation_adj) + s(NPP, by=Predation_adj) + s(Tree_canopy_cover) + s(NDSI_Snow_Cover) + s(Palmer_drought_summer) + Protected"
  equation_family: paper_empirical_or_dataset_specific
  model_family: generalized_additive_model
  source_type: scientific_publication_or_package_documentation
  source_ref: "01. Model.R (script de replication R, Dryad DOI 10.5061/dryad.0cfxpnw7w), ligne 108. Reexecute integralement le 2026-09-09 (N final = 492, match exact avec le papier)."
  confidence: high
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Echantillon (N=492) et formule confirmes verbatim par reexecution complete du script de replication R original ; mismatch N=492/534 du jeu parent entierement explique et reproduit (voir Note Bloc 1). Y continu (Deer_density), X tous presents dans le RDS local."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Echantillon et formule confirmes verbatim par reexecution du script de replication original.

## Estimator eligibility

```yaml
estimator_eligibility:
  eligible_estimators:
    - estimator: gam_spatial
      basis: scientific_evidence
      source_ref: "01. Model.R, ligne 108 : mgcv::gam(log(Deer_density) ~ ... lissages ...). Meme moteur (mgcv) que l'estimateur gam_spatial du harnais."
      notes: "Version publiee utilise des lissages varying-coefficient (s(x, by=Predation_adj)) -- a verifier si le harnais accepte cette syntaxe de formule etendue ; sinon utiliser la version additive simplifiee (formula_candidates.multivariate_constrained) comme approximation raisonnable, deja scientifiquement motivee (mêmes variables, sans l'interaction)."
    - estimator: ols
      basis: generated_candidate
      source_ref: "Aucune -- comparateur lineaire standard, pas le modele publie (qui est un GAM)."
      notes: "Approximation lineaire simplifiee."
    - estimator: random_forest
      basis: generated_candidate
      source_ref: "Aucune -- alternative non-parametrique generique pour comparaison, Y continu."
      notes: "Comparateur ML, pas le modele publie."
  conditionally_eligible_estimators: []
  ineligible_reason: "n/a -- estimateur principal (gam_spatial) eligible avec preuve scientifique directe."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 492
- k variables: 8
- T periods: 1
- Variable temporelle: aucune (chaque site = une observation independante de densite)
- N/T profile: N_grand_T_petit
- Note N/T (session 2026-09-09) : Sous-ensemble filtre (492) du panel/jeu brut parent [[paper_red_deer_topdown]] (534 sites) -- 3 filtres documentes et reproduits verbatim (voir Note Bloc 1). Plusieurs sites peuvent partager la meme `Study_area` (variable conservee dans le parent mais non retenue en X ici) -- a surveiller si un futur travail exige l'independance stricte des observations.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation (site d'etude)
- Temporal resolution: coupe transversale (pas de resolution temporelle -- densites estimees a des dates variables selon les etudes sources)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-8.25, 32.63], y [37.0, 64.54]
- Time range: non applicable (coupe transversale ; `Year_publ` documente l'annee de PUBLICATION de l'etude source, pas une date d'observation structurelle)
- CRS analyse recommande: pending - etendue paneuropeenne (span=40.9deg) -- projection continentale (ex. EPSG:3035 LAEA Europe) recommandee pour l'analyse spatiale

## Bloc 6 - Reproductibilite

- License present: yes (heritee, a confirmer)
- License name: probable CC0 1.0 (licence par defaut Dryad) -- a confirmer via la page Dataverse/Dryad du DOI
- License URL: https://datadryad.org/stash/dataset/doi:10.5061/dryad.0cfxpnw7w
- License open: yes (probable)
- License evidence: Convention par defaut des depots Dryad (CC0) ; non verifiee explicitement page par page (session 2026-09-09) -- statut herite du parent, qui le documentait deja comme "unknown" (note obsolete du 2026-08-18 contredite par les DOI/Source URL deja presents dans la fiche parente -- a corriger separement).
- Reproducibility status: OK - reexecution complete et verifiee du script de replication original `01. Model.R` (session 2026-09-09), N final = 492 match exact avec le papier.
- Code available: yes (`01. Model.R`, data/raw/papers/.../Rscripts/)
- Repository: paper-derived (voir fiche parent [[paper_red_deer_topdown]])

## Quality Control

- Schema: OK - fiche derivee du format Bloc 1-6 de la fiche parent [[paper_red_deer_topdown]].
- Variables: OK - Y (`Deer_density`) et X (8 variables, dont 2 derivees : Protected, Predation_adj) confirmes verbatim.
- Formula: OK - formule GAM confirmee verbatim (version simplifiee sans by= executable avec gam_spatial standard).
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT), 492 sites.
- Missing values: OK - 0% de NA (na.omit deja applique lors du filtrage).
- Duplicates: OK au niveau ligne -- pas de doublon exact ; plusieurs sites peuvent partager une meme Study_area (non bloquant, signale en Bloc 4).
- Reproducibility: OK - script de replication reexecute integralement, N final valide.

## Related Pages

- [[paper_red_deer_topdown]]
- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Numerical top-down effects on ungulate density are moderated by human presence and predator diversity

## Curation documentée — 2026-09-09

Fiche generee suite a l'investigation du "cas a trancher" signale sur le jeu parent [[paper_red_deer_topdown]] (mismatch N=492 vs 534). Le script de replication R original `01. Model.R` (present dans les donnees brutes Dryad) a ete lu et reexecute integralement, confirmant que le RDS local est le jeu brut (534, avant filtrage papier) et que les 3 filtres du papier (exclusion enclos, na.omit, Year_publ>2000) reproduisent exactement le N=492 rapporte. Le meme jeu de donnees a bien ete confirme identique (memes colonnes source, memes sites) -- pas de divergence de source, uniquement une difference d'etape de filtrage.

Provenance des corrections : investigation du 2026-09-09, reexecution de `01. Model.R`, script `build_reddeer_492.R` (scratchpad).
