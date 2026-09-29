# Protocole — Mesure du déséquilibre Monte-Carlo / données réelles

**Objet.** Quantifier, dans la littérature de développement méthodologique d'estimateurs de
régression spatiale, l'écart entre l'effort consacré au design de simulations de Monte-Carlo et
le nombre de jeux de données réels mobilisés pour apprécier les performances.

**Statut.** Proposition de protocole, 18 août 2026. Non lancée. Rattachée au data paper,
sans effet sur le calendrier du rapport de stage.

---

## 1. Hypothèse à tester

Dans la littérature en statistiques spatiales, économétrie spatiale et géographie quantitative
orientée développement d'estimateurs, les auteurs investissent un effort substantiel dans la
construction de processus générateurs de données couvrant une variété de configurations, mais
n'évaluent leurs propositions que sur un à trois jeux de données réels, très rarement davantage.

Cette hypothèse est l'argument fondateur de la banque : si elle est vraie, le déficit n'est pas
un défaut de rigueur des auteurs mais une conséquence de l'indisponibilité de matériel empirique
standardisé, et une ressource comme celle décrite par l'article y répond directement.

## 2. Variables à coder, par article

| Variable | Définition | Type |
|---|---|---|
| `n_dgp_cells` | Nombre de combinaisons de paramètres effectivement simulées (produit des niveaux du plan factoriel réellement exécuté) | entier |
| `n_dgp_structures` | Nombre de structures génératrices qualitativement distinctes (SAR, SEM, SARAR, non-linéaire, hétéroscédastique, coefficients variables...) | entier |
| `dgp_axes` | Ensemble des axes effectivement variés | ensemble codé |
| `n_replications` | Nombre de réplications par cellule | entier |
| `n_real_datasets` | Nombre de jeux de données empiriques distincts | entier |
| `n_real_with_perf` | Parmi ceux-ci, ceux servant à une comparaison de performance chiffrée | entier |
| `real_dataset_names` | Identification des jeux (pour mesurer la concentration sur quelques jeux canoniques) | texte |
| `has_oos_evaluation` | Présence d'une évaluation hors échantillon sur données réelles | booléen |
| `cv_scheme_declared` | Schéma de validation déclaré sur données réelles, le cas échéant | catégoriel |

`dgp_axes` est codé sur une liste fermée : taille d'échantillon, intensité de la dépendance
spatiale, structure de la matrice de voisinage, distribution des erreurs, hétéroscédasticité,
non-linéarité de la relation, corrélation entre covariables, erreur de mesure sur les covariables,
données manquantes, irrégularité de la géométrie. C'est probablement la variable la plus
informative de l'étude : elle permet de dire non seulement *combien* de configurations sont
testées, mais *lesquelles ne le sont jamais*.

## 3. Règles de comptage

**Deux comptes distincts pour les DGP, jamais un seul.** Un plan « n ∈ {100, 500, 1000} × ρ ∈
{0.2, 0.5, 0.8} × W ∈ {rook, queen} » vaut `n_dgp_cells = 18` et `n_dgp_structures = 1`. Le
premier chiffre rend le contraste visible, le second mesure la diversité réellement couverte.
Les rapporter séparément évite l'objection immédiate selon laquelle faire varier ρ sur une grille
ne couvre pas des situations empiriques différentes.

**Un jeu de données réel est compté une fois.** Plusieurs tableaux, plusieurs modèles ou
plusieurs sous-périodes issus de la même source comptent pour un. Cette règle est exactement
celle qu'applique l'unité d'analyse par source du moteur de comparaison du package : la
cohérence est voulue et mérite d'être signalée dans l'article.

**Exclusions.** Les jeux cités dans une revue de littérature sans être analysés ne comptent pas.
Un jeu utilisé uniquement pour illustrer une carte, sans métrique associée, est compté dans
`n_real_datasets` mais pas dans `n_real_with_perf`.

## 4. Critères d'inclusion des articles

Sont inclus les articles qui proposent un estimateur, une procédure d'inférence ou un
protocole d'évaluation nouveaux pour la régression spatiale ou spatio-temporelle, ou qui
comparent systématiquement plusieurs estimateurs existants. Sont exclus les applications
empiriques n'apportant pas de contribution méthodologique, les revues de littérature, les
articles logiciels et les data papers. Fenêtre : publications postérieures à 2015.

## 5. Base de sondage

### 5.1 Ce que permet le corpus actuel

Le fichier `corpus/bib/references.bib` contient 182 références, dont 142 postérieures à 2015 et
130 munies d'un DOI. Leur répartition par type de revue est la suivante :

| Type de revue (post-2015) | Effectif |
|---|---:|
| Revue méthodologique (statistique, économétrie, SIG) | 25 |
| Revue applicative ou disciplinaire | 37 |
| Autre, majoritairement applicatif (écologie, environnement, agronomie) | 50 |
| Sans revue (ouvrage, manuel, preprint) | 30 |

Ce corpus a été constitué pour **trouver des jeux de données**, non pour échantillonner la
littérature méthodologique. Il est donc dominé par des applications. Après filtrage sur les
critères d'inclusion, on peut raisonnablement en attendre vingt à trente articles éligibles.

### 5.2 Conséquence sur le phasage

Vingt à trente articles suffisent à calibrer la grille de codage et à mesurer l'accord entre
extraction automatique et codage humain, mais ne suffisent pas à produire un chiffre publiable,
et surtout ne portent pas sur la population visée par l'hypothèse. Le corpus actuel doit donc
servir de **pilote**, pas de base de sondage.

La base de sondage définitive doit être construite pour cet objet, stratifiée par revue. Liste
de départ proposée : *Journal of Geographical Systems*, *Geographical Analysis*, *Spatial
Statistics*, *Spatial Economic Analysis*, *Regional Science and Urban Economics*, *Papers in
Regional Science*, *International Journal of Geographical Information Science*, *Annals of the
American Association of Geographers*, *Environment and Planning B*, *Journal of Econometrics*,
et pour le versant écologie méthodologique *Ecography* et *Methods in Ecology and Evolution*.
La constitution se fait par requête OpenAlex/Crossref sur ces revues, filtrée par concept et
par fenêtre temporelle, puis par écrémage manuel sur titre et résumé.

### 5.3 Biais à déclarer

Le corpus pilote est biaisé **en faveur** des articles disposant de données ouvertes, puisque
c'est le critère qui a présidé à sa constitution. Ce biais joue dans le sens conservateur pour
l'hypothèse testée : si même un corpus sélectionné pour la disponibilité des données montre un
à trois jeux réels par article, le cas général est nécessairement au moins aussi défavorable.
Cet argument doit être énoncé explicitement plutôt que laissé implicite.

## 6. Procédure de codage et validation

L'extraction s'appuie sur la chaîne déjà en place : conversion des PDF par GROBID, puis
extraction assistée par modèle de langage des sections de simulation et d'application. Une
affirmation quantitative dans un article à comité de lecture exige toutefois un taux d'erreur
mesuré. La procédure retenue est donc en trois temps.

L'extraction automatique est appliquée à l'ensemble des articles retenus. Un sous-échantillon
aléatoire d'au moins vingt-cinq articles est ensuite codé manuellement, en double aveugle si
un second codeur est disponible. L'accord entre codage automatique et codage humain est enfin
rapporté : accord exact sur les compteurs entiers, et coefficient d'accord sur la variable
`dgp_axes`, qui est catégorielle et multiple. Les désaccords systématiques donnent lieu à une
révision de la grille avant relance.

Cette procédure applique à l'étude bibliométrique la même règle que le projet applique à ses
fiches : le modèle propose, l'humain valide, et le taux de validation est publié plutôt que
supposé.

## 7. Restitution dans l'article

**Background & Summary.** Un paragraphe portant les chiffres de synthèse : médiane et étendue
du nombre de configurations simulées, médiane et étendue du nombre de jeux réels, part des
articles à un seul jeu réel, et concentration sur les jeux canoniques. C'est le paragraphe
d'enjeux situés demandé.

**Methods.** Une sous-section décrivant la base de sondage, les critères d'inclusion, les règles
de comptage et la validation du codage. Une affirmation quantitative sans protocole déclaré
serait fragile en évaluation.

**Figure.** Un nuage de points par article, nombre de cellules simulées en abscisse
logarithmique contre nombre de jeux réels en ordonnée. Le contraste attendu — plusieurs
dizaines contre un ou deux — se lit immédiatement.

**Tableau.** Fréquence de chaque axe de variation dans les plans de simulation, qui documente
ce que les designs couvrent et surtout ce qu'ils ne couvrent jamais.

## 8. Faisabilité et charge

Les textes intégraux ne sont pas présents sur le poste courant : `corpus/papers/raw_pdf` est
vide et les TEI sont exclus du dépôt. La construction de la base de sondage, la grille de
codage et le script d'extraction peuvent être préparés ici ; la passe d'extraction doit être
exécutée là où résident les PDF, ou après une campagne de récupération en libre accès.

Charge estimée pour la phase pilote : la préparation de la grille et du script relève de la
journée ; le codage manuel de vingt-cinq articles, à quinze ou vingt minutes pièce lecture
comprise, représente une journée supplémentaire. La phase définitive, sur une base stratifiée
de l'ordre de cent à cent cinquante articles, est un chantier de plusieurs jours.

## 9. Décisions attendues

1. Confirmer que le corpus actuel sert de pilote et non de base de sondage définitive.
2. Valider ou amender la liste de revues de la base stratifiée.
3. Indiquer si un second codeur humain est mobilisable pour le double aveugle.
4. Confirmer que ce chantier reste postérieur au dépôt du rapport de stage.
