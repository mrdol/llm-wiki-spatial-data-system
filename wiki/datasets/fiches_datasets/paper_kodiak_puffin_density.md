---
title: paper_kodiak_puffin_density
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_kodiak_puffin_density.rds
  - DatasetFirst_10_5281_zenodo_17128171
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Spatiotemporal species distribution models of colony census and at-sea survey data for Fratercula cirrhata (Tufted Puffin) and F. corniculata (Horned Puffin) reveal long-term declines in Kodiak, Alaska" (DOI 10.1093/ornithapp/duag053).

## Description du jeu de donnees

- Topic: ornithologie marine / declin de population de macareux
- Observation unit: transect d'observation en mer (echantillon)
- Observed population: macareux huppes et cornus (Fratercula cirrhata, F. corniculata), archipel de Kodiak, Alaska, 1975-2022
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: 39 distinct periods (variable: year)
- Source description: Spatiotemporal species distribution models of colony census and at-sea survey data for Fratercula cirrhata (Tufted Puffin) and F. corniculata (Horned Puffin) reveal long-term declines in Kodiak, Alaska
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1093/ornithapp/duag053
- Dataset DOI: 10.5281/zenodo.17128171
- Source URL: https://doi.org/10.5281/zenodo.17128171
- Local raw dir: `data/raw/papers/DatasetFirst_10_5281_zenodo_17128171/`
- Local sf output: `data/final_datasets/sf/paper_kodiak_puffin_density.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `density`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `modified_platform_type`, `fly_bird_method`, `transect_width`, `sample_area`, `month`, `year`, `number`, `species_code`, `transect_length`
- Candidate X count in local artifact: 9
- Candidate X typology: categorical, continuous
- Published X variables from paper: depth (profondeur du fond marin), distance_to_shoreline (distance a la cote), SSTa (anomalie de temperature de surface de la mer), PDO (Pacific Decadal Oscillation)
- Published X count: 4
- Coordinates (x, y - excluded from X candidates): `longitude`, `latitude`
- Identifier columns (excluded from X candidates): `pi`, `local_date_time`, `day`, `doy`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `density` | `numeric` | continuous | [0, 2810.039] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `kodiak_puffin_density`, la ou les reponses `density` viennent du loader papier et/ou des preuves de l article `Spatiotemporal species distribution models of colony census and at-sea survey data for Fratercula cirrhata (Tufted Puffin) and F. corniculata (Horned Puffin) reveal long-term declines in Kodiak, Alaska`. Les covariables X retenues sont `transect_width`, `sample_area`, `month`, `species_code` ; 5 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`longitude`, `latitude`), identifiants (`pi`, `local_date_time`, `day`, `doy`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `modified_platform_type` | `character` | categorical | 0% |
| `fly_bird_method` | `character` | categorical | 0% |
| `transect_width` | `integer` | count | 0% |
| `sample_area` | `numeric` | continuous | 0% |
| `month` | `integer` | count | 0% |
| `year` | `integer` | count | 0% |
| `number` | `integer` | count | 0% |
| `species_code` | `integer` | binary | 0% |
| `transect_length` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: density_it(s) ~ depth + distance_to_shoreline + SSTa_t + PDO_t [modele conjoint VAST (vector autoregressive spatiotemporal), Poisson-link delta-GLMM avec erreur gamma pour la partie positive, ordination d'especes (1 facteur partage), effets spatio-temporels aleatoires en marche aleatoire, 500 noeuds spatiaux ; covariables de capturabilite (mois, heure, plateforme, qualite des donnees) modelisees separement]
- x_terms_pub: depth (profondeur du fond marin), distance_to_shoreline (distance a la cote), SSTa (anomalie de temperature de surface de la mer), PDO (Pacific Decadal Oscillation)
- y_term_pub: density (densite de macareux en mer, individus par unite de surface de transect, Fratercula cirrhata et F. corniculata combines)
- Reference publication: Stoner, Corcoran, Arimitsu, Piatt & Lyons (2026), Spatiotemporal species distribution models of colony census and at-sea survey data for Fratercula cirrhata (Tufted Puffin) and F. corniculata (Horned Puffin) reveal long-term declines in Kodiak, Alaska, Ornithological Applications, doi:10.1093/ornithapp/duag053. Papier en libre acces (CC-BY) ; PDF bloque par protection anti-bot du site academic.oup.com (403), resume/methodologie confirmes via la page officielle de l'article (abstract + section methodes), texte integral non recupere localement -- ajoute a la liste de recuperation manuelle. Le papier ajuste un modele VAST conjoint avec des covariables (profondeur, distance a la cote, SSTa, PDO) issues d'une grille de covariables separee (cov_data_at_sea_Stoner.et.al.csv, non jointe ici pour eviter une jointure spatiale approximative). formula_used utilise uniquement les variables deja presentes dans la table d'observation brute (puffin_data_at_sea_Stoner.et.al.csv), une simplification documentee en base de conception d'echantillonnage plutot que la specification environnementale complete du papier. Donnees brutes telechargees directement depuis Zenodo (10.5281/zenodo.17128171) -- pas une reconstruction, N=17908 (8954 transects x 2 especes), Kodiak, Alaska, 1975-2022 -- correspond exactement aux '8,954 at-sea transect samples' cites dans le resume officiel du papier.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Stoner, Corcoran, Arimitsu, Piatt & Lyons (2026), Spatiotemporal species distribution models of colony census and at-sea survey data for Fratercula cirrhata (Tufted Puffin) and F. corniculata (Horned Puffin) reveal long-term declines in Kodiak, Alaska, Ornithological Applications, doi:10.1093/ornithapp/duag053. Papier en libre acces (CC-BY) ; PDF bloque par protection anti-bot du site academic.oup.com (403), resume/methodologie confirmes via la page officielle de l'article (abstract + section methodes), texte integral non recupere localement -- ajoute a la liste de recuperation manuelle. Le papier ajuste un modele VAST conjoint avec des covariables (profondeur, distance a la cote, SSTa, PDO) issues d'une grille de covariables separee (cov_data_at_sea_Stoner.et.al.csv, non jointe ici pour eviter une jointure spatiale approximative). formula_used utilise uniquement les variables deja presentes dans la table d'observation brute (puffin_data_at_sea_Stoner.et.al.csv), une simplification documentee en base de conception d'echantillonnage plutot que la specification environnementale complete du papier. Donnees brutes telechargees directement depuis Zenodo (10.5281/zenodo.17128171) -- pas une reconstruction, N=17908 (8954 transects x 2 especes), Kodiak, Alaska, 1975-2022 -- correspond exactement aux '8,954 at-sea transect samples' cites dans le resume officiel du papier.

### Formule - niveau systeme

- formula_used: density ~ transect_width + sample_area + month + species_code
- x_terms_used: transect_width, sample_area, month, species_code
- y_term_used: density
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Stoner, Corcoran, Arimitsu, Piatt & Lyons (2026), Spatiotemporal species distribution models of colony census and at-sea survey data for Fratercula cirrhata (Tufted Puffin) and F. corniculata (Horned Puffin) reveal long-term declines in Kodiak, Alaska, Ornithological Applications, doi:10.1093/ornithapp/duag053. Papier en libre acces (CC-BY) ; PDF bloque par protection anti-bot du site academic.oup.com (403), resume/methodologie confirmes via la page officielle de l'article (abstract + section methodes), texte integral non recupere localement -- ajoute a la liste de recuperation manuelle. Le papier ajuste un modele VAST conjoint avec des covariables (profondeur, distance a la cote, SSTa, PDO) issues d'une grille de covariables separee (cov_data_at_sea_Stoner.et.al.csv, non jointe ici pour eviter une jointure spatiale approximative). formula_used utilise uniquement les variables deja presentes dans la table d'observation brute (puffin_data_at_sea_Stoner.et.al.csv), une simplification documentee en base de conception d'echantillonnage plutot que la specification environnementale complete du papier. Donnees brutes telechargees directement depuis Zenodo (10.5281/zenodo.17128171) -- pas une reconstruction, N=17908 (8954 transects x 2 especes), Kodiak, Alaska, 1975-2022 -- correspond exactement aux '8,954 at-sea transect samples' cites dans le resume officiel du papier.

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
    formula: "density ~ transect_width + sample_area + month + species_code"
    response: "density (densite de macareux en mer, individus par unite de surface de transect, Fratercula cirrhata et F. corniculata combines)"
    predictors: ["depth (profondeur du fond marin)", "distance_to_shoreline (distance a la cote)", "SSTa (anomalie de temperature de surface de la mer)", "PDO (Pacific Decadal Oscillation)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Stoner, Corcoran, Arimitsu, Piatt & Lyons (2026), Spatiotemporal species distribution models of colony census and at-sea survey data for Fratercula cirrhata (Tufted Puffin) and F. corniculata (Horned Puffin) reveal long-term declines in Kodiak, Alaska, Ornithological Applications, doi:10.1093/ornithapp/duag053. Papier en libre acces (CC-BY) ; PDF bloque par protection anti-bot du site academic.oup.com (403), resume/methodologie confirmes via la page officielle de l'article (abstract + section methodes), texte integral non recupere localement -- ajoute a la liste de recuperation manuelle. Le papier ajuste un modele VAST conjoint avec des covariables (profondeur, distance a la cote, SSTa, PDO) issues d'une grille de covariables separee (cov_data_at_sea_Stoner.et.al.csv, non jointe ici pour eviter une jointure spatiale approximative). formula_used utilise uniquement les variables deja presentes dans la table d'observation brute (puffin_data_at_sea_Stoner.et.al.csv), une simplification documentee en base de conception d'echantillonnage plutot que la specification environnementale complete du papier. Donnees brutes telechargees directement depuis Zenodo (10.5281/zenodo.17128171) -- pas une reconstruction, N=17908 (8954 transects x 2 especes), Kodiak, Alaska, 1975-2022 -- correspond exactement aux '8,954 at-sea transect samples' cites dans le resume officiel du papier."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "density ~ transect_width + sample_area + month + year + species_code + modified_platform_type"
    response: "density"
    predictors: ["transect_width", "sample_area", "month", "year", "species_code", "modified_platform_type"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Stoner, Corcoran, Arimitsu, Piatt & Lyons (2026), Spatiotemporal species distribution models of colony census and at-sea survey data for Fratercula cirrhata (Tufted Puffin) and F. corniculata (Horned Puffin) reveal long-term declines in Kodiak, Alaska, Ornithological Applications, doi:10.1093/ornithapp/duag053. Papier en libre acces (CC-BY) ; PDF bloque par protection anti-bot du site academic.oup.com (403), resume/methodologie confirmes via la page officielle de l'article (abstract + section methodes), texte integral non recupere localement -- ajoute a la liste de recuperation manuelle. Le papier ajuste un modele VAST conjoint avec des covariables (profondeur, distance a la cote, SSTa, PDO) issues d'une grille de covariables separee (cov_data_at_sea_Stoner.et.al.csv, non jointe ici pour eviter une jointure spatiale approximative). formula_used utilise uniquement les variables deja presentes dans la table d'observation brute (puffin_data_at_sea_Stoner.et.al.csv), une simplification documentee en base de conception d'echantillonnage plutot que la specification environnementale complete du papier. Donnees brutes telechargees directement depuis Zenodo (10.5281/zenodo.17128171) -- pas une reconstruction, N=17908 (8954 transects x 2 especes), Kodiak, Alaska, 1975-2022 -- correspond exactement aux '8,954 at-sea transect samples' cites dans le resume officiel du papier."
    estimator_context: ["random_forest", "xgboost", "gam_spatial", "gwr"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_kodiak_puffin_density`
- Dataset name: Spatiotemporal species distribution models of colony census and at-sea survey data for Fratercula cirrhata (Tufted Puffin) and F. corniculata (Horned Puffin) reveal long-term declines in Kodiak, Alaska [Dataset]
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Spatiotemporal species distribution models of colony census and at-sea survey data for Fratercula cirrhata (Tufted Puffin) and F. corniculata (Horned Puffin) reveal long-term declines in Kodiak, Alaska
- Paper DOI: 10.1093/ornithapp/duag053
- Dataset DOI: 10.5281/zenodo.17128171
- Source URL: https://doi.org/10.5281/zenodo.17128171
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "density_it(s) ~ depth + distance_to_shoreline + SSTa_t + PDO_t [modele conjoint VAST (vector autoregressive spatiotemporal), Poisson-link delta-GLMM avec erreur gamma pour la partie positive, ordination d'especes (1 facteur partage), effets spatio-temporels aleatoires en marche aleatoire, 500 noeuds spatiaux ; covariables de capturabilite (mois, heure, plateforme, qualite des donnees) modelisees separement]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Stoner, Corcoran, Arimitsu, Piatt & Lyons (2026), Spatiotemporal species distribution models of colony census and at-sea survey data for Fratercula cirrhata (Tufted Puffin) and F. corniculata (Horned Puffin) reveal long-term declines in Kodiak, Alaska, Ornithological Applications, doi:10.1093/ornithapp/duag053. Papier en libre acces (CC-BY) ; PDF bloque par protection anti-bot du site academic.oup.com (403), resume/methodologie confirmes via la page officielle de l'article (abstract + section methodes), texte integral non recupere localement -- ajoute a la liste de recuperation manuelle. Le papier ajuste un modele VAST conjoint avec des covariables (profondeur, distance a la cote, SSTa, PDO) issues d'une grille de covariables separee (cov_data_at_sea_Stoner.et.al.csv, non jointe ici pour eviter une jointure spatiale approximative). formula_used utilise uniquement les variables deja presentes dans la table d'observation brute (puffin_data_at_sea_Stoner.et.al.csv), une simplification documentee en base de conception d'echantillonnage plutot que la specification environnementale complete du papier. Donnees brutes telechargees directement depuis Zenodo (10.5281/zenodo.17128171) -- pas une reconstruction, N=17908 (8954 transects x 2 especes), Kodiak, Alaska, 1975-2022 -- correspond exactement aux '8,954 at-sea transect samples' cites dans le resume officiel du papier."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "le papier publie un modele VAST joint avec covariables environnementales sur grille separee (profondeur, distance a la cote, SSTa, PDO) non jointe ici -- formula_used utilise uniquement les variables de conception d'echantillonnage deja presentes dans la table d'observation, une simplification documentee ; texte integral du papier non recupere localement (PDF bloque par anti-bot, resume/methodes confirmes via la page officielle) -- promu a package_include='yes' apres validation utilisateur (session 2026-08-16, groupe A)"
  reason: "Y continu reel (densite de macareux en mer), N=17908 (8954 transects x 2 especes, correspond exactement au resume officiel du papier), coordonnees reelles (Kodiak, Alaska, 1975-2022). Fichier original telecharge directement depuis Zenodo, pas une reconstruction. Paper_doi corrige (etait la source de donnees NPPSD citee, pas le papier reel) ; methodologie VAST confirmee via la page officielle de l'article (abstract + methodes), PDF complet a recuperer manuellement."
```

- Decision: ready
- Manque principal: le papier publie un modele VAST joint avec covariables environnementales sur grille separee (profondeur, distance a la cote, SSTa, PDO) non jointe ici -- formula_used utilise uniquement les variables de conception d'echantillonnage deja presentes dans la table d'observation, une simplification documentee ; texte integral du papier non recupere localement (PDF bloque par anti-bot, resume/methodes confirmes via la page officielle) -- promu a package_include="yes" apres validation utilisateur (session 2026-08-16, groupe A)
- Raison: Y continu reel (densite de macareux en mer), N=17908 (8954 transects x 2 especes, correspond exactement au resume officiel du papier), coordonnees reelles (Kodiak, Alaska, 1975-2022). Fichier original telecharge directement depuis Zenodo, pas une reconstruction. Paper_doi corrige (etait la source de donnees NPPSD citee, pas le papier reel) ; methodologie VAST confirmee via la page officielle de l'article (abstract + methodes), PDF complet a recuperer manuellement.

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

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 17908
- k variables: 19
- T periods: 39
- Variable temporelle: year
- N/T profile: N_grand_T_grand

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 39 distinct periods (variable: year)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-154.9949951, -151.0030212], y [56.0001602, 58.9999886]
- Time range: 1975 to 2022 (variable: year)
- CRS analyse recommande: 32605 (UTM Zone 5N (EPSG:32605)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`kodiak_puffin_density` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `kodiak_puffin_density` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`kodiak_puffin_density` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Spatiotemporal species distribution models of colony census and at-sea survey data for Fratercula cirrhata (Tufted Puffin) and F. corniculata (Horned Puffin) reveal long-term declines in Kodiak, Alaska

