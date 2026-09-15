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

> Note de fidelite (2026-09-15, corrigee) : la source native (`DubVoter.shp`) est un jeu de POLYGONES (322 EDs, MULTIPOLYGON). Le `.rds` local conserve les DEUX geometries, conformement a la methodologie documentee du pipeline sf (code/r_catalog/guide_objets_sf.md, section 3-5) : `geom_origine` (verifie directement sur le .rds : sfc_MULTIPOLYGON, geometrie complete d'origine, conservee pour les usages necessitant les contours -- ex. matrices de contiguite/voisinage) et `geom_point` (geometrie active, un point garanti a l'INTERIEUR du polygone via `st_point_on_surface()` -- pas un centroide simple, choisi car un centroide peut tomber hors d'un polygone en forme de donut/multipolygone). Rien n'est perdu : `Type de geometrie: POINT` (Bloc 5) decrit uniquement la geometrie active par defaut, utilisee pour l'usage uniforme des estimateurs a support ponctuel du benchmark.

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
- Reference publication: Dambon, J.A., Sigrist, F. & Furrer, R. (2022), "Joint variable selection of both fixed and random effects for Gaussian process-based spatially varying coefficient models," International Journal of Geographical Information Science, DOI 10.1080/13658816.2022.2097684 (Crossref-verifie ; PDF open access lu integralement, fourni par l'utilisateur), Section 5.1 "Data" -- confirme independamment (troisieme source verbatim) : "we consider the Dublin Voter data set. It consists of the voter turnout in the 2002 General Elections and 8 other demographic covariates for n=322 electoral divisions in the Greater Dublin area (Ireland)... The data set was first studied by Kavanagh (2004) and is available in the R package GWmodel." Equation (1), page 13 : y_i = Z.GenEl2004_i = mu2*Z.DiffAdd_i + mu3*Z.LARent_i + mu4*Z.SC1_i + mu5*Z.Unempl_i + mu6*Z.LowEduc_i + mu7*Z.Age18_24_i + mu8*Z.Age25_44_i + mu9*Z.Age45_64_i + eps_i -- la meme formule exacte (variables standardisees), utilisee comme point de depart pour une selection de variables par LASSO adaptatif. Le Tableau 3 (p.15) precise en note : "due to a naming error the response of interest is called GenEl2004, although it actually refers to the 2002 GE" -- confirme le motif deja documente par gwmodel::DubVoter (variable nommee GenEl2004 par erreur de continuite historique). Reference exacte de l'etude originale confirmee par la bibliographie de Dambon et al. (2022) (p.20) : Kavanagh, A. (2004), "Turnout or turned off? Electoral participation in Dublin in the 21st century," Journal of Irish Urban Studies, 3(2):1-22 -- CORRECTION : l'annee et la pagination exactes sont 2004 et 1-22 (pas 2006 et 1-24 comme rapporte par la documentation `GWmodel::DubVoter`, tres probablement une coquille de citation dans le Rd du package, meme titre et meme revue). Gollini, I., Lu, B., Charlton, M., Brunsdon, C. & Harris, P. (2015), "GWmodel: An R Package for Exploring Spatial Heterogeneity Using Geographically Weighted Models," Journal of Statistical Software 63(17), DOI 10.18637/jss.v063.i17 (Crossref-verifie ; texte integral dans corpus/papers/tei/Gollini_2015_GWmodel_JSS.tei.xml) -- deuxieme preuve verbatim la plus forte : l'article execute et rapporte le vrai modele `lm(GenEl2004 ~ DiffAdd + LARent + SC1 + Unempl + LowEduc + Age18_24 + Age25_44 + Age45_64, data = Dub.voter)` avec table de coefficients complete (Section 6), puis la meme specification exacte en GW regression (Sections 6-7, plusieurs variantes : `bw.gwr`, `gwr.basic`, `gwr.lcr`, selection de modele). Lu, B., Harris, P., Charlton, M. & Brunsdon, C. (2014), "The GWmodel R package: further topics for exploring spatial heterogeneity using geographically weighted models," Geo-spatial Information Science 17(2), DOI 10.1080/10095020.2014.917453 (Crossref-verifie ; texte integral dans corpus/papers/tei/Lu_2014_GWmodel_further_topics.tei.xml), Section 2.3.1, confirme independamment la meme formule en 8 covariables. Attribution de l'etude originale : incertaine entre plusieurs travaux de Kavanagh et coauteurs -- Gollini et al. (2015) citent "Kavanagh, Fotheringham & Charlton (2006), A Geographically Weighted Regression Analysis of the Election Specific Turnout Behaviour in the Republic of Ireland" ; Lu et al. (2014) citent "Kavanagh, Sinnott, Fotheringham & Charlton, Geographically Weighted Regression Analysis of General Election Turnout in the Republic of Ireland, Political Studies Association of Ireland Conference" ; la documentation du package `GWmodel::DubVoter` cite "Kavanagh A (2006) Turnout or turned off? Electoral participation in Dublin in the early 21st Century, Journal of Irish Urban Studies 3(2):1-24". Ces trois citations ne sont pas verifiees comme identiques (aucune n'a ete lue en texte integral) et ne sont PAS retenues comme preuve de la formule -- seule l'execution directe et verifiee du modele par Gollini et al. (2015) et Lu et al. (2014), toutes deux lues en texte integral dans ce corpus, sert de preuve. Harris P, Brunsdon C, Charlton M (2011), Geographically weighted principal components analysis, International Journal of Geographical Information Science 25(10):1717-1736, DOI 10.1080/13658816.2011.554838 (Crossref-verifie) -- reference secondaire documentee par GWmodel::DubVoter, analyse GWPCA (pas une regression sur GenEl2004).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: verbatim
- Methode d'estimation: OLS global puis GW regression (`lm()` puis `gwr.basic()`/`bw.gwr()`), executee et rapportee avec coefficients reels
- Correspondance Python/R: aucune identifiee
- Note: Citation verbatim retrouvee dans le texte integral de Gollini et al. (2015) (corpus/papers/tei/Gollini_2015_GWmodel_JSS.tei.xml), qui execute directement le modele global : `lm.global <- lm(GenEl2004 ~DiffAdd + LARent + SC1 + Unempl + LowEduc + Age18_24 + Age25_44 + Age45_64, data = Dub.voter)`, avec la table de coefficients rapportee : Intercept 77.70467 (p<2e-16), DiffAdd -0.08583 (p=0.32), LARent -0.09402 (p=1.9e-07), SC1 0.08637 (p=0.22), Unempl -0.72162 (p=2.0e-13), LowEduc -0.13073 (p=0.76), Age18_24 -0.13992 (p=0.01), Age25_44 -0.35365 (p=3.2e-06), Age45_64 -0.09202 (p=0.31). La meme specification est ensuite reprise dans plusieurs runs de GW regression (bw.gwr, gwr.basic, gwr.lcr) dans les sections 6-7 du meme article. Confirme independamment par Lu et al. (2014), section 2.3.1, et par Dambon et al. (2022) (Section 5.1, equation 1, p.13), qui utilise la meme formule standardisee comme point de depart d'une selection de variables par LASSO adaptatif -- PDF fourni par l'utilisateur, lu integralement le 2026-09-15. Historique de cette correction (2026-09-15, 4 passes) : (1) fiche initiale "resolu/publication" en citant uniquement Kavanagh (2006), affirmation non etayee (pas de texte integral disponible) ; (2) degrade vers "candidat par analogie" faute de preuve directe ; (3) restaure et renforce vers "resolu/verbatim" en citant Gollini et al. (2015) et Lu et al. (2014), qui executent reellement ce modele exact dans leur texte integral (present dans ce corpus) ; (4) confirme une troisieme fois par Dambon et al. (2022) (PDF fourni par l'utilisateur, lu integralement), dont la bibliographie propre resout aussi la reference exacte de l'etude originale (Kavanagh, A., 2004, pas 2006). L'attribution Kavanagh reste documentee mais n'est plus la seule preuve retenue : la formule repose sur trois executions independantes du meme modele en texte integral.

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
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Gollini et al. (2015), DOI 10.18637/jss.v063.i17 -- lm() global execute avec coefficients reels rapportes ; confirme independamment par Lu et al. (2014), DOI 10.1080/10095020.2014.917453, et par Dambon et al. (2022), DOI 10.1080/13658816.2022.2097684 (equation 1, meme formule standardisee) ; les trois textes integraux verifies"
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

- Dataset ID: `R_GWmodel_DubVoter_Dub.voter`
- Dataset name: GWmodel::DubVoter
- Source family: r-package
- Source: package R `GWmodel`
- Source URL: https://CRAN.R-project.org/package=GWmodel
- Dataset DOI: none
- Publication DOI: pending
- Year: 2013

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): regression
- Modele niveau 2 (famille): regression_lineaire
- Modele niveau 3 (variante): OLS global + GW regression (geographically weighted regression)

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "GenEl2004~DiffAdd+LARent+SC1+Unempl+LowEduc+Age18_24+Age25_44+Age45_64"
  equation_family: regression
  model_family: "OLS + GW regression -- execute et rapporte avec coefficients reels par Gollini et al. (2015), confirme par Lu et al. (2014), textes integraux dans le corpus"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Gollini et al. (2015), DOI 10.18637/jss.v063.i17 ; Lu et al. (2014), DOI 10.1080/10095020.2014.917453"
  confidence: high
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
  benchmark_task: "regression_spatial_package_formula"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Formule confirmee verbatim par une publication du corpus (Lu et al. 2014), reponse numerique, covariables locales completes et support spatial disponible (polygone d'origine conserve dans geom_origine)."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Formule confirmee verbatim par une publication du corpus (Lu et al. 2014), reponse numerique, covariables locales completes et support spatial disponible (polygone d'origine conserve dans geom_origine).

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
- Formula: OK - formule confirmee verbatim par Lu et al. (2014) (texte integral dans le corpus), voir Statut regression canonique.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement (proj4string NA verifie sur l'objet R source).
- Geometry: OK - la source native (`DubVoter.shp`) est un SpatialPolygonsDataFrame (322 EDs) ; le .rds local conserve les DEUX geometries -- `geom_origine` (MULTIPOLYGON, verifie directement sur le .rds) et `geom_point` (point interieur garanti, derive via `st_point_on_surface()` selon la methodologie documentee dans code/r_catalog/guide_objets_sf.md, section 3 -- pas un centroide simple, choisi precisement pour eviter qu'un point tombe hors du polygone). `Type de geometrie: POINT` (Bloc 5) decrit la geometrie active, pas une perte d'information.
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2)).

## Related Pages

- Source: package R `GWmodel`

## Curation documentée — 2026-09-07

Quatrieme passe de verification 2026-09-15 (mode production de secours) : l'utilisateur a telecharge et fourni le PDF complet de Dambon, Sigrist & Furrer (2022) (DOI 10.1080/13658816.2022.2097684), lu integralement. Confirme une TROISIEME fois, independamment de Gollini et al. (2015) et Lu et al. (2014), la meme formule exacte : Section 5.1 declare explicitement utiliser "the Dublin Voter data set... voter turnout in the 2002 General Elections and 8 other demographic covariates for n=322 electoral divisions", et l'equation (1) p.13 est exactement Z.GenEl2004 ~ Z.DiffAdd+Z.LARent+Z.SC1+Z.Unempl+Z.LowEduc+Z.Age18_24+Z.Age25_44+Z.Age45_64 (variables standardisees), utilisee comme modele de depart pour une selection LASSO adaptative. Le Tableau 3 (p.15) confirme aussi le motif de nommage deja documente par le package ("due to a naming error the response of interest is called GenEl2004, although it actually refers to the 2002 GE"). Correction supplementaire, resolue par la bibliographie propre de Dambon et al. (2022, p.20) : la reference exacte est Kavanagh, A. (2004) "Turnout or turned off? Electoral participation in Dublin in the 21st century," Journal of Irish Urban Studies, 3(2):1-22 -- l'annee (2004, pas 2006) et la pagination (1-22, pas 1-24) rapportees par la documentation `GWmodel::DubVoter` etaient inexactes (meme titre et meme revue, tres probablement une coquille du Rd du package plutot qu'un article different) ; corrige dans la fiche. La question laissee ouverte lors de la passe precedente (les differentes attributions "Kavanagh et al." chez Gollini 2015 et Lu 2014 sont-elles la meme etude ?) reste non tranchee -- Dambon et al. (2022) cite lui aussi le seul Kavanagh (2004) solo comme etude originale, ce qui est coherent avec la documentation du package, mais n'exclut pas l'existence de travaux ulterieurs avec coauteurs sur le meme sujet. La formule repose desormais sur TROIS executions independantes et verifiees en texte integral (Gollini 2015, Lu 2014, Dambon 2022), ce qui rend la question d'attribution Kavanagh non bloquante pour le statut verbatim de formula_pub.
