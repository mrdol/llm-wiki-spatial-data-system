---
title: Plan d'action pour intégrer les panels spatiaux dans spatialtidymodels
type: analysis
created: 2026-09-09
updated: 2026-09-09
sources:
  - wiki/analyses/revue_panel_spatial_2026-09-09.md
  - wiki/analyses/revue_fidelite_quatre_datasets_2026-09-09.md
  - packages/spatialtidymodels/R/13-benchmark-spatial.R
tags: [spatial-panel, implementation-plan, spatialtidymodels, benchmark]
---

# Plan d'action pour intégrer les panels spatiaux

L'objectif est d'ajouter les modèles de panel spatial sans casser la logique actuelle de `spatialtidymodels` : une spécification parsnip, un registre d'estimateurs, un harnais dédié, des protocoles de rééchantillonnage explicites, des résultats normalisés et des métadonnées exportées. La première version doit reproduire correctement des modèles économétriques statiques avant de promettre une prédiction hors échantillon ou des modèles dynamiques. Le tableau de bord et toute comparaison panel–coupe transversale sont hors du périmètre actuel.

## Décision d'architecture

Le panel spatial doit constituer une nouvelle branche du harnais, reliée seulement aux abstractions techniques communes du package et distincte des modèles transversaux `sar_lag`, `sem_error` et `sdm_mixed`. Les moteurs actuels restent inchangés et ne servent ni de référence ni de concurrents aux nouveaux moteurs panel. Une observation de panel est un couple unité–temps, tandis que sa matrice de poids est généralement définie sur les unités. Pour 30 provinces observées pendant 15 ans, les données ont 450 lignes mais W reste une matrice 30 × 30.

Les noms SAR et SEM décrivent le même type général de dépendance spatiale, mais pas le même estimateur :

- le SAR transversal actuel estime une équation du type \(y=\rho Wy+X\beta+\varepsilon\) sur une seule coupe ;
- le SAR de panel estime \(y_{it}=\rho\sum_j w_{ij}y_{jt}+X_{it}\beta+\alpha_i+\tau_t+\varepsilon_{it}\), avec index temporel et effets de panel ;
- le SEM transversal actuel spatialise l'erreur d'une coupe ;
- le SEM de panel ajoute cette structure d'erreur à un modèle répété dans le temps, avec effets individuels, temporels ou doubles et une vraisemblance/variance adaptée au panel.

Il s'agit donc de nouveaux `panel_sar_*` et `panel_sem_*`, et non d'une réutilisation directe de `sar_lag` et `sem_error` sur les lignes empilées.

Le harnais actuel sous-échantillonne W avec les numéros de lignes des observations. Cette opération convient à une coupe spatiale, mais elle est incorrecte pour un panel : elle confond les 450 observations avec 30 unités et peut désaligner les voisins. La première modification structurante sera donc un contrat de données de panel et une couche d'alignement de W au niveau des unités.

Deux usages seront déclarés séparément :

1. **Réplication/estimation** : estimation sur le panel complet, restitution des coefficients, paramètres spatiaux, effets fixes ou aléatoires, impacts et diagnostics. C'est l'objectif de la première version.
2. **Prédiction** : évaluation temporelle sur des périodes futures pour des unités déjà observées. Elle sera ajoutée après définition et validation des formules de prédiction de chaque famille. Les nouvelles unités et les effets temporels futurs resteront hors contrat tant que leur traitement n'est pas explicite.

## Périmètre méthodologique issu de la revue

L'ordre d'implémentation suit les papiers recensés dans [[revue_panel_spatial_2026-09-09]] :

| Lot | Méthodes | Appui dans la littérature | Rôle dans le package |
|---|---|---|---|
| 1 | Panel linéaire FE, SAR statique FE | Li–Fang–He ; Elhorst ; Yun–Gramig ; Baylis–Paulson–Piras | Première route de réplication et socle commun |
| 2 | SEM, SAC et SDM statiques FE | Li–Fang–He ; Baylis–Paulson–Piras ; Antunes et al. ; applications carbone | Comparaison de mécanismes spatiaux et effets de débordement |
| 3 | Effets aléatoires et tests de spécification | Baltagi–Song–Koh ; Elhorst ; Millo–Piras | FE/RE, tests compatibles avec la structure de panel |
| 4 | Prédiction temporelle | Yun–Gramig | Validation hors période sur unités connues |
| 5 | Panels dynamiques QML/GMM | Bouayad-Agha–Védrine ; Pu et al. ; Parent–LeSage | Retards temporels et spatiaux, après stabilisation du statique |
| 6 | SUR spatial, flux dyadiques, panels non équilibrés | Baltagi–Bresson ; Pu et al. ; Egger et al. | Extensions spécialisées, chacune avec son propre contrat |

Le papier CO2 de Li, Fang et He sera le premier cas métier, mais pas le premier test numérique isolé : sa W publiée doit encore être reconstruite et son ordre provincial prouvé. L'exemple Munnell utilisé par Millo et Piras fournira d'abord une référence reproductible du moteur. Yun–Gramig et Baylis–Paulson–Piras serviront ensuite de cas de parité applicative lorsque code et données seront disponibles.

## Contrat de données à ajouter

Étendre `spatial_dataset_spec()` dans `R/benchmark-datasets.R` avec un argument optionnel `panel`. Une fiche non-panel continuera à suivre exactement le chemin actuel. Le nouvel objet contiendra au minimum :

```r
panel = spatial_panel_spec(
  unit = "province",
  time = "year",
  effect = "individual",
  balance = "balanced",
  w_unit_order = province_ids,
  prediction_target = "fit_only"
)
```

`spatial_panel_spec()` et son validateur devront vérifier :

- unicité de chaque couple unité–temps ;
- nombre d'unités, périodes observées, équilibre et trous temporels ;
- stabilité du type et de l'encodage des identifiants ;
- dimension de W égale au nombre d'unités, noms de lignes/colonnes et ordre explicite ;
- une géométrie de référence par unité, ou une politique déclarée si la géométrie change dans le temps ;
- convention de normalisation, gestion des unités sans voisin et caractère fixe ou temporel de W ;
- variables nécessaires après traitement des valeurs manquantes, sans perdre silencieusement l'alignement du panel.

Une W sans noms ne sera acceptée que si `w_unit_order` est fourni. Une permutation des lignes de données devra produire le même ajustement après réalignement par identifiant.

## API des estimateurs

Ajouter un moteur parsnip dans `R/70-parsnip-splm.R`, sur le modèle des moteurs personnalisés actuels. L'interface principale proposée est `spatial_panel_reg()`, avec des raccourcis lisibles :

- `panel_sar_reg()` ;
- `panel_sem_reg()` ;
- `panel_sac_reg()` ;
- `panel_sdm_reg()`.

Les paramètres publics doivent exprimer le modèle statistique, pas seulement les arguments du backend : `panel_model = c("within", "random", "pooling")`, `effect = c("individual", "time", "twoways")`, famille spatiale, traitement de l'erreur et index unité–temps. Le premier moteur sera `splm`, dont `spml()` couvre les modèles statiques nécessaires. `plm` fournira la référence non spatiale.

Le wrapper de résultat conservera l'objet source, les index, l'ordre de W, les unités et périodes, les coefficients, les paramètres rho/lambda, la convention d'effets et une table explicite de capacités de prédiction. Le SDM sera construit avec des covariables spatialement retardées vérifiées si le backend ne propose pas directement le contrat Durbin attendu ; aucune option ne sera déduite de son nom.

Les identifiants de registre proposés sont :

- `panel_fe` ;
- `panel_sar_fe` ;
- `panel_sem_fe` ;
- `panel_sac_fe` ;
- `panel_sdm_fe`.

Les variantes RE puis dynamiques auront des identifiants distincts. Elles ne seront pas enregistrées comme simples variantes des estimateurs transversaux, car leur estimand, leur structure d'erreur et leur protocole de validation diffèrent.

Au début, `splm` et `plm` peuvent rester dans `Suggests` avec contrôle clair de disponibilité. Ils passeront dans `Imports` seulement lorsqu'une route panel fera partie du fonctionnement garanti du package.

## Sélection des datasets concernés

Avant l'implémentation des moteurs, produire un inventaire des fiches parentes qui conservent le panel complet. Les fiches annuelles ou temporelles dérivées restent attachées à leur traitement transversal actuel et ne doivent pas être promues automatiquement vers le panel.

L'inventaire partira des champs déjà présents `parent_dataset` et `source_dataset_id`, du statut `ready_panel_reduction`, des variables temporelles déclarées et des répétitions d'identifiants ou de coordonnées. Pour chaque famille parent/enfants, il indiquera :

- identifiant et artefact du panel parent ;
- fiches de coupes dérivées ;
- unité et temps candidats, N, T et équilibre ;
- réponse, formule publiée et covariables disponibles ;
- géométrie par unité et matrice W disponible ou reconstructible ;
- méthode de panel réellement utilisée dans le papier ;
- niveau d'éligibilité au futur harnais panel.

Seuls les panels parents validés seront routés vers les nouveaux moteurs. Une coupe dérivée pourra rester utilisable par les moteurs transversaux, sans qu'aucune comparaison automatique soit produite entre les deux analyses.

## Harnais panel distinct

Créer un module dédié, par exemple `R/70-panel-spatial.R` pour les moteurs et `R/71-benchmark-panel-spatial.R` pour l'orchestration. Il pourra réutiliser les utilitaires stables de métriques, journalisation et timeout, mais il ne doit pas passer par les branches `sar_lag`, `sem_error`, `sdm_mixed`, par leurs grilles de réglage ou par leurs fonctions de comparaison.

Le harnais panel réalisera :

1. créer les partitions au niveau unité–temps ;
2. déterminer les unités présentes dans le train et le test ;
3. construire ou sous-indexer W par identifiant d'unité ;
4. transmettre séparément `index` et `W_units` au moteur ;
5. calculer les métriques selon la cible déclarée ;
6. joindre aux résultats N, T, équilibre, effet, famille spatiale et horizon.

Les protocoles transversaux `near_prediction`, `block_spatial` et `vfold_cv` ne doivent pas être appliqués automatiquement aux lignes d'un panel. Ajouter :

- `panel_full_fit` pour la réplication ;
- `panel_time_holdout(h)` pour réserver les h dernières périodes ;
- `panel_rolling_origin(initial, assess, skip)` pour des fenêtres temporelles croissantes ;
- plus tard, `panel_leave_units_out`, limité aux modèles capables de prédire de nouvelles unités et incompatible avec des effets fixes individuels non observés.

Chaque split temporel vérifiera l'absence de fuite : pour chaque unité, aucune date de test ne peut précéder la dernière date d'apprentissage. Les transformations, retards et WX seront construits dans le split, avec les valeurs passées autorisées explicitement.

## Contrat de prédiction

La méthode `predict()` ne doit être annoncée que pour une cible démontrée. Les capacités seront exposées dans les métadonnées : `fit_only`, `in_sample`, `time_forecast_known_units`, `new_units`.

Pour les modèles statiques sur unités connues, les formules à tester sont :

- SAR : \((I-\rho W)^{-1}(X\beta + effets)\) ;
- SDM : \((I-\rho W)^{-1}(X\beta + WX\theta + effets)\) ;
- SEM : prédiction de la moyenne systématique, avec traitement séparé de l'erreur spatiale non observée.

Les effets fixes individuels estimés peuvent être utilisés pour des unités déjà vues. Un effet temporel d'une période future n'est pas connu et exige une convention explicite. Les modèles dynamiques nécessiteront une prédiction récursive, une définition des valeurs initiales et une interdiction d'utiliser la réponse future.

## Sorties et diagnostics

Conserver les conventions techniques utiles des sorties actuelles, notamment les résultats tabulaires, erreurs et traces, mais dans un objet de résultat panel distinct. Ajouter des colonnes ou tables normalisées pour :

- N unités, T périodes, nombre d'observations et équilibre ;
- effet individuel, temporel ou double ;
- rho, lambda et paramètres de dynamique ;
- coefficients et intervalles ;
- effets directs, indirects et totaux pour SAR/SDM ;
- RMSE/MAE globaux et par horizon lorsque la prédiction est valide ;
- Moran des résidus calculé période par période avec W des unités, puis résumé de sa distribution ;
- log-vraisemblance et critères d'information seulement lorsque leur comparaison est statistiquement légitime.

La première version n'alimente ni le tableau de bord ni les comparaisons transversales. Une éventuelle visualisation panel sera conçue plus tard à partir des sorties stabilisées et ne devra pas mélanger les deux structures de données.

## Métadonnées et fiches datasets

Étendre la source autoritative `code/package_metadata/export_spatialtidymodels_metadata.py`, puis régénérer `inst/metadata/estimators.json` et `datasets.json`. Champs à ajouter :

- `data_structure: spatial_panel` ;
- `panel_unit`, `panel_time`, `n_units`, `n_periods`, `panel_balance` ;
- `w_level: unit`, `w_unit_order_source`, `w_time_varying` ;
- `panel_effect`, `prediction_target`, `supported_resampling` ;
- référence méthodologique et niveau de parité atteint.

Le statut `ready_in_data_bank` reste un statut de conservation. Il ne vaut pas admission automatique au benchmark. Pour CO2, l'admission à une réplication complète dépendra de la provenance de W, de l'ordre des provinces et de la conformité de toutes les transformations à l'article.

## Tests requis

### Validation structurelle

- doublons unité–temps, périodes manquantes et panel non équilibré signalés correctement ;
- erreur sur dimension ou noms de W incohérents ;
- invariance à une permutation des observations et de l'ordre des unités nommées ;
- valeurs manquantes traitées sans désaligner index, géométrie et W ;
- géométries répétées reconnues comme répétitions d'unités, pas comme nouveaux voisins.

### Estimation et parité

- parité numérique avec l'exemple Munnell de Millo–Piras pour FE et SAR/SEM disponibles ;
- parité entre le wrapper et un appel direct à `splm::spml()` ;
- comparaison au panel FE non spatial lorsque rho/lambda sont absents ou contraints ;
- impacts SAR/SDM comparés à un calcul matriciel indépendant sur un petit exemple déterministe ;
- réplication Li–Fang–He seulement après validation de W ; puis Yun–Gramig ou Baylis et al. selon disponibilité des artefacts.

### Rééchantillonnage et prédiction

- aucune période future dans l'apprentissage ;
- retards calculés sans lire la réponse de test ;
- taille et ordre de W corrects dans chaque fold ;
- erreur informative pour une cible non supportée, notamment nouvelles unités avec FE ;
- métriques par horizon identiques à un calcul manuel sur un petit panel.

### Intégration

- registre panel, export des métadonnées, sérialisation et worker avec timeout ;
- absence de routage d'une coupe dérivée vers les moteurs panel et absence de comparaison automatique panel–coupe ;
- non-régression complète des estimateurs transversaux ;
- comportement documenté lorsque `splm` ou `plm` n'est pas installé.

## Jalons et critères de passage

### J0 — Inventaire des panels parents et spécification figée

Recenser les panels parents conservés, leurs coupes dérivées, les index, formules et W disponibles, puis produire une note de décision sur les cibles, les familles, W et la prédiction. **Passage :** inventaire traçable et revue du contrat par un exemple CO2 et un exemple Munnell, sans ambiguïté unité/temps/W.

### J1 — Données et W de panel

Implémenter `spatial_panel_spec()`, validations et alignement. **Passage :** tous les tests structurels passent et aucune régression transverse.

### J2 — FE non spatial et SAR statique FE

Ajouter le moteur, le wrapper et `panel_full_fit`. **Passage :** parité avec appels directs et exemple publié ; résultats normalisés disponibles dans la suite.

### J3 — SEM, SAC et SDM statiques

Ajouter chaque famille séparément et les impacts. **Passage :** tests matriciels, diagnostics temporels et métadonnées exactes pour chaque route.

### J4 — Validation temporelle

Ajouter holdout et rolling origin, puis les prédictions supportées. **Passage :** tests anti-fuite, métriques par horizon et échec explicite des cibles non supportées.

### J5 — Intégration au catalogue panel

Brancher le registre panel, les fiches parentes et les sorties traçables. **Passage :** un run Munnell et un run CO2 traçables de la fiche parente jusqu'au résultat ; aucune coupe dérivée n'est routée vers ce harnais et CO2 reste conditionnel tant que W n'est pas prouvée.

### J6 — Effets aléatoires, tests et correction de biais

Ajouter RE et les tests Baltagi/Elhorst ; examiner Lee–Yu sans attribuer au backend une correction qu'il ne réalise pas. **Passage :** simulations contrôlées et références exactes par fonctionnalité.

### J7 — Dynamique et extensions

Évaluer QML/GMM, puis SUR spatial, flux dyadiques et panels non équilibrés comme modules distincts. **Passage :** formulation, conditions d'identification, prédiction et parité établies séparément pour chaque route.

## Ordre de travail recommandé

La première tâche est documentaire et les trois premières tâches de code viennent ensuite :

1. recenser les panels parents et leurs coupes dérivées dans les fiches ;
2. écrire le contrat `spatial_panel_spec()` et les tests d'alignement unité–temps–W ;
3. créer le harnais panel séparé et sa construction de W par unités ;
4. livrer `panel_fe` et `panel_sar_fe` en mode `panel_full_fit`, avec parité Munnell.

Ce socle permet d'intégrer ensuite Li–Fang–He fidèlement. Commencer directement par toutes les variantes CO2 mélangerait quatre incertitudes : moteur, index du panel, construction de W et reproduction de l'article.

## Hors périmètre de la première livraison

- prédiction de nouvelles unités avec effets fixes individuels ;
- W qui varie dans le temps ;
- panels dyadiques origine–destination ;
- systèmes SUR spatiaux ;
- GMM dynamique et correction Lee–Yu sans backend et référence numérique validés ;
- admission automatique d'un dataset parce qu'il appartient à la banque de données.
- tableau de bord et comparaisons entre modèles de panel et modèles de coupe transversale.

## Pages liées

- [[revue_panel_spatial_2026-09-09]]
- [[revue_fidelite_quatre_datasets_2026-09-09]]
- [[tidymodels_spatial_pipeline_status_2026-07]]
- [[spatial_regression]]
- [[data_leakage]]

## Related Pages

- [[revue_panel_spatial_2026-09-09]]
- [[revue_fidelite_quatre_datasets_2026-09-09]]
- [[tidymodels_spatial_pipeline_status_2026-07]]
