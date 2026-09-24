# S3 — covariable interpolée : prototype validé et résultats pilotes

Date : 15 septembre 2026. Statut : **lot pilote étendu et intégré à la revue ; généralisation scientifique encore ouverte**.

## Ce qui est exécuté

La vraie covariable `z` est conservée pour construire `m(X)`, mais les méthodes ordinaires reçoivent une surface reconstruite. Georgia utilise `PctEld`, proportion aréale représentée au centroïde de comté ; Meuse utilise `elev`, altitude ponctuelle. Les réseaux de mesure maximin sont emboîtés à 20 %, 40 % et 70 %. IDW et krigeage ordinaire sont distingués, tout comme réseau connu (transductif) et transfert géographique. En transfert, toutes les covariables du pli, y compris celles des observations d'apprentissage, sont reconstruites depuis le seul réseau autorisé hors région test et tampon.

Le balayage de faisabilité comprend 960 évaluations sur 96 réglages avec deux répétitions, sans échec. Le lot central **apparié** comprend 3 200 évaluations avec 40 répétitions, densité 40 % et mesure exacte, sans échec. Un second lot contient **12 800 évaluations sur 40 répétitions** pour les réseaux à 20 % et 70 %, avec mesure exacte ou bruitée, sans échec. Les mêmes innovations de réponse sont utilisées à répétition égale pour les conditions comparées. Les contrastes et leurs MCSE sont disponibles. Vingt choix distincts du réseau central ont aussi été exécutés pour vérifier la sensibilité au dessin de mesure.

Le krigeage utilise un variogramme exponentiel : la portée est fixée à un tiers du diamètre du réseau autorisé, puis pépite et palier sont ajustés. Le premier essai d'ajustement simultané des trois paramètres était instable sur les petits réseaux de transfert. Les ajustements invalides sont enregistrés comme échecs, sans remplacement par l'IDW.

Trente simulations conditionnelles sont produites sur chaque pli de krigeage de la première répétition. Avec une mesure exacte, les réalisations honorent les valeurs du réseau. Leur propagation à travers le **générateur connu** constitue un diagnostic privilégié, exclu du classement ordinaire. Les mêmes réalisations sont maintenant propagées aux cinq estimateurs ordinaires, qui sont réajustés pour chacune : 3 600 ajustements, sans échec.

## Résultats centraux

Erreur de reconstruction de `z`, RMSE dans l'échelle standardisée du pilote :

| Dataset | Tâche | IDW | Krigeage |
|---|---|---:|---:|
| Georgia | Réseau connu | 0,865 | 0,891 |
| Georgia | Transfert | 1,150 | 1,165 |
| Meuse | Réseau connu | 0,813 | 0,815 |
| Meuse | Transfert | 1,680 | 1,389 |

La qualité de reconstruction baisse nettement en transfert, surtout pour Meuse. Le balayage à deux répétitions montre que la densification du réseau connu réduit généralement l'erreur, tandis que son effet en transfert est irrégulier : les nouvelles stations peuvent se trouver dans la région exclue.

Pour la prédiction de la réponse, le meilleur risque moyen dépend du générateur, de la tâche et de l'interpolation. Sous vérité forêt, la forêt donne la plus faible NMSE dans les huit configurations centrales. Sous vérité polynomiale, le polynôme est premier dans sept configurations sur huit ; le GAM covariables est premier pour Meuse–transfert–IDW. Ces observations restent conditionnelles aux réglages du pilote ; les écarts appariés, et non les rangs seuls, seront nécessaires pour un jugement scientifique.

La couverture à 90 % des intervalles issus des 30 réalisations conditionnelles et du générateur connu est d'environ 0,887 sur Georgia et 0,902 sur Meuse en réseau connu, mais 0,830 et 0,799 en transfert. Ce diagnostic repose sur la première répétition de chaque réglage central et signale une possible sous-couverture en transfert ; il ne constitue pas une estimation Monte Carlo précise de la couverture.

Les 40 contrastes appariés « transfert − réseau connu » ont une différence de risque moyenne positive, comprise entre **0,0215 et 0,1113 de NMSE** selon le dataset, le générateur, l'interpolation et la méthode. Le krigeage réduit le risque moyen par rapport à l'IDW dans 18 des 40 contrastes correspondants ; aucun interpolateur ne domine uniformément. Les différences et leur MCSE sont exportées dans `paired_contrasts.csv` et `paired_contrasts.json`. La graine de réponse est reconstruite et contrôlée par le script de rapport ; elle est aussi enregistrée dans les futures exécutions du scénario.

## Vérification des réseaux petits/denses et des mesures bruitées

Le lot à 20 %/70 % confirme que le risque du transfert dépasse celui du réseau connu dans **38 des 40 contextes moyens** regroupant dataset, générateur, densité et méthode (moyennes sur interpolation et bruit). Deux contextes font exception ; le constat n'est donc pas universel.

À mesures exactes, l'erreur de reconstruction de `z` dans le réseau connu diminue fortement avec la densité : Georgia, environ 0,99 à 0,65 ; Meuse, environ 0,97 à 0,59 (moyennes IDW/krigeage et générateurs). En transfert, elle reste proche de 1,16 pour Georgia et 1,53 pour Meuse aux deux densités. Ajouter des stations ailleurs dans le domaine ne garantit pas de mieux reconstruire une région dont les stations sont exclues.

Les mesures bruitées à 25 % de l'écart-type de `z` augmentent modestement l'erreur de reconstruction dans le réseau connu. Leur effet sur le risque de réponse n'a pas un signe uniforme : 22 des 40 contextes moyens montrent une hausse, 18 une baisse. Ce pilote ne permet pas d'affirmer un effet systématique du bruit de mesure sur le classement des estimateurs.

## Sensibilité au choix du réseau et incertitude du générateur connu

Vingt réseaux maximin distincts ont été testés à densité 40 %, mesure exacte et krigeage. La RMSE moyenne de `z`, suivie de son MCSE entre réseaux, est :

| Dataset | Réseau connu | Transfert |
|---|---:|---:|
| Georgia | 0,768 ± 0,015 | 1,172 ± 0,009 |
| Meuse | 0,771 ± 0,008 | 1,419 ± 0,020 |

La fréquence de présence de la moyenne latente dans l'intervalle **dû à `z` seul**, propagé par le générateur connu, est proche de 0,90–0,94 avec réseau connu selon le dataset et le générateur, mais plutôt 0,80–0,84 en transfert. Sa MCSE entre réseaux est comprise entre 0,0035 et 0,0080. Cela établit une sensibilité récurrente au retrait des mesures de la région test ; ce n'est toujours pas la couverture d'un intervalle prédictif complet.

## Propagation aux estimateurs ordinaires : première répétition

Pour les 24 plis de krigeage du lot central, chacun des cinq estimateurs est réajusté sur 30 réalisations conditionnelles de `z`. La réponse simulée est tenue fixe. L'intervalle central à 90 % qui en résulte décrit **seulement la variation des prédictions due à `z`**. La fréquence à laquelle cet intervalle contient la moyenne latente va de 0,217 à 0,554 selon la méthode et la tâche. La moyenne des largeurs varie fortement selon le dataset et la méthode.

Ces fréquences ne sont pas une couverture nominale de prédiction : elles excluent l'innovation de réponse, l'incertitude du modèle de variogramme, l'incertitude d'estimation et le biais de la méthode. Elles servent à quantifier la part de dispersion transmise par une covariable interpolée. Le diagnostic est fondé sur une seule répétition de réponse ; une MCSE de couverture reste nécessaire.

## Ce qui manque pour clore S3

1. Répéter l'intervalle transmis aux **estimateurs ordinaires** sur plusieurs réseaux ou réponses et mesurer sa MCSE ; ajouter les autres sources d'incertitude avant de parler de couverture prédictive.
2. Élargir à d'autres sources et vérifier si un réseau de mesure réellement documenté peut remplacer les réseaux construits.
3. Réexaminer la pertinence d'une interpolation ponctuelle de `PctEld`, qui demeure une proportion aréale par comté.

## Fichiers

- `scenario_s3_interpolated_covariate.R` et `test_scenario_s3_interpolated_covariate.R` ;
- `scenario_s3_pilot_2026-09-15/results.rds` : lot de faisabilité avec diagnostics conditionnels ;
- `scenario_s3_central_paired_2026-09-15/results.rds` : lot central apparié de 40 répétitions ; `paired_contrasts.csv` et `.json` : 80 écarts avec MCSE ;
- `scenario_s3_central_paired_2026-09-15/conditional_estimators_v2.rds` et `.csv` : 120 lignes méthode–pli après 3 600 ajustements conditionnels, avec libellé explicite du taux de présence dans l'intervalle dû à `z` seul ;
- `scenario_s3_network_noise_2026-09-15/results.rds` : lot à 20 %/70 % et bruit de mesure sur 40 répétitions ; `factor_contrasts.csv` : 120 contrastes avec MCSE ;
- `scenario_s3_network_repeat_2026-09-15/results.rds` et `summary.csv` : 20 dessins du réseau central et MCSE entre réseaux ;
- `scenario_s3_central_2026-09-15/results.rds` : première version du lot central, conservée pour audit ; innovations de réponse non appariées entre réglages ;
- `scenario_s3_smoke_2026-09-15/results.rds` : première exécution de faisabilité avant l'ajout des diagnostics conditionnels.
