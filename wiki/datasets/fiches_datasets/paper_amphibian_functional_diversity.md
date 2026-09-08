---
title: paper_amphibian_functional_diversity
type: dataset
created: 2026-08-16
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_amphibian_functional_diversity.rds
  - DatasetFirst_10_5061_dryad_nk0bj96
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Amphibian functional diversity is related to high annual precipitation and low precipitation seasonality in the New World" (DOI 10.1111/geb.12926).

## Description du jeu de donnees

- Topic: biogeographie / diversite fonctionnelle des amphibiens
- Observation unit: cellule de grille
- Observed population: amphibiens du Nouveau Monde (Ameriques), N=4065 cellules de grille
- Geographic context: Etendue mesuree dans le RDS : x [-167.0655071, -34.4041591], y [-54.852941, 70.2585972]; CRS EPSG:4326.
- Temporal context: none (cross-sectional)
- Source description: Amphibian functional diversity is related to high annual precipitation and low precipitation seasonality in the New World
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/geb.12926
- Dataset DOI: 10.5061/dryad.nk0bj96
- Source URL: https://doi.org/10.5061/dryad.nk0bj96
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_nk0bj96/`
- Local sf output: `data/final_datasets/sf/paper_amphibian_functional_diversity.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `H0`, `Richness`, `Shannon`, `Gini_Simp`
- Candidate Y typology: count, continuous, rate
- Candidate X variables in local artifact: `Alt`, `NPP`, `PET`, `AI`, `Pps`, `Pp`, `Ts`, `MeanAnnualTemp`, `Alt_st`, `NPP_st`, `PET_st`, `AI_st`, `Pps_st`, `Pp_st`, `Ts_st`, `T_st`, `H0_25`, `H0_5`, `H0_75`, `H1`, `H2`, `H3`, `H4`, `H5`, `Traits`
- Candidate X count in local artifact: 25
- Candidate X typology: continuous
- Published X variables from paper: MeanAnnualTemp, Pp, Ts, AI (modele final ; NPP et Pps etaient candidats au criblage de colinearite mais exclus du modele final, corrige 2026-09-08)
- Published X count: 6
- Coordinates (x, y - excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `UNIQUE_ID`, `Regions`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `H0` | `integer` | count | [1, 50] | 0% |
| `Richness` | `integer` | count | [1, 158] | 0% |
| `Shannon` | `numeric` | continuous | [0, 3.4622] | 0% |
| `Gini_Simp` | `numeric` | rate | [0, 0.9612] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `amphibian_functional_diversity`, la ou les reponses `H0`, `Richness`, `Shannon`, `Gini_Simp` viennent du loader papier et/ou des preuves de l article `Amphibian functional diversity is related to high annual precipitation and low precipitation seasonality in the New World`. Les covariables X retenues sont `MeanAnnualTemp`, `Pp`, `Ts`, `AI` (corrige 2026-09-08 -- modele final publie, SAR) ; 21 autres colonnes candidates (dont NPP et Pps, ecartees du modele final) restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`X`, `Y`), identifiants (`UNIQUE_ID`, `Regions`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Alt` | `numeric` | continuous | 0.1% |
| `NPP` | `numeric` | continuous | 0.9% |
| `PET` | `numeric` | continuous | 0.1% |
| `AI` | `numeric` | continuous | 0.1% |
| `Pps` | `numeric` | continuous | 0.1% |
| `Pp` | `numeric` | continuous | 0.1% |
| `Ts` | `numeric` | continuous | 0.1% |
| `MeanAnnualTemp` | `numeric` | continuous | 0.1% |
| `Alt_st` | `numeric` | continuous | 0% |
| `NPP_st` | `numeric` | continuous | 0% |
| `PET_st` | `numeric` | continuous | 0% |
| `AI_st` | `numeric` | continuous | 0% |
| `Pps_st` | `numeric` | continuous | 0% |
| `Pp_st` | `numeric` | continuous | 0% |
| `Ts_st` | `numeric` | continuous | 0% |
| `T_st` | `numeric` | continuous | 0% |
| `H0_25` | `numeric` | continuous | 0% |
| `H0_5` | `numeric` | continuous | 0% |
| `H0_75` | `numeric` | continuous | 0% |
| `H1` | `numeric` | continuous | 0% |
| `H2` | `numeric` | continuous | 0% |
| `H3` | `numeric` | continuous | 0% |
| `H4` | `numeric` | continuous | 0% |
| `H5` | `numeric` | continuous | 0% |
| `Traits` | `integer` | count | 0% |

### Formule - niveau publication

- formula_pub: H0 ~ MeanAnnualTemp + Pp + Ts + AI [modele SAR (spatial autoregressive), modele final publie -- OLS+Dutilleul ne sert qu'au criblage prealable de colinearite sur le jeu complet de 6 variables candidates]
- x_terms_pub: MeanAnnualTemp, Pp, Ts, AI
- y_term_pub: H0 ; Richness disponible comme variante
- Reference publication: Ochoa-Ochoa, L.M. et al. (2019), Amphibian functional diversity is related to high annual precipitation and low precipitation seasonality in the New World, Global Ecology and Biogeography, doi:10.1111/geb.12926. Appendix S3 CSV telecharge directement depuis le depot Dryad (10.5061/dryad.nk0bj96) -- pas une reconstruction, N=4065 cellules de grille (Ameriques, X/Y en degres decimaux). Y et X correspondent exactement aux variables environnementales decrites dans le papier (NPP, temperature/precipitation annuelles et leur saisonnalite, indice d'aridite). CORRECTION (session 2026-08-16, detectee par le verificateur de coherence inter-blocs) : la colonne source 'T' (temperature annuelle moyenne, terme publie du papier) entrait en collision avec la convention TIME_VAR <- 'T' du pipeline partage (build_sf_datasets.R), qui l'excluait donc automatiquement des candidats X en la traitant comme variable temporelle technique. Renommee 'MeanAnnualTemp' dans le loader pour lever l'ambiguite -- meme colonne/valeurs, pas une reconstruction.
- Correction APPLIQUEE (2026-09-08, lecture TEI approfondie, puis correction sur demande explicite de l'utilisateur) : le modele publie H0~environnement est un **SAR (spatial autoregressive)**, pas un OLS -- le TEI precise "We generated an SAR model for each functional diversity metric... explicit spatial dependence is allowed within a neighbourhood structure" (l'OLS+correction Dutilleul ne sert qu'au criblage prealable de colinearite sur les 6 variables candidates, pas au modele final). Le texte du papier precise : "Final models were run with annual mean temperature, annual precipitation, temperature seasonality and aridity index" (4 variables). `formula_used`/`x_terms_used`/`formula_pub` corriges pour ne garder que ces 4 variables (MeanAnnualTemp, Pp, Ts, AI -- NPP et Pps retires) et `sar_lag` ajoute comme estimateur eligible (voir Estimator eligibility). formula_status : `pub` (modele final confirme et correctement specifie).

### Statut regression canonique

- Statut: resolu (corrige 2026-09-08)
- Niveau de preuve: publication -- variables ET methode (SAR) desormais conformes au modele final du papier
- Methode d estimation: formule publication confirmee et corrigee (4 variables du modele final, SAR)
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: H0 ~ MeanAnnualTemp + Pp + Ts + AI
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: count
- x_terms_used: MeanAnnualTemp, Pp, Ts, AI
- y_term_used: H0
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

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
    formula: "H0 ~ MeanAnnualTemp + Pp + Ts + AI"
    response: "H0"
    predictors: ["MeanAnnualTemp", "Pp", "Ts", "AI"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["sar_lag", "ols"]
    status: "confirmed"

  ml_or_selected:
    formula: "H0 ~ MeanAnnualTemp + Pp + Ts + AI"
    response: "H0"
    predictors: ["MeanAnnualTemp", "Pp", "Ts", "AI"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["sar_lag", "ols", "random_forest"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_amphibian_functional_diversity`
- Dataset name: Data from: Amphibian functional diversity is related to high annual precipitation and low precipitation seasonality in the New World
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Amphibian functional diversity is related to high annual precipitation and low precipitation seasonality in the New World
- Paper DOI: 10.1111/geb.12926
- Dataset DOI: 10.5061/dryad.nk0bj96
- Source URL: https://doi.org/10.5061/dryad.nk0bj96
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): SAR (spatial autoregressive)
- Modele niveau 3 (variante): sar_lag

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "H0 ~ MeanAnnualTemp + Pp + Ts + AI [modele SAR (spatial autoregressive), modele final publie -- corrige 2026-09-08, remplace l'ancienne mention OLS+Dutilleul qui ne concernait que le criblage de colinearite prealable]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_autoregressive_sar
  source_type: scientific_publication_or_package_documentation
  source_ref: "Ochoa-Ochoa, L.M. et al. (2019), Amphibian functional diversity is related to high annual precipitation and low precipitation seasonality in the New World, Global Ecology and Biogeography, doi:10.1111/geb.12926. Appendix S3 CSV telecharge directement depuis le depot Dryad (10.5061/dryad.nk0bj96) -- pas une reconstruction, N=4065 cellules de grille (Ameriques, X/Y en degres decimaux). Y et X correspondent exactement aux variables environnementales decrites dans le papier (NPP, temperature/precipitation annuelles et leur saisonnalite, indice d'aridite). CORRECTION (session 2026-08-16, detectee par le verificateur de coherence inter-blocs) : la colonne source 'T' (temperature annuelle moyenne, terme publie du papier) entrait en collision avec la convention TIME_VAR <- 'T' du pipeline partage (build_sf_datasets.R), qui l'excluait donc automatiquement des candidats X en la traitant comme variable temporelle technique. Renommee 'MeanAnnualTemp' dans le loader pour lever l'ambiguite -- meme colonne/valeurs, pas une reconstruction."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_spatial_sar_confirmed"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Bloc complete le 2026-09-08 apres correction de formula_used (4 variables du modele final, retrait de NPP et Pps). sar_lag est l'estimateur scientifiquement fonde (modele publie explicitement SAR, Ochoa-Ochoa et al. 2019)."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Bloc complete le 2026-09-08 apres correction de formula_used (4 variables du modele final, retrait de NPP et Pps). sar_lag est l'estimateur scientifiquement fonde (modele publie explicitement SAR, Ochoa-Ochoa et al. 2019).

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators:
    - estimator: sar_lag
      basis: scientific_evidence
      source_ref: "Ochoa-Ochoa, L.M. et al. (2019), Global Ecology and Biogeography, doi:10.1111/geb.12926 -- \"We generated an SAR model for each functional diversity metric... explicit spatial dependence is allowed within a neighbourhood structure.\""
      notes: "Modele final publie, verbatim (4 variables : MeanAnnualTemp, Pp, Ts, AI)."
    - estimator: ols
      basis: benchmark_use
      source_ref: "Le papier utilise OLS+Dutilleul uniquement pour le criblage de colinearite prealable, pas le modele final -- conserve ici comme comparateur non-spatial standard."
      notes: "Comparateur de reference, pas le modele publie."
  conditionally_eligible_estimators: []
  ineligible_reason: "Bloc complete le 2026-09-08 apres correction de formula_used (4 variables du modele final, retrait de NPP et Pps). sar_lag est l'estimateur scientifiquement fonde (modele publie explicitement SAR, Ochoa-Ochoa et al. 2019)."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 4065
- k variables: 33
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-167.0655071, -34.4041591], y [-54.852941, 70.2585972]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=132.7deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.nk0bj96 (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`amphibian_functional_diversity` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `amphibian_functional_diversity` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`amphibian_functional_diversity` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Amphibian functional diversity is related to high annual precipitation and low precipitation seasonality in the New World

## Curation documentée — 2026-09-07

Decision conservatoire : Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : count. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
