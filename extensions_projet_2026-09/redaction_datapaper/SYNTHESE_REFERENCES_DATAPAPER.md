# Synthèse des références pour la rédaction du data paper

Date : 16 septembre 2026  
Périmètre : les 11 références de la revue des banques de benchmark et les 24 références de la revue semi-synthétique. Cette synthèse distingue les références qui fondent directement le data paper de celles qui documentent ses extensions méthodologiques.

## 1. Architecture générale de la littérature

La bibliographie répond à cinq questions complémentaires :

1. **Comment constituer une collection de datasets standardisée ?** PMLB.
2. **Comment transformer un dataset en tâche de benchmark reproductible ?** OpenML.
3. **Comment conserver les conditions et résultats d'une exécution ?** AMLB.
4. **Comment documenter correctement une ressource scientifique spatiale ?** CAMELS-US, LamaH-CE, Caravan, Datasheets et FAIR.
5. **Comment évaluer des méthodes sans tirer des conclusions artificielles du choix des données, des splits ou du DGP ?** TableShift, TabZilla, TabReD, puis la littérature sur les simulations, plasmodes et validations spatiales.

La contribution de la banque se place à l'intersection de ces traditions. Elle vise une collection multidomaine et traçable, conserve les objets propres à la modélisation spatiale, puis distingue le dataset, la tâche, la suite et l'exécution.

## 2. Références centrales citées dans l'introduction et la discussion

### PMLB — Romano et al. (2022)

PMLB propose une collection publique de datasets tabulaires accessibles par des interfaces uniformes en R et Python. Chaque dataset est accompagné de métadonnées et de profils standardisés. Sa contribution principale est de réduire le coût d'accès, de préparation et de comparaison.

**Apport au data paper :** modèle pour l'interface commune, la validation par schéma et les métadonnées machine-lisibles.  
**Limite utile au positionnement :** PMLB normalise des datasets, mais ne définit pas nécessairement une tâche scientifique spatiale, une matrice `W` ou un split substantif pour chaque entrée.

### OpenML Benchmarking Suites — Bischl et al. (2021)

OpenML distingue le dataset de la tâche. Une tâche associe données, cible, procédure d'évaluation, splits exacts et métrique ; une suite regroupe des tâches sélectionnées et versionnées. Les runs enregistrent ensuite pipeline, paramètres, prédictions et scores.

**Apport au data paper :** justification principale de la séparation `Dataset`–`BenchmarkTask`–`BenchmarkSuite`–`BenchmarkRun`.  
**Conséquence :** les 381 fiches ne doivent pas être présentées comme 381 tâches exécutables.

### AMLB — Gijsbers et al. (2024)

AMLB formalise le harnais d'exécution : environnements, versions, budgets, ressources, prédictions, scores, avertissements et échecs. Le papier montre que les échecs ne doivent pas être supprimés silencieusement, car ils peuvent se concentrer sur les tâches difficiles et biaiser les classements.

**Apport au data paper :** modèle pour les manifests d'exécution, les versions, les timeouts et le traitement des échecs.  
**Conséquence :** un jeu marqué `package_include: yes` n'est pas pour autant un benchmark exécuté.

### TableShift — Gardner et al. (2023)

TableShift construit des tâches tabulaires où les domaines d'entraînement et de test sont définis explicitement. Le split représente une situation de transfert hors distribution et non une simple option informatique. Aucun modèle robuste ne domine uniformément les bonnes baselines sur toutes les tâches.

**Apport au data paper :** justification de l'obligation de décrire la population cible et le sens du transfert.  
**Application spatiale :** distinguer interpolation locale, extrapolation vers une région, transfert entre territoires et prévision temporelle.

### TabZilla — McElfresh et al. (2023)

TabZilla compare de nombreuses méthodes tabulaires sur un large ensemble de datasets. Les écarts entre réseaux de neurones et arbres boostés sont souvent faibles ; le réglage ou une baseline simple peut compter davantage que la famille de modèles. Le sous-ensemble « difficile » est sélectionné après un pilote empirique multi-méthodes.

**Apport au data paper :** la difficulté d'un dataset ne doit pas être proclamée à partir de sa taille ou de son Moran ; elle doit être observée au moyen de plusieurs baselines.  
**Limite :** cette logique peut guider la constitution future d'un noyau difficile, sans servir à sélectionner rétrospectivement les jeux favorables à une méthode.

### TabReD — Rubachev et al. (2025)

TabReD reconstruit des tâches tabulaires proches d'usages réels, avec variables riches et splits temporels. Le papier montre que remplacer un split temporel par un split aléatoire ou réduire les variables peut changer les scores et le classement des méthodes.

**Apport au data paper :** argument pour préserver les panels parents, les dates et les variables originales.  
**Conséquence :** une coupe transversale dérivée ne doit pas effacer son lien avec le panel source.

### Datasheets for Datasets — Gebru et al. (2021)

Les datasheets organisent la documentation sur tout le cycle de vie : motivation, composition, collecte, prétraitement, usages, distribution et maintenance. Elles incluent les exclusions, erreurs, usages déconseillés, restrictions et responsabilités de maintenance.

**Apport au data paper :** cadre humain pour définir le contenu minimal des fiches et des Data Records.  
**Conséquence :** une description de colonnes et un DOI ne suffisent pas ; il faut aussi expliquer la production, les transformations, les limites et les usages impropres.

### FAIR — Wilkinson et al. (2016)

FAIR exige que données et métadonnées soient trouvables, accessibles selon des règles explicites, interopérables et réutilisables. Les principes insistent sur les identifiants, la provenance, les relations qualifiées, les vocabulaires, la licence et la persistance des métadonnées.

**Apport au data paper :** cadre machine-actionnable pour relier dataset, article, fichiers bruts, artifact final, formule, géométrie, `W`, tâche, code et résultats.  
**Précision :** FAIR ne signifie pas nécessairement ouvert ou redistribuable sans restriction.

### CAMELS-US — Addor et al. (2017)

CAMELS-US documente 671 bassins, leurs séries hydroclimatiques et six familles d'attributs. Les auteurs fournissent sources, unités, méthodes de dérivation, équations et limites par variable.

**Apport au data paper :** référence forte pour la provenance au niveau des variables et la discussion des incertitudes.  
**Différence avec notre banque :** CAMELS est une ressource scientifique cohérente de domaine ; il ne définit pas une tâche statistique universelle pour chaque usage.

### LamaH-CE — Klingler et al. (2021)

LamaH-CE couvre 859 bassins de neuf pays, des séries quotidiennes et horaires, plusieurs délimitations et un réseau hydrographique explicite. Des contrôles physiques conduisent notamment à exclure une variable jugée non plausible.

**Apport au data paper :** modèle pour les supports multiples, les relations entre unités, les drapeaux de qualité et la justification des exclusions.  
**Leçon :** une banque spatiale doit représenter les réseaux et emboîtements quand ils portent le sens scientifique.

### Caravan — Kratzert et al. (2023)

Caravan harmonise sept ressources régionales en 6 830 bassins, avec forçages, attributs et séries de débit. Le pipeline reproductible permet l'ajout de bassins et conserve des indicateurs sur les écarts géométriques et la fraction de surface utilisée.

**Apport au data paper :** référence pour l'harmonisation multi-source, les contrôles géométriques, la transparence des transformations et l'extension communautaire.  
**Conséquence :** notre contribution ne doit pas être présentée comme la première documentation spatiale rigoureuse.

## 3. Ce que ces onze références permettent d'affirmer

Elles soutiennent quatre propositions principales :

- une collection de datasets, une suite de tâches et un harnais d'exécution sont des objets différents ;
- un split encode une population cible et peut changer les conclusions ;
- une ressource scientifique doit documenter provenance, transformations, qualité, limites, licence et maintenance ;
- des banques spatiales très bien documentées existent déjà, surtout dans des domaines cohérents comme l'hydrologie.

Elles justifient donc un positionnement précis : la nouveauté recherchée est la combinaison d'une couverture spatiale multidomaine, d'une provenance allant jusqu'aux variables et formules publiées, d'une représentation explicite de la géométrie, du temps et de `W`, et d'un passage contrôlé vers des tâches exécutables.

## 4. Littérature méthodologique complémentaire

### 4.1 Concevoir et contrôler une étude de simulation

**Morris, White et Crowther (2019)** fournissent le cadre général : objectifs, facteurs du DGP, méthodes comparées, estimands, métriques, répétitions et erreur Monte-Carlo doivent être spécifiés avant l'analyse. Cette référence est la base pour présenter proprement toute validation semi-synthétique.

**White et al. (2024)** proposent des contrôles concrets d'une simulation : cas limites, valeurs attendues, appariement, variabilité entre répétitions et diagnostics permettant de détecter une erreur de code ou de conception. Cette lecture a conduit à renouveler le champ `g` à chaque répétition de S4.

**Advani, Kitagawa et Słoczyński (2019)** montrent qu'une simulation peut favoriser les estimateurs dont les hypothèses ressemblent au DGP choisi. Le classement issu d'un Monte-Carlo n'est donc pas automatiquement transportable aux données réelles.

**Knaus, Lechner et Strittmatter (2021)** illustrent l'Empirical Monte Carlo Study : les covariables et une partie de la structure empirique sont conservées pour comparer des estimateurs d'effets hétérogènes. L'approche est utile comme précédent, mais son cadre causal fondé sur le traitement ne correspond pas directement à l'objectif de régression spatiale du projet.

**Curth et al. (2021)** critiquent les benchmarks CATE trop dépendants de quelques DGP, datasets ou métriques. Leur leçon générale est de varier les générateurs et de séparer ce qui est observable de la vérité simulée.

### 4.2 Plasmodes et simulations ancrées dans les données réelles

**Schreck et al. (2024)** est la référence centrale sur les plasmodes. Le papier décrit le choix des données réelles, l'ajustement d'un générateur, la définition de la vérité, les interventions, les répétitions, la validation et le reporting. Il avertit contre la circularité lorsqu'on évalue une méthode trop proche du générateur.

**Sauer et al. (2026)** élargissent la réflexion aux simulations paramétriques fondées sur des données réelles. Ils clarifient ce qui est estimé à partir du réel, ce qui est fixé et ce qui est simulé, ainsi que la nécessité de valider la fidélité du générateur.

**RealCause — Neal, Huang et Raghupathi (2021)** ajuste des modèles génératifs aux données puis les sélectionne au moyen de vraisemblance de validation et de tests à deux échantillons. Il montre qu'un test non rejeté ne prouve pas l'égalité des distributions, surtout en grande dimension. RealCause reste une référence de réalisme génératif, mais vise principalement l'inférence causale.

**Stolte et al. (2024, 2025)** comparent plasmodes et simulations paramétriques pour la régression linéaire puis la classification en haute dimension. Ils montrent que l'avantage du plasmode dépend du problème, du générateur et de la propriété évaluée ; le recours à des données réelles n'assure pas automatiquement un benchmark plus juste.

### 4.3 Validation, échelle et dépendance spatiales

**Roberts et al. (2017)** montrent que la validation aléatoire peut être optimiste en présence de structure spatiale, temporelle ou hiérarchique. Les blocs doivent correspondre à la tâche de prédiction. C'est une référence centrale pour justifier les splits spatiaux et les zones tampons.

**Paciorek (2010)** analyse le rôle de l'échelle relative des covariables et du champ spatial dans le biais de confusion spatiale. Une covariable spatialement structurée et un effet latent peuvent être difficiles à séparer. Cette référence soutient la variation de la portée et le contrôle des corrélations entre `X` et les champs simulés.

**The Spatial Confounding Environment — Tec et al. (2024)** propose un environnement de benchmark causal spatial avec données réelles et confusions simulées. Il illustre l'intérêt d'un environnement contrôlé, mais sa notion de traitement ne doit pas être transposée directement au benchmark prédictif du projet.

**Lahiri et Zhu (2006)** étudient le rééchantillonnage pour des régressions spatiales sous plans stochastiques. La référence soutient l'idée que la dépendance et le plan spatial doivent être respectés lors de l'estimation de l'incertitude.

**LeSage et Pace (2018)** demandent aux Monte-Carlo d'économétrie spatiale de varier `W`, la dépendance des covariables, le SNR et la force de dépendance, puis d'évaluer biais, dispersion et MSE des effets directs et indirects. Le papier devient central si le projet évalue ensuite SAR ou SDM ; il ne constitue pas une recette complète pour les champs gaussiens de S4.

**Lopez et Kholodilin (2023)** combinent non-linéarités de type MARS et effets spatiaux dans des modèles hédoniques. Cette étude illustre la nécessité de ne pas opposer artificiellement flexibilité de `f(X)` et structure spatiale.

### 4.4 Changement de support, fusion et erreurs d'observation

**Gotway et Young (2002)** est la référence principale sur les données spatiales incompatibles. Chaque variable possède un support, et l'opérateur reliant ce support au processus latent doit être explicite. Agréger puis transformer diffère généralement de transformer puis agréger. Cette référence soutient S1, S2 et la propagation de l'incertitude par simulation conditionnelle.

**Gelfand et Schliep (2026)** présentent la fusion spatiale fondée sur un processus latent commun à plusieurs sources ponctuelles, aréales ou de type patron de points. Une source peut servir de référence tandis qu'une autre exige une calibration ; calibrer librement toutes les sources crée un problème d'identifiabilité.

**Gryparis et al. (2009)** étudient l'erreur de mesure créée par le désalignement spatial en épidémiologie environnementale. Utiliser une exposition interpolée comme si elle était observée peut modifier les effets estimés et leur incertitude. Cette référence est directement liée à S3.

**Tiedeman et Green (2013)** montrent que des observations dérivées d'une même mesure possèdent des erreurs corrélées. Ignorer la covariance hors diagonale peut sous-estimer ou surestimer l'incertitude selon les sensibilités du modèle. Cette référence soutient les supports recouvrants et les futures observations conditionnantes bruitées.

### 4.5 Simulation géostatistique

**Zakeri et Mariethoz (2021)** fournissent une taxonomie des simulations géostatistiques et insistent sur la validation des réalisations, de leurs distributions et de leurs structures spatiales.

**Gómez-Hernández et Srivastava (2021)** retracent les principes de la simulation séquentielle. La simulation conditionnelle produit plusieurs champs honorant les observations et la structure spatiale, plutôt qu'une unique prédiction lissée.

**Cressie et Pavlicová (2002)** proposent des simulations par moyennes mobiles calibrées sur des covariances usuelles. La référence sert de fondement à la génération contrôlée de champs spatiaux.

### 4.6 Références de contexte plus périphériques

**Huber, Lechner et Wunsch (2010)** portent sur le contrôle d'un grand nombre de covariables par score de propension. Cette référence explique une partie de l'origine des EMCS causaux, mais elle n'est pas centrale pour le data paper spatial.

La bibliographie semi-synthétique contient donc plusieurs références causales utiles comme précédents méthodologiques. Elles ne doivent pas être utilisées pour présenter le projet comme un benchmark de traitement causal.

## 5. Hiérarchie recommandée pour le manuscrit

### Noyau de l'introduction et du positionnement

- PMLB ;
- OpenML Benchmarking Suites ;
- AMLB ;
- Datasheets for Datasets ;
- FAIR ;
- CAMELS-US ;
- LamaH-CE ;
- Caravan.

### Noyau de la discussion sur la validation

- TableShift ;
- TabZilla ;
- TabReD ;
- Roberts et al. ;
- Morris et al.

### Références pour une section ou perspective semi-synthétique

- Schreck et al. ;
- Sauer et al. ;
- White et al. ;
- Paciorek ;
- Gotway et Young ;
- Gelfand et Schliep ;
- Gryparis et al. ;
- Tiedeman et Green ;
- LeSage et Pace.

Les autres références peuvent être mobilisées dans une annexe méthodologique ou dans un article distinct consacré au benchmark semi-synthétique.

## 6. Message scientifique commun

La littérature ne justifie pas seulement la création d'une grande liste de datasets. Elle montre qu'un benchmark utile exige :

- une provenance détaillée et une documentation maintenue ;
- une séparation entre données, tâches, suites et exécutions ;
- des splits correspondant à un usage réel ;
- la conservation des structures spatiales et temporelles ;
- des baselines et budgets comparables ;
- la conservation des erreurs et échecs ;
- des conclusions limitées aux domaines, tâches et générateurs effectivement étudiés.

Le data paper doit donc présenter la banque comme une infrastructure de traçabilité et de préparation de tâches spatiales reproductibles. Les expériences semi-synthétiques renforcent cette infrastructure en montrant comment tester les méthodes sous une vérité contrôlée, mais elles ne doivent pas prendre la place de la description de la ressource dans le manuscrit principal.

## 7. Sources bibliographiques locales

- `extensions_projet_2026-09/revue_jeux_donnees_benchmark/revue_jeux_donnees_benchmark.bib` : 11 références centrales ;
- `extensions_projet_2026-09/revue_donnees_semi_synthetiques/revue_donnees_semi_synthetiques.bib` : 24 références méthodologiques complémentaires ;
- `extensions_projet_2026-09/revue_jeux_donnees_benchmark/lecture_integrale_et_comparaison_2026-09-14.md` : lecture détaillée des 11 références centrales ;
- `extensions_projet_2026-09/revue_donnees_semi_synthetiques/lecture_approfondie_et_geostatistique_2026-09-14.md` : approfondissement des références spatiales et géostatistiques.
