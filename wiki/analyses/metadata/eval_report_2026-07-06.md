---
title: Eval Report 2026-07-06
type: analysis
created: 2026-07-06
updated: 2026-07-06
sources:
  - wiki/eval_queue.md
tags: [analysis, eval, quality-gate, remediation-plan]
---

Rapport de remediation produit par l'agent quality-gate a partir de `wiki/eval_queue.md`
(124 entrees). Ce rapport ne modifie aucune fiche -- il liste les corrections a
appliquer, fiche par fiche, pour que l'agent injecteur (ou l'utilisateur) puisse
les executer.

## Methode

- **Cohorte A (6 fiches, 2026-07-06)** : verifiees individuellement contre le
  code R (`Code_scrapping/R/estimators/`) et les `.rds` sources
  (`data/final_datasets/sf/`). Constats factuels confirmes, pas de reprise
  brute du texte de la queue.
- **Cohorte B (117 fiches, 2026-05-12 / 2026-07-02)** : reformatees a partir
  des colonnes "Champs suspects" / "Raison" deja presentes dans
  `wiki/eval_queue.md` (produites par une passe Tier 2 anterieure), converties
  en instructions imperatives. Non re-verifiees individuellement contre les
  sources brutes (volume trop important pour ce rapport) -- a l'exception des
  12 fiches signalees section 3, ou un risque specifique a ete identifie.

## 1. Cohorte A -- 6 fiches recentes, verifiees individuellement

### [[spboost]] (score 0.74, estimator)

- **Sources cassees** : `raw/paper/spbbost_article.pdf` n'existe pas sur
  disque. Le fichier reel est `corpus/papers/raw_pdf/spbbost_article.pdf`.
  C'est ce qui plafonne le score a 0.74 (regle de cap CLAUDE.md : source
  manquante). **Fix : corriger l'entree `sources:` en frontmatter.**
- Deplacer la section "Moteur `parsnip` Du Projet" juste avant
  `## Related Pages` (voir point commun avec mgwr/mgwrsar ci-dessous).

### [[mgwrsar]] (score 0.74, estimator)

- **Placement de section** : `estimator_fiche_schema_v1.md` impose un ordre de
  sections (Summary -> ... -> Open Questions From Papers -> Related Pages).
  La section "Project `parsnip` Engine" est inseree au milieu (entre
  Prediction Controls et Diagnostics To Inspect), rompant cet ordre. [[xgboost]]
  place sa section equivalente ("Project Use As A Non-Spatial Baseline") juste
  avant Related Pages -- c'est le bon pattern. **Fix : deplacer la section
  juste avant `## Related Pages`.**
- **Clarte** : la phrase "control(W = W)" ressemble a un appel R litteral
  mais n'en est pas un (le code reel fait `ctl <- control; ctl$W <- W`).
  **Fix : reformuler pour eviter la confusion avec un appel de fonction.**
- Sources verifiees : tous les chemins `raw/estimators/Mgwrsar/...` existent.
  Pas de source cassee.

### [[mgwr]] (score 0.74, estimator)

- Meme fix de placement de section que mgwrsar (section "Project `parsnip`
  Engine" -> juste avant Related Pages).
- **Section manquante confirmee** : contrairement a mgwrsar.md, mgwr.md n'a
  pas de section dediee "Prediction Controls" pour `TDS_MGWR()`. Le detail
  `method_pred="shepard"` est noye dans une liste de notes d'implementation.
  **Fix : ajouter une section "## Prediction Controls" miroir de celle de
  mgwrsar.md**, documentant `method_pred`, le switch automatique
  TP->shepard, et `h_w`/`kernel_w` pour ce backend.

### [[R_GWmodel_EWHP_ewhp]] (score 0.68, dataset)

- **Variable mal classee, confirme** : `TypSemiD` est liste en
  "Identifier columns (excluded from X candidates)" alors que c'est une
  covariable binaire (type de logement), au meme titre que `TypDetch`/
  `TypFlat` deja dans X -- confirme par `formula_pub`/`formula_used` qui
  l'INCLUENT tous les deux. **Fix : deplacer `TypSemiD` vers "Candidate X
  variables", ajouter une ligne dans le tableau "Detail X" (`integer`,
  `binary`, `0%` NA, comme ses homologues).**
- **Phrase tronquee** ligne 33 : `> Note doc : y is detached (i` -- coupee
  en plein mot. **Fix : completer la phrase ou la supprimer si c'est un
  artefact d'extraction.**
- **Publication DOI resoluble** : marque "pending" alors que la reference
  (Gollini et al. 2015, JSS 63) est un article Journal of Statistical
  Software avec DOI standard : `10.18637/jss.v063.i17`. **Fix : resoudre le
  DOI plutot que de le laisser pending.**
- **quality_pedigree absent** -- voir template section 2.

### [[R_GWmodel_GeorgiaCounties_Gedu.counties]] (score 0.72, dataset) -- **le plus serieux des 6**

- **Verifie directement sur le `.rds`** (`data/final_datasets/sf/R_GWmodel_GeorgiaCounties_Gedu.counties.rds`) :
  ses colonnes reelles sont `AREA, PERIMETER, G_UTM_, G_UTM_ID, AREANAME,
  AREAKEY, X_COORD, Y_COORD` -- **aucune trace de `PctBach`/`PctRural`/
  `PctFB`/`PctBlack`/`PctEld`**.
- Or la fiche affiche "Formule -- niveau publication :
  `PctBach~PctRural+PctFB+PctBlack+PctEld`" avec "Statut: bon candidat /
  Niveau de preuve: verbatim", comme si c'etait directement verifie sur ce
  fichier precis. En realite cette formule provient du jeu jumeau
  `Python_libpysal_georgia` (note en "Correspondance Python/R" mais pas mise
  en avant dans le statut).
  **Fix : rétrograder "Niveau de preuve" de `verbatim` a quelque chose comme
  `inherited_via_twin_dataset`, et ajouter une phrase explicite indiquant que
  la formule N'EST PAS calculable sur les colonnes reelles de ce fichier.**
- **Verification supplementaire recommandee** : s'assurer qu'il ne s'agit pas
  en realite du meme dataset sous-jacent duplique par erreur dans le
  catalogue sous deux entrees (`R_GWmodel_GeorgiaCounties_Gedu.counties` vs
  `Python_libpysal_georgia`), auquel cas une fusion ou une deduplication
  serait preferable a une simple correction de champ.
- **Bloc 3 "Modele niveau 1/2/3: pending"** malgre un bloc `modeling_evidence`
  complet juste en dessous (confidence: high) -- incoherence a resoudre une
  fois le point precedent clarifie.
- **quality_pedigree absent** -- voir template section 2.

### [[R_agridat_lasrosas.corn_lasrosas.corn]] (score 0.72, dataset) -- meme bug que Georgia-GWmodel, confirme

- `formula_used` (Bloc 1, "Formule -- niveau systeme") recopie tel quel
  `YIELD~N+N2+TOPO/TOP2-4+NXTOPz` -- variables transformees par GeoDa
  (`N`, `N2`, `TOP2-4`, `NXTOPz`) qui n'existent PAS dans ce `.rds`. Les
  colonnes reelles, listees dans le Bloc 1 lui-meme ("Candidate X
  variables"), sont `nitro, topo, bv, nf, year`.
- C'est exactement le probleme deja documente et contourne dans le pipeline
  R de ce projet (`wiki/metadata/tidymodels_spatial_pipeline_status_2026-07.md`),
  qui utilise `yield ~ nitro + bv` pour cette raison precise.
  **Fix : `formula_used`/`x_terms_used`/`y_term_used` ne doivent pas copier
  `formula_pub` aveuglement -- soit remplacer par la formule reellement
  calculable (`yield ~ nitro + bv`, deja validee dans le pipeline R), soit
  marquer explicitement "necessite transformation GeoDa non appliquee sur ce
  fichier".**
- **quality_pedigree absent** -- voir template section 2.

## 2. Template quality_pedigree a ajouter (rappel du schema)

Presque toutes les fiches de la cohorte B (et 4 des 6 de la cohorte A)
n'ont pas de bloc `quality_pedigree`. Plutot que de le signaler fiche par
fiche sans plus de details, voici le bloc a inserer (adapter les scores et
`*_evidence` au cas par cas -- ne jamais copier les valeurs telles quelles
sans justification specifique) :

```yaml
quality_pedigree:
  provenance: software_package        # ou official_warehouse / peer_reviewed_paper selon la source
  provenance_score: 3
  provenance_evidence: "<a completer>"
  rigour_score: 3
  rigour_evidence: "<a completer>"
  evidence_score: 3
  evidence_evidence: "<a completer>"
  coherence_score: 3
  coherence_evidence: "<a completer>"
  claim_discipline_score: 3
  claim_discipline_evidence: "<a completer>"
  citation_metrics:
    dataset_citation_count: null
    paper_citation_count: null
    citation_source: none
    citation_checked_at: null
    citation_interpretation: not_checked
    citation_evidence: "Non verifie."
  delta1_risk: medium
  evaluator_proposed_by: llm
  human_review_required: true
  review_status: pending
  reviewer: null
  reviewed_at: null
  reference_schema: wiki/metadata/quality_pedigree_schema_v1.md
```

Regle rappelee par [[quality_pedigree_schema_v1]] : le LLM ne doit jamais
marquer `review_status: reviewed` lui-meme -- ce bloc doit toujours sortir
avec `review_status: pending` et attendre une validation humaine.

## 3. Risque systemique -- formula_used copie formula_pub sans verification

Le bug confirme sur Georgia-GWmodel et lasrosas (section 1) touche
potentiellement d'autres fiches qui referencent un jeu "jumeau" via
"Correspondance Python/R". 12 fiches du catalogue sont dans ce cas :

```
Python_geodatasets_geoda.lasrosas, Python_geodatasets_spdata.columbus, Python_libpysal_georgia,
R_GWmodel_GeorgiaCounties_Gedu.counties, R_GWmodel_LondonBorough_londonborough, R_GWmodel_LondonHP_londonhp,
R_agridat_lasrosas.corn_lasrosas.corn, R_gstat_meuse.all_meuse.all, R_sp_meuse_meuse,
R_spdep_oldcol_COL.OLD, R_surveillance_hagelloch_hagelloch.df, R_surveillance_hagelloch_hagelloch
```

Seules 2 des 12 ont ete verifiees directement dans ce rapport (les deux
listees en cohorte A). **Recommandation : verifier les 10 autres (comparer
les termes de `formula_used` aux colonnes reelles du `.rds` correspondant)
avant de les considerer fiables.**

## 4. Cohorte B -- 117 fiches legacy (2026-05-12 / 2026-07-02), reformatees depuis eval_queue.md

Note de methode : ces entrees n'ont pas ete re-verifiees contre leurs
sources brutes individuelles dans ce rapport (voir section Methode). Les
corrections ci-dessous reformulent en instructions imperatives les colonnes
"Champs suspects" / "Raison" deja presentes dans `wiki/eval_queue.md` pour
chaque fiche. Le fix "ajouter quality_pedigree" renvoie systematiquement au
template de la section 2 et n'est pas repete en detail a chaque ligne.

### Analyses (score < 0.75)

- **[[zenodo_15530852_mexico_municipalities_expenditure]]** (0.74) : resoudre
  `modeling_evidence.paper_doi`/`evidence_source`; verifier que la page du
  papier existe dans `wiki/` avant de lier en Related Pages.
- **[[zenodo_15627695_mexico_property_tax_spillovers]]** (0.74) : resoudre
  `paper_doi`/`paper_title`/`paper_url`; remplacer `n_observations: unknown`
  par une valeur inspectee ou `to_be_determined` explicite.
- **[[zenodo_15781610_poland_ekc_nuts]]** (0.74) : completer
  `variables_inspected`, `temporal_range_T_periods`,
  `presence_of_imputed_X`, `reproducibility_code_availability`,
  `dataset_citation_metrics`.
- **[[book_lookup_statistics_for_high_dimensional_data_2026_04_23]]** (0.62) :
  viole les frontieres de type d'entite AGENTS.md (book lookups / download
  summaries ne sont pas des `analysis`) -- reclasser `type` ou deplacer le
  contenu vers un type approprie; corriger `sources`; clarifier
  `stored_artifacts_routing`.
- **[[dataset_ranking_metadata_spatial_download_priority_2026_04_22]]** (0.72) :
  corriger `file_path_inferred`; verifier conformite frontmatter; clarifier
  `schema_routing`.
- **[[france_unemployment_datasets_comparison]]** (0.65) : peupler `sources`
  avec les fichiers raw / pages wiki reels sous-tendant les comparaisons;
  ajouter un extrait de preuve citant les pages dataset consultees.
- **[[metadata_oriented_dataset_discovery_warehouses_2026_04_22]]** (0.65) :
  peupler `sources`; corriger `created`/`updated`; completer
  `comparison_table_dataset_existence`, `warehouse_access_routes`,
  `classification_structures`.
- **[[raw_spatiotemporal_dataset_scraping_targets_2026_04_23]]** (0.65) :
  corriger `type`/`created`/`updated`; separer les URLs et DOIs dans
  `sources` par famille; creer les pages `related_pages` manquantes ou les
  retirer; ajouter le bloc `quality_pedigree` (obligatoire pour les
  references dataset/paper/source selon AGENTS.md).
- **[[download_batch_2026_04_23_datasets10_papers10]]** (0.74) : corriger
  `type`/`sources`/`related_pages`.
- **[[trade_raw_endpoint_verification_2026_04_22]]** (0.72) : peupler
  `sources`; ajouter l'extrait de preuve manquant.
- **[[feature_selection_block_template]]** (0.70) : peupler `sources`;
  ajouter `evidence_source_excerpt`; clarifier `type_classification`.
- **[[rnn_svm_strategy_2026_04_23]]** (0.62) : peupler `sources`; corriger
  `claims_faithful`; documenter `evidence_extraction`; ajouter
  `quality_pedigree`.
- **[[scientific_data_linked_papers_2026_04_27]]** (0.55) : auditer la
  colonne "Local status" contre le manifest et `wiki/log.md`; verifier que
  toutes les pages wiki citees en Sources existent; detailler les 5
  `rejected_responses` du manifest; clarifier si c'est le batch final de 10
  papiers ou une liste courte; ajouter `quality_pedigree` avec
  `review_status`/`human_review_required`.
- **[[software_dataset_literature_links_2026_04_29]]** (0.52) : `sources` ne
  doit citer que des fichiers `raw/`, pas `data/manifests/`; ajouter
  `quality_pedigree`; valider les entrees Georgia education et xarray;
  corriger la date de l'entree xarray 2026; resoudre le doublon North
  Carolina SIDS (DOIs differents); corriger le JSON tronque de l'entree
  Boston housing; ajouter un champ structure candidate/unvalidated pour le
  statut de validation; verifier l'existence des `related_pages`.
- **[[software_python_priority_datasets_metadata]]** (0.74) : lister les
  versions/URLs precises de geodatasets/libpysal dans `sources`; preciser la
  methode d'extraction prevue pour `modeling_evidence: pending`; ajouter
  `quality_pedigree` complet; ajouter les manifests references dans
  `sources`; clarifier le routage des "Next Actions" (`wiki/analyses/metadata/`
  vs `wiki/analyses/modeling/`); verifier l'existence des pages liees en
  Related Pages.
- **[[software_r_priority_datasets_metadata]]** (0.72) : ajouter
  `quality_pedigree`; completer `sources`; justifier les `modeling_evidence:
  pending` ou les resoudre; peupler `feature_selection`/`X_selected`;
  ajouter DOI/citation; ajouter `review_status`/`human_review_required`.
- **[[revision_boosting_statistics_high_dimensional_data_2026_04_23]]** (0.65) :
  verifier `all_page_numbers`, les formulations d'equations, les enonces
  theoreme 12.1/12.2/12.3, le tableau d'hypotheses p.411, l'exemple
  riboflavine, la formule hat-matrix p.406-407 contre le PDF source;
  completer `sources`.
- **[[zenodo_18421412_mountain_fire]]** (0.72) : resoudre `paper_linkage_status`;
  differer `y_typology`/`x_typology` a l'inspection des donnees; completer
  `n_obs`/`t_periods` depuis le README; verifier `modeling_evidence` contre
  le README ou une publication liee.

### Estimateurs (score < 0.75, hors cohorte A)

- **[[gamboost]]** (0.72) : verifier l'extrait de preuve source et la
  fidelite de source (`source_faithful`); completer le manifest de formules.
- **[[inla]]** (0.65) : verifier la formulation latente gaussienne canonique
  contre `OpitzINLA.pdf` une fois extrait; verifier chaque hyperparametre
  (actuellement tous `project_candidate`); clarifier si l'etat "template"
  (section Open Questions) est un etat de transit acceptable ou bloquant.
- **[[lightgbm]]** (0.65) : verifier la forme additive canonique contre la
  source; integrer une preuve papier reelle (`Paper Evidence Status` marque
  partout "pending extraction"); ajouter des directives de tuning issues des
  papiers pour les hyperparametres (actuellement tous `project_candidate`).
- **[[random_forest]]** (0.65) : verifier `Model Equation`/`Paper Evidence
  Status`/`Open Questions` -- la formule et la structure sont correctes mais
  non verifiees contre la source.
- **[[mars]]** (0.72) : verifier la forme canonique MARS contre le PDF source;
  resoudre `penalty`/`minspan`/`endspan` (actuellement "later"/"to_verify");
  repondre aux questions ouvertes; corriger le chemin `sources` (backslash
  Windows `raw\paper\...` -> slash Unix).

### Datasets (score < 0.75) -- champs recurrents

Pour la quasi-totalite des entrees suivantes, le motif dominant est
identique : `quality_pedigree` absent (template section 2), `Publication
DOI` bloque a "pending" au lieu d'etre resolu ou marque `none` explicitement,
`formula_used`/`x_terms_used`/`y_term_used` bloques a "pending" sans
justification, et parfois CRS EPSG manquant. Le detail specifique
(au-dela de ce motif commun) est liste ci-dessous ; sinon, appliquer les 4
corrections generiques.

- **[[R_spDataLarge_pol_pres15_pol_pres15]]** (0.72) : corriger la
  contradiction de geometrie (Bloc 5 dit POINT, texte decrit des unites
  aereales/polygones) -- verifier le type reel.
- **[[Python_geodatasets_geoda.airbnb]]** (0.72) : justifier
  `modeling_evidence.confidence: low`.
- **[[R_gstat_jura_jura.pred]]** (0.68) : nommer le type de krigeage si
  Goovaerts 1997 est la reference; ajouter `feature_selection` (absent).
- **[[Python_geodatasets_geoda.charleston1]]** (0.74) : documenter le plan de
  transition `formula_used` (pending -> resolu).
- **[[Python_geodatasets_geoda.charleston2]]** (0.72) : resoudre
  `modeling_evidence.equation_family`/`model_family` (actuellement
  "unknown").
- **[[Python_geodatasets_geoda.chicago_commpop]]** (0.74) : justifier
  `modeling_evidence.confidence`.
- **[[Python_geodatasets_geoda.chicago_health]]** (0.68) : resoudre
  `modeling_evidence.source_ref`; justifier la confidence.
- **[[Python_geodatasets_geoda.chile_labor]]** (0.68) : verifier coherence
  `formula_pub` avec la reference liee; resoudre le DOI
  (`10.1007/978-981-10-0230-4_6` deja identifie, a formaliser); classer le
  niveau de modele; peupler la resolution temporelle (dates de recensement
  disponibles mais marquees pending).
- **[[Python_geodatasets_geoda.guerry]]** (0.68) : clarifier si la source de
  formule est la doc Python `geodatasets` ou le package R `Guerry`
  uniquement; peupler les niveaux de typologie modele; declarer
  explicitement le paper_linkage (DOI/titre ou "aucun").
- **[[Python_geodatasets_geoda.cincinnati]]** (0.68) : reparer le lien
  `modeling_evidence.source_ref` casse (pas de fallback); clarifier le
  statut pending de `formula_used`; justifier la confidence "medium" sans
  source verifiable.
- **[[Python_geodatasets_geoda.health]]** (0.68) : `Publication DOI` doit
  passer de "pending" a "none" explicite; corriger l'avertissement Quality
  Control (liste de variables visiblement corrompue -- artefact
  d'extraction a reparer).
- **[[Python_geodatasets_geoda.health_indicators]]** (0.68) : remplacer la
  chaine `"null"` par un vrai `null` JSON dans
  `modeling_evidence.equation_text`; `confidence` doit etre numerique ou
  omis.
- **[[Python_geodatasets_geoda.hickory1]]** (0.74) : `modeling_evidence.source_ref`
  reste null malgre recherche exhaustive -- documenter la methode de
  recherche utilisee.
- **[[Python_geodatasets_geoda.hickory2]]** (0.72) : remplacer les chaines
  `"null"` par `null` JSON (`source_ref`, `equation_text`); `sources`
  frontmatter doit citer le fichier `.rds`, pas un fichier corpus.
- **[[Python_geodatasets_geoda.home_sales]]** (0.68) : clarifier si
  `arxiv.org/pdf/2507.07113` est un papier dataset ou une reference externe;
  ajouter une source corpus ou un DOI pour les equations.
- **[[Python_geodatasets_geoda.lansing1]]** (0.68) : `Dataset DOI` doit
  affirmer explicitement "non disponible" plutot que "none" ambigu.
- **[[Python_geodatasets_geoda.lansing2]]** (0.72) : resoudre
  `modeling_evidence.model_family` ("unknown" -> revue de recherche de
  modele canonique ou confirmation d'absence).
- **[[Python_geodatasets_geoda.lasrosas]]** (0.68) : clarifier si GeoDa
  center ou le DOI cite est la source primaire; verifier `formula_pub` contre
  la source avant de la marquer fidele (meme risque que la fiche R
  correspondante, voir section 3).
- **[[Python_geodatasets_geoda.milwaukee1]]** (0.72) : remplacer la chaine
  `"null"` par `null` JSON dans `source_ref`.
- **[[Python_geodatasets_geoda.ndvi]]** (0.58) : corriger `y_typology`
  (GREEN: "count" -> "continuous"); corriger `x_typology` (TEMP, ELEV, PREC:
  "count" -> "continuous"); declarer explicitement le lien Anselin 1993 avec
  DOI ou "aucun"; resoudre `crs_recommended` (pending -> EPSG concret);
  ajouter un champ `feature_selection_method`.
- **[[Python_geodatasets_geoda.nepal]]** (0.72) : remplacer les chaines
  `"null"` par `null` JSON dans `modeling_evidence`.
- **[[Python_geodatasets_geoda.nyc]]** (0.68) : resoudre `modeling_evidence.source_ref`
  ("null" -> confirmer explicitement l'absence de regression publiee ou
  localiser la preuve).
- **[[Python_geodatasets_geoda.nyc_education]]** (0.68) : `formula_used`/
  `y_term_used`/`x_terms_used` marques pending alors que `formula_pub` (avec
  `mean_inc` et la liste X complete) est deja documentee -- resoudre;
  ajouter `paper_title`/`paper_authors`/`paper_year`.
- **[[Python_geodatasets_geoda.nyc_neighborhoods]]** (0.72) : clarifier si
  l'absence de formule canonique disqualifie le dataset pour la modelisation
  ou s'il reste utile en exploratoire.
- **[[Python_geodatasets_geoda.orlando1]]** (0.68) : clarifier si un DOI
  verifiable existe malgre le "pending".
- **[[Python_geodatasets_geoda.phoenix_acs]]** (0.74) : justifier
  `modeling_evidence.confidence: low`.
- **[[Python_geodatasets_geoda.police]]** (0.62) : corriger `x_typology`
  (continuous/rate, pas count); clarifier le mapping de noms de variables
  formule<->donnees (OWNER->OWN, OUT->?, TRANS->?); creer une fiche paper
  pour Kelejian & Robinson 1992 ou marquer reference externe uniquement;
  clarifier si la formule est ajustee empiriquement sur ce dataset ou
  purement litteraire.
- **[[Python_geodatasets_geoda.sacramento1]]** (0.72) : documenter pourquoi
  `formula_used`/`x_terms_used`/`y_term_used` restent pending malgre une
  recherche manuelle exhaustive.
- **[[Python_geodatasets_geoda.savannah1]]** (0.74) : resoudre
  `modeling_evidence.source_type`/`confidence`; peupler les niveaux de
  modele 1/2/3.
- **[[Python_geodatasets_geoda.seattle1]]** (0.72) : ajouter une declaration
  explicite d'indisponibilite du Dataset DOI; documenter la rationale de
  `feature_selection`.
- **[[Python_geodatasets_geoda.tampa1]]** (0.74) : justifier
  `modeling_evidence.confidence`; justifier `CRS_analyse_recommande`.
- **[[Python_geodatasets_geoda.us_sdoh]]** (0.72) : peupler les niveaux de
  modele 1/2/3; citer Kolak et al. 2020 dans l'extrait de preuve plutot que
  "No local source evidence".
- **[[Python_geodatasets_naturalearth.cities]]** (0.72) : peupler
  `modeling_evidence` (formula_used, x_terms_used, y_term_used); peupler les
  niveaux de modele 1/2/3; resoudre `CRS analyse recommande`.
- **[[Python_geodatasets_spdata.boston]]** (0.74) : formaliser le lien vers
  rdrr.io comme entite paper plutot qu'implicite; reconcilier
  `modeling_evidence.source_ref` avec `publication_doi`.
- **[[Python_geodatasets_spdata.columbus]]** (0.74) : ajouter DOI et titre
  explicites pour Anselin (1988); clarifier si c'est la source primaire ou
  secondaire du modele -- meme risque formula_used que section 3.
- **[[Python_geodatasets_spdata.eire]]** (0.72) : peupler les niveaux de
  modele 1/2/3; completer la note sur le choix de projection CRS.
- **[[Python_geodatasets_spdata.nydata]]** (0.68) : corriger l'avertissement
  Quality Control (sortie de seuil NA corrompue).
- **[[Python_geodatasets_spdata.wheat]]** (0.62) : peupler `sources`;
  declarer `paper_linkage`; resoudre `CRS analyse recommande`.
- **[[Python_libpysal_Baltimore]]** (0.68) : ajouter DOI et titre pour Dubin
  1992.
- **[[Python_libpysal_Elections]]** (0.68) : changer "pending" en "none"
  pour `formula_used`/`x_terms_used`/`y_term_used` (recherche exhaustive
  deja faite); remplacer la chaine `"null"` par `null` JSON.
- **[[Python_libpysal_NYC_Socio-Demographics]]** (0.72) : reclasser
  `gini`/`medianinco` (actuellement character/categorical, a fournir des
  niveaux ou reclasser); clarifier si la recherche de `formula_pub` a ete
  exhaustive ou par echantillonnage.
- **[[Python_libpysal_Ohiolung]]** (0.62) : verifier la fiche paper Xia &
  Carlin (1998) et son DOI; **verifier l'etendue spatiale -- x range
  [-85.4895, -85.4895] a variance nulle, y [0.0003, 0.0004] extremement
  petit, probable erreur d'export a corriger en priorite.**
- **[[Python_libpysal_Snow]]** (0.62) : `formula_pub` necessite validation de
  source ou suppression -- confidence "low" sans source publiee ne devrait
  pas figurer dans la fiche sans reserve claire; citer la doc libpysal, un
  exemple de code ou un papier academique pour `source_ref`.
- **[[Python_libpysal_georgia]]** (0.68) : verifier `modeling_evidence.model_family`
  (niveaux 1/2/3) -- **verifier aussi la coherence avec
  R_GWmodel_GeorgiaCounties_Gedu.counties (voir section 3, meme formule
  citee, fichiers `.rds` differents).**
- **[[R_GWmodel_DubVoter_Dub.voter]]** (0.72) : verifier/resoudre le DOI
  Kavanagh 2006 via `corpus/bib/references.bib` ou Crossref; verifier CRS
  (Irish Grid ou WGS84); clarifier si Kavanagh 2006 est un papier ou une
  documentation logicielle (`source_type` dit "software_documentation" mais
  c'est cite comme une citation academique).
- **[[R_GWmodel_LondonBorough_londonborough]]** (0.62) : ajouter CRS_EPSG;
  citation complete DOI/bibtex pour Lu et al. 2014; verifier le lien vers le
  dataset LondonHP.
- **[[R_GWmodel_LondonHP_londonhp]]** (0.74) : resoudre le nom CRS pour
  EPSG:27700 (deja identifie, nom manquant); peupler formula_used/x_terms_used/
  y_term_used (systeme, pas seulement publication).
- **[[R_GWmodel_USelect_USelect2004]]** (0.68) : ajouter CRS EPSG/nom;
  resoudre `modeling_evidence.source_type`; declarer `paper_linkage`.
- **[[R_SpatialEpi_pennLC_sf_pennLC_sf]]** (0.72) : peupler `formula_used`;
  clarifier `source_type` (verbatim vs infere).
- **[[R_ade4_atlas_atlas]]** (0.62) : changer les niveaux de modele de
  "pending" a "not_applicable" (ordination, pas regression) avec
  justification; resoudre CRS ou declarer "permanently unknown" justifie.
- **[[R_ade4_atya_atya]]** (0.62) : resoudre ou confirmer `null` pour
  `modeling_evidence`; resoudre CRS EPSG; confirmer `formula_used`/`x_terms_used`/
  `y_term_used` en "pending" volontaire ou `null`.
- **[[R_ade4_avijons_avijons]]** (0.72) : remplacer "unknown" par valeur
  explicite ou `null` pour `equation_family`/`model_family`; ajouter lookup
  CRS EPSG.
- **[[R_ade4_buech_buech]]** (0.62) : ajouter CRS EPSG; clarifier explicitement
  `Publication DOI` (none/pending/valide); `modeling_evidence.source_ref`
  doit dire "none" pas `"null"`.
- **[[R_ade4_butterfly_butterfly]]** (0.68) : ajouter CRS EPSG ou "not
  available" explicite; planifier une date de revue manuelle Y/X.
- **[[R_ade4_doubs_doubs]]** (0.74) : lookup CRS EPSG (actuellement
  "unknown"); confirmer l'etat final de `modeling_evidence.source_type`.
- **[[R_ade4_elec88_elec88]]** (0.62) : Dataset DOI doit dire explicitement
  "No DOI available" plutot que "none"; ajouter note CRS explicite "unknown,
  not geographic" si pertinent; `source_type`/`confidence` doivent etre
  `null` plutot que "unknown"/"low" sans justification.
- **[[R_ade4_irishdata_irishdata]]** (0.72) : remplacer la chaine `"null"`
  par `null` JSON pour `source_ref`; resoudre les niveaux de modele 1/2/3
  (pending -> "unknown" au minimum).
- **[[R_ade4_julliot_julliot]]** (0.72) : clarifier CRS; noter que
  `model_family: unknown` devrait dire "ordination, pas regression"; ajouter
  documentation formelle de `feature_selection`.
- **[[R_ade4_jv73_jv73]]** (0.58) : peupler ou justifier explicitement
  l'absence de `formula_used`/niveaux de modele/CRS/DOI (dataset non
  regressif -- documenter cette nature plutot que laisser "pending").
- **[[R_ade4_kcponds_kcponds]]** (0.72) : ajouter CRS complet, DOI, formule
  systeme, `quality_pedigree`, justification de confidence.
- **[[R_ade4_macon_macon]]** (0.68) : CRS doit dire explicitement "not
  applicable -- non-geographic wine tasting data"; DOI doit etre resolu ou
  "none"; confirmer absence de formule canonique ou documenter la formule
  d'ordination si utilisee.
- **[[R_ade4_pcw_pcw]]** (0.58) : dataset mal adapte a la regression --
  documenter cette inadequation clairement plutot que de laisser tous les
  champs Y/X/modeling_evidence en `pending`.
- **[[R_ade4_sarcelles_sarcelles]]** (0.68) : clarifier le role de
  `x_typology` (covariate vs count); CRS "unknown - not geographic" explicite;
  formaliser `feature_selection`.
- **[[R_ade4_t3012_t3012]]** (0.62) : citer la doc/vignette du package ade4
  dans `sources` (actuellement vide); justifier `confidence: low`.
- **[[R_ade4_tintoodiel_tintoodiel]]** (0.72) : lookup CRS EPSG/nom; DOI a
  resoudre ou "none"/"not-available"; ajouter methodologie de recherche pour
  `modeling_evidence.source: none`.
- **[[R_ade4_vegtf_vegtf]]** (0.62) : lookup CRS EPSG; justifier
  `confidence: low`.
- **[[R_ade4_zealand_zealand]]** (0.74) : lookup CRS EPSG; verifier si la
  citation ade4 suffit ou si une reference d'origine existe; envisager
  "very_low" pour confidence ou documenter explicitement la nature
  multivariee (pas regression-ready).
- **[[R_agridat_gartner.corn_gartner.corn]]** (0.68) : ajouter CRS EPSG;
  completer la reference Rakshit avec DOI, creer/lier une fiche paper;
  formaliser license_data vs license_package.
- **[[R_agridat_ortiz.tomato.covs_ortiz.tomato.covs]]** (0.68) : lookup CRS
  EPSG/nom; resoudre `formula_used`/`x_terms_used`/`y_term_used`.
- **[[R_agridat_usgs.herbicides_usgs.herbicides]]** (0.58) : **verifier la
  classe R des variables Y candidates -- devraient etre numeriques, pas
  factor** (incoherence typologique signalee comme majeure); inspecter la
  colonne `date` pour la resolution temporelle; `publication_doi` doit etre
  `null`/"none" (package R, pas de DOI); declarer `paper_linkage` explicite
  (USGS WRIR 98-4245 ou "aucun"); clarifier le routage `formula_system`.
- **[[R_agridat_wallace.iowaland_wallace.iowaland]]** (0.62) : corriger
  `y_typology` (fedval, stval: "count" -> "continuous"); corriger `x_typology`
  (yield, corn, grain, untillable: "count" -> "proportion"/"continuous");
  ajouter des roles `covariate` explicites pour X; declarer `paper_linkage`
  ("none" ou lien); resoudre lookup CRS; aligner `modeling_evidence.confidence`
  sur l'echelle low/medium/high du schema v3.
- **[[R_gstat_DE_RB_2005_DE_RB_2005]]** (0.68) : resoudre resolution/plage
  temporelle; peupler formula_used/x_terms_used/y_term_used; peupler niveaux
  de modele 1/2/3; ajouter nom CRS.
- **[[R_gstat_jura_jura.val]]** (0.62) : resoudre `equation_text`/`equation_family`
  (null/unknown); resoudre `model_family` (unknown); ajouter extrait de
  preuve citant la doc du package ou Goovaerts 1997.
- **[[R_gstat_meuse.all_meuse.all]]** (0.72) : lookup CRS EPSG; resoudre
  `formula_used`/`x_terms_used` depuis la vignette gstat ou une publication;
  declarer `paper_linkage` explicite; ajouter extrait de source locale --
  **meme risque formula_used que section 3, a verifier.**
- **[[R_gstat_oxford_oxford]]** (0.74) : lookup CRS EPSG; remplacer la chaine
  `"null"` par `null` JSON pour `equation_text`; documenter si les niveaux de
  modele "pending" sont attendus pour des datasets sans publication
  canonique.
- **[[R_sfdep_guerry_nb_guerry_nb]]** (0.68) : clarifier `crs_epsg`,
  `publication_doi_role`, `dataset_role`; declarer `paper_linkage`.
- **[[R_spDataLarge_lsl_lsl]]** (0.74) : resoudre le nom CRS pour EPSG:32717;
  peupler formula_used/x_terms_used/y_term_used.
- **[[R_spData_depmunic_depmunic]]** (0.62) : peupler formula_used/x_terms_used/
  y_term_used et niveaux de modele; `confidence` devrait etre "low" pas
  "medium" (formule candidate non verifiee sur ce dataset); localiser Dong &
  Harris (2014) pour valider ou rejeter la formule; clarifier si
  airbnb/pop_rest doivent etre modelises ensemble ou separement.
- **[[R_spData_house_house]]** (0.62) : corriger `y_typology` (price/avalue:
  "count" -> "continuous"); resoudre `formula_system`/niveaux de modele;
  ajouter DOI LeSage & Pace (2004) ou "source cite, non lie" explicite;
  formaliser `feature_selection`.
- **[[R_spData_nz_nz]]** (0.68) : Dataset_DOI doit expliquer pourquoi "none";
  `confidence: low` doit avoir un texte de justification; `formula_pub`
  devrait dire explicitement "none -- polygones administratifs sans
  regression documentee"; niveaux de modele "pending" -> "N/A -- no modeling
  evidence".
- **[[R_spData_properties_properties]]** (0.68) : verifier tracabilite DOI;
  reconcilier `formula_pub`/`modeling_evidence` avec la claim "no source
  found".
- **[[R_spData_world_world]]** (0.74) : resoudre `publication_doi`; confirmer
  intentionnalite de `confidence: low`.
- **[[R_sp_meuse.grid_ll_meuse.grid_ll]]** (0.68) : lookup CRS EPSG/nom;
  peupler niveaux de modele.
- **[[R_sp_meuse.grid_meuse.grid]]** (0.72) : resoudre nom CRS; peupler
  formula_used/x_terms_used/y_term_used; ajouter extrait de source locale.
- **[[R_sp_meuse_meuse]]** (0.68) : peupler formula_used/y_term_used et
  niveaux de modele; lookup nom CRS (EPSG:28992); aligner
  `equation_family`/`model_family` sur la taxonomie standard.
- **[[R_spaMM_Leuca_Leuca]]** (0.74) : lookup CRS EPSG; assigner ou marquer
  explicitement differes les niveaux de modele.
- **[[R_spaMM_Loaloa_Loaloa]]** (0.74) : lookup CRS; justifier
  `modeling_evidence.confidence`.
- **[[R_spaMM_arabidopsis_arabidopsis]]** (0.74) : lookup CRS EPSG; peupler
  formula_used/x_terms_used; peupler niveaux de modele.
- **[[R_spatstat.data_nbfires_nbfires]]** (0.72) : ajouter CRS EPSG/nom;
  resoudre resolution/plage temporelle; resoudre
  `modeling_evidence.source_type`/`source_ref`.
- **[[R_spdep_oldcol_COL.OLD]]** (0.72) : resoudre DOI; CRS EPSG/nom; lier
  Anselin 1988; ajouter formula_used/x_terms_used/y_term_used -- **meme
  risque formula_used que section 3, a verifier.**
- **[[R_surveillance_hagelloch_hagelloch.df]]** (0.72) : lookup CRS EPSG;
  peupler `y_term_pub` dans formula_pub (vide); peupler niveaux de modele --
  **meme risque formula_used que section 3, a verifier.**
- **[[R_surveillance_hagelloch_hagelloch]]** (0.72) : lookup CRS EPSG/nom;
  peupler formula_used/x_terms_used/y_term_used; valider l'evidence source
  locale (aucun extrait disponible) -- **meme risque formula_used que
  section 3, a verifier.**

## Related Pages

- [[eval_system_documentation]]
- [[catalog_registry_schema_v3]]
- [[quality_pedigree_schema_v1]]
- [[estimator_fiche_schema_v1]]
