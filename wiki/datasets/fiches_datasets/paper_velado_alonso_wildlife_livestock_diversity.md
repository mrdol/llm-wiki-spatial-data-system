---
title: paper_velado_alonso_wildlife_livestock_diversity
type: dataset
created: 2026-08-09
updated: 2026-08-10
sources:
  - data/final_datasets/sf/DataCite_2020_RelationshipsBetweenTheDistribution_10_1111_ddi_1313.gpkg
  - DataCite_2020_RelationshipsBetweenTheDistribution_10_1111_ddi_1313
  - corpus/papers/tei/Relationships between the distribution of wildlife and livestock diversity.tei.xml
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Relationships between the distribution of wildlife and livestock diversity" (DOI 10.1111/ddi.13133).

## Description du jeu de donnees

- Topic: ecologie du paysage / relation entre richesse de la faune sauvage et diversite des races d'elevage en Espagne
- Observation unit: cellule de grille UTM 10x10 km
- Observed population: territoire continental espagnol, grille complete (5324 cellules)
- Geographic context: Espagne peninsulaire (voir Bloc 5)
- Temporal context: coupe transversale (pas de dimension temporelle)
- Source description: le papier utilise des modeles GWR pour analyser la variation spatiale des relations entre richesse en especes de vertebres terrestres natifs (amphibiens, reptiles, oiseaux, mammiferes) et richesse en races d'elevage locales (bovine, ovine, caprine, asine, equine, porcine), variables climatiques et empreinte humaine
- Description source: corpus/papers/tei/Relationships between the distribution of wildlife and livestock diversity.tei.xml
- Description confidence: high (variables du fichier converti correspondent exactement a la description methodologique du papier - groupes taxonomiques et types de races cites)
- Paper DOI: 10.1111/ddi.13133
- Dataset DOI: 10.5061/dryad.0gb5mkkzd
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.0gb5mkkzd
- Local raw dir: `data/raw/papers/DataCite_2020_RelationshipsBetweenTheDistribution_10_1111_ddi_1313/`
- Local sf output: `data/final_datasets/sf/DataCite_2020_RelationshipsBetweenTheDistribution_10_1111_ddi_1313.gpkg`
- Local benchmark RDS: `data/final_datasets/sf/paper_velado_alonso_wildlife_livestock_diversity.rds`

### ⚠️ Avertissement — CRS suppose, non confirme

Le fichier source fournit des coordonnees projetees (`XCentroid`, `YCentroid`) et un code de grille MGRS (`UTMCode`), mais ni le fichier ni le papier ne precisent le datum/fuseau exact. ETRS89 UTM zone 30N (EPSG:25830) a ete applique sur validation explicite de l'utilisateur (2026-08-09), convention la plus courante pour les atlas de biodiversite espagnols peninsulaires sur un seul fuseau, mais **ce n'est pas une certitude verifiee**. Voir `qc.join_note` du typology JSON.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Native_Mammal_Richness`, `Native_Reptile_Richness`, `Native_Nesting_Bird_Richness`, `Native_Amphibian_Richness` (et sous-groupes)
- Candidate Y typology: count
- Candidate X variables: `Total_Breed_Richness`, `Bovine_Breed_Richness`, `Ovine_Breed_Richness`, `Annual_Mean_Temperature`, `Annual_Precipitation`, `Precipitation_Seasonality`, `HumanFootprint_2009`
- Candidate X typology: count (richesses de races), continuous (climat, empreinte humaine)
- Presence of imputed X: unknown
- Coordinates (excluded from X): `XCentroid`, `YCentroid` (identifiees comme identifiants dans le typology JSON car projetees, pas lon/lat directes)
- Identifier columns (excluded from X): `UTMCode`, `Grid`, `Unnamed: 0`

#### Detail Y

| Variable | Typologie | Plage |
|---|---|---|
| `Native_Mammal_Richness` | count | [0, 49] |
| `Native_Reptile_Richness` | count | [0, 20] |
| `Native_Nesting_Bird_Richness` | count | [0, 121] |
| `Native_Amphibian_Richness` | count | [0, 14] |

#### Detail X

| Variable | Typologie | Plage |
|---|---|---|
| `Total_Breed_Richness` | count | [0, 15] |
| `Bovine_Breed_Richness` | count | [0, 6] |
| `Ovine_Breed_Richness` | count | [0, 5] |
| `Annual_Mean_Temperature` | continuous | [1.2158, 18.3614] |
| `Annual_Precipitation` | continuous | [213.0, 1813.13] |
| `HumanFootprint_2009` | continuous | [0.9453, 45.1274] |

### Formule — niveau publication

- formula_pub: modele GWR non explicite sous forme d'equation dans le TEI (extraction GROBID n'a pas capture de formule inline pour ce papier) ; description narrative verbatim : "We modelled the spatial gradients in species richness of native terrestrial vertebrates [...] as a function of local livestock breed richness [...] climate variables and human footprint."
- x_terms_pub: richesse de races (totale et par type), variables climatiques, empreinte humaine
- y_term_pub: richesse en especes par groupe taxonomique natif
- Reference publication: Velado-Alonso, E., Morales-Castilla, I., Rebollo, S., Gomez-Sal, A. (2020) "Relationships between the distribution of wildlife and livestock diversity", Diversity and Distributions 26(10):1264-1275.

### Statut regression canonique

- Statut: partiel
- Niveau de preuve: narratif (description methodologique verbatim, pas d'equation formelle capturee par le parsing TEI)
- Methode d'estimation: geographically weighted regression (GWR)
- Correspondance Python/R: aucune
- Note: le papier teste plusieurs groupes taxonomiques Y separement (mammiferes, oiseaux nicheurs, reptiles rupestres/arbustifs, amphibiens terrestres/aquatiques...) contre le meme jeu de predicteurs X. Pas de formule mathematique explicite extraite - a verifier manuellement dans le PDF si une equation GWR formelle est presente en figure/tableau non capturee par GROBID.

### Formule — niveau systeme

- formula_used: `Native_Mammal_Richness ~ Total_Breed_Richness + Annual_Mean_Temperature + Annual_Precipitation + HumanFootprint_2009`
- x_terms_used: `Total_Breed_Richness, Annual_Mean_Temperature, Annual_Precipitation, HumanFootprint_2009`
- y_term_used: `Native_Mammal_Richness`

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "Native_Mammal_Richness ~ Total_Breed_Richness"
    response: "Native_Mammal_Richness"
    predictors: ["Total_Breed_Richness"]
    role: "simple_baseline"
    source_type: "published"
    source_ref: "Velado-Alonso et al. (2020), description methodologique, section 2"
    estimator_context: ["ols", "gwr"]
    status: "confirmed"

  multivariate_constrained:
    formula: "Native_Mammal_Richness ~ Total_Breed_Richness + Annual_Mean_Temperature + Annual_Precipitation + Precipitation_Seasonality + HumanFootprint_2009"
    response: "Native_Mammal_Richness"
    predictors: ["Total_Breed_Richness", "Annual_Mean_Temperature", "Annual_Precipitation", "Precipitation_Seasonality", "HumanFootprint_2009"]
    role: "paper_main_specification"
    source_type: "published"
    source_ref: "Velado-Alonso et al. (2020), description methodologique, section 2"
    estimator_context: ["gwr", "ols"]
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

## Bloc 2 — Identification et DOI

- Dataset ID: `paper_velado_alonso_wildlife_livestock_diversity`
- Dataset name: Relationships between the distribution of wildlife and livestock diversity
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Relationships between the distribution of wildlife and livestock diversity
- Paper DOI: 10.1111/ddi.13133
- Dataset DOI: 10.5061/dryad.0gb5mkkzd
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.0gb5mkkzd
- Year: 2020

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): relation spatiale entre richesse de la faune sauvage et diversite des races d'elevage
- Modele niveau 2 (famille): geographically weighted regression (GWR)
- Modele niveau 3 (variante): non precisee (noyau/bandwidth non extraits du TEI)

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Description narrative uniquement : species richness modelled as a function of livestock breed richness, climate variables and human footprint via GWR."
  equation_family: geographically_weighted_regression
  model_family: gwr
  source_type: published
  source_ref: "Velado-Alonso et al. (2020), Diversity and Distributions, section 2 (methodes)"
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_count"
  package_include: "yes"
  has_local_rds: true
  missing_items: "none for technical benchmark; CRS uncertainty remains documented"
  reason: "Y/X clairement identifies et coherents avec le papier. Le RDS benchmark contient des centroides projetes en EPSG:3035 pour les calculs de distance; le CRS source suppose reste documente comme limite."
```

- Decision: ready for technical benchmark
- Manque principal: aucun pour un benchmark technique ; l'incertitude sur le CRS source reste documentee pour un usage de publication.
- Raison: Y (richesses taxonomiques) et X (richesse de races, climat, empreinte humaine) sont coherents avec la description du papier, et le RDS final fournit des coordonnees projetees pour les estimateurs spatiaux.

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 5324
- k variables: 20
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 — Resolution et etendue

- Type de geometrie: POINT (centroide de cellule de grille 10x10 km)
- Spatial resolution: grille reguliere 10 km
- Temporal resolution: not applicable (coupe transversale)
- CRS EPSG: 4326 (reprojete depuis EPSG:25830 suppose)
- CRS nom: WGS 84
- Spatial extent: x [-9.086648, 3.008022], y [35.981155, 43.742685] (coherent avec l'Espagne peninsulaire)
- Time range: not applicable
- CRS analyse recommande: 25830 (ETRS89 / UTM zone 30N) — a confirmer

## Bloc 6 — Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown (Dryad, generalement CC0)
- Reproducibility status: partiel - CRS suppose documente explicitement dans qc.join_note, a reverifier si une source plus precise devient disponible
- Code available: non fourni dans le depot Dryad consulte
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Estimator eligibility

```yaml
estimator_eligibility:
  - estimator: gwr
    eligible: true
    basis: published_model
    source_ref: "Velado-Alonso et al. (2020), section methodes"
    notes: "Methode principale du papier, explicitement nommee (geographically weighted regression)."
  - estimator: ols
    eligible: uncertain
    basis: generated_candidate
    source_ref: "n/a"
    notes: "Non utilise dans le papier mais benchmark de reference standard pour comparer a la GWR."
  - estimator: sar_lag
    eligible: uncertain
    basis: generated_candidate
    source_ref: "n/a"
    notes: "Non utilise dans le papier ; alternative de dependance spatiale globale non testee."
```

## Quality Control

- Schema: OK - fiche alignee sur le format stabilise des fiches package.
- Variables: OK - Y (richesses taxonomiques) et X (races, climat, empreinte humaine) coherents avec la description methodologique verbatim du papier.
- Formula: PARTIEL - pas d'equation formelle capturee par GROBID pour ce papier, description narrative seulement.
- CRS: A VERIFIER - CRS suppose (EPSG:25830), documente comme hypothese non confirmee.
- Geometry: OK - type geometrique controle (POINT), etendue coherente avec l'Espagne.
- Missing values: OK - Annual_Mean_Temperature/Annual_Precipitation/Precipitation_Seasonality a 0.4% NA, HumanFootprint_2009 a 5.2% NA, sous le seuil de 20%.
- Duplicates: OK - grille reguliere, pas de doublons detectes.
- Reproducibility: PARTIEL - source brute tracee, mais CRS a reverifier.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Relationships between the distribution of wildlife and livestock diversity
