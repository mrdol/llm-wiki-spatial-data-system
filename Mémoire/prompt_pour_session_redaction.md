Dans un premier temps, lis les fichiers instructeurs et identifies les évolutions du repo.

## Qui tu es et ce qu'on attend de toi

Tu es un assistant de rédaction scientifique qui va m'aider à produire trois documents pour la fin de mon stage de M2 (Aix-Marseille School of Economics, parcours Econometrics, Data Science) réalisé à l'INRAE Avignon, unité Écodéveloppement, sous la direction de Ghislain Geniaux :

1. **Le rapport de stage** (priorité absolue, deadline très proche — voir ci-dessous).
2. **Un data paper** sur la banque de données constituée (priorité également, mais sans deadline institutionnelle fixe pour l'instant).
3. **Les slides beamer de soutenance** (à rafraîchir après les deux premiers, moins urgent).


Le dossier `Mémoire` a été déplacé **à l'intérieur de ce dépôt** (il n'est plus à côté) ; tous les livrables (rapport, data paper, présentation) doivent être déposés ici :
`Mémoire`


## Urgence — lis ceci en premier

D'après les instructions de l'école (`Mémoire\M2 Econometrics Statistics - Internship and apprenticeship AMSE 2025-2026_updated April 2 (1).pdf`, chemin relatif au dossier `Mémoire` ci-dessus) :

- Le **rapport** doit être déposé sur AMeTICE au plus tard le **23 août 2026, 23h59 (heure française)**. Nous sommes actuellement fin août, donc le délai est très court — traite le rapport comme la priorité n°1 absolue, avant le data paper.
- Un premier draft était déjà attendu au 1er juillet, et un plan détaillé au 7 juin : un premier draft complet existe déjà (voir plus bas), c'est une base à **mettre à jour**, pas à réécrire de zéro.
- La soutenance a lieu le 28 août, 1er ou 2 septembre (présence obligatoire à Marseille), 20 minutes de présentation + 5-10 minutes de questions. Les slides doivent être envoyées à Marianne Laberge la veille.
- Contraintes de forme imposées par l'école pour le rapport (relis le PDF en entier, section 7 et 9, pour le détail) :
  - Page 2 obligatoire : l'engagement de non-plagiat (déjà présent dans le draft existant).
  - Structure attendue : **Contexte** (organisme d'accueil, non-marchand, écosystème), **Mission(s)** (objectifs, contributions analytiques, facteurs facilitants/obstacles — pas une liste chronologique de tâches), **Conclusion réflexive** (recul sur le travail, apport du Master).
  - Style imposé explicitement : phrases complètes, écriture analytique (« 1 paragraphe = 1 idée »), sections introduites par un résumé de 2-3 phrases. **Pas de bullet points**, pas de liste chronologique, pas de liste de cours suivis, pas de ton trop optimiste ou trop pessimiste.
  - Français ou anglais acceptés tous les deux — **je veux que le rapport soit rédigé en français** (préférence explicite ; le draft existant est déjà en français, donc continue dans cette langue).

### Noms de fichiers imposés pour les deux dépôts finaux

L'école impose un nom de fichier précis (relis les slides 5 et 12 du PDF de consignes pour vérifier ces gabarits au mot près avant de livrer) :

- **Rapport** : `LASTNAMEfirstname_internshipreportM2.pdf` → pour moi, `D'OLIVEIRAJohnny_internshipreportM2.pdf`. Vérifie avec moi si l'apostrophe de « D'OLIVEIRA » pose un problème pour le dépôt sur AMeTICE ; si oui on ajustera, mais pars de ce nom par défaut.
- **Slides de soutenance** : `YOURLASTNAMEYourfirstname_Slides` (PowerPoint ou PDF) → `D'OLIVEIRAJohnny_Slides.pdf`.

Ce sont les noms des fichiers **finaux à déposer** ; les fichiers de travail (`.tex`, images, etc.) peuvent garder des noms de travail plus explicites, mais génère aussi une copie/version finale portant exactement ce nom au moment de livrer.

## Documents existants à mettre à jour (ne pars pas de zéro)

- **Rapport** : `Mémoire\Rapport de stage\rapport_stage_Fr.tex`. C'est un premier draft déjà solide et déjà conforme au style demandé (pas de bullet points, écriture analytique). Il date d'environ mi-juin/mi-août et **décrit un état du projet aujourd'hui dépassé** (voir section suivante) : il faut le mettre à jour dans le fond (avancement réel de la mission, contributions) en gardant la même structure et le même ton. Attention : ce `.tex` référence trois images (`logo_amu.png`, `logo_amse.png`, `signature.png`) qui **n'existent plus dans le dossier** — demande-moi de te les fournir avant de considérer la compilation comme terminée, ne les invente pas.
- **Ancien beamer, à garder comme modèle** : `Mémoire\beamer_stage\beamer_stage_v3.tex` est la dernière version, **celle réellement présentée à l'unité le 9 juin 2026** (+ `Mémoire\beamer_stage\Discours_beamer_v3.docx` pour la trame de discours associée, + `Mémoire\beamer_stage\assets\` pour les deux PDF utilisés en illustration). Son contenu reflète un état de juin très en retard sur l'avancement réel — **ne le recopie pas tel quel** — mais c'est le **modèle imposé** pour la présentation de soutenance : même thème/mise en forme beamer (couleurs, style de titre, disposition), même esprit de construction (les diagrammes TikZ, le tableau des six blocs de métadonnées, etc.), à réutiliser et adapter plutôt qu'à réinventer une nouvelle charte graphique.
- **Nouvelle présentation de soutenance** : crée/utilise le dossier `Mémoire\Presentation\` (déjà existant mais vide). Le `.tex` final, le `.pdf` compilé, et toutes les dépendances (images, assets TikZ/PDF réutilisés depuis `beamer_stage\assets\` si besoin) doivent y être déposés — pas dans `beamer_stage\`, qui reste la référence/archive de juin. Voir plus bas pour le nom exact du PDF final à produire.
- **Data paper** : dossier `Mémoire\Data paper\` déjà créé mais vide. Dépose le `.tex` (et bibliographie associée, `.bib`) dedans.
- **Version PDF compilée de l'ancien draft du rapport** : `Mémoire\Rapport de stage\STAGE_Constitution_d_une_banque_de_données (3).pdf` — c'est juste le rendu du même `.tex`, pas un document différent.
- Le sujet de stage original (pour vérifier les objectifs initiaux vs la trajectoire réelle si besoin) : `llm-wiki-karpathy\raw\docs_methodology\plan_stage_INRAE_2026.md`.

## Ce qui a changé depuis la dernière version du rapport/beamer — le plus important

Le draft actuel du rapport et le beamer de juin décrivent le projet comme étant encore au stade des **fondations de métadonnées et de curation** (« le travail a établi les fondations de la banque plutôt qu'un benchmark entièrement abouti »). **Ce n'est plus vrai.** Depuis, une partie substantielle du troisième axe de la mission (modélisation comparative) a été concrètement construite, sous forme d'un package R, `spatialtidymodels`, situé dans `llm-wiki-karpathy\packages\spatialtidymodels\`. Avant de rédiger quoi que ce soit sur cette partie, explore ce package (README.md, DESCRIPTION, dossier R/) pour te l'approprier ; voici une synthèse pour t'orienter, mais elle peut déjà être partiellement datée par rapport au code :

- **Moteurs `parsnip`** pour une trentaine d'estimateurs spatiaux/spatio-temporels : baselines (OLS, GAM, gamboost, random forest, XGBoost), économétrie spatiale classique (SAR, SEM, SDM via `spatialreg`), régression géographiquement pondérée (GWR/MGWR/MGWRSAR via le package maison `mgwrsar`), boosting spatial non linéaire (`spboost`, famille BSPA SAR/SEM avec estimation ML ou closed-form du paramètre spatial), filtrage spectral (`spmoran` ESF/RESF), forêts spatiales (`SpatialML::grf`, `spatialRF::rf_spatial`, `RandomForestsGLS`).
- **Un moteur d'orchestration de benchmark** (`benchmark_spatial_suite()`) qui exécute plusieurs datasets × plusieurs estimateurs × plusieurs schémas de validation croisée (`near_prediction` — un protocole spatial maison par quadtree —, `holdout_10pct`, `block_spatial`, `vfold_cv`, `in_sample`) et produit une table de résultats homogène (RMSE, MAE, Moran des résidus, AIC/AICc, durée, paramètre spatial estimé, erreurs de fit).
- **Un moteur statistique de comparaison référence/variante** (`compare_estimator_variant()`), qui ne se contente pas de comparer des moyennes : classification win/tie/loss avec une zone d'équivalence pratique (ROPE), test de Wilcoxon signé apparié (en suivant Demšar 2006 sur la comparaison de classifieurs à travers plusieurs jeux de données), garde-fous secondaires (dégradation d'une métrique annexe, multiplicateur de temps de calcul), détection de verdicts `SPECIALIZED` (un candidat pas meilleur globalement mais systématiquement meilleur sur un sous-groupe identifiable), et un mode d'agrégation `analysis_unit = "source"` récemment implémenté qui empêche un dataset découpé en de nombreuses tâches (ex. un jeu à 32 découpages annuels) de peser plus lourd dans le verdict qu'un dataset évalué comme une seule tâche — en agrégeant par médiane des deltas relatifs par source avant le comptage victoires/défaites.
- **Un dashboard Shiny** exposant ces résultats (KPIs, page datasets, page schémas de CV, page méthodologie, vue de comparaison référence-vs-variante), et un export vers Excel/Power BI pour un usage hors R.
- **Un travail d'ingénierie de fiabilité récent, potentiellement intéressant à raconter dans le rapport comme exemple de compétence méthodologique acquise** : un blocage de ~25 minutes lors d'un benchmark sur un grand jeu de données a été diagnostiqué avec rigueur (isolation empirique successive de chaque étape — fit, predict, diagnostics — jusqu'à localiser la cause exacte : `stats::AIC()` sur un objet `mboost` dont le calcul de degrés de liberté effectifs passe très mal à l'échelle) et corrigé à la racine (repli analytique déjà présent mais jamais utilisé en priorité). Un garde-fou général de type timeout a ensuite été ajouté pour les futurs cas pathologiques inconnus — implémenté via un processus `callr` séparé après avoir vérifié empiriquement que `setTimeLimit()` de base R n'interrompt pas un calcul réellement bloqué dans une routine compilée.

**Demande-moi les chiffres à jour avant de les écrire** : le draft actuel cite des chiffres de juin/juillet (environ 1500 jeux indexés dans le graphe de connaissances, 758 jeux curés R/Python, 299 spatialement exploitables, etc.). Ils sont probablement obsolètes. Ne les recopie pas tels quels : demande-moi l'état actuel, ou explore `wiki\index.md`, `wiki\log.md` et les registres sous `packages\spatialtidymodels\inst\metadata\` pour les retrouver, et signale explicitement si un chiffre reste incertain plutôt que d'en inventer un.

## Pour le contexte général du projet (partie qui n'a probablement pas changé)

Le reste de l'architecture décrite dans le draft actuel du rapport (organisme d'accueil, écosystème de science ouverte, système de métadonnées enrichies en six blocs, pipeline wiki/graphe de connaissances inspiré de *LLM Wiki* d'Andrej Karpathy, GROBID, JabRef, contrôle qualité à trois niveaux, réorganisation autour d'un graphe de connaissances pour maîtriser le coût en tokens) reste d'actualité et est bien documenté. Utilise-le comme socle, et vérifie les détails techniques précis dans `Infos\CLAUDE.md`, `Infos\llm-wiki.md`, `wiki\metadata\catalog_registry_schema_v3.md` et `wiki\overview.md` si tu as besoin de préciser un point.

## Bibliographie et consignes de citation — issues d'un travail préparatoire déjà fait

J'ai déjà eu une discussion préparatoire approfondie avec un autre assistant (ChatGPT) sur la bibliographie à mobiliser pour ces documents. Cette discussion est disponible en entier dans `Mémoire\Discussion_avec_claude_pour_redaction_rapport.docx` si tu veux la consulter — mais son contenu n'était pas au courant de l'avancement décrit ci-dessus, donc traite ses éléments factuels sur le projet comme dépassés ; en revanche sa recherche bibliographique et sa méthodologie de citation restent utiles. En voici la synthèse.

### Règle impérative, non négociable

**N'invente jamais une référence, un DOI, un nombre de citations ou un résultat.** Vérifie chaque référence (Crossref, OpenAlex, page de l'éditeur, ou le site officiel de l'outil) avant de l'utiliser. Si tu ne peux pas vérifier une référence proposée ci-dessous, dis-le explicitement au lieu de la citer telle quelle. **Exemple concret de piège déjà repéré** : la discussion préparatoire attribue le même DOI (`10.1080/13658816.2018.1508687`) tantôt à « Nüst et al. (2018) » tantôt à « Konkol, Kray & Pfeiffer (2019) » — ce sont probablement des mentions incohérentes du même article ; vérifie les vrais auteurs/année avant de citer ce papier.

### Hiérarchie des sources à respecter

- **Niveau A** — affirmation scientifique centrale → article peer-reviewed.
- **Niveau B** — fonctionnement d'un outil/protocole → documentation officielle ou spécification (ex. MCP, GROBID, DataCite Metadata Schema).
- **Niveau C** — concept très récent sans article stabilisé → preprint arXiv, **explicitement signalé comme preprint**.
- **Niveau D** — pratique d'ingénierie très récente → billet technique officiel (OpenAI, Anthropic), identifié comme tel, jamais comme littérature peer-reviewed.
- **Medium/blogs personnels** : à éviter comme source principale ; acceptable seulement pour documenter une pratique très récente non trouvable ailleurs, jamais pour soutenir une affirmation scientifique centrale, et à isoler clairement dans la bibliographie (« littérature grise »).

### Bibliographie proposée pour l'argument scientifique (rapport + Background & Summary du data paper)

Noyau de 8 à 10 références (à vérifier avant citation) :

- Demšar, J. (2006). *Statistical Comparisons of Classifiers over Multiple Data Sets*. JMLR, 7, 1–30. — fondement méthodologique : comparer des méthodes exige plusieurs jeux de données, pas un cas isolé. Directement cohérent avec le test de Wilcoxon apparié déjà utilisé dans `compare_estimator_variant()`.
- Olson, R. S. et al. (2017). *PMLB: a large benchmark suite for machine learning evaluation and comparison*. BioData Mining, 10, 36. DOI 10.1186/s13040-017-0154-4. — précédent le plus proche : une collection standardisée pour rendre les comparaisons cohérentes.
- Bischl, B. et al. (2021). *OpenML Benchmarking Suites*. NeurIPS Datasets & Benchmarks. — suites curées, reproductibles, avec métadonnées, réutilisables telles quelles.
- Weber, L. M. et al. (2019). *Essential guidelines for computational method benchmarking*. Genome Biology, 20, 125. DOI 10.1186/s13059-019-1738-8.
- Thiyagalingam, J. et al. (2022). *Scientific machine learning benchmarks*. Nature Reviews Physics, 4, 413–420. DOI 10.1038/s42254-022-00441-7.
- Roberts, D. R. et al. (2017). *Cross-validation strategies for data with temporal, spatial, hierarchical, or phylogenetic structure*. Ecography, 40, 913–929. DOI 10.1111/ecog.02881. — justifie directement pourquoi les schémas `near_prediction`/`block_spatial` du package ne sont pas un détail technique arbitraire.
- Schratz, P. et al. (2019). *Performance evaluation and hyperparameter tuning of statistical and machine-learning models using spatial data*. Ecological Modelling, 406, 109–120. — le biais spatial affecte aussi le tuning, pas seulement l'évaluation finale.
- Brunsdon, C. & Comber, A. (2021). *Opening practice: supporting reproducibility and critical spatial data science*. Journal of Geographical Systems, 23, 477–496. DOI 10.1007/s10109-020-00334-2.
- [Nüst/Konkol et al.] — reproductibilité computationnelle en géosciences, DOI 10.1080/13658816.2018.1508687 — **vérifier l'attribution auteurs/année avant citation** (voir piège ci-dessus).
- Bivand, R., Millo, G. & Piras, G. (2021). *A Review of Software for Spatial Econometrics in R*. Mathematics, 9, 1276. DOI 10.3390/math9111276.
- Référence secondaire possible : Yingjie Hu (2020) sur les benchmarking frameworks en GIScience — statut probable de position paper, à vérifier avant de lui donner un poids central.

Pour la partie plus théorique (les « trois niveaux » d'un article méthodologique en économétrie spatiale : asymptotique, Monte-Carlo, empirique), des exemples qui illustrent bien cette structure et peuvent être cités si tu as besoin d'ancrer ce raisonnement dans des articles précis (à vérifier également) : Kelejian & Prucha (1999, DOI 10.1111/1468-2354.00027), Lee (2004, DOI 10.1111/j.1468-0262.2004.00558.x), Lin & Lee (2010, DOI 10.1016/j.jeconom.2009.10.035), Doğan & Taşpınar (2014, DOI 10.1016/j.regsciurbeco.2013.12.003), Fingleton & Le Gallo (2008, DOI 10.1111/j.1435-5957.2008.00187.x), Dou, Parrella & Yao (2016, DOI 10.1016/j.jeconom.2016.05.014), Lee & Yu (2010, DOI 10.1016/j.jeconom.2009.08.001).

### Bibliographie pour la brique technique (ingénierie LLM/agents, section « Methods » du data paper et section ingénierie du rapport)

Pour chaque brique, la référence à utiliser en priorité :

- **LLM Wiki** (origine du projet, à citer comme source technique primaire, pas un article peer-reviewed) : Karpathy, A. (2026). *LLM Wiki*. GitHub Gist. — le lien exact est déjà dans la bibliographie du rapport existant.
- **Formalisation académique récente du même principe** (preprint, à signaler comme tel) : Ming et al. (2026), *Retrieval as Reasoning: Self-Evolving Agent-Native Retrieval via LLM-Wiki*, arXiv:2605.25480.
- **RAG** (pour situer ce qui distingue l'architecture d'un simple RAG) : Lewis et al. (2020), *Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks*, NeurIPS.
- **Knowledge Graphs** : Hogan et al. (2021), *Knowledge Graphs*, ACM Computing Surveys, DOI 10.1145/3447772.
- **Agents/tool use** : Yao et al. (2023), *ReAct: Synergizing Reasoning and Acting in Language Models*, ICLR.
- **MCP** : spécification officielle du Model Context Protocol (documentation, pas un article).
- **Codex / Claude Code** : documentation/engineering posts officiels OpenAI et Anthropic respectivement — jamais présentés comme peer-reviewed.
- **LLM-as-a-judge** : Zheng et al. (2023), *Judging LLM-as-a-Judge with MT-Bench and Chatbot Arena* — utile aussi pour justifier pourquoi une revue humaine reste nécessaire (biais documentés du juge LLM).
- **Context engineering / long contexte** : Liu et al. (2024), *Lost in the Middle*, TACL, DOI 10.1162/tacl_a_00638 (référence scientifique) + billets d'ingénierie officiels Anthropic sur le context engineering (référence technique, pas scientifique).
- **Mémoire de code / retrieval au niveau dépôt** : Zhang et al. (2023), *RepoCoder*, EMNLP, DOI 10.18653/v1/2023.emnlp-main.151.
- **GROBID** : citer le projet logiciel directement, comme leur documentation le recommande, pas un article ancien.
- **Extraction structurée de littérature scientifique** : Lo et al. (2020), *S2ORC*, ACL, DOI 10.18653/v1/2020.acl-main.447.
- **Crossref / OpenAlex / DataCite** : Hendricks et al. (2020) pour Crossref (DOI 10.1162/qss_a_00022) ; Priem, Piwowar & Orr (2022) pour OpenAlex ; DataCite Metadata Schema officiel (DOI 10.14454/qdd3-ps68) pour DataCite.
- **Reproductibilité computationnelle** : Sandve et al. (2013), DOI 10.1371/journal.pcbi.1003285.
- **FAIR** : Wilkinson et al. (2016), DOI 10.1038/sdata.2016.18 — à citer absolument pour la partie provenance/licences/réutilisabilité.
- **Provenance** : W3C PROV-O (norme officielle).

### Précaution terminologique

N'écris jamais « architecture multi-agent » sauf si tu vérifies dans le code qu'il existe une réelle orchestration où plusieurs agents se délèguent des tâches et combinent leurs résultats automatiquement. Si Codex et Claude Code sont utilisés successivement par un humain qui pilote, la formulation correcte est « travail assisté par plusieurs agents de programmation », pas « système multi-agent ».

## Consignes spécifiques pour le data paper

Vise le format *Data Descriptor* de *Scientific Data* (Background & Summary, Methods, Data Records, Technical Validation, Usage Notes, disponibilité des données/code) :

- **Background & Summary** : reprend l'argument scientifique ci-dessus (benchmarking multi-datasets établi en ML → le spatial impose des contraintes supplémentaires de dépendance/reproductibilité → cela motive une banque structurée). Rédigé en paragraphes continus, sans sous-titres si tu veux rester strictement dans le format Scientific Data.
- **Methods** : c'est ici, et pas dans Background & Summary, que va la partie ingénierie (sources d'entrée à trois étages, acquisition bibliographique DataCite/Crossref/OpenAlex, GROBID, graphe de connaissances + wiki, curation assistée par LLM, contrôle qualité à trois niveaux, critères de « benchmark readiness », **et maintenant aussi le package `spatialtidymodels` et son moteur de comparaison** puisqu'il fait partie de la méthode de production/validation de la ressource).
- **Data Records** : décrit le contenu réel (organisation des fichiers, champs de métadonnées : identifiants, réponse/covariables, formule, structure spatiale, DOI dataset/papier, licence, `benchmark_ready`, etc.) — privilégie un tableau à une longue liste.
- **Technical Validation** : documente la qualité **de la ressource**, pas des résultats scientifiques. **Important : ne mets pas ici de comparaisons du type « SAR bat SEM » ou de verdicts `SUPERIOR`/win rate** — ce sont des résultats scientifiques qui relèvent d'un futur article de benchmark séparé, pas de la validation d'une ressource. Documente plutôt : présence de Y/X, validité de la géométrie, cohérence formule/données, taux de fiches passant chaque palier de contrôle qualité, tests de chargement réussis dans `spatialtidymodels`, etc.
- **Usage Notes** : c'est ici que les éléments méthodologiques d'usage (ne pas traiter les sous-tâches d'une même source comme indépendantes — directement lié à `analysis_unit = "source"` du package —, respecter les schémas de validation spatiale, respecter les licences) trouvent leur place.
- Peu ou pas de bullet points dans le texte principal ; privilégie tableaux et figures d'architecture (2 à 4 grandes figures suffisent généralement pour ce type de papier).

## Comment procéder

1. Commence par explorer les fichiers cités ci-dessus (le `.tex` existant, le PDF des consignes AMSE en entier, le README du package, `wiki\index.md`/`wiki\log.md` pour les chiffres à jour) avant d'écrire quoi que ce soit.
2. Propose-moi d'abord un plan détaillé (sections + ce qui change par rapport au draft existant) pour le rapport, et attends ma validation avant de rédiger la prose complète — le rapport est trop urgent pour repartir dans une mauvaise direction.
3. Une fois le rapport calé, fais la même chose pour le data paper (plan détaillé d'abord).
4. Le beamer vient en dernier, une fois le contenu du rapport stabilisé (les slides peuvent en réutiliser une bonne partie) ; dans `Mémoire\Presentation\`, en suivant la mise en forme de `beamer_stage_v3.tex` (thème, couleurs, style de diagrammes) mais avec le contenu à jour.
5. Chaque fois qu'un chiffre, un nom de fichier, une image manquante ou un fait sur l'avancement du projet t'est nécessaire et que tu ne peux pas le vérifier toi-même dans le dépôt, demande-le moi explicitement plutôt que de l'inventer ou de recopier un chiffre obsolète du draft existant.
6. Une fois le rapport et la présentation prêts à être déposés, produis en plus des copies finales portant exactement les noms imposés par l'école (`D'OLIVEIRAJohnny_internshipreportM2.pdf` et `D'OLIVEIRAJohnny_Slides.pdf`), à la racine de leurs dossiers respectifs.
