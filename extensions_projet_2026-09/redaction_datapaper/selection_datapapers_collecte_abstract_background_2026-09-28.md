# Data papers centrés sur la constitution d'une banque

## Objet de cette note

Cette sélection distingue les articles qui expliquent comment des sources hétérogènes sont repérées, sélectionnées, transformées, contrôlées et publiées de ceux dont la contribution principale est un benchmark d'algorithmes. Les résumés ci-dessous sont des reformulations françaises des abstracts et des méthodes lus dans les TEI. Ils ne reproduisent pas les abstracts originaux.

L'introduction du rapport de stage est utilisée ici comme aide pour retrouver la logique scientifique du projet. Elle ne constitue pas la source du futur article. Les affirmations du manuscrit devront être soutenues par la littérature, la méta-analyse et les artefacts vérifiés du dépôt.

## Les cinq modèles principaux

### 1. LAGOS-NE — modèle spatial le plus proche

**Pourquoi le retenir.** L'article présente la construction d'une grande banque géospatiale et temporelle à partir de 87 sources fédérales, étatiques, universitaires et associatives. Il explique pourquoi une question scientifique à grande échelle exige d'intégrer les observations, leur contexte écologique, les unités spatiales et le temps.

**Résumé reformulé.** Les mesures de qualité de l'eau sont dispersées dans l'espace, dans le temps et entre de nombreux producteurs. LAGOS-NE les relie à des informations de localisation, de caractéristiques physiques et de contexte écologique pour 51 101 lacs de 17 États américains. La ressource permet ainsi des analyses à des échelles qui ne seraient pas accessibles avec une source isolée.

**Ce qu'il apporte à notre rédaction.** Le résumé part d'un besoin scientifique, explique pourquoi les données existantes ne suffisent pas séparément, annonce la méthode d'intégration, quantifie clairement le produit final, puis expose les nouveaux usages. C'est le meilleur modèle pour expliquer pourquoi coordonnées, géométries, unités spatiales, temps et provenance doivent être conservés.

### 2. Microbiome Learning Repo — parallèle méthodologique le plus direct

**Pourquoi le retenir.** Les auteurs partent d'articles et de données publiques hétérogènes, appliquent une chaîne commune, curent les métadonnées, puis dérivent plusieurs tâches de classification ou de régression. Ils distinguent la source initiale de la tâche finalement utilisable.

**Résumé reformulé.** Les spécialistes des méthodes d'apprentissage disposent de nombreux jeux de microbiome, mais leur hétérogénéité et le besoin d'expertise thématique compliquent leur utilisation. ML Repo transforme 15 études publiées en 33 tâches documentées de classification et de régression, accessibles dans une ressource publique, puis illustre les analyses rendues possibles.

**Ce qu'il apporte à notre rédaction.** Il fournit un précédent clair pour la chaîne « article → données sources → curation → tâche réutilisable ». Il aide aussi à expliquer pourquoi une banque utile ne se réduit pas à juxtaposer des fichiers.

### 3. Compound Matrix-Based Project Database (CMPD) — modèle de consolidation

**Pourquoi le retenir.** La contribution centrale est la consolidation de bibliothèques très hétérogènes au moyen de parseurs et d'un modèle commun, avec une distinction explicite entre instances originales et instances générées.

**Résumé reformulé.** Les bases utilisées pour étudier l'ordonnancement de projets diffèrent fortement par leur structure de fichiers et par les caractéristiques décrites. CMPD rassemble les collections fréquemment utilisées et les convertit vers une représentation matricielle commune, extensible à de nouvelles caractéristiques et à de nouvelles formes de projets.

**Ce qu'il apporte à notre rédaction.** Il montre comment présenter un problème d'hétérogénéité, une représentation commune, les convertisseurs et les contrôles. Sa distinction entre données originales et données générées est directement utile pour séparer données empiriques et extensions semi-synthétiques.

### 4. Pyrfume — modèle d'alignement sémantique

**Pourquoi le retenir.** Pyrfume ne se contente pas de stocker des jeux : il aligne les identifiants de stimuli, les modalités, les espèces et les mesures afin de permettre des analyses transversales.

**Résumé reformulé.** La recherche sur l'olfaction est freinée par la rareté apparente de grandes ressources reliées, alors que de nombreux jeux existent séparément. Pyrfume réunit des dizaines de sources couvrant plusieurs espèces et modalités dans un cadre commun et montre comment cette intégration permet de nouvelles analyses, des usages pédagogiques et la construction de benchmarks.

**Ce qu'il apporte à notre rédaction.** L'article aide à formuler la valeur scientifique de l'harmonisation : rendre comparables et interrogeables ensemble des données qui existaient déjà, mais dont les identifiants et les schémas empêchaient l'exploitation conjointe.

### 5. Construction Motion Data Library — modèle de collecte mixte

**Pourquoi le retenir.** La banque combine des ressources publiques et une collecte expérimentale propre, puis harmonise les articulations, les fréquences, les unités, les coordonnées et les étiquettes. Elle distingue aussi le corpus analysé du sous-ensemble redistribuable.

**Résumé reformulé.** Les jeux génériques de mouvements humains décrivent mal les gestes et contraintes propres aux chantiers. Les auteurs produisent donc une petite collecte en laboratoire, l'utilisent pour annoter et organiser une bibliothèque plus large, puis vérifient la qualité et l'utilisabilité de la ressource avec plusieurs modèles. Le résumé quantifie séparément la collection complète et son noyau fortement lié à la construction.

**Ce qu'il apporte à notre rédaction.** Il fournit un bon exemple pour expliquer une collecte composite, les transformations nécessaires et la différence entre inventaire étudié, données légalement redistribuables et noyau directement utilisable.

## Modèles complémentaires

- **MedMNIST v2** : le meilleur modèle pour la forme d'un résumé de *Scientific Data*. Il enchaîne objet, composition, standardisation, amplitude, usages, validation légère et accès. Le benchmark sert de validation de la ressource et ne domine pas le récit.
- **PMLB** : utile pour le format commun, les métadonnées validables, les interfaces logicielles et la procédure de contribution. Son objectif reste toutefois fortement lié à l'évaluation comparative.
- **Monash Forecasting Archive** : utile pour décrire une archive multi-domaines sans perdre fréquence, chronologie, longueur et valeurs manquantes. La partie benchmark est plus développée.
- **GriddingMachine** : pertinent pour la standardisation de projections, coordonnées, unités, résolutions et emprises des couches spatiales. Il s'agit d'un article hybride banque-logiciel.
- **Common Fund Data Ecosystem** : utile pour distinguer un catalogue fédéré des fichiers effectivement harmonisés et distribués. Il porte surtout sur les métadonnées et la découvrabilité.
- **Meta-Album** : intéressant pour les critères d'inclusion, les licences, les contrôles, les versions de taille différente et l'ajout futur de jeux. Il reste lié à un programme de benchmark few-shot.

## Articles à ne pas prendre comme modèles principaux de résumé

OpenML Suites, OpenML-CTR23, TableShift, TabZilla, TabReD, Open Graph Benchmark, TUDataset, le benchmark de pression artérielle et SRBench apportent des idées utiles sur les tâches, les partitions et la validation. Leur récit est toutefois dominé par la comparaison de méthodes. Ils ne correspondent pas au premier article désormais centré sur la constitution et la mise à disposition de la banque.

## Ordre de lecture recommandé

1. Résumés puis `Background & Summary` de LAGOS-NE et Microbiome Learning Repo.
2. Résumés et `Methods` de CMPD et Construction Motion Data Library.
3. Résumé et structure éditoriale de MedMNIST v2.
4. Pyrfume pour la justification scientifique de l'intégration.
5. PMLB, Monash, GriddingMachine et CFDE pour les aspects interface, temps, spatial et catalogue.

## Trame proposée pour notre Abstract

1. **Problème scientifique** : l'évaluation empirique des méthodes spatiales repose sur des jeux réels dispersés, hétérogènes et inégalement documentés.
2. **Limite de la simulation** : les expériences de Monte-Carlo sont indispensables lorsque le mécanisme générateur doit être connu, mais leurs conclusions restent conditionnées par les structures et mauvaises spécifications effectivement simulées.
3. **Besoin complémentaire** : les applications empiriques exposent les méthodes à des structures conjointes non entièrement choisies par l'expérimentateur, mais les sources existantes ne forment pas encore une ressource directement comparable.
4. **Contribution** : annoncer une banque de jeux spatiaux construite par repérage d'articles, packages et entrepôts, vérification dans les sources, harmonisation et documentation de la réponse, des prédicteurs, des coordonnées ou géométries, du temps, du CRS et de la provenance.
5. **Produit publié** : ne donner que l'effectif du noyau réellement publiable et distribuable au moment du gel final, avec ses types de données et ses artefacts.
6. **Utilité** : permettre la réutilisation, l'étude méthodologique et, ultérieurement, des comparaisons reproductibles sans faire du benchmark logiciel la contribution centrale du premier article.

## Trame proposée pour Background & Summary

### Mouvement 1 — Deux sources de preuve complémentaires

Présenter la simulation et les applications empiriques comme complémentaires. La simulation autorise l'étude du biais, de la variabilité ou de la couverture parce que le mécanisme générateur est connu. Elle ne peut toutefois représenter toutes les combinaisons de non-linéarité, hétérogénéité spatiale, corrélation des covariables, interactions, variables omises ou erreurs de mesure. Conformément à la remarque de l'encadrant, la taille d'échantillon, le niveau de bruit et, en économétrie spatiale, le niveau de dépendance et la matrice de voisinage ne doivent pas automatiquement être présentés comme des tests riches de mauvaise spécification : ils constituent souvent les dimensions minimales du plan expérimental.

### Mouvement 2 — Ce que les données réelles ajoutent

Les cas empiriques confrontent les méthodes à des structures conjointes que le chercheur n'a pas entièrement imposées. Ils ne permettent pas d'observer directement le biais puisque le vrai mécanisme reste inconnu. La banque élargit donc l'évaluation empirique; elle ne remplace pas le Monte-Carlo.

### Mouvement 3 — Le verrou documentaire

Expliquer que les données existent, mais sont dispersées entre articles, suppléments, packages et entrepôts. Une réponse, des prédicteurs, des coordonnées ou une géométrie, une dimension temporelle, un CRS et parfois une relation de voisinage doivent être retrouvés et vérifiés. Ne jamais attribuer aux auteurs une matrice `W` reconstruite par le projet.

### Mouvement 4 — Ce que montrent les banques existantes

Mobiliser LAGOS-NE pour l'intégration spatiale multi-source, ML Repo pour la dérivation de tâches depuis des articles, CMPD pour les parseurs et la représentation commune, Pyrfume pour l'alignement sémantique, et MedMNIST pour la présentation éditoriale. Reconnaître leurs apports avant d'identifier le manque précis : une ressource transversale destinée aux données de régression spatiale, avec les éléments nécessaires à la compréhension et à la réutilisation des spécifications empiriques.

### Mouvement 5 — Contribution du data paper

Décrire la méthode de collecte, les critères d'admission, la vérification des sources, les transformations, les contrôles, la structure des fichiers et les limites. Réserver la comparaison complète des estimateurs et le package de benchmark à un travail ultérieur si le semi-synthétique reste dans le périmètre retenu.

## Proposition de formulation française de travail

Les expériences de Monte-Carlo occupent une place centrale dans l'évaluation des méthodes de régression spatiale, car elles permettent d'étudier leur comportement lorsque le mécanisme générateur des données est connu. Leur portée reste néanmoins liée aux configurations retenues. Les variations de taille d'échantillon, de bruit et de dépendance spatiale forment souvent le socle minimal d'un plan de simulation, tandis que les écarts à la spécification étudiée dépendent de choix plus ciblés, tels que la non-linéarité, l'hétérogénéité spatiale, la corrélation des covariables, les interactions, les variables omises ou les erreurs de mesure. Les applications empiriques apportent une preuve différente : elles exposent les méthodes à des combinaisons de structures qui n'ont pas été entièrement fixées par l'expérimentateur, sans permettre pour autant de mesurer directement un biais par rapport à un mécanisme vrai inconnu.

Cette complémentarité rend utile l'évaluation sur une diversité de jeux réels. Or les données employées dans la littérature spatiale sont réparties entre articles, suppléments, packages statistiques et entrepôts, avec des niveaux variables de documentation. Les fichiers seuls ne suffisent pas toujours à retrouver la variable réponse, les prédicteurs, l'unité d'observation, les coordonnées ou géométries, la dimension temporelle, le système de référence spatiale et les transformations appliquées. Des banques comme LAGOS-NE, Microbiome Learning Repo, CMPD et Pyrfume montrent que l'intégration multi-source exige une méthode explicite de sélection, d'harmonisation, de contrôle et de traçabilité.

Notre travail répond à ce besoin pour les données de régression spatiale en construisant une banque issue de sources scientifiques hétérogènes et reliée à leurs preuves documentaires. Pour chaque jeu admis, le processus vise à conserver la provenance, la structure empirique pertinente, les variables mobilisables et les transformations nécessaires à sa réutilisation. Le data paper décrit la constitution de cette ressource, ses fichiers, ses contrôles techniques et ses limites. Les chiffres définitifs devront être insérés uniquement après le gel du noyau publiable, afin que le résumé porte sur les données effectivement prêtes et distribuables.

## Lecture comparée approfondie des sept articles retenus

### Leur manière de construire le résumé

| Article | Point de départ | Réponse apportée | Contenu annoncé | Place du benchmark |
|---|---|---|---|---|
| LAGOS-NE | Les mesures de qualité de l'eau sont limitées géographiquement et temporellement | Intégration de nombreuses sources avec leur contexte écologique | 51 101 lacs, trois modules, 87 sources et plusieurs types de mesures | Secondaire; les usages scientifiques de la banque dominent |
| Microbiome Learning Repo | Les développeurs de méthodes manquent de l'expertise nécessaire pour interpréter et curer des données biologiques hétérogènes | Transformation de jeux publiés en tâches prêtes à analyser | 33 tâches de classification et régression issues de 15 études | Présent sous forme de cas d'usage, sans dominer le résumé |
| CMPD | Les bases de projets ont des structures et caractéristiques incompatibles | Parseurs et modèle matriciel unifié | 12 bases, 23 jeux et des extensions clairement distinguées | Motive la consolidation, mais le papier décrit surtout la ressource |
| MedMNIST v2 | Les modalités, tailles et tâches biomédicales sont très diverses | Standardisation d'images 2D et 3D dans un format léger | 12 jeux 2D, 6 jeux 3D, tailles, types de tâches et effectifs | Important, mais présenté après la description du produit |
| Monash Forecasting Archive | Il manque une archive étendue de séries reliées pour évaluer les modèles globaux | Archive et format commun TSF | 20 sources publiques, 50 variantes, fréquences et longueurs variées | Central dans la motivation et développé dans le résumé |
| Meta-Album | Les évaluations few-shot manquent de jeux assez nombreux, variés et abordables en calcul | Meta-collection multi-domaines en trois tailles | 40 jeux, 10 domaines, seuils de classes et d'exemples, trois versions | Très central; la collection est construite autour des compétitions |
| GriddingMachine | Les couches mondiales sont dispersées et incompatibles par leurs formats, projections, orientations et unités | Base standardisée et distribution automatisée par tags | Traits végétaux, indices de végétation et informations géophysiques accessibles dans plusieurs langages | Une utilisation parmi d'autres pour les modèles terrestres |

### Ce que montre LAGOS-NE

LAGOS-NE est le modèle le plus instructif pour notre méthode. Les données ne sont pas sélectionnées uniquement parce qu'elles existent. Trois critères sont annoncés : leur pertinence au regard des questions scientifiques, leur disponibilité et leur qualité, puis le coût nécessaire à leur intégration. La banque est organisée en modules ayant chacun leurs sources, leurs procédures d'intégration, leurs contrôles et leur version.

La provenance constitue un principe de conception : une donnée finale doit rester reliée à sa source. Les auteurs expliquent aussi que l'automatisation complète n'est pas réaliste lorsque les petits jeux ont peu de standards communs. L'intégration repose alors sur la collaboration entre spécialistes du domaine et spécialistes des données, ainsi que sur une interprétation manuelle documentée. Ce constat correspond directement à notre expérience avec les articles, les packages, les dépôts et les fiches datasets.

### Ce que montre Microbiome Learning Repo

ML Repo formule très clairement la différence entre un dépôt d'archives et une ressource méthodologique. Les auteurs ne se contentent pas de regrouper des fichiers : ils appliquent un traitement commun aux séquences, retirent certains échantillons selon des seuils explicites, lisent manuellement les métadonnées et les méthodes des articles, puis construisent des tâches scientifiquement interprétables.

Ils documentent aussi les facteurs de confusion et les répétitions par sujet. Certaines analyses sont restreintes géographiquement pour éviter qu'un effet de localisation soit confondu avec la réponse. La leçon pour notre data paper est que la valeur ajoutée doit être décrite au niveau des décisions de curation, pas uniquement au niveau du téléchargement ou du changement de format.

### Ce que montre CMPD

CMPD suit une progression facilement transférable : importance du problème, rôle historique des bases, inventaire de leurs incompatibilités, définition d'un modèle commun, conversion par des parseurs, puis validation structurelle. Le texte devient cependant très technique et énumératif après l'annonce de la contribution. Nous pouvons reprendre cette logique sans reprendre la densité de sigles ni l'inventaire exhaustif dans les premiers paragraphes.

### Ce que montre MedMNIST v2

MedMNIST est le modèle le plus net pour annoncer un produit. Son `Background & Summary` part de la diversité réelle des modalités, tailles et tâches, explique pourquoi quelques jeux ne permettent pas d'étudier la généralisation, situe deux collections antérieures, puis présente quatre propriétés mémorisables : diversité, standardisation, légèreté et usage pédagogique.

Pour notre article, une liste équivalente ne sera pertinente que si chaque propriété correspond à un résultat vérifié. Des termes possibles seraient : multi-source, traçable, spatialement documentée et réutilisable. Ils ne doivent pas devenir des slogans si les licences, transformations ou artefacts ne sont pas encore complètement vérifiés.

### Ce que montre Monash Time Series Forecasting Archive

Monash distingue correctement trois niveaux souvent confondus : 20 jeux sources, 50 variantes liées notamment à la fréquence ou aux valeurs manquantes, et de nombreuses séries au sein de chaque jeu. Cette précision est directement utile pour éviter des expressions ambiguës comme « article-dataset ».

Son introduction annonce cinq contributions concrètes : l'archive, le format TSF, la caractérisation des séries, les baselines et le code. Pour notre premier data paper, les trois premières dimensions sont transférables. La partie comparaison d'algorithmes est trop centrale pour servir directement de modèle au périmètre désormais retenu.

### Ce que montre Meta-Album

Le résumé de Meta-Album décrit la diversité par des exemples concrets plutôt que par le seul mot *multi-domaines*. Il cite l'écologie — faune et flore —, l'industrie manufacturière — textures et véhicules —, les actions humaines et la reconnaissance optique de caractères. Il précise également les échelles d'image : microscopique, échelle humaine et télédétection.

La section de collecte donne la liste complète des dix domaines : grands animaux, petits animaux, plantes, maladies des plantes, microscopie, télédétection, véhicules, fabrication, actions humaines et reconnaissance optique de caractères. Elle explique aussi leur définition selon quatre dimensions : domaine d'application, problème de reconnaissance, échelle et canaux d'entrée.

Cette technique rédactionnelle est utile : notre résumé gagnera à citer quelques domaines représentatifs de la banque spatiale, après gel du noyau publiable. Il faudra choisir des domaines réellement présents parmi les jeux admis, sans transformer cette liste en inventaire. Meta-Album est également un bon modèle pour annoncer des critères d'inclusion mesurables et plusieurs versions adaptées aux ressources, mais son dispositif reste fortement construit autour du benchmark et des compétitions.

### Ce que montre GriddingMachine

GriddingMachine fournit la formulation la plus concrète du problème spatial. Les auteurs énumèrent les obstacles observables : sites dispersés, GeoTIFF ou NetCDF différents, facteurs d'échelle, orientations inversées, grilles de latitude et longitude distinctes, projections incompatibles et unités non standardisées. Ils proposent ensuite une collection retraitée, identifiée par tags et accessible depuis plusieurs langages.

Leurs fichiers normalisés conservent notamment longitude, latitude, unité, description, auteurs, publication source, DOI et historique des modifications. Des empreintes SHA servent à vérifier les téléchargements. Cet article peut donc soutenir notre explication des exigences documentaires propres au spatial, tout en gardant à l'esprit qu'il traite principalement de couches mondiales régulières alors que notre banque comprend plusieurs types de structures spatiales.

## Conséquence pour notre futur résumé

La meilleure combinaison n'est pas de copier un seul article :

- reprendre de **LAGOS-NE** le passage du besoin scientifique à l'intégration multi-source et à la provenance;
- reprendre de **ML Repo** la transformation de sources publiées en objets directement réutilisables;
- reprendre de **MedMNIST** la concision de l'annonce du produit;
- reprendre de **Meta-Album** quelques exemples de domaines pour rendre la diversité concrète;
- reprendre de **Monash** la distinction entre sources, jeux, variantes et observations;
- reprendre de **GriddingMachine** les difficultés spécifiquement spatiales;
- reprendre de **CMPD** la logique inventaire, représentation commune, parseurs et validation.

Le benchmark ne devrait apparaître dans le résumé que comme un usage futur ou une possibilité de réutilisation. L'objet principal du texte doit rester la méthode de constitution, le contenu réellement publié, la traçabilité et les contrôles de la banque.

## Proposition d'Abstract français chiffré — état du 27 septembre 2026

Les simulations de Monte-Carlo permettent d'évaluer les méthodes de régression spatiale lorsque le mécanisme générateur est connu, mais leurs conclusions restent conditionnées par les structures effectivement simulées. Une première analyse de 67 textes intégraux a confirmé que la diversité empirique devait être examinée systématiquement, mais ce corpus intermédiaire doit encore être révisé et étendu avant que ses effectifs soient cités comme résultats définitifs. L'élargissement de la validation empirique est freiné par la dispersion des données spatiales entre articles, packages et entrepôts, ainsi que par l'hétérogénéité de leurs formats et de leur documentation.

Nous présentons une banque multi-source actuellement composée de 276 enregistrements analytiques techniquement prêts, issus de 129 sources distinctes. Elle rassemble notamment des données d'agriculture et de sols, d'écologie et de biodiversité, d'économie urbaine et immobilière, de santé publique, de climat, d'hydrologie, de qualité de l'air, de risques naturels et de sciences sociales. Chaque enregistrement possède une réponse, des prédicteurs et une formule résolue. Un CRS est déclaré pour 272 enregistrements. La géométrie active est de type `POINT` pour 275 enregistrements et `POLYGON/MULTIPOLYGON` pour un enregistrement ; lorsqu'une source aréale a été convertie en points représentatifs, sa géométrie polygonale d'origine est conservée séparément lorsqu'elle est disponible. Les sources, transformations et niveaux de preuve sont documentés, et toute structure spatiale reconstruite par le projet reste distinguée de celle employée par les auteurs.

La banque fournit également des procédures reproductibles de sous-échantillonnage et de construction semi-synthétique. Celles-ci conservent les covariables et supports spatiaux réels tout en générant une réponse à partir d'un mécanisme contrôlé ou d'une fonction plasmode ajustée puis figée. Elles associent ainsi des structures empiriques à une vérité connue pour étudier la récupération des effets, l'incertitude et la sensibilité aux structures spatiales. Les 276 enregistrements constituent le noyau techniquement prêt ; l'effectif effectivement redistribuable sera fixé après l'audit des licences et droits au niveau des 129 sources.

### Réserves avant insertion dans le manuscrit soumis

- Le snapshot strict compte actuellement zéro enregistrement juridiquement validé comme redistribuable, car `license_verified` et `redistribution_allowed` n'ont encore été confirmés pour aucune source. Les 276 enregistrements ne doivent donc pas être appelés « publiés » ou « redistribuables » avant cet audit.
- Les 67 textes intégraux et les 66 articles quantitatifs correspondent au corpus intermédiaire, pas au corpus final demandé par l'encadrant. Celui-ci doit retirer les travaux de géostatistique pure sans variables explicatives, être complété jusqu'à environ 100 articles en privilégiant les cinq à dix dernières années, puis être entièrement recodé avant le recalcul de la médiane, des effectifs empiriques et des configurations simulées.
- Les nombres de géométries décrivent la géométrie active des artefacts prêts. Ils ne signifient pas que les 275 sources sont nativement ponctuelles : plusieurs sources aréales conservent leur géométrie polygonale d'origine dans un champ séparé.
