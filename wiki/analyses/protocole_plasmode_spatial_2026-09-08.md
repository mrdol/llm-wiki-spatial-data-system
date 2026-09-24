---
title: Plasmode spatial — protocole et premier pilote après retour de l'encadrant
type: analysis
created: 2026-09-08
updated: 2026-09-08
sources:
  - extensions_projet_2026-09/revue_donnees_semi_synthetiques/synthese_encadrant_2026-09.md
  - extensions_projet_2026-09/revue_donnees_semi_synthetiques/plasmode_pilot.R
  - extensions_projet_2026-09/revue_donnees_semi_synthetiques/test_plasmode_pilot.R
  - wiki/datasets/r_package_docs/sp/topics/meuse.md
  - wiki/datasets/fiches_datasets/Python_libpysal_georgia.md
  - https://doi.org/10.1214/10-STS326
  - https://doi.org/10.2307/1939924
tags: [plasmode, simulation, benchmark, spatial, protocole]
status: pilote_methodologique
---

Le programme retient exclusivement le plasmode : une fonction estimée sur le réel devient une vérité de simulation, puis des interventions documentées modifient la relation, l'information disponible ou le bruit.

## Décision du 8 septembre

Le retour de l'encadrant privilégie la famille C, spécifiquement le plasmode, et écarte l'EMCS placebo centré sur les traitements causaux. La taxonomie des HTML demeure un historique bibliographique ; GAN, synthèse complète, morphing et EMCS ne constituent plus des branches d'implémentation actives.

Ce choix conserve l'intérêt des scénarios D0–D9, mais impose de documenter, pour chacun, ce qui est ajusté sur le réel et ce qui est modifié expérimentalement. Il ne signifie pas que toute la grille est déjà implémentée. Le pilote ci-dessous traite la question ouverte sur D9 ; il ne réalise ni SVC, ni SAR, ni champ g(s) supplémentaire.

La note transmise par l'encadrant est conservée telle quelle comme source historique. Les présentes précisions constituent son cadrage opérationnel après le nouveau message ; les numéros P0–P6 du pilote ne remplacent pas les codes D0–D9.

## Question et vocabulaire

Question : une méthode spatiale améliore-t-elle la prédiction parce qu'elle décrit une dépendance spatiale du phénomène, ou parce qu'elle compense une information absente ou une forme fonctionnelle insuffisante ?

La phrase « D9 est le seul DGP aspatial produisant l'apparence d'un processus spatial » est remplacée par : **une réponse ou des résidus peuvent présenter un motif spatial sans interaction directe entre réponses voisines**. Dès D0, des X spatialement structurés peuvent produire un Y structuré. D9 teste une information pertinente retirée au modèle. L'autocorrélation observée est réelle ; c'est son interprétation comme propagation qui peut être incorrecte.

Trois origines doivent rester séparées :

1. **Information incomplète** : variable omise, proxy imparfait, date ou composition omise.
2. **Forme du modèle insuffisante** : courbure, seuil, interaction que certaines méthodes peuvent apprendre et d'autres non.
3. **Processus d'observation** : agrégation, changement de support, lissage avec mesures sources partagées.

Une variance géographiquement variable ne crée pas à elle seule une covariance entre erreurs indépendantes centrées. Le contrôle hétéroscédastique du pilote teste cette distinction.

Repères théoriques : [Legendre (1993)](https://doi.org/10.2307/1939924) distingue les sources environnementales et les processus d'interaction ; [Paciorek (2010)](https://doi.org/10.1214/10-STS326) montre l'importance des échelles relatives dans la confusion spatiale. Les scénarios précis ci-dessous sont des constructions du projet, sans prétention de nouveauté bibliographique démontrée.

## Données et support du pilote

Deux sources locales, sélectionnées pour leur taille permettant un essai rapide et pour leurs covariables réelles documentées :

| Source | Réponse réelle de calibration | X1 / X2 | Z susceptible d'être masquée |
|---|---|---|---|
| Georgia | PctBach | PctRural / PctFB | PctEld |
| Meuse | log(zinc) | dist / om | elev |

Ces choix sont des spécifications de simulation conçues pour le pilote, **pas une reproduction des modèles publiés**. Georgia représente des comtés ; Meuse des prélèvements de sol. Les scénarios gaussiens portent sur une réponse continue artificielle : ils ne garantissent pas le maintien des bornes d'un pourcentage. Aucune réponse synthétique ne remplace une observation réelle dans le catalogue.

Georgia : les colonnes Longitud/Latitude, Y et X sont comparées à spgwr::gSRDF installé par clé AreaKey. Les longitudes sont comprises approximativement entre -85.50 et -81.09 et les latitudes entre 30.72 et 34.92. La géométrie sf convertie du fichier local a une étendue incohérente avec Georgia ; elle n'est pas utilisée. Les coordonnées vérifiées sont projetées en EPSG:5070, en mètres, uniquement dans le pilote. Cette incohérence de conversion doit faire l'objet d'une réparation distincte ; les contrôles de structure sf de l'audit antérieur ne constituaient pas une validation géographique.

Meuse : les x/y RDH en mètres sont documentés par sp::meuse (exemple EPSG:28992). Les deux lignes avec om manquant sont écartées pour ce pilote et leurs indices sont enregistrés. Le CRS du fichier original reste inchangé.

W est construit sur les sites d'évaluation : union symétrisée des quatre plus proches voisins euclidiens, diagonale nulle, standardisation par ligne, aucun isolat. C'est **un W du protocole**, pas une matrice originale attribuée à un article. Les coordonnées sources et les graines sont enregistrées.

## Construction du plasmode

Les sites sont ordonnés selon l'est, puis le nord ; un site sur trois sert uniquement à la calibration. Les autres servent à l'évaluation des méthodes. La sélection ne dépend pas de Y. Il s'agit de groupes disjoints, pas d'une garantie d'indépendance spatiale : la calibration est intercalée entre sites d'évaluation.

Les X sont standardisés avec les moyennes et écarts-types de calibration. Sur ces seuls sites, une régression polynomiale est ajustée au Y réel :

```
y ~ x1 + x2 + z + I(x1^2) + I(x2^2) + x1:x2
```

Ses coefficients estimés définissent trois blocs enregistrés : b(X), partie linéaire ; q(X), courbures ; h(X), interaction. Les blocs non linéaires ne sont ni inventés indépendamment du réel ni amplifiés pour forcer une autocorrélation positive. Leur amplitude et leur Moran descriptif sont mesurés. Un effet presque nul ou sans motif spatial est un résultat de faisabilité, pas une raison de sélectionner après coup un scénario favorable.

La fonction de référence complète est b+q+h. Les scénarios désactivent certains blocs ou modifient l'information observée. Cette base polynomiale unique favorise des formes représentables par elle ; le pilote n'est donc pas une démonstration générale de réalisme ou d'impartialité entre modèles. Une seconde famille de générateurs sera nécessaire avant une étude comparative large.

## Scénarios exécutables

| Code / identifiant | Moyenne vraie sur les sites | Information du concurrent | Objet du test |
|---|---|---|---|
| P0 / reference | b | x1,x2,z | Référence linéaire correctement spécifiée |
| P1 / omitted_z | b | x1,x2 | Même réponse que P0, Z retirée ; variante D9 |
| P2 / curvature | b+q | x1,x2,z | Une relation courbe peut laisser un motif après ajustement linéaire |
| P3 / interaction | b+h | x1,x2,z | Interaction accessible aux méthodes flexibles, absente du modèle linéaire |
| P4 / measured_z | b | x1,x2,z_proxy | Z vraie remplacée par Z+bruit de mesure fixe, écart-type 0.75 après standardisation |
| P5 / sem_positive | b | x1,x2,z | Contrôle positif : bruit SEM avec lambda=0.4 |
| P6 / heteroskedastic_control | b | x1,x2,z | Erreurs indépendantes, variance proportionnelle à exp(z) |

P1 et P4 conservent exactement la moyenne, le bruit et Y de P0 pour la même réplication. Seule l'information fournie change. Pour P3, on ne prétend pas cacher l'interaction aux GAM : les deux variables leur sont fournies. Aucune coordonnée n'entre dans le DGP des moyennes de P0–P6 ; seules les erreurs de P5 utilisent W.

Z_proxy est générée une fois avec une graine dédiée puis figée. Cela mesure la sensibilité sur une réalisation de l'erreur de mesure, pas une moyenne sur toutes les erreurs de mesure possibles. L'extension devra aussi répliquer cette couche.

## Bruit et calibration de difficulté

Le pilote utilise un SNR attendu de 3, défini par var(m) divisée par la moyenne des variances marginales du bruit. La variance de m est calculée sur les sites fixes d'évaluation.

- P0–P4 : bruit gaussien indépendant.
- P5 : B=(I-0.4W)^(-1), normalisé pour que mean(diag(B B'))=1.
- P6 : B diagonal, termes proportionnels à exp(z/2), avec la même normalisation.

On génère u=sigma B epsilon, epsilon~N(0,I), sigma²=var(m)/3. **Aucun centrage ni ajustement de variance par réalisation** : ces opérations pourraient modifier la covariance voulue. Les mêmes innovations sont utilisées entre scénarios et concurrents pour une source et une réplication données.

Le SNR commun ne rend pas tous les scénarios identiques en difficulté. Part du signal inaccessible, portée, amplitude de l'interaction et erreur de mesure sont mesurées ou fixées, pas calibrées sur une grille commune complète. P5 est un contrôle positif, pas un benchmark SAR/SEM exhaustif.

## Évaluation et information privilégiée

Les sites d'évaluation sont divisés en trois bandes contiguës est-ouest de tailles proches. Chacune est tenue à l'écart à son tour. Les bandes périphériques posent une difficulté d'extrapolation ; la bande centrale relève davantage de l'interpolation. Pas de tampon spatial dans ce premier pilote ; les voisinages proches de frontières restent une limite.

Concurrents de ce pilote :

- modèle linéaire sur les variables accessibles ;
- GAM sur covariables, avec lissages univariés et interaction tensorielle x1/x2 ;
- même GAM complété par un lissage des coordonnées.

Une régression dans la base polynomiale complète, disposant de Z vraie même lorsque Z est masquée ou dégradée, constitue un **diagnostic privilégié**. Elle est ajustée sur les réponses simulées d'apprentissage ; ce n'est pas un concurrent équitable, ni une prédiction oracle parfaite. Elle reste séparée dans les tableaux.

Les concurrents ne reçoivent ni moyenne vraie, ni réponses de test pendant l'ajustement. Les différences de variables entre scénarios sont intentionnelles ; au sein d'un scénario, les covariables non géographiques accessibles sont identiques entre concurrents.

Mesure principale : MSE entre prédiction hors échantillon et moyenne latente connue m, normalisée par var(m). Pour P4, la cible est **la moyenne sur les sites et X latents fixes** ; elle n'est pas E[Y|X_proxy] dans une population où l'erreur de mesure serait intégrée. La cible est explicitement différente et ne doit pas être présentée comme une vérité conditionnelle connue sur les seuls X observés.

Mesures secondaires : MSE sur Y bruité, Moran descriptif des résidus hors échantillon et des innovations, temps de calcul, erreurs et warnings. Le Moran est sans test de significativité : les résidus de validation croisée ne sont pas échangeables comme des observations iid. La norme du signal omis et son Moran sont conservés ; aucune amélioration prédictive n'est assimilée à la preuve d'un mécanisme causal spatial.

Les moyennes et erreurs standard Monte Carlo sont conditionnelles aux deux sources, aux sites, aux folds, à la calibration et au proxy fixes. Vingt réplications constituent un budget de faisabilité ; aucune convergence scientifique n'est revendiquée. Aucun verdict win/tie/loss, classement global ou regret agrégé n'est recalculé en dehors du moteur officiel du package. Ces essais autonomes ne certifient pas ses wrappers.

## Exécution et sorties

Depuis la racine du dépôt :

```powershell
$env:OPENBLAS_NUM_THREADS='1'
Rscript extensions_projet_2026-09/revue_donnees_semi_synthetiques/test_plasmode_pilot.R
Rscript extensions_projet_2026-09/revue_donnees_semi_synthetiques/plasmode_pilot.R 20
```

Le deuxième argument optionnel du pilote désigne un répertoire de sortie distinct pour un autre essai. Les sorties natives sont results.rds, les objets de calibration, les vérités et données de la première réplication, un miroir results.json et sessionInfo.txt. Les indices des lignes, folds, graines, coefficients, matrices W, transformations et empreintes des deux fichiers sources permettent la reproduction.

Le [compte rendu du pilote](../../extensions_projet_2026-09/revue_donnees_semi_synthetiques/pilot_output_2026-09-08/rapport_pilote.md) donne les résultats effectifs et leurs limites. Aucune fiche, donnée originale ou décision package_include n'est modifiée par le pilote.

## Étapes après ce pilote

1. Vérifier si les composantes omises présentent effectivement un motif spatial sur ces sources ; examiner les échecs du générateur et les performances réelles hors calibration.
2. Discuter les variantes les plus informatives avec l'encadrant ; conserver les résultats peu favorables à l'hypothèse.
3. Ajouter une seconde base génératrice et des folds/tampons alternatifs ; augmenter les réplications selon la précision Monte Carlo requise.
4. Construire une vraie expérience de changement de support si des observations et groupes adaptés sont disponibles. En général mean(f(X)) n'est pas f(mean(X)) ; l'information de composition manquante doit être connue dans le DGP. Lissage avec mesures partagées et date omise restent des extensions documentées, non réalisées.
5. Intégrer les scénarios stabilisés aux interfaces du package, puis étendre lambda, f, g et u. Lancer le benchmark large seulement après ces contrôles ; la présente exécution reste un pilote.

## Pages liées

- [[dataset_fiches_corrections_2026-09-07]]
- [[tidymodels_spatial_pipeline_status_2026-07]]


## Related Pages

Aucune fiche wiki associee a ce rapport ; se referer aux sources listees en frontmatter.
