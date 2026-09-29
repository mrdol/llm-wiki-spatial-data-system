# Résultats du scénario S1 — supports géographiques recouvrants

Date d'exécution : 14 septembre 2026  
Statut : lot pilote complet de 40 répétitions ; résultat interne, sans verdict général sur les estimateurs.

## Protocole exécuté

Le scénario part des unités fines d'évaluation de Georgia et Meuse. Chaque observation est une combinaison pondérée de sa propre unité et de zéro, deux ou quatre unités voisines. Les voisins sont limités à la même région géographique afin que l'opérateur `H` soit par blocs. Deux pondérations sont comparées : uniforme et décroissance exponentielle avec la distance. `H=I` fournit le contrôle sans recouvrement.

La réponse observée est `H(m(X)+u)`, la vérité de score est `H m(X)` et la covariance vraie des erreurs est `sigma² H H'`. Un tampon égal à la distance médiane au plus proche voisin est appliqué entre toutes les unités fines contributrices des supports d'apprentissage et celles de test.

Le lot contient 2 datasets × 2 générateurs × 5 supports × 40 répétitions × 5 méthodes = **4 000 évaluations**.

## Contrôles

- 4 000 évaluations terminées, zéro échec et zéro avertissement de modèle ;
- lignes de `H` non négatives et normalisées ;
- contrôle `H=I` retrouvant exactement la moyenne fine ;
- covariance empirique convergeant vers `sigma² H H'` dans les tests Monte-Carlo ;
- aucune unité fine partagée entre apprentissage et test ;
- réponses de test artificiellement modifiées sans effet sur les prédictions ;
- tampon calculé sur toutes les unités contributrices, et non sur le seul centroïde du support.

## Intensité du recouvrement et tampon

| Dataset | Support | Paires recouvrantes dans une région | Sources partagées entre train/test | Observations d'apprentissage exclues en moyenne |
|---|---|---:|---:|---:|
| Georgia | identité | 0 % | 0 | 3,33 |
| Georgia | 2 voisins | 14,12 % | 0 | 8,00 |
| Georgia | 4 voisins | 29,07 % | 0 | 10,67 |
| Meuse | identité | 0 % | 0 | 0,67 |
| Meuse | 2 voisins | 13,13 % | 0 | 1,67 |
| Meuse | 4 voisins | 28,88 % | 0 | 3,33 |

La pondération modifie la covariance, mais pas le graphe de recouvrement : à nombre de voisins identique, les supports uniformes et décroissants utilisent les mêmes unités fines.

## Résultats prédictifs

Le recouvrement dégrade fortement la NMSE sur Georgia. Sous vérité polynomiale, la meilleure NMSE passe de `0,057 ± 0,004` avec `H=I` à environ `0,36–0,40` avec supports recouvrants. Sous vérité forêt, elle passe de `0,127 ± 0,003` à environ `0,25–0,29`.

Sur Meuse, les changements sont plus faibles. Sous vérité forêt, la meilleure NMSE reste proche de 0,10–0,12. Sous vérité polynomiale, elle passe de `0,087 ± 0,008` pour le contrôle à environ 0,108–0,134 selon le support.

La forêt fournit la plus faible moyenne dans la plupart des configurations recouvrantes. Le modèle linéaire arrive en tête pour Meuse sous vérité polynomiale. Ces résultats sont conditionnels aux deux sources, au générateur, au support, au tampon et aux réglages fixés.

## Limites

- Les supports sont des voisinages ponctuels, pas des polygones administratifs ou des empreintes instrumentales observées.
- Le recouvrement est calibré par nombre de voisins et mesuré après construction ; il n'est pas encore résolu pour atteindre une covariance ou un Moran cible commun aux datasets.
- Le premier lot n'ajoute pas de bruit de mesure après l'opérateur `H`.
- Le protocole vise le transfert indépendant sans sources partagées. Une tâche transductive autorisant des supports communs devrait être rapportée séparément.

## Fichiers reproductibles

- script : `scenario_s1_overlapping_supports.R` ;
- tests : `test_scenario_s1_overlapping_supports.R` ;
- résultats : `scenario_s1_output_2026-09-14/results.rds` et `results.json` ;
- environnement : `scenario_s1_output_2026-09-14/sessionInfo.txt`.
