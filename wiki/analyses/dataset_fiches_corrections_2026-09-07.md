---
title: Corrections des fiches datasets — 7 septembre 2026
type: analysis
created: 2026-09-07
updated: 2026-09-07
sources:
  - data/manifests/datasets/dataset_fiches_consistency_audit_2026-09-07.csv
  - data/manifests/datasets/dataset_curation_overrides.json
  - data/manifests/datasets/dataset_fiches_validation_2026-09-07.json
  - packages/spatialtidymodels/inst/metadata/datasets.json
  - inst/kg/paper_dataset_uses.json
tags: [datasets, corrections, provenance, benchmark, audit]
---

Les corrections certaines sont appliquées aux générateurs, à l’export, aux loaders et aux fiches ; les choix scientifiques incertains restent en revue.

## Résultat et périmètre

| Mesure | Résultat |
| --- | --- |
| Fiches contrôlées | 292 |
| Fiches modifiées par cette intervention | 286 |
| Constats critiques corrigés techniquement | 20 sur 22 |
| Constats critiques neutralisés, résolution scientifique en attente | 2 sur 22 |
| Passages yes → manual_review | 119 |
| Passages yes → no | 1 |
| Passages manual_review → no | 3 |
| Réouvertures no → manual_review (sans admission) | 3 |
| Promotions vers yes | 0 |
| État final package_include | {"manual_review": 175, "yes": 35, "no": 82} |
| Artefacts lisibles | 292 / 292 |
| Formules disponibles valides, variables présentes | 231 / 231 |
| Formules indisponibles, hors admission automatique | 61 |
| Datasets benchmark_ready chargés par le loader courant | 35 / 35 |
| Échecs bloquants du contrôle package | 0 |

Les 123 abaissements comprennent 120 anciennes fiches yes et 3 anciennes manual_review. Les 3 passages no → manual_review rouvrent une investigation ; ils ne constituent pas une promotion benchmark. Le registre comptait 117 benchmark_ready, contre 35 désormais. Il contient maintenant les 292 fiches : warehouse_ted_can_2015_nuts3, absente de l’ancien export de 291 entrées, reste manual_review ; ses valeurs avant viennent de l’audit de fiche, et son ancien formula_status est indiqué absent_du_registre dans le CSV. Aucun benchmark complet n’a été exécuté : ces nombres décrivent l’admission et le chargement, pas des résultats de performance.

Le [CSV des corrections](../../data/manifests/datasets/dataset_fiches_corrections_2026-09-07.csv) contient 292 lignes, séparateur point-virgule, UTF-8 BOM, avec les états avant/après, formules, typologies, motifs et empreintes des fiches. Le rapport et le CSV de l’audit initial sont conservés à l’identique. Les modifications utilisateur présentes au début ont été prises comme référence, sans reset ni checkout.

## Corrections à la source

- **Export** : la typologie de la réponse effectivement sélectionnée pilote le routage ; elle ne résulte plus de l’union des réponses candidates. Les tableaux Detail Y à trois ou cinq colonnes sont lus selon leur en-tête. Une réponse entière n’est plus automatiquement un count. Les taux/proportions suivent une route continue lorsqu’elle est justifiée.
- **Provenance** : formula_status ne peut plus être pub avec formula_pub pending ou une référence indisponible. Les preuves de formula_used et de formula_pub sont distinctes ; generated_system_formula, reconstructed_from_data, paper_extracted et unavailable ne sont plus déguisés en publication.
- **Admission** : les alias package ne contournent plus les décisions manual_review/no. Une tâche en revue suspend l’éligibilité automatique ; les anciennes listes sont conservées dans le manifeste de curation.
- **Générateurs** : les annotations quittent formula_used ; les ellipses sont remplacées par la liste complète des X déjà déclarés, avec échappement des noms R. Une formule indisponible reste pending. Une couche de curation idempotente, partagée par les deux générateurs, réapplique uniquement les champs documentés et préserve les autres paragraphes.
- **Routage R** : les métadonnées ambiguës sont refusées ; les routes binaire/count vérifient effectivement la réponse (0/1 ou facteur binaire ; entiers non négatifs pour count). Ces contrôles ne certifient pas à eux seuls le choix scientifique d’une famille.
- **Artefacts** : les sous-ensembles Las Rosas 1999/2001 sont reconstruits sans casser la colonne géométrique ; leurs attributs et géométries correspondent aux lignes du parent. Pour ade4 doubs et mafragh, seules les tables de sites documentées sont jointes sur clés exactes, en conservant la géométrie initiale. Aucun Y ni aucune formule n’a été choisi arbitrairement.

Les textes génériques sont remplacés par le nombre d’enregistrements, l’unité déclarée et l’étendue/CRS mesurés. Le nombre de lignes n’est jamais présenté comme un nombre de sites indépendants. Les anciennes mentions « Statut benchmark actuel » sont synchronisées avec la décision finale.

## Les 22 constats critiques

| Dataset | Constat initial | Traitement | État final |
| --- | --- | --- | --- |
| paper_amphibian_malformation_prevalence | ["LOADER_FAILURE"] | 1 corrigé(s), 0 neutralisé(s) | yes / valid |
| paper_coral_corallium | ["FORMULA_NOT_EXECUTABLE"] | 1 corrigé(s), 0 neutralisé(s) | manual_review / valid |
| paper_coral_enallopsammia | ["FORMULA_NOT_EXECUTABLE"] | 1 corrigé(s), 0 neutralisé(s) | manual_review / valid |
| paper_coral_errina | ["FORMULA_NOT_EXECUTABLE"] | 1 corrigé(s), 0 neutralisé(s) | manual_review / valid |
| paper_coral_goniocorella | ["FORMULA_NOT_EXECUTABLE"] | 1 corrigé(s), 0 neutralisé(s) | manual_review / valid |
| paper_coral_isididae | ["FORMULA_NOT_EXECUTABLE"] | 1 corrigé(s), 0 neutralisé(s) | manual_review / valid |
| paper_coral_leiopathes | ["FORMULA_NOT_EXECUTABLE"] | 1 corrigé(s), 0 neutralisé(s) | manual_review / valid |
| paper_coral_madrepora | ["FORMULA_NOT_EXECUTABLE"] | 1 corrigé(s), 0 neutralisé(s) | manual_review / valid |
| paper_coral_paragorgia | ["FORMULA_NOT_EXECUTABLE"] | 1 corrigé(s), 0 neutralisé(s) | manual_review / valid |
| paper_coral_primnoa | ["FORMULA_NOT_EXECUTABLE"] | 1 corrigé(s), 0 neutralisé(s) | manual_review / valid |
| paper_coral_solenosmilia | ["FORMULA_NOT_EXECUTABLE"] | 1 corrigé(s), 0 neutralisé(s) | manual_review / valid |
| paper_coral_stylaster | ["FORMULA_NOT_EXECUTABLE"] | 1 corrigé(s), 0 neutralisé(s) | manual_review / valid |
| paper_harbour_porpoise_response | ["Y_WRONG_BINARY_ROUTE"] | 1 corrigé(s), 0 neutralisé(s) | manual_review / valid |
| paper_hiv_southern_africa | ["INDIVIDUAL_REVIEW"] | 1 corrigé(s), 0 neutralisé(s) | manual_review / valid |
| paper_hummingbird_sdm | ["Y_WRONG_COUNT_ROUTE"] | 1 corrigé(s), 0 neutralisé(s) | yes / valid |
| paper_joshua_tree_flowering | ["Y_WRONG_COUNT_ROUTE", "INDIVIDUAL_REVIEW"] | 1 corrigé(s), 1 neutralisé(s) | no / valid |
| paper_nyc_tract_income_ssig | ["INDIVIDUAL_REVIEW"] | 1 corrigé(s), 0 neutralisé(s) | yes / valid |
| paper_plant_invasion_fia | ["Y_WRONG_COUNT_ROUTE"] | 1 corrigé(s), 0 neutralisé(s) | manual_review / valid |
| paper_snake_home_range | ["Y_WRONG_BINARY_ROUTE"] | 1 corrigé(s), 0 neutralisé(s) | manual_review / valid |
| paper_song_sparrow_breeding_date | ["INDIVIDUAL_REVIEW"] | 1 corrigé(s), 0 neutralisé(s) | manual_review / valid |
| R_spData_nydata_nydata | ["FORMULA_COLUMN_MISSING"] | 0 corrigé(s), 1 neutralisé(s) | manual_review / unavailable |

L’annotation amphibian est déplacée dans la note : prevalence_abnormal ~ ROADDISTANCE + RoadType est une reconstruction partielle explicitement déclarée. Les onze formules coral sont exécutables avec les covariables existantes ; leur élargissement est déclaré formule système et les tâches restent en revue. Maipo, eberg et metacomnet ont également des formules complètes parseables, sans promotion.

Les huit erreurs sémantiques concernent la surface de domaine vital, la variation de réponse des marsouins, une richesse logarithmique, une couverture végétale, le produit flyrs, un pourcentage VIH, un revenu et un jour de l’année. Les vrais comptages, notamment fledglings, n_detections, deaths et Native_Mammal_Richness, restent soumis à la validation d’une tâche count et d’estimateurs adaptés.

Deux défauts ne sont pas prétendus résolus scientifiquement : Joshua Tree est un produit de modèle exclu de la tâche empirique principale, et nydata ne contient pas Cases. La colonne TRACTCAS n’est pas un remplacement validé : elle comprend des valeurs fractionnaires. Sa formula_used est donc pending et son admission suspendue. Les formules non traduisibles de regulatory_convergence, waste_site et depmunic sont aussi laissées pending, avec la preuve historique conservée.

## Provenance et KG

Columbus conserve la preuve package de CRIME ~ HOVAL + INC. Pour Georgia, la documentation primaire GWmodel atteste PctBach ~ PctRural + PctEld + PctFB + PctPov (gwr.bootstrap, p. 46). La formule utilisée dans le package inclut PctBlack à la place de PctPov : elle reste disponible mais est explicitement marquée variante système ; la preuve publiée est conservée séparément. Sources : [manuel GWmodel](https://stat.ethz.ch/CRAN/web/packages/GWmodel/GWmodel.pdf), [documentation spgwr](https://rsbivand.github.io/spgwr/reference/gwr.html).

Pour red_deer_topdown, le DOI dataset 10.5061/dryad.0cfxpnw7w est relié à l’article 10.1111/1365-2664.14526 dans le manifeste et le KG. Le README et la [page Dryad](https://datadryad.org/dataset/doi%3A10.5061/dryad.0cfxpnw7w) étayent ce lien. La différence entre 492 sites annoncés et 534 lignes du RDS reste à expliquer ; Year_publ désigne l’année de publication, pas nécessairement une date d’observation.

Pour sugar glider, trois identifiants sont séparés : le dépôt de réutilisation 10.5061/dryad.4xgxd259g, le dataset original 10.5061/dryad.xgxd254bt, et le lien article déjà présent 10.1111/aec.12583. Le deuxième DOI n’est **pas un DOI article**. La [page Dryad du dépôt de réutilisation](https://datadryad.org/dataset/doi%3A10.5061/dryad.4xgxd259g) indique la reprise des données Stojanovic. L’enregistrement ambigu devient une relation Dataset DERIVED_FROM Dataset ; son champ publication reste pending_source_review. Le lien article séparé est conservé, sans prétendre à une nouvelle vérification intégrale de cet article. Cette désambiguïsation précise le diagnostic initial sans réécrire son historique.

Le rapprochement de l’audit couvrait toutes les autres fiches paper ; la seule absence était red deer, maintenant ajoutée. Le manifeste contient 489 enregistrements d’usage. Le KG a été reconstruit depuis l’extraction modifiée : 59378 nœuds, 76633 arêtes, dont une DERIVED_FROM et trois RESOLVES_TO_DATASET. Les relations d’usage et de provenance ne sont pas toutes des arêtes directes USES_DATASET.

Répartition finale des preuves exportées :

| formula_status | Nombre |
| --- | --- |
| generated_system_formula | 58 |
| paper_extracted | 134 |
| pub | 20 |
| reconstructed_from_data | 2 |
| unavailable | 78 |

Ces niveaux décrivent la provenance consignée ; paper_extracted ne certifie pas une reproduction intégrale de chaque article. Une source primaire supplémentaire reste nécessaire lorsque la fiche signale une traduction ou une preuve incomplète.

## Répétitions spatiales, temporalité et W

Les répétitions de coordonnées déclenchent une revue de l’unité et du split, pas la suppression de lignes ou du dataset. Les fiches concernées décrivent le N local, la temporalité détectée et la nécessité de grouper les observations dépendantes. Les statuts restent manual_review ou ready_panel_reduction tant que la tâche n’est pas arrêtée.

- Korea housing : distinguer les transactions et bâtiments des années ; grouper par bâtiment et bloquer chronologiquement pour une évaluation future. Une coupe annuelle doit préciser l’année et l’agrégation éventuelle.
- LTAR crop rotation : distinguer parcelle, site et année ; 11 sites et 58 années dans la documentation examinée. Valider un panel ou un split par site/parcelle et période, sans assimiler les lignes aux sites indépendants.
- Séries par station et études compilées : séparer identifiant de site, date de mesure et année de publication. Une coordonnée répétée ne prouve pas un doublon exact.

W reste reconstructible quand le support le permet : définir CRS/unité de distance, k ou seuil, contiguïté polygonale, standardisation et zero_policy avant estimation. Les valeurs exactes de k/seuil doivent être arrêtées pour la tâche ; elles ne sont pas inventées ici. Une matrice institutionnelle ou économique propre à l’article, comme regulatory_convergence, ne se remplace pas automatiquement par un voisinage géographique.

## Quinze récupérations prioritaires

Sélection dans les cas récupérables low/manual_review de l’audit. Les mesures locales et documents package/CSV source ont été réexaminés ; les preuves PDF/TEI de l’audit sont conservées comme telles, sans inventer de PDF pour un objet package. Les deux jointures ade4 et la réparation sf de Las Rosas sont réalisées ; les autres lignes définissent les prochaines preuves à obtenir. Le manifeste dataset_recovery_priorities_2026-09-07.json détaille les colonnes et sources.

| Ordre | Dataset | Preuve disponible / correction | Étape avant promotion |
| --- | --- | --- | --- |
| 1 | R_ade4_doubs_doubs | Jointure réalisée : env (11 variables) + fish (27), clés de 30 sites et coordonnées vérifiées. | Choisir une réponse écologique justifiée, préciser X, unités, formule et validation spatiale ; aucun Y choisi automatiquement. |
| 2 | R_ade4_mafragh_mafragh | Jointure réalisée : env (11 variables) + flo (56), clés de 97 sites et coordonnées vérifiées. | Choisir une réponse et une tâche ; les tables de traits/espèces ne sont pas des tables de sites. |
| 3 | R_agridat_lasrosas.corn_lasrosas.corn_2001 | Sous-ensemble sf réparé, 1705 lignes ; yield, nitro, topo, bv présents. | Retrouver le modèle de 2001 ou approuver explicitement une formule système ; la preuve de 1999 ne vaut pas pour 2001. |
| 4 | R_MASS_npr1_npr1 | 104 points ; perm et por présents dans le RDS et la documentation package. | Préciser relation scientifique, unités et transformation ; formula_used reste pending. |
| 5 | R_spatstat.data_finpines_finpines | 126 points ; diameter et height présents, support ponctuel conservé. | Définir régression sur marques ou processus ponctuel ; choisir la réponse et la formule dans la source. |
| 6 | R_gstat_pcb_pcb | 216 lignes ; PCB138, coast, depth et year présents. | Préciser modèle et répétitions par site/année ; formula_used reste pending. |
| 7 | R_spDataLarge_census_de_census_de | 210556 lignes ; pop, women, mean_age et hh_size présents. | Choisir Y et dénominateurs, documenter masquage/confidentialité et validation ; formule pending. |
| 8 | Python_geodatasets_geoda.nepal | 75 unités ; povindex et X de la formule système présents dans le CSV source et le RDS. | Valider définition de pauvreté, unités/dénominateurs et choix des X ; ne pas présenter cette formule système comme publiée. |
| 9 | Python_geodatasets_geoda.nyc_neighborhoods | 195 unités ; UEMPRATE et X présents dans le CSV source et le RDS. | Vérifier dénominateur du chômage et colinéarité des sous-populations ; valider la tâche avant admission. |
| 10 | R_ade4_oribatid_oribatid | 70 coordonnées ; sous-tables de mesures présentes dans l’objet natif consulté. | Vérifier clés puis joindre tables de sites ; RDS courant encore limité au support spatial. |
| 11 | R_ade4_buech_buech | 31 coordonnées ; documentation et sous-tables natives consultées. | Prouver la correspondance des lignes, choisir mesures de réponse et covariables ; aucune jointure générique par nombre de lignes. |
| 12 | R_ade4_kcponds_kcponds | Coordonnées et objet natif consultés ; formule indisponible. | Vérifier clés site/table puis documenter Y, X et voisinage. |
| 13 | R_ade4_jv73_jv73 | 92 coordonnées ; sous-tables natives et documentation consultées. | Joindre uniquement les observations de sites après vérification des clés ; réponse et formule à définir. |
| 14 | R_agridat_usgs.herbicides_usgs.herbicides | 184 prélèvements ; atrazine, sampletype, date, hour et autres analytes présents. | Vérifier limites de détection, unités, répétitions par station et split groupé/chronologique ; revoir les covariables avant promotion. |
| 15 | R_gstat_DE_RB_2005_DE_RB_2005 | 23230 lignes ; PM10, altitude, identifiant de station, time et autres attributs présents. | Définir panel station/jour, écarter annual_mean_PM10 si fuite de cible, justifier X et validation ; PM10 ~ 1 ne suffit pas à ce choix. |

## Datasets laissés en manual_review

| Dataset | Statut | Motif à lever |
| --- | --- | --- |
| paper_airbnb_europe_prices | manual_review | N lignes=51707; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=21582. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_amphibian_abnormality_hotspots | manual_review | N lignes=598; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=201. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_amphibian_functional_diversity | manual_review | Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. |
| paper_banff_stream_temperature | manual_review | 110 réponses WaterTemp et quatre X complets; SSN/INLA sur réseau hydrographique, simplification curateur. La fiche dit T=1, le loader déclare Year_. Examiner les années et le réseau; promouvoir seulement une tâche comparative explicitement distincte de SSN, avec construction W documentée. |
| paper_bean_landrace_gap_sdm | manual_review | Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. |
| paper_bumblebee_colony_reproduction | manual_review | Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. |
| paper_california_wildfire_growth | manual_review | 23 031 lignes, 11 386 répétitions de coordonnées; 21 304 lignes complètes. Taille finale répétée par Fire_ID/Date et tâche différente du seuil de croissance publié. Grouper par incendie, contrôler l’antériorité météo et définir une coupe/agrégation par événement avant toute promotion. |
| paper_chaco_bird_richness | ready_panel_reduction | N lignes=234; T declare=6; variable temporelle declaree=year; repetitions de coordonnees controlees=12. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_checkerspot_phenology | ready_panel_reduction | N lignes=1989; T declare=128; variable temporelle declaree=year; repetitions de coordonnees controlees=814. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_coral_bathypathes | manual_review | Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. |
| paper_coral_corallium | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : current_package_regression_only. Conserver la décision actuelle jusqu’au traitement des constats. |
| paper_coral_enallopsammia | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : current_package_regression_only. Conserver la décision actuelle jusqu’au traitement des constats. |
| paper_coral_errina | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : current_package_regression_only. Conserver la décision actuelle jusqu’au traitement des constats. |
| paper_coral_goniocorella | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : current_package_regression_only. Conserver la décision actuelle jusqu’au traitement des constats. |
| paper_coral_isididae | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : current_package_regression_only. Conserver la décision actuelle jusqu’au traitement des constats. |
| paper_coral_leiopathes | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : current_package_regression_only. Conserver la décision actuelle jusqu’au traitement des constats. |
| paper_coral_madrepora | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : current_package_regression_only. Conserver la décision actuelle jusqu’au traitement des constats. |
| paper_coral_paragorgia | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : current_package_regression_only. Conserver la décision actuelle jusqu’au traitement des constats. |
| paper_coral_primnoa | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : current_package_regression_only. Conserver la décision actuelle jusqu’au traitement des constats. |
| paper_coral_solenosmilia | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : current_package_regression_only. Conserver la décision actuelle jusqu’au traitement des constats. |
| paper_coral_stylaster | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : current_package_regression_only. Conserver la décision actuelle jusqu’au traitement des constats. |
| paper_danajon_coral_distribution | manual_review | Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. |
| paper_dougfir_sdm | manual_review | Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. |
| paper_dragonfly_diversity_europe | manual_review | Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. |
| paper_early_season_biomass | ready_panel_reduction | N lignes=512; T declare=33; variable temporelle declaree=plant_date; repetitions de coordonnees controlees=494. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_ethiopia_bushcrow_sdm | manual_review | Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. |
| paper_ethiopia_whitetailed_swallow_sdm | manual_review | Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. |
| paper_fhb_ensembling | ready_panel_reduction | N lignes=985; T declare=32; variable temporelle declaree=year; repetitions de coordonnees controlees=919. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_flapper_skate_presence | manual_review | Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. |
| paper_florida_crash_gsvcm | manual_review | Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. |
| paper_gcfr_soil | manual_review | N lignes=2767; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=1928. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_global_nee_gwxgboost | manual_review | NEE contient -9999 et le loader ne filtre que is.na; 387 sites pour 109 154 lignes, publication non résolue. Lire les codes manquants du dépôt, convertir les sentinelles avec preuve, auditer les X, puis CV groupée par site/temps ou agrégation justifiée. |
| paper_goa_trawl_demersal | ready_panel_reduction | N lignes=9213; T declare=12; variable temporelle declaree=Year; repetitions de coordonnees controlees=1. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_groundfish_cpue | ready_panel_reduction | N lignes=6716; T declare=23; variable temporelle declaree=Year; repetitions de coordonnees controlees=6643. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_gwqlasso_mt | ready_panel_reduction | N lignes=6063; T declare=43; variable temporelle declaree=Year; repetitions de coordonnees controlees=5922. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_gwqlasso_pr | ready_panel_reduction | N lignes=17157; T declare=43; variable temporelle declaree=Year; repetitions de coordonnees controlees=16758. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_gwqlasso_rs | ready_panel_reduction | N lignes=21371; T declare=43; variable temporelle declaree=Year; repetitions de coordonnees controlees=20874. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_harbour_porpoise_response | manual_review | N lignes=700; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=600. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_hiv_southern_africa | ready_panel_reduction | N lignes=3347; T declare=4; variable temporelle declaree=DHSYEAR; repetitions de coordonnees controlees=9. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_hyena_lion_biomass_africa | ready_panel_reduction | N lignes=30; T declare=23; variable temporelle declaree=Year; repetitions de coordonnees controlees=17. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_influenza_mortality_chicago | ready_panel_reduction | N lignes=3472; T declare=7; variable temporelle declaree=week; repetitions de coordonnees controlees=2976. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_kodiak_puffin_density | ready_panel_reduction | N lignes=17908; T declare=39; variable temporelle declaree=year; repetitions de coordonnees controlees=9449. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_korea_hedonic_housing | ready_panel_reduction | N lignes=178719; T declare=46; variable temporelle declaree=Year; repetitions de coordonnees controlees=173324. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_1989 | manual_review | N lignes=2424; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=2355. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_1990 | manual_review | N lignes=1794; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=1729. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_1991 | manual_review | N lignes=3828; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=3730. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_1992 | manual_review | N lignes=5697; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=5541. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_1993 | manual_review | N lignes=5432; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=5268. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_1994 | manual_review | N lignes=6771; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=6602. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_1995 | manual_review | N lignes=6914; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=6737. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_1996 | manual_review | N lignes=9261; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=9081. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_1997 | manual_review | N lignes=9135; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=8949. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_1998 | manual_review | N lignes=6485; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=6350. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_1999 | manual_review | N lignes=5572; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=5469. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_2000 | manual_review | N lignes=6599; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=6455. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_2001 | manual_review | N lignes=4165; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=4021. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_2002 | manual_review | N lignes=4799; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=4542. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_2003 | manual_review | N lignes=6122; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=5750. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_2004 | manual_review | N lignes=4346; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=4112. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_2005 | manual_review | N lignes=6559; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=6366. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_2006 | manual_review | N lignes=7328; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=7135. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_2007 | manual_review | N lignes=5510; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=5363. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_2008 | manual_review | N lignes=6084; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=5977. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_2009 | manual_review | N lignes=4816; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=4734. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_2010 | manual_review | N lignes=3463; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=3406. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_2011 | manual_review | N lignes=4302; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=4221. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_2012 | manual_review | N lignes=2981; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=2883. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_2013 | manual_review | N lignes=5694; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=5542. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_2014 | manual_review | N lignes=5622; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=5452. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_2015 | manual_review | N lignes=6986; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=6806. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_2016 | manual_review | N lignes=5868; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=5629. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_2017 | manual_review | N lignes=4990; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=4765. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_2018 | manual_review | N lignes=4260; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=4071. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_2019 | manual_review | N lignes=1810; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=1679. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_korea_hedonic_housing_pre1989 | ready_panel_reduction | N lignes=13102; T declare=15; variable temporelle declaree=T; repetitions de coordonnees controlees=12592. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. |
| paper_leishmaniasis_occurrence | manual_review | Tache categorical a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. |
| paper_li_energy_price_co2_china | ready_panel_reduction | N lignes=30; T declare=15; variable temporelle declaree=year; repetitions de coordonnees controlees=0. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_ltar_crop_rotation_yield | ready_panel_reduction | N lignes=11970; T declare=58; variable temporelle declaree=year; repetitions de coordonnees controlees=11959. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Unite : parcelle-annee, 11 sites et 58 annees declarees; grouper par site/parcelle et separer les annees pour une validation prospective. |
| paper_macropod_body_size | ready_panel_reduction | N lignes=856; T declare=49; variable temporelle declaree=Year; repetitions de coordonnees controlees=733. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_mammals_sr_pd | manual_review | Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. |
| paper_marrot_spatial_autocorrelation_fitness | ready_panel_reduction | N lignes=229; T declare=6; variable temporelle declaree=Years; repetitions de coordonnees controlees=89. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_medicago | manual_review | Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. richesse specifique observee : denombrement, sans transformation continue imposee. |
| paper_midwest_crop_yield | ready_panel_reduction | N lignes=6359; T declare=22; variable temporelle declaree=Year; repetitions de coordonnees controlees=5955. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_mimulus_sdm | manual_review | Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. |
| paper_mistletoe_bird_abundance | ready_panel_reduction | N lignes=9012; T declare=5; variable temporelle declaree=Season; repetitions de coordonnees controlees=7794. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_network_misspecification_elections | ready_panel_reduction | N lignes=386; T declare=65; variable temporelle declaree=elecyr; repetitions de coordonnees controlees=364. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_no2_aqs_ma_2016_monitor_covariates | manual_review_derived_reconstruction | Continuous response, coordinates and public covariates are present, but this is a partial reconstruction and not the exact training matrix from the paper. |
| paper_o3_aqs_ma_2016_monitor_covariates | manual_review_derived_reconstruction | Continuous response, coordinates and public covariates are present, but this is a partial reconstruction and not the exact training matrix from the paper. |
| paper_pallid_bat | manual_review | N lignes=182; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=94. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_plant_invasion_fia | ready_panel_reduction | N lignes=42612; T declare=13; variable temporelle declaree=MEASYEAR; repetitions de coordonnees controlees=3. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_pm25_aqs_ma_2016_monitor_covariates | manual_review_derived_reconstruction | Continuous response, coordinates and public covariates are present, but this is a partial reconstruction and not the exact training matrix from the paper. |
| paper_pollinator_urbanization_meta | manual_review | N lignes=228; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=161. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_portugal_covid_municipal | manual_review | Panel municipal de 20 604 lignes; 278 désigne un nombre de communes dans le texte, pas nécessairement une contradiction sur N. Distinguer N lignes/N communes/T, vérifier dénominateur et période d’incidence, puis agrégation ou CV temporelle/groupée. |
| paper_possum_body_size | ready_panel_reduction | N lignes=588; T declare=335; variable temporelle declaree=Date; repetitions de coordonnees controlees=265. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_red_deer_topdown | manual_review | Source liee via README et metadonnees Dryad verifiees le 2026-09-07; reconcilier les 492 sites decrits avec les 534 lignes du RDS et les exclusions du script 01.Model.R avant benchmark. |
| paper_regulatory_convergence | manual_review | Le papier utilise des lags de banques/réseaux/souverains/commerce; les blocs de matrices figurent dans les données, ce ne sont pas des distances géographiques ordinaires. Reconstruire les W sources avec ordre des pays vérifié et une coupe 2008/2013 documentée; kNN géographique ne remplace pas ces liens. |
| paper_seshat_social_complexity | manual_review | N lignes=307; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=276. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_sfbay_contaminated_sites | manual_review | Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. |
| paper_shark_longline_catch | ready_panel_reduction | N lignes=8592; T declare=9; variable temporelle declaree=year; repetitions de coordonnees controlees=8292. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_snake_home_range | manual_review | N lignes=109; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=15. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_song_sparrow_breeding_date | ready_panel_reduction | N lignes=1040; T declare=38; variable temporelle declaree=year; repetitions de coordonnees controlees=189. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_spruce_bark_beetle | ready_panel_reduction | N lignes=1731; T declare=18; variable temporelle declaree=year; repetitions de coordonnees controlees=27. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_stwr_precip_isotope | manual_review | N lignes=272; T declare=1; variable temporelle declaree=n/a; repetitions de coordonnees controlees=156. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_sugarglider_occupancy | manual_review | Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. n_detections denombre les detections; occupation et detectabilite doivent rester distinguees. |
| paper_swiss_heat_exposure | manual_review | deaths est un comptage 0–12, mais typologie continuous; panel 2 368 080 lignes, 2 145 communes. Modèle BYM2 simplifié et colonnes deaths_sim/weight présentes. Vérifier deaths versus deaths_sim dans les deux RDS bruts et la notice, exposition population et dépendance temporelle; garder en revue. Ne pas inventer une version continue. |
| paper_trillium_presence_background | manual_review | Tache binary a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. |
| paper_uk_linear_features_birds | manual_review | Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. |
| paper_usgs_flood_skew | ready_panel_reduction | N lignes=183; T declare=70; variable temporelle declaree=BegYear; repetitions de coordonnees controlees=0. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_velado_alonso_wildlife_livestock_diversity | manual_review | Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Native_Mammal_Richness denombre les especes de mammiferes natives; une route count et le traitement du CRS suppose restent a valider. |
| paper_wald_test | ready_panel_reduction | N lignes=1428; T declare=306; variable temporelle declaree=ts; repetitions de coordonnees controlees=1405. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| paper_wildebeest_movement_env | ready_panel_reduction | N lignes=94006; T declare=13838; variable temporelle declaree=Date; repetitions de coordonnees controlees=33. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. |
| Python_geodatasets_geoda.airbnb | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.charleston1 | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.charleston2 | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.chicago_health | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.chile_labor | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.guerry | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats. |
| Python_geodatasets_geoda.health | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.health_indicators | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.hickory1 | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.hickory2 | almost_ready_small_n | La formule et les covariables sont executables, mais l echantillon est petit pour une comparaison robuste d estimateurs. |
| Python_geodatasets_geoda.home_sales | almost_ready_cross_section_or_panel_reduction | Le jeu contient une dimension temporelle; il peut etre benchmarkable apres choix documente d une coupe ou d une aggregation temporelle. |
| Python_geodatasets_geoda.lansing1 | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.lansing2 | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.milwaukee1 | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.ncovr_1960 | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats. |
| Python_geodatasets_geoda.ncovr_1970 | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats. |
| Python_geodatasets_geoda.ncovr_1980 | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats. |
| Python_geodatasets_geoda.ncovr_1990 | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats. |
| Python_geodatasets_geoda.ndvi | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.nyc | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.nyc_education | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.orlando1 | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.phoenix_acs | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.police | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.sacramento1 | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.savannah1 | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.seattle1 | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.sids_1974 | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats. |
| Python_geodatasets_geoda.sids_1979 | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats. |
| Python_geodatasets_geoda.tampa1 | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_geoda.us_sdoh | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_geodatasets_spdata.eire | almost_ready_small_n | La formule et les covariables sont executables, mais l echantillon est petit pour une comparaison robuste d estimateurs. |
| Python_geodatasets_spdata.nydata | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats. |
| Python_geodatasets_spdata.wheat | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats. |
| Python_libpysal_Baltimore | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats. |
| Python_libpysal_chicagoSDOH | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_libpysal_Elections | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_libpysal_Ohiolung | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| Python_libpysal_Snow | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| R_ade4_doubs_doubs | manual_review | Sous-tables natives de sites restaurees par jointure exacte sur les rownames de xy, puis egalite des coordonnees verifiee. Choix scientifique de Y/X et formule encore requis; aucune colonne numerique choisie automatiquement. |
| R_ade4_mafragh_mafragh | manual_review | Sous-tables natives de sites restaurees par jointure exacte sur les rownames de xy, puis egalite des coordonnees verifiee. Choix scientifique de Y/X et formule encore requis; aucune colonne numerique choisie automatiquement. |
| R_agridat_gartner.corn_gartner.corn | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| R_agridat_lasrosas.corn_lasrosas.corn | manual_review | La source complete est utile a la tracabilite, mais son empilement 1999-2001 ne constitue pas une tache de regression spatiale transversale ni un panel confirme. |
| R_agridat_lasrosas.corn_lasrosas.corn_2001 | manual_review | La campagne est une coupe transversale exploitable, mais la preuve de modelisation disponible est moins precise que pour 1999. |
| R_agridat_ortiz.tomato.covs_ortiz.tomato.covs | almost_ready_small_n | La formule et les covariables sont executables, mais l echantillon est petit pour une comparaison robuste d estimateurs. |
| R_agridat_wallace.iowaland_wallace.iowaland | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| R_gstat_fulmar_fulmar | almost_ready_cross_section_or_panel_reduction | Le jeu contient une dimension temporelle; il peut etre benchmarkable apres choix documente d une coupe ou d une aggregation temporelle. |
| R_gstat_jura_jura.val | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats. |
| R_mgwrsar_mydata_mydata | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats. |
| R_mgwrsar_mydatasf_mydatasf | almost_ready_cross_section_or_panel_reduction | Le jeu contient une dimension temporelle; il peut etre benchmarkable apres choix documente d une coupe ou d une aggregation temporelle. |
| R_sfdep_guerry_nb_guerry_nb | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| R_SpatialEpi_pennLC_sf_pennLC_sf | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| R_SpatialEpi_scotland_sf_scotland_sf | manual_review | Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. cases est un nombre de cas avec exposition expected en offset. |
| R_spatstat.data_clmfires_clmfires | almost_ready_cross_section_or_panel_reduction | Le jeu contient une dimension temporelle; il peut etre benchmarkable apres choix documente d une coupe ou d une aggregation temporelle. |
| R_spatstat.data_nbfires_nbfires | almost_ready_cross_section_or_panel_reduction | Le jeu contient une dimension temporelle; il peut etre benchmarkable apres choix documente d une coupe ou d une aggregation temporelle. |
| R_spData_baltimore_baltimore | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats. |
| R_spData_elect80_elect80 | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats. |
| R_spData_house_house | manual_review | Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. |
| R_spData_nydata_nydata | manual_review | Ancienne declaration yes incoherente avec les conditions du registre : estimator_eligibility_block_missing. Conserver la décision actuelle jusqu’au traitement des constats. |
| R_spData_nz_nz | almost_ready_small_n | La formule et les covariables sont executables, mais l echantillon est petit pour une comparaison robuste d estimateurs. |
| R_spData_properties_properties | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| R_spData_world_world | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| R_spDataLarge_pol_pres15_pol_pres15 | almost_ready_generated_formula | La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee. |
| warehouse_ted_can_2015_nuts3 | ready_needs_review |  |

## Exclusions de la tâche benchmark principale

Les 19 exclusions recommandées dans l’audit restent hors de la tâche principale ; aucune fiche n’est supprimée. Les autres no préexistants sont documentés dans le CSV complet et ne sont pas tous des rejets définitifs.

| Dataset | Motif / voie alternative |
| --- | --- |
| paper_beta0_gwr | retrouver le dataset empirique original et ses covariables Maintenir hors benchmark empirique; conserver la fiche et orienter une reconstruction distincte vers les observations sources. |
| paper_cluster_detection | exclu du package benchmark empirique Maintenir hors benchmark empirique; conserver la fiche et orienter une reconstruction distincte vers les observations sources. |
| paper_colombia_leptospirosis_risk | RR et MannKendall sont des sorties statistiques; covariables climatiques ajoutées. Géométrie réelle ne transforme pas ces sorties en observations d’incidence. Garder cette version hors benchmark empirique général; rechercher cas/populations municipaux pour une tâche distincte. |
| paper_desert_tortoise_genotype_niche | retrouver les points d'echantillonnage genotype bruts (non fournis dans le depot Dryad, uniquement des surfaces .asc deja modelisees) Maintenir hors benchmark empirique; conserver la fiche et orienter une reconstruction distincte vers les observations sources. |
| paper_ethiopia_clusters | retrouver le jeu DHS/GWR original ou rester hors benchmark Maintenir hors benchmark empirique; conserver la fiche et orienter une reconstruction distincte vers les observations sources. |
| paper_joshua_tree_flowering | Y flyrs est une sortie de hindcast BART, avec 689 valeurs négatives (différences entre périodes); routage count incompatible. Description de pollinisateurs/oiseaux sans rapport avec Joshua tree. Isoler cette tâche de sortie modèle; privilégier les observations flr originales du dépôt, avec route binaire et sélection climatique publiée. Corriger la description et les périodes. |
| paper_no2_grid | retrouver les observations et covariables sources du modele ensembliste Maintenir hors benchmark empirique; conserver la fiche et orienter une reconstruction distincte vers les observations sources. |
| paper_o3_grid | retrouver les observations et covariables sources du modele ensembliste Maintenir hors benchmark empirique; conserver la fiche et orienter une reconstruction distincte vers les observations sources. |
| paper_pm25_grid | retrouver les observations et covariables sources du modele ensembliste Maintenir hors benchmark empirique; conserver la fiche et orienter une reconstruction distincte vers les observations sources. |
| paper_waste_site | 727 estimations de méta-analyse, 14 positions approximatives; formula_used inclut des champs d’étude et une prose invalide. Maintenir hors benchmark d’observations spatiales; conserver pour une éventuelle méta-régression avec variances et groupes d’étude. |
| Python_geodatasets_naturalearth.cities | La formule propose des rangs/paramètres cartographiques (scalerank, labelrank, rank_max, zoom) comme X de population. Certains peuvent dériver de la population. Garder la couche comme référence cartographique; une tâche population nécessite des covariables indépendantes et datées. |
| R_ade4_macon_macon | Huit lignes d’un tableau de vins; les colonnes nommées x/y ne suffisent pas à prouver un support géographique. Garder hors benchmark spatial jusqu’à preuve d’un repère réel; examiner la documentation de macon. |
| R_ade4_zealand_zealand | Objet actuel essentiellement géométrique, cartographique ou réseau de distances; aucune paire Y/X empirique justifiée dans le sf. Conserver comme source/support; joindre de vraies mesures via des clés documentées si une tâche est définie. Aucune suppression recommandée. |
| R_HistData_OldMaps_OldMaps | Objet actuel essentiellement géométrique, cartographique ou réseau de distances; aucune paire Y/X empirique justifiée dans le sf. Conserver comme source/support; joindre de vraies mesures via des clés documentées si une tâche est définie. Aucune suppression recommandée. |
| R_sp_meuse.grid_ll_meuse.grid_ll | Grille de prédiction meuse; dist est une distance géographique et part.a/part.b des partitions, pas la concentration de zinc observée. Les deux fiches décrivent deux représentations du même support. Conserver comme support de prédiction et rattacher à R_sp_meuse_meuse; ne pas promouvoir la régression dist sur champs de grille. |
| R_sp_meuse.grid_meuse.grid | Grille de prédiction meuse; dist est une distance géographique et part.a/part.b des partitions, pas la concentration de zinc observée. Les deux fiches décrivent deux représentations du même support. Conserver comme support de prédiction et rattacher à R_sp_meuse_meuse; ne pas promouvoir la régression dist sur champs de grille. |
| R_spacetime_air_DE_NUTS1 | Objet actuel essentiellement géométrique, cartographique ou réseau de distances; aucune paire Y/X empirique justifiée dans le sf. Conserver comme source/support; joindre de vraies mesures via des clés documentées si une tâche est définie. Aucune suppression recommandée. |
| R_spData_depmunic_depmunic | N=7 et formula_used contient une équation mathématique hiérarchique non exécutable telle quelle. Garder hors benchmark général; rechercher l’échelle municipale liée avant toute tâche hiérarchique. |
| R_spData_state.vbm_state.vbm | Objet actuel essentiellement géométrique, cartographique ou réseau de distances; aucune paire Y/X empirique justifiée dans le sf. Conserver comme source/support; joindre de vraies mesures via des clés documentées si une tâche est définie. Aucune suppression recommandée. |

## Vérifications exécutées

Commandes exécutées depuis la racine du dépôt (python et Rscript désignent les runtimes locaux de la session). Les scripts R ont été lancés avec OPENBLAS_NUM_THREADS=1.

```powershell
python code/r_catalog/dataset_curation.py
python code/r_catalog/dataset_curation.py --check
python code/package_metadata/export_spatialtidymodels_metadata.py
python code/package_metadata/test_dataset_corrections.py
Rscript code/r_catalog/prepare_lasrosas_benchmark_tasks.R
Rscript code/r_catalog/restore_reviewed_ade4_tables.R
Rscript code/r_catalog/test_reviewed_table_joins.R
Rscript code/r_catalog/check_curated_dataset_artifacts.R
Rscript -e 'source("packages/spatialtidymodels/R/benchmark-datasets.R"); source("packages/spatialtidymodels/R/13-benchmark-spatial.R"); testthat::test_file("packages/spatialtidymodels/tests/testthat/test-response-routing-corrections.R", reporter="summary")'
python tools/check_dataset_fiche_readiness.py --all --no-report
python tools/reconcile_dataset_source_links.py
python tools/kg/09_extract_paper_dataset_uses.py
python tools/kg/04_build_graph.py
python tools/kg/06_make_summaries.py
python tools/kg/07_export_agent_index.py stats
python tools/build_paper_dataset_curation_manifest.py --report wiki/analyses/paper_dataset_benchmark_candidates_2026-09-07.md --html wiki/analyses/paper_dataset_benchmark_candidates_2026-09-07.html --medium-review wiki/analyses/paper_dataset_medium_review_2026-09-07.md --low-review wiki/analyses/paper_dataset_low_archive_2026-09-07.md
```

Résultats : 6 tests Python passent ; 9 assertions R de routage passent ; les jointures ade4 résistent à une permutation et refusent une clé manquante ; les deux sous-ensembles Las Rosas conservent toutes les colonnes du parent. La curation est idempotente (0 fiche à modifier au second passage). Le contrôle des 292 artefacts ne trouve aucune formule disponible invalide ni variable absente. Le contrôle d’admission compte 35 passages, 0 échec bloquant ; le test 3/4 + spatial compte 194 passages, ce qui ne vaut pas admission.

Un essai du générateur papier a produit amphibian_malformation_prevalence, coral_corallium et maipo dans un répertoire isolé (DATASET_FICHE_OUTPUT_DIR), avec DATASET_CURATION_PYTHON pointant le runtime local. Les fiches existantes ont ensuite été régénérées par la couche de curation ciblée pour préserver leur contenu utilisateur.

Le HTML interactif et les manifests de candidats ont été régénérés : 491 candidats (27 high, 172 medium, 292 low), population distincte des 292 fiches. Le CSV de corrections est produit via Artifact Tool, recalculé, puis contrôlé par un aller-retour exact des valeurs (292 lignes, 33 colonnes, empreintes des 292 fiches vérifiées). Le script JavaScript intégré au HTML se parse sans erreur ; ce contrôle ne remplace pas une revue visuelle du navigateur. Les trois formules de l’essai du générateur correspondent exactement aux métadonnées finales. La réconciliation KG est idempotente. git diff --check sur les scripts et fiches concernés passe avec la prise en compte des fins de ligne Windows (cr-at-eol).

Limites des contrôles : les warnings de locale Windows et de conversion de chaînes accentuées sont conservés dans le JSON de validation (22 enregistrements concernés, dont certains warnings viennent de la lecture du registre complet par le loader). Ils ne causent pas d’erreur de formule/chargement ; aucune normalisation destructive des libellés source n’a été faite. La structure sfc est contrôlée, mais cette passe ne remplace pas une validation topologique exhaustive, une revue scientifique ni un benchmark complet.

## Fichiers modifiés et sorties

- `CONTEXT.md`
- `code/package_metadata/export_spatialtidymodels_metadata.py`
- `code/package_metadata/test_dataset_corrections.py`
- `code/r_catalog/build_sf_datasets.R`
- `code/r_catalog/check_curated_dataset_artifacts.R`
- `code/r_catalog/dataset_curation.py`
- `code/r_catalog/export_sf_metadata.R`
- `code/r_catalog/generate_fiches.py`
- `code/r_catalog/generate_fiches_papers.R`
- `code/r_catalog/prepare_lasrosas_benchmark_tasks.R`
- `code/r_catalog/restore_reviewed_ade4_tables.R`
- `code/r_catalog/test_reviewed_table_joins.R`
- `data/final_datasets/sf/R_ade4_doubs_doubs.rds`
- `data/final_datasets/sf/R_ade4_mafragh_mafragh.rds`
- `data/final_datasets/sf/R_agridat_lasrosas.corn_lasrosas.corn_1999.rds`
- `data/final_datasets/sf/R_agridat_lasrosas.corn_lasrosas.corn_2001.rds`
- `data/manifests/datasets/ade4_reviewed_table_joins_2026-09-07.json`
- `data/manifests/datasets/dataset_curation_overrides.json`
- `data/manifests/datasets/dataset_fiches_corrections_2026-09-07.csv`
- `data/manifests/datasets/dataset_fiches_validation_2026-09-07.json`
- `data/manifests/datasets/dataset_recovery_priorities_2026-09-07.json`
- `data/manifests/papers/paper_dataset_benchmark_candidates.csv`
- `data/manifests/papers/paper_dataset_benchmark_candidates.json`
- `inst/kg/paper_dataset_uses.json`
- `packages/spatialtidymodels/R/13-benchmark-spatial.R`
- `packages/spatialtidymodels/R/benchmark-datasets.R`
- `packages/spatialtidymodels/inst/metadata/datasets.json`
- `packages/spatialtidymodels/inst/metadata/estimators.json`
- `packages/spatialtidymodels/tests/testthat/test-response-routing-corrections.R`
- `tools/harvest_dataset_first.py`
- `tools/ingest_dataset_first_candidates.py`
- `tools/kg/09_extract_paper_dataset_uses.py`
- `tools/reconcile_dataset_source_links.py`
- `wiki/analyses/dataset_fiches_corrections_2026-09-07.md`
- `wiki/analyses/paper_dataset_benchmark_candidates_2026-09-07.html`
- `wiki/analyses/paper_dataset_benchmark_candidates_2026-09-07.md`
- `wiki/analyses/paper_dataset_ingestion_gaps_2026-07.md`
- `wiki/analyses/paper_dataset_low_archive_2026-09-07.md`
- `wiki/analyses/paper_dataset_medium_review_2026-09-07.md`
- `wiki/index.md`
- `wiki/log.md`
- `wiki/metadata/paper_dataset_ingestion_pipeline_2026-08.md`

Sorties KG dérivées régénérées dans .kg/extracted/, .kg/graph.sqlite et .kg/summaries/ ; aucun nouveau traitement GROBID. Les artefacts RDS et .kg peuvent être ignorés par Git, mais ont bien été produits localement.

### Fiches corrigées (liste exhaustive)

| Dataset | Fiche | Champs / décision |
| --- | --- | --- |
| paper_airbnb_europe_prices | wiki/datasets/fiches_datasets/paper_airbnb_europe_prices.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_alps_floristic_legacy | wiki/datasets/fiches_datasets/paper_alps_floristic_legacy.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_amazon_tree_dominance | wiki/datasets/fiches_datasets/paper_amazon_tree_dominance.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_amphibian_abnormality_hotspots | wiki/datasets/fiches_datasets/paper_amphibian_abnormality_hotspots.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_amphibian_functional_diversity | wiki/datasets/fiches_datasets/paper_amphibian_functional_diversity.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_amphibian_malformation_prevalence | wiki/datasets/fiches_datasets/paper_amphibian_malformation_prevalence.md | ["Topic", "Formula used evidence", "formula_used"] |
| paper_antarctic_biodiversity_completeness | wiki/datasets/fiches_datasets/paper_antarctic_biodiversity_completeness.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_avian_phylo_functional_distance | wiki/datasets/fiches_datasets/paper_avian_phylo_functional_distance.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_banff_stream_temperature | wiki/datasets/fiches_datasets/paper_banff_stream_temperature.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_bean_landrace_gap_sdm | wiki/datasets/fiches_datasets/paper_bean_landrace_gap_sdm.md | ["Topic", "Selected Y typology", "Selected Y evidence"] |
| paper_beta0_gwr | wiki/datasets/fiches_datasets/paper_beta0_gwr.md | [] |
| paper_biomass_rainforest | wiki/datasets/fiches_datasets/paper_biomass_rainforest.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_brisbane_urban_vegetation | wiki/datasets/fiches_datasets/paper_brisbane_urban_vegetation.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_bumblebee_colony_reproduction | wiki/datasets/fiches_datasets/paper_bumblebee_colony_reproduction.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_california_wildfire_growth | wiki/datasets/fiches_datasets/paper_california_wildfire_growth.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_chaco_bird_richness | wiki/datasets/fiches_datasets/paper_chaco_bird_richness.md | ["Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_checkerspot_phenology | wiki/datasets/fiches_datasets/paper_checkerspot_phenology.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_cluster_detection | wiki/datasets/fiches_datasets/paper_cluster_detection.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_colombia_leptospirosis_risk | wiki/datasets/fiches_datasets/paper_colombia_leptospirosis_risk.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_coral_bathypathes | wiki/datasets/fiches_datasets/paper_coral_bathypathes.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_coral_corallium | wiki/datasets/fiches_datasets/paper_coral_corallium.md | ["Topic", "x_terms_used", "y_term_used", "Formula used evidence", "formula_used"] |
| paper_coral_enallopsammia | wiki/datasets/fiches_datasets/paper_coral_enallopsammia.md | ["Topic", "x_terms_used", "y_term_used", "Formula used evidence", "formula_used"] |
| paper_coral_errina | wiki/datasets/fiches_datasets/paper_coral_errina.md | ["Topic", "x_terms_used", "y_term_used", "Formula used evidence", "formula_used"] |
| paper_coral_goniocorella | wiki/datasets/fiches_datasets/paper_coral_goniocorella.md | ["Topic", "x_terms_used", "y_term_used", "Formula used evidence", "formula_used"] |
| paper_coral_isididae | wiki/datasets/fiches_datasets/paper_coral_isididae.md | ["Topic", "x_terms_used", "y_term_used", "Formula used evidence", "formula_used"] |
| paper_coral_leiopathes | wiki/datasets/fiches_datasets/paper_coral_leiopathes.md | ["Topic", "x_terms_used", "y_term_used", "Formula used evidence", "formula_used"] |
| paper_coral_madrepora | wiki/datasets/fiches_datasets/paper_coral_madrepora.md | ["Topic", "x_terms_used", "y_term_used", "Formula used evidence", "formula_used"] |
| paper_coral_paragorgia | wiki/datasets/fiches_datasets/paper_coral_paragorgia.md | ["Topic", "x_terms_used", "y_term_used", "Formula used evidence", "formula_used"] |
| paper_coral_primnoa | wiki/datasets/fiches_datasets/paper_coral_primnoa.md | ["Topic", "x_terms_used", "y_term_used", "Formula used evidence", "formula_used"] |
| paper_coral_solenosmilia | wiki/datasets/fiches_datasets/paper_coral_solenosmilia.md | ["Topic", "x_terms_used", "y_term_used", "Formula used evidence", "formula_used"] |
| paper_coral_stylaster | wiki/datasets/fiches_datasets/paper_coral_stylaster.md | ["Topic", "x_terms_used", "y_term_used", "Formula used evidence", "formula_used"] |
| paper_covid_sociodemographic_risk | wiki/datasets/fiches_datasets/paper_covid_sociodemographic_risk.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_crane | wiki/datasets/fiches_datasets/paper_crane.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_danajon_coral_distribution | wiki/datasets/fiches_datasets/paper_danajon_coral_distribution.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_desert_tortoise_genotype_niche | wiki/datasets/fiches_datasets/paper_desert_tortoise_genotype_niche.md | ["Topic"] |
| paper_dougfir_sdm | wiki/datasets/fiches_datasets/paper_dougfir_sdm.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_dragonfly_colour_lightness | wiki/datasets/fiches_datasets/paper_dragonfly_colour_lightness.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_dragonfly_diversity_europe | wiki/datasets/fiches_datasets/paper_dragonfly_diversity_europe.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_early_season_biomass | wiki/datasets/fiches_datasets/paper_early_season_biomass.md | ["Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_eberg | wiki/datasets/fiches_datasets/paper_eberg.md | ["Selected Y typology", "Selected Y evidence", "benchmark_task_note", "x_terms_used", "y_term_used", "Formula used evidence", "formula_used"] |
| paper_ethiopia_bushcrow_sdm | wiki/datasets/fiches_datasets/paper_ethiopia_bushcrow_sdm.md | ["Topic", "Selected Y typology", "Selected Y evidence"] |
| paper_ethiopia_clusters | wiki/datasets/fiches_datasets/paper_ethiopia_clusters.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_ethiopia_whitetailed_swallow_sdm | wiki/datasets/fiches_datasets/paper_ethiopia_whitetailed_swallow_sdm.md | ["Topic", "Selected Y typology", "Selected Y evidence"] |
| paper_fhb_ensembling | wiki/datasets/fiches_datasets/paper_fhb_ensembling.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_fire_forest_loss_dominican_republic | wiki/datasets/fiches_datasets/paper_fire_forest_loss_dominican_republic.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_flapper_skate_presence | wiki/datasets/fiches_datasets/paper_flapper_skate_presence.md | ["Topic", "Selected Y typology", "Selected Y evidence"] |
| paper_florida_crash_gsvcm | wiki/datasets/fiches_datasets/paper_florida_crash_gsvcm.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_gcfr_soil | wiki/datasets/fiches_datasets/paper_gcfr_soil.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_global_nee_gwxgboost | wiki/datasets/fiches_datasets/paper_global_nee_gwxgboost.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_goa_trawl_demersal | wiki/datasets/fiches_datasets/paper_goa_trawl_demersal.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_groundfish_cpue | wiki/datasets/fiches_datasets/paper_groundfish_cpue.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_gwqlasso_mt | wiki/datasets/fiches_datasets/paper_gwqlasso_mt.md | ["Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_gwqlasso_pr | wiki/datasets/fiches_datasets/paper_gwqlasso_pr.md | ["Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_gwqlasso_rs | wiki/datasets/fiches_datasets/paper_gwqlasso_rs.md | ["Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_harbour_porpoise_response | wiki/datasets/fiches_datasets/paper_harbour_porpoise_response.md | ["Topic", "Selected Y typology", "Selected Y evidence", "benchmark_task_note", "Recommended validation", "Formula used evidence"] |
| paper_hiv_southern_africa | wiki/datasets/fiches_datasets/paper_hiv_southern_africa.md | ["Selected Y typology", "Selected Y evidence", "benchmark_task_note", "Recommended validation"] |
| paper_houston_lst_landcover | wiki/datasets/fiches_datasets/paper_houston_lst_landcover.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_hummingbird_sdm | wiki/datasets/fiches_datasets/paper_hummingbird_sdm.md | ["Selected Y typology", "Selected Y evidence", "benchmark_task_note", "Formula used evidence"] |
| paper_hyena_lion_biomass_africa | wiki/datasets/fiches_datasets/paper_hyena_lion_biomass_africa.md | ["Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_influenza_mortality_chicago | wiki/datasets/fiches_datasets/paper_influenza_mortality_chicago.md | ["Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_joshua_tree_flowering | wiki/datasets/fiches_datasets/paper_joshua_tree_flowering.md | ["Selected Y typology", "Selected Y evidence", "benchmark_task_note", "Recommended validation", "Formula used evidence", "Topic", "Observed population"] |
| paper_kodiak_puffin_density | wiki/datasets/fiches_datasets/paper_kodiak_puffin_density.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_1989 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_1989.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_1990 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_1990.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_1991 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_1991.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_1992 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_1992.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_1993 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_1993.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_1994 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_1994.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_1995 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_1995.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_1996 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_1996.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_1997 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_1997.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_1998 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_1998.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_1999 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_1999.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_2000 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_2000.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_2001 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_2001.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_2002 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_2002.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_2003 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_2003.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_2004 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_2004.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_2005 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_2005.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_2006 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_2006.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_2007 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_2007.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_2008 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_2008.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_2009 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_2009.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_2010 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_2010.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_2011 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_2011.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_2012 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_2012.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_2013 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_2013.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_2014 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_2014.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_2015 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_2015.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_2016 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_2016.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_2017 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_2017.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_2018 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_2018.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_2019 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_2019.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_korea_hedonic_housing_pre1989 | wiki/datasets/fiches_datasets/paper_korea_hedonic_housing_pre1989.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_leishmaniasis_occurrence | wiki/datasets/fiches_datasets/paper_leishmaniasis_occurrence.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_li_energy_price_co2_china | wiki/datasets/fiches_datasets/paper_li_energy_price_co2_china.md | ["Recommended validation"] |
| paper_ltar_crop_rotation_yield | wiki/datasets/fiches_datasets/paper_ltar_crop_rotation_yield.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_macropod_body_size | wiki/datasets/fiches_datasets/paper_macropod_body_size.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_maine_baseflow | wiki/datasets/fiches_datasets/paper_maine_baseflow.md | ["Topic", "Selected Y typology", "Selected Y evidence"] |
| paper_maipo | wiki/datasets/fiches_datasets/paper_maipo.md | ["Selected Y typology", "Selected Y evidence", "benchmark_task_note", "x_terms_used", "y_term_used", "Formula used evidence", "formula_used"] |
| paper_mammals_sr_pd | wiki/datasets/fiches_datasets/paper_mammals_sr_pd.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_marrot_spatial_autocorrelation_fitness | wiki/datasets/fiches_datasets/paper_marrot_spatial_autocorrelation_fitness.md | ["Selected Y typology", "Selected Y evidence", "benchmark_task_note", "Recommended validation"] |
| paper_medicago | wiki/datasets/fiches_datasets/paper_medicago.md | ["Selected Y typology", "Selected Y evidence", "benchmark_task_note"] |
| paper_metacomnet | wiki/datasets/fiches_datasets/paper_metacomnet.md | ["Selected Y typology", "Selected Y evidence", "benchmark_task_note", "x_terms_used", "y_term_used", "Formula used evidence", "formula_used"] |
| paper_midwest_crop_yield | wiki/datasets/fiches_datasets/paper_midwest_crop_yield.md | ["Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_mimulus_sdm | wiki/datasets/fiches_datasets/paper_mimulus_sdm.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_mistletoe_bird_abundance | wiki/datasets/fiches_datasets/paper_mistletoe_bird_abundance.md | ["Selected Y typology", "Selected Y evidence", "benchmark_task_note", "Recommended validation"] |
| paper_network_misspecification_elections | wiki/datasets/fiches_datasets/paper_network_misspecification_elections.md | ["Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_no2_aqs_ma_2016_monitor_covariates | wiki/datasets/fiches_datasets/paper_no2_aqs_ma_2016_monitor_covariates.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_no2_grid | wiki/datasets/fiches_datasets/paper_no2_grid.md | [] |
| paper_nyc_census2000_gwrboost | wiki/datasets/fiches_datasets/paper_nyc_census2000_gwrboost.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_nyc_tract_income_ssig | wiki/datasets/fiches_datasets/paper_nyc_tract_income_ssig.md | ["Selected Y typology", "Selected Y evidence", "benchmark_task_note"] |
| paper_o3_aqs_ma_2016_monitor_covariates | wiki/datasets/fiches_datasets/paper_o3_aqs_ma_2016_monitor_covariates.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_o3_grid | wiki/datasets/fiches_datasets/paper_o3_grid.md | [] |
| paper_pacific_atoll_coconut | wiki/datasets/fiches_datasets/paper_pacific_atoll_coconut.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_pallid_bat | wiki/datasets/fiches_datasets/paper_pallid_bat.md | ["Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_plant_invasion_fia | wiki/datasets/fiches_datasets/paper_plant_invasion_fia.md | ["Selected Y typology", "Selected Y evidence", "benchmark_task_note", "Recommended validation"] |
| paper_pm25_aqs_ma_2016_monitor_covariates | wiki/datasets/fiches_datasets/paper_pm25_aqs_ma_2016_monitor_covariates.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_pm25_grid | wiki/datasets/fiches_datasets/paper_pm25_grid.md | [] |
| paper_pollinator_urbanization_meta | wiki/datasets/fiches_datasets/paper_pollinator_urbanization_meta.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_portugal_covid_municipal | wiki/datasets/fiches_datasets/paper_portugal_covid_municipal.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_possum_body_size | wiki/datasets/fiches_datasets/paper_possum_body_size.md | ["Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_red_deer_topdown | wiki/datasets/fiches_datasets/paper_red_deer_topdown.md | ["Observed population", "Selected Y typology", "Selected Y evidence", "Recommended validation", "Dataset DOI", "Paper DOI", "Source URL", "Paper title", "Variable temporelle", "Temporal context"] |
| paper_regulatory_convergence | wiki/datasets/fiches_datasets/paper_regulatory_convergence.md | ["x_terms_used", "y_term_used", "Formula used evidence", "formula_used"] |
| paper_rocha_agricultural_technology_brazil | wiki/datasets/fiches_datasets/paper_rocha_agricultural_technology_brazil.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_rocky_mountain_tree_growth | wiki/datasets/fiches_datasets/paper_rocky_mountain_tree_growth.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_seshat_social_complexity | wiki/datasets/fiches_datasets/paper_seshat_social_complexity.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation", "Formula used evidence"] |
| paper_sfbay_contaminated_sites | wiki/datasets/fiches_datasets/paper_sfbay_contaminated_sites.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_shark_longline_catch | wiki/datasets/fiches_datasets/paper_shark_longline_catch.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_snake_home_range | wiki/datasets/fiches_datasets/paper_snake_home_range.md | ["Selected Y typology", "Selected Y evidence", "benchmark_task_note", "Recommended validation"] |
| paper_song_sparrow_breeding_date | wiki/datasets/fiches_datasets/paper_song_sparrow_breeding_date.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "benchmark_task_note", "Recommended validation"] |
| paper_spatial_confounding_diabetes | wiki/datasets/fiches_datasets/paper_spatial_confounding_diabetes.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_spruce_bark_beetle | wiki/datasets/fiches_datasets/paper_spruce_bark_beetle.md | ["Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_stwr_precip_isotope | wiki/datasets/fiches_datasets/paper_stwr_precip_isotope.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_sugarglider_occupancy | wiki/datasets/fiches_datasets/paper_sugarglider_occupancy.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "benchmark_task_note"] |
| paper_swiss_heat_exposure | wiki/datasets/fiches_datasets/paper_swiss_heat_exposure.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "benchmark_task_note"] |
| paper_swiss_rainfall | wiki/datasets/fiches_datasets/paper_swiss_rainfall.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_trillium_presence_background | wiki/datasets/fiches_datasets/paper_trillium_presence_background.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_trillium_proportional_occupancy | wiki/datasets/fiches_datasets/paper_trillium_proportional_occupancy.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_uk_linear_features_birds | wiki/datasets/fiches_datasets/paper_uk_linear_features_birds.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| paper_usgs_flood_skew | wiki/datasets/fiches_datasets/paper_usgs_flood_skew.md | ["Observed population", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_velado_alonso_wildlife_livestock_diversity | wiki/datasets/fiches_datasets/paper_velado_alonso_wildlife_livestock_diversity.md | ["Selected Y typology", "Selected Y evidence", "benchmark_task_note"] |
| paper_vindum | wiki/datasets/fiches_datasets/paper_vindum.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_wald_test | wiki/datasets/fiches_datasets/paper_wald_test.md | ["Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_waste_site | wiki/datasets/fiches_datasets/paper_waste_site.md | ["x_terms_used", "y_term_used", "Formula used evidence", "formula_used"] |
| paper_wildebeest_movement_env | wiki/datasets/fiches_datasets/paper_wildebeest_movement_env.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Recommended validation"] |
| paper_wildfire_bootleg_severity | wiki/datasets/fiches_datasets/paper_wildfire_bootleg_severity.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_wildfire_greenup_nbr5 | wiki/datasets/fiches_datasets/paper_wildfire_greenup_nbr5.md | ["Selected Y typology", "Selected Y evidence"] |
| paper_wildfire_schneider_springs_severity | wiki/datasets/fiches_datasets/paper_wildfire_schneider_springs_severity.md | ["Selected Y typology", "Selected Y evidence"] |
| Python_geodatasets_geoda.airbnb | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.airbnb.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.charleston1 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.charleston1.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.charleston2 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.charleston2.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.chicago_commpop | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.chicago_commpop.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| Python_geodatasets_geoda.chicago_health | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.chicago_health.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.chile_labor | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.chile_labor.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.cincinnati | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.cincinnati.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| Python_geodatasets_geoda.guerry | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.guerry.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| Python_geodatasets_geoda.health | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.health.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.health_indicators | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.health_indicators.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.hickory1 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.hickory1.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.hickory2 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.hickory2.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| Python_geodatasets_geoda.home_sales | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.home_sales.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| Python_geodatasets_geoda.lansing1 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.lansing1.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.lansing2 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.lansing2.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.milwaukee1 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.milwaukee1.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.ncovr_1960 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.ncovr_1960.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| Python_geodatasets_geoda.ncovr_1970 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.ncovr_1970.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| Python_geodatasets_geoda.ncovr_1980 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.ncovr_1980.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| Python_geodatasets_geoda.ncovr_1990 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.ncovr_1990.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| Python_geodatasets_geoda.ndvi | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.ndvi.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.nepal | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.nepal.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| Python_geodatasets_geoda.nyc | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.nyc.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.nyc_earnings_2002 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.nyc_earnings_2002.md | ["Observed population", "Geographic context", "Topic"] |
| Python_geodatasets_geoda.nyc_earnings_2003 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.nyc_earnings_2003.md | ["Observed population", "Geographic context", "Topic"] |
| Python_geodatasets_geoda.nyc_earnings_2004 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.nyc_earnings_2004.md | ["Observed population", "Geographic context", "Topic"] |
| Python_geodatasets_geoda.nyc_earnings_2005 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.nyc_earnings_2005.md | ["Observed population", "Geographic context", "Topic"] |
| Python_geodatasets_geoda.nyc_earnings_2006 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.nyc_earnings_2006.md | ["Observed population", "Geographic context", "Topic"] |
| Python_geodatasets_geoda.nyc_earnings_2007 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.nyc_earnings_2007.md | ["Observed population", "Geographic context", "Topic"] |
| Python_geodatasets_geoda.nyc_earnings_2008 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.nyc_earnings_2008.md | ["Observed population", "Geographic context", "Topic"] |
| Python_geodatasets_geoda.nyc_earnings_2009 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.nyc_earnings_2009.md | ["Observed population", "Geographic context", "Topic"] |
| Python_geodatasets_geoda.nyc_earnings_2010 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.nyc_earnings_2010.md | ["Observed population", "Geographic context", "Topic"] |
| Python_geodatasets_geoda.nyc_earnings_2011 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.nyc_earnings_2011.md | ["Observed population", "Geographic context", "Topic"] |
| Python_geodatasets_geoda.nyc_earnings_2012 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.nyc_earnings_2012.md | ["Observed population", "Geographic context", "Topic"] |
| Python_geodatasets_geoda.nyc_earnings_2013 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.nyc_earnings_2013.md | ["Observed population", "Geographic context", "Topic"] |
| Python_geodatasets_geoda.nyc_earnings_2014 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.nyc_earnings_2014.md | ["Observed population", "Geographic context", "Topic"] |
| Python_geodatasets_geoda.nyc_education | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.nyc_education.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.nyc_neighborhoods | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.nyc_neighborhoods.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| Python_geodatasets_geoda.orlando1 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.orlando1.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.phoenix_acs | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.phoenix_acs.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.police | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.police.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.sacramento1 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.sacramento1.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.savannah1 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.savannah1.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.seattle1 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.seattle1.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.sids_1974 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.sids_1974.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| Python_geodatasets_geoda.sids_1979 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.sids_1979.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| Python_geodatasets_geoda.tampa1 | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.tampa1.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_geoda.us_sdoh | wiki/datasets/fiches_datasets/Python_geodatasets_geoda.us_sdoh.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_geodatasets_naturalearth.cities | wiki/datasets/fiches_datasets/Python_geodatasets_naturalearth.cities.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| Python_geodatasets_spdata.auckland | wiki/datasets/fiches_datasets/Python_geodatasets_spdata.auckland.md | ["Observed population", "Geographic context", "Topic"] |
| Python_geodatasets_spdata.boston | wiki/datasets/fiches_datasets/Python_geodatasets_spdata.boston.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| Python_geodatasets_spdata.columbus | wiki/datasets/fiches_datasets/Python_geodatasets_spdata.columbus.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "formula_pub", "x_terms_pub", "y_term_pub", "Reference publication", "Formula used evidence"] |
| Python_geodatasets_spdata.eire | wiki/datasets/fiches_datasets/Python_geodatasets_spdata.eire.md | ["Observed population", "Geographic context", "Topic"] |
| Python_geodatasets_spdata.nydata | wiki/datasets/fiches_datasets/Python_geodatasets_spdata.nydata.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| Python_geodatasets_spdata.wheat | wiki/datasets/fiches_datasets/Python_geodatasets_spdata.wheat.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| Python_libpysal_Baltimore | wiki/datasets/fiches_datasets/Python_libpysal_Baltimore.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| Python_libpysal_chicagoSDOH | wiki/datasets/fiches_datasets/Python_libpysal_chicagoSDOH.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_libpysal_Elections | wiki/datasets/fiches_datasets/Python_libpysal_Elections.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_libpysal_georgia | wiki/datasets/fiches_datasets/Python_libpysal_georgia.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "formula_pub", "x_terms_pub", "y_term_pub", "Reference publication", "Formula used evidence"] |
| Python_libpysal_NYC_Socio-Demographics | wiki/datasets/fiches_datasets/Python_libpysal_NYC_Socio-Demographics.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| Python_libpysal_Ohiolung | wiki/datasets/fiches_datasets/Python_libpysal_Ohiolung.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| Python_libpysal_Snow | wiki/datasets/fiches_datasets/Python_libpysal_Snow.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| R_ade4_atlas_atlas | wiki/datasets/fiches_datasets/R_ade4_atlas_atlas.md | ["Observed population", "Geographic context", "Topic"] |
| R_ade4_atya_atya | wiki/datasets/fiches_datasets/R_ade4_atya_atya.md | ["Observed population", "Geographic context", "Topic"] |
| R_ade4_avijons_avijons | wiki/datasets/fiches_datasets/R_ade4_avijons_avijons.md | ["Observed population", "Geographic context", "Topic"] |
| R_ade4_buech_buech | wiki/datasets/fiches_datasets/R_ade4_buech_buech.md | ["Observed population", "Geographic context", "Topic"] |
| R_ade4_butterfly_butterfly | wiki/datasets/fiches_datasets/R_ade4_butterfly_butterfly.md | ["Observed population", "Geographic context", "Topic"] |
| R_ade4_doubs_doubs | wiki/datasets/fiches_datasets/R_ade4_doubs_doubs.md | ["Observed population", "Geographic context", "Topic", "k variables", "formula_used", "x_terms_used", "y_term_used", "Formula used evidence", "Restored source variables"] |
| R_ade4_elec88_elec88 | wiki/datasets/fiches_datasets/R_ade4_elec88_elec88.md | ["Geographic context"] |
| R_ade4_irishdata_irishdata | wiki/datasets/fiches_datasets/R_ade4_irishdata_irishdata.md | ["Observed population", "Geographic context", "Topic"] |
| R_ade4_julliot_julliot | wiki/datasets/fiches_datasets/R_ade4_julliot_julliot.md | ["Observed population", "Geographic context", "Topic"] |
| R_ade4_jv73_jv73 | wiki/datasets/fiches_datasets/R_ade4_jv73_jv73.md | ["Observed population", "Geographic context", "Topic"] |
| R_ade4_kcponds_kcponds | wiki/datasets/fiches_datasets/R_ade4_kcponds_kcponds.md | ["Observed population", "Geographic context", "Topic"] |
| R_ade4_macon_macon | wiki/datasets/fiches_datasets/R_ade4_macon_macon.md | ["Observed population", "Geographic context", "Topic"] |
| R_ade4_mafragh_mafragh | wiki/datasets/fiches_datasets/R_ade4_mafragh_mafragh.md | ["Observed population", "Geographic context", "Topic", "k variables", "formula_used", "x_terms_used", "y_term_used", "Formula used evidence", "Restored source variables"] |
| R_ade4_oribatid_oribatid | wiki/datasets/fiches_datasets/R_ade4_oribatid_oribatid.md | ["Observed population", "Geographic context", "Topic"] |
| R_ade4_pcw_pcw | wiki/datasets/fiches_datasets/R_ade4_pcw_pcw.md | ["Observed population", "Geographic context", "Topic"] |
| R_ade4_sarcelles_sarcelles | wiki/datasets/fiches_datasets/R_ade4_sarcelles_sarcelles.md | ["Observed population", "Geographic context", "Topic"] |
| R_ade4_t3012_t3012 | wiki/datasets/fiches_datasets/R_ade4_t3012_t3012.md | ["Observed population", "Geographic context", "Topic"] |
| R_ade4_tintoodiel_tintoodiel | wiki/datasets/fiches_datasets/R_ade4_tintoodiel_tintoodiel.md | ["Observed population", "Geographic context", "Topic"] |
| R_ade4_vegtf_vegtf | wiki/datasets/fiches_datasets/R_ade4_vegtf_vegtf.md | ["Observed population", "Geographic context", "Topic"] |
| R_ade4_zealand_zealand | wiki/datasets/fiches_datasets/R_ade4_zealand_zealand.md | ["Observed population", "Geographic context", "Topic"] |
| R_agridat_gartner.corn_gartner.corn | wiki/datasets/fiches_datasets/R_agridat_gartner.corn_gartner.corn.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| R_agridat_gotway.hessianfly_gotway.hessianfly | wiki/datasets/fiches_datasets/R_agridat_gotway.hessianfly_gotway.hessianfly.md | ["Geographic context"] |
| R_agridat_kayad.alfalfa_kayad.alfalfa | wiki/datasets/fiches_datasets/R_agridat_kayad.alfalfa_kayad.alfalfa.md | ["Geographic context"] |
| R_agridat_lasrosas.corn_lasrosas.corn_1999 | wiki/datasets/fiches_datasets/R_agridat_lasrosas.corn_lasrosas.corn_1999.md | ["Selection Y/X", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| R_agridat_ortiz.tomato.covs_ortiz.tomato.covs | wiki/datasets/fiches_datasets/R_agridat_ortiz.tomato.covs_ortiz.tomato.covs.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| R_agridat_usgs.herbicides_usgs.herbicides | wiki/datasets/fiches_datasets/R_agridat_usgs.herbicides_usgs.herbicides.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| R_agridat_wallace.iowaland_wallace.iowaland | wiki/datasets/fiches_datasets/R_agridat_wallace.iowaland_wallace.iowaland.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| R_gstat_DE_RB_2005_DE_RB_2005 | wiki/datasets/fiches_datasets/R_gstat_DE_RB_2005_DE_RB_2005.md | ["Observed population", "Geographic context", "Selected Y typology", "Selected Y evidence"] |
| R_gstat_fulmar_fulmar | wiki/datasets/fiches_datasets/R_gstat_fulmar_fulmar.md | ["Observed population", "Geographic context", "Selected Y typology", "Selected Y evidence"] |
| R_gstat_jura_jura.val | wiki/datasets/fiches_datasets/R_gstat_jura_jura.val.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| R_gstat_oxford_oxford | wiki/datasets/fiches_datasets/R_gstat_oxford_oxford.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| R_gstat_pcb_pcb | wiki/datasets/fiches_datasets/R_gstat_pcb_pcb.md | ["Observed population", "Geographic context"] |
| R_gstat_walker_walker | wiki/datasets/fiches_datasets/R_gstat_walker_walker.md | ["Observed population", "Geographic context", "Topic"] |
| R_gstat_wind_wind.loc | wiki/datasets/fiches_datasets/R_gstat_wind_wind.loc.md | ["Observed population", "Geographic context", "Topic"] |
| R_GWmodel_DubVoter_Dub.voter | wiki/datasets/fiches_datasets/R_GWmodel_DubVoter_Dub.voter.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| R_GWmodel_EWHP_ewhp | wiki/datasets/fiches_datasets/R_GWmodel_EWHP_ewhp.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| R_GWmodel_LondonHP_londonhp | wiki/datasets/fiches_datasets/R_GWmodel_LondonHP_londonhp.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| R_GWmodel_USelect_USelect2004 | wiki/datasets/fiches_datasets/R_GWmodel_USelect_USelect2004.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| R_HistData_OldMaps_OldMaps | wiki/datasets/fiches_datasets/R_HistData_OldMaps_OldMaps.md | ["Geographic context"] |
| R_MASS_npr1_npr1 | wiki/datasets/fiches_datasets/R_MASS_npr1_npr1.md | ["Observed population", "Geographic context", "Topic"] |
| R_mgwrsar_mydata_mydata | wiki/datasets/fiches_datasets/R_mgwrsar_mydata_mydata.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| R_mgwrsar_mydatasf_mydatasf | wiki/datasets/fiches_datasets/R_mgwrsar_mydatasf_mydatasf.md | ["Observed population", "Geographic context", "Selected Y typology", "Selected Y evidence"] |
| R_sfdep_guerry_nb_guerry_nb | wiki/datasets/fiches_datasets/R_sfdep_guerry_nb_guerry_nb.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| R_sp_meuse.grid_ll_meuse.grid_ll | wiki/datasets/fiches_datasets/R_sp_meuse.grid_ll_meuse.grid_ll.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| R_sp_meuse.grid_meuse.grid | wiki/datasets/fiches_datasets/R_sp_meuse.grid_meuse.grid.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| R_sp_meuse_meuse | wiki/datasets/fiches_datasets/R_sp_meuse_meuse.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| R_spacetime_air_DE_NUTS1 | wiki/datasets/fiches_datasets/R_spacetime_air_DE_NUTS1.md | ["Observed population", "Geographic context", "Topic"] |
| R_spaMM_arabidopsis_arabidopsis | wiki/datasets/fiches_datasets/R_spaMM_arabidopsis_arabidopsis.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| R_spaMM_blackcap_blackcap | wiki/datasets/fiches_datasets/R_spaMM_blackcap_blackcap.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| R_spaMM_Leuca_Leuca | wiki/datasets/fiches_datasets/R_spaMM_Leuca_Leuca.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| R_spaMM_Loaloa_Loaloa | wiki/datasets/fiches_datasets/R_spaMM_Loaloa_Loaloa.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| R_SpatialEpi_pennLC_sf_pennLC_sf | wiki/datasets/fiches_datasets/R_SpatialEpi_pennLC_sf_pennLC_sf.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| R_SpatialEpi_scotland_sf_scotland_sf | wiki/datasets/fiches_datasets/R_SpatialEpi_scotland_sf_scotland_sf.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "benchmark_task_note"] |
| R_spatstat.data_betacells_betacells | wiki/datasets/fiches_datasets/R_spatstat.data_betacells_betacells.md | ["Observed population", "Geographic context", "Topic"] |
| R_spatstat.data_btb_btb | wiki/datasets/fiches_datasets/R_spatstat.data_btb_btb.md | ["Geographic context"] |
| R_spatstat.data_clmfires_clmfires | wiki/datasets/fiches_datasets/R_spatstat.data_clmfires_clmfires.md | ["Observed population", "Geographic context", "Selected Y typology", "Selected Y evidence"] |
| R_spatstat.data_finpines_finpines | wiki/datasets/fiches_datasets/R_spatstat.data_finpines_finpines.md | ["Observed population", "Geographic context", "Topic"] |
| R_spatstat.data_gorillas_gorillas | wiki/datasets/fiches_datasets/R_spatstat.data_gorillas_gorillas.md | ["Observed population", "Geographic context"] |
| R_spatstat.data_nbfires_nbfires | wiki/datasets/fiches_datasets/R_spatstat.data_nbfires_nbfires.md | ["Observed population", "Geographic context", "Selected Y typology", "Selected Y evidence"] |
| R_spatstat.data_shapley_shapley | wiki/datasets/fiches_datasets/R_spatstat.data_shapley_shapley.md | ["Observed population", "Geographic context", "Topic"] |
| R_spatstat.data_stonetools_stonetools | wiki/datasets/fiches_datasets/R_spatstat.data_stonetools_stonetools.md | ["Observed population", "Geographic context", "Topic"] |
| R_spData_baltimore_baltimore | wiki/datasets/fiches_datasets/R_spData_baltimore_baltimore.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| R_spData_depmunic_depmunic | wiki/datasets/fiches_datasets/R_spData_depmunic_depmunic.md | ["Observed population", "Geographic context", "Topic", "formula_used", "x_terms_used", "y_term_used", "Formula used evidence"] |
| R_spData_elect80_elect80 | wiki/datasets/fiches_datasets/R_spData_elect80_elect80.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| R_spData_house_house | wiki/datasets/fiches_datasets/R_spData_house_house.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |
| R_spData_nydata_nydata | wiki/datasets/fiches_datasets/R_spData_nydata_nydata.md | ["Observed population", "Geographic context", "Topic", "formula_used", "x_terms_used", "y_term_used", "Formula used evidence"] |
| R_spData_nz_nz | wiki/datasets/fiches_datasets/R_spData_nz_nz.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| R_spData_properties_properties | wiki/datasets/fiches_datasets/R_spData_properties_properties.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| R_spData_state.vbm_state.vbm | wiki/datasets/fiches_datasets/R_spData_state.vbm_state.vbm.md | ["Observed population", "Geographic context", "Topic"] |
| R_spData_world_world | wiki/datasets/fiches_datasets/R_spData_world_world.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| R_spDataLarge_census_de_census_de | wiki/datasets/fiches_datasets/R_spDataLarge_census_de_census_de.md | ["Geographic context"] |
| R_spDataLarge_lsl_lsl | wiki/datasets/fiches_datasets/R_spDataLarge_lsl_lsl.md | ["Observed population", "Geographic context", "Topic", "Selected Y typology", "Selected Y evidence"] |
| R_spDataLarge_pol_pres15_pol_pres15 | wiki/datasets/fiches_datasets/R_spDataLarge_pol_pres15_pol_pres15.md | ["Geographic context", "Selected Y typology", "Selected Y evidence", "Formula used evidence"] |
| R_surveillance_hagelloch_hagelloch | wiki/datasets/fiches_datasets/R_surveillance_hagelloch_hagelloch.md | ["Geographic context", "Selected Y typology", "Selected Y evidence"] |

## Sources encore nécessaires et validation avant promotion

La source exacte de Cases pour nydata, la tâche empirique originale de Joshua Tree, la traduction des modèles regulatory_convergence/waste_site/depmunic, les protocoles count/binaires/panels et les quinze récupérations prioritaires restent à valider. Les formules système complètes de coral/maipo ne prouvent pas que ce jeu de X corresponde au modèle publié ni qu’il soit statistiquement adapté.

Les propositions de récupération sont prêtes à être examinées dans ce rapport ; aucune promotion ambiguë n’a été appliquée. Une validation explicite de Y, X, formule/provenance et protocole sera nécessaire avant tout passage à yes.

Pages liées : [[dataset_fiches_consistency_audit_2026-09-07]], [[paper_dataset_ingestion_pipeline_2026-08]], [[paper_dataset_benchmark_candidates_2026-09-07]].


## Related Pages

Aucune fiche wiki associee a ce rapport ; se referer aux sources listees en frontmatter.
