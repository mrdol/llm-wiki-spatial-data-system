---
title: paper_wang_henan_cultivated_land_quality
type: dataset
created: 2026-08-09
updated: 2026-08-10
sources:
  - data/final_datasets/sf/DataCite_2022_ModelingOfSpatialPattern_10_1371_journal_.gpkg
  - DataCite_2022_ModelingOfSpatialPattern_10_1371_journal_
  - corpus/papers/tei/Modeling of spatial pattern and influencing factors of cultivated land quality in Henan Province based on spatial big data.tei.xml
tags: [dataset, paper-derived, spatial, polygon]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Modeling of spatial pattern and influencing factors of cultivated land quality in Henan Province based on spatial big data" (DOI 10.1371/journal.pone.0265613).

## Description du jeu de donnees

- Topic: geographie agricole / qualite des terres cultivees et facteurs d'influence spatiale dans la province du Henan (Chine)
- Observation unit: comte (xian/qu) de la province du Henan
- Observed population: comtes du Henan, 143 sur 159 comtes officiels (voir avertissement ci-dessous)
- Geographic context: province du Henan, Chine (voir Bloc 5)
- Temporal context: coupe transversale
- Source description: le papier calcule un indice de qualite des terres cultivees par comte (moyenne ponderee par la surface des cantons/townships, eqn 1), normalise (eqn 2), puis analyse l'autocorrelation spatiale globale et locale (Moran's I, eqn 3-5) et modelise les facteurs d'influence via un modele d'autoregression spatiale
- Description source: corpus/papers/tei/Modeling of spatial pattern and influencing factors of cultivated land quality in Henan Province based on spatial big data.tei.xml
- Description confidence: high (les variables du fichier - epaisseur effective du sol, salinite, acidite/alcalinite, drainage, taux de garantie d'irrigation, pente - sont les facteurs de qualite des sols classiques utilises dans ce type d'etude, coherents avec le titre et l'objet du papier)
- Paper DOI: 10.1371/journal.pone.0265613
- Dataset DOI: 10.5061/dryad.v6wwpzgz0
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.v6wwpzgz0
- Local raw dir: `data/raw/papers/DataCite_2022_ModelingOfSpatialPattern_10_1371_journal_/`
- Local sf output: `data/final_datasets/sf/DataCite_2022_ModelingOfSpatialPattern_10_1371_journal_.gpkg`
- Local benchmark RDS: `data/final_datasets/sf/paper_wang_henan_cultivated_land_quality.rds`

### ⚠️ Avertissement — couverture partielle (143/159 comtes)

Le referentiel geometrique de reference (GADM ADM3) ne couvrait que 84/159 comtes du Henan (districts urbains manquants, ex. Zhengzhou agrege en une seule entite au lieu de ses ~6 arrondissements). Remplace par geoBoundaries CHN ADM3 (2864 unites nationales), clippe a la province Henan. **143/159 comtes (90%) apparies sans ambiguite** apres normalisation des noms, correction d'une faute de frappe evidente ('Jia Countu' -> 'Jia County') et 2 alias de transliteration verifies individuellement (ZhongMou -> Zhongmu County ; ShunHeHuiZu -> Shunhe Hui District). **16 comtes exclus, non fabriques** : ChanHeHuiZu, ChangHeng, GuanChengHuiZu, HengChuan, Hui County, HuiYuan, JinMing, KaiFeng, LiangUuan, Qi County, Xia County, XiangCheng, XuCheng, ZhaoLing (+ 2 doublons ambigus). Voir `qc.join_note` du typology JSON pour le detail complet.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Effective soil thickness` (Y de substitution — l'indice publie Y_i n'est pas directement present, voir note ci-dessous)
- Candidate Y typology: continuous
- Candidate X variables: `Effective soil thickness`, `Soil salinity content`, `Soil acidity and alkalinity`, `Drainage conditions`, `Irrigation guarantee rate`, `Slope`
- Candidate X typology: continuous
- Presence of imputed X: unknown
- Coordinates (excluded from X): aucune (geometrie polygonale, pas de coordonnees ponctuelles)
- Identifier columns (excluded from X): `County`, `Map Area`

#### Detail X

| Variable | Typologie | Plage |
|---|---|---|
| `Effective soil thickness` | continuous | [0.0, 157.78] |
| `Soil salinity content` | continuous | [7.14, 27.69] |
| `Soil acidity and alkalinity` | continuous | [5.42, 8.77] |
| `Drainage conditions` | continuous | [0.0, 3.80] |
| `Irrigation guarantee rate` | continuous | [1.0, 3.98] |
| `Slope` | continuous | [0.0, 3.64] |

### Formule — niveau publication

- formula_pub: indice de qualite par comte comme moyenne ponderee par la surface des cantons `Y_i = sum(X_i,max/min,i * S_i) / sum(S_i)` (eqn 1), normalisation min-max `X_bar = (x_i - min)/(max - min)` (eqn 2), Moran's I global `I = n*sum_i,j(w_ij*(X_i-Xbar)*(X_j-Xbar)) / (sum_i,j(w_ij)*sum_i((X_i-Xbar)^2))` (eqn 3), Moran's I local (eqn 4-5)
- x_terms_pub: facteurs de qualite des sols (epaisseur, salinite, pH, drainage, irrigation, pente) agreges au niveau canton puis comte
- y_term_pub: `Y_i` (indice de qualite des terres cultivees du comte i)
- Reference publication: Wang, H., Zhu, Y., Wang, J., Han, H., Niu, J., Chen, X. (2022) "Modeling of spatial pattern and influencing factors of cultivated land quality in Henan Province based on spatial big data", PLOS ONE 17(4):e0265613. Equations (1)-(5).

### Statut regression canonique

- Statut: partiel
- Niveau de preuve: verbatim (equations 1-5 extraites du TEI pour la construction de l'indice et l'analyse d'autocorrelation spatiale)
- Methode d'estimation: indice pondere + statistiques d'autocorrelation spatiale (Moran's I global et local) + modele d'autoregression spatiale (mentionne mais equation non extraite du TEI)
- Correspondance Python/R: aucune
- Note: le fichier converti fournit les facteurs X (niveau comte, deja agreges) mais pas l'indice Y_i final tel que publie dans le papier - celui-ci devrait etre reconstruit selon la formule (1)-(2) si necessaire pour un benchmark, ou une variable X (ex. Effective soil thickness) peut servir de Y de substitution pour un benchmark exploratoire.

### Formule — niveau systeme

- formula_used: `Effective.soil.thickness ~ Soil.salinity.content + Soil.acidity.and.alkalinity + Drainage.conditions + Irrigation.guarantee.rate + Slope`
- x_terms_used: `Soil.salinity.content, Soil.acidity.and.alkalinity, Drainage.conditions, Irrigation.guarantee.rate, Slope`
- y_term_used: `Effective.soil.thickness` (Y de substitution - voir note ci-dessus)

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "Effective soil thickness ~ Slope"
    response: "Effective soil thickness"
    predictors: ["Slope"]
    role: "simple_baseline"
    source_type: "generated_candidate"
    source_ref: "n/a - Y de substitution, l'indice publie Y_i n'est pas directement dans le fichier"
    estimator_context: ["ols"]
    status: "confirmed"

  multivariate_constrained:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "paper_main_specification"
    source_type: "none_found"
    source_ref: "indice Y_i publie (eq. 1-2) non reconstruit - necessiterait les poids de surface par canton (S_i), absents du fichier converti (agregation deja faite au niveau comte)"
    estimator_context: []
    status: "unavailable"

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

## Bloc 2 — Identification et DOI

- Dataset ID: `paper_wang_henan_cultivated_land_quality`
- Dataset name: Data for: Modeling of spatial pattern and influencing factors of cultivated land quality based on spatial-temporal big data
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Modeling of spatial pattern and influencing factors of cultivated land quality in Henan Province based on spatial big data
- Paper DOI: 10.1371/journal.pone.0265613
- Dataset DOI: 10.5061/dryad.v6wwpzgz0
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.v6wwpzgz0
- Year: 2022

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): analyse du patron spatial et des facteurs d'influence de la qualite des terres cultivees
- Modele niveau 2 (famille): indice pondere + autocorrelation spatiale (Moran's I) + autoregression spatiale
- Modele niveau 3 (variante): Moran's I global et local (LISA)

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Y_i = sum(X_i * S_i)/sum(S_i) (eq.1) ; normalisation min-max (eq.2) ; Moran's I global (eq.3) ; Moran's I local (eq.4-5)"
  equation_family: weighted_quality_index_spatial_autocorrelation
  model_family: morans_i_sar
  source_type: published
  source_ref: "Wang et al. (2022), PLOS ONE, eq. (1)-(5)"
  confidence: high
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous_exploratory"
  package_include: "yes"
  has_local_rds: true
  missing_items: "none for exploratory benchmark; published composite Y_i not reconstructed"
  reason: "RDS final disponible avec noms R-safe, geometrie de comtes et centroides projetes en EPSG:32650. Effective soil thickness sert de reponse continue de substitution; ce n'est pas une reproduction de l'indice composite Y_i publie."
```

- Decision: ready for exploratory technical benchmark
- Manque principal: aucun pour un benchmark exploratoire ; la reproduction exacte de l'article demanderait de reconstruire l'indice composite Y_i publie.
- Raison: les facteurs X sont coherents avec le papier, le RDS final est exploitable par le package, et la limite de couverture 143/159 comtes reste documentee.

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 143
- k variables: 8
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 — Resolution et etendue

- Type de geometrie: POLYGON/MULTIPOLYGON (comtes)
- Spatial resolution: comte (xian/qu)
- Temporal resolution: not applicable
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [110.354790, 116.644731], y [31.384459, 36.366779] (coherent avec la province du Henan, Chine)
- Time range: not applicable
- CRS analyse recommande: 32650 (WGS 84 / UTM zone 50N) — a confirmer

## Bloc 6 — Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown (Dryad, generalement CC0)
- Reproducibility status: partiel - geometrie reconstruite par jointure nominale documentee (geoBoundaries), couverture 90% transparente
- Code available: non fourni dans le depot Dryad consulte
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Estimator eligibility

```yaml
estimator_eligibility:
  - estimator: ols
    eligible: uncertain
    basis: generated_candidate
    source_ref: "n/a"
    notes: "Y de substitution seulement (indice publie non reconstruit) ; utilisable pour un benchmark exploratoire, pas une reproduction du papier."
  - estimator: gwr
    eligible: uncertain
    basis: generated_candidate
    source_ref: "n/a"
    notes: "Non explicitement utilise dans le papier (Moran's I + SAR preferes), mais compatible avec la structure polygonale."
  - estimator: sar_lag
    eligible: true
    basis: published_model
    source_ref: "Wang et al. (2022), mention d'un modele d'autoregression spatiale (equation non extraite du TEI)"
    notes: "Methode explicitement mentionnee dans le texte pour modeliser les facteurs d'influence, mais l'equation formelle n'a pas ete capturee par le parsing GROBID - a verifier manuellement dans le PDF si besoin d'une specification exacte."
```

## Quality Control

- Schema: OK - fiche alignee sur le format stabilise des fiches package.
- Variables: PARTIEL - facteurs X coherents avec le sujet du papier, mais l'indice Y_i publie n'est pas directement present (necessiterait reconstruction).
- Formula: OK - formule de construction de l'indice et de Moran's I publiees et verbatim (equations 1-5 du TEI).
- CRS: OK - CRS renseigne (4326), etendue coherente avec le Henan.
- Geometry: OK - type geometrique controle (POLYGON/MULTIPOLYGON), 143 comtes.
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - un enregistrement par comte.
- Reproducibility: PARTIEL - couverture geographique a 90% documentee explicitement, 16 comtes exclus par prudence (pas de correspondance non ambigue).

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Modeling of spatial pattern and influencing factors of cultivated land quality in Henan Province based on spatial big data
