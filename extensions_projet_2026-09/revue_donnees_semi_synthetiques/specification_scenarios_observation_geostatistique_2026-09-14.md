# Spécification des scénarios d'observation et de simulation géostatistique

Date : 14 septembre 2026  
Statut actualisé le 15 septembre 2026 : S2 et S1 exécutés pour leurs lots initiaux ; S3 exécuté comme pilote élargi ; S4 a passé les contrôles de champs et des lots appariés de 40 répétitions, non conditionnel et conditionnel par pli, sur Georgia/Meuse (8 000 évaluations et 400 contrastes par mode) puis sur Banff (4 000 évaluations et 200 contrastes par mode), documentés dans le HTML principal. Banff utilise les covariables finales de son papier mais une covariance euclidienne différente du modèle de réseau publié. Les observations conditionnantes bruitées, les réseaux alternatifs et la généralisation restent ouverts. Voir `SUIVI_ETAPES.md`.

## 1. Objet commun

Les scénarios partent des sites et covariables réels d'un dataset source. Une fonction génératrice `m(X)` est ajustée uniquement sur les sites de calibration, puis figée. La cible de base est la moyenne latente aux sites d'évaluation :

`Y* = m(X) + u`, avec `E(u | X,s) = 0`.

Chaque scénario modifie une seule couche identifiable : moyenne, innovation, observation ou covariable. La sortie doit permettre de reconstruire la vérité utilisée pour scorer les estimateurs. Un indice de Moran élevé n'est jamais utilisé seul pour identifier le mécanisme.

### Objets communs à conserver

- identifiant du dataset et empreinte du fichier source ;
- indices des sites de calibration et d'évaluation ;
- formule, hyperparamètres et prédictions du générateur `m` ;
- coordonnées projetées, CRS et unité de distance ;
- définition et matrice de `W` ;
- folds et éventuelle zone tampon ;
- graines de toutes les couches aléatoires ;
- moyenne latente, innovation, réponse observée et opérateur d'observation ;
- SNR attendu et obtenu, part de variance spatiale, portée effective et Moran descriptif ;
- échecs, avertissements, temps de calcul et versions logicielles.

## 2. S1 — Supports recouvrants

### Question

Une dépendance observée peut-elle être créée par des produits spatiaux qui partagent des mesures sources, alors que les innovations du processus fin sont indépendantes ?

### DGP

Sur `n` unités fines :

`Y* = m(X) + sigma epsilon`, avec `epsilon ~ N(0,I_n)`.

Pour `q` observations agrégées ou lissées :

`Y_obs = H Y*`,

`E(Y_obs | X,H) = Hm(X)`,

`Cov(Y_obs | X,H) = sigma² H H'`.

`H` est une matrice `q × n`, à poids non négatifs et lignes normalisées. Le scénario principal utilise des supports locaux recouvrants construits à partir de la géométrie ; `H=(1-alpha)I+alpha W` reste un contrôle algébrique, pas le scénario géographique final.

### Facteurs

- intensité de recouvrement : fraction moyenne d'unités fines partagées ;
- largeur du support : rayon métrique ou nombre de voisins ;
- pondération : uniforme ou décroissante avec la distance ;
- bruit de mesure additionnel après agrégation : nul/faible/modéré.

Les niveaux doivent être calibrés sur une mesure commune, par exemple la corrélation hors diagonale moyenne ou le Moran attendu de l'erreur observée, plutôt que sur `alpha` seul.

### Vérités et scores

- vérité de prédiction observée : `Hm(X)` ;
- covariance vraie : `sigma²HH'` plus la covariance du bruit de mesure éventuel ;
- score principal : NMSE des prédictions de `Hm(X)` ;
- scores secondaires : couverture des intervalles, erreur sur la covariance et diagnostic des résidus.

### Validation

Les unités fines qui contribuent à une observation de test ne doivent pas contribuer à une observation d'apprentissage pour la cible de transfert indépendant. Les folds sont construits sur le graphe biparti `observations ↔ unités fines`, puis séparés spatialement avec tampon. Le nombre de paires train–test partageant une unité fine doit être nul dans cette variante.

### Critères d'acceptation

- `H` stocké et lignes sommant à 1 à la tolérance numérique ;
- covariance empirique convergeant vers `sigma²HH'` ;
- aucune fuite de support dans les folds indépendants ;
- contrôle `H=I` retrouvant le DGP de référence.

## 3. S2 — Agrégation d'une relation non linéaire

### Question

Quelle erreur apparaît lorsqu'un analyste ne possède que des moyennes zonales de X et évalue `m` sur ces moyennes ?

### DGP

Les unités fines sont regroupées dans des zones disjointes par une matrice d'agrégation `A` :

`mu_zone = A m(X)`.

La reconstruction naïve est :

`mu_naive = m(A X)`.

L'écart de support est :

`delta_support = A m(X) - m(A X)`.

Pour une composante quadratique, `A(X²) - A(X)²` est la variance interne à la zone. Pour une interaction, l'écart dépend de la covariance interne. Ces identités servent de contrôles positifs.

### Facteurs

- découpage spatial : au moins trois partitions contiguës de granularités différentes ;
- forme de `m` : additive, quadratique, interaction et générateur forêt ;
- hétérogénéité interne des zones, mesurée avant simulation ;
- taille et déséquilibre des zones.

### Vérités et scores

- vérité zonale : `A m(X)` ;
- erreur mécanistique : `delta_support` ;
- scores : NMSE zonale, Moran de `delta_support`, corrélation avec les moments internes et stabilité entre partitions.

### Validation

Une zone entière appartient à un seul fold. Les partitions doivent être fondées sur une géométrie contiguë documentée ; le regroupement par ordre est–ouest reste seulement un test unitaire. La réponse `log(zinc)` de Meuse ne doit pas être présentée comme le logarithme d'une concentration moyenne sans transformation inverse et justification.

### Critères d'acceptation

- identité quadratique retrouvée à moins de `1e-10` ;
- groupes disjoints et couverture complète des unités retenues ;
- résultats rapportés pour plusieurs découpages ;
- séparation explicite entre erreur de moyenne et covariance des innovations.

## 4. S3 — Covariable interpolée

### Question

Comment l'erreur d'une covariable mesurée sur un sous-réseau puis interpolée affecte-t-elle la moyenne estimée et la covariance résiduelle ?

### DGP

Une covariable réelle complète `X_j` sert de vérité. Un sous-réseau de mesure `M` observe :

`X_M_obs = X_M + eta`, avec `eta ~ N(0, Sigma_eta)`.

L'interpolation produit :

`X_tilde = L(X_M_obs)`.

La réponse est générée depuis la vérité complète :

`Y* = m(X_j, X_-j) + u`.

Les estimateurs ordinaires reçoivent `X_tilde`; une référence privilégiée reçoit `X_j`. Pour isoler correctement l'incertitude, `eta` et, dans la variante géostatistique, la réalisation conditionnelle de `X_j` sont retirés à chaque réplication.

### Facteurs

- densité et dessin du réseau de mesure ;
- méthode : krigeage ou autre interpolation documentée ;
- portée, effet pépite et anisotropie du modèle de covariable ;
- amplitude de l'erreur de mesure ;
- surface unique contre ensemble de simulations conditionnelles.

### Vérités et scores

- moyenne vraie : `m(X_j,X_-j)` ;
- biais de lissage : différence obtenue avec l'espérance ou la surface interpolée ;
- incertitude propagée : distribution des prédictions sur les réalisations conditionnelles ;
- scores : NMSE de la moyenne, couverture, calibration de l'incertitude et covariance des résidus.

### Validation

Les stations ayant servi à interpoler une covariable de test ne doivent pas traverser implicitement la frontière train–test sans que cette transductivité soit déclarée. Deux tâches sont donc rapportées séparément : interpolation dans un réseau connu et transfert vers une zone dont les mesures sont exclues avec tampon.

### Critères d'acceptation

- points sources, modèle de variogramme et opérateur ou prédictions conservés ;
- la variante sans bruit et avec tous les sites retrouve la covariable vraie à la tolérance attendue ;
- covariance empirique de l'erreur comparée à la covariance conditionnelle ;
- séparation des résultats « surface unique » et « incertitude propagée ».

## 5. S4 — Champs spatiaux conditionnels calibrés

### Question

Comment faire varier `g(s)` ou `u(s)` avec une force et une portée comparables entre datasets, tout en conservant l'ancrage dans la structure spatiale observée ?

### DGP

Deux variantes doivent rester séparées :

- tendance latente : `Y* = m(X) + g(s) + epsilon` ;
- innovation spatiale : `Y* = m(X) + u(s)`.

Le champ gaussien utilise une covariance Matérn ou exponentielle documentée :

`C(h) = tau² 1(h=0) + sigma_s² R(h; phi, nu)`.

La version conditionnelle génère des réalisations qui honorent des valeurs du champ sur un sous-ensemble de sites. La version non conditionnelle sert de contrôle et de scénario de mécanisme entièrement imposé.

### Calibration commune

- `SNR = Var(m) / Var(bruit total)` ;
- part spatiale `pi_s = Var(composante spatiale) / Var(m + composante spatiale)` ;
- portée effective exprimée comme fraction du diamètre du domaine ;
- effet pépite comme fraction de la variance du bruit total.

Les paramètres natifs sont résolus numériquement pour atteindre ces cibles sur chaque géométrie. Les valeurs réalisées sont enregistrées en plus des cibles.

**Restriction et correction constatées lors du contrôle S4 (15 septembre)** : dans les deux variantes, un champ spatial et une pépite diagonale ne fournissent que deux variances libres. Avec SNR et `pi_s` fixés, la fraction de pépite en découle ; elle ne peut pas être croisée indépendamment dans le même plan. Le script corrigé utilise le même SNR `Var(m)/E[Var(champ spatial + bruit indépendant)]` et la même réponse simulée dans les deux variantes ; seule la cible (`m` ou `m+g`) change. Le champ `g` est renouvelé à chaque répétition, conformément au contrôle recommandé par White et al. Le SNR de LeSage–Pace, borné entre 0 et 1 dans son exemple SAR, ne se lit pas directement comme notre ratio. Le script refuse les combinaisons impossibles au lieu d'altérer les cibles silencieusement. Voir `resultats_s4_faisabilite_2026-09-15.md`.

### Facteurs

- portée courte/moyenne/longue ;
- part spatiale faible/moyenne/forte ;
- effet pépite nul/modéré ;
- isotropie contre une anisotropie documentée ;
- champ conditionnel contre non conditionnel.

### Vérités et scores

- moyenne conditionnelle selon la tâche : `m(X)+g(s)` ou `m(X)` ;
- réalisation complète du champ conservée ;
- scores : NMSE, couverture, reproduction du variogramme/covariance, Moran multi-voisinages et erreur par distance au site conditionnant le plus proche.

### Critères d'acceptation

- matrice de covariance positive définie ou régularisation déclarée ;
- sites conditionnants honorés à la tolérance cohérente avec l'effet pépite ;
- histogramme, variogramme et paramètres réalisés contrôlés ;
- nombre de réalisations fixé par une précision Monte Carlo cible.

## 6. Plan expérimental minimal

Le premier lot doit rester petit et interprétable :

| Élément | Lot initial |
|---|---|
| Sources | Georgia et Meuse |
| Générateurs de `m` | polynôme et forêt déjà calibrés |
| Scénarios | S1–S4, plus référence sans modification |
| Niveaux | deux niveaux non nuls par facteur principal, plus contrôle nul |
| Folds | bandes géographiques avec tampon ; groupes/supports indivisibles |
| Réplications | lot pilote de 40, puis recalcul à partir de la MCSE des contrastes appariés |
| Estimateurs | ensemble fixe déjà disponible ; référence privilégiée exclue des classements ordinaires |

Les comparaisons principales sont appariées par dataset, générateur, scénario, réplication et fold. Les rangs ne sont interprétés qu'avec les écarts de risque et leur MCSE.

Pour les modèles SAR ou SDM, le rapport doit ajouter les effets directs et indirects ainsi que leur dispersion, conformément à LeSage et Pace. Les seuls biais et MSE de `beta` et `rho` sont insuffisants pour évaluer l'inférence utilisée en pratique.

## 7. Ordre d'implémentation proposé

1. S2 — terminé : partitions spatiales à trois granularités, identités algébriques, plis par zones et lot de 40 répétitions. Voir `resultats_s2_aggregation_2026-09-14.md`.
2. S1 — terminé pour le lot initial : supports ponctuels géographiques, pondérations uniforme et décroissante, plis sans partage d'unités fines, tampon sur les sources contributrices et 40 répétitions. Voir `resultats_s1_supports_recouvrants_2026-09-14.md`.
3. S3, après choix d'une covariable et d'un réseau de mesure crédibles pour chaque source.
4. S4, après stabilisation d'une fonction commune de calibration SNR/part spatiale/portée.

Le PDF publié de LeSage–Pace est désormais déposé dans le dossier des articles complémentaires et converti en TEI. Les équations SAR/SDM, la définition du SNR et le protocole d'évaluation des effets directs et indirects devront servir de contrôles lors de l'implémentation.
