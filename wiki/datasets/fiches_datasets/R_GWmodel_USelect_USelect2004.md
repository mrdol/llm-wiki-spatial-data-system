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

> Note de fidelite (2026-09-15, corrigee) : la source native est un jeu de POLYGONES (3111 comtes, MULTIPOLYGON). Le `.rds` local conserve les DEUX geometries, conformement a la methodologie documentee du pipeline sf (code/r_catalog/guide_objets_sf.md, section 3-5) : `geom_origine` (verifie directement sur le .rds : sfc_MULTIPOLYGON, geometrie complete d'origine, conservee pour les usages necessitant les contours -- ex. matrices de contiguite/voisinage) et `geom_point` (geometrie active, un point garanti a l'INTERIEUR du polygone via `st_point_on_surface()` -- pas un centroide simple). Rien n'est perdu : `Type de geometrie: POINT` (Bloc 5) decrit uniquement la geometrie active par defaut, utilisee pour l'usage uniforme des estimateurs a support ponctuel du benchmark.

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
- Reference publication: Foley, P. & Demsar, U. (2012), "Using geovisual analytics to compare the performance of geographically weighted discriminant analysis versus its global counterpart, linear discriminant analysis," International Journal of Geographical Information Science 27:633-661, DOI 10.1080/13658816.2012.722638 (Crossref-verifie) -- reference methodologique d'origine. Lu, B., Harris, P., Charlton, M. & Brunsdon, C. (2014), "The GWmodel R package: further topics for exploring spatial heterogeneity using geographically weighted models," Geo-spatial Information Science 17(2), DOI 10.1080/10095020.2014.917453 (Crossref-verifie ; texte integral dans corpus/papers/tei/Lu_2014_GWmodel_further_topics.tei.xml), Section 2.3.2/6 "US 2004 election data" -- confirme verbatim (avec code R executable) que ces 5 covariables exactes sont reprises de Foley & Demsar (2012). Gollini, I., Lu, B., Charlton, M., Brunsdon, C. & Harris, P. (2015), "GWmodel: An R Package for Exploring Spatial Heterogeneity Using Geographically Weighted Models," Journal of Statistical Software 63(17), DOI 10.18637/jss.v063.i17 (Crossref-verifie ; texte integral dans corpus/papers/tei/Gollini_2015_GWmodel_JSS.tei.xml) -- confirme que la donnee brute (winner + 5 covariables) est documentee comme "a subset of that provided in (Robinson 2013)" -- Robinson (2013) est donc la source de la DONNEE brute, pas de la specification du MODELE statistique.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: verbatim
- Methode d'estimation: GW Discriminant Analysis (`gwda()`), formule confirmee par code R verbatim
- Correspondance Python/R: aucune identifiee
- Note: Citation verbatim retrouvee dans le texte integral de Lu et al. (2014) (corpus/papers/tei/Lu_2014_GWmodel_further_topics.tei.xml, section "US 2004 election data") : "For the USelect data, the five independent variables are taken the same as that used in Foley and Demsar (28), as follows: percentage unemployed (unemployed); percentage of adults over 25 with 4 or more years of college education (pctcoled); percentage of persons over the age of 65 (PEROVER65); percentage urban (pcturban); percentage white (WHITE)." Le meme papier fournit le code R executable exact : `lda(winner~unemploy+pctcoled+PEROVER65+pcturban+WHITE, USelect2004)` et `gwda(winner~unemploy+pctcoled+PEROVER65+pcturban+WHITE, USelect2004, kernel="bisquare", adaptive=T, dMat=Dmat)`. Correction 2026-09-15 (deuxieme passe) : une premiere correction avait degrade ce champ vers "candidat par analogie" faute d'avoir trouve le texte integral de Foley & Demsar (2012) -- corrige apres verification que Lu et al. (2014) et Gollini et al. (2015), deux papiers du corpus qui documentent directement ce jeu de donnees, confirment verbatim (code R inclus) la formule et sa reference.

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
    source_ref: "Foley & Demsar (2012), IJGIS 27:633-661, DOI 10.1080/13658816.2012.722638 -- formule et code R confirmes verbatim dans Lu et al. (2014), DOI 10.1080/10095020.2014.917453, texte integral dans le corpus"
    estimator_context: ["linear_regression", "kriging_auxiliary", "spatial_baseline"]
    status: "confirmed"

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

- Modele niveau 1 (tache): classification
- Modele niveau 2 (famille): discriminant_analysis
- Modele niveau 3 (variante): GW Discriminant Analysis (`gwda()`)

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "winner ~ unemploy + pctcoled + PEROVER65 + pcturban + WHITE"
  equation_family: discriminant_analysis
  model_family: "GW discriminant analysis -- confirme verbatim (code R inclus) par Lu et al. (2014), texte integral dans le corpus"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Foley & Demsar (2012), IJGIS 27:633-661, DOI 10.1080/13658816.2012.722638 ; confirme par Lu et al. (2014), DOI 10.1080/10095020.2014.917453"
  confidence: high
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
- Formula: OK - formule et code R confirmes verbatim par Lu et al. (2014) (texte integral dans le corpus), voir Statut regression canonique.
- CRS: WARN - CRS absent du `.rds` source (proj4string NA verifie sur l'objet R source) ; motif de bbox compatible avec WGS84 non projete, a confirmer.
- Geometry: OK - la source native est un SpatialPolygonsDataFrame (3111 comtes) ; le .rds local conserve les DEUX geometries -- `geom_origine` (MULTIPOLYGON, verifie directement sur le .rds) et `geom_point` (point interieur garanti, derive via `st_point_on_surface()` selon la methodologie documentee dans code/r_catalog/guide_objets_sf.md, section 3 -- pas un centroide simple). `Type de geometrie: POINT` (Bloc 5) decrit la geometrie active, pas une perte d'information.
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2)).

## Related Pages

- Source: package R `GWmodel`

## Curation documentée — 2026-09-07

Deuxieme passe de verification 2026-09-15 (mode production de secours), suite a deux corrections du lecteur : (1) `Type de geometrie: POINT` avait ete presente a tort comme une possible perte d'information -- verification directe du .rds confirme que `geom_origine` (MULTIPOLYGON) est bien preserve, conformement a la methodologie documentee du pipeline sf (code/r_catalog/guide_objets_sf.md, section 3-5) : `geom_point` est un point garanti a l'interieur du polygone (`st_point_on_surface()`), gardee pour l'usage uniforme des estimateurs, tandis que `geom_origine` reste disponible pour les matrices de contiguite. (2) formula_pub avait ete degrade vers "candidat par analogie" faute de texte integral -- recherche plus approfondie dans le corpus (data/manifests/papers/model_evidence_audit.csv) revele que Lu et al. (2014, DOI 10.1080/10095020.2014.917453) et Gollini et al. (2015, DOI 10.18637/jss.v063.i17) documentent directement ce jeu de donnees en texte integral. Lu et al. (2014) fournit le code R executable exact (`gwda(winner~unemploy+pctcoled+PEROVER65+pcturban+WHITE, USelect2004, ...)`) et confirme explicitement que les 5 covariables proviennent de Foley & Demsar (2012) -- formula_pub restaure a "resolu/verbatim", la reference Foley & Demsar (2012) deja retenue lors de la premiere correction s'avere donc etre la bonne.
