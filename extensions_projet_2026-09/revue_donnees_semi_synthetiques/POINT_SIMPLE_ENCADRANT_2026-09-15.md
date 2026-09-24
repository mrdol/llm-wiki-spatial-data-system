# Point simple sur la revue semi-synthétique et les pilotes

Date : 15 septembre 2026. Ce document distingue **ce que contient le HTML**, **ce qui a été calculé à côté** et **ce qui reste à décider**.

## Notre objectif de départ

Nous avons retenu la famille C, le **plasmode** : partir de vrais sites et de vraies covariables, ajuster une fonction sur une partie des données, puis fabriquer des réponses dont la vérité est connue pour comparer des méthodes. L'objectif donné par l'encadrant est de faire varier principalement **la forme de `f(X)`**, **une tendance spatiale `g(s)`**, **la dépendance des erreurs `u` contrôlée notamment par `lambda`**, et d'examiner les situations qui donnent l'apparence d'un processus spatial sans propagation entre réponses voisines. D9, une variable spatiale omise, n'est qu'un exemple.

## Où en est le HTML ?

Le document `revue_donnees_semi_synthetiques.html` contient la revue bibliographique actualisée et les expériences pilotes **S1, S2, S3 et les deux modes S4 sur Georgia/Meuse puis Banff**. Il explique les méthodes plasmodes, les limites de la simulation fondée sur des données réelles, et les mécanismes pouvant produire un motif spatial trompeur.

| Travail | Sens simple | Dans le HTML ? | Maturité réelle |
|---|---|---|---|
| Revue des articles | Ce que la littérature permet de construire et les précautions méthodologiques | Oui | Lectures prioritaires terminées ; synthèse à réutiliser dans le data paper |
| Pilote de départ P0–P6 | Vérifier que l'on sait générer une vérité connue avec Georgia et Meuse | Oui, en synthèse | Faisabilité technique ; **ce n'est pas la grille D0–D9 complète** |
| S1 — supports recouvrants | Deux observations réutilisent des mesures sources communes : leurs erreurs deviennent corrélées | Oui | Lot initial exécuté et testé ; supports ponctuels **construits**, non observés dans les papiers |
| S2 — agrégation non linéaire | La moyenne d'une relation non linéaire diffère de la relation évaluée sur les moyennes des covariables | Oui | Lot initial exécuté et testé ; zonages **construits**, à élargir avant généralisation |
| S3 — covariable interpolée | Une covariable manque à certains endroits et est reconstruite depuis un réseau partiel | Oui, comme pilote avec ses limites | Deux lots de 40 répétitions et 20 réseaux alternatifs ; étude scientifique incomplète |
| S4 — champs spatiaux calibrés | Faire varier directement `g(s)` et les erreurs spatiales `u`, avec force et portée comparables | Oui, avec ses limites | Deux modes de 40 répétitions sur Georgia/Meuse (8 000 évaluations chacun) et Banff (4 000 chacun), sans échec ; valeurs latentes conditionnantes exactes et synthétiques |

Les scripts S1–S4 se trouvent dans le dossier de la revue, **pas dans les moteurs du package**. Aucun résultat de ces pilotes ne démontre qu'un estimateur est généralement supérieur ni que trois sources représentent la banque entière.

## Ce que les calculs apportent, sans jargon

- **S1** : une corrélation spatiale observée peut venir de la manière dont des mesures sont combinées. Ce test fonctionne techniquement ; il faut encore décider si de tels supports construits sont pertinents pour le futur data paper.
- **S2** : l'agrégation géographique peut déformer une relation non linéaire. L'effet est beaucoup plus fort dans certains réglages Georgia que Meuse ; on ne peut donc pas reprendre un chiffre unique pour tous les jeux de données.
- **S3** : lorsqu'une covariable est reconstruite depuis des sites de mesure, prédire une région privée de mesures est en général plus difficile que prédire dans un domaine où le réseau est connu. Les réglages central et alternatifs ont maintenant 40 répétitions ; sur 20 choix de réseau, l'erreur moyenne de reconstruction reste plus élevée en transfert. Dans 38 des 40 contextes moyens comparés, le risque prédictif est plus élevé en transfert, avec deux exceptions. Une densité accrue aide surtout quand le réseau est connu ; le bruit de mesure et le choix IDW/krigeage n'ont pas d'effet universel. Pour Georgia, `PctEld` est une proportion **par comté**, représentée à son centroïde ; ce n'est pas une mesure de station. Pour Meuse, `elev` est une altitude ponctuelle. Ces deux cas ne doivent pas être interprétés comme un même processus de mesure.

- **S4** : sur Georgia/Meuse, une portée simulée plus longue accroît le risque dans 80/80 contextes sans conditionnement et 53/80 avec conditionnement. Sur **Banff**, troisième source de la banque, ce sont **34/40 et 27/40** ; pour la tendance spatiale conditionnelle, seulement **8/20**. Les valeurs de champ imposées et les covariables viennent d'un autre domaine, mais le générateur reproduit modestement la température réelle (R² 0,16/0,25 hors calibration). La covariance S4 est euclidienne, alors que le papier Banff modélise la connectivité du réseau fluvial. La distance au site imposé donne déjà des contrastes sans champ : ce n'est pas une preuve d'effet du conditionnement. Les variantes `g` et `u` présentent la même réponse simulée mais une vérité à prédire différente.

Les gros nombres d'« évaluations » rapportés dans les notes désignent des réajustements de modèles dans un **petit pilote sur trois sources au plus**, et non des centaines de nouveaux jeux de données ni des méthodes intégrées au package.

## Ce qui reste ouvert

1. **Recentrer la priorité scientifique** : S1–S3 explorent surtout le *processus d'observation*. S4 varie maintenant `g` et `u` avec et sans conditionnement, mais la variation de `lambda` et la grille D0–D9 ne sont pas achevées. Il faut articuler la suite avec le périmètre souhaité par l'encadrant.
2. **Compléter S3 avant toute conclusion générale** : les intervalles calculés ne propagent que l'incertitude de la covariable interpolée. Il faut répéter ceux des estimateurs ordinaires sur plusieurs réseaux et réponses, puis inclure les autres incertitudes avant de parler de couverture prédictive.
3. **Élargir les sources et les supports** avant de tirer des conclusions destinées au data paper. Les zonages S2 et supports S1 ne reproduisent pas des supports publiés.
4. **Achever S4** : traiter les observations conditionnantes bruitées, renouveler les réseaux et les valeurs imposées, puis compléter les diagnostics spatiaux avant une interprétation générale.
5. **Distinguer revue, pilote et package** dans toute communication : la revue documente la littérature ; les pilotes testent la faisabilité ; le package n'a pas encore reçu ces scénarios comme moteurs.

## Message réutilisable à l'encadrant

> Bonjour,  
> J'ai poursuivi la revue sur les plasmodes spatiaux et clarifié plusieurs mécanismes qui peuvent donner une apparence de dépendance spatiale sans propagation entre réponses voisines. Le HTML intègre maintenant la littérature et quatre pilotes : supports recouvrants (S1), agrégation non linéaire (S2), covariable interpolée (S3) et champs spatiaux calibrés (S4). S1–S3 ont été testés sur Georgia et Meuse ; S4 a aussi été testé sur Banff, avec des valeurs de champ construites pour l'expérience. Il ne faut pas présenter ces constructions comme des configurations empiriques publiées ni généraliser les classements de méthodes.  
> Pour S3, deux lots de 40 répétitions et 20 réseaux alternatifs montrent qu'une région sans mesures pose en général davantage de difficultés qu'un domaine avec réseau connu. Le résultat et ses exceptions sont dans le HTML. La partie incertitude ne fournit pas encore des intervalles prédictifs complets ; les estimateurs ordinaires et d'autres sources doivent être étudiés plus largement.  
> S4 dispose désormais de deux modes de 40 répétitions sur Georgia/Meuse et Banff, tous sans échec : champ libre et champ conditionné, pli par pli, sur des valeurs latentes synthétiques imposées dans l'apprentissage après tampon. Une portée longue accroît le risque dans 80/80 contextes Georgia/Meuse sans conditionnement et 53/80 avec conditionnement ; sur Banff, dans 34/40 et 27/40, et seulement 8/20 pour la tendance conditionnelle. Banff utilise les trois covariables du modèle final des auteurs, mais notre champ est euclidien alors que leur modèle suit le réseau fluvial, et nos générateurs reproduisent modestement la température observée. Ce troisième essai affaiblit une conclusion monotone générale sur la portée. Les observations conditionnantes bruitées, d'autres réseaux et sources et la variation de `lambda` restent à étudier avant une conclusion générale. Je propose de poursuivre ces diagnostics, puis d'articuler S4 avec D0–D9 et de décider quelle place donner à S1–S3 dans le data paper.

Ce texte est un état d'avancement, pas une conclusion scientifique publiée.

