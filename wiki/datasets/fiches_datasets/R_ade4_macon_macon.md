---
title: R_ade4_macon_macon
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/R_ade4_macon_macon.rds
tags: [dataset, r-package, spatial, point]
---

The ‘macon’ data frame has 8 rows-wines and 25 columns-tasters. Each column is a classification of 8 wines (Beaujolais, France).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `a`
- Candidate Y typology: continuous
- Candidate X variables: `b`, `c`, `d`, `e`, `f`, `g`, `h`, `i`, `j`, `k`, `l`, `m`, `n`, `o`, `p`, `q`, `r`, `s`, `t`, `u`, `v`, `w`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `a` | `numeric` | continuous | [1, 8] | 0% |


> **ade4** - Donnees ecologiques multivariees. La variable reponse Y et la formule sont a definir manuellement selon l'etude ciblee (ordination, RDA, etc.).

> Selection Y/X (claude-sonnet-4-6) : Ce dataset de dégustation contient les classements de 8 vins par 23 dégustateurs (colonnes a–w), toutes symétriques et de même nature. En l'absence de variable cible évidente, on peut modéliser le classement d'un dégustateur (ex: 'a') en fonction des classements des autres dégustateurs (b–w), par exemple pour prédire le consensus ou détecter des profils de goût similaires via spatial/agreement modeling.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `b` | `numeric` | continuous | 0% |
| `c` | `numeric` | continuous | 0% |
| `d` | `numeric` | continuous | 0% |
| `e` | `numeric` | continuous | 0% |
| `f` | `numeric` | continuous | 0% |
| `g` | `numeric` | continuous | 0% |
| `h` | `numeric` | continuous | 0% |
| `i` | `numeric` | continuous | 0% |
| `j` | `numeric` | continuous | 0% |
| `k` | `numeric` | continuous | 0% |
| `l` | `numeric` | continuous | 0% |
| `m` | `numeric` | continuous | 0% |
| `n` | `numeric` | continuous | 0% |
| `o` | `numeric` | continuous | 0% |
| `p` | `numeric` | continuous | 0% |
| `q` | `numeric` | continuous | 0% |
| `r` | `numeric` | continuous | 0% |
| `s` | `numeric` | continuous | 0% |
| `t` | `numeric` | continuous | 0% |
| `u` | `numeric` | continuous | 0% |
| `v` | `numeric` | continuous | 0% |
| `w` | `numeric` | continuous | 0% |


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
- Note: Package ade4 = ordination multivariee (ACP/RDA/CCA) ; structure de donnees confirmee a 5 reprises independantes (doubs/avijons/oribatid/mafragh/jv73) comme non adaptee a une regression canonique a variable dependante unique. [Revue Tache 4 (2026-07-02) : aucune analogie structurelle pertinente identifiee avec un bon candidat existant -- statut inchange plutot que forcer un rapprochement faible.] Raison : Colonnes anonymes a une lettre (a, b, c...w) sans documentation du sens reel des variables (degustation de vin, Foire de Macon 1985) -- impossible de juger la coherence substantielle d'une formule.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_ade4_macon_macon`
- Dataset name: ade4::macon
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
- N observations: 8
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [1, 8], y [1, 8] (CRS unknown)
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
