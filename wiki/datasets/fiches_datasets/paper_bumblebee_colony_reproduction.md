---
title: paper_bumblebee_colony_reproduction
type: dataset
created: 2026-09-14
updated: 2026-09-17
sources:
  - data/final_datasets/sf/paper_bumblebee_colony_reproduction.rds
  - DataCite_2018_LowerBumblebeeColonyReproductive_10_1098_rspb_201
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Lower bumblebee colony reproductive success in agricultural compared with urban environments" (DOI 10.1098/rspb.2018.0807).

## Description du jeu de donnees

- Topic: ecologie urbaine / ecologie des pollinisateurs / effets de l'occupation du sol sur la reproduction des bourdons
- Observation unit: colonie de Bombus terrestris audax placee sur un site experimental (issue d'une reine sauvage capturee et elevee en laboratoire)
- Observed population: 43 colonies de Bombus terrestris audax (reines sauvages) placees sur 38 sites entre Londres et sa peripherie agricole, mai-juillet 2016 (verifie texte integral PMC6030522) -- N=38 dans cet artefact (unite = site, l'artefact local ne distingue pas les cas ou plusieurs colonies partagent un site).
- Geographic context: etendue sf: x [-1.2065639, -0.0407438], y [51.1083416, 51.5933662]
- Temporal context: coupe transversale agregee par colonie/site, derivee d'une experience de terrain longitudinale (visites hebdomadaires, jusqu'a 10 semaines, mai-juillet 2016) -- le suivi hebdomadaire brut (nectar, pollen, taille de colonie) n'est pas dans cet artefact agrege ; certaines analyses du papier (GAM binomial sur presence de ressources) utilisent la semaine comme predicteur, mais sur les donnees hebdomadaires non presentes ici.
- Source description: Lower bumblebee colony reproductive success in agricultural compared with urban environments
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1098/rspb.2018.0807
- Dataset DOI: 10.5061/dryad.c68cj62
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.c68cj62
- Local raw dir: `data/raw/papers/DataCite_2018_LowerBumblebeeColonyReproductive_10_1098_rspb_201/`
- Local sf output: `data/final_datasets/sf/paper_bumblebee_colony_reproduction.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Tot_rep`, `Countave`, `Tot_male`, `Tot_gyne`
- Candidate Y typology: count, continuous
- Candidate X variables in local artifact: `LU500`, `Crith_suc`, `Apic_suc`, `Crith_fail`, `Apic_fail`, `Syntretus`, `Crithidia`, `Apicystis`, `Tot_cuck`, `Cu_bin`, `Bin_rep`, `G_thorave`, `G_wmass`, `G_dmass`, `M_thorave`, `M_wmass`, `M_dmass`, `Q_week`, `Q_died`, `Col_death_week`, `Col_status`, `Rep_wk`, `Rep_status`, `Ave_temp`, `Ave_hum`, `Sum_prec`, `Prop_flower100`, `Prop_flower250`, `Prop_flower500`, `Prop_flower750`, `Prop_imp500`, `Prop_flower500.1`, `Prop_urb500`, `Prop_open500`, `Prop_tree500`, `Prop_ag500`, `Prop_gard500`, `Prop_road500`, `X750PC1`, `X750PC2`, `X500PC1`, `X500PC2`, `X250PC1`, `X250PC2`, `X100PC1`, `X100PC2`, `X100PC3`
- Candidate X count in local artifact: 47
- Candidate X typology: categorical, unknown, continuous
- Published X variables from paper: LU500 (categorie d'occupation du sol dans un buffer de 500m -- City/Village/Agricultural, obtenue par PCA sur les proportions d'occupation du sol puis clustering de Ward, verifie dans le .rds : effectifs exacts City=17/Village=16/Agricultural=5, identiques a ceux du papier), temperature, humidite, precipitation. Selection de modele all-subsets par AICc parmi ces candidats (papier, section Methods : "we built a comparison set of models including the full model... and all subsets") -- le jeu de termes exact du modele final retenu est dans les tableaux supplementaires (S1a/S2a), non recuperes integralement a ce jour.
- Published X count: 4 (candidats de selection de modele) -- les proportions individuelles (Prop_*) et axes PCA (X*PC*) sont les INGREDIENTS ayant servi a construire LU500, pas des predicteurs simultanes distincts dans le modele publie.
- Coordinates (x, y - excluded from X candidates): `longitude`, `latitude`, `Lat`, `Lon`
- Identifier columns (excluded from X candidates): `Col`, `Site`, `LU750`, `LU250`, `LU100`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown
- Note complementaire (2026-09-17) : `LU500` a ete deplace de "Identifier columns" vers les candidats X -- verification directe du .rds (`table(LU500)` = Agricultural:5, City:17, Village:16) confirme que c'est le predicteur categoriel principal du papier, pas un identifiant technique.

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Tot_rep` | `integer` | count | [0, 79] | 0% |
| `Countave` | `numeric` | continuous | [9.5, 140.6667] | 0% |
| `Tot_male` | `integer` | unknown | [0, 71] | 0% |
| `Tot_gyne` | `integer` | unknown | [0, 19] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `bumblebee_colony_reproduction`, la ou les reponses `Tot_rep`, `Countave`, `Tot_male`, `Tot_gyne` viennent du loader papier et/ou des preuves de l article `Lower bumblebee colony reproductive success in agricultural compared with urban environments`. Les covariables X retenues sont `Ave_temp`, `Ave_hum`, `Sum_prec`, `Prop_flower500`, `Prop_imp500`, `Prop_urb500`, `Prop_open500`, `Prop_tree500`, `Prop_ag500`, `Prop_gard500`, `Prop_road500`, `X500PC1`, `X500PC2` ; 33 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`longitude`, `latitude`, `Lat`, `Lon`), identifiants (`Col`, `Site`, `LU750`, `LU250`, `LU100`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : manual_review; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `LU500` | `character` | categorical | 0% |
| `Crith_suc` | `integer` | unknown | 10.5% |
| `Apic_suc` | `integer` | unknown | 10.5% |
| `Crith_fail` | `integer` | unknown | 10.5% |
| `Apic_fail` | `integer` | unknown | 10.5% |
| `Syntretus` | `integer` | binary | 10.5% |
| `Crithidia` | `integer` | binary | 10.5% |
| `Apicystis` | `integer` | binary | 10.5% |
| `Tot_cuck` | `numeric` | continuous | 0% |
| `Cu_bin` | `integer` | binary | 0% |
| `Bin_rep` | `integer` | binary | 0% |
| `G_thorave` | `numeric` | continuous | 84.2% |
| `G_wmass` | `numeric` | continuous | 5.3% |
| `G_dmass` | `numeric` | continuous | 5.3% |
| `M_thorave` | `numeric` | continuous | 31.6% |
| `M_wmass` | `numeric` | continuous | 0% |
| `M_dmass` | `numeric` | continuous | 0% |
| `Q_week` | `numeric` | continuous | 0% |
| `Q_died` | `integer` | binary | 0% |
| `Col_death_week` | `numeric` | continuous | 0% |
| `Col_status` | `integer` | binary | 0% |
| `Rep_wk` | `numeric` | continuous | 0% |
| `Rep_status` | `integer` | binary | 0% |
| `Ave_temp` | `numeric` | continuous | 0% |
| `Ave_hum` | `numeric` | continuous | 0% |
| `Sum_prec` | `numeric` | continuous | 0% |
| `Prop_flower100` | `numeric` | rate | 0% |
| `Prop_flower250` | `numeric` | rate | 0% |
| `Prop_flower500` | `numeric` | rate | 0% |
| `Prop_flower750` | `numeric` | rate | 0% |
| `Prop_imp500` | `numeric` | rate | 0% |
| `Prop_flower500.1` | `numeric` | rate | 0% |
| `Prop_urb500` | `numeric` | rate | 0% |
| `Prop_open500` | `numeric` | rate | 0% |
| `Prop_tree500` | `numeric` | rate | 0% |
| `Prop_ag500` | `numeric` | rate | 0% |
| `Prop_gard500` | `numeric` | rate | 0% |
| `Prop_road500` | `numeric` | rate | 0% |
| `X750PC1` | `numeric` | continuous | 0% |
| `X750PC2` | `numeric` | continuous | 0% |
| `X500PC1` | `numeric` | continuous | 0% |
| `X500PC2` | `numeric` | continuous | 0% |
| `X250PC1` | `numeric` | continuous | 0% |
| `X250PC2` | `numeric` | continuous | 0% |
| `X100PC1` | `numeric` | continuous | 0% |
| `X100PC2` | `numeric` | continuous | 0% |
| `X100PC3` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: Tot_rep ~ LU500 [+ covariables meteo candidates] -- modele hurdle binomial-negatif zero-altere (partie binaire presence/absence de sexues + partie comptage tronque a zero), selectionne par comparaison all-subsets AICc parmi land-use (LU500) et meteo (Ave_temp, Ave_hum, Sum_prec)
- x_terms_pub: LU500 (categorie City/Village/Agricultural, buffer 500m, PCA+Ward -- confirme candidat principal), Ave_temp, Ave_hum, Sum_prec (candidats de selection de modele ; jeu final exact non recupere, voir tableaux supplementaires S1a/S2a)
- y_term_pub: Tot_rep (nombre total de sexues produits : males + gynes)
- Reference publication: Samuelson, A.E., Gill, R.J., Brown, M.J.F. & Leadbeater, E. (2018), 'Lower bumblebee colony reproductive success in agricultural compared with urban environments', Proceedings of the Royal Society B 285(1881):20180807, DOI 10.1098/rspb.2018.0807 (texte integral verifie via PMC6030522, libre acces). Modele pour Tot_rep : "Total production of sexuals (gynes and males) was analysed using zero-altered negative binomial hurdle models, where the response is modelled as a binary process (production of sexuals) and a zero-truncated count process (total number of sexuals in colonies that produced sexuals)" (texte exact). Occupation du sol : "(1) definition of land-use categories, (2) principal components analysis (PCA) on the categories and (3) cluster analysis based on the PCA output" puis "cluster analysis (Ward's method) was performed on the first two principal components" -> 3 categories 'city' (n=17), 'village' (n=16), 'agricultural' (n=5) -- verifie exactement identique dans le .rds local (colonne LU500). Selection de modele : "we built a comparison set of models including the full model... and all subsets", selection par AIC. Le papier utilise aussi, pour d'autres reponses (pas Tot_rep) : GAM binomial ("Binomial GAMs (allowing for a nonlinear effect of week) with site as a random effect were used to analyse the presence of nectar and pollen and ovary development"), GLM binomial (parasites, invasion de B. vestalis), regression lineaire sur donnees log-transformees ("linear regression was carried out on log-transformed data", pour la taille de colonie maximale -- colonne locale correspondante non identifiee avec certitude), et modeles de Cox ("Cox proportional hazards models", survie des reines/colonies). Diagnostic spatial uniquement : "Final models were examined for spatial autocorrelation by using a Moran's I test on the residuals" -- AUCUN modele de regression spatiale (SAR/SEM/GWR) n'est estime dans le papier.

### Statut regression canonique

- Statut: mis de cote
- Niveau de preuve: publication
- Methode d estimation: formule adaptee/reconstruite a partir des variables du depot -- ne reproduit PAS la methode exacte du papier
- Correspondance Python/R: aucune identifiee
- Note: Correction (2026-09-17, verification texte integral PMC6030522 + inspection directe du .rds) : confirme le hurdle model binomial-negatif zero-altere pour Tot_rep, et identifie `LU500` (deja present dans l'artefact, precedemment classe a tort comme identifiant) comme le predicteur d'occupation du sol reellement utilise -- effectifs City=17/Village=16/Agricultural=5 verifies identiques au papier. Le jeu exact de termes du modele final (parmi LU500 + meteo, selection AICc all-subsets) n'est pas recupere (tableaux supplementaires S1a/S2a non consultes). formula_used reste une adaptation lineaire simultanee de nombreuses proportions/PC, non testee telle quelle dans le papier -- ecart deja documente le 2026-09-08, confirme par cette verification.

### Formule - niveau systeme

- formula_used: Tot_rep ~ Ave_temp + Ave_hum + Sum_prec + Prop_flower500 + Prop_imp500 + Prop_urb500 + Prop_open500 + Prop_tree500 + Prop_ag500 + Prop_gard500 + Prop_road500 + X500PC1 + X500PC2
- License evidence: DataCite API record for DOI 10.5061/dryad.c68cj62 (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: count
- x_terms_used: Ave_temp, Ave_hum, Sum_prec, Prop_flower500, Prop_imp500, Prop_urb500, Prop_open500, Prop_tree500, Prop_ag500, Prop_gard500, Prop_road500, X500PC1, X500PC2
- y_term_used: Tot_rep
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "Tot_rep ~ LU500"
    response: "Tot_rep"
    predictors: ["LU500"]
    role: "simple_baseline"
    source_type: "scientific_publication"
    source_ref: "Samuelson, A.E., Gill, R.J., Brown, M.J.F. & Leadbeater, E. (2018), 'Lower bumblebee colony reproductive success in agricultural compared with urban environments', Proceedings of the Royal Society B 285(1881):20180807, DOI 10.1098/rspb.2018.0807 (texte integral verifie via PMC6030522, libre acces). LU500 confirme predicteur principal d'occupation du sol (voir Reference publication) -- reduction univariee simplifiee, le papier utilise en realite un hurdle model (pas une regression simple) et une selection all-subsets incluant aussi la meteo."
    estimator_context: ["hurdle_negative_binomial (methode publiee, non disponible dans le harnais actuel)"]
    status: "confirmed"

  multivariate_constrained:
    formula: "Tot_rep ~ LU500 + Ave_temp + Ave_hum + Sum_prec  [hurdle binomial-negatif zero-altere, selection AICc all-subsets]"
    response: "Tot_rep (total sexues : males + gynes)"
    predictors: ["LU500", "Ave_temp", "Ave_hum", "Sum_prec"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Samuelson, A.E., Gill, R.J., Brown, M.J.F. & Leadbeater, E. (2018), 'Lower bumblebee colony reproductive success in agricultural compared with urban environments', Proceedings of the Royal Society B 285(1881):20180807, DOI 10.1098/rspb.2018.0807 (texte integral verifie via PMC6030522, libre acces). Voir Reference publication pour les citations exactes (hurdle model, construction LU500, selection AICc)."
    estimator_context: ["hurdle_negative_binomial (methode reellement utilisee, aucun equivalent dans le harnais actuel)"]
    status: "confirmed"
    note: "estimator_context ci-dessus decrit la methode DU PAPIER, pas des candidats de benchmark. Le papier ne teste aucune regression spatiale (pas de SAR/SEM/SDM/GWR) -- seul un test de Moran's I sur les residus est effectue (diagnostic, pas un modele). Candidats de benchmark PROPOSES PAR NOUS (pas attribues au papier) : sar_lag, sem_error, sdm_mixed, mgwrsar_gwr -- pertinents car coordonnees geographiques reelles disponibles (Londres + peripherie), mais aucun ne reproduit une methode publiee ici ; a documenter comme benchmark_candidate_estimators, pas comme preuve scientifique. Methodes reellement utilisees dans le papier, mais pour D'AUTRES reponses que Tot_rep (non modelisees dans formula_pub/formula_used) : GAM binomial (presence nectar/pollen/ovaires, avec semaine, donnees hebdomadaires non presentes dans cet artefact agrege), GLM binomial (parasites), regression lineaire sur log (taille de colonie maximale, colonne locale non identifiee avec certitude), Cox proportional hazards (survie reines/colonies)."

  ml_or_selected:
    formula: "Tot_rep ~ LU500 + Crith_suc + Apic_suc + Crith_fail + Apic_fail + Syntretus + Crithidia + Apicystis + Tot_cuck + Cu_bin + G_thorave + G_wmass + G_dmass + M_thorave + M_wmass + M_dmass + Q_week + Q_died + Col_death_week + Col_status + Ave_temp + Ave_hum + Sum_prec + Prop_flower100 + Prop_flower250 + Prop_flower500 + Prop_flower750 + Prop_imp500 + Prop_flower500.1 + Prop_urb500 + Prop_open500 + Prop_tree500 + Prop_ag500 + Prop_gard500 + Prop_road500 + X750PC1 + X750PC2 + X500PC1 + X500PC2 + X250PC1 + X250PC2 + X100PC1 + X100PC2 + X100PC3"
    response: "Tot_rep"
    predictors: ["LU500", "Crith_suc", "Apic_suc", "Crith_fail", "Apic_fail", "Syntretus", "Crithidia", "Apicystis", "Tot_cuck", "Cu_bin", "G_thorave", "G_wmass", "G_dmass", "M_thorave", "M_wmass", "M_dmass", "Q_week", "Q_died", "Col_death_week", "Col_status", "Ave_temp", "Ave_hum", "Sum_prec", "Prop_flower100", "Prop_flower250", "Prop_flower500", "Prop_flower750", "Prop_imp500", "Prop_flower500.1", "Prop_urb500", "Prop_open500", "Prop_tree500", "Prop_ag500", "Prop_gard500", "Prop_road500", "X750PC1", "X750PC2", "X500PC1", "X500PC2", "X250PC1", "X250PC2", "X100PC1", "X100PC2", "X100PC3"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "Ajoute le 2026-09-17 (nouvelle pratique standard pour les fiches a plus de 10 X : proposer une formule ML/boosting exploitant toutes les covariables disponibles pour selection automatique). 45 des 47 candidats X inclus."
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
    note: "`Rep_status` et `Bin_rep` sont EXCLUS deliberement : verifie par inspection directe du .rds que Rep_status==Bin_rep==(Tot_rep>0) a 100% de correspondance (38/38 lignes) -- ce sont des fuites directes de la reponse (composante binaire du hurdle model elle-meme), pas des covariables exogenes. `Rep_wk` est egalement exclu par prudence (semaine de reproduction, etroitement liee au meme evenement) bien que sa relation exacte avec Tot_rep n'ait pas ete testee aussi strictement."
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_bumblebee_colony_reproduction`
- Dataset name: Data from: Lower bumblebee colony reproductive success in agricultural compared to urban environments
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Lower bumblebee colony reproductive success in agricultural compared with urban environments
- Paper DOI: 10.1098/rspb.2018.0807
- Dataset DOI: 10.5061/dryad.c68cj62
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.c68cj62
- Year: 2018 (annee de depot Dryad/DataCite, non verifiee comme annee de publication de l'article -- voir Reference publication)

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression de comptage sur donnees geolocalisees (pas un modele spatial au sens SAR/SEM/GWR)
- Modele niveau 2 (famille): hurdle count regression (zero-altered negative binomial) pour Tot_rep ; GLM/GAM binomial, regression lineaire sur log, Cox PH pour d'autres reponses du meme papier
- Modele niveau 3 (variante): zero-altered negative binomial hurdle (partie binaire + comptage tronque a zero)

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Tot_rep ~ LU500 + Ave_temp + Ave_hum + Sum_prec [zero-altered negative binomial hurdle model, selection AICc all-subsets]"
  equation_family: count_regression_hurdle
  model_family: "hurdle_negative_binomial (aucun estimateur equivalent dans le harnais actuel)"
  source_type: scientific_publication
  source_ref: "Samuelson et al. (2018), Proceedings B, DOI 10.1098/rspb.2018.0807 (texte integral verifie PMC6030522). Spatial dependence model in publication: NON -- aucun SAR/SEM/SDM/GWR estime. Spatial diagnostic only: test de Moran's I sur les residus des modeles finaux ('Final models were examined for spatial autocorrelation by using a Moran's I test on the residuals')."
  confidence: high
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "manual_review"
  benchmark_task: "review_count"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache."
  reason: "Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache."
```

- Decision: manual_review
- Manque principal: Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Raison: Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "DECISION UTILISATEUR (2026-09-08) : option (b) -- mis de cote explicitement. La methode publiee (hurdle model binomial-negatif zero-altere, predicteur categoriel par clustering PCA+Ward) n'a pas d'equivalent dans le harnais actuel (aucun estimateur hurdle/zero-inflate n'existe dans le registre). N=38 colonies est de toute facon tres petit pour un benchmark spatial fiable. En attente d'un futur chantier d'extension du harnais (nouvel estimateur hurdle/zero-inflated count). formula_used reste documente comme adaptation, pas une reproduction du papier -- ne pas promouvoir package_include=yes avant cette extension."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 38
- k variables: 62
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_petit_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-1.2065639, -0.0407438], y [51.1083416, 51.5933662]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32630 (UTM Zone 30N (EPSG:32630)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- Reproducibility status: OK - loader R enregistre et reexecutable (`bumblebee_colony_reproduction` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `bumblebee_colony_reproduction` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - Statut 'mis de cote' documente et intentionnel (voir Bloc 1 > Statut regression canonique > Note) ; ne pas retraiter sans revue.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20%: G_thorave (NA=84.2%), M_thorave (NA=31.6%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`bumblebee_colony_reproduction` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Lower bumblebee colony reproductive success in agricultural compared with urban environments

## Curation documentée — 2026-09-07

Decision conservatoire : Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : count. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
