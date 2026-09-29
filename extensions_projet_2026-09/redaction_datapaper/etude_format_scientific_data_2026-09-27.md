# Étude du format *Scientific Data* pour le data paper

Date de contrôle : 27 septembre 2026  
Objet : déterminer le format éditorial à appliquer avant la prochaine réécriture du manuscrit.

## Décision principale

Le manuscrit doit être préparé comme un **Data Descriptor** de *Scientific Data*. Les trois modèles éditoriaux principaux du corpus local sont :

1. **MedMNIST v2**, pour la description de jeux dérivés de sources multiples, des fichiers distribués, des partitions et de la validation technique ;
2. **Compound Matrix-Based Project Database**, pour la consolidation de plusieurs banques, les parseurs, les contrôles automatiques et la distinction entre instances originales et générées ;
3. **Construction Motion Data Library**, pour la description détaillée des transformations, de l’harmonisation et de la différence entre corpus analysé et corpus effectivement redistribué.

**LAGOS-NE** reste le meilleur modèle du corpus pour la provenance par variable, les unités spatiales, les relations multi-échelles et les contrôles de qualité. Il complète le modèle éditorial des trois articles précédents.

**GriddingMachine ne doit pas servir de plan éditorial.** L’article est publié dans *Scientific Data*, mais son texte suit une structure d’article — *Introduction*, *Results*, *Discussion*, *Methods* — et non celle d’un Data Descriptor. Il reste utile pour documenter résolution, projection, orientation, unités, rééchantillonnage et distribution de couches spatiales.

## Exigences officielles vérifiées

La [page officielle de préparation des manuscrits](https://www.nature.com/sdata/publish/submission-guidelines) impose aux Data Descriptors l’ordre général suivant :

1. titre ;
2. auteurs et affiliations ;
3. résumé ;
4. *Background & Summary* ;
5. *Methods* ;
6. *Data Records* ;
7. *Data Overview*, facultatif ;
8. *Technical Validation* ;
9. *Usage Notes*, facultatif ;
10. *Data Availability* ;
11. *Code Availability* ;
12. références ;
13. contributions des auteurs ;
14. intérêts concurrents ;
15. remerciements, facultatifs ;
16. financement ;
17. déclaration éthique lorsqu’elle est pertinente.

Les contraintes qui affectent directement notre manuscrit sont les suivantes :

- le titre ne doit pas dépasser **110 caractères, espaces compris** ;
- le résumé devrait rester sous **170 mots** et décrire les données et leurs usages, sans annoncer de nouveau résultat scientifique ni donner d’URL de téléchargement ;
- les références doivent être **numériques** ;
- le Data Descriptor ne doit pas contenir de section de résultats ou de discussion ;
- *Data Records* doit dire concrètement quels fichiers sont partagés, dans quel dépôt, sous quels formats et avec quelle organisation ;
- *Data Overview* est facultatif et doit rester bref : un paragraphe et, en principe, une ou deux figures ou tables ;
- *Technical Validation* doit présenter les contrôles ou expériences qui soutiennent effectivement la qualité technique des données ;
- *Usage Notes* doit rester technique et ne pas devenir une conclusion, un argumentaire promotionnel ou une série d’études de cas ;
- la disponibilité des données doit répéter brièvement les liens, identifiants et citations des dépôts déjà détaillés dans *Data Records* ;
- pour une version LaTeX révisée, les références doivent être intégrées au fichier `.tex` plutôt que dépendre d’un `.bib` externe ;
- les hyperliens internes produits par `\cref` ou des commandes similaires ne sont pas souhaités : les renvois doivent être écrits simplement, par exemple « Fig. 1 ».

Le guide ne prescrit pas de police, de maquette LaTeX ou de gabarit visuel particulier. La revue déconseille même de reprendre un ancien modèle trouvé sur Overleaf. La mise en forme actuelle peut donc rester sobre ; la priorité porte sur les rubriques obligatoires, la clarté et le contenu scientifique.

## Structure observée dans les articles de référence

Les nombres de mots ci-dessous sont des approximations obtenues à partir des TEI. Les tableaux ont également été vérifiés dans les PDF, car leur texte est parfois aplati par GROBID.

| Article | Format réel | Longueur et organisation observées | Figures/tables détectées | Leçon principale |
|---|---|---|---:|---|
| MedMNIST v2 | Data Descriptor | 10 pages ; *Background & Summary* ≈ 645 mots ; méthodes détaillées jeu par jeu ; *Data Records* bref et concret ; validation organisée par familles de modèles ; *Usage Notes* très court | 6 / 4 | La description des fichiers, des clés, des splits et des transformations doit être concrète. |
| CMPD | Data Descriptor | 10 pages ; *Background & Summary* ≈ 970 mots ; construction et génération décrites dans les méthodes ; *Data Records* ≈ 970 mots ; validation ≈ 610 mots ; notes d’usage ≈ 530 mots | 6 / 1 | Une banque consolidée doit distinguer sources originales, objets transformés et objets générés. |
| Construction Motion Data Library | Data Descriptor | 15 pages ; méthodes longues et subdivisées par opération ; *Data Records* ≈ 450 mots ; validation technique substantielle ; notes d’usage ≈ 480 mots | 12 / 5 | Chaque transformation importante peut disposer de sa propre sous-section et de contrôles associés. |
| GriddingMachine | Article, pas Data Descriptor | 11 pages ; *Introduction*, *Results*, *Discussion*, puis *Methods* ; aucune rubrique *Data Records* ou *Technical Validation* | 4 / 1 | Référence thématique pour les grilles spatiales, mais mauvais modèle pour notre plan. |

Les trois Data Descriptors ne suivent pas une longueur uniforme. Leur régularité vient plutôt de la fonction de chaque section : les méthodes expliquent la fabrication, *Data Records* décrit précisément les objets déposés et *Technical Validation* rapporte les contrôles réellement exécutés.

## Diagnostic du manuscrit actuel

Manuscrit examiné : `latex_scientific_data/manuscript_scientific_data.tex`.

| Élément | État actuel | Diagnostic | Action requise avant soumission |
|---|---|---|---|
| Titre | 120 caractères | Dépasse la limite de 110 caractères et contient une formulation générale sur la recherche reproductible | Choisir un titre descriptif plus court après fixation du contenu réellement déposé. |
| Résumé | Environ 140 mots | Longueur conforme, mais mélange justification bibliographique, 392 fiches, admissions internes et état inachevé de la diffusion | Le recentrer sur les seuls jeux effectivement prêts et déposés ; retirer `package registry`, les statuts internes et les données non distribuables. |
| Encadré de snapshot | Dates internes des 24–25 septembre | Ressemble à une note de travail et non à un élément publiable | Le retirer de la version article ; remplacer les dates internes par une version ou un DOI du dépôt gelé. |
| *Background & Summary* | Environ 870 mots, deux figures et deux tables avant les méthodes | Contient beaucoup de résultats de la petite méta-analyse et de statistiques internes. Le guide exclut les résultats et analyses développés d’un Data Descriptor | Garder le besoin scientifique, la lacune documentaire et la contribution de la banque ; réduire ou déplacer la méta-analyse détaillée. |
| Citations | Commandes `\cite` donnant des références numériques à la compilation | Compatible avec le style demandé, mais plusieurs phrases énumèrent trop d’auteurs ou de systèmes | Écrire les idées d’abord, puis placer une ou plusieurs références numériques en fin de proposition. |
| *Methods* | Environ 1 250 mots | Bonne base, mais mêle méthode de collecte, revue de littérature, sous-échantillonnage encore expérimental et semi-synthétique hors périmètre | Recentrer sur la construction exacte de la version déposée : recherche, acquisition, extraction, sélection, curation, transformation et contrôle. |
| *Data Records* | Environ 325 mots | Décrit surtout un arbre local et des statuts de travail. Aucun dépôt public, DOI, manifeste immuable ou dictionnaire complet n’est disponible | Cette section n’est pas encore soumissionnable. Elle devra nommer les fichiers distribués, formats, dossiers, identifiants, tables de métadonnées et dépôts. |
| *Data Overview* | Environ 60 mots | La brièveté est conforme, mais les figures de composition se trouvent principalement dans *Background & Summary* | Déplacer ici au maximum une ou deux représentations descriptives réellement utiles. |
| *Technical Validation* | Environ 340 mots | Présente honnêtement les contrôles, mais insiste sur les contrôles manquants, les alertes et les éléments non gelés | Exécuter et figer les validations nécessaires ; rapporter les contrôles positifs et leurs limites sans présenter un chantier non terminé comme validation. |
| *Usage Notes* | Environ 280 mots | Plusieurs remarques sont utiles, mais la section contient aussi des limites générales et des recommandations méthodologiques étendues | Conserver seulement les instructions pratiques : lecture, jointures, formules, CRS, poids, panels, splits et précautions anti-fuite. |
| Disponibilité | Chemins du dépôt local | Ne répond pas à l’exigence d’un dépôt accessible aux évaluateurs puis public | Créer un dépôt de données versionné, avec identifiant stable, fichiers téléchargeables et citations des sources originales. |
| Code | Code local décrit mais non archivé | La description est utile, mais aucun commit, environnement gelé ou DOI de code n’est annoncé | Archiver une version exécutable et documenter les commandes de reconstruction et de validation. |
| Ordre final | Remerciements, contributions, intérêts, financement, puis références | Ne suit pas l’ordre conseillé | Mettre les références avant les déclarations finales, puis contributions, intérêts, remerciements et financement. |
| Éthique | Absente | Plusieurs jeux peuvent provenir de données humaines, animales ou sensibles | Ajouter dans les méthodes une déclaration expliquant le statut de réutilisation et renvoyer aux approbations des sources lorsque cela s’applique. |
| LaTeX | Bibliographie incorporée, mais `hyperref` rend les renvois internes cliquables | La bibliographie autonome va dans le bon sens ; les liens internes devront être neutralisés dans la version révisée | Conserver la bibliographie intégrée et produire des renvois en texte simple. |

## Plan éditorial recommandé

### Abstract

Le résumé devra répondre à quatre questions seulement :

1. quel problème pratique empêche actuellement la réutilisation de jeux spatiaux ;
2. quels jeux **effectivement prêts et distribués** composent la version décrite ;
3. quelles informations et quels artefacts sont fournis pour chaque jeu ;
4. quels usages la banque rend possibles.

Les 392 fiches ne doivent plus représenter la taille publiée si une partie est en statut `manual_review` ou `no`. Le dénominateur final sera celui du snapshot distribuable.

### Background & Summary

Cette section devrait suivre quatre mouvements :

1. les simulations spatiales sont indispensables mais les applications empiriques restent dispersées et difficiles à reproduire ;
2. les banques généralistes standardisent les fichiers ou les tâches, tandis que les banques spatiales de domaine documentent bien la géométrie et la provenance ;
3. il manque une ressource transversale associant provenance, rôles analytiques, support spatial, temps, formules et relations de voisinage ;
4. présentation factuelle de la banque déposée et de ses limites de portée.

La petite méta-analyse peut soutenir le premier mouvement avec un ou deux résultats robustes. Ses tableaux détaillés, la répartition complète des familles de méthodes et les analyses par domaine ne doivent pas dominer le Data Descriptor.

### Methods

Sous-sections recommandées :

1. **Scope and eligibility criteria** — définition d’un jeu source, d’un enregistrement analytique et du noyau distribuable ;
2. **Source discovery and acquisition** — voies logiciel, article et dépôt ;
3. **Data extraction and source fidelity** — réponse, covariables, formule, unité statistique et échantillon ;
4. **Spatial and temporal harmonisation** — coordonnées, géométries, CRS, supports, temps et panels parents ;
5. **Spatial weights provenance** — matrices des auteurs, matrices reconstruites et matrices créées par le projet, sans les confondre ;
6. **File conversion and registry construction** — transformation des sources brutes vers les artefacts distribués ;
7. **Quality-control workflow** — contrôles automatiques puis validation manuelle ;
8. **Ethics and sensitive-data handling**, si nécessaire.

Le semi-synthétique doit rester hors de ce premier Data Descriptor si la décision est de consacrer l’article à la banque et au package de données. Le sous-échantillonnage ne reste dans les méthodes que s’il produit effectivement des fichiers distribués dans la version décrite.

### Data Records

Cette section devra être reconstruite à partir du snapshot final et du dépôt public. Elle devra présenter :

- l’identifiant et la version de la publication de données ;
- les fichiers et dossiers réellement téléchargeables ;
- le registre principal et son schéma ;
- le dictionnaire des variables ;
- les artefacts de données et leurs formats ;
- les géométries, CRS et poids spatiaux lorsqu’ils sont distribués ;
- les relations entre panel parent et dérivés ;
- les checksums, tailles, licences et citations des sources ;
- les éléments uniquement référencés mais non redistribués.

### Data Overview

Conserver au maximum :

- une figure montrant la composition du **noyau distribué** ;
- éventuellement une table compacte par type de support, structure temporelle et type de réponse.

Les données en `manual_review` ou `no` ne doivent pas entrer dans ces dénombrements comme composants de la banque publiée.

### Technical Validation

Organiser la validation selon les objets vérifiés :

1. intégrité et lisibilité des fichiers ;
2. conformité au schéma du registre ;
3. présence et type de Y, X, coordonnées, temps et identifiants ;
4. validité géométrique et CRS ;
5. fidélité des formules et des effectifs aux sources ;
6. cohérence des panels parents et dérivés ;
7. provenance, dimensions, ordre, normalisation et îlots des poids spatiaux ;
8. reproductibilité des chargeurs ;
9. licences et droits de redistribution.

Un contrôle non exécuté doit rester une limite ou une tâche préalable à la publication, pas un résultat de validation.

### Usage Notes

Limiter cette section aux procédures nécessaires pour réutiliser correctement les données : chargement, sélection d’une tâche, jointures, précautions relatives aux unités spatiales, construction ou lecture de `W`, structure des panels, partitions recommandées et citation des producteurs originaux.

## Figures et tableaux

Les légendes du manuscrit actuel sont trop longues par rapport aux exemples examinés. Chaque légende devrait identifier l’objet, définir les abréviations nécessaires et préciser le dénominateur, sans raconter les méthodes ni reproduire la discussion.

Plan graphique recommandé :

1. **Figure 1 — construction de la banque**, depuis les sources jusqu’au noyau distribué ;
2. **Figure 2 — structure des objets distribués**, reliant source, jeu parent, enregistrement analytique, artefact, géométrie et poids ;
3. **Figure 3 — composition du noyau publié**, seulement si elle apporte une information descriptive difficile à lire dans une table.

La figure de diversité des applications empiriques et la matrice méthodes-domaines relèvent surtout de la revue introductive. Elles peuvent être retirées du Data Descriptor ou réduites à un résultat textuel si elles ne décrivent pas directement les données déposées.

## Style à appliquer

- employer des chiffres pour les mesures, effectifs, dates, dimensions et numéros de version ;
- écrire un nombre en toutes lettres lorsqu’il ouvre une phrase, ou reformuler la phrase ;
- éviter les points-virgules en série ;
- préférer des phrases courtes portant une seule affirmation vérifiable ;
- définir les termes propres au projet à leur première occurrence ;
- remplacer `article-dataset`, `parent-aware` et les noms de statuts internes par des expressions compréhensibles sans connaissance du dépôt ;
- citer numériquement les sources à la fin de l’affirmation qu’elles soutiennent ;
- ne jamais présenter une matrice `W` construite par le projet comme une matrice utilisée par les auteurs ;
- distinguer systématiquement catalogue de travail, noyau distribué, tâches de benchmark et exécutions de benchmark.

## Conditions à remplir avant la réécriture finale

La prochaine réécriture complète ne doit commencer qu’après fixation des éléments suivants :

1. snapshot du noyau réellement prêt et redistribuable ;
2. dépôt public ou espace anonyme accessible aux évaluateurs ;
3. manifeste immuable avec checksums et tailles ;
4. licences et droits de redistribution par jeu ;
5. dictionnaire des variables et des fichiers ;
6. résultats des contrôles de géométrie, CRS, formules, panels et poids ;
7. version archivée du code et commandes de reproduction ;
8. périmètre confirmé du package dans l’article ;
9. titre définitif et informations d’auteur ;
10. décision finale sur la place de la petite méta-analyse.

Le manuscrit actuel reste utile comme document de travail. Il ne doit cependant plus être présenté comme presque soumissionnable : sa structure générale est proche du format demandé, mais son objet publié, ses *Data Records* et sa validation technique dépendent encore du snapshot distribuable.
