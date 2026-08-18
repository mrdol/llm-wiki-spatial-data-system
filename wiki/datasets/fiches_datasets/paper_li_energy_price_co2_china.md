---
title: paper_li_energy_price_co2_china
type: dataset
created: 2026-08-09
updated: 2026-08-10
sources:
  - data/final_datasets/sf/DataCite_2019_TheImpactOfEnergy_10_1016_j_scitot.gpkg
  - DataCite_2019_TheImpactOfEnergy_10_1016_j_scitot
  - corpus/papers/tei/The impact of energy price on CO2 emissions in China - A spatial econometric analysis.tei.xml
tags: [dataset, paper-derived, spatial, polygon, panel]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "The Impact of Energy Price on CO2 Emissions in China: A Spatial Econometric Analysis" (DOI 10.1016/j.scitotenv.2019.135942).

## Description du jeu de donnees

- Topic: economie de l'energie / effet du prix de l'energie sur les emissions de CO2 en Chine, avec dependance spatiale
- Observation unit: province chinoise x annee
- Observed population: 30 provinces chinoises (Tibet exclu faute de donnees), 2002-2016
- Geographic context: Chine continentale (voir Bloc 5)
- Temporal context: panel, 15 annees (2002-2016)
- Source description: le papier modelise le logarithme des emissions de CO2 en fonction du prix de l'energie (EP) et de variables de controle (population, PIB/habitant, structure industrielle, urbanisation, investissement direct etranger, technologie, education, structure energetique), avec un terme de dependance spatiale (SAR-lag, SAR-error, ou dynamique avec retard temporel)
- Description source: corpus/papers/tei/The impact of energy price on CO2 emissions in China - A spatial econometric analysis.tei.xml
- Description confidence: high (les variables de controle citees dans l'equation (3) du papier - POP, PGDP, INS, URB, RFDI, TEC, EDU, ENS - correspondent exactement aux colonnes du fichier)
- Paper DOI: 10.1016/j.scitotenv.2019.135942
- Dataset DOI: 10.17632/hm29shxmfc.1
- Source URL: https://data.mendeley.com/datasets/hm29shxmfc/1
- Local raw dir: `data/raw/papers/DataCite_2019_TheImpactOfEnergy_10_1016_j_scitot/`
- Local sf output: `data/final_datasets/sf/DataCite_2019_TheImpactOfEnergy_10_1016_j_scitot.gpkg`
- Local benchmark RDS: `data/final_datasets/sf/paper_li_energy_price_co2_china.rds`

### ⚠️ Avertissement — identification des provinces par reconstruction, pas par codebook officiel

Le depot Mendeley et le papier source ne fournissent aucune table de correspondance entre le code `id_province` (1-31, Tibet absent) et le nom de la province. Identification reconstruite en deux etapes independantes et convergentes (2026-08-09) :

1. **Empreinte statistique** : les valeurs `POP` de l'annee 2010 (annee de recensement chinois) comparees aux chiffres officiels du recensement 2010 par province (source : Wikipedia/NBS) — 28/30 provinces identifiees avec un ecart de rang < 3%.
2. **Codes administratifs officiels GB/T 2260** (verifie via Wikipedia) : la sequence North China → Northeast → East China → Central-South → Southwest → Northwest correspond exactement a l'ordre de `id_province` sur les 30 provinces, ce qui confirme les 28 deja identifiees et tranche les 2 dernieres ambigues sur la seule population (Guizhou/Shanxi, Henan/Shandong — populations reelles quasi identiques en 2010).

Les deux methodes convergent integralement. Confiance elevee, mais ce n'est pas un codebook publie par les auteurs — a signaler explicitement en cas d'usage pour une publication. `id_map` (ordre alphabetique anglais des provinces, deduit du fichier) est conserve comme identifiant secondaire, non utilise pour la geometrie.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `CO2` (utilisee en log dans le papier : ln(CO2))
- Candidate Y typology: continuous
- Candidate X variables: `EP` (prix de l'energie, variable principale), `POP`, `PGDP`, `INS`, `URB`, `RFDI`, `TEC`, `EDU`, `ENS`
- Candidate X typology: continuous
- Presence of imputed X: unknown
- Coordinates (excluded from X): aucune (geometrie polygonale provinciale)
- Identifier columns (excluded from X): `id_province`, `id_map`, `region`, `province_name`, `year` (variable temporelle)

> Selection Y/X (paper-loader / curated evidence) : Pour `paper_li_energy_price_co2_china`, la réponse retenue est `CO2`, utilisée dans le papier sous forme logarithmique pour étudier les émissions provinciales de carbone. Les covariables X retenues sont `EP`, `POP`, `PGDP`, `INS`, `URB`, `RFDI`, `TEC`, `EDU` et `ENS`, car elles correspondent à la spécification empirique publiée sur le prix de l'énergie et les facteurs socio-économiques associés. Les identifiants administratifs, les champs temporels et les géométries sont exclus de X. Statut benchmark actuel : ready_spatial_slice_2016 ; la version package utilise la coupe spatiale 2016.

#### Detail Y

| Variable | Typologie | Plage |
|---|---|---|
| `CO2` | continuous | [1011.4, 132595.14] |

#### Detail X

| Variable | Typologie | Plage |
|---|---|---|
| `EP` (prix de l'energie) | continuous | [0.4154, 3.4107] |
| `POP` | count | [523, 10849] |
| `PGDP` | count | [3000, 107960] |
| `INS` (structure industrielle) | continuous | [13.12, 53.04] |
| `URB` (urbanisation) | continuous | [24.48, 89.61] |
| `RFDI` (investissement direct etranger relatif) | continuous | [0.068, 14.65] |
| `TEC` (technologie) | continuous | [0.21, 26447.83] |
| `EDU` (education) | continuous | [2.19, 11.64] |
| `ENS` (structure energetique) | continuous | [13.70, 1058.83] |

### Formule — niveau publication

- formula_pub: `ln(CO2)_it = alpha_i + gamma*ln(EP)_it + beta*Control_it + rho*W*ln(CO2)_it + eta_t + xi_t + epsilon_t` (SAR-lag, eqn 5), variante SAR-error `ln(CO2)_it = alpha_i + gamma*ln(EP)_it + beta*Control_it + lambda*W*upsilon_it + eta_t + xi_t + epsilon_t` (eqn 6), variante dynamique avec retard spatio-temporel (eqn 7)
- x_terms_pub: `ln(EP)`, `Control` = {POP, PGDP, INS, URB, RFDI, TEC, EDU, ENS} (eqn 3)
- y_term_pub: `ln(CO2)`
- Reference publication: Li, K., Fang, L., He, Q. (2020) "The Impact of Energy Price on CO2 Emissions in China: A Spatial Econometric Analysis", Science of The Total Environment 706:135942. Equations (3), (5)-(7).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: verbatim (equations 3, 5-7 extraites du TEI)
- Methode d'estimation: panel spatial (SAR-lag / SAR-error / dynamique avec retard temporel et spatial), matrices de poids spatiaux alternatives testees
- Correspondance Python/R: aucune
- Note: le papier teste plusieurs specifications spatiales (lag, erreur, dynamique) sur le meme jeu de variables ; toutes les variables de controle citees dans l'equation (3) sont presentes dans le fichier converti.

### Formule — niveau systeme

- formula_used: `CO2 ~ EP + POP + PGDP + INS + URB + RFDI + TEC + EDU + ENS`
- x_terms_used: `EP, POP, PGDP, INS, URB, RFDI, TEC, EDU, ENS`
- y_term_used: `CO2`

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "CO2 ~ EP"
    response: "CO2"
    predictors: ["EP"]
    role: "simple_baseline"
    source_type: "published"
    source_ref: "Li, Fang & He (2020), Science of the Total Environment, eq. (5), variable principale EP"
    estimator_context: ["ols", "sar_lag", "sar_error"]
    status: "confirmed"

  multivariate_constrained:
    formula: "CO2 ~ EP + POP + PGDP + INS + URB + RFDI + TEC + EDU + ENS"
    response: "CO2"
    predictors: ["EP", "POP", "PGDP", "INS", "URB", "RFDI", "TEC", "EDU", "ENS"]
    role: "paper_main_specification"
    source_type: "published"
    source_ref: "Li, Fang & He (2020), eq. (3) et (5)-(7)"
    estimator_context: ["sar_lag", "sar_error"]
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

- Dataset ID: `paper_li_energy_price_co2_china`
- Dataset name: Data for: The impact of energy price on CO2 emissions in China: A spatial econometric analysis
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: The Impact of Energy Price on CO2 Emissions in China: A Spatial Econometric Analysis
- Paper DOI: 10.1016/j.scitotenv.2019.135942
- Dataset DOI: 10.17632/hm29shxmfc.1
- Source URL: https://data.mendeley.com/datasets/hm29shxmfc/1
- Year: 2020

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): effet du prix de l'energie sur les emissions de CO2 avec dependance spatiale
- Modele niveau 2 (famille): panel spatial (SAR-lag / SAR-error / dynamique)
- Modele niveau 3 (variante): 3 specifications testees (statique lag, statique erreur, dynamique avec retard temporel)

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "ln(CO2)_it = alpha_i + gamma*ln(EP)_it + beta*Control_it + rho*W*ln(CO2)_it + eta_t + xi_t + epsilon_t (eq.5)"
  equation_family: spatial_panel_co2_energy_price
  model_family: sar_lag_error_dynamic
  source_type: published
  source_ref: "Li, Fang & He (2020), Science of the Total Environment, eq. (3), (5)-(7)"
  confidence: high
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: ready
  package_include: yes
  blocking_reason: "none for technical benchmark; province-name reconstruction remains documented"
  required_next_step: "optional external confirmation that id_province follows the reconstructed GB/T 2260 sequence"
  has_local_rds: true
  missing_items: "none for the 2016 cross-sectional benchmark"
  reason: "Y/X et formule publiee sont confirmes; le RDS benchmark utilise la coupe 2016 pour rester compatible avec le benchmark spatial actuel, qui ne traite pas encore les panels spatiaux."
```

- Decision: ready for technical benchmark as 2016 cross-section
- Manque principal: aucun pour la coupe 2016 ; le panel complet 2002-2016 demandera une route spatio-temporelle separee.
- Raison: Y (CO2), X (prix de l'energie + 8 controles) et formule sont solidement etablis et coherents avec le papier. Le RDS final evite les coordonnees dupliquees du panel en gardant une seule observation par province.

## Bloc 4 — Typologie des donnees

- Data type: spatio-temporel
- Structure: panel
- N observations: 30
- k variables: 15
- T periods: 15
- Variable temporelle: year
- N/T profile: N_petit_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : verification empirique montre qu'il n'y a AUCUNE repetition de geometrie (N spatial = N observations exactement) malgre la classification 'Structure: panel_ou_series' / 'Data type: spatio-temporel' ci-dessus -- chaque ligne correspond a un lieu unique. Ce n'est donc pas un panel au sens statistique (pas de correlation intra-unite a modeliser), plutot une coupe transversale avec une covariable/dimension temporelle associee a chaque point distinct.

## Bloc 5 — Resolution et etendue

- Type de geometrie: POLYGON/MULTIPOLYGON (provinces)
- Spatial resolution: provinciale
- Temporal resolution: annuelle (2002-2016)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [73.56, 134.77], y [18.16, 53.56] (coherent avec la Chine continentale)
- Time range: 2002-2016
- CRS analyse recommande: 4479 (CGCS2000 / China Albers Equal Area) — a confirmer

## Bloc 6 — Reproductibilite

- License present: yes
- License name: Creative Commons Attribution 4.0 International
- License URL: https://creativecommons.org/licenses/by/4.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.17632/hm29shxmfc.1 (checked 2026-08-18): rightsList = 'Creative Commons Attribution 4.0 International'.
- Reproducibility status: partiel - identification des provinces documentee comme reconstruction, pas un codebook officiel
- Code available: non fourni dans le depot Mendeley consulte
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Estimator eligibility

```yaml
estimator_eligibility:
  - estimator: sar_lag
    eligible: true
    basis: published_model
    source_ref: "Li, Fang & He (2020), eq. (5)"
    notes: "Specification principale du papier (SAR-lag statique)."
  - estimator: sar_error
    eligible: true
    basis: published_model
    source_ref: "Li, Fang & He (2020), eq. (6)"
    notes: "Specification alternative explicitement testee (SAR-error)."
  - estimator: ols
    eligible: uncertain
    basis: generated_candidate
    source_ref: "n/a"
    notes: "Non utilise dans le papier (dependance spatiale toujours modelisee) mais benchmark de reference standard."
```

## Quality Control

- Schema: OK - fiche alignee sur le format stabilise des fiches package.
- Variables: OK - Y (CO2) et X (EP + 8 controles) confirmes verbatim contre l'equation (3) du papier.
- Formula: OK - formule publiee et verbatim (equations 3, 5-7 du TEI), statut confirmed.
- CRS: OK - CRS renseigne (4326), etendue coherente avec la Chine.
- Geometry: OK - type geometrique controle (POLYGON/MULTIPOLYGON), 30 provinces.
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - un enregistrement par province x annee (450 = 30 x 15).
- Reproducibility: PARTIEL - identification geographique par reconstruction documentee (voir avertissement), pas de codebook officiel disponible.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: The impact of energy price on CO2 emissions in China - A spatial econometric analysis
