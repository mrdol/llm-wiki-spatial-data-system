---
title: paper_li_energy_price_co2_china
type: dataset
created: 2026-08-09
updated: 2026-09-07
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
- Coordinates (excluded from X): `X`, `Y` (centroides projetes derives de la geometrie polygonale provinciale)
- Identifier columns (excluded from X): `id_province`, `id_map`, `region`, `province_name`, `year` (variable temporelle)

> Selection Y/X (paper-loader / curated evidence) : Pour `paper_li_energy_price_co2_china`, la réponse retenue est `CO2`, utilisée dans le papier sous forme logarithmique pour étudier les émissions provinciales de carbone. Les covariables X retenues sont `EP`, `POP`, `PGDP`, `INS`, `URB`, `RFDI`, `TEC`, `EDU` et `ENS`, car elles correspondent à la spécification empirique publiée sur le prix de l'énergie et les facteurs socio-économiques associés. Les identifiants administratifs, les champs temporels et les géométries sont exclus de X. Statut benchmark actuel : manual_review; le RDS local contient desormais le panel complet (450 obs, restaure le 2026-09-08 -- il ne contenait auparavant que la coupe 2016).

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
- x_terms_pub: `ln(EP)`, `Control` = {POP, PGDP, INS, URB, RFDI, TEC, EDU, ENS}
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
- Recommended validation: N lignes=30; T declare=15; variable temporelle declaree=year; repetitions de coordonnees controlees=0. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.
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
  benchmark_status: "manual_review"
  package_include: "manual_review"
  blocking_reason: "panel spatial complet (450 obs) restaure le 2026-09-08 -- promotion en attente d'un support benchmark panel-spatial dedie, pas d'un defaut de la fiche ; province-name reconstruction reste documentee"
  required_next_step: "implementer/valider un chemin de benchmark spatial-panel (effets fixes + SAR panel, methode Elhorst 2010) avant promotion ; en parallele, confirmation externe optionnelle que id_province suit la sequence GB/T 2260 reconstruite"
  has_local_rds: true
  missing_items: "N lignes=450 (panel complet, 30 provinces x 15 annees, restaure le 2026-09-08 -- l'ancien RDS ne contenait que la coupe 2016, N=30). Chaque province se repete 15 fois : panel spatial legitime, pas une duplication a nettoyer. Le harnais de regression actuel (cross-sectionnel) ne gere pas nativement une matrice W construite sur des geometries repetees -- CV manuelle recommandee : grouper par province, respecter la chronologie (annee)."
  reason: "N lignes=450 (panel complet, 30 provinces x 15 annees, restaure le 2026-09-08 -- l'ancien RDS ne contenait que la coupe 2016, N=30). Chaque province se repete 15 fois : panel spatial legitime, pas une duplication a nettoyer. Le harnais de regression actuel (cross-sectionnel) ne gere pas nativement une matrice W construite sur des geometries repetees -- CV manuelle recommandee : grouper par province, respecter la chronologie (annee)."
  benchmark_task: "spatial_panel_estimator_support_pending"
```

- Decision: manual_review
- Manque principal: Support benchmark spatial-panel non encore disponible dans le harnais (voir 'reason' ci-dessus) ; la fiche/les donnees elles-memes sont completes et confirmees (formule verbatim eqs. 3/5-7, panel complet restaure).
- Raison: N lignes=450 (panel complet, 30 provinces x 15 annees, restaure le 2026-09-08 -- l'ancien RDS ne contenait que la coupe 2016, N=30). Chaque province se repete 15 fois : panel spatial legitime, pas une duplication a nettoyer. Le harnais de regression actuel (cross-sectionnel) ne gere pas nativement une matrice W construite sur des geometries repetees -- CV manuelle recommandee : grouper par province, respecter la chronologie (annee).

## Bloc 4 — Typologie des donnees

- Data type: spatio-temporel
- Structure: panel
- N observations: 450
- k variables: 15
- T periods: 15
- Variable temporelle: year
- N/T profile: N_petit_T_grand (30 unites spatiales x 15 periodes)
- Note N/T corrigee (session 2026-09-08) : le RDS local ne contenait auparavant que la coupe 2016 (N=30), contrairement a la note du 2026-08-17 ci-dessous qui affirmait a tort l'absence de panel sur cette base. Verification du fichier brut `data.xlsx` (depot Mendeley) : il contient bien les 450 lignes completes (30 provinces x 15 annees 2002-2016). Sur decision explicite de l'utilisateur (jeu de petite taille -> conserver la forme panel plutot que de le decouper en coupes annuelles comme Coree), le RDS local a ete reconstruit pour contenir les 450 lignes, geometrie provinciale repetee 15 fois par province (panel spatial equilibre et legitime, conforme aux equations panel du papier). Ancienne note (2026-08-17, devenue obsolete) : "verification empirique montre qu'il n'y a AUCUNE repetition de geometrie" -- cette note se basait par erreur sur le RDS reduit a 2016 et non sur les donnees brutes completes.

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
  status: "manual_review"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "N lignes=450 (panel complet restaure le 2026-09-08, 30 provinces x 15 annees) ; T declare=15 ; variable temporelle declaree=year ; chaque geometrie provinciale se repete 15 fois (panel spatial legitime, PAS une duplication a corriger). Le harnais de benchmark actuel (regression cross-sectionnelle) ne construit pas nativement une matrice W panel-coherente sur des geometries repetees -- promotion en attente d'un support panel spatial dedie (cf. Elhorst 2010, methode utilisee par le papier lui-meme : effets fixes province/annee + SAR-lag/SAR-error/dynamique). Grouper par province ET respecter la chronologie (annee) en CV manuelle en attendant ce support."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
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

## Curation documentée — 2026-09-07

Decision conservatoire : N lignes=30; T declare=15; variable temporelle declaree=year; repetitions de coordonnees controlees=0. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
