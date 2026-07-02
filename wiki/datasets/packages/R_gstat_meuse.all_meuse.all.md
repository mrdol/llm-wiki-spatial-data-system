---
title: R_gstat_meuse.all_meuse.all
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/R_gstat_meuse.all_meuse.all.rds
tags: [dataset, r-package, spatial, point]
---

This data set gives locations and top soil heavy metal concentrations (ppm), along with a number of soil and landscape variables, collected in a flood plain of the river Meuse, near the village Stein. Heavy metal concentrations are bulk sampled from an area of approximately 15 m x 15 m.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `cadmium`, `copper`, `lead`, `zinc`
- Candidate Y typology: continuous
- Candidate X variables: `elev`, `dist.m`, `om`, `ffreq`, `soil`, `lime`, `landuse`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `cadmium` | `numeric` | continuous | [0, 18.1] | 0% |
| `copper` | `numeric` | continuous | [14, 128] | 0% |
| `lead` | `numeric` | continuous | [27, 654] | 0% |
| `zinc` | `numeric` | continuous | [107, 1839] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les concentrations en métaux lourds (cadmium, copper, lead, zinc) sont les variables cibles naturelles de ce dataset de contamination des sols. Les variables environnementales et pédologiques (élévation, distance à la rivière, matière organique, fréquence d'inondation, type de sol, présence de calcaire, usage des terres) sont des covariables explicatives classiques pour modéliser la dispersion des métaux. Les colonnes 'sample', 'in.pit', 'in.meuse155' et 'in.BMcD' sont des identifiants ou indicateurs d'appartenance à des sous-ensembles (flags techniques) sans valeur explicative directe.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `elev` | `numeric` | continuous | 0% |
| `dist.m` | `numeric` | continuous | 0% |
| `om` | `numeric` | continuous | 1.2% |
| `ffreq` | `numeric` | continuous | 0% |
| `soil` | `numeric` | continuous | 0% |
| `lime` | `numeric` | binary | 0% |
| `landuse` | `factor` | categorical | 0.6% |


### Formule — niveau publication

- formula_pub: log(zinc)~sqrt(dist) (idem cadmium/lead/copper)
- x_terms_pub: sqrt(dist) (idem cadmium/lead/copper)
- y_term_pub: log(zinc)
- Reference publication: Tutoriel officiel gstat (Pebesma)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: OLS + krigeage universel
- Correspondance Python/R: R_sp_meuse_meuse
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_gstat_meuse.all_meuse.all`
- Dataset name: gstat::meuse.all
- Source family: r-package
- Source: package R `gstat` (version 2.1.6)
- Source URL: https://CRAN.R-project.org/package=gstat
- Dataset DOI: none
- Publication DOI: pending
- Year: 2003

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "log(zinc)~sqrt(dist) (idem cadmium/lead/copper)"
  equation_family: unknown
  model_family: "OLS + krigeage universel"
  source_type: software_documentation
  source_ref: "Tutoriel officiel gstat (Pebesma)"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 164
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [178605, 181390], y [329714, 333611] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2.0)
- License URL: https://CRAN.R-project.org/package=gstat
- License open: yes
- Reproducibility status: available via package R `gstat`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

WARN: CRS absent — lookup EPSG necessaire.

## Related Pages

- Source: package R `gstat`
