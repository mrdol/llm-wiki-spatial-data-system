---
title: R_ade4_sarcelles_sarcelles
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/R_ade4_sarcelles_sarcelles.rds
tags: [dataset, r-package, spatial, point]
---

The data frame ‘sarcelles$tab’ contains the number of the winter teals (_Anas C. Crecca_) for which the ring was retrieved in the area _i_ during the month _j_ (_n_=3049).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Fev`, `Jan`, `Mar`, `Dec`, `Nov`, `Aou`
- Candidate Y typology: count
- Candidate X variables: `Sep`, `Oct`, `Avr`, `Mai`, `Jun`, `Jui`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Fev` | `integer` | count | [0, 500] | 0% |
| `Jan` | `integer` | count | [0, 179] | 0% |
| `Mar` | `integer` | count | [0, 218] | 0% |
| `Dec` | `integer` | count | [0, 69] | 0% |
| `Nov` | `integer` | count | [0, 48] | 0% |
| `Aou` | `integer` | count | [0, 184] | 0% |


> **ade4** - Donnees ecologiques multivariees. La variable reponse Y et la formule sont a definir manuellement selon l'etude ciblee (ordination, RDA, etc.).

> Selection Y/X (claude-sonnet-4-6) : Chaque colonne mensuelle représente un compte de sarcelles récupérées, toutes sont candidates Y selon le mois cible modélisé (les mois de pic hivernal Jan/Fev/Mar/Dec/Nov étant les plus naturels comme variable réponse). Les mois de transition migratoire (Sep/Oct automne, Avr/Mai/Jun printemps, Jui été) peuvent servir de covariables temporelles pour expliquer les effectifs hivernaux, capturant la dynamique de migration et la disponibilité saisonnière des oiseaux.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Sep` | `integer` | count | 0% |
| `Oct` | `integer` | count | 0% |
| `Avr` | `integer` | count | 0% |
| `Mai` | `integer` | count | 0% |
| `Jun` | `integer` | count | 0% |
| `Jui` | `integer` | count | 0% |


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
- Note: Package ade4 = ordination multivariee (ACP/RDA/CCA) ; structure de donnees confirmee a 5 reprises independantes (doubs/avijons/oribatid/mafragh/jv73) comme non adaptee a une regression canonique a variable dependante unique. [Revue Tache 4 (2026-07-02) : aucune analogie structurelle pertinente identifiee avec un bon candidat existant -- statut inchange plutot que forcer un rapprochement faible.] Raison : Y et X sont tous deux des comptages mensuels d'oiseaux (juste des mois differents) -- serie temporelle/mesures repetees, pas une structure de regression covariable classique.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_ade4_sarcelles_sarcelles`
- Dataset name: ade4::sarcelles
- Source family: r-package
- Source: package R `ade4` (version 1.7.24)
- Source URL: https://CRAN.R-project.org/package=ade4
- Dataset DOI: none
- Publication DOI: pending
- Year: 2002

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
- N observations: 14
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [29.4112, 205.768], y [31.9719, 169.6298] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://CRAN.R-project.org/package=ade4
- License open: yes
- Reproducibility status: available via package R `ade4`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

WARN: CRS absent — lookup EPSG necessaire.

## Related Pages

- Source: package R `ade4`
