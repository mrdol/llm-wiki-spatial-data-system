# S4 — champs spatiaux calibrés : contrôles et lots de 40 répétitions

Date : 15 septembre 2026. Statut : **lots non conditionnel et conditionnel par pli de 40 répétitions exécutés sur Georgia/Meuse, puis sur Banff ; observations conditionnantes bruitées et généralisation ouvertes**.

## Question et séparation des deux variantes

Le script `scenario_s4_calibrated_fields.R` utilise les sites et covariables réels de Georgia et Meuse et les générateurs polynomial/forêt déjà calibrés. Il distingue :

- **innovation spatiale** : `Y* = m(X) + u(s)` ; le champ est retiré de la vérité de moyenne, qui reste `m(X)`, et renouvelé à chaque répétition ;
- **tendance spatiale** : `Y* = m(X) + g(s) + epsilon` ; le champ `g` et `epsilon` sont renouvelés à chaque répétition ; la vérité de moyenne de cette répétition est `m(X)+g(s)`.

Cela permet de tester séparément une structure spatiale dans la moyenne et dans l'innovation. Les deux lots comparent les réglages de chaque variante ; ils ne démontrent pas qu'elles soient distinguables à partir d'une seule réponse observée.

## Calibration et restriction nécessaire

La covariance est exponentielle avec pépite diagonale. La **portée effective** est la distance à laquelle la corrélation exponentielle vaut 0,05 ; sa cible est une fraction du diamètre métrique de chaque source. La variance spatiale cible est résolue à partir de `pi_s = Var(g)/(Var(m)+Var(g))`, où la variance du champ est l'espérance de sa variance empirique centrée sur les sites fixes. L'amplitude native de covariance tient donc compte de la géométrie propre à chaque dataset.

Dans **les deux** variantes, le SNR du script vaut `Var(m)/E[Var(champ spatial + bruit indépendant)]`. SNR et part spatiale fixent les variances spatiale et totale. **La pépite en découle** : avec seulement un champ spatial et un bruit diagonal, elle n'est pas un troisième facteur indépendant. Les combinaisons où la variance spatiale demanderait plus que la variance totale du bruit sont refusées. LeSage–Pace emploient dans leur exemple SAR un SNR entre 0 et 1, proche d'un R², alors que notre script emploie un ratio signal/bruit égal à 3 ; ces nombres ne doivent pas être assimilés. Sous une même définition de signal et de bruit, le ratio 3 correspond à une fraction signal/(signal+bruit) de 0,75. Cette conversion simple n'est pas l'équation SAR complète du papier.

La réponse simulée non conditionnelle est **la même** pour les variantes `g` et `u` à source, générateur, réglage et répétition égaux. Les composants spatiaux et indépendants sont appariés ; seule la cible d'évaluation change (`m+g` contre `m`). Les deux variantes ont donc la même loi marginale de réponse : il serait faux de les présenter comme deux mécanismes observablement séparables avec une seule réalisation. Leur intérêt est de distinguer les questions d'estimation de la moyenne et de l'innovation.

Les réalisations conditionnelles utilisent la distribution gaussienne exacte du champ sur les sites libres, étant données les valeurs sur les sites conditionnants. Le programme garde les sites conditionnants à leur valeur imposée ; il ne modélise pas encore des mesures de conditionnement bruitées.

## Contrôles et premier essai

Le test vérifie les cibles attendues de SNR, de part spatiale et de portée, la positivité de covariance, le contrôle sans champ spatial, le refus d'une combinaison impossible, la reproductibilité, l'honneur exact des sites conditionnants et la convergence de 5 000 tirages indépendants vers la covariance voulue. Il passe.

Un essai initial de la variante innovation seule a produit **240 évaluations, zéro échec**. Le premier lot à deux variantes, **480 évaluations**, a révélé lors de la relecture de White et al. que `g` y était fixé entre répétitions. **Ce lot est écarté de l'interprétation** et conservé uniquement comme trace de faisabilité. Le lot corrigé a de nouveau produit **480 évaluations, zéro échec et zéro avertissement de modèle**. Ses 48 paires de réponses (une par source/générateur/part/portée/répétition, avant duplication par méthode) concordent à l'arrondi numérique près ; les cibles latentes diffèrent pour les 32 paires où la part spatiale est non nulle. Les cibles attendues de SNR et de part spatiale correspondent aux valeurs demandées dans toutes les configurations. Les ajustements utilisent les trois plis géographiques du pilote de départ, sans tampon ; leurs chiffres de risque ne sont donc pas des résultats publiables.

Les sorties corrigées sont dans `scenario_s4_corrected_smoke_2026-09-15/`. Le test est `test_scenario_s4_calibrated_fields.R`. Un petit contrôle supplémentaire après ajout du diagnostic de corrélation champ–X a produit 80 évaluations sans échec.

## Contrôle des champs sur les deux sources

Le script `check_s4_sources.R` a vérifié **16 réglages** (deux sources, deux générateurs, deux parts spatiales non nulles et deux portées) avec **1 000 tirages non conditionnels par réglage**, puis **32 configurations conditionnelles** (champ complet d'innovation et champ spatial de tendance). La variance empirique moyenne du bruit diffère de la cible de −0,94 % à +0,92 %. L'écart relatif de covariance complète vaut 0,165 à 0,326 avec 1 000 tirages et environ une centaine de sites ; il n'est pas interprété comme un défaut de calibration sans précision Monte Carlo supplémentaire. Les variances conditionnelles empiriques moyennes diffèrent des valeurs analytiques de +0,58 % à +1,66 %.

Les 13 ou 14 sites conditionnants selon la source sont pris uniquement parmi les sites d'apprentissage **après tampon métrique** pour la bande test 3. **Aucun** n'est dans cette bande, chaque distance site conditionnant–test dépasse le tampon, et l'écart maximum aux valeurs imposées est zéro pour les deux types de champ. Le choix d'un site sur cinq est construit pour le contrôle et ne constitue pas un réseau d'observation publié.

## Tampon, variogramme et précision Monte Carlo fixés

Le tampon vaut la médiane des distances au plus proche autre site sur chaque source : **26,93 km pour Georgia** et **116,83 m pour Meuse**. Il exclut entre **1 et 6** observations d'apprentissage selon la bande Georgia et entre **0 et 1** sur Meuse ; il reste 65 à 69 observations d'apprentissage. Le test vérifie pour chaque pli que la distance minimale train–test est strictement supérieure au tampon. Changer artificiellement la réponse du pli test ne change pas les prédictions linéaires contrôlées.

Le lot d'estimateurs **corrigé avec tampon** garde 480 évaluations sur deux répétitions, **zéro échec et zéro avertissement** ; ses 48 paires de réponses `g`/`u` restent identiques à l'arrondi numérique près. Ces deux répétitions restent un contrôle technique, pas un classement de méthodes. Les sorties sont dans `scenario_s4_buffered_smoke_2026-09-15/`.

La précision des champs a été vérifiée avec **3 000 tirages par réglage** sur 16 réglages, 32 contrôles conditionnels et **128 classes de distance de variogramme** (quatre par réglage et variante). Les cibles fixées avant le lot de 40 sont : MCSE de la variance moyenne au plus 2 % de sa cible, MCSE du variogramme moyen au plus 5 % de sa valeur attendue, et erreur relative de la covariance complète (norme de Frobenius) au plus 20 %. À 3 000 tirages, les besoins estimés les plus élevés sont respectivement **168**, **70** et **2 581** tirages ; l'erreur relative de covariance complète observée va de **9,1 % à 18,5 %**. Les 128 écarts de variogramme restent entre −2,01 et +2,01 MCSE ; ce contrôle descriptif ne constitue pas un test global de modèle à 128 comparaisons.

Le premier contrôle de champ conditionnel avait seulement la bande 3 comme région test. La tâche prédictive sur **chacun** des trois plis est désormais implémentée ci-dessous. Les sorties du contrôle à 3 000 tirages restent dans `scenario_s4_source_checks_validation_2026-09-15/` ; le script valide explicitement les trois seuils de précision et cette exécution a passé la validation.

## Tâche conditionnelle par pli

Le scénario prédictif conditionnel utilise désormais **les trois plis**, chacun avec ses sites de conditionnement choisis parmi les sites d'apprentissage après tampon. Le réseau construit prend un site sur cinq dans l'ordre des sites d'apprentissage du pli ; son choix ne vient pas des papiers Georgia ou Meuse. Les valeurs imposées au **champ spatial latent** sont tirées une fois par source, générateur, part spatiale, portée et pli, puis restent fixes entre répétitions. Les tirages de base des valeurs imposées sont appariés entre parts spatiales et portées d'un même pli ; les valeurs elles-mêmes changent avec la covariance. Une décomposition de la covariance conditionnelle est préparée une seule fois pour chacun de ces réglages. À chaque répétition, un nouveau champ est tiré sous ces mêmes valeurs et seules les observations de l'apprentissage du pli servent à ajuster l'estimateur. Le pli test ne fournit aucune valeur conditionnante ni réponse d'apprentissage.

Le RDS conditionnel regroupe les contrôles de sites (nombre, distance minimale à la bande test, respect des valeurs imposées), les risques prédictifs et une ventilation descriptive de l'erreur des sites test **proches ou éloignés** de leur site conditionnant le plus proche, selon la médiane de chaque pli. Cette ventilation n'isole pas un effet causal de la distance : covariables, positions et difficultés des bandes varient aussi. Les observations conditionnantes sont ici des valeurs exactes du champ latent ; le cas de valeurs de champ incertaines ou de réponses observées avec bruit est une autre tâche.

Les valeurs latentes imposées sont **synthétiques** ; elles ne sont pas des résidus spatiaux mesurés dans Georgia ou Meuse. Elles conditionnent le générateur, mais ne sont pas transmises directement aux cinq estimateurs : ceux-ci reçoivent seulement les réponses simulées de leurs sites d'apprentissage. La calibration SNR/part spatiale est définie pour la loi **marginale avant conditionnement**. Les valeurs de champ fixées modifient la moyenne et la variance conditionnelles ; la comparaison brute des risques conditionnels et non conditionnels ne peut donc pas être présentée comme l'effet du seul conditionnement. Au contrôle `pi_s=0`, aucun champ n'est imposé et les réponses simulées restent celles du contrôle non conditionnel.

### Lot conditionnel de 40 répétitions

Le lot a produit **8 000 évaluations, zéro échec, zéro avertissement**, 200 résumés de risque, **400 contrastes appariés de 40 répétitions**, 120 contrôles de conditionnement et 48 000 lignes de diagnostic par distance. Le tout se trouve dans **un seul nouveau RDS**, `scenario_s4_40_conditional_2026-09-15/results.rds`, sans CSV. Pour les 120 contrôles, les 13 sites conditionnants de chaque pli sont hors de la bande test, leur distance à cette bande dépasse le tampon et les valeurs imposées sont honorées exactement. Les graines des valeurs imposées sont communes entre réglages spatiaux d'une même source/générateur/pli. Les **4 000 paires** de réponses simulées `g`/`u` ont des sommes de carrés identiques ; les **1 600 évaluations** du contrôle sans champ reproduisent exactement le RDS non conditionnel, réponses et NMSE compris. L'empreinte MD5 enregistrée pour ce lot correspond au script local lors du contrôle.

| Contraste conditionnel de NMSE | Nombre | Signe positif | Écart positif > 2 MCSE | Exceptions négatives < −2 MCSE |
|---|---:|---:|---:|---:|
| Champ spatial − contrôle nul | 160 | 145 | 126 | 5 |
| Portée 30 % − portée 10 % | 80 | 53 | 44 | 7 |
| Part spatiale 0,2 − 0,1 | 80 | 77 | 69 | 0 |
| GAM spatial − GAM sur covariables | 40 | 39 | 39 | 0 |

La portée longue **n'augmente plus le risque dans tous les contextes** comme dans le lot non conditionnel : 27 des 80 contrastes sont négatifs, dont sept au-delà de deux MCSE en valeur absolue. Les 40 comparaisons de portée pour l'innovation ont 31 signes positifs ; celles pour la tendance en ont 22. Cette variation dépend du mécanisme, des sites et des valeurs conditionnantes. Les écarts négatifs et positifs du tableau sont des repères de précision Monte Carlo **conditionnels aux valeurs imposées fixes**, sans correction des nombreuses comparaisons. Le contraste champ–contrôle de `g` change aussi la cible et sa variance.

L'erreur des sites test éloignés dépasse celle des sites proches dans **10 des 100 contextes moyens Georgia**, contre **77 des 100 Meuse**. La différence existe déjà au contrôle sans champ : **0/20 contextes Georgia** et **16/20 Meuse** présentent un risque plus élevé dans le groupe éloigné. Ce diagnostic ne prouve donc pas un effet du conditionnement ou de la distance seule ; la géographie, les covariables et les bandes peuvent expliquer une partie du contraste. Il faut répéter l'expérience avec d'autres réseaux et d'autres valeurs imposées pour mesurer leur variabilité.

## Lot non conditionnel de 40 répétitions

Le plan a deux sources, deux générateurs de moyenne, deux variantes `g`/`u`, cinq estimateurs, deux portées non nulles (10 et 30 % du diamètre) et deux parts spatiales non nulles (0,1 et 0,2), plus un contrôle `pi_s=0` exécuté **une seule fois** par source/générateur/variante. Cela donne **8 000 évaluations**, **zéro échec**, **zéro avertissement**, **200 résumés de risque** et **400 contrastes appariés de 40 répétitions chacun**. Aucun CSV n'a été créé : les données brutes, résumés, contrastes, contrôles de split, provenance et session R sont réunis dans `scenario_s4_40_2026-09-15/results.rds` (environ 0,12 Mo).

Le même tirage gaussien de base est réutilisé pour comparer portées, parts spatiales et méthodes. Sur chaque source/générateur/répétition, un seul identifiant de tirage apparaît entre réglages. Les réponses des variantes `g` et `u` concordent à l'arrondi numérique près sur 800 paires de configurations contrôlées ; au contrôle sans champ, leurs risques sont exactement égaux. L'empreinte MD5 du script dans le RDS documente la version du script lors de ce lot ; la branche conditionnelle a été ajoutée ensuite, donc cette empreinte n'est plus celle du fichier local actuel. Ces contrôles permettent d'interpréter les écarts comme des **contrastes appariés de scénarios**, conditionnels aux sources et générateurs choisis.

| Contraste de NMSE de la moyenne latente | Nombre | Signe positif | Écart positif supérieur à 2 MCSE | Lecture prudente |
|---|---:|---:|---:|---|
| Champ spatial − contrôle nul | 160 | 147 | 121 | Le risque monte généralement. Pour `g`, la cible et sa variance changent aussi : ce contraste n'isole pas la seule difficulté d'apprentissage. |
| Portée 30 % − portée 10 % | 80 | 80 | 56 | Une portée plus longue accroît le risque dans tous les contextes du pilote, mais 24 écarts restent petits au regard de leur MCSE. |
| Part spatiale 0,2 − 0,1 | 80 | 75 | 66 | L'effet est majoritairement défavorable, avec cinq exceptions ; il dépend de la cible et de l'estimateur. |
| GAM spatial − GAM sur covariables | 40 | 40 | 39 | Le terme spatial ajouté ne gagne pas dans ces plis et réglages ; le GAM spatial fait déjà moins bien au contrôle nul, donc l'écart n'est pas uniquement causé par le champ. |

Dans le contraste champ–contrôle, un des 13 écarts négatifs dépasse aussi 2 MCSE en valeur absolue. Le tableau compte seulement les écarts positifs.

« Supérieur à 2 MCSE » est un repère descriptif de précision Monte Carlo, **pas** une déclaration de significativité après correction des nombreuses comparaisons. Le GAM spatial utilise ici un lissage `s(sx,sy,k=10)` fixé, les mêmes cinq méthodes non réajustées et des bandes géographiques avec tampon ; un comportement de transfert ou un réglage inadéquat peut contribuer à son risque. Le signe du contraste forêt − polynôme dépend du **générateur** : sur les 20 configurations à vérité forêt, la forêt fait mieux ; sur les 20 à vérité polynomiale, le polynôme fait mieux. Cela confirme la sensibilité déjà observée dans S1/S2 et interdit un classement universel.

Les MCSE portent sur les champs et bruits renouvelés, **conditionnellement** aux deux datasets, aux sites fixes, aux fonctions génératrices apprises et au plan de plis. Le RDS ne constitue ni une réplication entre datasets indépendants ni une validation de la covariance spatiale réelle de Georgia ou Meuse. Les variantes `g` et `u` ont la même loi marginale de réponse dans ce plan ; leurs scores ne doivent pas être comparés directement comme si leurs vérités de moyenne étaient identiques.

## Troisième source : Banff stream temperature

Le troisième essai utilise le RDS de la banque `paper_banff_stream_temperature` et sa fiche vérifiée contre le TEI de Struthers et al. (2024). Les **110 sites de mesure** ont `WaterTemp` en réponse et les trois covariables finales des auteurs, `Elev`, `RSlope` et `LE`, sans valeur manquante ; `Year_` vaut 2018 partout. Les colonnes d'origine `Easting`/`Northing` sont en mètres UTM zone 11 d'après le README des données brutes et la fiche. Le RDS `sf` ne porte toutefois pas de CRS actif : le script utilise les coordonnées d'origine sans transformation. Le plan réserve 36 sites à la calibration du générateur et 74 à l'évaluation. Ses trois plis conservent 47 à 49 sites d'apprentissage après un tampon de **1 499,58 m**.

Le polynôme de notre plasmode emploie les **mêmes trois X**, avec des termes de courbure et d'interaction créés pour l'expérience ; ces derniers ne sont pas la formule publiée. La forêt est le second générateur. Sur la température réelle tenue hors calibration, leurs R² sont respectivement **0,1566** et **0,2499** (RMSE 2,0551 et 1,9382 °C) : la fidélité empirique est limitée. Dans les GAM, `LE` binaire entre comme effet paramétrique, car un lissage `s(LE,k=4)` n'est pas identifiable avec deux valeurs ; les autres méthodes et le plan S4 restent ceux des deux premières sources.

Sur la géométrie Banff, **3 000 tirages pour chacun des huit réglages spatiaux non nuls** ont donné une MCSE de variance au plus 0,47 % de la cible, un écart relatif de covariance complète au plus 15,43 % et un écart de variance moyenne au plus 0,4 MCSE. Cela satisfait les seuils techniques fixés précédemment. Les deux lots de 40 répétitions ont produit **4 000 évaluations et 200 contrastes appariés chacun**, sans échec ni avertissement de modèle. Les 60 contrôles du mode conditionnel utilisent neuf sites imposés par pli, hors bande test et à au moins **1 402,76 m au-delà du tampon** ; ils sont honorés exactement. Les **800 évaluations** sans champ reproduisent exactement les réponses et NMSE du lot non conditionnel. Les réponses simulées `g`/`u` restent identiques à l'arrondi dans chaque mode. Les deux lots, leurs métadonnées et les 24 000 lignes descriptives du risque par distance sont réunis dans **un seul nouveau RDS**, `scenario_s4_banff_40_2026-09-15/results.rds`, sans CSV.

| Contraste de risque Banff | Sans conditionnement : signe positif | Avec conditionnement : signe positif | Écarts positifs > 2 MCSE (sans / avec) | Exceptions négatives < −2 MCSE (sans / avec) |
|---|---:|---:|---:|---:|
| Champ spatial − contrôle nul | 75 / 80 | 66 / 80 | 59 / 54 | 0 / 0 |
| Portée 30 % − portée 10 % | **34 / 40** | **27 / 40** | 23 / 18 | 1 / 6 |
| Part spatiale 0,2 − 0,1 | 40 / 40 | 39 / 40 | 36 / 31 | 0 / 0 |
| GAM spatial − GAM sur covariables | 19 / 20 | 20 / 20 | 11 / 16 | 0 / 0 |

Pour la **portée**, les 20 contrastes d'innovation sans conditionnement sont tous positifs ; avec conditionnement, 19 le sont. Pour la tendance `g`, seulement **14/20** sont positifs sans conditionnement et **8/20** avec conditionnement ; six écarts conditionnels opposés dépassent deux MCSE en valeur absolue. Banff contredit donc une règle générale « portée plus longue = risque plus élevé », déjà pour le lot non conditionnel. Le score de `g` change aussi de cible et de variance avec le champ, et les valeurs imposées restent fixes entre répétitions : les MCSE ne couvrent pas d'autres valeurs conditionnantes. Le repère 2 MCSE est descriptif, sans correction des nombreuses comparaisons.

Le groupe de sites test éloignés a plus de risque que le groupe proche dans **65/100 contextes moyens**, mais déjà **12/20** au contrôle sans champ. Surtout, le papier emploie des covariances **sur réseau hydrographique**, sensibles à la connectivité et au sens du flux, et un modèle INLA avec champ barrière/effet de bassin ; S4 utilise une covariance exponentielle euclidienne et n'inclut pas ces composants. Les distances proches/éloignées sont donc un diagnostic interne du plasmode, **pas** une conclusion hydrologique ou une reproduction du modèle publié. La troisième source vérifie la portabilité technique sur de vrais sites/covariables d'un autre domaine ; les signes de risque et la faible fidélité du générateur empêchent encore une généralisation scientifique.

## À faire avant une interprétation scientifique

1. Décider si la pépite dérivée suffit au premier lot ou si un autre plan doit lui permettre de varier indépendamment ; garder une échelle SNR explicitement distincte de celle de LeSage–Pace.
2. Traiter séparément les observations conditionnantes bruitées et renouveler les réseaux et les valeurs imposées ; la tâche conditionnelle exacte par pli et le diagnostic descriptif par distance sont terminés pour ce premier plan.
3. Ajouter le Moran à plusieurs voisinages et, éventuellement, un contrôle de portée empirique ; les cibles de précision pour variance, variogramme et covariance complète sont fixées et atteintes à 3 000 tirages.
4. Réviser les conclusions scientifiques seulement après les observations conditionnantes bruitées, des réseaux alternatifs et davantage de sources ; les lots de 40 répétitions Georgia/Meuse et Banff et leurs contrastes/MCSE sont terminés.
5. Examiner ensuite anisotropie et éventuellement Matérn ; elles ne font pas partie de cette preuve de faisabilité.

S4 reste un script autonome dans la revue, sans intégration aux moteurs du package. Les lots Georgia/Meuse et Banff et leurs limites figurent dans le HTML principal.
