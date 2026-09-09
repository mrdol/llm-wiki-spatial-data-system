---
title: paper_li_energy_price_co2_china
type: dataset
created: 2026-08-09
updated: 2026-09-09
sources:
  - data/final_datasets/sf/paper_li_energy_price_co2_china.rds
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
- Description confidence: medium
- Description confidence note: high pour les variables et transformations ; attribution géographique reconstruite, non confirmée par un codebook auteur
- Paper DOI: 10.1016/j.scitotenv.2019.135942
- Dataset DOI: 10.17632/hm29shxmfc.1
- Source URL: https://data.mendeley.com/datasets/hm29shxmfc/1
- Local raw dir: `data/raw/papers/DataCite_2019_TheImpactOfEnergy_10_1016_j_scitot/`
- Local sf output: `data/final_datasets/sf/paper_li_energy_price_co2_china.rds`
- Local benchmark RDS: `data/final_datasets/sf/paper_li_energy_price_co2_china.rds`

### ⚠️ Avertissement — identification des provinces par reconstruction, pas par codebook officiel

Le depot Mendeley et le papier source ne fournissent aucune table de correspondance entre le code `id_province` (1-31, Tibet absent) et le nom de la province. Identification reconstruite en deux etapes independantes et convergentes (2026-08-09) :

1. **Empreinte statistique** : les valeurs `POP` de l'annee 2010 (annee de recensement chinois) comparees aux chiffres officiels du recensement 2010 par province (source : Wikipedia/NBS) — 28/30 provinces identifiees avec un ecart de rang < 3%.
2. **Codes administratifs officiels GB/T 2260** (verifie via Wikipedia) : la sequence North China → Northeast → East China → Central-South → Southwest → Northwest correspond exactement a l'ordre de `id_province` sur les 30 provinces, ce qui confirme les 28 deja identifiees et tranche les 2 dernieres ambigues sur la seule population (Guizhou/Shanxi, Henan/Shandong — populations reelles quasi identiques en 2010).

Les deux methodes convergent integralement. Confiance elevee, mais ce n'est pas un codebook publie par les auteurs — a signaler explicitement en cas d'usage pour une publication. `id_map` (ordre alphabetique anglais des provinces, deduit du fichier) est conserve comme identifiant secondaire, non utilise pour la geometrie.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `CO2`, utilisée en logarithme naturel
- Candidate Y typology: continuous
- Candidate X variables: `POP`, `PGDP`, `INS`, `URB`, `RFDI`, `TEC`, `EDU`, `ENS`, `EP`, toutes utilisées en logarithme naturel
- Candidate X count: 9
- Candidate X typology: continuous
- Coordinates (excluded from X): `X`, `Y` ; géométrie provinciale
- Identifier columns (excluded from X): `id_province`, `id_map`, `region`, `province_name`, `year`
- Presence of imputed X: non établie par le seul fichier disponible
- Variables inspected: yes ; 450 lignes, dix variables Y/X présentes, finies et strictement positives

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `CO2` | `numeric` | continuous | [1011.4, 132595.1] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `li_energy_price_co2_china`, la réponse `CO2` (émissions provinciales, utilisée en `log(CO2)`) vient du loader papier et des preuves de l'article Li, Fang et He (2020). Les covariables X retenues sont `POP`, `PGDP`, `INS`, `URB`, `RFDI`, `TEC`, `EDU`, `ENS`, `EP`, toutes utilisées en logarithme naturel (équation 3). Les coordonnées (`X`, `Y`, géométrie provinciale), identifiants (`id_province`, `id_map`, `region`, `province_name`) et la variable de panel (`year`) sont exclus de X. Statut benchmark actuel : ready_in_data_bank ; package_include: no (support panel spatial du harnais à implémenter).

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `POP` | `numeric` | continuous (log) | 0% |
| `PGDP` | `numeric` | continuous (log) | 0% |
| `INS` | `numeric` | continuous (log) | 0% |
| `URB` | `numeric` | continuous (log) | 0% |
| `RFDI` | `numeric` | continuous (log) | 0% |
| `TEC` | `numeric` | continuous (log) | 0% |
| `EDU` | `numeric` | continuous (log) | 0% |
| `ENS` | `numeric` | continuous (log) | 0% |
| `EP` | `numeric` | continuous (log) | 0% |

> Note : EP = prix de l'énergie ; POP = population ; PGDP = PIB par habitant ; INS = structure industrielle ; URB = urbanisation ; RFDI = intensité relative des investissements directs étrangers ; TEC = efficacité d'utilisation de l'énergie ; EDU = niveau d'éducation ; ENS = structure de consommation énergétique. Le papier transforme aussi les huit contrôles en logarithme (équation 3 et début de la page PDF 15).

### Formule — niveau publication

- formula_pub: lnCO2 = alpha + beta1*lnPOP + beta2*lnPGDP + beta3*lnINS + beta4*lnURB + beta5*lnRFDI + beta6*lnTEC + beta7*lnEDU + beta8*lnENS + beta9*lnEP + epsilon
- x_terms_pub: lnPOP, lnPGDP, lnINS, lnURB, lnRFDI, lnTEC, lnEDU, lnENS, lnEP
- y_term_pub: lnCO2
- Reference publication: Li, K., Fang, L. et He, L. (Lerong He), 2020, Science of the Total Environment 706:135942, DOI 10.1016/j.scitotenv.2019.135942, équation 3.

Le modèle principal retenu est le **panel spatial lag à effets fixes provinciaux** (section 3.1). Les équations (4)–(6) présentent SAC, lag et erreur ; le modèle dynamique (7) est une analyse de robustesse. Transcription des notations imprimées, sans correction silencieuse de leurs indices :

- (5) `lnCO2_it = alpha_i + gamma*lnEP_it + beta*Control_it + rho*W*lnCO2_it + eta_t + xi_t + epsilon_t`.
- (6) `lnCO2_it = alpha_i + gamma*lnEP_it + beta*Control_it + lambda*W*upsilon_it + eta_t + xi_t + epsilon_t`.
- (7) ajoute `delta*lnCO2_i,t-1` à (5).

Control désigne les huit contrôles transformés en logarithme. La notation générale inclut un effet temporel ; elle ne signifie pas que le modèle principal retenu soit nécessairement à doubles effets fixes. Le texte privilégie les effets fixes provinciaux. W principale : contiguïté binaire des provinces avec frontière commune, normalisée par ligne (pages PDF 16–17). La géométrie jointe du projet ne suffit pas à garantir l'identité avec W des auteurs.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: équations du PDF contrôlées visuellement, et non TEI seul
- Methode d'estimation: panel spatial lag à effets fixes provinciaux ; SEM/SAC et dynamique en comparaison ou robustesse
- Note: Statut resolu pour les variables et transformations (composante de régression de l'équation 3) ; l'implémentation panel spatial complète (effets fixes, W, retards) reste différée, faute de route panel dans le harnais. Les dix variables nécessaires au terme de régression sont présentes et positives. Les paramètres spatiaux, effets fixes et retards temporels relèvent du modèle, pas de neuf colonnes X ordinaires.

### Formule — niveau systeme

- formula_used: log(CO2) ~ log(POP) + log(PGDP) + log(INS) + log(URB) + log(RFDI) + log(TEC) + log(EDU) + log(ENS) + log(EP)
- Selected Y typology: continuous
- x_terms_used: POP, PGDP, INS, URB, RFDI, TEC, EDU, ENS, EP
- y_term_used: CO2
- Recommended validation: 450 lignes = 30 provinces × 15 années 2002–2016 ; une observation par couple province-année ; protocole de panel et alignement explicite de W
- Note: Cette formule R conserve exactement les variables et logarithmes de (3). Elle est la composante de régression à transmettre au futur estimateur de panel ; l'exécuter dans un OLS ou SAR transversal ne reproduirait pas le modèle principal.

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
    formula: "log(CO2) ~ log(POP) + log(PGDP) + log(INS) + log(URB) + log(RFDI) + log(TEC) + log(EDU) + log(ENS) + log(EP)"
    response: "CO2"
    predictors: ["POP", "PGDP", "INS", "URB", "RFDI", "TEC", "EDU", "ENS", "EP"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Li, Fang et He (2020), Science of the Total Environment 706:135942, DOI 10.1016/j.scitotenv.2019.135942, equation 3 -- composante de regression du modele principal panel spatial lag a effets fixes provinciaux (equations 4-7) ; parametres spatiaux, effets fixes et retards temporels non representes par ce champ tabulaire."
    estimator_context: []
    status: "confirmed_pending_panel_route"

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

La formule brute `CO2 ~ EP` et la formule multivariée sans logarithmes sont retirées des spécifications publiées. Les variantes spatiales à conserver sont les équations (4)–(7) décrites ci-dessus ; aucun estimateur transversal n'est déclaré reproduction exacte.

## Bloc 2 — Identification et DOI

- Dataset ID: `paper_li_energy_price_co2_china`
- Dataset name: Data for: Assessing the impact of energy price on China's carbon emissions: A spatial econometric method
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: The Impact of Energy Price on CO2 Emissions in China: A Spatial Econometric Analysis
- Paper DOI: 10.1016/j.scitotenv.2019.135942
- Dataset DOI: 10.17632/hm29shxmfc.1
- Source URL: https://data.mendeley.com/datasets/hm29shxmfc/1
- Year: 2020

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): expliquer les émissions provinciales de CO2
- Modele niveau 2 (famille): panel spatial à effets fixes
- Modele niveau 3 (variante): lag principal ; erreur et SAC comparatifs ; dynamique en robustesse

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Equations (3) à (7), logarithmes de toutes les variables ; modèle principal spatial lag à effets fixes provinciaux."
  model_family: spatial_panel
  source_type: published
  source_ref: "10.1016/j.scitotenv.2019.135942, sections 2.1, 2.4, 3.1, 3.4"
  confidence: high
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready_in_data_bank"
  benchmark_task: "regression_continuous_panel"
  package_include: "no"
  has_local_rds: true
  missing_items: "Panel conservé dans la banque ; support panel spatial du harnais à implémenter, W et provenance géographique à contrôler pour une réplication."
  reason: "Panel conservé dans la banque ; support panel spatial du harnais à implémenter, W et provenance géographique à contrôler pour une réplication."
```

- Decision: ready_in_data_bank
- Manque principal: Panel conservé dans la banque ; support panel spatial du harnais à implémenter, W et provenance géographique à contrôler pour une réplication.
- Raison: Données conservées dans la banque ; le statut ne vaut pas admission au benchmark automatique.

## Bloc 4 — Typologie des donnees

- Data type: spatio-temporel
- Structure: panel
- N observations: 450
- k variables: 17
- T periods: 15
- Variable temporelle: year
- N/T profile: 30 unités spatiales × 15 périodes
- Note: 18 colonnes dont 1 géométrie ; k=17 attributs hors géométrie, dont 9 covariables de régression, 1 réponse, 5 identifiants/champs de panel et 2 coordonnées. Les coefficients, effets fixes et termes spatiaux ne sont pas comptés comme colonnes du RDS.

Le fichier contient exactement les années 2002–2016. La version PDF locale présente une incohérence : résumé 2002–2016, section 2.2 annonçant 2001–2016 et 480 observations. Les 30 observations de 2001 ne sont pas dans le RDS ; ne pas prétendre les avoir restaurées. Les anciennes mentions N=30 décrivaient une coupe 2016 et sont retirées.

## Bloc 5 — Resolution et etendue

- Type de geometrie: POLYGON/MULTIPOLYGON (provinces)
- Spatial resolution: provinciale
- Temporal resolution: annuelle (2002-2016)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [73.56, 134.77], y [18.16, 53.56] (coherent avec la Chine continentale)
- Time range: 2002-2016
- CRS analyse recommande: projection adaptée aux provinces à choisir selon le calcul ; ancienne attribution EPSG:4479 à China Albers retirée

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
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "Les routes transversales sar_lag et sem_error ne sont pas les estimateurs de panel du papier. Préparer une route dédiée avant tout benchmark."
  rule: "Conserver la méthode du papier ; une famille voisine ne constitue pas une reproduction."
```

## Quality Control

- Variables: neuf X et CO2 présents ; toutes les valeurs sont finies et strictement positives, logarithmes définis sur les 450 lignes.
- Formula: transformations de l'équation (3) restaurées ; composante de régression distincte du modèle complet de panel.
- Geometry: 30 géométries provinciales répétées par année ; attribution des noms reconstruite, pas un codebook auteur.
- Duplicates: un couple id_province × year par ligne ; 30 unités à chacune des 15 dates.
- Reproducibility: attributs Mendeley conservés ; provenance de la jointure géographique et W à vérifier avant réplication exacte.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: The impact of energy price on CO2 emissions in China - A spatial econometric analysis

## ⚠️ Avertissement — identification des provinces par reconstruction, pas par codebook officiel

Les attributs viennent du dépôt Mendeley. Les noms de province et géométries ont été ajoutés par le projet ; ils ne sont pas fournis directement dans la table auteur. La curation antérieure rapporte une identification à partir de la population et de l'ordre des codes, sans codebook auteur. Cette revue confirme 30 géométries répétées sur 15 années, mais ne transforme pas cette reconstruction en provenance officiellement confirmée. La source géographique exacte et la correspondance province-identifiant doivent être tracées avant de prétendre reproduire W. Le référentiel GADM présent dans le dépôt ne prouve pas à lui seul qu'il a servi à cet objet précis.
