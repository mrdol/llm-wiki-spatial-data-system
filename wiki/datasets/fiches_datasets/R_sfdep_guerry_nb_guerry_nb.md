---
title: R_sfdep_guerry_nb_guerry_nb
type: dataset
created: 2026-07-10
updated: 2026-07-10
sources:
  - data/final_datasets/sf/R_sfdep_guerry_nb_guerry_nb.rds
tags: [dataset, r-package, spatial, point]
---

Dataset spatial issu du package R `sfdep` (`guerry_nb`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `crime_pers`, `crime_prop`, `literacy`, `suicides`, `infanticide`, `lottery`, `desertion`, `donations`
- Candidate Y typology: count
- Candidate X variables: `wealth`, `commerce`, `clergy`, `crime_parents`, `donation_clergy`, `instruction`, `prostitutes`, `distance`, `area`, `pop1831`, `infants`, `main_city`, `region`
- Candidate X typology: continuous, unknown, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `code_dept`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `crime_pers` | `integer` | count | [5883, 37014] | 0% |
| `crime_prop` | `integer` | count | [1368, 20235] | 0% |
| `literacy` | `integer` | count | [12, 74] | 0% |
| `suicides` | `integer` | count | [3460, 163241] | 0% |
| `infanticide` | `integer` | count | [1, 86] | 0% |
| `lottery` | `integer` | count | [1, 86] | 0% |
| `desertion` | `integer` | count | [1, 86] | 0% |
| `donations` | `integer` | count | [1246, 27830] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables Y candidates sont des phénomènes sociaux mesurés (criminalité, suicides, infanticide, loterie, désertion, donations, alphabétisation) typiquement modélisés comme variables réponse dans la littérature Guerry/Quetelet. Les variables X candidates regroupent des indicateurs structurels départementaux (richesse, commerce, clergé, instruction, population, superficie, distance à Paris) et contextuels (région, taille de ville) servant de covariables explicatives ; `count`, `ave_id_geo`, `dept`, `department`, `nb` et `wt` sont ignorés car purement administratifs, techniques (listes de voisinage) ou redondants.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `wealth` | `integer` | count | 0% |
| `commerce` | `integer` | count | 0% |
| `clergy` | `integer` | count | 0% |
| `crime_parents` | `integer` | count | 0% |
| `donation_clergy` | `integer` | count | 0% |
| `instruction` | `integer` | count | 0% |
| `prostitutes` | `integer` | count | 0% |
| `distance` | `numeric` | continuous | 0% |
| `area` | `integer` | count | 0% |
| `pop1831` | `numeric` | continuous | 0% |
| `infants` | `integer` | count | 0% |
| `main_city` | `ordered` | unknown | 0% |
| `region` | `factor` | categorical | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Dray, S. and Jombart, T. (2011) Revisiting Guerry's Data: Introducing Spatial Constraints in Multivariate Analysis. The Annals of Applied Statistics, Vol. 5, No. 4, 2278-2299

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: Formule systeme proposee automatiquement pour benchmark spatial ; ne pas confondre avec une formule publiee.
### Formule — niveau systeme

- formula_used: crime_pers ~ wealth + commerce + clergy + crime_parents + donation_clergy + instruction + prostitutes + distance
- x_terms_used: wealth + commerce + clergy + crime_parents + donation_clergy + instruction + prostitutes + distance
- y_term_used: crime_pers


### Formules candidates — niveau systeme

- formula_candidate_1: crime_pers ~ wealth + commerce + clergy + crime_parents + donation_clergy + instruction + prostitutes + distance
- formula_candidate_1_role: recommended_default
- formula_candidate_2: crime_pers ~ wealth + commerce + clergy + crime_parents
- formula_candidate_2_role: alternative_specification
- recommended_formula: formula_candidate_1
- selection_status: generated_system_formula
- selection_reason: candidate_1 conserve la specification systeme actuelle pour comparer les estimateurs; candidate_2 est une variante parcimonieuse utile si colinearite, temps de calcul ou petits folds posent probleme.
- preprocessing_note: Les estimateurs comme xgboost, random_forest, gamboost et spboost peuvent reduire l'effet de certaines variables via leur mecanisme d'apprentissage ou de regularisation ; les modeles lineaires/spatiaux parametriques restent plus sensibles au choix explicite de X.

## Bloc 2 — Identification et DOI

- Dataset ID: `R_sfdep_guerry_nb_guerry_nb`
- Dataset name: sfdep::guerry_nb
- Source family: r-package
- Source: package R `sfdep`
- Source URL: https://CRAN.R-project.org/package=sfdep
- Dataset DOI: none
- Publication DOI: 10.1214/10-AOAS356
- Year: 2022

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "null"
  equation_family: unknown
  model_family: "n/a"
  source_type: unknown
  source_ref: "Dray, S. and Jombart, T. (2011) Revisiting Guerry's Data: Introducing Spatial Constraints in Multivariate Analysis. The Annals of Applied Statistics, Vol. 5, No. 4, 2278-2299"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 85
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [143129.7071, 983300.7956], y [1735692.5, 2615767.5] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL-3
- License URL: https://CRAN.R-project.org/package=sfdep
- License open: yes
- Reproducibility status: available via package R `sfdep`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL-3).

## Related Pages

- Source: package R `sfdep`
