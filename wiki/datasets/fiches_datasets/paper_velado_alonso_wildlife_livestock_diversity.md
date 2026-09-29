---
title: paper_velado_alonso_wildlife_livestock_diversity
type: dataset
created: 2026-08-09
updated: 2026-09-07
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

### CRS confirme par verification geographique (corrige 2026-09-08)

Le fichier source (`vertebrate_livestock_diversity_Spain_database.csv`, seul fichier du depot Dryad, aucun README/metadonnee CRS fourni) donne des coordonnees projetees (`XCentroid`, `YCentroid`) et un code de grille (`UTMCode`, ex. 'NJ7040', 'PJ0050') sans preciser le datum/fuseau exact ni dans le fichier ni dans le papier. ETRS89 UTM zone 30N (EPSG:25830) avait ete applique sur validation de l'utilisateur (2026-08-09) par convention (fuseau le plus courant pour l'Espagne peninsulaire), mais reste marque comme non verifie jusqu'a cette session.

**Verification directe (2026-09-08)** : transformation des 5324 points de `XCentroid`/`YCentroid` vers WGS84 en testant les 3 fuseaux UTM candidats pour l'Espagne :
- EPSG:25829 (zone 29N) -> longitude [-15.09, -2.99] : tombe dans l'Atlantique, a l'ouest du Portugal -- **exclu**.
- EPSG:25830 (zone 30N) -> longitude [-9.09, 3.01], latitude [35.98, 43.74] -- correspond presque exactement a l'etendue reelle de l'Espagne peninsulaire (reference : lon -9.30 a 3.32, lat 36.00 a 43.79) -- **confirme**.
- EPSG:25831 (zone 31N) -> longitude [-3.09, 9.01] : tombe majoritairement en France/Mediterranee -- **exclu**.

EPSG:25830 est donc confirme empiriquement (pas seulement par convention) comme le CRS source correct : c'est le seul des 3 fuseaux dont la reprojection tombe dans les bornes geographiques reelles de l'Espagne. Le caveat "CRS suppose, non confirme" est leve.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Native_Mammal_Richness`, `Native_Reptile_Richness`, `Native_Nesting_Bird_Richness`, `Native_Amphibian_Richness` (et sous-groupes)
- Candidate Y typology: count
- Candidate X variables: `Total_Breed_Richness`, `Bovine_Breed_Richness`, `Ovine_Breed_Richness`, `Annual_Mean_Temperature`, `Annual_Precipitation`, `Precipitation_Seasonality`, `HumanFootprint_2009`
- Candidate X typology: count (richesses de races), continuous (climat, empreinte humaine)
- Presence of imputed X: unknown
- Coordinates (excluded from X): `XCentroid`, `YCentroid` (identifiees comme identifiants dans le typology JSON car projetees, pas lon/lat directes)
- Identifier columns (excluded from X): `UTMCode`, `Grid`, `Unnamed: 0`

> Selection Y/X (paper-loader / curated evidence) : Pour `paper_velado_alonso_wildlife_livestock_diversity`, la réponse prioritaire est `Native_Mammal_Richness`, parce que le papier relie la diversité des vertébrés sauvages à la diversité du bétail et aux gradients environnementaux. Les covariables X retenues sont `Total_Breed_Richness`, `Annual_Mean_Temperature`, `Annual_Precipitation` et `HumanFootprint_2009`, qui résument respectivement la diversité du bétail, le climat et la pression humaine. Les réponses alternatives par groupe taxonomique restent disponibles pour analyses secondaires ; les identifiants, géométries et champs techniques sont exclus de X. Statut benchmark actuel : ready; CRS confirme le 2026-09-08 (voir avertissement Bloc 1).

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
- x_terms_pub: richesse de races, variables climatiques, empreinte humaine
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
- benchmark_task_note: Native_Mammal_Richness denombre les especes de mammiferes natives (tache count). CRS confirme le 2026-09-08 (voir avertissement Bloc 1) -- reste manual_review pour le routage count a documenter/tester.
- Selected Y evidence: Native_Mammal_Richness denombre les especes de mammiferes natives ; CRS desormais confirme (voir Bloc 1).
- Selected Y typology: count
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
  benchmark_task: "count_spatial_gwr_confirmed"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "CRS confirme le 2026-09-08 par verification geographique directe (seul EPSG:25830 des 3 fuseaux UTM candidats tombe dans les bornes reelles de l'Espagne, voir Bloc 1). Methode GWR explicitement publiee (mgwrsar_gwr eligible)."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: CRS confirme le 2026-09-08 par verification geographique directe (seul EPSG:25830 tombe dans les bornes reelles de l'Espagne). Methode GWR explicitement publiee, coherente avec formula_used.

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
- CRS EPSG: 4326 (reprojete depuis EPSG:25830, confirme par verification geographique le 2026-09-08)
- CRS nom: WGS 84
- Spatial extent: x [-9.086648, 3.008022], y [35.981155, 43.742685] (coherent avec l'Espagne peninsulaire)
- Time range: not applicable
- CRS analyse recommande: 25830 (ETRS89 / UTM zone 30N) — confirme le 2026-09-08 par verification geographique (voir avertissement Bloc 1)

## Bloc 6 — Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.0gb5mkkzd (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - CRS confirme le 2026-09-08 par verification geographique directe (transformation testee sur les 3 fuseaux UTM candidats, seul EPSG:25830 tombe dans les bornes reelles de l'Espagne)
- Code available: non fourni dans le depot Dryad consulte
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators:
    - estimator: mgwrsar_gwr
      basis: scientific_evidence
      source_ref: "Relationships between the distribution of wildlife and livestock diversity (TEI), DOI 10.1111/ddi.13133 -- \"we performed geographically weighted regression models (GWR)... to analyse the relationship between wild species richness and livestock breed richness and environmental variables while accounting for the spatial non-stationarity\"."
      notes: "Methode explicitement publiee (GWR, bande passante adaptative, package spgwr). CRS confirme le 2026-09-08 (voir Bloc 1) -- ne bloque plus la promotion."
    - estimator: ols
      basis: scientific_evidence
      source_ref: "Relationships between the distribution of wildlife and livestock diversity (TEI), DOI 10.1111/ddi.13133 -- GWR sur richesse de mammiferes natives vs richesse de races d'elevage + variables environnementales."
      notes: "GLM/OLS comptage est la base testee avant ponderation geographique dans le papier. CRS confirme le 2026-09-08."
    - estimator: gam_spatial
      basis: generated_candidate
      source_ref: "Routage comptage ajoute cette semaine (mgcv::gam(family=poisson()))."
      notes: "Capacite technique du harnais, comparateur non-spatial."
  conditionally_eligible_estimators: []
  ineligible_reason: "Bloc complete et CRS confirme le 2026-09-08 (verification geographique directe, voir Bloc 1) -- le blocage CRS est leve. GWR (mgwrsar_gwr) ajoute comme estimateur scientifiquement fonde (methode explicitement publiee)."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Quality Control

- Schema: OK - fiche alignee sur le format stabilise des fiches package.
- Variables: OK - Y (richesses taxonomiques) et X (races, climat, empreinte humaine) coherents avec la description methodologique verbatim du papier.
- Formula: PARTIEL - pas d'equation formelle capturee par GROBID pour ce papier, description narrative seulement.
- CRS: OK - EPSG:25830 confirme le 2026-09-08 par verification geographique directe (voir avertissement Bloc 1).
- Geometry: OK - type geometrique controle (POINT), etendue coherente avec l'Espagne.
- Missing values: OK - Annual_Mean_Temperature/Annual_Precipitation/Precipitation_Seasonality a 0.4% NA, HumanFootprint_2009 a 5.2% NA, sous le seuil de 20%.
- Duplicates: OK - grille reguliere, pas de doublons detectes.
- Reproducibility: OK - source brute tracee, CRS confirme le 2026-09-08.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Relationships between the distribution of wildlife and livestock diversity

## Curation documentée — 2026-09-07

Decision conservatoire : Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Native_Mammal_Richness denombre les especes de mammiferes natives; une route count et le traitement du CRS suppose restent a valider. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : count. Native_Mammal_Richness denombre les especes de mammiferes natives; une route count et le traitement du CRS suppose restent a valider.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
