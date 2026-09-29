# État d’avancement du data paper — 24 septembre 2026

## Objectif de l’article

Le premier article présente une banque multidomaine de données spatiales et spatio-temporelles conçue pour la recherche statistique reproductible. Sa contribution principale est de relier les fichiers aux articles et sources d’origine, aux rôles analytiques des variables, aux formules publiées, à la géométrie, au temps, aux matrices de voisinage disponibles, aux transformations et au niveau de maturité de chaque jeu. La comparaison générale des estimateurs du package `spatialtidymodels` est reportée.

## Résumé par bloc de l'article (état du brouillon `BROUILLON_DATAPAPER_V1`)

**Titre de travail.** *A provenance-aware, cross-domain data bank of spatial and spatio-temporal datasets for reproducible statistical research.*

**Background & Summary — rédigé en entier (5 mouvements).**
1. *Monte-Carlo et diversité empirique* : la méta-analyse des 66 articles montre une médiane d'1 seul jeu réel par article, contre au moins 117 expériences de simulation et 2 042 cellules de paramètres — l'effort d'évaluation est concentré sur le simulé, pas sur l'empirique (Figure 1).
2. *Infrastructures existantes et le manque restant* : comparaison à PMLB, OpenML, AMLB, TableShift, TabZilla, TabReD (bancs généralistes) et CAMELS-US/LamaH-CE/Caravan (bancs spatiaux mono-domaine, hydrologie) — aucun ne combine multi-domaine + structure spatiale/temporelle + formule publiée liée (Table 2).
3. *Des sources dispersées vers des fiches réutilisables* : état chiffré du catalogue au 24 septembre — 392 fiches, 278 `yes`/59 `manual_review`/55 `no`, 241 familles distinctes (131 parmi les `yes`) après dédoublonnage parent-enfant (Table 1, Figure 2). Clarifie que `package_include: yes` ne veut pas dire "embarqué physiquement" (seulement 16/278 le sont).
4. *Curation assistée sous contrôle humain* : rôle des LLM (extraction, cohérence) vs décision humaine (promotion jamais automatique).
5. *Contribution et plan de l'article.*

**Methods — 3 sous-sections rédigées sur 4.**
- *Literature sample and coding* (rédigée) : protocole de la méta-analyse, 66 articles retenus sur 70 filtrés, grille de codage à ~50 colonnes par article.
- *Data collection, provenance and curation* (rédigée, corrigée le 24 septembre) : les 3 voies de collecte dans leur vrai ordre chronologique — Bloc 1 logiciel (packages R/Python, premier), Bloc 2 dataset-first (Dryad/Zenodo/DataCite, deuxième), Bloc 3 article-first (complément tardif du Bloc 2, motivé par le corpus d'articles déjà réuni pour la méta-analyse) — puis pipeline commun (TEI/KG pour les voies papier, doc du package pour la voie logicielle) et les deux vérifications obligatoires (contre la source, et cohérence interne déterministe) (Figure 3).
- *Controlled subsampling* : **non rédigée** (placeholder).
- *Semi-synthetic data construction* (rédigée le 24 septembre, source lue en détail : `extensions_projet_2026-09/revue_donnees_semi_synthetiques/` — spécification S1-S4, `SUIVI_ETAPES.md`, `synthese_encadrant_2026-09.md` §3, `POINT_SIMPLE_ENCADRANT_2026-09-15.md`). Distingue clairement deux efforts non confondus : (1) la grille canonique D0-D9 du projet (`Y = ρWY + f(X,s) + g(s) + u`, 10 familles de DGP appariées à un estimateur « maison », calibrées sur SNR/part spatiale/portée) — un protocole **non encore exécuté** ; (2) les 4 scénarios d'observation S1-S4, exécutés séparément et à échelle réelle, qui fixent un `m(X)` déjà calibré et font varier la couche d'observation (supports recouvrants, agrégation non linéaire, covariable interpolée, champs spatiaux calibrés conditionnels), ancrés sur Georgia/Meuse (S1-S4) et Banff (S4 uniquement). Chiffres d'exécution repris tels quels de `SUIVI_ETAPES.md`/`POINT_SIMPLE_ENCADRANT_2026-09-15.md` (S1 : 4 000 évaluations 0 échec ; S2 : 2 400 évaluations, identité quadratique à 1e-15 près, NMSE agrégation Georgia-forêt 0,294→0,865 ; S3 : pilote à 90 %, 3 600 ajustements sur 30 réalisations conditionnelles, réserve sur `PctEld` = proxy aréal pas une mesure de station ; S4 : pilote étendu à 90 %, tolérances de calibration atteintes, 8 000+8 000 évaluations Georgia/Meuse et 4 000+4 000 Banff, effet de portée nettement moins monotone sous conditionnement, fidélité du générateur Banff faible R²=0,16-0,25). Réserve de périmètre explicite reprise dans le texte : scripts S1-S4 hors des moteurs du package, aucune conclusion de supériorité d'estimateur, λ et grille D0-D9 complète encore ouverts — cohérent avec le périmètre de l'article (comparaison d'estimateurs hors sujet).

**Data Records, Technical Validation, Usage Notes, Code and data availability — non rédigées**, seulement le plan est fixé. Elles dépendent de décisions encore ouvertes (quels Data Records sont réellement distribués, audit des licences, revue cible).

## Ce qui est déjà réalisé

- Une petite méta-analyse de **66 articles méthodologiques** à DGP paramétrique a été codée. Elle met en regard la richesse des simulations et la diversité des applications réelles : médiane d’un jeu réel par article, au moins 117 expériences, 141 structures de DGP et 2 042 cellules paramétriques documentées ou bornées.
- La revue des infrastructures existantes couvre notamment OpenML, PMLB, AMLB, TableShift, TabZilla, TabReD, CAMELS-US, LamaH-CE et Caravan. Elle montre que des banques spatiales bien documentées existent, surtout dans des domaines cohérents comme l’hydrologie. Notre apport visé est une couche multidomaine reliant provenance, structure spatiale et temporelle, variables, formules et maturité d’usage.
- Le snapshot reproductible du 24 septembre contient **392 fiches** et **392 entrées de registre**, avec un alignement complet des identifiants. Il distingue **278 entrées `yes`**, **59 `manual_review`** et **55 `no`**.
- Les découpages temporels et spatiaux produisent plusieurs fiches à partir d’une même source. Après déduplication parent–enfant, le catalogue représente **241 familles de jeux distinctes** ; les 278 entrées `yes` correspondent à **131 familles distinctes**.
- Les 392 entrées possèdent un artifact local et un champ `formula_used`; **354 formules** ne sont plus `pending`.
- Le pipeline documentaire relie corpus bibliographique, PDF/TEI, graphe de connaissances, fiches, chargeurs RDS, registre du package et audits. Les décisions incertaines restent explicitement en revue manuelle.

## État de la rédaction

La première partie *Background & Summary* possède maintenant cinq mouvements rédigés :

1. rôle du Monte-Carlo et faible diversité empirique au niveau des articles ;
2. comparaison avec les infrastructures et banques existantes (Table 2 ajoutée le 24 septembre, chiffres verifies contre les abstracts TEI de PMLB/OpenML/AMLB/TableShift/TabZilla/TabReD) ;
3. dispersion des sources et état quantifié de notre banque (Table 1 ajoutée le 24 septembre : composition du catalogue, toutes fiches vs `package_include: yes`) ;
4. chaîne de curation assistée sous contrôle humain ;
5. contribution propre de la banque et périmètre de l’article.

La section *Methods* a maintenant trois sous-sections rédigées : la méthode de méta-analyse, **Data collection, provenance and curation** (ajoutée le 24 septembre, sourcée sur `wiki/metadata/paper_dataset_ingestion_pipeline_2026-08.md`), et **Semi-synthetic data construction** (ajoutée le 24 septembre, sourcée sur la spécification S1-S4 et `SUIVI_ETAPES.md` de `revue_donnees_semi_synthetiques/`, détail ci-dessus). Reste en placeholder : *Controlled subsampling*. Le plan des sections *Data Records*, *Technical Validation* et *Usage Notes* est établi, mais leur rédaction complète dépend encore du périmètre final des données distribuées.

Deux tableaux descriptifs sont maintenant dans le texte (Table 1 : composition du catalogue ; Table 2 : comparaison aux infrastructures existantes, chiffres verifies contre les 6 abstracts TEI concernes). Deux figures generees et inserees (`extensions_projet_2026-09/redaction_datapaper/figures/`) :
- **Figure 2** (`F2_pipeline_curation.png`) : schema du pipeline de curation (2 voies d'entree -> GROBID/TEI -> KG -> audit -> loader -> fiche -> 2 verifications obligatoires -> decision de promotion), a l'image du schema de delimitation de bassin de LamaH-CE. Script source conserve (`make_F2_pipeline.py`) pour reproductibilite.
- **Figure 1** (`F3_composition_catalogue.png`) : composition du catalogue (typologie de reponse, structure temporelle, statut d'admission), toutes fiches vs `package_include: yes`, meme style que F1 existante (matplotlib, comptage+pourcentage, note de lecture). Script source conserve (`make_F3_composition.py`), recalcule depuis le registre courant, pas de chiffres codes en dur.

Numerotation corrigee : l'ancienne F1 (distribution empirique des 66 articles) n'etait jusque-la jamais inseree dans le texte -- elle est maintenant Figure 1 (section Monte-Carlo), la composition du catalogue devient Figure 2, le schema du pipeline Figure 3 (ordre de lecture respecte).

Correction importante (signalee par l'utilisateur) : le schema du pipeline et le texte Methods ne couvraient que les 2 voies "papier" (article-first/dataset-first), en oubliant la troisieme voie -- la voie **logicielle** (jeux R/Python deja empaquetes, 111 des 392 fiches, famille `software_or_other`), qui a son propre pipeline plus leger (`create_r_software_catalog.R` -> `build_sf_datasets.R` -> `generate_fiches.py`, preuve primaire = documentation du package lui-meme, pas de GROBID/TEI/KG). Texte et Figure 3 corriges le 24 septembre pour montrer les 3 voies (+ mention d'une 4e voie pilote "warehouse", 1 seule fiche, non detaillee sur le schema pour la lisibilite).

Deuxieme correction (signalee par l'utilisateur) : la chronologie et la causalite entre les 3 voies etaient fausses dans le texte et le schema. Verifie dans `Memoire/Rapport de stage/DOLIVEIRAjohnny_internshipreportM2.tex` (lignes 270, 345-349, utilise ici comme aide d'orientation historique uniquement, conformement a `CORRESPONDANCE_RAPPORT_PLAN_V2_2026-09-16.md`) : l'ordre reel est Bloc 1 logiciel (premier, donnees deja accessibles) -> Bloc 2 dataset-first (deuxieme) -> Bloc 3 article-first (troisieme, EN COMPLEMENT du bloc 2, pas une alternative symetrique essayee en premier -- demarre parce qu'un corpus d'articles deja lus pour la meta-analyse mentionnait des jeux de donnees non trouves via le bloc 2). Texte et Figure 3 corriges le 24 septembre : boites/texte reduits, ordre Bloc 1/2/3 respecte, article-first explicitement cadre comme complement tardif.

Troisieme correction (signalee par l'utilisateur) : Figure 1 (distribution empirique des 66 articles) etait en francais -- incoherent avec un manuscrit redige en anglais -- et son affichage debordait dans le visualiseur. Recreee en anglais (`make_F1_empirical_diversity.py`, aucun script source francais retrouve, memes chiffres 14/39/11/1/1). Les 3 figures utilisent maintenant une balise `<img width=...>` plutot que la syntaxe markdown `![]()` pour fixer une largeur d'affichage explicite (600-700px), independamment de leur taille native en pixels.

Reste a faire cote figures/tableaux : envisager une figure de comparaison directe avec CAMELS/LamaH/Caravan si pertinent.

Point de vigilance découvert le 24 septembre, corrigé dans le texte : `package_include: "yes"` ne signifie pas que le jeu est physiquement embarqué dans le package (seuls 16 des 278 le sont, `storage: bundled` — les 262 autres sont `repo_only`) ; cette distinction est maintenant explicite dans le texte et renvoyée vers Usage Notes.

## Décisions à stabiliser avant une version soumissible

1. définir précisément les Data Records qui seront effectivement distribués, distinctement des fiches seulement documentaires ;
2. achever l’audit des licences et des droits de redistribution ;
3. produire automatiquement les tableaux descriptifs à partir du snapshot ;
4. vérifier sur un échantillon la fidélité KG–fiches–articles ;
5. constituer la bibliographie maître et harmoniser les clés de citation ;
6. décider quels sous-échantillons et scénarios semi-synthétiques sont assez mûrs pour entrer dans ce premier article ;
7. choisir la revue cible et adapter le manuscrit à ses exigences.

## Message central proposé

Les méthodes spatiales sont souvent évaluées sur des plans de simulation riches mais sur peu de jeux réels par article. Les ressources existantes montrent qu’une documentation spatiale rigoureuse est possible, mais elles couvrent soit des tâches tabulaires générales, soit des domaines spatiaux homogènes. La banque proposée complète ces infrastructures par une collection multidomaine qui conserve la provenance et les éléments nécessaires pour comprendre et reconstruire les usages statistiques des données.
