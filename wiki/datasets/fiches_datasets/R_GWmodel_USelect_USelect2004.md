---
title: R_GWmodel_USelect_USelect2004
type: dataset
created: 2026-08-15
updated: 2026-09-15
sources:
  - data/final_datasets/sf/R_GWmodel_USelect_USelect2004.rds
tags: [dataset, r-package, spatial, point]
---

Results of the 2004 US presidential election at the county level, together with five socio-economic (census) variables. This data can be used with GW Discriminant Analysis (documentation reelle du package `GWmodel`, verifiee 2026-09-15 via tools::Rd_db). Source reelle : SpatialPolygonsDataFrame de 3111 comtes americains — verifie par inspection directe (`data(USelect)` charge l'objet `USelect2004` comme SpatialPolygonsDataFrame, pas SpatialPointsDataFrame).

## Description du jeu de donnees

- Topic: elections et comportement electoral
- Observation unit: comte (county) des Etats-Unis
- Observed population: 3111 comtes americains, resultats de l'election presidentielle 2004 et variables socio-economiques du recensement
- Geographic context: Etendue mesuree dans le RDS : x [-124.208955488165, -67.554446615488], y [25.53857421875, 48.864316940308]; motif compatible avec des coordonnees geographiques non projetees (longitude/latitude, etendue continentale des Etats-Unis contigus), mais CRS non embarque dans l'objet R source (proj4string NA verifie directement) -- a documenter/confirmer avant tout usage necessitant un CRS exact.
- Temporal context: aucune variable temporelle structurelle detectee (election unique, 2004)
- Source description: Results of the 2004 US presidential election at the county level, together with five socio-economic (census) variables. This data can be used with GW Discriminant Analysis.
- Description source: package R `GWmodel`
- Description confidence: high (verifie par inspection directe R et documentation reelle du package, 2026-09-15)

> Note de fidelite (2026-09-15) : la source native est un jeu de POLYGONES (3111 comtes), mais le `.rds` local de cette fiche est un objet POINT. Contrairement a DubVoter (dont les donnees du package fournissaient deja des colonnes X/Y), l'objet source USelect2004 ne contient PAS de colonnes de coordonnees dans son slot `@data` -- les points X/Y du .rds proviennent donc probablement de centroides calcules lors de la conversion sf (memes conventions que `R_GWmodel_DubVoter_Dub.voter`), pas de coordonnees originales du package. `Type de geometrie: POINT` (Bloc 5) decrit fidelement l'artefact local, pas la geometrie source.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `winner`
- Candidate Y typology: categorical
- Candidate X variables: `unemploy`, `pctcoled`, `PEROVER65`, `pcturban`, `WHITE`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `winner` | `factor` | categorical | None | 0% |

> Selection Y/X (claude-sonnet-4-6) : Dans ce dataset sur les élections américaines, `winner` (parti/candidat vainqueur par comté) est la variable réponse naturelle à modéliser. Les cinq variables socio-démographiques (taux de chômage, niveau d'éducation, part des +65 ans, urbanisation, proportion de blancs) sont des covariables explicatives classiques des comportements électoraux.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `unemploy` | `numeric` | continuous | 0% |
| `pctcoled` | `numeric` | continuous | 0% |
| `PEROVER65` | `numeric` | continuous | 0% |
| `pcturban` | `numeric` | continuous | 0% |
| `WHITE` | `numeric` | continuous | 0% |

### Formule — niveau publication

- formula_pub: winner ~ unemploy + pctcoled + PEROVER65 + pcturban + WHITE
- x_terms_pub: unemploy, pctcoled, PEROVER65, pcturban, WHITE
- y_term_pub: winner
- Reference publication: Foley, P. & Demsar, U. (2012), "Using geovisual analytics to compare the performance of geographically weighted discriminant analysis versus its global counterpart, linear discriminant analysis," International Journal of Geographical Information Science 27:633-661, DOI 10.1080/13658816.2012.722638 (Crossref-verifie). Reference documentee directement par GWmodel::USelect comme methode d'analyse applicable a ce jeu de donnees (GW Discriminant Analysis, winner comme reponse categorielle). Reference secondaire (contexte cartographique, pas d'equation) : Robinson, A. C. (2013), Geovisualization of the 2004 Presidential Election, Penn State / National Institutes of Health (ressource web, pas un article evalue par les pairs).

### Statut regression canonique

- Statut: candidat par analogie -- non verifie
- Niveau de preuve: analogie
- Methode d'estimation: GW Discriminant Analysis (classification categorielle) selon la documentation officielle du package, qui cite explicitement Foley & Demsar (2012) comme reference methodologique pour ce jeu de donnees
- Correspondance Python/R: aucune identifiee
- Note: Correction 2026-09-15 (mode production de secours) : la fiche citait auparavant Robinson (2013), une ressource web de geovisualisation cartographique sans preuve d'une specification de regression precise, comme source "resolu/publication" -- affirmation non etayee. Remplacee par Foley & Demsar (2012), reference methodologique reelle documentee par le package lui-meme pour l'usage GW Discriminant Analysis sur ce jeu de donnees exact. La formule (winner ~ les 5 covariables disponibles) reste plausible par analogie avec l'objectif documente (discriminant analysis utilisant toutes les covariables socio-economiques), mais le texte integral de Foley & Demsar (2012) n'est pas dans le corpus -- la specification exacte n'a pas ete confirmee verbatim.

### Formule — niveau systeme

- formula_used: winner ~ unemploy + pctcoled + PEROVER65 + pcturban + WHITE
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: categorical
- x_terms_used: unemploy, pctcoled, PEROVER65, pcturban, WHITE
- y_term_used: winner

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "winner ~ unemploy + pctcoled + PEROVER65 + pcturban + WHITE"
    response: "winner"
    predictors: ["unemploy, pctcoled, PEROVER65, pcturban, WHITE"]
    role: "simple_baseline"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Foley, P. & Demsar, U. (2012), IJGIS 27:633-661, DOI 10.1080/13658816.2012.722638 -- reference GW Discriminant Analysis documentee par GWmodel::USelect"
    estimator_context: ["linear_regression", "kriging_auxiliary", "spatial_baseline"]
    status: "candidat_par_analogie"

  multivariate_constrained:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "paper_main_specification"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

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

- Dataset ID: `R_GWmodel_USelect_USelect2004`
- Dataset name: GWmodel::USelect
- Source family: r-package
- Source: package R `GWmodel`
- Source URL: https://CRAN.R-project.org/package=GWmodel
- Dataset DOI: none
- Publication DOI: pending
- Year: 2013

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "winner ~ unemploy + pctcoled + PEROVER65 + pcturban + WHITE"
  equation_family: discriminant_analysis
  model_family: "candidat par analogie -- GW discriminant analysis, methode documentee par le package mais equation exacte non verifiee en texte integral"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Foley, P. & Demsar, U. (2012), IJGIS 27:633-661, DOI 10.1080/13658816.2012.722638"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 3111
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-124.209, -67.5544], y [25.5386, 48.8643] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://CRAN.R-project.org/package=GWmodel
- License open: yes
- Reproducibility status: available via package R `GWmodel`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_non_continuous_response"
  benchmark_task: "not_current_regression_benchmark"
  package_include: "no"
  has_local_rds: true
  missing_items: "route classification/binomiale/survie ou transformation continue explicite requise"
  reason: "La variable reponse ou la formule n est pas une regression continue scalaire compatible avec le benchmark actuel."
```

- Decision: not_ready_non_continuous_response
- Manque principal: route classification/binomiale/survie ou transformation continue explicite requise
- Raison: La variable reponse ou la formule n est pas une regression continue scalaire compatible avec le benchmark actuel.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: WARN - formule reclassee "candidat par analogie" le 2026-09-15 ; reference remplacee (Robinson 2013 -> Foley & Demsar 2012), voir Statut regression canonique.
- CRS: WARN - CRS absent du `.rds` source (proj4string NA verifie sur l'objet R source) ; motif de bbox compatible avec WGS84 non projete, a confirmer.
- Geometry: WARN - Type de geometrie POINT dans le .rds local, mais la source native est un SpatialPolygonsDataFrame (3111 comtes) sans colonnes de coordonnees propres ; conversion probable en centroides lors du pipeline sf (voir note de fidelite en Description du jeu de donnees).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2)).

## Related Pages

- Source: package R `GWmodel`

## Curation documentée — 2026-09-07

Verification directe (mode production de secours, tools::Rd_db("GWmodel") + inspection R de l'objet source) : description generique remplacee par le texte reel de la documentation du package ; source confirmee SpatialPolygonsDataFrame (3111 comtes), non SpatialPointsDataFrame -- note de fidelite ajoutee. Reference publication corrigee : Robinson (2013), une ressource web de cartographie sans preuve de specification statistique, remplacee par Foley & Demsar (2012) (DOI verifie 10.1080/13658816.2012.722638), la reference methodologique reelle citee par la documentation officielle du package pour l'usage GW Discriminant Analysis sur ce jeu de donnees exact. formula_pub reclassee "resolu/publication" -> "candidat par analogie/analogie" car le texte integral de Foley & Demsar (2012) n'est pas dans le corpus et la specification exacte n'a pas pu etre confirmee verbatim -- correction appliquee pour respecter la regle N'invente rien.
