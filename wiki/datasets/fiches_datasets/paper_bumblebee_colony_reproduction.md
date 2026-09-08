---
title: paper_bumblebee_colony_reproduction
type: dataset
created: 2026-08-15
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_bumblebee_colony_reproduction.rds
  - DataCite_2018_LowerBumblebeeColonyReproductive_10_1098_rspb_201
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Lower bumblebee colony reproductive success in agricultural compared with urban environments" (DOI 10.1098/rspb.2018.0807).

## Description du jeu de donnees

- Topic: ecologie / interactions plantes-pollinisateurs
- Observation unit: site d'observation ou cellule de grille d'occurrence
- Observed population: communautes de pollinisateurs ou d'oiseaux nectarivores
- Geographic context: etendue sf: x [-1.2065639, -0.0407438], y [51.1083416, 51.5933662]
- Temporal context: none (cross-sectional)
- Source description: Lower bumblebee colony reproductive success in agricultural compared with urban environments
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1098/rspb.2018.0807
- Dataset DOI: 10.5061/dryad.c68cj62
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.c68cj62
- Local raw dir: `data/raw/papers/DataCite_2018_LowerBumblebeeColonyReproductive_10_1098_rspb_201/`
- Local sf output: `data/final_datasets/sf/paper_bumblebee_colony_reproduction.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Tot_rep`, `Countave`, `Tot_male`, `Tot_gyne`
- Candidate Y typology: count, continuous
- Candidate X variables in local artifact: `Crith_suc`, `Apic_suc`, `Crith_fail`, `Apic_fail`, `Syntretus`, `Crithidia`, `Apicystis`, `Tot_cuck`, `Cu_bin`, `Bin_rep`, `G_thorave`, `G_wmass`, `G_dmass`, `M_thorave`, `M_wmass`, `M_dmass`, `Q_week`, `Q_died`, `Col_death_week`, `Col_status`, `Rep_wk`, `Rep_status`, `Ave_temp`, `Ave_hum`, `Sum_prec`, `Prop_flower100`, `Prop_flower250`, `Prop_flower500`, `Prop_flower750`, `Prop_imp500`, `Prop_flower500.1`, `Prop_urb500`, `Prop_open500`, `Prop_tree500`, `Prop_ag500`, `Prop_gard500`, `Prop_road500`, `X750PC1`, `X750PC2`, `X500PC1`, `X500PC2`, `X250PC1`, `X250PC2`, `X100PC1`, `X100PC2`, `X100PC3`
- Candidate X count in local artifact: 46
- Candidate X typology: continuous, categorical
- Published X variables from paper: temperature, humidity, precipitation, flower cover, impervious surface, urban cover, open cover, tree cover, agricultural cover, garden cover, road cover, land-use PCA axes
- Published X count: 12
- Coordinates (x, y - excluded from X candidates): `longitude`, `latitude`, `Lat`, `Lon`
- Identifier columns (excluded from X candidates): `Col`, `Site`, `LU750`, `LU500`, `LU250`, `LU100`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Tot_rep` | `integer` | count | [0, 79] | 0% |
| `Countave` | `numeric` | continuous | [9.5, 140.6667] | 0% |
| `Tot_male` | `integer` | count | [0, 71] | 0% |
| `Tot_gyne` | `integer` | count | [0, 19] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `bumblebee_colony_reproduction`, la ou les reponses `Tot_rep`, `Countave`, `Tot_male`, `Tot_gyne` viennent du loader papier et/ou des preuves de l article `Lower bumblebee colony reproductive success in agricultural compared with urban environments`. Les covariables X retenues sont `Ave_temp`, `Ave_hum`, `Sum_prec`, `Prop_flower500`, `Prop_imp500`, `Prop_urb500`, `Prop_open500`, `Prop_tree500`, `Prop_ag500`, `Prop_gard500`, `Prop_road500`, `X500PC1`, `X500PC2` ; 33 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`longitude`, `latitude`, `Lat`, `Lon`), identifiants (`Col`, `Site`, `LU750`, `LU500`, `LU250`, `LU100`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : manual_review; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Crith_suc` | `integer` | count | 10.5% |
| `Apic_suc` | `integer` | count | 10.5% |
| `Crith_fail` | `integer` | count | 10.5% |
| `Apic_fail` | `integer` | count | 10.5% |
| `Syntretus` | `integer` | binary | 10.5% |
| `Crithidia` | `integer` | binary | 10.5% |
| `Apicystis` | `integer` | binary | 10.5% |
| `Tot_cuck` | `numeric` | continuous | 0% |
| `Cu_bin` | `integer` | binary | 0% |
| `Bin_rep` | `integer` | binary | 0% |
| `G_thorave` | `numeric` | continuous | 84.2% |
| `G_wmass` | `numeric` | continuous | 5.3% |
| `G_dmass` | `numeric` | continuous | 5.3% |
| `M_thorave` | `numeric` | continuous | 31.6% |
| `M_wmass` | `numeric` | continuous | 0% |
| `M_dmass` | `numeric` | continuous | 0% |
| `Q_week` | `numeric` | continuous | 0% |
| `Q_died` | `integer` | binary | 0% |
| `Col_death_week` | `numeric` | continuous | 0% |
| `Col_status` | `integer` | binary | 0% |
| `Rep_wk` | `numeric` | continuous | 0% |
| `Rep_status` | `integer` | binary | 0% |
| `Ave_temp` | `numeric` | continuous | 0% |
| `Ave_hum` | `numeric` | continuous | 0% |
| `Sum_prec` | `numeric` | continuous | 0% |
| `Prop_flower100` | `numeric` | rate | 0% |
| `Prop_flower250` | `numeric` | rate | 0% |
| `Prop_flower500` | `numeric` | rate | 0% |
| `Prop_flower750` | `numeric` | rate | 0% |
| `Prop_imp500` | `numeric` | rate | 0% |
| `Prop_flower500.1` | `numeric` | rate | 0% |
| `Prop_urb500` | `numeric` | rate | 0% |
| `Prop_open500` | `numeric` | rate | 0% |
| `Prop_tree500` | `numeric` | rate | 0% |
| `Prop_ag500` | `numeric` | rate | 0% |
| `Prop_gard500` | `numeric` | rate | 0% |
| `Prop_road500` | `numeric` | rate | 0% |
| `X750PC1` | `numeric` | continuous | 0% |
| `X750PC2` | `numeric` | continuous | 0% |
| `X500PC1` | `numeric` | continuous | 0% |
| `X500PC2` | `numeric` | continuous | 0% |
| `X250PC1` | `numeric` | continuous | 0% |
| `X250PC2` | `numeric` | continuous | 0% |
| `X100PC1` | `numeric` | continuous | 0% |
| `X100PC2` | `numeric` | continuous | 0% |
| `X100PC3` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: colony reproductive output ~ weather + floral cover + urban/land-use metrics [GLM/GLMM model-selection context]
- x_terms_pub: temperature, humidity, precipitation, flower cover, impervious surface, urban cover, open cover, tree cover, agricultural cover, garden cover, road cover, land-use PCA axes
- y_term_pub: colony reproductive output: total males plus gynes produced
- Reference publication: Samuelson et al. (2018), Proceedings B, DOI 10.1098/rspb.2018.0807: colony-level reproductive success is analysed against local floral resources, land use and weather covariates. The raw ColonyData table contains the response and covariates; Lat/Lon labels are numerically inverted for southern England and are corrected in the loader.
- Correction (2026-09-08, lecture TEI approfondie) : le papier modelise "Total production of sexuals" par un **hurdle model binomial-negatif zero-altere** (partie binaire presence/absence + partie comptage tronquee a zero), pas un GLM/GLMM simple -- "Total production of sexuals... was analysed using zero-altered negative binomial hurdle models". Le predicteur d'occupation du sol est aussi different : les auteurs regroupent 80 classes d'occupation du sol en 3 clusters categoriels ("city"/"village"/"agricultural" par PCA+Ward), alors que `formula_used` utilise les proportions individuelles (Prop_flower500, Prop_imp500, etc.) et des composantes PC comme predicteurs lineaires simultanes -- combinaison non testee telle quelle dans le papier. formula_status reste `reconstructed_from_data`, pas `pub`.

### Statut regression canonique

- Statut: mis de cote
- Niveau de preuve: publication
- Methode d estimation: formule adaptee/reconstruite a partir des variables du depot -- ne reproduit PAS la methode exacte du papier (voir correction 2026-09-08)
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: Tot_rep ~ Ave_temp + Ave_hum + Sum_prec + Prop_flower500 + Prop_imp500 + Prop_urb500 + Prop_open500 + Prop_tree500 + Prop_ag500 + Prop_gard500 + Prop_road500 + X500PC1 + X500PC2
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: count
- x_terms_used: Ave_temp, Ave_hum, Sum_prec, Prop_flower500, Prop_imp500, Prop_urb500, Prop_open500, Prop_tree500, Prop_ag500, Prop_gard500, Prop_road500, X500PC1, X500PC2
- y_term_used: Tot_rep
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
    formula: "Tot_rep ~ weather + floral cover + land-use composition around colony sites"
    response: "colony reproductive output: total males plus gynes produced"
    predictors: ["temperature", "humidity", "precipitation", "flower cover", "impervious surface", "urban cover", "open cover", "tree cover", "agricultural cover", "garden cover", "road cover", "land-use PCA axes"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
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

- Dataset ID: `paper_bumblebee_colony_reproduction`
- Dataset name: Data from: Lower bumblebee colony reproductive success in agricultural compared to urban environments
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Lower bumblebee colony reproductive success in agricultural compared with urban environments
- Paper DOI: 10.1098/rspb.2018.0807
- Dataset DOI: 10.5061/dryad.c68cj62
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.c68cj62
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "colony reproductive output ~ weather + floral cover + urban/land-use metrics [GLM/GLMM model-selection context]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Samuelson et al. (2018), Proceedings B, DOI 10.1098/rspb.2018.0807: colony-level reproductive success is analysed against local floral resources, land use and weather covariates. The raw ColonyData table contains the response and covariates; Lat/Lon labels are numerically inverted for southern England and are corrected in the loader."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "manual_review"
  benchmark_task: "review_count"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "DECISION UTILISATEUR (2026-09-08) : option (b) -- mis de cote explicitement. La methode publiee (hurdle model binomial-negatif zero-altere, predicteur categoriel par clustering PCA+Ward) n'a pas d'equivalent dans le harnais actuel (aucun estimateur hurdle/zero-inflate n'existe dans le registre). N=38 colonies est de toute facon tres petit pour un benchmark spatial fiable. En attente d'un futur chantier d'extension du harnais (nouvel estimateur hurdle/zero-inflated count). formula_used reste documente comme adaptation, pas une reproduction du papier -- ne pas promouvoir package_include=yes avant cette extension."
  reason: "DECISION UTILISATEUR (2026-09-08) : option (b) -- mis de cote explicitement. La methode publiee (hurdle model binomial-negatif zero-altere, predicteur categoriel par clustering PCA+Ward) n'a pas d'equivalent dans le harnais actuel (aucun estimateur hurdle/zero-inflate n'existe dans le registre). N=38 colonies est de toute facon tres petit pour un benchmark spatial fiable. En attente d'un futur chantier d'extension du harnais (nouvel estimateur hurdle/zero-inflated count). formula_used reste documente comme adaptation, pas une reproduction du papier -- ne pas promouvoir package_include=yes avant cette extension."
```

- Decision: manual_review
- Manque principal: Mis de cote (option b, decision utilisateur 2026-09-08) -- voir estimator_eligibility.
- Raison: DECISION UTILISATEUR (2026-09-08) : option (b) -- mis de cote explicitement. La methode publiee (hurdle model binomial-negatif zero-altere, predicteur categoriel par clustering PCA+Ward) n'a pas d'equivalent dans le harnais actuel (aucun estimateur hurdle/zero-inflate n'existe dans le registre). N=38 colonies est de toute facon tres petit pour un benchmark spatial fiable. En attente d'un futur chantier d'extension du harnais (nouvel estimateur hurdle/zero-inflated count). formula_used reste documente comme adaptation, pas une reproduction du papier -- ne pas promouvoir package_include=yes avant cette extension.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "DECISION UTILISATEUR (2026-09-08) : option (b) -- mis de cote explicitement. La methode publiee (hurdle model binomial-negatif zero-altere, predicteur categoriel par clustering PCA+Ward) n'a pas d'equivalent dans le harnais actuel (aucun estimateur hurdle/zero-inflate n'existe dans le registre). N=38 colonies est de toute facon tres petit pour un benchmark spatial fiable. En attente d'un futur chantier d'extension du harnais (nouvel estimateur hurdle/zero-inflated count). formula_used reste documente comme adaptation, pas une reproduction du papier -- ne pas promouvoir package_include=yes avant cette extension."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 38
- k variables: 62
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_petit_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-1.2065639, -0.0407438], y [51.1083416, 51.5933662]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32630 (UTM Zone 30N (EPSG:32630)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.c68cj62 (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`bumblebee_colony_reproduction` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `bumblebee_colony_reproduction` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20%: G_thorave (NA=84.2%), M_thorave (NA=31.6%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`bumblebee_colony_reproduction` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Lower bumblebee colony reproductive success in agricultural compared with urban environments

## Curation documentée — 2026-09-07

Decision conservatoire : Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : count. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
