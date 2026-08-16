---
title: paper_teles_decapod_biodiversity_brazil
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_teles_decapod_biodiversity_brazil.rds
  - DataCite_2026_DataAndRCode_10_1111_jbi_7007
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Data and R code for: Biogeography and conservation of bycatch decapods" (DOI 10.1111/jbi.70076).

## Description du jeu de donnees

- Topic: biodiversite marine / captures accessoires
- Observation unit: cellule ou point d'observation marin
- Observed population: decapodes marins captures en peche accessoire
- Geographic context: etendue sf: x [-52.85, -31.85], y [-33.3, 4.7]
- Temporal context: none (cross-sectional)
- Source description: Data and R code for: Biogeography and conservation of bycatch decapods
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/jbi.70076
- Dataset DOI: 10.5061/dryad.0zpc8678d
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.0zpc8678d
- Local raw dir: `data/raw/papers/DataCite_2026_DataAndRCode_10_1111_jbi_7007/`
- Local sf output: `data/final_datasets/sf/paper_teles_decapod_biodiversity_brazil.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `SR`, `PD`, `PE`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `ph`, `chlomean`, `chloRange`, `chloSS`, `curvel`, `O2`, `O2range`, `O2Lmax`, `nit`, `phosp`, `sal`, `salrange`, `salLmax`, `tempmean`, `temprange`, `bathym`, `iron`, `pp`, `sil`, `tempSS`, `SalSS`, `light`, `carbophyto`, `carbophytoLmax`, `carbophytorange`, `calcite`, `carbophytoSS`, `ppSS`, `pprange`, `tempLmax`, `WE`, `ED`, `PD.SES`, `WE.SES`, `PE.SES`, `ED.SES`, `fishing_effort`
- Candidate X count in local artifact: 37
- Candidate X typology: continuous
- Published X variables from paper: tempmean (temperature moyenne du fond), pp (productivite primaire), curvel (vitesse du courant), sal (salinite), light (disponibilite lumineuse), fishing_effort (effort de peche)
- Published X count: 6
- Coordinates (x, y - excluded from X candidates): `Longitude`, `Latitude`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `SR` | `numeric` | continuous | [1, 65] | 0% |
| `PD` | `numeric` | continuous | [0.0594, 29.6888] | 0% |
| `PE` | `numeric` | continuous | [0.0024, 2.7711] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `teles_decapod_biodiversity_brazil`, la ou les reponses `SR`, `PD`, `PE` viennent du loader papier et/ou des preuves de l article `Data and R code for: Biogeography and conservation of bycatch decapods`. Les covariables X retenues sont `tempmean`, `pp`, `curvel`, `sal`, `light`, `fishing_effort` ; 31 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Longitude`, `Latitude`), identifiants (les identifiants detectes), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `ph` | `numeric` | continuous | 1.2% |
| `chlomean` | `numeric` | continuous | 1.2% |
| `chloRange` | `numeric` | continuous | 1.2% |
| `chloSS` | `numeric` | continuous | 1.2% |
| `curvel` | `numeric` | rate | 1.2% |
| `O2` | `numeric` | continuous | 1.2% |
| `O2range` | `numeric` | continuous | 1.2% |
| `O2Lmax` | `numeric` | continuous | 1.2% |
| `nit` | `numeric` | continuous | 1.2% |
| `phosp` | `numeric` | continuous | 1.2% |
| `sal` | `numeric` | continuous | 1.2% |
| `salrange` | `numeric` | continuous | 1.2% |
| `salLmax` | `numeric` | continuous | 1.2% |
| `tempmean` | `numeric` | continuous | 1.2% |
| `temprange` | `numeric` | continuous | 1.2% |
| `bathym` | `numeric` | continuous | 1.2% |
| `iron` | `numeric` | rate | 1.2% |
| `pp` | `numeric` | continuous | 1.2% |
| `sil` | `numeric` | continuous | 1.2% |
| `tempSS` | `numeric` | continuous | 1.2% |
| `SalSS` | `numeric` | continuous | 1.2% |
| `light` | `numeric` | continuous | 1.2% |
| `carbophyto` | `numeric` | continuous | 1.2% |
| `carbophytoLmax` | `numeric` | continuous | 1.2% |
| `carbophytorange` | `numeric` | continuous | 1.2% |
| `calcite` | `numeric` | rate | 1.2% |
| `carbophytoSS` | `numeric` | continuous | 1.2% |
| `ppSS` | `numeric` | rate | 1.2% |
| `pprange` | `numeric` | continuous | 1.2% |
| `tempLmax` | `numeric` | continuous | 1.2% |
| `WE` | `numeric` | continuous | 0% |
| `ED` | `numeric` | rate | 0% |
| `PD.SES` | `numeric` | continuous | 0% |
| `WE.SES` | `numeric` | continuous | 0% |
| `PE.SES` | `numeric` | continuous | 0% |
| `ED.SES` | `numeric` | continuous | 0% |
| `fishing_effort` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: PD.SES ~ tempmean + pp + curvel [Random Forest ; PD.SES = effet standardise de diversite phylogenetique, principale reponse continue modelisee par le papier avec SR (count) et PE.SES]
- x_terms_pub: tempmean (temperature moyenne du fond), pp (productivite primaire), curvel (vitesse du courant), sal (salinite), light (disponibilite lumineuse), fishing_effort (effort de peche)
- y_term_pub: PD.SES (diversite phylogenetique, effet standardise -- reponse continue choisie par defaut parmi les 3 reponses publiees SR/PD.SES/PE.SES, toutes les 3 disponibles en option dans le package)
- Reference publication: Teles & Mantelatto (2025), Journal of Biogeography / Dryad description et TEI : le papier modelise par Random Forest 3 reponses -- SR (richesse specifique, count, principalement expliquee par salinite/lumiere/productivite primaire), PD.SES (diversite phylogenetique standardisee, principalement temperature du fond/productivite primaire/vitesse du courant) et PE.SES (originalite phylogenetique standardisee, principalement temperature/productivite primaire). PD.SES est choisie comme reponse par defaut le 2026-08-15 (decision utilisateur : reponse principale = celle qui est continue) car c'est une metrique continue (z-score, peut etre negative) contrairement a SR (count) ; SR, PE.SES, WE, WE.SES, ED, ED.SES restent documentees et disponibles comme reponses alternatives dans le .rds (N=160, toutes colonnes presentes).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Teles & Mantelatto (2025), Journal of Biogeography / Dryad description et TEI : le papier modelise par Random Forest 3 reponses -- SR (richesse specifique, count, principalement expliquee par salinite/lumiere/productivite primaire), PD.SES (diversite phylogenetique standardisee, principalement temperature du fond/productivite primaire/vitesse du courant) et PE.SES (originalite phylogenetique standardisee, principalement temperature/productivite primaire). PD.SES est choisie comme reponse par defaut le 2026-08-15 (decision utilisateur : reponse principale = celle qui est continue) car c'est une metrique continue (z-score, peut etre negative) contrairement a SR (count) ; SR, PE.SES, WE, WE.SES, ED, ED.SES restent documentees et disponibles comme reponses alternatives dans le .rds (N=160, toutes colonnes presentes).

### Formule - niveau systeme

- formula_used: PD.SES ~ tempmean + pp + curvel + sal + light + fishing_effort
- x_terms_used: tempmean, pp, curvel, sal, light, fishing_effort
- y_term_used: PD.SES
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Teles & Mantelatto (2025), Journal of Biogeography / Dryad description et TEI : le papier modelise par Random Forest 3 reponses -- SR (richesse specifique, count, principalement expliquee par salinite/lumiere/productivite primaire), PD.SES (diversite phylogenetique standardisee, principalement temperature du fond/productivite primaire/vitesse du courant) et PE.SES (originalite phylogenetique standardisee, principalement temperature/productivite primaire). PD.SES est choisie comme reponse par defaut le 2026-08-15 (decision utilisateur : reponse principale = celle qui est continue) car c'est une metrique continue (z-score, peut etre negative) contrairement a SR (count) ; SR, PE.SES, WE, WE.SES, ED, ED.SES restent documentees et disponibles comme reponses alternatives dans le .rds (N=160, toutes colonnes presentes).

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
    formula: "PD.SES ~ tempmean + pp + curvel + sal + light + fishing_effort"
    response: "PD.SES (diversite phylogenetique, effet standardise -- reponse continue choisie par defaut parmi les 3 reponses publiees SR/PD.SES/PE.SES, toutes les 3 disponibles en option dans le package)"
    predictors: ["tempmean (temperature moyenne du fond)", "pp (productivite primaire)", "curvel (vitesse du courant)", "sal (salinite)", "light (disponibilite lumineuse)", "fishing_effort (effort de peche)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Teles & Mantelatto (2025), Journal of Biogeography / Dryad description et TEI : le papier modelise par Random Forest 3 reponses -- SR (richesse specifique, count, principalement expliquee par salinite/lumiere/productivite primaire), PD.SES (diversite phylogenetique standardisee, principalement temperature du fond/productivite primaire/vitesse du courant) et PE.SES (originalite phylogenetique standardisee, principalement temperature/productivite primaire). PD.SES est choisie comme reponse par defaut le 2026-08-15 (decision utilisateur : reponse principale = celle qui est continue) car c'est une metrique continue (z-score, peut etre negative) contrairement a SR (count) ; SR, PE.SES, WE, WE.SES, ED, ED.SES restent documentees et disponibles comme reponses alternatives dans le .rds (N=160, toutes colonnes presentes)."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "PD.SES ~ tempmean + pp + curvel + sal + light + fishing_effort"
    response: "PD.SES"
    predictors: ["tempmean", "pp", "curvel", "sal", "light", "fishing_effort"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Teles & Mantelatto (2025), Journal of Biogeography / Dryad description et TEI : le papier modelise par Random Forest 3 reponses -- SR (richesse specifique, count, principalement expliquee par salinite/lumiere/productivite primaire), PD.SES (diversite phylogenetique standardisee, principalement temperature du fond/productivite primaire/vitesse du courant) et PE.SES (originalite phylogenetique standardisee, principalement temperature/productivite primaire). PD.SES est choisie comme reponse par defaut le 2026-08-15 (decision utilisateur : reponse principale = celle qui est continue) car c'est une metrique continue (z-score, peut etre negative) contrairement a SR (count) ; SR, PE.SES, WE, WE.SES, ED, ED.SES restent documentees et disponibles comme reponses alternatives dans le .rds (N=160, toutes colonnes presentes)."
    estimator_context: ["random_forest", "random_forest_spatial", "xgboost"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_teles_decapod_biodiversity_brazil`
- Dataset name: Data and R code for: Biogeography and conservation of bycatch decapods
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Data and R code for: Biogeography and conservation of bycatch decapods
- Paper DOI: 10.1111/jbi.70076
- Dataset DOI: 10.5061/dryad.0zpc8678d
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.0zpc8678d
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "PD.SES ~ tempmean + pp + curvel [Random Forest ; PD.SES = effet standardise de diversite phylogenetique, principale reponse continue modelisee par le papier avec SR (count) et PE.SES]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Teles & Mantelatto (2025), Journal of Biogeography / Dryad description et TEI : le papier modelise par Random Forest 3 reponses -- SR (richesse specifique, count, principalement expliquee par salinite/lumiere/productivite primaire), PD.SES (diversite phylogenetique standardisee, principalement temperature du fond/productivite primaire/vitesse du courant) et PE.SES (originalite phylogenetique standardisee, principalement temperature/productivite primaire). PD.SES est choisie comme reponse par defaut le 2026-08-15 (decision utilisateur : reponse principale = celle qui est continue) car c'est une metrique continue (z-score, peut etre negative) contrairement a SR (count) ; SR, PE.SES, WE, WE.SES, ED, ED.SES restent documentees et disponibles comme reponses alternatives dans le .rds (N=160, toutes colonnes presentes)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous_biodiversity"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun -- PD.SES choisie comme reponse continue par defaut (voir FORMULA_OVERRIDES), SR/PE.SES/WE/WE.SES/ED/ED.SES documentees comme alternatives disponibles dans le .rds"
  reason: "Y biodiversite continue (PD.SES), covariables environnementales et coordonnees sont disponibles; modele RF et diagnostics Moran documentes dans le papier/supplement. Promu package_include=yes le 2026-08-15."
```

- Decision: ready
- Manque principal: aucun -- PD.SES choisie comme reponse continue par defaut (voir FORMULA_OVERRIDES), SR/PE.SES/WE/WE.SES/ED/ED.SES documentees comme alternatives disponibles dans le .rds
- Raison: Y biodiversite continue (PD.SES), covariables environnementales et coordonnees sont disponibles; modele RF et diagnostics Moran documentes dans le papier/supplement. Promu package_include=yes le 2026-08-15.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready"
  eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
  conditionally_eligible_estimators: []
  ineligible_reason: ""
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 160
- k variables: 44
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-52.85, -31.85], y [-33.3, 4.7]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=21deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`teles_decapod_biodiversity_brazil` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `teles_decapod_biodiversity_brazil` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`teles_decapod_biodiversity_brazil` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Data and R code for: Biogeography and conservation of bycatch decapods

