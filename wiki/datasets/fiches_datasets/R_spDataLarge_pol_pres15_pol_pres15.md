---
title: R_spDataLarge_pol_pres15_pol_pres15
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/R_spDataLarge_pol_pres15_pol_pres15.rds
tags: [dataset, r-package, spatial, point]
---

Polish Presidential election 2015 data by gminy and Warsaw borough areal units

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

- formula_pub: none (aucune regression canonique documentee -- recherche manuelle exhaustive menee)
- x_terms_pub: none
- y_term_pub: none
- Reference publication: none (aucune source verifiable retrouvee)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: mauvais candidat
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: Elections POLONAISES (et non espagnoles malgre le nom) de 2015 ; usage confirme = clustering SKATER (regionalisation), pas de regression. [Revue Tache 4 (2026-07-02) : aucune analogie structurelle pertinente identifiee avec un bon candidat existant -- statut inchange plutot que forcer un rapprochement faible.] Raison : Aucune covariable demographique independante disponible -- seules d'autres tallies electorales administratives (entitled_to_vote, voting_papers) sont presentes, regression circulaire.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

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
  equation_text: "null"
  equation_family: unknown
  model_family: "unknown"
  source_type: unknown
  source_ref: "null"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 2495
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_1

> **Correction metadonnees (Tache 2, juillet 2026)** — Erreur de generation confirmee (voir mission) : ce dataset est un objet sf de polygones electoraux polonais (2495 unites administratives, elections 2015), sans structure panel — les tours 1 et 2 de l'election sont des paires de colonnes (I_*/II_*) dans la meme ligne, pas des periodes repetees. Confirme par wiki/datasets/r_package_docs/spDataLarge/topics/pol_pres15.md ('sf data frame object with 2495 areal units and 65 variables').
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

Aucune anomalie detectee.

## Related Pages

- Source: package R `spDataLarge`
