# Choix des covariables et réseaux de mesure pour S3

Date : 14 septembre 2026  
Statut : choix scientifique préalable à l'implémentation.

## Décision

La covariable `z` du pilote est retenue pour les deux sources :

| Dataset | Variable source | Nature et support | Moran sur les 106/102 sites d'évaluation | Rôle dans S3 |
|---|---|---|---:|---|
| Georgia | `PctEld` | pourcentage de la population du comté âgée de 65 ans ou plus ; valeur aréale représentée au centroïde | 0,244 | reconstruction d'une covariable indisponible dans certains comtés |
| Meuse | `elev` | altitude associée à un site ponctuel d'échantillonnage | 0,430 | interpolation d'une covariable physique depuis un sous-réseau de mesure |

Les deux variables sont disponibles sans valeur manquante, entrent déjà dans le générateur polynomial et permettent donc de modifier uniquement la couche d'observation de la covariable. Elles ne doivent cependant pas recevoir la même interprétation.

Pour Georgia, `PctEld` n'est pas une mesure de station. S3 simulera une absence de disponibilité dans certains comtés et une reconstruction spatiale à partir d'autres comtés. L'interpolation ponctuelle des centroïdes est une approximation expérimentale explicite ; elle ne transforme pas une proportion aréale en champ physique continu.

Pour Meuse, `elev` se prête directement au dessin d'un réseau ponctuel. La grille `meuse.grid` pourra servir ultérieurement de support de prédiction, mais elle ne doit pas être confondue avec les 155 observations de concentration.

## Dessin des réseaux

Trois densités sont retenues : 70 %, 40 % et 20 % des sites disponibles. Les sites seront choisis par échantillonnage spatial maximin déterministe après fixation d'une graine. Ce dessin évite que la comparaison des densités soit principalement déterminée par des amas aléatoires.

Les réseaux seront emboîtés : le réseau à 20 % est inclus dans celui à 40 %, lui-même inclus dans celui à 70 %. La même sélection est réutilisée entre répétitions ; seules l'erreur de mesure et les innovations de réponse sont retirées.

## Deux tâches distinctes

1. **Réseau connu dans tout le domaine** : les sites de mesure peuvent se trouver dans les trois régions. Cette tâche est transductive et doit être étiquetée comme telle.
2. **Transfert géographique** : pour chaque pli, les sites de mesure appartenant à la région test et au tampon sont exclus avant interpolation. Aucun renseignement sur `z` provenant de la région test n'est utilisé.

Les résultats de ces deux tâches ne seront pas mélangés dans un même classement.

## Méthodes d'interpolation

- contrôle : interpolation par distance inverse, sans modèle de covariance estimé ;
- méthode principale : krigeage ordinaire avec variogramme exponentiel ajusté uniquement sur le réseau autorisé ;
- référence privilégiée : vraie covariable complète, exclue du classement ordinaire ;
- propagation d'incertitude : simulations conditionnelles du champ, rapportées séparément de la surface de krigeage unique.

Une défaillance d'ajustement du variogramme devra être enregistrée. Le script ne remplacera pas silencieusement un modèle invalide par une autre méthode.

## Erreur de mesure

Le premier plan comparera une mesure exacte et une erreur gaussienne d'écart-type égal à 25 % de l'écart-type de `z` dans le réseau. La graine de cette erreur sera distincte de celle de l'innovation de réponse.

## Critères avant exécution

- réseaux emboîtés, reproductibles et spatialement dispersés ;
- aucune utilisation des valeurs vraies de `z` hors réseau par les estimateurs ordinaires ;
- variante complète sans bruit retrouvant `z` aux sites mesurés ;
- réseau, valeurs bruitées, modèle de variogramme et prédictions conservés ;
- séparation stricte entre tâche transductive et transfert ;
- prédictions scorées contre la moyenne construite avec la vraie covariable ;
- erreurs et avertissements conservés, sans remplacement silencieux.
