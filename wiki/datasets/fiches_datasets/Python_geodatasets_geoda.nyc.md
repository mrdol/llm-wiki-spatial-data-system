---
title: Python_geodatasets_geoda.nyc
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.nyc.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`nyc`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `rent2008`, `rentpct08`, `kids2009`, `pubast00`, `hhsiz08`
- Candidate Y typology: count, continuous
- Candidate X variables: `forhis06`, `forhis07`, `forhis08`, `forhis09`, `forwh06`, `forwh07`, `forwh08`, `forwh09`, `hhsiz1990`, `hhsiz00`, `hhsiz02`, `hhsiz05`, `kids2000`, `kids2005`, `kids2006`, `kids2007`, `kids2008`, `rent2002`, `rent2005`, `rentpct02`, `rentpct05`, `pubast90`, `yrhom02`, `yrhom05`, `yrhom08`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `code`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `rent2008` | `integer` | count | [0, 2900] | 0% |
| `rentpct08` | `numeric` | continuous | [0, 47.3805] | 0% |
| `kids2009` | `numeric` | continuous | [0, 48.1308] | 0% |
| `pubast00` | `numeric` | continuous | [0.8981, 23.4318] | 0% |
| `hhsiz08` | `numeric` | continuous | [1.5443, 3.2223] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables les plus récentes (rent2008, rentpct08, kids2009, pubast00, hhsiz08) sont retenues comme cibles plausibles car elles représentent des outcomes socio-économiques d'intérêt (loyer, part d'enfants, aide publique, taille du ménage) à la date la plus récente du dataset. Les séries temporelles antérieures et les variables structurelles (composition ethnique, durée de résidence) constituent des covariables explicatives naturelles ; name, subborough et bor_subb sont ignorés car purement administratifs/géographiques.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `forhis06` | `numeric` | continuous | 0% |
| `forhis07` | `numeric` | continuous | 0% |
| `forhis08` | `numeric` | continuous | 0% |
| `forhis09` | `numeric` | continuous | 0% |
| `forwh06` | `numeric` | continuous | 0% |
| `forwh07` | `numeric` | continuous | 0% |
| `forwh08` | `numeric` | continuous | 0% |
| `forwh09` | `numeric` | continuous | 0% |
| `hhsiz1990` | `numeric` | continuous | 0% |
| `hhsiz00` | `numeric` | continuous | 0% |
| `hhsiz02` | `numeric` | continuous | 0% |
| `hhsiz05` | `numeric` | continuous | 0% |
| `kids2000` | `numeric` | continuous | 0% |
| `kids2005` | `numeric` | continuous | 0% |
| `kids2006` | `numeric` | continuous | 0% |
| `kids2007` | `numeric` | continuous | 0% |
| `kids2008` | `numeric` | continuous | 0% |
| `rent2002` | `integer` | count | 0% |
| `rent2005` | `integer` | count | 0% |
| `rentpct02` | `numeric` | continuous | 0% |
| `rentpct05` | `numeric` | continuous | 0% |
| `pubast90` | `numeric` | continuous | 0% |
| `yrhom02` | `numeric` | continuous | 0% |
| `yrhom05` | `numeric` | continuous | 0% |
| `yrhom08` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: rent2008~forhis08+forwh08+hhsiz08+pubast90+kids2008
- x_terms_pub: forhis08+forwh08+hhsiz08+pubast90+kids2008
- y_term_pub: rent2008
- Reference publication: Analogie structurelle avec spdata.boston / geoda.us_sdoh (banque interne, mission 2026-07)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: candidat par analogie -- non verifie
- Niveau de preuve: analogie
- Methode d'estimation: OLS
- Correspondance Python/R: aucune identifiee
- Note: CANDIDAT PAR ANALOGIE -- non verifie. Loyer de secteur explique par composition demographique -- structure hedonique/SDOH comparable a Boston/us_sdoh. NOTE ADDITIONNELLE (hors perimetre formule) : ce dataset presente le meme pattern de colonnes suffixees par annee (rent2002/2005/2008, kids2000..2008, hhsiz1990..08) que Python_geodatasets_geoda.chile_labor -- possible structure spatio-temporelle en format large non detectee, a verifier separement (Tache 2).

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.nyc`
- Dataset name: geodatasets::nyc
- Source family: python-package
- Source: package Python `geodatasets`
- Source URL: https://pypi.org/project/geodatasets/
- Dataset DOI: none
- Publication DOI: pending
- Year: 2023

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "rent2008~forhis08+forwh08+hhsiz08+pubast90+kids2008"
  equation_family: linear
  model_family: "OLS"
  source_type: unknown
  source_ref: "Analogie structurelle avec spdata.boston / geoda.us_sdoh (banque interne, mission 2026-07)"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 55
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-74.1942, -73.736], y [40.5369, 40.891] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32618 (UTM Zone 18N (EPSG:32618)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/geodatasets/
- License open: yes
- Reproducibility status: available via package Python `geodatasets`
- Code available: yes (package examples and vignettes)
- Repository: python-package

## Quality Control

Aucune anomalie detectee.

## Related Pages

- Source: package Python `geodatasets`
