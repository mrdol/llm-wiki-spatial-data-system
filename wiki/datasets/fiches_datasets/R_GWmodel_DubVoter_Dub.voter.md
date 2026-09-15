---
title: R_GWmodel_DubVoter_Dub.voter
type: dataset
created: 2026-08-15
updated: 2026-09-15
sources:
  - data/final_datasets/sf/R_GWmodel_DubVoter_Dub.voter.rds
tags: [dataset, r-package, spatial, point]
---

Voter turnout and social characters data in Greater Dublin for the 2002 General election and the 2002 census. Note that this data set was originally thought to relate to 2004, so for continuity the package retains the associated variable names (ex. `GenEl2004`). Source reelle du package : `DubVoter.shp`, un SpatialPolygonsDataFrame de 322 divisions electorales (ED) — verifie par inspection directe (`data(DubVoter)` charge l'objet `Dub.voter` comme SpatialPolygonsDataFrame, pas SpatialPointsDataFrame).

## Description du jeu de donnees

- Topic: elections et comportement electoral
- Observation unit: division electorale (Electoral Division, ED) de la region du Grand Dublin
- Observed population: 322 divisions electorales du Grand Dublin, participation et caracteristiques socio-demographiques du recensement 2002
- Geographic context: Etendue mesuree dans le RDS : x [300888.2240334547, 328236.4395205436], y [220662.35184542695, 263404.7994482985]; CRS non renseigne (proj4string NA verifie directement sur l'objet R), coordonnees compatibles avec le systeme national irlandais (Irish Grid, metres).
- Temporal context: aucune variable temporelle structurelle detectee (photographie 2002)
- Source description: Voter turnout and social characters data in Greater Dublin for the 2002 General election and the 2002 census (documentation reelle du package `GWmodel`, verifiee 2026-09-15 via tools::Rd_db).
- Description source: package R `GWmodel`
- Description confidence: high (verifie par inspection directe R et documentation reelle du package, 2026-09-15)

> Note de fidelite (2026-09-15) : la source native (`DubVoter.shp`) est un jeu de POLYGONES (322 EDs), mais le `.rds` local de cette fiche est un objet POINT (centroides administratifs, colonnes X/Y deja fournies dans les donnees du package). C'est une simplification deliberee et documentee du pipeline de conversion sf (memes conventions appliquees a `R_GWmodel_USelect_USelect2004`, egalement natif polygone), pas une erreur : elle permet l'usage uniforme des estimateurs a support ponctuel du benchmark. `Type de geometrie: POINT` (Bloc 5) decrit fidelement l'artefact local, pas la geometrie source.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `GenEl2004`
- Candidate Y typology: continuous
- Candidate X variables: `DiffAdd`, `LARent`, `SC1`, `Unempl`, `LowEduc`, `Age18_24`, `Age25_44`, `Age45_64`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `DED_ID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `GenEl2004` | `numeric` | continuous | [27.9846, 72.9142] | 0% |

> Selection Y/X (claude-sonnet-4-6) : GenEl2004 représente le taux de participation (ou résultat) aux élections générales de 2004, variable de sortie typique des études de comportement électoral spatial. Les autres colonnes (mobilité résidentielle, location sociale, statut socio-économique, chômage, faible niveau d'éducation, tranches d'âge) sont des covariables socio-démographiques classiquement utilisées pour expliquer les variations spatiales du vote.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `DiffAdd` | `numeric` | continuous | 0% |
| `LARent` | `numeric` | continuous | 0% |
| `SC1` | `numeric` | continuous | 0% |
| `Unempl` | `numeric` | continuous | 0% |
| `LowEduc` | `numeric` | continuous | 0% |
| `Age18_24` | `numeric` | continuous | 0% |
| `Age25_44` | `numeric` | continuous | 0% |
| `Age45_64` | `numeric` | continuous | 0% |

### Formule — niveau publication

- formula_pub: GenEl2004~DiffAdd+LARent+SC1+Unempl+LowEduc+Age18_24+Age25_44+Age45_64
- x_terms_pub: DiffAdd, LARent, SC1, Unempl, LowEduc, Age18_24, Age25_44, Age45_64
- y_term_pub: GenEl2004
- Reference publication: Kavanagh A (2006) Turnout or turned off? Electoral participation in Dublin in the early 21st Century. Journal of Irish Urban Studies, 3(2):1-24 (aucun DOI trouve via Crossref -- revue academique peu indexee, existence plausible mais texte integral non accessible/non verifie). Harris P, Brunsdon C, Charlton M (2011), Geographically weighted principal components analysis, International Journal of Geographical Information Science 25(10):1717-1736, DOI 10.1080/13658816.2011.554838 (Crossref-verifie) -- seconde reference documentee par GWmodel::DubVoter, analyse GWPCA (pas une regression sur GenEl2004).

### Statut regression canonique

- Statut: candidat par analogie -- non verifie
- Niveau de preuve: analogie
- Methode d'estimation: aucune equation exacte retrouvee dans le texte integral (Kavanagh 2006 non accessible, sans DOI) ; la formule utilise l'ensemble des covariables socio-demographiques documentees par le package pour expliquer GenEl2004, par analogie avec le sujet de l'etude (participation electorale) mais sans confirmation verbatim d'une specification de regression precise
- Correspondance Python/R: aucune identifiee
- Note: Correction 2026-09-15 (mode production de secours) : la fiche affichait auparavant "Statut: resolu / Niveau de preuve: publication", ce qui suggerait une equation verifiee en texte integral. Or Kavanagh (2006) n'a pas de DOI resolvable et son texte integral n'est pas dans le corpus -- impossible de confirmer que cette formule (utilisant les 8 covariables disponibles) correspond a une specification reelle de l'article plutot qu'a une generation systeme. Degrade honnetement vers "candidat par analogie" plutot que de laisser une declaration de verification non etayee (regle N'invente rien).

### Formule — niveau systeme

- formula_used: GenEl2004~DiffAdd+LARent+SC1+Unempl+LowEduc+Age18_24+Age25_44+Age45_64
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: DiffAdd, LARent, SC1, Unempl, LowEduc, Age18_24, Age25_44, Age45_64
- y_term_used: GenEl2004

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "GenEl2004~DiffAdd+LARent+SC1+Unempl+LowEduc+Age18_24+Age25_44+Age45_64"
    response: "GenEl2004"
    predictors: ["DiffAdd, LARent, SC1, Unempl, LowEduc, Age18_24, Age25_44, Age45_64"]
    role: "simple_baseline"
    source_type: "analogie_topique_sans_texte_integral"
    source_ref: "Kavanagh A (2006) Turnout or turned off? Electoral participation in Dublin in the early 21st Century. Journal of Irish Urban Studies, 3(2):1-24 (sans DOI, texte integral non accessible -- verifie 2026-09-15)"
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

- Dataset ID: `R_GWmodel_DubVoter_Dub.voter`
- Dataset name: GWmodel::DubVoter
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
  equation_text: "GenEl2004~DiffAdd+LARent+SC1+Unempl+LowEduc+Age18_24+Age25_44+Age45_64"
  equation_family: regression
  model_family: "candidat par analogie -- ensemble complet des covariables du package, non verifie en texte integral"
  source_type: analogie_topique_sans_texte_integral
  source_ref: "Kavanagh A (2006) Turnout or turned off? Electoral participation in Dublin in the early 21st Century. Journal of Irish Urban Studies, 3(2):1-24 (sans DOI, texte integral non accessible)"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 322
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [300888.224, 328236.4395], y [220662.3518, 263404.7994] (CRS unknown)
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
  benchmark_status: "ready"
  benchmark_task: "regression_spatial_candidate_formula"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte ; formule reclassee candidat par analogie le 2026-09-15 (voir Statut regression canonique), reste utilisable comme specification benchmark"
  reason: "Reponse numerique (GenEl2004), covariables socio-demographiques du package documentees et completes (0% NA), support spatial disponible. Formule = ensemble complet des covariables du package, plausible par analogie avec le sujet de l etude source (Kavanagh 2006) mais non verifiee verbatim (texte integral non accessible)."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte ; formule reclassee candidat par analogie le 2026-09-15 (voir Statut regression canonique), reste utilisable comme specification benchmark
- Raison: Reponse numerique (GenEl2004), covariables socio-demographiques du package documentees et completes (0% NA), support spatial disponible. Formule = ensemble complet des covariables du package, plausible par analogie avec le sujet de l etude source (Kavanagh 2006) mais non verifiee verbatim (texte integral non accessible).

## Estimator eligibility

```yaml
estimator_eligibility:
  - estimator: ols
    basis: benchmark_use
    source_ref: "GWmodel DubVoter documentation and GWR examples."
  - estimator: gam_spatial
    basis: benchmark_use
    source_ref: "GWmodel DubVoter documentation and GWR examples."
  - estimator: mgwrsar_gwr
    basis: scientific_evidence
    source_ref: "GWmodel DubVoter documentation and GWR examples."
    notes: "Electoral dataset with projected coordinates, useful for geographically weighted regression."
  - estimator: mgwrsar_mgwr
    basis: benchmark_use
    source_ref: "GWmodel DubVoter documentation and GWR examples."
```


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: WARN - formule reclassee "candidat par analogie" le 2026-09-15 ; ensemble complet des covariables du package, non verifiee verbatim contre le texte integral de Kavanagh (2006) (sans DOI, non accessible).
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement (proj4string NA verifie sur l'objet R source).
- Geometry: WARN - Type de geometrie POINT dans le .rds local, mais la source native (`DubVoter.shp`) est un SpatialPolygonsDataFrame (322 EDs) ; conversion en centroides ponctuels documentee comme deliberee (voir note de fidelite en Description du jeu de donnees), pas une erreur mais une simplification du pipeline.
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2)).

## Related Pages

- Source: package R `GWmodel`

## Curation documentée — 2026-09-07

Verification directe (mode production de secours, tools::Rd_db("GWmodel") + inspection R de l'objet source) : description generique remplacee par le texte reel de la documentation du package ; source confirmee SpatialPolygonsDataFrame (322 EDs), non SpatialPointsDataFrame -- note de fidelite ajoutee pour documenter honnetement la conversion en centroides ponctuels deja presente dans le .rds local. Reference Harris et al. (2011) (GWPCA, DOI verifie 10.1080/13658816.2011.554838) ajoutee, deuxieme reference documentee par le package mais non liee a la formule de regression actuelle. formula_pub reclassee de "resolu/publication" vers "candidat par analogie/analogie" : Kavanagh (2006) n'a pas de DOI resolvable via Crossref et son texte integral n'est pas dans le corpus, donc la specification exacte de regression (les 8 covariables) n'a pas pu etre confirmee verbatim -- correction appliquee pour respecter la regle N'invente rien plutot que de laisser une declaration de verification non etayee.
