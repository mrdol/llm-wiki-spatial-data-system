# Résultats du scénario S2 — agrégation d'une relation non linéaire

Date d'exécution : 14 septembre 2026  
Statut : lot pilote complet de 40 répétitions ; résultat interne, sans verdict sur le package.

## Protocole exécuté

Le scénario conserve les sites d'évaluation et les covariables réelles de Georgia et Meuse. Les unités fines sont réparties par bissection récursive de l'emprise selon l'axe de plus grande étendue. Chaque feuille est ainsi une cellule spatiale rectangulaire contiguë. Trois granularités sont utilisées, avec des tailles cibles de 2, 4 et 8 unités par zone et un minimum de 24 zones pour que les cinq estimateurs restent estimables.

Une zone appartient entièrement à un seul des trois plis géographiques. La réponse simulée fournie aux méthodes est `A(m(X)+u)`, avec innovation gaussienne iid au niveau fin et SNR attendu égal à 3. La cible de score est la moyenne latente zonale `A m(X)`. La reconstruction mécanistique naïve `m(A X)` est étudiée séparément des prédictions apprises.

Deux générateurs sont figés après calibration : le polynôme du pilote et la forêt. Les estimateurs comparés sont linéaire, polynôme, GAM covariables, GAM spatial et forêt. Le lot contient 2 datasets × 2 générateurs × 3 granularités × 40 répétitions × 5 méthodes = 2 400 évaluations appariées.

## Contrôles

- 2 400 évaluations terminées, sans échec ni avertissement de modèle ;
- chaque unité fine appartient à une seule zone et toutes sont couvertes ;
- chaque ligne de `A` somme à 1 et aucune zone ne traverse un pli ;
- la covariance des innovations zonales est enregistrée séparément comme `sigma² A A'` ; ses termes hors diagonale sont nuls pour les zones disjointes ;
- pour le générateur quadratique, l'identité fondée sur les variances et covariances internes est retrouvée avec une erreur maximale comprise entre `1.38e-15` et `7.11e-15` ;
- modifier artificiellement les réponses du pli de test ne modifie aucune prédiction.

## Erreur mécanistique de changement de support

| Dataset | Générateur | Taille cible | Zones | NMSE de `A m(X)-m(A X)` | Moran de l'écart |
|---|---|---:|---:|---:|---:|
| Georgia | polynôme | 2 | 53 | 0,089 | -0,114 |
| Georgia | polynôme | 4 | 26 | 0,356 | -0,032 |
| Georgia | polynôme | 8 | 24 | 0,415 | -0,055 |
| Georgia | forêt | 2 | 53 | 0,294 | -0,109 |
| Georgia | forêt | 4 | 26 | 0,664 | -0,134 |
| Georgia | forêt | 8 | 24 | 0,865 | -0,222 |
| Meuse | polynôme | 2 | 51 | 0,0035 | 0,256 |
| Meuse | polynôme | 4 | 26 | 0,0135 | 0,007 |
| Meuse | polynôme | 8 | 24 | 0,0133 | -0,014 |
| Meuse | forêt | 2 | 51 | 0,0559 | 0,000 |
| Meuse | forêt | 4 | 26 | 0,132 | 0,197 |
| Meuse | forêt | 8 | 24 | 0,136 | 0,138 |

L'agrégation produit donc une erreur substantielle lorsque la relation est fortement non linéaire. Son amplitude dépend à la fois du générateur, des covariables, de l'hétérogénéité interne et du zonage. Le Moran de l'écart change de signe et d'amplitude selon le cas : une erreur de support n'a pas une signature spatiale unique.

## Résultats prédictifs

La forêt obtient la plus faible NMSE moyenne dans dix des douze configurations. Pour Meuse sous le générateur polynomial, le polynôme est premier au niveau fin (`0,109 ± 0,011`), puis le modèle linéaire aux deux niveaux plus agrégés (`0,149 ± 0,011` et `0,191 ± 0,016`). Ces valeurs sont descriptives du pilote : elles ne justifient pas un classement général des méthodes.

La réponse Meuse demeure la moyenne zonale de `log(zinc)`. Elle n'est pas interprétée comme le logarithme d'une concentration moyenne.

## Fichiers reproductibles

- script : `scenario_s2_aggregation.R` ;
- tests : `test_scenario_s2_aggregation.R` ;
- résultats complets : `scenario_s2_output_2026-09-14/results.rds` ;
- export lisible : `scenario_s2_output_2026-09-14/results.json` ;
- environnement : `scenario_s2_output_2026-09-14/sessionInfo.txt`.

La prochaine extension est S1 : supports locaux recouvrants, opérateur `H`, covariance vraie `sigma² H H'`, plis construits à partir des unités fines contributrices et tampon géographique.
