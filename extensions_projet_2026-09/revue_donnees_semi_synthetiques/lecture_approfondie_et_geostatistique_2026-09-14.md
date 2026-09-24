# Lecture approfondie et complément géostatistique

Date : 14 septembre 2026  
Périmètre : étape 2 de la mise à jour de la revue semi-synthétique.

## État vérifiable des lectures

| Source | Couverture réalisée | Conclusion utile au protocole |
|---|---|---|
| Neal et al., *RealCause* | Texte intégral parcouru, paragraphes et annexes du TEI contrôlés ; tableaux de résultats relus dans le PDF lorsque l'extraction était ambiguë. | Les modèles génératifs sont sélectionnés par vraisemblance de validation et tests à deux échantillons. Un test non rejeté est un moyen de falsification imparfait, dont la puissance baisse en grande dimension ; il ne prouve pas l'égalité des distributions. Les trois « boutons » portent sur recouvrement, hétérogénéité et échelle de l'effet causal. |
| Gelfand et Schliep, *Model-Based Spatial Data Fusion* | Article intégral parcouru à partir du TEI, avec contrôle des formulations et scénarios de fusion. | La fusion relie plusieurs sources de réponse à un processus latent commun. Les sources peuvent être ponctuelles, aréales ou des patrons de points. Une source sert de référence de mesure et l'autre peut nécessiter une calibration ; calibrer librement les deux n'est pas identifiable. Le changement de support est un cas lié, mais distinct de la fusion générale. |
| Gotway et Young, *Combining Incompatible Spatial Data* | Article intégral parcouru, y compris les sections sur données aréales/ponctuelles, changement de support, simulation conditionnelle et limites. | L'analyse doit représenter le support de chaque variable et l'opérateur qui la relie au processus latent. Agréger puis transformer n'est généralement pas équivalent à transformer puis agréger. La simulation conditionnelle fournit des réalisations compatibles avec les observations et permet de propager l'incertitude de changement de support. |
| Tiedeman et Green, *Effect of correlated observation error...* | Article intégral parcouru, dérivation simple, application de transport réactif et conclusions. | Des observations dérivées d'une même mesure ont une covariance hors diagonale calculable par propagation d'erreur. Ignorer cette covariance peut modifier paramètres et prédictions et peut sous-estimer ou surestimer leur incertitude. Dans l'application, les rapports de variances paramétriques vont de 0,4 à 3,7. L'effet dépend de l'interaction entre corrélations et sensibilités, pas de la seule valeur de la corrélation. |
| LeSage et Pace, *Spatial econometric Monte Carlo studies: raising the bar* | Article publié de 18 pages déposé localement, DOI et version contrôlés, puis converti en TEI. | Les simulations SAR doivent varier W, la dépendance des X, le SNR et la plage de dépendance. Leur cible principale doit inclure biais, dispersion et MSE des effets directs et indirects, fonctions non linéaires de beta et rho, en reproduisant aussi le calcul d'incertitude utilisé en pratique. |

## Conséquences pour les scénarios d'observation

### Supports recouvrants

Soit une réponse latente sur un support fin,

`Y* = m(X) + epsilon`, avec `Cov(epsilon | X) = sigma² I`,

et une observation `Y_obs = H Y*`. Alors

`Cov(Y_obs | X,H) = sigma² H H'`.

Des lignes de `H` partageant des unités fines produisent donc des covariances hors diagonale. Ce mécanisme ne doit pas être appelé SAR ou SEM : la dépendance est créée par l'observation de supports recouvrants. Il faut enregistrer `H`, le recouvrement entre lignes et les unités fines communes aux plis d'apprentissage et de test.

### Agrégation d'une relation non linéaire

Pour une zone `B`, `A_B[f(X)]` diffère en général de `f(A_B[X])`. Une formule quadratique illustre exactement le terme perdu :

`A_B[X²] = A_B[X]² + Var_B(X)`.

Un analyste qui ne reçoit que la moyenne zonale omet donc les moments internes. Le pilote retrouve cette identité à une erreur numérique inférieure à `6e-15`. L'écart obtenu a un Moran de `0,092` pour Georgia et `0,288` pour Meuse ; son NMSE est respectivement `0,743` et `0,055`. L'intensité dépend fortement du support source et ne peut pas être fixée à partir d'une seule géométrie.

### Covariables interpolées

Lorsqu'une covariable ponctuelle est interpolée puis utilisée comme si elle était observée, l'erreur de covariable est partagée entre prédictions voisines. Le scénario doit conserver les données ponctuelles d'origine, la méthode d'interpolation, ses paramètres et, si possible, des réalisations conditionnelles de la covariable. Il faut comparer au minimum : covariable vraie ou haute résolution, surface interpolée seule, et ensemble de simulations conditionnelles. Une unique surface krigée sous-représente l'incertitude et lisse la variabilité locale.

## Complément géostatistique

La simulation conditionnelle ne cherche pas seulement à minimiser une erreur ponctuelle comme le krigeage. Elle génère plusieurs champs qui honorent les observations tout en reproduisant une distribution marginale et une structure spatiale imposée. Pour le protocole, trois niveaux sont utiles :

1. **Champ gaussien conditionnel à deux points** : covariance ou variogramme paramétrique, portée, palier, effet pépite et anisotropie ; base naturelle pour `g(s)` et `u(s)`.
2. **Simulation séquentielle gaussienne ou indicatrice** : réalisations conditionnelles adaptées aux variables continues ou catégorielles, avec contrôle des histogrammes, variogrammes et contraintes aux données.
3. **Simulation multipoint** : utile lorsque connectivité et texture ne sont pas résumées par un variogramme, mais elle exige une image d'entraînement et introduit une nouvelle source de préférence du générateur.

Références de cadrage retenues : Zakeri et Mariethoz (2021), DOI `10.1016/j.rse.2021.112381`, pour la taxonomie et la validation ; Gómez-Hernández et Srivastava (2021), DOI `10.1007/s11004-021-09926-0`, pour l'histoire et les principes de la simulation séquentielle ; Cressie et Pavlicová (2002), DOI `10.1191/1471082X02ST035OA`, pour des champs de moyenne mobile calibrés sur des covariances usuelles.

## Ce qui reste ouvert

- Le PDF LeSage–Pace a été fourni manuellement après l'échec du téléchargement par Unpaywall. Son empreinte SHA-256 est `e6162a28b8bd80809fcc4a32313acc696fde439e6330b510a7a21d6ec98cd07c` et son TEI contient 64 paragraphes.
- Les équations extraites par GROBID doivent être contrôlées dans les PDF avant une implémentation.
- La simulation conditionnelle doit encore être prototypée sur Georgia et Meuse ; elle n'est pas un résultat du pilote actuel.
- Le pilote compare deux sources et deux familles de générateurs seulement. Il ne mesure pas une performance moyenne sur la banque.
- Les bandes géographiques n'ont pas de zone tampon et ne définissent pas encore une cible de transfert géographique.
