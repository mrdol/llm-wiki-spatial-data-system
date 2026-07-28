---
title: R_spDataLarge_pol_pres15_pol_pres15
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/R_spDataLarge_pol_pres15_pol_pres15.rds
tags: [dataset, r-package, spatial, point]
---

Polish Presidential election 2015 data by gminy and Warsaw borough areal units

## Description du jeu de donnees

- Topic: elections et comportement electoral
- Observation unit: circonscription, bureau de vote ou unite administrative
- Observed population: resultats electoraux ou population votante
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Polish Presidential election 2015 data by gminy and Warsaw borough areal units
- Description source: package R `spDataLarge`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `I_turnout`, `II_turnout`, `I_Duda_share`, `II_Duda_share`, `I_Komorowski_share`, `II_Komorowski_share`
- Candidate Y typology: rate
- Candidate X variables: `types`, `I_entitled_to_vote`, `II_entitled_to_vote`, `I_voters_voting_by_proxy`, `I_voters_voting_by_declaration`, `I_postal_voting_envelopes_received`, `I_invalid_votes`, `II_voters_voting_by_proxy`, `II_voters_voting_by_declaration`, `II_postal_voting_envelopes_received`, `II_invalid_votes`, `I_Grzegorz.Michal.Braun`, `I_Adam.Sebastian.Jarubas`, `I_Janusz.Ryszard.Korwin.Mikke`, `I_Marian.Janusz.Kowalski`, `I_Pawel.Piotr.Kukiz`, `I_Magdalena.Agnieszka.Ogorek`, `I_Janusz.Marian.Palikot`, `I_Pawel.Jan.Tanajno`, `I_Jacek.Wilk`
- Candidate X typology: categorical, continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `I_turnout` | `numeric` | rate | [0.2634, 0.6768] | 0% |
| `II_turnout` | `numeric` | rate | [0.3363, 0.7548] | 0% |
| `I_Duda_share` | `numeric` | rate | [0.0643, 0.7857] | 0% |
| `II_Duda_share` | `numeric` | rate | [0.154, 0.9508] | 0% |
| `I_Komorowski_share` | `numeric` | rate | [0.0375, 0.669] | 0% |
| `II_Komorowski_share` | `numeric` | rate | [0.0492, 0.846] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les taux de participation (I/II_turnout) et les parts de vote des candidats principaux (Duda, Komorowski) aux deux tours constituent les variables réponse naturelles pour modéliser les comportements électoraux spatiaux. Le type de commune (types), la taille de l'électorat (entitled_to_vote), les modalités de vote alternatif (proxy, declaration, postal), les votes invalides et les scores des candidats mineurs au 1er tour servent de covariables explicatives ; les colonnes administratives (TERYT, noms) sont ignorées.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `types` | `factor` | categorical | 0% |
| `I_entitled_to_vote` | `integer` | count | 0% |
| `II_entitled_to_vote` | `integer` | count | 0% |
| `I_voters_voting_by_proxy` | `integer` | count | 0% |
| `I_voters_voting_by_declaration` | `integer` | count | 0% |
| `I_postal_voting_envelopes_received` | `integer` | count | 0% |
| `I_invalid_votes` | `integer` | count | 0% |
| `II_voters_voting_by_proxy` | `integer` | count | 0% |
| `II_voters_voting_by_declaration` | `integer` | count | 0% |
| `II_postal_voting_envelopes_received` | `integer` | count | 0% |
| `II_invalid_votes` | `integer` | count | 0% |
| `I_Grzegorz.Michal.Braun` | `integer` | count | 0% |
| `I_Adam.Sebastian.Jarubas` | `integer` | count | 0% |
| `I_Janusz.Ryszard.Korwin.Mikke` | `integer` | count | 0% |
| `I_Marian.Janusz.Kowalski` | `integer` | count | 0% |
| `I_Pawel.Piotr.Kukiz` | `integer` | count | 0% |
| `I_Magdalena.Agnieszka.Ogorek` | `integer` | count | 0% |
| `I_Janusz.Marian.Palikot` | `integer` | count | 0% |
| `I_Pawel.Jan.Tanajno` | `integer` | count | 0% |
| `I_Jacek.Wilk` | `integer` | count | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: pending

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d'estimation: formule candidate generee par le systeme
- Correspondance Python/R: aucune identifiee
- Note: Aucune formule publiee n'a ete confirmee; deux formules candidates ont ete produites par le systeme et la formule recommandee est reportee dans formula_used.
### Formule — niveau systeme

- formula_used: I_turnout ~ types + I_entitled_to_vote + II_entitled_to_vote + I_voters_voting_by_proxy + I_voters_voting_by_declaration + I_postal_voting_envelopes_received + I_invalid_votes + II_voters_voting_by_proxy
- x_terms_used: types + I_entitled_to_vote + II_entitled_to_vote + I_voters_voting_by_proxy + I_voters_voting_by_declaration + I_postal_voting_envelopes_received + I_invalid_votes + II_voters_voting_by_proxy
- y_term_used: I_turnout

## Bloc 2 — Identification et DOI

- Dataset ID: `R_spDataLarge_pol_pres15_pol_pres15`
- Dataset name: spDataLarge::pol_pres15
- Source family: r-package
- Source: package R `spDataLarge` (version 2.2.0)
- Source URL: https://CRAN.R-project.org/package=spDataLarge
- Dataset DOI: none
- Publication DOI: pending
- Year: 2017

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: I_turnout ~ types + I_entitled_to_vote + II_entitled_to_vote + I_voters_voting_by_proxy + I_voters_voting_by_declaration + I_postal_voting_envelopes_received + I_invalid_votes + II_voters_voting_by_proxy
  equation_family: regression_candidate
  model_family: spatial_regression_candidate
  source_type: generated_system_formula
  source_ref: data/manifests/datasets/proposed_formula_used_audit.csv
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 2495
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [14.2222, 24.0176], y [49.1565, 54.7922] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32634 (UTM Zone 34N (EPSG:32634)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: CC0
- License URL: https://CRAN.R-project.org/package=spDataLarge
- License open: yes
- Reproducibility status: available via package R `spDataLarge`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: CANDIDATE - formule systeme proposee, sans source publication confirmee.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (CC0).

## Related Pages

- Source: package R `spDataLarge`
