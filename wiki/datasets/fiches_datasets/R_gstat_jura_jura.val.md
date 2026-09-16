---
title: R_gstat_jura_jura.val
type: dataset
created: 2026-08-15
updated: 2026-09-16
sources:
  - data/final_datasets/sf/R_gstat_jura_jura.val.rds
tags: [dataset, r-package, spatial, point]
---

The jura data set from Pierre Goovaerts' book (see references below). It contains four ‘data.frame’s: prediction.dat, validation.dat and transect.dat and juragrid.dat, and three ‘data.frame’s with consistently coded land use and rock type factors, as well as geographic coordinates. The examples below show how to transform these into spatial (sp) ob...

## Description du jeu de donnees

- Topic: agriculture / rendement ou experimentation agronomique
- Observation unit: parcelle, placette experimentale ou observation agricole
- Observed population: observations agricoles documentees par le package source
- Geographic context: Etendue mesuree dans le RDS : x [6.825787677834, 6.881330909309], y [47.116100419465, 47.158943499838]; CRS non renseigne, repere/unites a documenter.
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: The jura data set from Pierre Goovaerts' book (see references below). It contains four ‘data.frame’s: prediction.dat, validation.dat and transect.dat and juragrid.dat, and three ‘data.frame’s with consistently coded land use and rock type factors, as well as geographic coordinates. The examples below show how to transform these into spatial (sp) ob...
- Description source: package R `gstat`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Cd`, `Pb`, `Zn`, `Cu`, `Ni`, `Co`, `Cr`
- Candidate Y typology: continuous
- Candidate X variables: `Landuse`, `Rock`
- Candidate X typology: categorical
- Coordinates (x, y — excluded from X candidates): `Xloc`, `Yloc`, `long`, `lat`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Cd` | `numeric` | continuous | [0.325, 3.78] | 0% |
| `Pb` | `numeric` | continuous | [18.68, 300] | 0% |
| `Zn` | `numeric` | continuous | [25, 259.84] | 0% |
| `Cu` | `numeric` | continuous | [3.552, 154.6] | 0% |
| `Ni` | `numeric` | continuous | [1.98, 43.68] | 0% |
| `Co` | `numeric` | continuous | [1.652, 20.6] | 0% |
| `Cr` | `numeric` | continuous | [3.32, 70] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les concentrations en métaux lourds (Cd, Pb, Zn, Cu, Ni, Co, Cr) sont des variables réponses classiques en géostatistique environnementale, chacune pouvant être la cible d'une modélisation spatiale. Landuse et Rock sont des covariables catégorielles explicatives naturelles (facteurs contrôlant la distribution des métaux dans le sol), et ne constituent pas des cibles de prédiction pertinentes.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Landuse` | `factor` | categorical | 0% |
| `Rock` | `factor` | categorical | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: [MANUEL/LIVRE, pas un article] Goovaerts, P. (1997) Geostatistics for Natural Resources Evaluation. Oxford University Press, Applied Geostatistics Series, New York, 483 p., ISBN 978-0-19-511538-3 (verifie via Open Library, https://openlibrary.org/isbn/9780195115383) [Appendix C decrit et fournit le jeu de donnees Jura] ; deux articles analysant le meme jeu de donnees (metaux traces dans les sols du Jura suisse) sont egalement documentes dans gstat::jura : Atteia, O., Dubois, J.-P., Webster, R. (1994), Geostatistical analysis of soil contamination in the Swiss Jura, Environmental Pollution 86:315-327, DOI 10.1016/0269-7491(94)90172-4 ; Webster, R., Atteia, O., Dubois, J.-P. (1994), Coregionalization of trace metals in the soil in the Swiss Jura, European Journal of Soil Science 45:205-218, DOI 10.1111/j.1365-2389.1994.tb00502.x.

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: Cd ~ Landuse + Rock
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: Landuse + Rock
- y_term_used: Cd

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "simple_baseline"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

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
    formula: "Cd ~ Landuse + Rock"
    response: "Cd"
    predictors: ["Landuse", "Rock"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `R_gstat_jura_jura.val`
- Dataset name: gstat::jura
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
  existing_model_found: false
  equation_text: "Cd ~ Landuse + Rock"
  equation_family: regression_candidate
  model_family: "regression_candidate"
  source_type: generated_system_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 100
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [6.8258, 6.8813], y [47.1161, 47.1589] (EPSG:4326, via documentation)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326 (source: documentation du package, .rds sans CRS embarque)
- CRS nom: WGS 84
- CRS analyse recommande: reprojection recommandee vers un CRS metrique local (ex. CH1903+/LV95, EPSG:2056) -- coordonnees actuellement en WGS84 geographique (degres), peu adaptees au calcul direct de distances/voisinage pour cette petite region du Jura suisse.

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2.0)
- License URL: https://CRAN.R-project.org/package=gstat
- License open: yes
- Reproducibility status: available via package R `gstat`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "manual_review"
  benchmark_task: "regression_spatial_validated_generated_formula"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats."
  reason: "Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats."
```

- Decision: manual_review
- Manque principal: Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats.
- Raison: Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats.


## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: WARN - CRS absent du `.rds` source ; EPSG:4326 extrait de la documentation et reporte dans le Bloc 5.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: WARN - groupe de versions suspectes `jura`; autres versions: R_gstat_jura_jura.pred, R_gstat_jura_prediction.dat, R_gstat_jura_validation.dat, R_gstat_jura_jura.grid, R_gstat_jura_juragrid.dat
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2.0)).

## Related Pages

- Source: package R `gstat`
- Fusion complete (359 pts, jura.pred + jura.val) : [[R_gstat_jura_jura.full]]
- Duplicate/version candidate: [[R_gstat_jura_prediction.dat]]
- Duplicate/version candidate: [[R_gstat_jura_validation.dat]]
- Duplicate/version candidate: [[R_gstat_jura_jura.grid]]
- Duplicate/version candidate: [[R_gstat_jura_juragrid.dat]]

## Curation documentée — 2026-09-07

Decision conservatoire : Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

Verification 2026-09-15 (mode production de secours, tools::Rd_db("gstat")) : CRS confirme WGS84 pour long/lat (documentation gstat::jura, "Longitude, WGS84 datum") ; EPSG:4326 deja correctement renseigne, seul le nom manquait. Deux articles reels analysant precisement ce jeu de donnees identifies dans les references officielles gstat::jura (Atteia et al. 1994, DOI 10.1016/0269-7491(94)90172-4 ; Webster et al. 1994, DOI 10.1111/j.1365-2389.1994.tb00502.x) et ajoutes a Reference publication -- texte integral non recupere (pas dans corpus/papers/tei), donc aucune formule exacte extraite ; formula_pub reste honnetement "pending" plutot que d'inventer une equation a partir des seuls titres/resumes.

Complement 2026-09-15 (mode production de secours) : lecture directe des PDF complets des deux papiers ci-dessus (telecharges par l'utilisateur) confirme qu'ils analysent le releve ORIGINAL complet (366 sites), pas ce sous-ensemble de validation (100 pts) isolement. La coupure calibration (jura.pred, 259 pts) / validation (jura.val, ce fichier, 100 pts) est une construction posterieure de Goovaerts (1997, Appendix C), a but pedagogique. Une fiche fusionnee [[R_gstat_jura_jura.full]] (359 pts = jura.pred + jura.val, proxy le plus proche du releve complet disponible via gstat) a ete creee en complement ; elle porte desormais formula_pub etabli a partir d'une citation directe de Webster et al. (1994) (resultats ANOVA). Cette fiche `jura.val` est conservee telle quelle (sous-ensemble reel et distinct du package, utile pour des scenarios de validation croisee reproduisant Goovaerts 1997), pas fusionnee destructivement ; formula_pub reste "pending" ici car ce sous-ensemble seul n'a pas ete analyse independamment par les papiers sources.

Correction 2026-09-16 (mode production de secours) : le champ 'CRS analyse recommande' affirmait a tort que le CRS source etait non geographique/inconnu alors qu'il etait deja renseigne juste au-dessus -- corrige (voir le champ lui-meme pour le texte actuel).
