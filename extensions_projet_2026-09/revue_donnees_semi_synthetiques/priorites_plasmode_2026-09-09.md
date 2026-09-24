# Plasmode spatial : traitement des trois priorités

Date : 9 septembre 2026. Suite du [complément bibliographique](complement_litterature_plasmode_2026-09-09.md) et du [pilote du 8 septembre](../../wiki/analyses/protocole_plasmode_spatial_2026-09-08.md).

**Décision de travail : conserver le support réel fixe, mesurer la sensibilité à la famille génératrice et distinguer les mécanismes d'observation des mécanismes de propagation.** Les arguments bibliographiques ci-dessous soutiennent des choix précis ; ils ne valident pas à eux seuls le benchmark spatial complet.

## 1. Ce qui a été vérifié dans les articles

Les recherches locales KG et la revue existante ont servi de point de départ. Cinq textes intégraux supplémentaires sont conservés dans [le dossier de lecture](papiers_lus/priorites_2026-09-09/manifest_lecture.json), avec URL, empreinte SHA-256 et passages consultés. Il s'agit de lectures ciblées sur les questions du protocole, **pas d'un audit intégral des preuves, annexes et codes**. Ces documents restent dans l'extension documentaire, sans ingestion dans le corpus général.

| Source et version | Passages examinés | Conséquence pour notre travail |
|---|---|---|
| Stolte et al., 2024, article publié, DOI [10.1371/journal.pone.0299989](https://doi.org/10.1371/journal.pone.0299989) | Comparaison des rééchantillonnages, recommandations et discussion, notamment pp. 30–32 du PDF | L'absence de rééchantillonnage existe explicitement ; les résultats concernent la MSE des coefficients OLS, pas notre risque prédictif spatial. |
| Stolte et al., 2025, article publié, DOI [10.1371/journal.pone.0322887](https://doi.org/10.1371/journal.pone.0322887) | Protocole pp. 9–10, discussion et limites pp. 28–32 | Aucun rééchantillonnage ne domine uniformément ; l'OGM reste une source de sensibilité. Étude de classification non spatiale. |
| Lahiri et Zhu, 2006, reprint des *Annals of Statistics*, DOI [10.1214/009053606000000551](https://doi.org/10.1214/009053606000000551) | Introduction et hypothèses, pp. 1–7 du reprint | Un bootstrap spatial de sites irréguliers exige des hypothèses de plan, de domaine et de dépendance ; le transfert naïf des blocs est insuffisant. |
| López et Kholodilin, 2023, article publié, DOI [10.1111/pirs.12738](https://doi.org/10.1111/pirs.12738) | Résumé, introduction, MARS pp. 1–4 ; conclusion p. 18 ; début annexe A p. 21 | Article utile pour les non-linéarités de **Wy**, mais pas une démonstration d'absence de mécanisme spatial latent. |
| Gryparis et al., 2009, article publié, DOI [10.1093/biostatistics/kxn033](https://doi.org/10.1093/biostatistics/kxn033) | Cadre et sections 3, 4.1, 4.2, pp. 260–262 de la revue / 3–5 du PDF ; tableau d'application p. 271 | Antécédent direct : des covariables prédites spatialement peuvent induire une covariance résiduelle dans un modèle dont les erreurs conditionnelles complètes sont indépendantes. |
| Tiedeman et Green, 2013, [texte éditeur](https://agupubs.onlinelibrary.wiley.com/doi/full/10.1002/wrcr.20499) | Résumé, introduction et début des méthodes du HTML | Des observations dérivées de mêmes mesures sources peuvent avoir des erreurs corrélées ; ce mécanisme a des antécédents explicites. |

Les textes de Schreck, Curth, SpaCE et Gotway–Young consultés au passage précédent restent mobilisés via le [complément bibliographique](complement_litterature_plasmode_2026-09-09.md), qui précise leurs versions et limites de lecture.

## 2. Priorité 1 — Justifier les sites fixes

### Ce que les résultats publiés permettent de dire

Dans Stolte 2024, le sous-échantillonnage à petite proportion fonctionne souvent bien, mais **la taille finale simulée n est maintenue** : une proportion π plus petite suppose un réservoir initial de taille n/π plus grand. Prendre 10 % de Meuse ne reproduirait donc pas ce résultat : on changerait aussi la taille de la tâche. Lorsque le réservoir ne dépasse pas la taille visée, les auteurs considèrent l'absence de rééchantillonnage comme une option raisonnable. Cela concerne leur cadre de régression linéaire et de MSE d'estimation des coefficients.

Stolte 2025 compare cinq classifieurs pour n = 100, avec différentes dimensions et métriques. L'absence de rééchantillonnage donne souvent de bons résultats, sans domination systématique. Les variations d'OGM et de dimension ne sont pas totalement séparables dans leur plan. Il ne faut donc convertir ces observations ni en théorème spatial ni en règle universelle « ne jamais rééchantillonner ».

Chez Lahiri–Zhu, les sites suivent une densité éventuellement non uniforme, indépendante du champ d'erreur ; le domaine croît, avec possibilité d'augmentation de densité. Les erreurs forment un champ stationnaire soumis à des conditions de dépendance, dans un cadre de régression et de M-estimation. Les auteurs montrent une difficulté du bootstrap par blocs centrés sur les sites et proposent une construction sur grille externe. **Ce n'est pas une justification générale pour rééchantillonner arbitrairement des points, des polygones ou des tâches ML**, ni un traitement automatique de l'échantillonnage préférentiel.

### Notre choix et sa cible exacte

On conditionne sur le jeu source, les sites s, les covariables X, la calibration C, les paramètres estimés du générateur, la matrice W et les folds F. Pour une famille génératrice G :

\[
Y_i^{(b,G)}=m_G(X_i)+\sigma_G\varepsilon_i^{(b)},
\qquad \varepsilon^{(b)}\sim\mathcal N(0,I).
\]

Le risque étudié dans cette étape est :

\[
R_{a,G}=\mathbb E_{\varepsilon}\left[
\frac{1}{n\,\operatorname{Var}_{i}(m_G)}
\sum_{i=1}^{n}\{\widehat m_{a,-F(i)}(X_i,s_i)-m_G(X_i)\}^{2}
\mid X,s,C,W,F,\widehat\theta_G\right].
\]

`Var_i` est la variance empirique calculée par `var()` de R, avec diviseur n−1. Chaque prédiction utilise les autres folds, sur une réponse simulée. C'est un risque sur la moyenne latente aux sites réservés, et non une garantie sur un futur territoire ou sur l'estimation de paramètres réels.

Concrètement, les sites de calibration sont un site sur trois dans l'ordre est–ouest. Ils sont exclus de l'évaluation simulée. Les sites restants sont répartis en trois bandes est–ouest fixes. On conserve les tailles du pilote : Georgia 53 sites de calibration et 106 d'évaluation ; Meuse 51 et 102, après les mêmes exclusions pour données manquantes.

La fidélité sur Y réel hors calibration est calculée séparément. Ces sites sont géographiquement entrelacés avec la calibration : cette mesure n'établit pas un transfert vers un territoire éloigné. Les covariables et la géométrie de l'ensemble des sites sont connues ; les Y réels d'évaluation ne servent pas à ajuster le générateur.

### Quand ouvrir une branche de rééchantillonnage

Elle devient nécessaire si la cible est explicitement une nouvelle réalisation des sites ou la distribution d'un estimateur sous un plan d'échantillonnage. Il faudra alors choisir l'unité rééchantillonnée, le domaine cible, la taille finale, la portée de dépendance et le traitement des doublons, puis examiner si les hypothèses d'un bootstrap spatial donné sont adaptées. Une répétition de la calibration et une sélection de nouveaux datasets sources répondent encore à deux autres incertitudes. Elles ne sont pas remplacées par davantage de tirages d'epsilon.

**Paragraphe proposé pour le data paper :** « Nous conservons les covariables et les sites des jeux sources et régénérons les réponses conditionnellement à ces supports. Ce choix définit une évaluation conditionnelle permettant d'isoler les effets du générateur et du bruit tout en préservant la configuration empirique. Les réplications quantifient la variabilité des réponses simulées ; elles ne quantifient ni la représentativité des territoires retenus ni l'incertitude sur la calibration du générateur. »

## 3. Priorité 2 — Sensibilité à la famille génératrice

### Expérience distincte du pilote initial

Le [script exécuté](priorites_plasmode.R) ajuste deux générateurs sur **les mêmes Y réels de calibration et les mêmes X** :

- polynôme : x1 + x2 + z + x1² + x2² + x1:x2, identique à la base complète du pilote ;
- forêt `ranger` : 300 arbres, mtry = 2, taille minimale de nœud = 5, graine fixée, un thread.

Ces formes sont des choix du protocole, pas des formules empiriques attribuées aux articles des jeux sources. Les générateurs n'utilisent pas les coordonnées comme prédicteurs et lambda reste nul. Tous les concurrents reçoivent les trois covariables ; le polynôme concurrent n'a donc ici aucun accès privilégié à une variable masquée.

Cinq configurations sont évaluées : régression linéaire, polynôme, GAM de covariables, même GAM enrichi d'un lissage des coordonnées, forêt. Pour les GAM, les réglages du pilote sont conservés. Aucun réglage n'est choisi à partir des résultats ; ce premier test n'a pas de recherche d'hyperparamètres.

On fixe 40 réplications par source et famille, un rapport variance du signal / variance marginale attendue du bruit de 3, et les mêmes innovations standardisées entre familles. Le bruit est multiplié par sigma_G = sqrt(var(m_G)/3) : les deux problèmes ont le même SNR, **pas nécessairement la même amplitude, complexité ou difficulté**. Les graines algorithmiques sont fixes entre réplications.

Les fichiers de configuration sont écrits avant les ajustements. Vérités, modèles générateurs, prédictions hors fold, graines, diagnostics et versions logicielles sont conservés dans [les sorties séparées](priority_output_2026-09-09/config.json). Le script refuse d'écraser un répertoire de sortie existant.

### Lecture des écarts

On calcule les différences appariées de NMSE : forêt moins polynôme, GAM spatial moins GAM de covariables, GAM de covariables moins polynôme. Une différence négative indique seulement un risque moyen plus faible pour le premier terme, dans ce scénario. L'erreur Monte Carlo est sd(différences)/sqrt(B), avec B = 40 ; le changement d'écart entre familles est lui aussi apparié par réplication.

Une inversion du signe entre générateurs établirait une sensibilité du résultat à la famille génératrice dans ces configurations. Elle ne prouverait pas qu'une méthode est intrinsèquement biaisée, qu'un générateur représente mieux la réalité, ni que l'une des méthodes est meilleure en général. Les conclusions restent conditionnelles aux deux sources et aux réglages retenus. Aucun verdict statistique du package n'est calculé ici.

Le nombre final de réplications devra être fondé sur une précision désirée pour ces différences. À titre de règle de planification, pour une MCSE cible δ, utiliser B ≈ (sd(différences)/δ)², arrondir vers le haut, puis vérifier la précision obtenue. Une approximation ±1,96 MCSE décrit l'incertitude Monte Carlo de la moyenne sous des conditions usuelles ; elle ne couvre pas le choix du dataset ou de l'OGM.

## 4. Priorité 3 — Deux mécanismes d'observation et une piste précise sur les X

### A. Supports recouvrants ou lissage de Y

On part d'un mécanisme latent sans propagation : Y* = m(X) + sigma epsilon, avec innovations indépendantes. Puis l'instrument ou la chaîne de traitement restitue :

\[
Y^{obs}=H_{obs}Y^*,\quad
\mathbb E(Y^{obs}\mid X,H_{obs})=H_{obs}m(X),\quad
\operatorname{Cov}(Y^{obs}\mid X,H_{obs})=\sigma^2H_{obs}H_{obs}'.
\]

Pour des poids non négatifs, deux lignes partageant une même mesure source peuvent produire une covariance positive. L'appellation « aspatial » ne vaut que pour le mécanisme latent conditionnel : **le processus d'observation crée ici une véritable covariance**, pas seulement une apparence graphique. Cette déduction algébrique est notre construction de scénario ; Tiedeman–Green fournit un antécédent appliqué pour les mesures sources partagées. Leur article montre aussi que négliger les corrélations peut augmenter ou diminuer certaines incertitudes : il n'autorise pas une affirmation universelle de sous-estimation.

Le diagnostic utilise H_obs = (1−alpha)I + alpha W pour alpha = 0, 0,25 et 0,5, avec le W documenté du pilote. Pour 10 000 tirages, il compare covariance simulée et covariance analytique, et l'indice de Moran à un contrôle indépendant ayant **les mêmes variances marginales**. Le contrôle évite de confondre hétéroscédasticité et covariance. La moyenne observée correcte est H_obs m, pas m. Le SNR après observation n'est pas automatiquement conservé.

**Condition avant toute comparaison prédictive :** conserver les indices des mesures sources entrant dans chaque observation. Si des observations train et test partagent ces mesures, les folds ne constituent pas des ensembles de sources indépendants. Pour un objectif de transfert indépendant, il faut purger les supports partagés, choisir une séparation adaptée à l'étendue de H_obs et vérifier la taille restante. Pour une tâche visant délibérément des produits recouvrants, ce partage peut faire partie de la cible, mais doit être déclaré. Le diagnostic actuel compte ces paires ; il ne score pas les méthodes sur ces réponses lissées.

### B. Agrégation disjointe d'une moyenne non linéaire

Pour une zone j, la bonne moyenne est la moyenne des f(X_i), et non f de la moyenne des X. Dans notre polynôme, l'écart exact vaut :

\[
\overline{f(X)}_j-f(\overline X_j)=
\beta_{11}V_j(X_1)+\beta_{22}V_j(X_2)
+\beta_{12}C_j(X_1,X_2).
\]

V et C désignent ici les moments internes calculés avec le diviseur n_j. Les termes linéaires s'annulent. Des dispersions internes organisées géographiquement peuvent ainsi former un signal résiduel omis ; son autocorrélation n'est pas garantie.

Le test regroupe les sites d'évaluation par trois dans l'ordre est–ouest, avec un dernier groupe éventuellement plus petit. Ce regroupement est un contrôle algébrique sur covariables réelles, **pas une reconstitution de zones administratives ni une étude complète du MAUP**. Il vérifie que les moments internes restituent exactement la moyenne agrégée. Pour des groupes disjoints et des innovations indépendantes, sigma² AA' est diagonale : l'agrégation seule ne crée pas de covariance entre bruits de zones. Elle peut changer leurs variances si les tailles diffèrent.

Les moyennes de coordonnées servent uniquement aux diagnostics de voisinage des groupes. Des zones contiguës, plusieurs découpages et une interprétation substantive des unités agrégées seront nécessaires pour faire de ce scénario un composant crédible du data paper. Pour Meuse, on agrège ici log(zinc), sans l'interpréter comme le logarithme d'une concentration moyenne.

### C. Covariable spatiale interpolée : nouvel antécédent ciblé

Gryparis et al. écrivent X* = S* + V*, où S* prédit l'exposition à des sites sans mesure. Dans leur cadre gaussien à covariance connue, V* a une covariance conditionnelle généralement non diagonale. Pour Y = beta0 + beta1 X* + epsilon, remplacer X* par S* donne une erreur beta1 V* + epsilon et donc une covariance beta1² Var(V* | mesures) + sigma_epsilon² I. Les sections 3 et 4.1 établissent directement ce lien. L'analogie de Berkson est exacte sous les hypothèses indiquées ; elle ne l'est pas automatiquement lorsque le lissage et ses paramètres sont estimés. [Article](https://doi.org/10.1093/biostatistics/kxn033).

**Adaptation proposée à notre plasmode, non exécutée dans ce test :** garder X réel fixe, choisir des sites de mesure, observer X_M + eta et fabriquer une covariable interpolée S = L(X_M + eta). Le résidu dû au remplacement contient beta1(X−LX_M)−beta1 L eta : une erreur de moyenne fixe et, si eta est retiré à chaque réplication, une covariance beta1² L Var(eta)L'. Cela permettrait d'isoler biais de lissage et bruit des mesures sans simuler tout X par un processus gaussien.

Attention au conditionnement : si X, les mesures et S sont tous figés, X−S est un signal fixe. On ne peut pas lui attribuer la covariance de l'article en répétant seulement epsilon. Il faut dire quelle couche est aléatoire et répéter effectivement cette couche. Ce point doit guider le prochain scénario de mesure ; le simple proxy indépendant du premier pilote ne couvre pas encore l'interpolation spatiale.

## 5. Résultats du test et suites

Les résultats chiffrés sont consignés dans [le rapport de calcul](priority_output_2026-09-09/lecture_resultats.md), avec les sorties [JSON](priority_output_2026-09-09/results.json) et RDS. Ils complètent le protocole ci-dessus, sans constituer une validation générale du data paper.

Ordre de la prochaine étape :

1. Exploiter la sensibilité observée pour conserver plusieurs familles génératrices ; examiner la fidélité de chacune et ses écarts de risque, avant de choisir d'autres formes.
2. Ajouter le scénario de covariable interpolée avec une couche de mesure répétée et une cible explicite ; contrôler la provenance des mesures utilisées par train et test.
3. Construire des supports d'agrégation substantivement défendables et des folds qui respectent les supports d'observation ; répéter ensuite calibration et partition géographique.
4. Traiter la portée spatiale de g/u et la couverture des datasets, encore ouverts dans le complément bibliographique. Ces deux chantiers ne sont pas résolus par les calculs actuels.

La contribution à défendre reste la banque de supports réels, les interventions contrôlées et la traçabilité des mécanismes. Ces recherches ne fondent pas une revendication de nouveauté des mécanismes eux-mêmes.
