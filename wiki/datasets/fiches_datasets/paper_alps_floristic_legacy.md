---
title: paper_alps_floristic_legacy
type: dataset
created: 2026-09-14
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_alps_floristic_legacy.rds
  - DatasetFirst_10_5061_dryad_w9ghx3g12
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "The Limited Legacy of Post-Glacial Recolonization in the Floristic Patterns of the European Alps" (DOI 10.1600/036364425x17466502618876).

## Description du jeu de donnees

- Topic: biogeographie / heritage glaciaire de la flore alpine
- Observation unit: cellule de grille
- Observed population: flore vasculaire des Alpes europeennes, N=509 cellules
- Geographic context: Etendue mesuree dans le RDS : x [5.0445002, 15.6342734], y [43.7220926, 48.0024233]; CRS EPSG:4326.
- Temporal context: none (cross-sectional)
- Source description: The Limited Legacy of Post-Glacial Recolonization in the Floristic Patterns of the European Alps
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: high
- Paper DOI: 10.1600/036364425x17466502618876
- Dataset DOI: 10.5061/dryad.w9ghx3g12
- Source URL: https://doi.org/10.5061/dryad.w9ghx3g12
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_w9ghx3g12/`
- Local sf output: `data/final_datasets/sf/paper_alps_floristic_legacy.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Standardised_SR`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Elev_mean`, `Elev_sd`, `Slope_deg`, `Precip_total`, `Nunatak_distance`, `Periph_refugia_distance`, `Refugia_distance_all`, `Deglac`, `Temp_annual`, `Paleo_temp`, `Pet`, `Velocity_med`, `Bedrock_class`, `n`, `S.obs`, `SC`, `Tamme_mean`, `n_tamme`, `Ses_pd`, `Phylo_endem`
- Candidate X count in local artifact: 20
- Candidate X typology: continuous, categorical, unknown
- Published X variables from paper: Refugia_distance_all (distance au refuge glaciaire le plus proche, nunatak OU peripherique), Velocity_med (vitesse de changement climatique depuis le LGM, VoCC)
- Published X count: 2
- Coordinates (x, y - excluded from X candidates): `coords.X`, `coords.Y`
- Identifier columns (excluded from X candidates): `Code`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Standardised_SR` | `numeric` | continuous | [46.5, 891.67] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `alps_floristic_legacy`, la ou les reponses `Standardised_SR` viennent du loader papier et/ou des preuves de l article `The Limited Legacy of Post-Glacial Recolonization in the Floristic Patterns of the European Alps`. Les covariables X retenues sont `Refugia_distance_all`, `Velocity_med` ; 18 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`coords.X`, `coords.Y`), identifiants (`Code`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Elev_mean` | `numeric` | continuous | 0% |
| `Elev_sd` | `numeric` | continuous | 0% |
| `Slope_deg` | `numeric` | continuous | 0% |
| `Precip_total` | `numeric` | continuous | 0% |
| `Nunatak_distance` | `numeric` | continuous | 0% |
| `Periph_refugia_distance` | `numeric` | continuous | 0% |
| `Refugia_distance_all` | `numeric` | continuous | 0% |
| `Deglac` | `numeric` | continuous | 0% |
| `Temp_annual` | `numeric` | continuous | 0% |
| `Paleo_temp` | `numeric` | continuous | 0% |
| `Pet` | `numeric` | continuous | 0% |
| `Velocity_med` | `numeric` | continuous | 0% |
| `Bedrock_class` | `character` | categorical | 0% |
| `n` | `integer` | unknown | 0% |
| `S.obs` | `integer` | unknown | 0% |
| `SC` | `numeric` | rate | 0% |
| `Tamme_mean` | `numeric` | continuous | 0% |
| `n_tamme` | `integer` | unknown | 0% |
| `Ses_pd` | `numeric` | continuous | 0% |
| `Phylo_endem` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: Standardised_SR ~ Refugia_distance_all + Velocity_med [SAR, lagsarlm]
- x_terms_pub: Refugia_distance_all (distance au refuge glaciaire le plus proche, nunatak OU peripherique), Velocity_med (vitesse de changement climatique depuis le LGM, VoCC)
- y_term_pub: Standardised_SR (richesse specifique standardisee a 95% de completude d'echantillonnage, via rarefaction iNEXT::estimateD() -- PAS S.obs, richesse brute observee, non corrigee de l'effort d'echantillonnage variable)
- Reference publication: Wootton, Boucher, Renaud, Valla, Midolo, Lososova, Thuiller & Lavergne (2025), The Limited Legacy of Post-Glacial Recolonization in the Floristic Patterns of the European Alps, Systematic Botany 50(1):83-98, DOI 10.1600/036364425X17466502618876. CORRECTION (2026-09-10) : papier obtenu et lu integralement (l'utilisateur a telecharge le PDF, traite via GROBID/KG 2026-09-10 ; aucune version locale n'existait avant, la fiche precedente affirmait a tort 'formule verifiee par lecture directe du papier' avec Statut=resolu alors que inst/kg/paper_dataset_uses.json montrait local_pdf={}/local_tei={}/formula=null/ingestion_status='raw_data_downloaded_pending_loader' -- jamais lu). Table 1 (verifiee, page 47 du PDF) confirme que le modele SAR retenu pour la richesse specifique standardisee n'utilise QUE 2 predicteurs -- distance au refuge le plus proche et vitesse de changement climatique -- PAS Deglac (temps depuis deglaciation, contrairement a une phrase du texte page 21 qui semble erronee/contredite par sa propre Table 1 et par la phrase suivante du meme papier), PAS de variables climatiques contemporaines (Temp_annual/Precip_total/Pet) ni de landscape (Elev_sd/Bedrock_class) : ces dernieres n'apparaissent que dans une analyse SEPAREE de partitionnement de variance (vegan::varpart(), pas une formule de regression). Echantillon : grille Alpine 10x10km (n=1611 cellules initiales, GMBA v2) filtree a >=95% de completude d'echantillonnage et >=250 observations (-1088 cellules), puis exclusion des cellules jamais englacees au dernier cycle glaciaire (-14) = 509 cellules, EXACTEMENT N=509 confirme sur le .rds local. W construit sur 'tous les voisins de chaque cellule de grille' (contigue, pas kNN). Le papier appelle sa methode 'spatial simultaneous autoregressive ERROR modelling approach (SAR)' tout en utilisant lagsarlm() (fonction LAG de spatialreg, pas errorsarlm()) -- ambiguite terminologique du papier lui-meme, non resolue par le texte, mappee ici sur sar_lag (fonction R explicitement citee, signal le plus fiable). Donnees brutes (Supplementary_data_legacy.csv) telechargees directement depuis Dryad (10.5061/dryad.w9ghx3g12) -- pas une reconstruction. R2 note : le modele lineaire de base n'explique que 9% de la variance de la richesse specifique (bien moins que pour les 3 autres indices du papier, 31-45%) -- attente de performance faible a documenter pour le benchmark. Correspondance Y/X revérifiée (2026-09-10, question explicite de l'utilisateur) contre le README des auteurs (data/raw/papers/DatasetFirst_10_5061_dryad_w9ghx3g12/README.md, dictionnaire de donnees Dryad) : confirme 'Refugia_distance_all = distance to the closest refugium whether nunatak of peripheral (km)', 'Velocity_med = median value of climate change velocity (km/ky)', 'Standardised_SR = standardised species richness' (distinct de 'S.obs = observed number of species') -- source primaire independante du texte de l'article, qui accorde le nom de colonne mais pas necessairement la methode de calcul detaillee (rarefaction iNEXT a 95% de completude, decrite uniquement dans le texte p.11-12, pas dans ce README).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Wootton et al. (2025), Systematic Botany 50(1):83-98, Table 1 : W='all neighbours of each grid cell', effets totaux verifies -- distance aux refuges=-7.43 (p<0.001), vitesse de changement climatique=131.16 (p<0.001) ; regression lineaire de base + confirmation SAR car Moran's I detecte une autocorrelation spatiale residuelle.

### Formule - niveau systeme

- formula_used: Standardised_SR ~ Refugia_distance_all + Velocity_med
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: Refugia_distance_all, Velocity_med
- y_term_used: Standardised_SR
- Note: Wootton et al. (2025), Systematic Botany 50(1):83-98, Table 1 : W='all neighbours of each grid cell', effets totaux verifies -- distance aux refuges=-7.43 (p<0.001), vitesse de changement climatique=131.16 (p<0.001) ; regression lineaire de base + confirmation SAR car Moran's I detecte une autocorrelation spatiale residuelle.

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
    formula: "Standardised_SR ~ Refugia_distance_all + Velocity_med"
    response: "Standardised_SR (richesse specifique standardisee a 95% de completude d'echantillonnage, via rarefaction iNEXT::estimateD() -- PAS S.obs, richesse brute observee, non corrigee de l'effort d'echantillonnage variable)"
    predictors: ["Refugia_distance_all (distance au refuge glaciaire le plus proche, nunatak OU peripherique)", "Velocity_med (vitesse de changement climatique depuis le LGM, VoCC)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "Standardised_SR ~ Refugia_distance_all + Velocity_med + Deglac + Temp_annual + Precip_total + Pet + Elev_sd + Bedrock_class"
    response: "Standardised_SR"
    predictors: ["Refugia_distance_all", "Velocity_med", "Deglac", "Temp_annual", "Precip_total", "Pet", "Elev_sd", "Bedrock_class"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "gam_spatial", "random_forest", "gwr"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_alps_floristic_legacy`
- Dataset name: Data from: The limited legacy of post-glacial recolonization in the floristic patterns of the European Alps
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: The Limited Legacy of Post-Glacial Recolonization in the Floristic Patterns of the European Alps
- Paper DOI: 10.1600/036364425x17466502618876
- Dataset DOI: 10.5061/dryad.w9ghx3g12
- Source URL: https://doi.org/10.5061/dryad.w9ghx3g12
- Year: 2025

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Standardised_SR ~ Refugia_distance_all + Velocity_med [SAR, lagsarlm]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Wootton, Boucher, Renaud, Valla, Midolo, Lososova, Thuiller & Lavergne (2025), The Limited Legacy of Post-Glacial Recolonization in the Floristic Patterns of the European Alps, Systematic Botany 50(1):83-98, DOI 10.1600/036364425X17466502618876. CORRECTION (2026-09-10) : papier obtenu et lu integralement (l'utilisateur a telecharge le PDF, traite via GROBID/KG 2026-09-10 ; aucune version locale n'existait avant, la fiche precedente affirmait a tort 'formule verifiee par lecture directe du papier' avec Statut=resolu alors que inst/kg/paper_dataset_uses.json montrait local_pdf={}/local_tei={}/formula=null/ingestion_status='raw_data_downloaded_pending_loader' -- jamais lu). Table 1 (verifiee, page 47 du PDF) confirme que le modele SAR retenu pour la richesse specifique standardisee n'utilise QUE 2 predicteurs -- distance au refuge le plus proche et vitesse de changement climatique -- PAS Deglac (temps depuis deglaciation, contrairement a une phrase du texte page 21 qui semble erronee/contredite par sa propre Table 1 et par la phrase suivante du meme papier), PAS de variables climatiques contemporaines (Temp_annual/Precip_total/Pet) ni de landscape (Elev_sd/Bedrock_class) : ces dernieres n'apparaissent que dans une analyse SEPAREE de partitionnement de variance (vegan::varpart(), pas une formule de regression). Echantillon : grille Alpine 10x10km (n=1611 cellules initiales, GMBA v2) filtree a >=95% de completude d'echantillonnage et >=250 observations (-1088 cellules), puis exclusion des cellules jamais englacees au dernier cycle glaciaire (-14) = 509 cellules, EXACTEMENT N=509 confirme sur le .rds local. W construit sur 'tous les voisins de chaque cellule de grille' (contigue, pas kNN). Le papier appelle sa methode 'spatial simultaneous autoregressive ERROR modelling approach (SAR)' tout en utilisant lagsarlm() (fonction LAG de spatialreg, pas errorsarlm()) -- ambiguite terminologique du papier lui-meme, non resolue par le texte, mappee ici sur sar_lag (fonction R explicitement citee, signal le plus fiable). Donnees brutes (Supplementary_data_legacy.csv) telechargees directement depuis Dryad (10.5061/dryad.w9ghx3g12) -- pas une reconstruction. R2 note : le modele lineaire de base n'explique que 9% de la variance de la richesse specifique (bien moins que pour les 3 autres indices du papier, 31-45%) -- attente de performance faible a documenter pour le benchmark. Correspondance Y/X revérifiée (2026-09-10, question explicite de l'utilisateur) contre le README des auteurs (data/raw/papers/DatasetFirst_10_5061_dryad_w9ghx3g12/README.md, dictionnaire de donnees Dryad) : confirme 'Refugia_distance_all = distance to the closest refugium whether nunatak of peripheral (km)', 'Velocity_med = median value of climate change velocity (km/ky)', 'Standardised_SR = standardised species richness' (distinct de 'S.obs = observed number of species') -- source primaire independante du texte de l'article, qui accorde le nom de colonne mais pas necessairement la methode de calcul detaillee (rarefaction iNEXT a 95% de completude, decrite uniquement dans le texte p.11-12, pas dans ce README)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun -- CSV original telecharge directement depuis Dryad, N=509 cellules identique au depot source ; formule desormais verifiee contre Table 1 du papier (2026-09-10, papier obtenu et lu -- corrige un blocage precedent ou aucun PDF/TEI local n'existait)"
  reason: "Y continu reel (richesse specifique standardisee a 95% de completude), N=509 cellules avec coordonnees reelles (Alpes europeennes), covariables (distance au refuge le plus proche, vitesse de changement climatique) exactement celles du modele SAR retenu par les auteurs (Table 1, R2 faible=9% documente). CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier obtenu (2026-09-10) et verifie integralement -- corrige un cas ou la fiche precedente affirmait une verification qui n'avait jamais eu lieu."
```

- Decision: ready
- Manque principal: aucun -- CSV original telecharge directement depuis Dryad, N=509 cellules identique au depot source ; formule desormais verifiee contre Table 1 du papier (2026-09-10, papier obtenu et lu -- corrige un blocage precedent ou aucun PDF/TEI local n'existait)
- Raison: Y continu reel (richesse specifique standardisee a 95% de completude), N=509 cellules avec coordonnees reelles (Alpes europeennes), covariables (distance au refuge le plus proche, vitesse de changement climatique) exactement celles du modele SAR retenu par les auteurs (Table 1, R2 faible=9% documente). CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier obtenu (2026-09-10) et verifie integralement -- corrige un cas ou la fiche precedente affirmait une verification qui n'avait jamais eu lieu.

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
- N observations: 509
- k variables: 26
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [5.0445002, 15.6342734], y [43.7220926, 48.0024233]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32632 (UTM Zone 32N (EPSG:32632)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal (CC0 1.0)
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.w9ghx3g12 (checked 2026-09-10): rightsList = 'Creative Commons Zero v1.0 Universal (CC0 1.0)'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`alps_floristic_legacy` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `alps_floristic_legacy` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`alps_floristic_legacy` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: The Limited Legacy of Post-Glacial Recolonization in the Floristic Patterns of the European Alps

## Curation documentée — 2026-09-07

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
