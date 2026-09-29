# Lecture intégrale et comparaison des articles complémentaires

Date : 14 septembre 2026  
Périmètre : les onze PDF de `articles_complementaires_2026-09-09/`, lus dans leur intégralité, annexes méthodologiques comprises lorsqu'elles précisent sélection, splits, métriques, contrôles ou limites.

## Conclusion générale

Les articles distinguent quatre objets que le data paper doit séparer : une **collection standardisée de datasets** comme PMLB ; une **suite de tâches versionnée** comme OpenML, où chaque tâche fixe cible, splits et métrique ; un **harnais d'exécution** comme AMLB, qui fixe ressources, versions et traitement des erreurs ; et une **banque scientifique de domaine** comme CAMELS, LamaH-CE ou Caravan, qui documente construction, géométrie, sources, contrôles et limites.

Notre banque est aujourd'hui proche des premier et quatrième objets. Elle ne doit revendiquer le deuxième que pour les entrées disposant d'une tâche exécutable figée, ni le troisième sans run effectivement exécuté et conservé.

## Lecture des onze articles

### OpenML Benchmarking Suites — Bischl et al.

OpenML prend la tâche comme unité reproductible : dataset, type de problème, cible, procédure d'évaluation, splits exacts et métrique. Une suite est une sélection curatée de tâches sous des conditions explicites, avec un identifiant stable. Les runs relient pipeline, hyperparamètres, prédictions et scores. OpenML-CC18 montre que la sélection exige filtrage, inspection manuelle et retrait des tâches trop faciles, redondantes, artificielles, temporelles ou problématiques. Les auteurs signalent le risque de surapprentissage collectif sur une suite figée, l'absence initiale de contraintes de ressources dans les tâches et le besoin d'une documentation éthique structurée.

**À retenir :** séparer l'identité du dataset de celle de la tâche ; versionner suites et splits.

### PMLB v1.0 — Romano et al.

PMLB agrège des datasets publics dans des interfaces uniformes R et Python. Chaque dataset possède un `metadata.yaml`, une URL source, des publications, mots-clés et descriptions de variables, ainsi qu'un profil automatique. Le schéma est formalisé en JSON Schema et les contributions génèrent statistiques, profil et gabarit de métadonnées. PMLB résout surtout accès, homogénéité et contrôle élémentaire ; il ne fixe pas pour chaque dataset une tâche scientifique et un split substantif.

**À retenir :** ajouter aux fiches narratives un noyau machine-validable.

### AMLB — Gijsbers et al.

AMLB automatise installation, données, ressources, exécution, prédictions, métriques et erreurs. L'étude emploie 71 tâches de classification et 33 de régression issues d'OpenML. Temps, CPU, mémoire et stockage sont déclarés séparément des tâches. Les échecs ne sont pas aléatoires : les ignorer peut avantager un système qui échoue sur les cas difficiles ; le papier propose une pénalisation par baseline constante. Il examine aussi temps d'inférence, chevauchement avec les données de méta-apprentissage et limites d'un classement global.

**À retenir :** versions, ressources, timeout, prédictions et échecs font partie des résultats.

### TableShift — Gardner et al.

TableShift comprend 15 tâches de classification binaire avec domaines d'entraînement et de test explicites. Les données sont réelles, publiques, documentées, hétérogènes et suffisamment grandes ; une baseline réglée doit présenter un shift gap significatif. L'API reconstruit les tables depuis les sources brutes et conserve types, codages, transformations et valeurs manquantes. Parmi 19 méthodes, aucune méthode robuste ne domine uniformément les bonnes baselines. Les conclusions restent limitées aux shifts et modèles observés.

**À retenir :** un split spatial ou temporel encode une cible de transfert, pas un simple réglage technique.

### Datasheets for Datasets — Gebru et al.

La datasheet suit sept étapes du cycle de vie : motivation, composition, collecte, prétraitement/nettoyage/étiquetage, usages, distribution et maintenance. Elle couvre instances, relations, splits, erreurs, ressources externes, échantillonnage, période, transformations, brut, usages déconseillés, licence, restrictions et maintenance. Les réponses doivent être factuelles et développées. Une datasheet ne garantit ni absence de biais ni innocuité ; elle rend choix et limites visibles et doit évoluer avec chaque version.

**À retenir :** compléter les blocs techniques par collecte, exclusions, usages déconseillés et maintenance.

### TabZilla — McElfresh et al.

L'étude compare 19 algorithmes sur 176 datasets OpenML, jusqu'à 30 configurations et dix folds, soit plus d'un demi-million d'ajustements. Souvent, l'écart NN–GBDT est négligeable, une baseline simple suffit ou un réglage léger compte davantage que la famille. Les GBDT sont meilleurs en moyenne et plus robustes aux distributions irrégulières. TabZilla retient 36 datasets difficiles après observation des résultats : les baselines simples n'y gagnent pas et peu d'algorithmes atteignent la meilleure performance.

**À retenir :** la difficulté doit être démontrée par un pilote multi-méthodes.

### TabReD — Rubachev et al.

TabReD rassemble huit datasets industriels ou issus de compétitions reconstruites, avec splits temporels et variables riches proches de la production. Les auteurs relèvent dans les benchmarks académiques données synthétiques, non traçables, dupliquées ou affectées par des fuites. Remplacer les splits temporels par des splits aléatoires modifie scores et classement ; réduire les variables change aussi les conclusions. Certaines méthodes de voisinage ou d'entraînement long perdent leur avantage sous dérive temporelle et multicolinéarité.

**À retenir :** préserver dates, panels parents et usage prospectif ; ne pas casser systématiquement les panels en coupes.

### FAIR — Wilkinson et al.

FAIR demande identifiant persistant, métadonnées riches et indexées, accès standard, persistance des métadonnées, formats et vocabulaires partagés, relations qualifiées, licence claire, provenance et standards du domaine. FAIR ne signifie pas ouverture sans restriction : authentification et contrôle d'accès sont compatibles s'ils sont explicites. Workflows et logiciels sont également concernés.

**À retenir :** relier dataset, article, brut, conversion, formule, géométrie, W, tâche, splits, code et résultats par des identifiants stables.

### CAMELS-US — Addor et al.

CAMELS-US associe 671 bassins peu influencés par l'activité humaine, des séries quotidiennes de météo et débit et six familles d'attributs : topographie, climat, hydrologie, occupation du sol, sols et géologie. Les séries sources couvrent 1980–2014 ; les signatures principales utilisent 1990–2009. Le papier donne équations, unités, sources et limites par attribut et compare plusieurs estimations de certaines quantités. Il ne fixe cependant ni réponse, ni formule, ni split universels.

**À retenir :** modèle fort pour la documentation scientifique par variable, à compléter par une couche de tâches.

### LamaH-CE — Klingler et al.

LamaH-CE couvre 859 bassins dans neuf pays, plus de 60 attributs et des séries quotidiennes et horaires, principalement 1981–2017. Il offre trois délimitations, dont les bassins intermédiaires, la hiérarchie des stations et les connexions hydrographiques. Un modèle hydrologique conceptuel sert de contrôle et de baseline. Les incohérences entre produits sont documentées ; une PET ERA5-Land jugée non plausible est exclue.

**À retenir :** référence pour plusieurs supports spatiaux, relations entre unités, variables exclues et qualité temporelle.

### Caravan — Kratzert et al.

Caravan harmonise sept banques régionales en 6 830 bassins, avec débit quotidien, forçages ERA5-Land et attributs HydroATLAS. La période maximale est 1981–2020 et la longueur médiane des débits est de 31 ans. Le code permet d'ajouter des bassins via Google Earth Engine. Le papier documente les écarts de frontières entre modèles de terrain, filtre les petites intersections parasites, publie la fraction de surface utilisée et compare les forçages à plusieurs produits CAMELS-US. Cinq desiderata sur six sont satisfaits ; l'incertitude n'est pas estimée pour toutes les composantes.

**À retenir :** référence pour harmonisation multi-source, pipeline reproductible, indicateurs géométriques et extension communautaire.

## Comparaison des suites tabulaires

| Système | Objet | Ce qui est figé | Leçon pour notre banque |
|---|---|---|---|
| OpenML | suite de tâches | cible, splits, métrique, procédure | identifiant de tâche distinct du dataset |
| PMLB | collection standardisée | format, schéma, métadonnées | fiches validables et interface uniforme |
| AMLB | harnais d'exécution | ressources, versions, erreurs, sorties | traiter timeout et échecs comme résultats |
| TableShift | transfert hors domaine | domaines train/test | déclarer la cible du split |
| TabZilla | difficulté empirique | 36 tâches après résultats multi-méthodes | démontrer la difficulté |
| TabReD | réalisme temporel | chronologie et variables riches | préserver temps et panels parents |

Le schéma adapté comprend quatre objets : `Dataset`, `BenchmarkTask`, `BenchmarkSuite` et `BenchmarkRun`. Le catalogue peut contenir des datasets sans tâche ; le noyau exécutable ne contient que des tâches validées.

## Exigences documentaires du data paper

### Par dataset

- identifiant stable, version, citation, responsables et financement ;
- unité statistique, support spatial, étendues géographique et temporelle ;
- population source, collecte et échantillonnage ;
- sources et relations avec article, dépôt et fichiers ;
- dictionnaire des variables avec unités, types, codages, transformations et valeurs manquantes ;
- provenance distincte de Y, X, coordonnées, géométrie et W ;
- nettoyage, exclusions, agrégations et dérivations ;
- contrôles de qualité, erreurs, incertitudes et limites ;
- licence et restrictions des ressources externes ;
- usages prévus, usages déconseillés et risques de fuite ;
- maintenance, erratum et politique de version ;
- brut conservé ou indisponibilité justifiée ;
- métadonnées exportables dans un schéma machine-lisible.

### Par tâche benchmark

- réponse, formule ou ensemble de prédicteurs autorisés ;
- population d'inférence et objectif : interpolation, extrapolation, prévision ou nouvelles unités ;
- splits exacts, graine et justification ;
- métriques, baseline et estimateurs éligibles ;
- tuning, budget, timeout et règle pour résultats manquants ;
- versions du code et des dépendances ;
- prédictions, scores par fold et manifeste d'exécution.

### Exigences spatiales

- CRS, géométrie originale et transformée ;
- niveau spatial de chaque variable et méthode d'agrégation ;
- définition, style, ordre et provenance de W ;
- unités sans voisin et politique appliquée ;
- relations, emboîtements ou réseau entre unités ;
- dépendance temporelle et parent panel des coupes ;
- compatibilité du split avec l'usage visé.

## CAMELS, LamaH-CE et Caravan face à notre banque

| Dimension | CAMELS-US | LamaH-CE | Caravan | Notre banque spatiale |
|---|---|---|---|---|
| Portée | 671 bassins CONUS | 859 bassins, 9 pays | 6 830 bassins mondiaux | domaines et supports hétérogènes |
| Temps | quotidien, 1980–2014 | quotidien/horaire, 1981–2017 | quotidien, 1981–2020 | variable, parfois panel + coupes |
| Structure | bassins et attributs agrégés | 3 délimitations + réseau | 7 banques harmonisées | points, polygones, grilles, réseaux, panels |
| Provenance | source par attribut | source, méthode et limites par attribut | pipeline ERA5-Land/HydroATLAS | pedigree, article, brut, conversion, formule |
| Qualité | comparaison de sources | drapeaux, complétude, contrôles physiques | intersections et forçages contrôlés | audits automatiques et revues de fidélité |
| Benchmark | pas de tâche universelle | baseline de domaine | références, pas de suite universelle | tâches explicites pour un noyau admis |
| Extension | banque nationale | banque régionale versionnée | code communautaire d'ajout | catalogue extensible par fiches et pipelines |

La différenciation défendable n'est pas que les banques spatiales existantes seraient mal documentées. Ces trois banques hydrologiques sont des références fortes. Notre apport potentiel est transversal : réunir plusieurs domaines et supports, conserver la provenance jusqu'à la formule publiée et ajouter, pour un sous-ensemble explicite, une couche de tâches et d'exécution statistique reproductible.

## Limites

La lecture porte sur les PDF locaux, parfois versions auteur. Elle établit le contenu des articles mais ne vérifie pas l'état actuel des plateformes après publication. Aucun dataset hydrologique n'a été téléchargé ou exécuté pendant cette étape.
