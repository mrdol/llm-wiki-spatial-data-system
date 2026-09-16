---
title: R_gstat_jura_jura.full
type: dataset
created: 2026-09-15
updated: 2026-09-16
sources:
  - data/final_datasets/sf/R_gstat_jura_jura.full.rds
tags: [dataset, r-package, spatial, point]
---

Fusion de `jura.pred` (259 pts) et `jura.val` (100 pts), les deux data.frames livres par `data(jura)` du package R `gstat`. Verification directe des articles sources (Atteia et al. 1994 ; Webster et al. 1994, tous deux telecharges et lus par l'utilisateur/l'agent le 2026-09-15) : le releve original comptait 366 sites echantillonnes sur une grille carree avec renforcement local ("nested"), sur 14.5 km² pres de La Chaux-de-Fonds (Jura suisse) ; les deux papiers analysent ce releve complet, pas un sous-ensemble de calibration. La coupure 259 (calibration) / 100 (validation) utilisee par `gstat::jura` provient de Goovaerts (1997, Appendix C), soit 3 ans APRES les papiers sources, et sert un usage pedagogique (demonstration de validation croisee), pas la structure du releve original. Cette fiche fusionnee (359 pts, proxy le plus proche disponible du releve complet de 366 sites) remplace donc la restauration separee de `jura.pred` initialement envisagee.

## Description du jeu de donnees

- Topic: geostatistique environnementale — contamination des sols en metaux traces
- Observation unit: site d'echantillonnage ponctuel de sol (parcelle)
- Observed population: 359 sites d'un releve geostatistique de sols agricoles/forestiers dans le Jura suisse (region de La Chaux-de-Fonds), sous-ensemble du releve original de 366 sites
- Geographic context: Etendue mesuree dans le RDS fusionne : x [6.825788, 6.883906], y [47.116100, 47.162636] ; CRS WGS84 (long/lat), confirme par la documentation gstat::jura ("Longitude, WGS84 datum")
- Temporal context: aucune variable temporelle structurelle detectee (releve ponctuel, campagne unique)
- Source description: `rbind(jura.pred, jura.val)` — les deux data.frames "ready-made" livres par `data(jura)` du package `gstat` (version 2.1.6), verifies disjoints (0 chevauchement de coordonnees Xloc/Yloc) et de structure identique (memes colonnes, memes niveaux de facteur Landuse/Rock)
- Description source: package R `gstat`, fusion documentee 2026-09-15
- Description confidence: high (structure verifiee par inspection directe R ; contexte scientifique verifie par lecture directe des deux papiers sources)

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Cd`, `Pb`, `Zn`, `Cu`, `Ni`, `Co`, `Cr`
- Candidate Y typology: continuous
- Candidate X variables: `Landuse`, `Rock`
- Candidate X typology: categorical
- Coordinates (x, y — excluded from X candidates): `Xloc`, `Yloc`, `long`, `lat`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (direct, `C:/tmp/jura_full_bbox.R`, 2026-09-15)
- Presence of imputed X: no (0% NA sur toutes les variables Y et X, verifie par inspection directe)

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Cd` | `numeric` | continuous | [0.135, 5.129] | 0% |
| `Pb` | `numeric` | continuous | [18.68, 300] | 0% |
| `Zn` | `numeric` | continuous | [25, 259.84] | 0% |
| `Cu` | `numeric` | continuous | [3.552, 166.4] | 0% |
| `Ni` | `numeric` | continuous | [1.98, 53.2] | 0% |
| `Co` | `numeric` | continuous | [1.552, 20.6] | 0% |
| `Cr` | `numeric` | continuous | [3.32, 70] | 0% |

> Selection Y/X (verification 2026-09-15) : les concentrations en metaux lourds (Cd, Pb, Zn, Cu, Ni, Co, Cr) sont les variables reponses analysees par Atteia et al. (1994) et Webster et al. (1994). Landuse et Rock sont les covariables categorielles explicatives identifiees par ces memes papiers (facteurs geologiques et d'usage du sol controlant la distribution des metaux), pas des cibles de prediction.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Landuse` | `factor` | categorical | 0% |
| `Rock` | `factor` | categorical | 0% |

### Formule — niveau publication

- formula_pub: `Co ~ Rock` ; `Ni ~ Rock` ; `Cr ~ Landuse` ; `Cu ~ Landuse`
- x_terms_pub: Rock (pour Co, Ni) ; Landuse (pour Cr, Cu)
- y_term_pub: Co, Ni, Cr, Cu (quatre relations distinctes, une par metal)
- Reference publication: Webster, R., Atteia, O. & Dubois, J.-P. (1994), "Coregionalization of trace metals in the soil in the Swiss Jura," European Journal of Soil Science 45:205-218, DOI 10.1111/j.1365-2389.1994.tb00502.x — resume (p. 205, lu directement dans webster1994.pdf) : "Analysis of variance showed Co and Ni to be related to geology, and to the Argovian formation in particular... The analysis also showed Cr and Cu to be related to land use (in different ways)." Papier compagnon : Atteia, O., Dubois, J.-P. & Webster, R. (1994), "Geostatistical analysis of soil contamination in the Swiss Jura," Environmental Pollution 86:315-327, DOI 10.1016/0269-7491(94)90172-4 (releve des 366 sites, base commune des deux papiers). [MANUEL/LIVRE, pas un article] Goovaerts, P. (1997), Geostatistics for Natural Resources Evaluation, Oxford University Press, Applied Geostatistics Series, New York, 483 p., ISBN 978-0-19-511538-3 (verifie via Open Library, https://openlibrary.org/isbn/9780195115383) — source de la coupure calibration/validation 259/100 utilisee par gstat::jura (Appendix C), posterieure de 3 ans aux deux articles ci-dessus.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: article
- Methode d'estimation: ANOVA (analyse de variance), papier source
- Correspondance Python/R: aucune identifiee
- Note: le papier ne fournit pas d'equation de regression explicite avec coefficients ; il rapporte des relations qualitatives significatives issues d'ANOVA (facteur categoriel -> reponse continue). formula_pub encode ces relations comme specifications de type `Y ~ facteur`, fideles au texte, sans inventer de coefficients.

### Formule — niveau systeme

- formula_used: Cd ~ Landuse + Rock
- Selected Y evidence: Ligne Detail Y correspondant a formula_used ; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: Landuse + Rock
- y_term_used: Cd

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "Co ~ Rock"
    response: "Co"
    predictors: ["Rock"]
    role: "paper_anova_finding"
    source_type: "paper_reported"
    source_ref: "Webster et al. 1994, EJSS 45:205-218, DOI 10.1111/j.1365-2389.1994.tb00502.x, abstract p.205"
    estimator_context: ["ols", "gam_spatial"]
    status: "confirmed"

  multivariate_constrained:
    formula: "Cr ~ Landuse"
    response: "Cr"
    predictors: ["Landuse"]
    role: "paper_anova_finding"
    source_type: "paper_reported"
    source_ref: "Webster et al. 1994, EJSS 45:205-218, DOI 10.1111/j.1365-2389.1994.tb00502.x, abstract p.205"
    estimator_context: ["ols", "gam_spatial"]
    status: "confirmed"

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

- Dataset ID: `R_gstat_jura_jura.full`
- Dataset name: gstat::jura (fusion jura.pred + jura.val)
- Source family: r-package
- Source: package R `gstat` (version 2.1.6), objets `jura.pred` et `jura.val` fusionnes par `rbind()`
- Source URL: https://CRAN.R-project.org/package=gstat
- Dataset DOI: none
- Publication DOI: 10.1016/0269-7491(94)90172-4 (Atteia et al. 1994) ; 10.1111/j.1365-2389.1994.tb00502.x (Webster et al. 1994)
- Year: 1994 (releve original) ; 1997 (coupure calibration/validation, Goovaerts) ; 2003 (mise a disposition dans gstat)

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): regression
- Modele niveau 2 (famille): regression_lineaire (ANOVA a un facteur)
- Modele niveau 3 (variante): geostatistique / co-regionalisation (source), regression spatiale (usage benchmark)

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Co ~ Rock ; Ni ~ Rock ; Cr ~ Landuse ; Cu ~ Landuse"
  equation_family: anova
  model_family: "anova_categorical_regression"
  source_type: paper_reported
  source_ref: "Webster et al. 1994, EJSS 45:205-218, DOI 10.1111/j.1365-2389.1994.tb00502.x, abstract p.205"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 359
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee ; releve de sol ponctuel (campagne unique)

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [6.8258, 6.8839], y [47.1161, 47.1626] (EPSG:4326, calcule via `sf::st_bbox()` sur le RDS fusionne, 2026-09-15)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326 (source: documentation du package, .rds sans CRS embarque)
- CRS nom: WGS 84
- CRS analyse recommande: reprojection recommandee vers un CRS metrique local (ex. CH1903+/LV95, EPSG:2056) -- coordonnees actuellement en WGS84 geographique (degres), peu adaptees au calcul direct de distances/voisinage pour cette petite region du Jura suisse. (correction 2026-09-16, mode production de secours : le texte precedent affirmait a tort "CRS source non geographique ou inconnu" alors que le CRS est deja connu et renseigne ci-dessus -- incoherence interne du meme type que celle corrigee sur paper_banff_stream_temperature.)

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2.0)
- License URL: https://CRAN.R-project.org/package=gstat
- License open: yes
- Reproducibility status: available via package R `gstat` (fusion reproductible par `rbind(jura.pred, jura.val)`, script `C:/tmp/build_jura_full.R`)
- Code available: yes (package examples/vignettes + script de fusion documente)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "manual_review"
  benchmark_task: "regression_spatial_validated_generated_formula"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "Nouvelle fiche fusionnee (2026-09-15), n'a pas encore ete traitee par le pipeline benchmark_readiness automatise ; estimator_eligibility a etablir."
  reason: "Nouvelle fiche fusionnee (2026-09-15), n'a pas encore ete traitee par le pipeline benchmark_readiness automatise ; estimator_eligibility a etablir."
```

- Decision: manual_review
- Manque principal: fiche nouvellement creee (fusion jura.pred+jura.val), pas encore passee par le registre de curation automatise ; verifier `package_include` et `estimator_eligibility` avant promotion
- Raison: fusion documentee 2026-09-15, en attente de revue par le pipeline de curation (`dataset_curation.py`)

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "Fiche nouvellement creee par fusion (2026-09-15) ; eligibilite non encore evaluee par le registre."
  rule: "Revue de la tache avant selection des routes ; aucune promotion automatique."
```

## Quality Control

- Schema: OK - fiche redigee manuellement (mode production de secours) au format Bloc 1-6 conforme au gabarit `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes ; NA verifie a 0% sur toutes les variables.
- Formula: OK - formula_pub etablie a partir d'une citation directe du resume de Webster et al. (1994) (ANOVA), pas inventee.
- CRS: WARN - CRS absent du `.rds` source ; EPSG:4326 extrait de la documentation et reporte dans le Bloc 5.
- Geometry: OK - type geometrique controle (POINT), structure sf identique a `R_gstat_jura_jura.val.rds` (geom_point/geom_origine, memes conventions).
- Missing values: OK - aucune variable avec NA > 0% detectee.
- Duplicates: WARN - groupe de versions suspectes `jura` ; cette fiche fusionne jura.pred+jura.val (0 chevauchement de coordonnees verifie) ; autres versions restantes: R_gstat_jura_prediction.dat, R_gstat_jura_validation.dat, R_gstat_jura_jura.grid, R_gstat_jura_juragrid.dat
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2.0)) ; script de fusion documente et reproductible.

## Related Pages

- Source: package R `gstat`
- Version partielle (validation, 100 pts, conservee comme sous-ensemble documente) : [[R_gstat_jura_jura.val]]
- Duplicate/version candidate: [[R_gstat_jura_prediction.dat]]
- Duplicate/version candidate: [[R_gstat_jura_validation.dat]]
- Duplicate/version candidate: [[R_gstat_jura_jura.grid]]
- Duplicate/version candidate: [[R_gstat_jura_juragrid.dat]]

## Curation documentée — 2026-09-15

Decision : creation d'une fiche fusionnee `R_gstat_jura_jura.full` (359 pts = jura.pred 259 + jura.val 100), en mode production de secours explicitement autorise par l'utilisateur pour cette tache.

Contexte de la decision : l'examen initial visait a determiner si `jura.val` (100 pts, seule version conservee dans le corpus) etait un doublon ou un fichier secondaire du "vrai" jeu de donnees Jura. Verification du code de generation (`generate_fiches.py`) : `jura.pred` (259 pts) etait ecarte sans justification documentee au profit de `jura.val` seul. Sur instruction explicite de l'utilisateur ("Lis les papiers pour voir ce qu'ils ont fait"), les deux papiers sources reels ont ete telecharges par l'utilisateur (`atteia1994.pdf`, `webster1994.pdf`) et lus directement : les deux papiers analysent le releve ORIGINAL complet de 366 sites, pas un sous-ensemble. La coupure 259/100 est une construction posterieure (Goovaerts 1997, Appendix C) a but pedagogique (demonstration de validation croisee), non representative de la structure du releve ni des papiers sources. La fusion jura.pred+jura.val (359 pts, proxy le plus proche du releve complet disponible via `gstat`) est donc jugee plus fidele aux papiers sources qu'une restauration separee de jura.pred ou qu'un statu quo sur jura.val seul.

Verification technique : `data(jura)` du package `gstat` charge `jura.pred` et `jura.val` comme objets R prets a l'emploi (pas de reimplementation manuelle du georeferencement necessaire). Colonnes et niveaux de facteur (Landuse, Rock) identiques entre les deux objets ; 0 chevauchement de coordonnees Xloc/Yloc verifie par `merge()` (`C:/tmp/build_jura_merged.R`). Fusion effectuee par `rbind()` puis reconstruction de l'objet `sf` a l'identique de la structure de `R_gstat_jura_jura.val.rds` (colonnes geom_point/geom_origine, CRS non embarque) via `C:/tmp/build_jura_full.R`. Bbox et statistiques descriptives recalculees directement sur le RDS fusionne (`C:/tmp/jura_full_bbox.R`).

Formule niveau publication etablie a partir d'une citation directe et verifiee du resume de Webster et al. (1994) (EJSS 45:205-218, DOI verifie via Crossref) rapportant des resultats d'ANOVA : Co et Ni lies a la geologie (formation Argovienne en particulier), Cr et Cu lies a l'usage du sol. Ces relations sont rapportees telles quelles (`Y ~ facteur`), sans coefficient invente, le papier ne fournissant pas d'equation de regression explicite.

`R_gstat_jura_jura.val.md` (100 pts) est conservee inchangee comme sous-ensemble de validation documente, plutot que supprimee, car elle reste un objet reel et distinct du package (utile pour des scenarios de validation croisee reproduisant Goovaerts 1997) ; un lien croise est ajoute dans `Related Pages` des deux fiches plutot qu'une fusion destructive.

Provenance : lecture directe de `atteia1994.pdf` et `webster1994.pdf` (telecharges par l'utilisateur dans son dossier Downloads local, hors depot) ; inspection R directe des objets `gstat::jura` ; DOIs verifies via l'API Crossref. Regeneration future via `code/r_catalog/generate_fiches.py` (jura.pred reste dans `CONFIRMED_DISCARD`, commentaire explicatif ajoute) — cette fiche a ete redigee manuellement car `jura.full` n'est pas un objet natif du package, seulement une construction documentee.
