# Prompts d’appui pour la méta-analyse et le *Background & Summary*

Date de mise à jour : 17 septembre 2026

Ces deux prompts ont des usages différents. Le premier s’adresse à une IA capable de parcourir le dépôt. Le second est autonome et peut être envoyé à une IA conversationnelle disposant seulement d’un accès au web.

## 1. Prompt actualisé pour une IA ayant accès au dépôt

```text
Tu travailles dans le dépôt llm-wiki-karpathy. Ta mission est d’effectuer un contrôle indépendant de la petite méta-analyse sur les pratiques d’évaluation des méthodes spatiales, puis d’effectuer les recherches web ciblées nécessaires à la préparation du Background & Summary du data paper.

Commence par lire intégralement :

- extensions_projet_2026-09/redaction_datapaper/PILOTE_META_ANALYSE_2026-09-16.md
- extensions_projet_2026-09/redaction_datapaper/meta_analyse_codage_50_articles_2026-09-17.tsv
- extensions_projet_2026-09/redaction_datapaper/meta_analyse_50_pdf_manifest_2026-09-17.tsv
- extensions_projet_2026-09/redaction_datapaper/meta_analyse_datasets_a_recuperer_2026-09-17.tsv
- extensions_projet_2026-09/redaction_datapaper/CORPUS_WEB_BRUT_META_ANALYSE_2026-09-16.md
- extensions_projet_2026-09/redaction_datapaper/PLAN_DATAPAPER_V2_2026-09-16.md
- extensions_projet_2026-09/redaction_datapaper/CORRESPONDANCE_RAPPORT_PLAN_V2_2026-09-16.md
- tools/build_meta_analysis_coding.py

Les textes intégraux convertis en TEI sont dans corpus/papers/tei. Consulte les PDF seulement lorsqu’un tableau, une formule ou une mise en page est mal restitué dans le TEI.

État à contrôler, sans le présumer exact :

- 50 articles examinés ;
- 47 articles dans le noyau quantitatif à DGP paramétrique ;
- E02 exclu ; G01 et G02 conservés dans une strate historique contextuelle ;
- 14 articles sans jeu réel, 29 avec un jeu et 4 avec deux jeux ;
- 37 utilisations empiriques et une médiane de 1 jeu réel par article ;
- au moins 82 expériences de simulation ;
- 1 183 cellules exactement reconstructibles dans 21 articles ;
- au moins 1 263 cellules en incluant les bornes inférieures ;
- 10 articles avec une évaluation hors échantillon, 36 sans et G03 encore ambigu.

Travail demandé :

1. Auditer un sous-échantillon stratifié d’au moins 10 articles, comprenant au moins deux articles de chacune des cinq familles. Refaire le codage sans copier les valeurs de la grille, puis comparer les résultats champ par champ.
2. Vérifier en priorité les décisions qui influencent le résultat global : inclusion, nombre de jeux réels, nombre d’expériences, cellules exactes ou bornes, répétitions du DGP, bootstrap interne, randomisation, MCMC et statut hors échantillon.
3. Rechercher sur le web des articles méthodologiques manquants susceptibles de modifier la conclusion. Cibler notamment : spatial machine learning, méthodes spatiales pénalisées ou de sélection, INLA/SPDE, Gaussian Markov random fields, deep spatial learning, méthodes de point process évaluées sur des données réelles, modèles spatio-temporels non économétriques et comparaisons multi-datasets.
4. Chercher spécialement les articles qui utilisent au moins trois jeux de données spatiaux réels, des benchmark suites spatiales, ou un protocole répété sur plusieurs régions/phénomènes. Ces cas sont les plus susceptibles de contredire ou nuancer le résultat actuel.
5. Pour chaque nouvel article candidat, relever : titre, auteurs, année, revue, DOI, URL officielle, famille, contribution, preuve d’une simulation à DGP paramétrique, nombre apparent de jeux réels, noms des jeux, type de validation et disponibilité du texte intégral. Ne transforme jamais une absence d’information en zéro.
6. Identifier les revues, périodes et familles sous-représentées dans le corpus actuel. Distinguer un corpus raisonné d’un échantillon représentatif de toute la littérature.
7. Vérifier les jeux récurrents déjà repérés : Boston Housing, Dublin voter turnout, précipitations NCDC, biomasse USDA-FIA, HECM et panel américain de demande de cigarettes. Signaler les variantes qui proviennent réellement de la même source.
8. Proposer une analyse de sensibilité : résultat avec les 47 articles ; résultat sans articles purement numériques ; résultat par famille ; résultat articles anciens/influents versus récents ; résultat selon présence d’une validation hors échantillon.
9. Produire une proposition de texte pour le premier mouvement du Background & Summary. Elle doit distinguer résultat observé, interprétation et limite d’échantillonnage. Ne pas présenter le ratio cellules de DGP/jeux réels comme une comparaison d’unités équivalentes.

Règles de preuve :

- privilégie les pages éditeur, DOI, Crossref, OpenAlex, dépôts institutionnels et textes intégraux ;
- pour chaque affirmation factuelle, indique la source exacte et le niveau de preuve : texte intégral, résumé, supplément ou simple métadonnée ;
- cite la section, le tableau ou la figure lorsque tu codes un plan de simulation ;
- sépare répétitions du DGP, bootstrap, permutation/randomisation, tirages MCMC et répétitions d’un algorithme stochastique ;
- n’invente aucun total lorsque les cellules ne sont pas reconstructibles ; utilise exact, borne inférieure ou non reconstructible ;
- ne modifie pas silencieusement la grille : consigne chaque désaccord avec l’ancienne valeur, la nouvelle valeur, la preuve et sa conséquence sur les résultats ;
- ne rédige aucune conclusion générale sur toute la littérature sans analyser le biais de sélection du corpus.

Livrables attendus :

A. tableau des désaccords issus du double codage ;
B. liste dédoublonnée de nouveaux articles prioritaires ;
C. tableau des articles utilisant au moins trois jeux réels ou un véritable benchmark multi-jeux ;
D. analyse des lacunes du corpus ;
E. analyses de sensibilité chiffrées ;
F. proposition de 3 à 5 paragraphes pour le Background & Summary, avec références ;
G. liste des points qui exigent encore une décision humaine.

Travaille d’abord en lecture et présente les résultats du contrôle avant toute modification importante du dépôt. Si tu crées un fichier, préfère un seul rapport de contrôle daté et actualise les fichiers existants plutôt que de multiplier les sorties intermédiaires.
```

## 2. Prompt autonome pour une IA sans accès au dépôt

```text
Je prépare le Background & Summary d’un data paper consacré à une banque documentée de jeux de données spatiaux destinée à l’évaluation de méthodes statistiques et de machine learning spatial. Tu n’as pas accès à mon dépôt ni à mes PDF. Je te demande donc une recherche web indépendante, traçable et utile à une vérification ultérieure, et non une modification de fichiers.

Contexte déjà établi par une première lecture de textes intégraux :

- un corpus raisonné de 50 articles méthodologiques spatiaux a été constitué ;
- 47 articles comportant une évaluation par DGP paramétrique forment le noyau quantitatif ;
- ces 47 articles utilisent 37 jeux réels au total : 14 articles n’en utilisent aucun, 29 en utilisent un et 4 en utilisent deux ;
- la médiane est donc de 1 jeu réel par article et aucun article du corpus n’en utilise plus de deux ;
- au moins 82 expériences et au moins 1 263 cellules de DGP ont été recensées ;
- seules 10 études comportent une évaluation prédictive hors échantillon clairement identifiée ;
- plusieurs jeux sont réutilisés : Boston Housing dans 3 articles ; Dublin voter turnout, précipitations NCDC, biomasse USDA-FIA, HECM et demande de cigarettes aux États-Unis dans 2 articles chacun.

Ces nombres sont des résultats internes à contrôler. Ils ne doivent pas être extrapolés automatiquement à toute la littérature. L’hypothèse à éprouver est la suivante : les articles méthodologiques spatiaux explorent souvent de nombreux scénarios simulés mais évaluent leurs méthodes sur peu de phénomènes empiriques distincts.

Effectue une recherche web large mais structurée pour tenter de confirmer, contredire ou nuancer cette hypothèse.

Questions prioritaires :

1. Existe-t-il des revues systématiques, méta-analyses ou études bibliométriques qui quantifient le nombre de jeux réels utilisés pour évaluer les méthodes spatiales, géostatistiques ou spatio-temporelles ?
2. Existe-t-il des articles méthodologiques spatiaux comparant leurs méthodes sur au moins trois jeux réels distincts ?
3. Existe-t-il de véritables benchmark suites pour la régression spatiale, la prédiction géostatistique, les panels spatiaux, les coefficients spatialement variables ou le spatial machine learning ?
4. Quels articles expliquent pourquoi les simulations sont nécessaires en statistique spatiale, mais insuffisantes pour établir la généralisabilité empirique ?
5. Quels travaux discutent le manque de diversité, la réutilisation des mêmes jeux, le dataset shift géographique, la transférabilité spatiale, la validation spatiale bloquée et la différence entre validation aléatoire et validation géographique ?
6. Quelles pratiques comparables existent dans les benchmarks tabulaires ou hydrologiques — par exemple OpenML Suites, PMLB, AMLB, TableShift, TabZilla, TabReD, CAMELS, LamaH-CE et Caravan — et quelles idées documentaires ou méthodologiques peuvent être transposées à une banque spatiale ?
7. Quelles références sur Datasheets for Datasets, Data Statements, FAIR, data papers et documentation géospatiale peuvent justifier la publication d’une banque de données spatiales soigneusement documentée ?

Élargis la recherche aux familles insuffisamment représentées dans notre corpus initial :

- spatial machine learning et deep spatial learning ;
- modèles INLA/SPDE et GMRF ;
- processus ponctuels spatiaux ;
- méthodes spatiales pénalisées et sélection de variables ;
- modèles spatio-temporels hors économétrie ;
- méthodes évaluées sur plusieurs villes, pays, bassins versants, domaines écologiques ou produits de télédétection ;
- articles récents de benchmark ou de comparaison multi-datasets.

Pour éviter les doublons, considère que les DOI suivants sont déjà présents dans notre corpus :

10.1111/1468-2354.00027; 10.1016/j.jeconom.2005.10.004; 10.1016/j.jeconom.2009.10.035; 10.1016/j.jeconom.2009.10.025; 10.1111/j.1467-9787.2009.00618.x; 10.1016/j.jeconom.2009.10.031; 10.1080/07474938.2013.741020; 10.1016/j.regsciurbeco.2013.09.002; 10.1016/j.regsciurbeco.2013.12.003; 10.1016/j.jeconom.2014.08.008; 10.1016/j.regsciurbeco.2015.02.003; 10.1016/j.jeconom.2014.12.005; 10.1111/jors.12116; 10.1016/j.regsciurbeco.2017.02.002; 10.1111/j.1538-4632.1996.tb00936.x; 10.1111/1467-9884.00145; 10.1068/a44111; 10.1080/24694452.2017.1352480; 10.1080/00949655.2017.1311896; 10.1002/env.2485; 10.1111/gean.12189; 10.1111/gean.12289; 10.1080/13658816.2023.2250838; 10.3934/math.2023713; 10.1007/s10109-025-00468-1; 10.1002/env.785; 10.1198/106186006X132178; 10.1198/016214508000000959; 10.1111/j.1467-9868.2008.00663.x; 10.1016/j.jmva.2010.10.010; 10.1111/j.1467-9868.2011.01007.x; 10.1080/01621459.2015.1044091; 10.1080/01621459.2015.1123632; 10.1002/env.2652; 10.1080/00949655.2021.2016759; 10.1016/j.jeconom.2006.09.004; 10.1080/17421772.2011.647057; 10.1016/j.jeconom.2016.12.001; 10.1016/j.jeconom.2016.11.004; 10.1016/j.regsciurbeco.2017.03.007; 10.1016/j.regsciurbeco.2020.103520; 10.1016/j.jeconom.2020.05.016; 10.1073/pnas.1917411117; 10.1371/journal.pone.0261144; 10.1111/biom.12656; 10.1016/j.jspi.2009.05.008; 10.1093/biostatistics/kxv048; 10.1002/env.2771; 10.1016/j.jmva.2024.105381; 10.1080/03610918.2022.2154365.

Pour chaque source nouvelle, fournis dans un tableau :

- titre exact ;
- auteurs ;
- année et revue ;
- DOI ;
- URL officielle ;
- famille méthodologique ;
- raison de sa pertinence ;
- simulation à DGP paramétrique : oui/non/incertain ;
- nombre de jeux réels : nombre vérifié ou « incertain » ;
- noms et provenance des jeux ;
- validation en échantillon, validation aléatoire, validation spatiale ou hors échantillon ;
- niveau de preuve : texte intégral, supplément, résumé ou métadonnées ;
- passage, section, tableau ou figure qui soutient l’information ;
- disponibilité du PDF ou d’une version auteur.

Sépare les résultats en quatre groupes :

A. articles méthodologiques nouveaux susceptibles d’entrer dans la méta-analyse ;
B. articles utilisant au moins trois jeux réels ou une comparaison multi-datasets ;
C. revues, études bibliométriques et textes conceptuels utiles pour interpréter le résultat ;
D. infrastructures et benchmark suites utiles comme points de comparaison pour le data paper.

Termine par :

1. une analyse des familles, périodes ou revues que notre corpus semble manquer ;
2. les dix sources nouvelles à vérifier en priorité ;
3. cinq hypothèses alternatives pouvant expliquer le faible nombre de jeux réels par article ;
4. une proposition prudente de 3 à 5 paragraphes pour une introduction scientifique ;
5. une liste explicite des informations que tu n’as pas pu vérifier.

Contraintes essentielles :

- n’invente aucun DOI, titre, nombre de jeux ou résultat ;
- vérifie chaque DOI sur une page officielle ou Crossref ;
- donne des liens directs, pas seulement des résultats de moteur de recherche ;
- n’utilise pas le nombre de citations comme preuve de qualité méthodologique ;
- ne conclus jamais « aucun article n’existe » à partir d’une recherche non exhaustive ;
- distingue clairement ce qui est observé, inféré et incertain ;
- ne transforme pas « non mentionné dans le résumé » en « zéro jeu réel » ;
- évite les longues citations : paraphrase et indique précisément la source ;
- indique la date de la recherche et les requêtes principales réellement utilisées.

Je réexaminerai ensuite tes résultats dans les textes intégraux. La priorité est donc la traçabilité et la qualité des pistes, pas la quantité brute de références.
```
