# Fiche de suivi — revue et pilote semi-synthétiques

Dernière actualisation : **15 septembre 2026, après l'essai S4 sur Banff**  
Périmètre : revue bibliographique, formalisation scientifique et scénarios plasmodes spatiaux.  
Règle de maintenance : cette fiche doit être actualisée après chaque intervention qui modifie l'avancement, un résultat, une limite ou l'ordre des prochaines tâches.

## Légende

| Statut | Signification |
|---|---|
| ✅ Terminé | Livrable produit, contrôlé et exploitable pour l'étape suivante |
| 🟢 Exécuté, interprétation à intégrer | Calcul terminé ; résultats encore à reporter dans le document principal |
| 🟡 En cours/préparé | Spécification ou travail partiel disponible ; critères d'acceptation non encore tous satisfaits |
| ⬜ À faire | Aucune implémentation validée |

Le pourcentage indique la part des livrables attendus déjà obtenue. Il ne mesure pas le temps consommé.

## Vue d'ensemble

| Étape | Niveau | Statut actuel | Prochaine action |
|---|---:|---|---|
| 1. Corpus PDF, TEI et bibliographie | 100 % | ✅ Terminé | Maintenir les manifestes si un article est ajouté |
| 2. Lecture bibliographique prioritaire | 100 % | ✅ Terminé | Mobiliser les résultats lors de la rédaction scientifique |
| 3. HTML principal de la revue | S1–S4 intégrés ; S4 étendu à Banff | 🟡 Pilotes documentés, synthèse scientifique à poursuivre | Harmoniser la conclusion après observations bruitées et davantage de sources |
| 4. Spécification commune des scénarios | 100 % | ✅ Terminée | La faire évoluer seulement si les tests imposent une correction scientifique |
| 5. Pilote de départ P0–P6 | 100 % pour ce pilote | ✅ Sept scénarios exécutés | La grille D0–D9 reste un programme à développer |
| 6. S2 — agrégation non linéaire | 100 % pour le lot initial | ✅ Exécuté, documenté et intégré au HTML | Élargir sources et zonages avant un résultat général |
| 7. S1 — supports recouvrants | 100 % pour le lot initial | ✅ Exécuté, documenté et intégré au HTML | Étudier d'autres supports et une calibration commune |
| 8. S3 — covariable interpolée | 90 % pour le pilote | 🟡 Lots élargis exécutés et intégrés au HTML | Répéter l'incertitude des estimateurs ordinaires sur plusieurs réseaux et réponses ; élargir les sources |
| 9. S4 — champs spatiaux calibrés | 90 % pour le premier pilote étendu | 🟡 Deux modes exécutés sur Georgia/Meuse et Banff, contrôlés et intégrés au HTML | Étudier les observations conditionnantes bruitées, autres réseaux/valeurs et davantage de sources |
| 10. Synthèse finale pour le data paper | 10 % | ⬜ Structure implicite seulement | Commencer après validation de S1–S4 |

## Détail des étapes

### 1. Corpus documentaire — ✅ 100 %

Réalisé :

- PDF complémentaires classés dans le dossier de la revue ;
- 21 fichiers TEI disponibles dans `tei/` ;
- bibliographie `revue_donnees_semi_synthetiques.bib` complétée et contrôlée ;
- LeSage–Pace récupéré, identifié par son DOI, converti en TEI et relié au `.bib` ;
- empreinte et provenance du fichier LeSage–Pace consignées.

Critère de clôture atteint : tous les textes prioritaires disponibles localement peuvent être interrogés sous forme TEI.

### 2. Lecture bibliographique — ✅ 100 % pour les priorités définies

Réalisé :

- lecture intégrale de RealCause ;
- approfondissement de Gelfand–Schliep sur la fusion spatiale ;
- approfondissement de Gotway–Young sur le changement de support ;
- approfondissement de Tiedeman–Green sur les erreurs corrélées ;
- lecture de LeSage–Pace sur les simulations spatiales ;
- complément sur la simulation conditionnelle et les champs spatiaux calibrés ;
- neuf articles complémentaires intégrés à l'analyse.

Preuve principale : `lecture_approfondie_et_geostatistique_2026-09-14.md`.

### 3. Document HTML principal — 🟡 S1–S4 intégrés

Réalisé :

- neuf articles complémentaires intégrés ;
- supports recouvrants, agrégation non linéaire et covariables interpolées discutés ;
- résultats du pilote Georgia/Meuse et limites du protocole intégrés ;
- apports de RealCause, Gelfand–Schliep, Gotway–Young, Tiedeman–Green et LeSage–Pace ajoutés ;
- structure HTML, identifiants et liens locaux vérifiés.
- pilotes S3 et S4, contrastes appariés, MCSE et limites intégrés.

Reste à faire :

- harmoniser la conclusion finale après les observations conditionnantes bruitées et l'élargissement des sources.

### 4. Spécification scientifique S1–S4 — ✅ 100 %

Le fichier `specification_scenarios_observation_geostatistique_2026-09-14.md` définit pour chaque scénario : question, DGP, facteurs, vérités, scores, validation et critères d'acceptation. Il fixe aussi l'ordre d'implémentation : S2, S1, S3, S4.

### 5. Pilote de départ P0–P6 — ✅ 100 % pour ce pilote

Réalisé :

- pilote de référence Georgia/Meuse ;
- scénarios de moyenne, omission, mesure, SEM positif et hétéroscédasticité ;
- comparaison des estimateurs existants ;
- diagnostic algébrique initial pour lissage et agrégation ;
- invariants de reproductibilité, SNR, covariance et absence de fuite testés.

Le regroupement historique de trois sites triés est–ouest reste uniquement un contrôle algébrique. Il ne doit pas être présenté comme un zonage géographique.

### 6. S2 — agrégation d'une relation non linéaire — ✅ 100 %

Réalisé :

- partitions spatiales par bissection récursive en cellules rectangulaires contiguës ;
- trois granularités ;
- zones intégralement affectées à un seul pli ;
- générateurs polynomial et forêt ;
- cinq estimateurs ;
- 40 répétitions ;
- 2 400 évaluations, zéro échec et zéro avertissement ;
- identité quadratique vérifiée entre `1.38e-15` et `7.11e-15` ;
- covariance des innovations séparée de l'erreur de moyenne ;
- absence de fuite de réponse de test vérifiée ;
- résultats interprétés dans `resultats_s2_aggregation_2026-09-14.md`.

Résultat central : l'erreur `A m(X) - m(A X)` augmente avec l'agrégation et dépend fortement du générateur et du dataset. Pour Georgia–forêt, sa NMSE passe de 0,294 à 0,865. Pour Meuse–polynôme, elle reste comprise entre 0,0035 et environ 0,0135.

Les résultats, la distinction concernant `log(zinc)` et les conclusions réutilisables sont maintenant intégrés au HTML principal.

### 7. S1 — supports recouvrants — ✅ 100 %

Réalisé :

- DGP et critères d'acceptation spécifiés ;
- supports locaux construits depuis les distances, avec deux ou quatre voisins ;
- pondérations uniforme et exponentielle décroissante ;
- contrôle `H=I` et vérification Monte-Carlo de `sigma² H H'` ;
- plis géographiques par blocs de `H`, sans source fine partagée ;
- tampon métrique appliqué aux unités fines contributrices ;
- générateurs polynôme et forêt, cinq estimateurs et 40 répétitions ;
- 4 000 évaluations, zéro échec et zéro avertissement ;
- résultats documentés dans `resultats_s1_supports_recouvrants_2026-09-14.md`.

Les résultats et leurs limites sont intégrés au HTML principal. La calibration directe sur une covariance ou un Moran cible commun reste une extension, sans empêcher la clôture du lot initial.

### 8. S3 — covariable interpolée — 🟡 90 % pour le pilote

Réalisé : DGP et facteurs spécifiés ; `PctEld` et `elev` documentés ; réseaux maximin emboîtés à 20 %, 40 % et 70 % ; IDW et krigeage ordinaire ; distinction réseau connu/transfert avec tampon ; test explicite de non-utilisation du `z` de la région test ; 960 évaluations de faisabilité sans échec ; lot central **apparié** de 3 200 évaluations sur 40 répétitions sans échec ; lot périphérique de 12 800 évaluations sur 40 répétitions sans échec ; contrastes de risque appariés et MCSE ; 20 réseaux maximin alternatifs contrôlés ; propagation de 30 réalisations conditionnelles aux cinq estimateurs ordinaires sur 24 plis × 30 réalisations (3 600 ajustements, zéro échec) ; résultats dans `resultats_s3_pilote_2026-09-15.md` et le HTML principal.

Reste à réaliser :

1. répéter le diagnostic d'intervalles des estimateurs ordinaires avec plusieurs réseaux et réponses, calculer sa MCSE et inclure les autres sources d'incertitude avant de parler de couverture prédictive ;
2. élargir les sources et examiner de vrais réseaux de mesure documentés ;
3. réexaminer le cas Georgia : `PctEld` est une proportion aréale représentée par centroïde, et non une mesure de station.

### 9. S4 — champs spatiaux conditionnels calibrés — 🟡 90 % pour le premier pilote étendu

Déjà disponible : spécification des variantes tendance latente et innovation spatiale ; TEI S4 relus et corrections documentées dans `audit_tei_s4_2026-09-15.md` ; covariance exponentielle calibrée sur chaque géométrie ; portée effective relative, SNR commun et part spatiale attendus vérifiés ; pépite dérivée et refus des combinaisons impossibles ; simulation conditionnelle exacte codée et testée ; contrôle nul, définition positive, reproductibilité et convergence empirique de la covariance testés ; **lot corrigé avec tampon** de faisabilité de 480 évaluations, zéro échec et zéro avertissement, sur les deux variantes et deux répétitions. `g` est renouvelé à chaque répétition et les réponses `g`/`u` sont appariées ; le premier lot avec `g` fixé est écarté. Sur Georgia/Meuse, 16 réglages non conditionnels et 32 conditionnels contrôlés à **3 000 tirages** par réglage, avec 128 classes de distance de variogramme ; aucun site imposé dans la région test, tampon métrique respecté et valeurs honorées exactement. Les cibles de MCSE de variance (2 %), de variogramme (5 %) et d'écart relatif de covariance complète (20 %) sont atteintes. Voir `resultats_s4_faisabilite_2026-09-15.md`. Cela reste un prototype technique, sans conclusion sur les méthodes.

Lot non conditionnel terminé : 40 répétitions, cinq estimateurs, deux sources, deux générateurs, deux variantes et cinq réglages spatiaux distincts (contrôle nul une seule fois). **8 000 évaluations, zéro échec et zéro avertissement ; 400 contrastes appariés avec MCSE et 40 répétitions chacun.** Les contrôles confirment l'appariement des graines et de la réponse simulée `g`/`u`. Résultats bruts, résumés, contrastes, configuration et provenance sont réunis dans **un seul nouveau RDS** : `scenario_s4_40_2026-09-15/results.rds`. Le tableau et ses réserves figurent dans le HTML et dans `resultats_s4_faisabilite_2026-09-15.md`.

Lot conditionnel par pli terminé : **8 000 évaluations, zéro échec et zéro avertissement ; 400 contrastes de 40 répétitions**, 120 contrôles de sites et 48 000 lignes de risque par distance. Les 13 sites conditionnants par pli appartiennent à l'apprentissage après tampon, sont hors de la bande test et sont honorés exactement. Les valeurs imposées synthétiques restent fixes entre répétitions ; leur tirage de base est apparié entre réglages. Les 1 600 évaluations sans champ reproduisent exactement le lot non conditionnel ; les réponses `g`/`u` sont appariées. La portée longue augmente le risque dans **53/80** contextes conditionnels contre **80/80** non conditionnels ; sept exceptions conditionnelles négatives dépassent 2 MCSE en valeur absolue. Le diagnostic proche/éloigné change de signe entre Georgia et Meuse déjà au contrôle nul, donc il n'isole pas un effet du conditionnement. Résultats et limites sont dans le HTML, la note S4 et **un seul nouveau RDS** : `scenario_s4_40_conditional_2026-09-15/results.rds` ; aucun CSV ajouté.

Troisième source **Banff** : 110 sites de température, 36 pour ajuster les générateurs et 74 pour l'évaluation ; trois X (`Elev`, `RSlope`, `LE`) du modèle final des auteurs, coordonnées UTM d'origine. Les deux lots de 40 ont **4 000 évaluations et 200 contrastes chacun**, zéro échec et zéro avertissement. Les 60 contrôles conditionnels ont neuf sites imposés par pli hors bande test, au-delà du tampon de 1,5 km et honorés exactement ; les 800 évaluations sans champ sont identiques entre modes. Un seul nouveau RDS contient les deux lots : `scenario_s4_banff_40_2026-09-15/results.rds`, sans CSV. La portée longue augmente le risque dans **34/40** contextes non conditionnels et **27/40** conditionnels ; la tendance `g` conditionnelle n'en a que **8/20**. La fidélité empirique du générateur reste faible (R² hors calibration 0,16/0,25) et le modèle publié utilise la connectivité du réseau fluvial, contrairement à la covariance euclidienne S4. Le pilote vérifie une troisième géométrie et limite la conclusion monotone sur la portée, sans validation générale.

Reste à réaliser :

1. traiter les observations conditionnantes bruitées et répéter le conditionnement avec d'autres réseaux et valeurs imposées ;
2. compléter Moran multi-voisinages et portée empirique si l'interprétation l'exige ;
3. élargir encore les sources et les réglages avant une conclusion générale ;
4. examiner anisotropie et Matérn ; ajouter les effets directs/indirects si SAR/SDM sont évalués.

### 10. Synthèse finale — ⬜ 10 %

Éléments déjà réutilisables : synthèse bibliographique, limites du pilote initial et résultats S2.

La synthèse finale devra :

- distinguer mécanisme de moyenne, innovation, observation et erreur de covariable ;
- expliquer ce que chaque scénario permet réellement d'identifier ;
- présenter risques, MCSE et diagnostics plutôt qu'un classement isolé ;
- fournir les paragraphes destinés aux méthodes, résultats et discussion du data paper.

## Prochaine séquence opérationnelle

1. vérifier avec l'encadrant la place de S1–S3 par rapport au cœur `lambda`, `f`, `g` et `u` ;
2. compléter les diagnostics d'incertitude de S3 et élargir ses supports sans présenter son pilote comme une validation générale ;
3. tester les observations conditionnantes bruitées de S4 et renouveler les réseaux/valeurs, puis élargir les sources ;
4. développer ensuite les familles restantes de la grille D0–D9 ;
5. consolider le HTML et rédiger la synthèse pour le data paper.

## Journal des actualisations

| Date | Mise à jour | Niveau atteint |
|---|---|---|
| 2026-09-14 | Création de la fiche après lecture bibliographique, intégration du PDF LeSage–Pace et exécution de S2 | Corpus et priorités bibliographiques terminés ; S2 exécuté à 90 % ; S1 prochain scénario |
| 2026-09-14 | Intégration complète de S2 au HTML ; implémentation, tests et 40 répétitions de S1 | S2 terminé à 100 % ; S1 exécuté à 90 % ; intégration HTML de S1 prochaine |
| 2026-09-14 | Intégration de S1 au HTML ; analyse des covariables et choix du dessin S3 | S1 terminé à 100 % ; S3 préparé à 35 % ; implémentation S3 prochaine |
| 2026-09-15 | Réseaux, IDW, krigeage et transfert codés/testés ; balayage de faisabilité et lot central de 40 répétitions ; simulations conditionnelles privilégiées | S3 à 75 % ; propagation ordinaire et précision des autres niveaux restantes |
| 2026-09-15 | Relance du lot central avec innovations appariées ; export de 80 contrastes de risque et de leurs MCSE | S3 à 80 % ; propagation ordinaire et précision des niveaux périphériques restantes |
| 2026-09-15 | Propagation de 30 réalisations conditionnelles aux cinq estimateurs ordinaires sur 24 plis | S3 à 85 % ; répétition du diagnostic d'intervalles et niveaux périphériques restants |
| 2026-09-15 | Correction des formulations périmées du HTML ; distinction entre revue, pilotes et package ; point simple pour l'encadrant | P0–P6 clarifié ; S1/S2 dans le HTML ; S3 en note ; S4 non implémenté |
| 2026-09-15 | Lot S3 périphérique de 12 800 évaluations sur 40 répétitions ; 20 réseaux alternatifs ; contrastes appariés ; intégration des conclusions et limites au HTML | S3 à 90 % pour le pilote ; S1–S3 dans le HTML ; incertitude complète et sources supplémentaires ouvertes |
| 2026-09-15 | Démarrage de S4 : calibration exponentielle, deux variantes `g`/`u`, contrôle de covariance et conditionnement, essai de 480 évaluations | S4 à 45 % pour le premier pilote ; faisabilité technique, pas validation scientifique ; HTML S4 encore absent |
| 2026-09-15 | Relecture ciblée des TEI ; correction du champ `g` fixé entre répétitions et du SNR commun ; nouveau lot apparié de 480 évaluations | Premier lot S4 écarté de l'interprétation ; lot corrigé sans échec ; validation scientifique encore ouverte |
| 2026-09-15 | Contrôle des champs sur Georgia/Meuse : 16 réglages non conditionnels, 32 conditionnels et 1 000 tirages par réglage | S4 à 55 % pour le premier pilote ; sites honorés et hors région test ; tampon et variogramme encore ouverts |
| 2026-09-15 | Tampon métrique dans les trois plis ; contrôle conditionnel hors bande test avec tampon ; 128 classes de variogramme et 3 000 tirages par réglage ; essai d'estimateurs tamponné de 480 évaluations | S4 à 70 % pour le premier pilote ; précision de champ atteinte ; lot de 40 et tâche conditionnelle par pli ouverts |
| 2026-09-15 | Contrastes appariés fixés et testés ; contrôle nul non dupliqué par portée ; lot non conditionnel de 40 répétitions lancé avec un unique RDS | S4 à 75 % pour le premier pilote ; calcul et interprétation en cours |
| 2026-09-15 | Lot S4 non conditionnel de 40 répétitions terminé : 8 000 évaluations sans échec ni avertissement, 400 contrastes appariés et MCSE ; note, HTML et README actualisés, un seul nouveau RDS | S4 à 85 % pour le premier pilote ; tâche conditionnelle par pli et élargissement des sources ouverts |
| 2026-09-15 | Conditionnement exact par chacun des trois plis avec tampon et valeurs de champ synthétiques fixes ; lot de 40 répétitions terminé, 8 000 évaluations sans échec, 400 contrastes, 120 contrôles de sites et diagnostic par distance ; un seul nouveau RDS, note et HTML actualisés | S4 à 90 % pour le premier pilote ; observations bruitées, autres réseaux/valeurs et sources ouverts |
| 2026-09-15 | Essai S4 sur Banff, troisième source de la banque : covariables du papier et coordonnées UTM vérifiées, GAM adapté à `LE` binaire, contrôle des champs sur 3 000 tirages ; deux lots de 40 répétitions, 4 000 évaluations chacun sans échec, RDS unique, note et HTML actualisés | S4 à 90 % pour le premier pilote étendu ; portée non monotone sur Banff, fidélité du générateur et réseau fluvial limitants |
