# Complément de lecture — plasmode spatial
Date : 9 septembre 2026  
Objet : identifier les recherches bibliographiques encore utiles au data paper, après le choix de se limiter au plasmode.

## Conclusion de travail

La recherche à poursuivre porte surtout sur **la validité du benchmark plasmode spatial**, plutôt que sur une nouvelle grande famille de génération. Cinq questions restent prioritaires : choix du support et du rééchantillonnage ; dépendance des classements au générateur ; réalisme spatial ; mécanismes d'observation ; représentativité des jeux sources.

Ce document distingue les constats tirés des textes, les propositions pour le projet et les lectures encore nécessaires. Il ne constitue pas une revue systématique exhaustive et ne démontre aucune absence de travaux antérieurs. Aucun résultat du pilote, aucune admission de dataset et aucun PDF existant n'ont été modifiés.

## 1. Ce qui a effectivement été consulté

Le KG local a été interrogé sur « plasmode » : aucun résultat. Les six PDF du dossier de revue ont ensuite été extraits et consultés. La lecture est ciblée sur les définitions, générateurs, limites et perspectives ; **les centaines de pages d'annexes n'ont pas été relues intégralement**.

| Source locale | Version réellement présente et couverture de cette lecture |
|---|---|
| [Schreck et al.](papiers_lus/schreck_2024_plasmode.pdf) | Le fichier nommé 2024 contient arXiv:2305.06028v1, 10 mai 2023, 24 pages. Lecture étendue des sections 1–4, de la discussion et des références ; exemple numérique consulté. Définition et perspectives recoupées avec le texte publié en 2024. |
| [Huber, Lechner et Wunsch](papiers_lus/huber_lechner_wunsch_2013.pdf) | IZA DP 5268, octobre 2010, 65 pages, intitulé « How to Control for Many Covariates? ». Lecture du principe EMCS, de sa population et des conclusions. Ce n'est pas le PDF de l'édition de revue de 2013. |
| [Advani, Kitagawa et Słoczyński](papiers_lus/advani_kitagawa_sloczynski_2019.pdf) | arXiv:1809.09527v2, avril 2019, 33 pages. Introduction, définitions, discussion et tableau 3 consultés ; pas d'audit complet des démonstrations. |
| [Knaus, Lechner et Strittmatter](papiers_lus/knaus_lechner_strittmatter_emcs.pdf) | Version décembre 2018, 112 pages. Section 5 sur le DGP et section 7 lues ; annexes exhaustives non relues. |
| [RealCause — Neal et al.](papiers_lus/neal_realcause_2020.pdf) | 40 pages. Sections 3–5, résultats sur le lien prédiction/estimation causale, discussion et annexe A consultés. |
| [SpaCE — Tec et al.](ICLR-2024-space-the-spatial-confounding-environment.pdf) | PDF ICLR 2024, 22 pages. Sections 2–4 et discussion consultées, particulièrement l'apprentissage de f, les résidus et le masquage. |

Lectures complémentaires ciblées dans les textes accessibles : Stolte et al. 2024 et 2025 ; Sauer et al. 2026 ; Curth et al. 2021 ; Shaw et al., prépublication 2025 ; Lahiri et Zhu 2006 ; Paciorek 2010 ; Gotway et Young 2002. Les sections et limites pertinentes sont précisées ci-dessous.

Franklin 2014 : notice bibliographique vérifiée, mais les accès au texte intégral PMC/Europe PMC ont échoué pendant cette session. Roberts 2017 : résumé détaillé de la source institutionnelle consulté ; lien PDF WSL devenu indisponible. López et Kholodilin 2023 : référence et dépôt institutionnel retrouvés, mais récupération du texte non aboutie. Ces sources ne sont donc pas comptées comme lectures intégrales.

## 2. Ce que les articles changent dans notre raisonnement

### Schreck : le plasmode ne garantit pas le réalisme de Y

Les sections 3–4 et la conclusion discutent trois fragilités : le rééchantillonnage, la représentativité du jeu source et le modèle générant la réponse. Ce dernier peut avantager les méthodes qui lui ressemblent. Les auteurs proposent aussi de travailler sur les distances entre données réelles et simulées. Leurs OGMs peuvent être estimés, issus de la littérature ou fixés par le chercheur : « ajusté par ML » n'est pas une condition de définition. [Article publié](https://onlinelibrary.wiley.com/doi/10.1002/sim.10012).

**Pour nous :** préserver X et la carte est une propriété vérifiable ; prétendre reproduire le vrai mécanisme de Y est une affirmation beaucoup plus forte. Les valeurs imposées de lambda, f, g et du bruit définissent des scénarios contrôlés, pas une vérité retrouvée sur le terrain.

### Stolte 2024 : le papier directement pertinent pour la régression

Cette étude évalue l'estimation de la MSE des coefficients des moindres carrés, pas l'erreur prédictive. Elle compare différentes stratégies plasmodes, dont **l'absence de rééchantillonnage**. Une petite proportion de sous-échantillonnage y signifie tirer une taille finale donnée depuis une base source plus grande ; elle ne justifie pas de réduire arbitrairement la taille finale étudiée. Les auteurs envisagent de garder tout X lorsque la base disponible a déjà la taille cible. Le cadre reste non spatial et relativement simple. [Texte, protocole et discussion](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0299989).

**Décision proposée :** conserver le mode X/sites/W fixes du pilote comme référence conditionnelle. Étudier un second mode de rééchantillonnage uniquement après avoir défini la population et la taille cible. Attention : le « wild Bootstrap » testé dans cet article transforme les covariables ; son classement ne condamne pas le wild bootstrap des résidus.

### Stolte 2025 : les conclusions sur le rééchantillonnage ne sont pas universelles

La suite compare cinq classifieurs et la récupération de leurs performances et classements. Aucun schéma de rééchantillonnage ne domine partout ; ne pas rééchantillonner donne souvent de bons résultats. Une mauvaise spécification de l'OGM affecte aussi le plasmode. L'étude fixe notamment n = 100 et ne valide pas les méthodes spatiales. [Méthodes et discussion](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0322887).

**Pour nous :** il faut distinguer un bon niveau de performance simulée d'un classement fiable. Cette piste est déjà partiellement couverte depuis Schreck : il serait inexact de la présenter comme entièrement vierge.

### Advani et Curth : la ressemblance avec le réel ne garantit pas le bon classement

Advani analyse deux designs EMCS causaux et les conditions nécessaires à leur utilisation pour choisir un estimateur. La recommandation transférable est de tester la sensibilité aux caractéristiques du DGP. Ce n'est pas un théorème interdisant tous les plasmodes.

Curth et al. montrent comment les choix de générateurs semi-synthétiques peuvent avantager des approches ; leur discussion inclut explicitement les modèles ajustés sur des données réelles. [Article NeurIPS 2021](https://datasets-benchmarks-proceedings.neurips.cc/paper/2021/hash/2a79ea27c279e471f4d180b08d62b00a-Abstract-round2.html).

**Proposition pour le pilote :** croiser au moins deux familles de générateurs de f, par exemple polynôme/GAM et arbres, avec les mêmes familles d'estimateurs, puis mesurer la stabilité des différences de risque et des rangs. L'ensemble de modèles de SpaCE est une stratégie pour limiter les préférences, pas une preuve de neutralité.

### RealCause et SpaCE : reprendre des idées précises

RealCause rééchantillonne les covariables et apprend les distributions conditionnelles. Les diagnostics de distributions et les paramètres de variation sont intéressants. Toutefois, l'absence de rejet d'un test à deux échantillons ne prouve pas l'égalité des distributions ; la puissance et la sélection du générateur sur les mêmes diagnostics comptent.

SpaCE apprend une réponse puis simule un nouveau bruit spatial avant de masquer des variables. Il emploie une séparation spatiale avec exclusion de voisins pour calibrer le prédicteur. Son objectif demeure causal. [Article officiel SpaCE](https://proceedings.iclr.cc/paper_files/paper/2024/file/d2155b1f7eb42350d7bc3013eefe5480-Paper-Conference.pdf).

**Proposition :** contrôler distributions, relations Y–X, variogrammes, Moran à plusieurs voisinages et performances hors calibration. Pour les scénarios volontairement perturbés, vérifier les propriétés annoncées comme conservées et la force de la perturbation ; ne pas exiger qu'ils soient tous indiscernables des données originales.

### Shaw 2025 : une alerte spécifique, à ne pas généraliser

Le texte compare la conservation du traitement observé avec sa régénération dans des plasmodes causaux. Le premier schéma peut fausser l'évaluation de méthodes fondées sur les scores de propension. La discussion ne constitue pas une objection directe à notre régression sans traitement. [Prépublication, sections 3–6](https://arxiv.org/html/2504.11740v1).

Huber et Knaus restent utiles pour comprendre le contraste avec le plasmode retenu. Leurs questions de traitement placebo, d'hétérogénéité causale et d'agrégation des effets ne sont pas les priorités de recherche du data paper actuel.

## 3. Les recherches spatiales encore nécessaires

### A. Rééchantillonnage : quelle unité et quelle cible ?

Lahiri et Zhu montrent qu'une extension naturelle du bootstrap par blocs de grilles régulières peut échouer sur des sites irréguliers à densité non uniforme. Ils proposent un autre mécanisme et en établissent la validité sous leurs hypothèses. Introduction et cadre consultés, preuves non auditées. [Texte](https://arxiv.org/pdf/math/0611261).

**Recherche à faire :** comparer les cadres de support fixe, sous-domaines et blocs pour nos points et polygones ; définir ce que deviennent les frontières et W. La théorie de ce papier ne valide pas automatiquement un rééchantillonnage de covariables suivi d'un nouvel OGM.

**Question à trancher :** veut-on décrire les méthodes sur cette carte observée, ou généraliser à de nouvelles cartes ? C'est le choix scientifique qui précède le choix de bootstrap.

### B. Échelle : varier lambda seul ne suffit pas

Paciorek étudie l'effet des échelles relatives de X et d'une variable spatiale omise sur le biais et la précision. Un terme spatial n'élimine pas automatiquement le biais ; la variation de X à une échelle plus fine joue un rôle essentiel dans son cadre. Sections 2.4–2.6, 3 et conclusion consultées. [Texte](https://arxiv.org/pdf/1011.1139).

**Recherche à faire :** relier nos paramètres natifs à une portée effective et à une proportion de variance spatiale ; comparer les échelles du signal expliqué, du terme omis et du bruit. Deux W et deux géométries avec le même lambda ne définissent pas nécessairement la même difficulté.

### C. Observation et changement de support : la piste la plus différente de D9

Gotway et Young examinent les problèmes de résolution, d'agrégation et de supports incompatibles. Leurs sections 2 et 3.3 expliquent notamment pourquoi les opérations non linéaires et l'agrégation ne sont pas interchangeables, et discutent la simulation conditionnelle. [Texte des auteurs](https://www.researchgate.net/profile/Linda-Young-13/publication/4745466_Combining_Incompatible_Spatial_Data/links/58c3f85745851538eb868f3b/Combining-Incompatible-Spatial-Data.pdf).

Les deux constructions suivantes sont **nos propositions mathématiques**, inspirées de cette problématique, pas des DGP attribués tels quels à l'article.

1. **Lissage ou supports recouvrants.** Partir de Y* = f(X) + epsilon, avec Cov(epsilon | X) = sigma² I, puis observer Yobs = H Y*. Alors Cov(Yobs | X,H) = sigma² H H'. Des lignes de H qui partagent des poids peuvent créer une covariance entre observations, sans interaction entre réponses dans le mécanisme latent. Le processus d'observation, lui, est spatial. Des agrégats disjoints d'erreurs indépendantes ne créent pas cet effet par simple agrégation.
2. **Agrégation d'une relation non linéaire.** En général, moyenne(f(X)) diffère de f(moyenne(X)). Une information de dispersion ou d'interaction interne aux zones peut manquer à l'analyste ; si cette information présente une organisation géographique, l'erreur de moyenne peut en présenter une aussi.

**Recherche à faire :** changement de support, erreurs issues de covariables interpolées, incertitude de géocodage, supports recouvrants et erreurs de mesure spatiales. L'échantillonnage préférentiel est une piste secondaire : vérifier ses conditions précises avant de le qualifier de mécanisme « aspatial ». [Point d'entrée : Diggle et al. 2010](https://www.stat.ubc.ca/~jim/Diggle2010.pdf), résumé consulté seulement.

### D. Validation : interpolation ou transfert géographique ?

Roberts et al. soulignent que la validation bloquée peut révéler des erreurs masquées par les dépendances, mais qu'elle peut aussi transformer une tâche d'interpolation en extrapolation. [Notice institutionnelle](https://epub.uni-regensburg.de/39299/), résumé consulté.

**Recherche à faire :** fixer la distance train–test et le domaine visé avant de choisir les folds ; distinguer validation du générateur sur Y réel et évaluation des estimateurs sur Y simulé. Nos bandes géographiques sans zone tampon et notre calibration entrelacée ne suffisent pas à établir une capacité de transfert vers un nouveau territoire.

### E. Sources réelles : quels domaines représente la banque ?

Sauer et al. proposent de rendre systématique la sélection des datasets et d'expliciter les composants appris ou imposés des générateurs. Ils indiquent que plusieurs de leurs considérations valent pour la partie paramétrique des simulations semi-paramétriques. Leur article, mentionné comme prépublication 2025 dans la revue, dispose maintenant d'une version publiée en 2026. Workflow et conclusion consultés. [Version publiée](https://wires.onlinelibrary.wiley.com/doi/10.1002/wics.70074).

**Proposition :** définir une matrice de couverture : points/polygones, tailles, densités spatiales, distributions de Y, domaines d'application et information disponible. Georgia et Meuse permettent une preuve de faisabilité ; multiplier les réplications sur ces deux supports n'élargit pas cette couverture.

## 4. Nuance indispensable sur « DGP aspatial »

Pour les scénarios d'interaction ou de courbure omise, le modèle complet peut avoir des erreurs indépendantes conditionnellement à X. Le résidu du modèle incomplet contient cependant une fonction structurée de X. Une carte de résidus ou un Moran élevé ne prouve donc pas une dépendance entre innovations.

Par exemple, si Y = beta1 X1 + beta2 X2 + gamma X1 X2 + epsilon et que l'analyste omet le produit, le résidu contient la partie de ce produit non expliquée par les termes retenus. **L'autocorrélation positive de X1 et X2 ne garantit pas à elle seule que cette partie sera forte ou spatialement autocorrélée.** Il faut le mesurer, ce que les résultats faibles du pilote rendent particulièrement pertinent.

Il convient donc de distinguer :
- erreurs de forme ou d'information dans la moyenne ;
- covariance spatiale des innovations ;
- covariance créée par l'observation.

Cette distinction rend les prochaines recherches plus précises que l'expression générale « apparence de spatial ».

## 5. Ordre de travail recommandé

| Priorité | Travail bibliographique | Résultat concret attendu |
|---|---|---|
| 1 | Finaliser Stolte 2024/2025 et confronter aux hypothèses de Lahiri–Zhu | Une justification écrite du support fixe ; un protocole séparé si rééchantillonnage |
| 1 | Schreck, Curth et discussion des générateurs de SpaCE | Une analyse de sensibilité aux familles de f, avec classement et écarts de risque |
| 1 | Gotway–Young ; récupérer López–Kholodilin en texte intégral | Deux scénarios d'observation précisément définis ; distinguer apport nouveau et simple variante de D9 |
| 2 | Paciorek, puis modèles géostatistiques et simulation conditionnelle | Une calibration de la portée et des composantes spatiales de g et u |
| 2 | Roberts en texte intégral et Sauer 2026 | Une cible de transfert explicite et des critères de sélection des jeux sources |
| Transversal | Morris–White–Crowther 2019, puis « How to check a simulation study » | Précision Monte Carlo, scénarios de contrôle, traitement des échecs |

[Morris et al., tutoriel](https://discovery.ucl.ac.uk/10066118/1/2019%20-%20Morris%20-%20simulation%20studies%20tutorial%20-%20stat%20med.pdf) : passages sur ADEMP et erreur Monte Carlo consultés. [How to check a simulation study](https://pmc.ncbi.nlm.nih.gov/articles/PMC10859132/) : points clés consultés ; lecture complète encore à faire.

La précision doit porter notamment sur les **différences appariées** entre méthodes. Les 20 réplications du pilote constituent une vérification de faisabilité ; le nombre de réplications final devra découler d'une précision recherchée. La variabilité des tirages, celle de la calibration et celle entre datasets sources sont trois niveaux différents.

## 6. Corrections documentaires à prévoir

- Remplacer le statut global « cinq papiers lus intégralement » par une couverture vérifiable, article et version par article : README et HTML se contredisent notamment sur RealCause.
- Identifier explicitement les prépublications locales de Schreck et Huber.
- Corriger la revue de Franklin 2014 : **Computational Statistics & Data Analysis**, 72, 219–226, DOI [10.1016/j.csda.2013.10.018](https://pubmed.ncbi.nlm.nih.gov/24587587/).
- Ne pas définir tout plasmode comme exigeant un OGM appris par ML ou un rééchantillonnage obligatoire : préciser la convention retenue et citer les variantes à X fixe.
- Nuancer « jamais mieux que le bootstrap » à propos d'Advani : le tableau 3 du PDF consulté comporte un contre-exemple pour le regret en MSE dans une expérience assurant l'absence de confusion. Conserver le constat de fragilité, sans universaliser.
- Compléter la référence Sauer par sa publication 2026 ; ajouter Stolte 2024, qui porte directement sur la régression.
- Rechercher les antécédents sous plusieurs vocabulaires : plasmode, semi-synthetic, fixed-design simulation, empirical covariates, spatial model misspecification, change of support. Le seul mot « plasmode » ne permet pas d'évaluer la nouveauté.

Positionnement proposé pour le data paper, à vérifier par cette recherche ciblée : **une banque documentée de supports spatiaux réels et de réponses contrôlées, permettant de distinguer erreurs de spécification, dépendance résiduelle et effets du processus d'observation, avec diagnostics de fidélité et de stabilité des comparaisons**. C'est une proposition de contribution ; ce n'est pas une revendication de première mondiale.

