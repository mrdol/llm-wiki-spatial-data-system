# Résumé du brouillon du data paper (24 septembre 2026)

Ce document résume, en texte continu, le contenu actuel du brouillon `BROUILLON_DATAPAPER_V1_2026-09-21.md`. Il ne remplace pas la lecture de l'article lui-même ni la synthèse d'avancement (`ETAT_AVANCEMENT_DATAPAPER_2026-09-24.md`), qui reste la référence pour le statut section par section et les décisions en attente.

## De quoi parle l'article

Le titre de travail est *A provenance-aware, cross-domain data bank of spatial and spatio-temporal datasets for reproducible statistical research*. L'article présente une banque de données multidomaine. Ce n'est pas une simple accumulation de fichiers, mais une ressource documentée : chaque jeu de données y est relié à son article ou sa source d'origine, aux rôles analytiques de ses variables, à sa formule publiée quand elle existe, à sa structure spatiale et temporelle, à ses matrices de voisinage disponibles et à son niveau de maturité pour un usage en benchmark. La comparaison des estimateurs du package `spatialtidymodels` sur cette banque est explicitement laissée hors du périmètre de ce premier article. Celui-ci se concentre sur l'infrastructure de données elle-même.

## Ce que dit la partie Background & Summary

L'article part d'un constat obtenu par une petite méta-analyse de 66 articles méthodologiques en statistique spatiale. Ces articles testent leurs méthodes sur des plans de simulation Monte-Carlo souvent riches : au moins 117 expériences et plus de 2000 cellules de paramètres documentées dans le corpus. Mais ils utilisent très peu de jeux de données réels. La médiane est d'un seul jeu réel par article, et 21 % des articles n'en utilisent aucun. L'argument central est que la simulation répond à une question conditionnelle, comment une méthode se comporte sous un mécanisme choisi. Elle ne garantit pas qu'une conclusion se généralise à travers des domaines, des supports spatiaux ou des échelles différentes.

Le texte situe ensuite cette contribution par rapport à l'existant. Des infrastructures généralistes comme PMLB, OpenML ou AMLB standardisent l'accès à des jeux de données tabulaires. Certaines séparent explicitement le jeu de données, la tâche de benchmark et l'exécution qui en résulte. TableShift, TabZilla et TabReD montrent en particulier que le choix du schéma de validation (répartition aléatoire, décalage temporel, changement de domaine) change les conclusions. Ce choix ne doit pas être traité comme un détail technique.

À l'inverse, des banques spatiales comme CAMELS-US, LamaH-CE ou Caravan démontrent qu'une documentation spatiale rigoureuse est possible à grande échelle. Elles restent cependant organisées autour d'un seul domaine cohérent, l'hydrologie, et d'une unité spatiale partagée. Aucune de ces ressources ne combine à la fois plusieurs domaines, la conservation de la géométrie et des matrices de voisinage, une structure temporelle explicite et un lien vérifié vers la formule publiée. C'est précisément l'espace que la banque proposée cherche à occuper.

Le texte donne ensuite l'état chiffré du catalogue à la date du snapshot. Il contient 392 fiches de jeux de données, alignées avec autant d'entrées dans le registre du package. Parmi elles, 278 sont actuellement admises (`package_include: yes`), 59 restent en révision manuelle et 55 sont écartées. Certains jeux ont été découpés en plusieurs fiches dérivées, par exemple un panel découpé en coupes annuelles. Une fois ce découpage neutralisé, le catalogue représente en réalité 241 jeux distincts, dont 131 parmi les fiches admises.

Le texte prend soin de dissocier plusieurs notions qu'on pourrait confondre. Être admis dans le registre ne signifie pas avoir été utilisé dans un benchmark. Cela ne signifie pas non plus que le jeu est physiquement livré avec le package : seuls 16 des 278 jeux admis le sont réellement, les autres étant chargés depuis le dépôt versionné au moment de l'utilisation.

Une section décrit ensuite comment ce catalogue est construit et vérifié, sans validation scientifique automatique. Des modèles de langage et des scripts assistent la découverte, la transcription et les contrôles de cohérence de premier niveau. Mais aucune fiche n'est promue sur la seule base d'un chargement réussi, et toute décision d'inclusion reste sous contrôle humain. La partie se termine en précisant le périmètre exact de la contribution et l'organisation du reste de l'article.

## Ce que dit la partie Methods, et ce qui n'est pas encore écrit

Trois des quatre sous-parties prévues sont rédigées. La première détaille le protocole de la méta-analyse des 66 articles. Elle couvre comment les candidats ont été identifiés et filtrés, ce qui a été codé pour chaque article (nombre d'expériences de simulation, structures de DGP, cellules de paramètres, usage de données réelles, validation hors-échantillon), et les limites explicites de cet échantillon, qui est raisonné et diversifié plutôt que représentatif de toute la littérature.

La deuxième sous-partie décrit la collecte, la provenance et la curation des données elles-mêmes. Le texte y corrige une présentation initialement incomplète : la banque s'est construite en trois étapes successives, pas trois voies parallèles.

La première étape a exploité les jeux de données déjà distribués dans des packages R et Python, parce que ces données étaient déjà accessibles et structurées. La deuxième étape est partie directement des entrepôts de données scientifiques (Dryad, Zenodo, DataCite). Elle cherche des jeux par mots-clés, puis retrouve leur publication liée depuis les métadonnées du dépôt lui-même.

La troisième étape part cette fois d'articles déjà lus dans le cadre de la méta-analyse. Elle consiste à rechercher directement les données de publications repérées comme intéressantes, mais non retrouvées par la deuxième étape. C'est une voie complémentaire et ciblée, pas une stratégie générale. Cela reste cohérent avec une mesure indépendante montrant qu'une recherche non ciblée à partir d'articles ne retrouve un jeu de données exploitable que dans environ 4 % des cas.

Ces trois étapes convergent ensuite vers un pipeline commun : conversion en objet spatial unifié, génération d'une fiche standardisée, puis deux vérifications obligatoires avant toute promotion. La première est une relecture de la source primaire (l'article ou la documentation du package), pour s'assurer que chaque variable de la formule est une vraie covariable et non un poids ou un critère d'exclusion. La seconde est un contrôle de cohérence interne entièrement automatique et déterministe. Ce contrôle ne remplace pas la relecture, mais détecte d'autres types d'erreurs.

Une troisième sous-partie, sur la construction de données semi-synthétiques, est maintenant rédigée. Le texte distingue deux efforts que l'on pourrait facilement confondre.

D'un côté, la grille canonique D0-D9 proposée pour le projet fait varier le mécanisme spatial moyen et de dépendance (tendance, autocorrélation, coefficients spatialement variables), pour tester la spécification de chaque estimateur. C'est un protocole encore entièrement à exécuter.

De l'autre, un chantier séparé et déjà exécuté rassemble quatre scénarios d'observation (S1 à S4). Il fixe au contraire une fonction moyenne déjà calibrée sur des covariables réelles, et fait varier la façon dont la réponse est mesurée, agrégée ou interpolée avant d'atteindre un estimateur. Ces quatre scénarios sont ancrés sur des sites et covariables réels de trois jeux de la banque : Georgia, Meuse, et Banff pour le quatrième.

Le texte rapporte leur échelle d'exécution réelle et leurs résultats centraux. Par exemple, une erreur d'agrégation qui dépend fortement du générateur et du jeu de données, ou un effet de portée spatiale qui devient nettement moins systématique une fois le champ conditionné sur des sites réels retenus.

Il pose aussi une réserve de périmètre explicite. Ces scripts restent des pilotes tenus à l'écart des moteurs du package. Aucun résultat ne démontre la supériorité générale d'un estimateur, et la grille D0-D9 complète reste un chantier ouvert. Cela reste cohérent avec le choix, annoncé dès le début de l'article, de laisser la comparaison des estimateurs hors du périmètre de ce premier article.

La sous-partie restante, sur le sous-échantillonnage contrôlé, n'est pas encore rédigée : elle dépend de la stabilisation des liens entre jeux parents et jeux dérivés distribués.

## Ce qui reste entièrement à écrire

Quatre dernières parties sont attendues d'un article de ce type : Data Records, Technical Validation, Usage Notes, et Code and data availability. Elles n'ont pour l'instant qu'un plan, aucun texte. Leur rédaction dépend de décisions qui ne sont pas encore prises : quels enregistrements seront effectivement distribués plutôt que seulement documentés, l'état des droits de redistribution par licence, et le choix de la revue cible qui conditionnera le format final.

## Figures et tableaux déjà produits

Trois figures accompagnent déjà le texte, toutes générées par script à partir de données vérifiées plutôt qu'insérées à la main : la diversité empirique des 66 articles de la méta-analyse, la composition du catalogue de 392 fiches, et un schéma du pipeline de collecte et curation en trois étapes. Deux tableaux complètent le texte : l'un détaille la composition du catalogue, l'autre compare point par point la présente banque aux infrastructures existantes citées plus haut.
