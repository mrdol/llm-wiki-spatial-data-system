# Calibration locale de la grille de méta-analyse — Monte-Carlo et jeux de données réels

Date : 16 septembre 2026  
Statut : **calibration de la grille sur des textes locaux ; ne constitue pas la sélection bibliographique du pilote**.  
Base de départ : protocole du 18 août 2026, corrigé à la lumière du plan V2 et du point d'encadrement.

## 1. Question étudiée

Dans les articles qui proposent ou comparent une méthode de régression spatiale, quelle place respective occupent :

- les expériences de simulation avec une vérité connue ;
- les applications à des jeux de données empiriques distincts ?

Cette calibration sert à vérifier que la question est codable de manière reproductible. Elle ne sert ni à sélectionner le corpus du pilote, ni à estimer la pratique de l'ensemble de la littérature. Les articles du véritable pilote seront recherchés sur le web selon une stratégie bibliographique annoncée à l'avance.

## 2. Corrections apportées au protocole initial

### Population

L'unité d'analyse est un **article méthodologique** qui propose un estimateur, une procédure d'inférence ou une comparaison systématique de méthodes pour des données spatiales ou spatio-temporelles.

### Corpus de calibration

La calibration utilise des textes complets déjà présents en TEI dans le dépôt. La sélection est raisonnée afin de tester la grille sur plusieurs formes de simulations. Elle ne constitue pas la sélection des articles de la méta-analyse.

### Sélection bibliographique du véritable pilote

La sélection doit être construite sur le web, indépendamment du contenu déjà présent dans le dépôt :

1. interroger OpenAlex et Crossref par revue, année et termes méthodologiques ;
2. constituer une liste de résultats avant de vérifier lesquels existent déjà localement ;
3. dédoublonner par DOI ;
4. examiner titre et résumé selon les critères d'inclusion ;
5. consigner toutes les exclusions avec leur motif ;
6. récupérer ensuite les textes accessibles et les convertir en TEI ;
7. coder le texte intégral sans remplacer les informations manquantes par des suppositions.

La présence préalable d'un PDF ou d'un TEI dans le dépôt ne doit jamais augmenter la probabilité qu'un article soit sélectionné.

La règle « publications postérieures à 2015 » est retirée comme critère scientifique général. Pour l'étude définitive, deux solutions restent possibles :

1. une strate d'articles influents sans restriction de date, définie par une règle bibliométrique reproductible ;
2. une strate récente, construite dans des revues prédéfinies sur une fenêtre temporelle annoncée à l'avance.

Les deux strates devront être analysées séparément avant toute synthèse commune.

### Inclusion

Un texte est inclus s'il remplit simultanément les conditions suivantes :

- contribution méthodologique spatiale ou spatio-temporelle ;
- expérience de simulation destinée à évaluer la méthode ;
- texte intégral permettant de coder le plan de simulation et les applications empiriques.

Les articles applicatifs sans simulation, ouvrages, revues, articles logiciels et brouillons internes sont exclus.

### Comptage des simulations

Le pilote montre qu'un compteur unique `n_dgp_cells` est insuffisant. Certains articles contiennent plusieurs expériences qui ne font pas varier les mêmes facteurs. Le codage définitif doit donc conserver :

- `n_simulation_experiments` : nombre d'expériences annoncées par les auteurs ;
- `n_dgp_structures` : nombre de mécanismes générateurs qualitativement distincts ;
- `n_cells_by_experiment` : nombre de cellules par expérience ;
- `n_dgp_cells_main_text` : somme des cellules explicitement reconstructibles dans le texte principal ;
- `cell_count_status` : `exact`, `lower_bound`, `unclear` ou `not_reported` ;
- `n_replications_by_experiment` : nombre de répétitions, qui ne doit pas être multiplié par le nombre de cellules.

Une valeur de paramètre utilisée uniquement pour ajuster une méthode n'est pas une nouvelle cellule de DGP. Les niveaux de significativité, les méthodes comparées et les hyperparamètres évalués sont codés séparément.

### Comptage des jeux réels

Un jeu empirique distinct est compté une seule fois, même si plusieurs modèles, variables réponses, périodes ou sous-échantillons en sont tirés. Une donnée générée par simulation ne devient jamais un jeu réel. Une application illustrative compte dans `n_real_datasets`, tandis que `n_real_with_perf` exige une évaluation chiffrée explicitement comparable.

## 3. Grille de codage révisée

| Bloc | Variables principales |
|---|---|
| Identification | identifiant, titre, auteurs, année, DOI, revue, version examinée |
| Sélection | inclus/exclu, motif, contribution méthodologique |
| Simulations | nombre d'expériences, structures de DGP, cellules par expérience, statut du compte, répétitions |
| Axes du DGP | taille, dépendance spatiale, `W`/géométrie, bruit/SNR, distribution des erreurs, hétéroscédasticité, non-linéarité, corrélation des X, échelle spatiale, erreur de mesure, valeurs manquantes |
| Méthodes évaluées | méthode proposée, comparateurs, métriques, vérité ciblée |
| Données réelles | nombre, noms, provenance, rôle analytique, comparaison chiffrée, hors-échantillon, validation déclarée |
| Preuve | section, tableau/figure, extrait paraphrasé, incertitude et décision du codeur |

La grille doit permettre `NA` et `unclear`. Une absence d'information ne doit pas être transformée en zéro.

## 4. Textes locaux utilisés uniquement pour calibrer la grille

### Articles inclus

| ID | Article | Simulation principale | Jeux empiriques distincts | Codage pilote |
|---|---|---|---:|---|
| P01 | Mei, Xu & Wang, *A bootstrap test for constant coefficients in geographically weighted regression models*, DOI `10.1080/13658816.2016.1149181` | GWR sur grille ; taille, distribution des erreurs, corrélation entre covariables et amplitude de variation sont modifiées ; 500 répétitions par réglage et 500 bootstraps par répétition | 1 — Boston Housing | **Inclus.** Le nombre total de cellules doit être codé par sous-expérience, car les expériences de niveau et de puissance se recouvrent partiellement. |
| P02 | Christensen & Eidsvik, *A dimension reduction approach to edge weight estimation for use in spatial models*, arXiv `2407.02684v2` | Deux expériences principales : choix du nombre de bases sur grilles 10×10/20×20 ; robustesse à une covariance non stationnaire issue de déformations | 1 — Mercer and Hall wheat yield | **Inclus.** Au moins 13 cellules principales sont directement reconstructibles : 6 pour l'expérience 1 et 7 pour l'expérience 2 ; la simulation supplémentaire doit rester séparée. |
| P03 | Wang et al., *GWRBoost: A geographically weighted gradient boosting method for explainable quantification of spatially-varying relationships*, arXiv `2212.05814v2` | Un DGP sur grille 25×25 avec quatre surfaces de coefficients de niveaux d'hétérogénéité différents ; 100 datasets simulés | 1 — NYC education, GeoDa | **Inclus.** Une cellule de DGP répétée 100 fois ; les quatre coefficients ne sont pas quatre datasets ni quatre cellules. |
| P04 | Wang & Li, *Structure identification and variable selection in geographically weighted regression models*, DOI `10.1080/00949655.2017.1311896` | Trois structures de GWR × deux amplitudes `α` × trois niveaux de corrélation `ρ` ; 200 répétitions | 1 — Dublin voter turnout | **Inclus.** 18 cellules principales exactement reconstructibles. Les 1 000 bootstraps internes de la méthode comparée ne sont pas des répétitions du DGP. |
| P05 | Murakami et al., *The Importance of Scale in Spatially Varying Coefficient Modeling*, DOI `10.1080/24694452.2018.1462691` | Deux expériences Monte-Carlo sur l'échelle des covariables et des coefficients spatiaux ; 200 répétitions par réglage | 0 | **Inclus.** Article particulièrement informatif : beaucoup de scénarios simulés et aucune application empirique propre. Le nombre exact de cellules doit être reconstruit séparément pour les deux expériences à partir des tableaux 2–4. |
| P06 | Murakami & Griffith, *Spatially varying coefficient modeling for large datasets: Eliminating N from spatial regressions*, DOI `10.1016/j.spasta.2019.02.003` | Expériences sur taille `N`, nombre de coefficients `K`, échelle et bruit ; 200 répétitions | 1 — valeurs foncières de Tokyo | **Inclus.** Le texte annonce quatre expériences ; le compte final doit distinguer petites tailles, grandes tailles et inférence. |

### Textes examinés mais exclus du pilote quantitatif

| Texte | Motif d'exclusion |
|---|---|
| *A geographic feature integrated multivariate linear regression method for house price prediction* | Application empirique et validation croisée, mais aucune étude Monte-Carlo. |
| *Multiscale Geographically Weighted Regression* | Ouvrage méthodologique, pas article constituant l'unité d'analyse. |
| *spmoran (ver. 0.2.0): An R package for Moran eigenvector-based scalable spatial additive mixed modeling* | Article logiciel ; les mentions de simulations renvoient principalement à d'autres travaux. |
| *Flexible nonlinear spatial autoregressive models: a gradient boosting approach with closed-form estimation* | Brouillon interne lié au développement du projet ; il ne doit pas entrer dans une étude de la littérature publiée. |
| *Scale and correlation in multiscale geographically weighted regression (MGWR)* | Texte de 2025 disponible localement et potentiellement éligible, conservé pour la seconde vague afin d'éviter que le pilote repose excessivement sur la famille GWR. |

## 5. Résultat descriptif de calibration uniquement

Sur les **six articles de calibration** :

- cinq utilisent exactement **un** jeu de données empirique distinct ;
- un n'en utilise **aucun** ;
- aucun n'en utilise deux ou davantage ;
- la médiane du nombre de jeux réels est **1** ;
- la répartition provisoire est : `0` = 1 article, `1` = 5 articles, `2` = 0, `3–5` = 0, `>5` = 0.

Ce résultat montre uniquement que la variable `n_real_datasets` est codable. Il **ne constitue pas un résultat du pilote bibliographique** et ne doit pas apparaître dans le data paper : l'échantillon a été choisi parmi les fichiers locaux et se concentre sur les modèles GWR/SVC.

Le comptage des cellules simulées est plus délicat. Deux articles permettent un compte exact immédiat, tandis que les autres répartissent les facteurs entre plusieurs expériences ou mêlent répétitions du DGP et bootstrap interne. Le pilote valide donc le principe de la méta-analyse, mais impose de stocker les comptes **par expérience** avant de calculer un total par article.

## 6. Axes déjà observés dans le pilote

| Axe de simulation | Présence constatée |
|---|---:|
| Taille d'échantillon ou taille de grille | 4/6 |
| Corrélation entre covariables | 2/6 |
| Distribution des erreurs | 1/6 |
| Échelle spatiale des covariables ou coefficients | 3/6 |
| Force/amplitude de l'hétérogénéité spatiale | 3/6 |
| Structure de covariance ou déformation | 1/6 |
| Niveau de bruit/SNR | 1/6 clairement codé |
| Erreur de mesure sur les covariables | 0/6 |
| Données manquantes | 0/6 |

Ces fréquences sont des contrôles de fonctionnement de la grille, pas des estimations de fréquence dans la littérature.

## 7. Décisions méthodologiques issues du pilote

1. Conserver séparément expériences, structures, cellules et répétitions.
2. Ajouter `cell_count_status` pour ne pas donner une fausse précision.
3. Coder les bootstraps internes séparément des réplications Monte-Carlo.
4. Ajouter l'axe « échelle spatiale » à la liste fermée des facteurs.
5. Ajouter une variable indiquant si l'application empirique fournit seulement une illustration, une qualité d'ajustement ou une véritable évaluation hors échantillon.
6. Ne pas utiliser les citations du rapport de stage comme base de sélection ; chaque valeur vient du texte intégral de l'article.
7. Diversifier la seconde vague au-delà de GWR/SVC : économétrie spatiale SAR/SEM/SDM, modèles de champ spatial, géostatistique et méthodes spatio-temporelles.

## 8. Prochaine étape : construire le pilote depuis le web

La prochaine passe doit :

1. fixer les revues, la période et les requêtes web ;
2. exporter tous les résultats web et les dédoublonner avant consultation du corpus local ;
3. sélectionner un pilote diversifié par famille méthodologique ;
4. rechercher ensuite les textes intégraux des articles sélectionnés ;
5. coder `n_real_with_perf`, l'évaluation hors échantillon et le schéma de validation ;
6. faire recoder au moins deux articles sans montrer le premier codage afin de tester l'accord ;
7. produire ensuite seulement une figure exploratoire clairement étiquetée « pilote web ».

## 9. Sources locales utilisées

Les six codages proviennent des fichiers TEI correspondants dans `corpus/papers/tei/`. Les sections consultées comprennent les plans de simulation, résultats de simulation et applications empiriques. Les métadonnées bibliographiques proviennent des en-têtes TEI ; elles devront être rapprochées de la bibliographie maître avant la version soumise.

## 10. Avancement du corpus web au 17 septembre 2026

Les 50 textes du corpus web disposent maintenant d'un PDF et d'un TEI valides. La grille détaillée est matérialisée dans `meta_analyse_codage_50_articles_2026-09-17.tsv`. Elle conserve les champs du protocole pour les expériences, structures de DGP, cellules, répétitions, axes simulés, méthodes, données réelles, validation et preuves textuelles.

### Partie vérifiée : inventaire des données empiriques

La lecture des sections d'application des 50 TEI donne, avant décision finale d'inclusion scientifique :

| Famille | Articles candidats | Sans jeu réel | 1 jeu réel | 2 jeux réels | Total d'utilisations empiriques |
|---|---:|---:|---:|---:|---:|
| Économétrie spatiale | 14 | 10 | 3 | 1 | 5 |
| GWR/MGWR/SVC | 11 | 2 | 8 | 1 | 10 |
| Géostatistique/GP | 10 | 1 | 9 | 0 | 9 |
| Spatio-temporel/panel | 10 | 2 | 8 | 0 | 8 |
| Complémentaires | 5 | 0 | 3 | 2 | 7 |
| **Total provisoire des candidats** | **50** | **15** | **31** | **4** | **39** |

Ces valeurs portent sur les 50 candidats avant application du critère d'éligibilité. La seconde lecture retient **47 articles** comportant une simulation fondée sur un DGP paramétrique pour l'analyse quantitative principale. `E02`, qui ne contient pas d'étude Monte-Carlo, est exclu. `G01` et `G02` sont conservés dans une **strate influente contextuelle** : ces articles fondateurs très cités utilisent une randomisation Monte-Carlo pour tester la variabilité spatiale des coefficients, sans DGP paramétrique destiné à évaluer les performances d'un estimateur. Ils serviront au cadrage historique et à une analyse descriptive séparée, mais ne figurent pas dans le dénominateur paramétrique principal.

Après ces exclusions, les 47 articles inclus se répartissent ainsi : 14 sans jeu réel, 29 avec un jeu réel et 4 avec deux jeux réels, soit 37 utilisations empiriques. La médiane est de 1 jeu réel par article, et reste égale à 1 parmi les seuls articles comportant une application empirique.

Une seconde lecture intégrale des TEI a corrigé deux omissions dues aux titres de sections : `T08` analyse les crimes mensuels de Pittsburgh et `C04` contient une seconde application aux mesures de conductivité de surface du golfe du Mexique. Le corpus montre aussi plusieurs réutilisations : Boston Housing, les anomalies de précipitations du NCDC, les données de biomasse FIA, les originations HECM et le panel de demande de cigarettes apparaissent chacun dans deux articles. Ce constat sera recalculé après inclusion définitive et harmonisation des noms de jeux.

### Partie restant à vérifier

Le codage principal des 47 articles est achevé. Il reste une vérification indépendante d'un sous-échantillon et, pour les articles dont le plan est réparti entre figures, tableaux et suppléments, une reconstruction détaillée si l'on souhaite remplacer les bornes minimales par des totaux exacts. Les champs réellement non reconstructibles restent `unclear` et ne sont jamais transformés en zéros.

## 11. Influence bibliométrique et codage des simulations au 17 septembre 2026

Les 50 DOI ont été interrogés dans OpenAlex le 17 septembre 2026. Le fichier source `openalex_citations_50_articles_2026-09-17.json` conserve l'identifiant OpenAlex, le compteur `cited_by_count` et la date de consultation. Ces compteurs servent à décrire l'influence du corpus ; ils ne constituent pas un critère d'inclusion rétroactif.

Neuf articles dépassent 500 citations OpenAlex : `G01` (3571), `G02` (1588), `E01` (1493), `G04` (1370), `E04` (1080), `S04` (1036), `T01` (821), `S02` (750) et `S07` (649). `G01` et `G02` sont conservés dans la strate influente contextuelle et analysés séparément des DGP paramétriques.

Une première extraction structurée des sept dimensions demandées a été appliquée aux 47 articles inclus. La grille enregistre désormais, séparément : nombre d'expériences, structures de DGP, expressions factorielles, répétitions, bootstrap interne, randomisation, comparateurs, métriques et onze familles de facteurs modifiés. La lecture automatique retrouve un nombre de répétitions explicite pour 22 articles, une expression factorielle explicite pour 2, des comparateurs pour 37 et des métriques pour 44. Ces valeurs sont des aides à la lecture, pas encore des comptes définitifs : les cellules doivent être reconstruites expérience par expérience dans les tableaux des articles.

Le registre `meta_analyse_datasets_a_recuperer_2026-09-17.tsv` conserve les jeux empiriques non retrouvés dans la banque, leur article source, leur contexte, leur propriétaire probable et une piste de récupération. Les correspondances certaines déjà présentes incluent notamment Boston Housing, Dublin voter turnout, Georgia educational attainment, England and Wales house prices et Swiss rainfall. Une similarité de thème ou de nom n'a pas été considérée comme une correspondance.

### Avancement du codage manuel

La famille **économétrie spatiale** est codée : les 13 articles admissibles `E01`, `E03`–`E14` ont été relus dans leur texte intégral. Les expériences, structures, cellules ou bornes, répétitions, bootstraps, méthodes et métriques ont été reportés dans la grille. `E02` reste exclu. Trois totaux de cellules sont exactement reconstructibles à ce stade (`E01` : 108, `E13` : 8, `E14` : 94) ; plusieurs autres sont conservés comme bornes inférieures ou nécessitent une reconstruction tableau par tableau. Cette différence de statut doit être conservée dans toute synthèse quantitative.

La famille **GWR/MGWR/SVC** est également codée pour l'analyse paramétrique : `G03`–`G11` ont été relus dans leur texte intégral. `G01` et `G02` restent dans la strate influente contextuelle. Les comptes exacts de cellules sont disponibles pour `G04` (2), `G05` (18 pour le plan principal), `G07` (1), `G08` (12), `G09` (1) et `G10` (8). `G03`, `G06` et `G11` gardent respectivement un statut de reconstruction par tableaux ou une borne inférieure. Les 1 000 bootstraps internes de `G05` et les 100 bootstraps par réplication de `G06` sont séparés des répétitions Monte-Carlo.

Les familles **géostatistique/GP** (`S01`–`S10`), **panel et spatio-temporel** (`T01`–`T10`) et **complémentaire** (`C01`–`C05`) sont désormais codées selon les mêmes règles. Les itérations MCMC de `S04`, `S06` et `S07`, les cinq répétitions algorithmiques de `S10` et les 200 bootstraps internes de `C02` ne sont pas comptés comme répétitions du DGP.

## 12. Résultats provisoires de la petite méta-analyse

> **État historique du premier codage (47 articles).** Les chiffres de cette section sont conservés pour la traçabilité, mais ils sont invalidés comme résultats finaux par le balayage intégral décrit plus bas. En particulier, la phrase selon laquelle aucun article ne mobilise plus de deux jeux réels ne doit plus être citée. Tous les indicateurs seront recalculés après l'extension du corpus.

### Corpus initialement retenu et données réelles
Le noyau quantitatif comprend **47 articles** à DGP paramétrique. Les deux articles `G01` et `G02` restent dans la strate historique contextuelle et `E02` est exclu. La distribution du nombre de jeux réels par article est :

| Nombre de jeux réels | Articles | Part du corpus |
|---:|---:|---:|
| 0 | 14 | 29,8 % |
| 1 | 29 | 61,7 % |
| 2 | 4 | 8,5 % |
| **Total** | **47** | **100 %** |

La médiane est de **1**, pour un total de **37 utilisations empiriques**. Aucun article ne mobilise plus de deux jeux réels. Les réemplois clairement harmonisés sont Boston Housing (**3 articles**), puis Dublin voter turnout, les précipitations NCDC, la biomasse USDA-FIA, les originations HECM et la demande de cigarettes aux États-Unis (**2 articles chacun**). Le nombre de jeux réellement distincts est donc inférieur à 37.

### Richesse des simulations

Les articles contiennent **au moins 82 expériences de simulation**. Ce total est une borne minimale, car `C01` présente plusieurs expériences de taille et de puissance sans les numéroter comme des expériences autonomes. Le nombre de structures qualitatives de DGP ne peut pas être additionné avec la même précision : certains auteurs changent de famille de modèle, d'autres seulement une distribution d'erreur ou une surface de coefficients. La grille conserve donc le nombre et la description article par article au lieu d'imposer une équivalence artificielle.

Pour les cellules paramétriques, **21 articles** livrent un total exact ou un plan principal exactement reconstructible, représentant **1 183 cellules**. Dix autres fournissent une borne inférieure explicite, ce qui porte le minimum observé à **1 263 cellules**. Les **16 articles restants** ont un plan continu, graphique, réparti entre plusieurs tableaux ou partiellement renvoyé aux suppléments ; aucun faux total n'est imputé à ces articles. Le minimum de 1 263 sous-estime donc volontairement la richesse réelle des simulations.

Les facteurs repérés le plus souvent dans les sections de simulation sont la géométrie ou la matrice de voisinage, la distribution des erreurs, la taille d'échantillon, la force de la dépendance spatiale, l'échelle ou la portée spatiale et l'hétéroscédasticité. Le bruit/SNR, la non-linéarité, la corrélation entre covariables, l'erreur de mesure et les valeurs manquantes apparaissent moins souvent. Les fréquences automatiques présentes dans le TSV servent de repérage textuel ; elles ne doivent pas encore être interprétées comme des prévalences définitives sans double codage des onze indicateurs.

### Répétitions et validation

Les répétitions du DGP sont enregistrées par expérience. Les bootstraps internes, randomisations, itérations MCMC et répétitions d'algorithmes stochastiques sont stockés séparément. Cette distinction modifie fortement la lecture de plusieurs articles qui affichent beaucoup d'itérations numériques mais ne génèrent qu'un seul champ spatial par scénario.

Une validation prédictive hors échantillon est explicitement codée dans **10 articles sur 47** ; **36** restent centrés sur l'estimation, l'inférence, la récupération des paramètres ou l'ajustement en échantillon ; **1** cas (`G03`) demeure ambigu. Les validations hors échantillon comprennent des lieux simulés tenus à l'écart, des observations supprimées, des partitions apprentissage/test et, plus rarement, une évaluation prédictive de l'application réelle.

### Rôle des applications empiriques

Les applications réelles servent principalement d'**illustration de faisabilité**, d'interprétation substantielle ou de démonstration sur un cas connu. Elles sont rarement conçues comme une comparaison multi-jeux avec un protocole de performance homogène. Même lorsque l'article comporte une validation hors échantillon, celle-ci peut porter uniquement sur la simulation. Le contraste documenté par le corpus est donc le suivant : des plans simulés comportant au minimum 1 263 cellules, face à 37 utilisations de jeux réels, concentrées sur au plus deux jeux par article et avec plusieurs réemplois des mêmes références.

Ce résultat soutient le premier mouvement du data paper sous une forme prudente : la littérature méthodologique étudiée explore une grande variété de réglages synthétiques, tandis que la diversité empirique par article reste faible. Il ne permet pas d'affirmer que les simulations sont inadéquates, ni que chaque cellule simulée équivaut à un jeu réel. Il motive plutôt une banque spatiale documentée qui facilite des évaluations répétées sur plusieurs phénomènes, géométries, tailles et mécanismes spatiaux réels.

## Révision du périmètre — 21 septembre 2026

Les résultats calculés sur les 47 articles admissibles déjà codés constituent un état intermédiaire et ne doivent plus être présentés comme les résultats finaux du data paper. Le corpus quantitatif doit atteindre au moins 50 articles admissibles et peut être porté à 60–70 si des textes influents, pertinents et intégralement documentés sont trouvés.

La recherche complémentaire doit couvrir l'ensemble du corpus TEI du dépôt avant tout nouvel élargissement web. Deux contre-exemples déjà repérés imposent de recalculer la distribution du nombre de jeux réels :

- *SGWR: similarity and geographically weighted regression* (DOI 10.1080/13658816.2024.2342319) : cinq jeux réels distincts ;
- *Benchmarking Regression Models Under Spatial Heterogeneity* (DOI 10.4230/LIPIcs.GIScience.2023.11) : cinq jeux spatiaux publics ;
- *Top-down scale approaches for multiscale GWR with locally adaptive bandwidths* (DOI 10.1007/s10109-025-00481-4) : sept applications réelles indiquées dans le TEI, à vérifier ligne à ligne avant inclusion.

Règle de comptage : plusieurs années, réponses, formules ou sous-échantillons issus d'une même source empirique comptent pour une source ; des jeux nommés et acquis indépendamment comptent séparément. Les distributions, médianes, récurrences et taux de validation hors échantillon ne seront figés qu'après recodage du corpus élargi.

Dans le manuscrit, les articles non retenus ne sont pas racontés dans les résultats. Les critères de sélection restent décrits dans les Methods et le journal de sélection demeure disponible dans les matériaux de traçabilité.

## Balayage intégral des 446 TEI — 21 septembre 2026

### Couverture

Les 446 fichiers TEI de `corpus/papers/tei` ont été analysés. Le rapprochement a été réalisé par DOI normalisé et titre normalisé, et non uniquement par nom de fichier.

- 50 articles correspondent au tableau de codage déjà constitué ;
- 118 fichiers supplémentaires contiennent à la fois des indices de simulation et d'application empirique ;
- ces 118 fichiers représentent 106 articles uniques après dédoublonnage ;
- les autres fichiers ne réunissent pas ces deux indices ou relèvent manifestement d'un autre type de contenu.

Ce filtre est volontairement sensible : les 106 résultats incluent donc des faux positifs, notamment des ouvrages, revues, logiciels, articles causalistes non spatiaux, simulations citées mais non réalisées et études empiriques utilisant le mot « simulation » dans un autre sens. L'admissibilité finale repose sur la lecture des sections du TEI.

### Candidats prioritaires dont le DGP paramétrique a été repéré

| Priorité | Article | DOI | Jeux réels repérés | Décision de criblage |
|---|---|---|---:|---|
| A | Geographically weighted elastic net logistic regression | 10.1007/s10109-018-0280-7 | 2 | admissible probable ; simulation SVC explicite et deux domaines réels |
| A | Benchmarking Regression Models Under Spatial Heterogeneity | 10.4230/LIPIcs.GIScience.2023.11 | 5 | admissible probable ; DGP factoriel et cinq jeux spatiaux publics |
| A | Top-down scale approaches for multiscale GWR with locally adaptive bandwidths | 10.1007/s10109-025-00481-4 | 7 | admissible probable ; trois DGP et sept jeux réels annoncés ; article récent |
| A | A new method for dealing simultaneously with spatial autocorrelation and spatial heterogeneity in regression models | 10.1016/j.regsciurbeco.2017.04.001 | 1 | admissible probable ; trois expériences Monte-Carlo et application immobilière |
| A | A spatiotemporal weighted regression model for analyzing local nonstationarity | 10.5194/gmd-13-6149-2020 | 1 | admissible probable ; DGP spatio-temporel et données isotopiques réelles |
| A | Geographically neural network weighted regression | 10.1080/13658816.2019.1707834 | 1 | admissible probable ; données simulées et observations environnementales |
| A | Joint variable selection of fixed and random effects for GP-based SVC models | 10.1080/13658816.2022.2097684 | à vérifier | admissible probable ; sections Simulation et Application |
| A | The Wald Test of Common Factors in Spatial Model Specification Search Strategies | 10.1017/pan.2020.23 | 1 | admissible probable ; 1 000 réplications par configuration et application électorale |
| A | Generalized Spatial and Spatiotemporal ARCH | DOI à corriger | 1 | admissible probable ; simulation paramétrique et mortalité par cancer |
| A | Flexible shrinkage in high-dimensional Bayesian spatial autoregressive models | DOI à retrouver | 1 | admissible probable ; simulation SAR et croissance régionale européenne |
| A | Measurement error caused by spatial misalignment in environmental epidemiology | 10.1093/biostatistics/kxn033 | 1 | admissible probable ; DGP sur mésalignement spatial et application environnementale |
| A | A bootstrap test for constant coefficients in GWR models | 10.1080/13658816.2016.1149181 | à vérifier | admissible probable ; distinguer réplications du DGP et bootstrap interne |
| A | Spatially varying coefficient modeling for large datasets | 10.1016/j.spasta.2019.02.003 | 1 | admissible probable ; simulation et application à grande échelle |
| A | The Importance of Scale in Spatially Varying Coefficient Modeling | 10.1080/24694452.2018.1462691 | à vérifier | admissible probable ; simulation multiscalaire et application |

### Candidats complémentaires à vérifier ligne à ligne

| Article | DOI | Point à vérifier |
|---|---|---|
| Estimation and prediction for spatial GLMMs with parametric links | à retrouver | nombre exact d'applications et cellules du DGP |
| GWRBoost | à retrouver | statut éditorial, DGP et indépendance du jeu réel |
| Flexible nonlinear spatial autoregressive models: a gradient boosting approach | 10.1111/gean.12268 | protocole complet et nombre de jeux réels |
| Spatial panel count data: modeling and forecasting of urban crimes | 10.1007/s43071-021-00019-y | DGP confirmé ; application Pittsburgh ; normaliser le DOI |
| Estimating dynamic spatial panel data models with endogenous regressors using synthetic instruments | 10.1007/s10109-022-00397-3 | confirmer la présence d'une application réelle ; admissible même sans jeu réel si le DGP est complet |
| Spatio-temporal Bayesian model selection for disease mapping | 10.1002/env.2410 | vérifier structures du DGP et source empirique |
| Multiscale SVC modelling using a Geographical Gaussian Process GAM | 10.1080/13658816.2023.2270285 | vérifier répétitions et validation |
| Spatially Varying Coefficient Model for Neuroimaging Data with Jump Discontinuities | arXiv:1310.1183 | retrouver la version publiée et son DOI |
| A dimension reduction approach to edge-weight estimation | à retrouver | vérifier application et influence |
| Estimation and Inference of Quantile SVC Models Over Complicated Domains | 10.1080/01621459.2025.2480867 | article très récent ; vérifier DGP et application |
| Fast Spatio-Temporally Varying Coefficient Modeling With Reluctant Interaction Selection | 10.1111/gean.70005 | article récent ; vérifier DGP et application |
| GeoShapley | 10.1080/24694452.2024.2350982 | vérifier que la simulation régénère bien un DGP spatial |
| Spatial Clustering Overview and Comparison | 10.1080/00045608.2014.958389 | vérifier adéquation avec le périmètre « estimation/régression » |
| Resampling Methods for Spatial Regression Models Under Stochastic Designs | 10.1214/009053606000000551 | distinguer DGP, bootstrap et résultats théoriques |

### Textes repérés mais non destinés au dénominateur principal

- *RealCause*, les articles EMCS et les articles CATE : utiles pour la revue semi-synthétique ou le cadrage causal, mais hors noyau des méthodes spatiales retenues ici ;
- *Using simulation studies to evaluate statistical methods*, LeSage–Pace sur les études Monte-Carlo et les textes sur les plasmodes : références méthodologiques de cadrage, pas nouvelles observations du corpus quantitatif ;
- ouvrages, revues logicielles et manuels, notamment *Spatial Statistics for Data Science* et la revue des logiciels d'économétrie spatiale : contexte documentaire ;
- TableShift, Random Forest et benchmarks tabulaires généraux : comparaison avec les infrastructures ML, mais hors corpus spatial à DGP paramétrique ;
- articles purement empiriques, études de cas et simulations seulement mentionnées dans l'état de l'art : hors corpus quantitatif.

### Conséquence immédiate

Les trois premiers candidats de priorité A suffisent à porter le corpus de travail de 47 à 50 articles admissibles probables. La liste A et la liste complémentaire offrent un réservoir suffisant pour viser 60–70 articles, sous réserve de la vérification intégrale et d'une mesure d'influence corrigée par l'ancienneté. Les statistiques sur le nombre de jeux réels restent suspendues jusqu'au codage de ces ajouts.


## Examen approfondi des 14 TEI de priorité A — 21 septembre 2026

### Décision générale

Après la décision de retirer l'article A14, qui ne comporte aucun jeu réel, **13 articles** sont ajoutés au corpus quantitatif. Ils présentent tous une contribution ou comparaison méthodologique spatiale, un mécanisme générateur paramétrique explicite, une évaluation sur données simulées et au moins une application empirique. Ils sont distincts des 47 articles déjà codés. Le corpus quantitatif atteint donc **60 articles**.

Cette décision ne signifie pas que les 14 ont la même influence bibliographique. L'admissibilité méthodologique et l'influence seront traitées séparément, avec une mesure de citations ajustée à l'ancienneté.

### Codage de lecture

| ID provisoire | Article | Expériences et DGP | Répétitions | Jeux réels | Méthodes et métriques | Décision / réserve |
|---|---|---|---|---:|---|---|
| A01 | *Geographically weighted elastic net logistic regression* | 1 expérience ; 1 DGP SVC logistique sur les 159 comtés de Georgia ; collinéarité locale construite | 100 jeux régénérés | 2 : élections américaines 2016 ; présence/absence d'espèce `ecospat` | LR, ENLR, GW-LR, GW-ENLR ; taux de classification, collinéarité locale et shrinkage | **Inclus.** Une seule cellule principale ; les deux applications sont indépendantes. |
| A02 | *Benchmarking Regression Models Under Spatial Heterogeneity* | 2 structures : relation linéaire et relation non linéaire avec interactions ; variation de `n`, non-stationnarité `lambda`, bruit `sigma` et hétérogénéité des erreurs | répétitions non explicitement reconstructibles dans le TEI | 5 : California Housing, Atlantic mortality, déforestation, Meuse, richesse végétale | OLS, SLX/SAR, GWR, RF, RF spatial, RF+krigeage ; RMSE, MAE, R² ; partage 90/10 | **Inclus.** Nombre de cellules à reconstruire à partir des figures et du code ; véritable comparaison multi-jeux. |
| A03 | *Top-down scale approaches for multiscale GWR with locally adaptive bandwidths* | expérience univariée sur 4 patrons ; expérience multivariée sur 3 DGP principaux et variantes ; taille, SNR, distribution des erreurs et patrons spatiaux varient | 1 000 par patron/unité de tableau ; 300 dans l'étude annexe du choix de séquence | 7 : Georgia, Clearwater, Tokyo, Berlin, VaucluseHousePrice, King County houses, NYC Airbnb | OLS, GWR, MGWR R/Python, `tds_mgwr`, `atds_mgwr` ; RMSE des coefficients, temps, AICc, CV aléatoire à 5 plis | **Inclus.** Sept jeux confirmés ; plusieurs variantes en annexe imposent un comptage principal/secondaire séparé. |
| A04 | *A new method for dealing simultaneously with spatial autocorrelation and spatial heterogeneity* | 3 expériences : concurvité, robustesse croisée estimateur–DGP, identification de `W` ; DGP OLS, SAR, GWR et MGWR-SAR stationnaire/non stationnaire | 1 000 pour l'expérience de robustesse ; autres répétitions à confirmer | 1 : prix immobiliers de Lucas County | OLS, SAR, GWR, MGWR-SAR ; biais, RMSE, identification de `W`, RSS, AIC, PMSE 10/20 plis | **Inclus.** Application avec véritable validation hors échantillon. |
| A05 | *A spatiotemporal weighted regression model for analyzing local nonstationarity* | 3 scénarios simulés sur cinq dates ; covariables et coefficients évoluent selon des tendances paramétrées | aucune répétition indépendante explicitement annoncée | 1 : isotopes de précipitation du nord-est des États-Unis | OLS, GWR, GTWR, STWR ; SSE, R², sigma, AICc, LOOCV | **Inclus.** Les trois « case studies » initiales sont des scénarios simulés, pas trois jeux réels. |
| A06 | *Geographically neural network weighted regression* | 1 DGP SVC, séparation apprentissage/test | 100 jeux simulés | 1 : observations environnementales côtières du Zhejiang | OLS, quatre GWR à noyaux différents, GNNWR ; R², RMSE, MAE, MAPE, AICc, corrélation ; test séparé | **Inclus.** Validation prédictive explicite en simulation et sur le jeu réel. |
| A07 | *Joint variable selection of fixed and random effects for GP-based SVC models* | 1 expérience ; GP-SVC sur grille perturbée 15×15, huit covariables, configuration fixe des effets nuls/non nuls | 100 jeux simulés | 1 : Dublin Voter 2002 | ALASSO, MLE, oracle, PMLE, GWR ; erreurs relatives, sélection d'effets, BIC, RMSE CV 10 plis | **Inclus.** Une cellule principale ; application réelle hors échantillon. |
| A08 | *The Wald Test of Common Factors in Spatial Model Specification Search Strategies* | 1 plan comprenant DGP non spatial, SEM et SDM ; `n`, `rho` et corrélation avec variable omise varient | 1 000 par configuration ; bootstrap interne distinct | 1 source : élections parlementaires et croissance du PIB | quatre formulations Wald, Wald bootstrap, LR ; taille, faux positifs, puissance | **Inclus.** Ne pas compter le bootstrap comme régénération du DGP. |
| A09 | *Generalized Spatial and Spatiotemporal Autoregressive Conditional Heteroscedasticity* | études sur lattice, dépendance de variance et estimation spARCH ; seconde grille de 48 réglages (`d`, `alpha`, `rho`) | 100 000 par réglage | 1 : mortalité par cancer pulmonaire, 3 108 comtés américains | régression linéaire, SAR, SAR-spARCH ; biais/densités des estimateurs, Moran I, AIC | **Inclus.** DOI corrigé : `10.1016/j.spasta.2018.07.005`. |
| A10 | *Flexible shrinkage in high-dimensional Bayesian spatial autoregressive models* | 1 expérience ; 8 scénarios issus de `K={50,100,150,200}` × `q={10,20}`, `N=100`, W à cinq voisins | 100 régénérations ; 2 000 itérations MCMC dont 1 000 burn-in, à compter séparément | 1 : croissance régionale paneuropéenne | sans shrinkage, SSVS, Normal-Gamma, Dirichlet-Laplace ; RMSE paramètres, précision, temps | **Inclus.** DOI corrigé : `10.1016/j.spasta.2018.10.004`. |
| A11 | *Measurement error caused by spatial misalignment in environmental epidemiology* | au moins 2 expériences : réponse continue et binaire ; plusieurs scénarios d'exposition/prédiction | 500 jeux par scénario | 1 : particules liées au trafic et poids de naissance, Grand Boston | plug-in, simulation d'exposition, correction de régression, approches bayésiennes ; biais, variance, couverture/MSE selon le cas | **Inclus.** Article central pour l'erreur issue de covariables spatiales interpolées. |
| A12 | *A bootstrap test for constant coefficients in GWR models* | 2 sous-expériences : validité/taille et puissance ; taille, distribution d'erreur, corrélation de X et amplitude de variation changent | 500 DGP par réglage ; 500 bootstraps internes par réplication | 1 : Boston Housing | test bootstrap, F-test, L-test ; taux de rejet, erreur de type I, puissance | **Inclus.** Application : 1 000 bootstraps par test ; ne pas les confondre avec les répétitions du DGP. |
| A13 | *Spatially varying coefficient modeling for large datasets: Eliminating N from spatial regressions* | 3 expériences : petits échantillons, grands échantillons, inférence ; variation de `N`, `K`, échelle et bruit | 200 par réglage | 1 : valeurs foncières autour des gares de Tokyo | M-SVC original/rapide, GWR, FB-GWR ; biais, RMSE, temps, erreur de type I, puissance | **Inclus.** Plusieurs régimes de taille ; cellules à reconstruire par sous-expérience. |

### Totaux empiriques apportés par les 13 articles retenus

La distribution interne aux 13 ajouts est maintenant :

- 10 articles avec un jeu réel ;
- 1 article avec deux jeux réels ;
- 1 article avec cinq jeux réels ;
- 1 article avec sept jeux réels.

A14 (*The Importance of Scale in Spatially Varying Coefficient Modeling*) est conservé uniquement dans le journal de criblage : il contient deux expériences de simulation mais aucun jeu réel et ne figure pas dans le TSV des 60 articles.

Les 13 ajouts représentent **24 utilisations empiriques** avant dédoublonnage entre articles. Le total final des sources distinctes sera inférieur, car certains jeux réapparaissent dans plusieurs textes, notamment Dublin Voter et des jeux classiques de GWR.

### Incidence sur le travail restant

Les résultats ont été recalculés directement à partir du TSV étendu afin de traiter ensemble les doublons de sources, les catégories de validation et les cellules DGP. A14 est écarté de cette extension parce qu'il ne comporte aucun jeu réel. Les tableaux complexes des sept articles restants ont été reconstruits avant le calcul ; lorsqu'une figure continue ou une annexe incomplète interdisait un total exact, seule une borne inférieure documentée a été retenue.


## Méta-analyse recalculée sur 66 articles — 21 septembre 2026

Le fichier de calcul de référence est `meta_analyse_codage_66_articles_2026-09-21.tsv`. Il contient 70 lignes de traçabilité : 66 articles à DGP paramétrique dans le dénominateur, deux articles GWR conservés comme contexte historique de randomisation, un article ancien sans Monte-Carlo et A14 sans jeu réel conservés comme décisions d'exclusion. Les 67 TEI disponibles disposent tous d'une ligne de codage ou de criblage ; aucun statut de lecture n'est en attente.

### Diversité empirique

| Nombre de jeux réels par article | Articles | Part des 66 articles |
|---:|---:|---:|
| 0 | 14 | 21,2 % |
| 1 | 39 | 59,1 % |
| 2 | 11 | 16,7 % |
| 3–5 | 1 | 1,5 % |
| >5 | 1 | 1,5 % |
| **Total** | **66** | **100 %** |

La médiane est de **1 jeu réel par article**. Le corpus contient **73 utilisations empiriques brutes** et **63 sources réelles distinctes** après harmonisation. Boston Housing apparaît dans quatre articles et Dublin Voter dans trois. NCDC precipitation, USDA-FIA biomass, HECM originations, US cigarette demand et Meuse apparaissent dans deux articles chacun. Les autres sources ne sont utilisées que dans un article du corpus.

La présence d'un même jeu dans plusieurs articles est comptée comme plusieurs utilisations empiriques mais comme une seule source distincte. Les découpages, périodes ou réponses multiples issus d'une même source ne deviennent pas de nouveaux jeux indépendants.

### Simulations, structures et cellules

Les 66 articles contiennent au moins **117 expériences distinctes** et **141 structures nommées de DGP**. Le mot « structure » reste descriptif : selon les articles, il peut désigner une famille de modèles, une distribution d'erreur, une surface de coefficients ou un mécanisme spatial différent.

Le minimum documenté atteint **2 042 cellules paramétriques** :

- 1 898 cellules exactes ou exactement reconstructibles dans 36 articles ;
- 144 cellules constituant des bornes inférieures documentées dans 15 articles ;
- 15 articles utilisant des plages continues, des grilles graphiques, des tableaux dispersés ou des plans dont la taille factorielle complète n'est pas communiquée.

Les six nouveaux articles N01–N06 ajoutent dix expériences, dix-huit structures et au moins 147 cellules au bilan précédent. N02 contribue une borne inférieure de quatre cellules car le nombre exact de niveaux de discordance spatiale n'est pas donné. N05 expose quarante cellules, mais ne communique pas le nombre de régénérations indépendantes du DGP.

### Facteurs modifiés

Le repérage harmonisé sur les 66 articles trouve principalement :

| Facteur modifié | Articles |
|---|---:|
| Géométrie ou matrice de voisinage | 45 |
| Taille d'échantillon | 39 |
| Dépendance spatiale | 37 |
| Distribution des erreurs | 35 |
| Échelle spatiale | 20 |
| Hétéroscédasticité | 12 |
| Non-linéarité | 8 |
| Corrélation des covariables | 8 |
| Bruit ou rapport signal/bruit | 7 |
| Erreur de mesure | 4 |
| Données manquantes | 2 |

Ces fréquences décrivent les facteurs explicitement identifiés dans le corpus. Elles ne constituent pas des estimations de leur fréquence dans l'ensemble de la littérature spatiale.

### Répétitions et validation

Les répétitions du DGP sont séparées des bootstraps internes, permutations, tirages postérieurs, périodes de chauffe MCMC et répétitions d'optimisation. Lorsqu'un article ne communique pas le nombre de régénérations indépendantes, la valeur reste « non rapportée ».

- 20 articles sur 66 comportent une validation hors échantillon identifiable, soit **30,3 %** ;
- 45 restent centrés sur l'ajustement, l'estimation, l'inférence, la taille ou la puissance des tests, ou la récupération des paramètres ;
- 1 cas demeure ambigu.

Trois nouveaux articles, N03, N04 et N06, comportent une validation hors échantillon identifiable. N01 évalue la puissance d'un test, N02 la récupération de partitions et N05 le biais et la couverture sans validation prédictive réelle hors échantillon.

### Portée de l'interprétation

La richesse des cellules simulées et le nombre de jeux réels ne mesurent pas la même chose. Les premières décrivent la profondeur d'exploration de mécanismes contrôlés ; les seconds décrivent la diversité des contextes empiriques. Leur présentation conjointe met en évidence une différence de largeur d'évaluation sans transformer les 2 042 cellules et les 63 sources en unités commensurables.

La figure `figures/F1_distribution_jeux_reels_66_articles.png` représente la distribution empirique. Le TSV complet constitue le tableau supplémentaire article par article.

### Étape différée avant le snapshot final de la banque

Après la rédaction des résultats de cette méta-analyse et avant le gel du snapshot de la banque, une phase distincte cherchera à récupérer les jeux de données employés par les 67 textes intégraux. Elle travaillera au niveau des **sources réelles distinctes**, avec dédoublonnage, vérification des licences, provenance, version et correspondance avec les jeux déjà présents dans le dépôt. La présence d'une application dans un article ne garantit ni l'accès au fichier ni son droit de redistribution.

