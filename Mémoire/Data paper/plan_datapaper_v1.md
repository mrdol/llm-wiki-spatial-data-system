# Plan détaillé — Data paper (format *Scientific Data*, Data Descriptor)

**Statut :** proposition soumise à validation, 18 août 2026.
**Base de travail :** brief de rédaction existant `wiki/analyses/datapapers/spatial_benchmark_databank_blocs_1_2_datapaper_draft_2026_08.md` (356 lignes, structure en 15 sections, non conforme au gabarit *Scientific Data*), à remapper sur le gabarit de la revue et à actualiser (ses chiffres datent du 4 août : 91 fiches, 7 datasets embarqués).

---

## 0. Cadrage

| Élément | Choix proposé |
|---|---|
| Revue cible | *Scientific Data* (Data Descriptor) |
| Rubriques imposées | Background & Summary, Methods, Data Records, Technical Validation, Usage Notes, Data Records availability, Code availability |
| Langue | Anglais |
| Auteurs | J. D'Oliveira, G. Geniaux (ordre à confirmer) |
| Objet décrit | La **ressource** : catalogue de 289 fiches + registre exporté + couche d'exécution `spatialtidymodels` |
| Hors périmètre, à dire explicitement | Tout classement d'estimateurs, tout verdict `SUPERIOR`/`INFERIOR`, tout taux de victoire. Ces résultats relèvent d'un article de benchmark distinct, avec protocole gelé. |

Périmètre de la version : les deux premières familles de sources (objets de packages R/Python, jeux liés à des publications). La troisième famille (entrepôts institutionnels) est annoncée comme extension, pas décrite comme livrée.

---

## 1. Title & Abstract

Titre de travail : *A provenance-aware benchmark data bank of spatial and spatio-temporal datasets for evaluating spatial regression and spatial machine-learning estimators.*

L'abstract du brief wiki (§2) est déjà bon et conforme au ton attendu. Trois retouches : actualiser les chiffres, remplacer « seven embedded » par l'état gelé au moment de la soumission, et conserver la dernière phrase qui exclut explicitement tout classement empirique.

## 2. Background & Summary

Paragraphes continus, sans sous-titres, conformément à l'usage de la revue. Cinq mouvements, un paragraphe chacun.

1. La comparaison de méthodes exige plusieurs jeux de données, pas un cas d'espèce — argument canonique de Demšar (2006), matérialisé en apprentissage automatique par des collections standardisées (Olson *et al.*, 2017 ; suites de comparaison OpenML) et codifié par les guides d'évaluation de méthodes computationnelles (Weber *et al.*, 2019 ; Thiyagalingam *et al.*, 2022).
2. Le domaine spatial ajoute une contrainte propre : la dépendance spatiale invalide les protocoles d'évaluation usuels, et le biais affecte le réglage des hyperparamètres autant que l'évaluation finale (Roberts *et al.*, 2017 ; Schratz *et al.*, 2019). Un jeu de données « qui contient des coordonnées » ne suffit donc pas ; il faut le rôle documenté des variables, le support spatial et le protocole de validation recommandé.
3. **Enjeux situés — paragraphe quantifié (nouveau, voir `protocole_mesure_mc_vs_donnees_reelles.md`).** La littérature de développement méthodologique en statistiques spatiales, économétrie spatiale et géographie quantitative investit un effort substantiel dans le design de processus générateurs de données couvrant une variété de configurations, mais n'évalue généralement les propositions que sur un à trois jeux de données réels. Ce paragraphe porte les chiffres de synthèse de l'étude bibliométrique dédiée : médiane et étendue du nombre de configurations simulées, médiane et étendue du nombre de jeux réels, part des articles à un seul jeu réel, concentration sur les jeux canoniques. Ce déséquilibre est l'argument fondateur de la ressource : il n'exprime pas un défaut de rigueur des auteurs, mais l'indisponibilité de matériel empirique standardisé.
4. Une seconde contrainte est la reproductibilité : une part importante des travaux publiés en géosciences n'est pas reproductible faute de documentation des traitements (Konkol *et al.*, 2019 ; Brunsdon & Comber, 2021), et l'offre logicielle en économétrie spatiale sous R est fragmentée entre packages aux conventions incompatibles (Bivand *et al.*, 2021).
5. De ces contraintes découle le besoin d'une ressource qui documente conjointement la donnée, sa spécification et son protocole d'évaluation — et non d'un simple dépôt de fichiers. Les principes FAIR (Wilkinson *et al.*, 2016) en fixent le cahier des charges.
6. Annonce de ce que décrit l'article : la banque, son schéma de métadonnées en six blocs, sa chaîne de production, et la couche d'exécution `spatialtidymodels`. Phrase de clôture explicitant qu'aucun résultat comparatif n'est revendiqué.

## 3. Methods

C'est ici que va toute l'ingénierie. Sous-sections autorisées par la revue.

**3.0 Bibliometric characterisation of evaluation practice (nouveau).** Base de sondage, critères d'inclusion, règles de comptage des configurations de simulation et des jeux réels, et validation du codage par double-codage humain sur sous-échantillon avec taux d'accord publié. Protocole complet dans `protocole_mesure_mc_vs_donnees_reelles.md`. Une affirmation quantitative sans protocole déclaré serait fragile en évaluation.

**3.1 Source scope and admission routes.** Les deux voies d'entrée (objets de packages ; jeux liés à des publications), leurs critères d'inclusion respectifs et les exclusions assumées. Reprise directe des §4 et §5 du brief wiki, qui sont déjà rédigés et opérationnels.

**3.2 Bibliographic acquisition.** DataCite, Crossref, OpenAlex pour la découverte et la vérification des identifiants ; JabRef pour la gestion des références ; GROBID pour la conversion des PDF en documents structurés dont on extrait sections, références et métadonnées.

**3.3 Knowledge graph and wiki layer.** L'architecture inspirée de *LLM Wiki* (Karpathy, 2026) : corpus curé, extraction vers un graphe de connaissances (Hogan *et al.*, 2021), synthèse en fiches wiki validées. Justifier le choix par la maîtrise du coût de contexte, en s'appuyant sur la dégradation documentée des modèles sur contexte long (Liu *et al.*, 2024) — argument de méthode, pas de performance. Préciser que les agents de programmation sont employés successivement sous pilotage humain, jamais en délégation automatique.

**3.4 Metadata schema.** Les six blocs, présentés en **tableau** (T1) plutôt qu'en prose : formule et variables (en distinguant formule publiée, formule confirmée manuellement et formule générée par le système) ; identification et traçabilité ; typologie des modèles ; typologie des données avec profil N/T ; résolution et étendue spatiales et temporelles ; reproductibilité. Renvoi au schéma de registre v3.

**3.5 LLM-assisted curation and three-tier quality control.** Niveau 1 structurel, niveau 2 sémantique par juge modèle de langage, niveau 3 file de révision humaine. Citer Zheng *et al.* (2023) pour justifier que les biais documentés du juge modèle imposent le troisième niveau, et énoncer la règle de non-auto-validation : un score proposé par le modèle n'est jamais validé par le modèle.

**3.6 Benchmark-readiness criteria.** Les conditions cumulatives de promotion (artefact local lisible, réponse utilisable, covariables présentes, support spatial exploitable, preuve de spécification, éligibilité d'estimateurs déclarée), et les états de non-promotion. Insister sur le fait que la promotion est une décision documentée, pas un effet de bord de l'existence d'une fiche.

**3.7 Execution layer: `spatialtidymodels`.** Les moteurs `parsnip` (28 estimateurs, 14 familles, référence/variante), les cinq schémas de validation croisée, le moteur d'orchestration, et le moteur de comparaison avec ses règles de décision (zone d'équivalence, Wilcoxon apparié, garde-fous, unité d'analyse). Ici on décrit le **dispositif**, jamais ses résultats. Mentionner l'API d'enregistrement d'un estimateur externe comme mécanisme d'extensibilité de la ressource.

## 4. Data Records

Trois inventaires distincts, à ne jamais fusionner en un chiffre unique — recommandation du brief wiki §9, que je reprends telle quelle :

1. le **registre complet** (289 fiches, toutes maturités confondues) ;
2. le **manifeste d'actifs** effectivement inclus ou récupérables de façon reproductible ;
3. le **noyau de benchmark**, sous-ensemble explicitement admis à l'exécution automatisée.

Tableaux prévus :

| # | Tableau | Contenu |
|---|---|---|
| T1 | Schéma de métadonnées | les six blocs, champ par champ, avec type et valeurs autorisées |
| T2 | Composition du registre | par famille de source, par type spatial/spatio-temporel, par statut de promotion |
| T3 | Profil des jeux promus | distribution de N et T, type de géométrie, typologie de la variable réponse |
| T4 | Registre des estimateurs | estimateur, backend, famille, rôle référence/variante, arguments spatiaux, hyperparamètres |
| T5 | Schémas de validation croisée | nom, principe, cas d'usage recommandé |
| T6 | Provenance et licences | présence de DOI jeu / DOI publication, licence, statut de redistribution |

Chiffres vérifiés disponibles à ce jour (à regeler au moment de la soumission) : 289 fiches, dont 153 issues de publications, 74 de packages R, 62 de packages Python ; 237 jeux spatiaux et 52 spatio-temporels ; 155 promus, 53 en révision manuelle, 81 écartés ; N variant de 16 à 178 719, médiane 2 981 parmi les promus ; 33 des 155 promus ont plus d'une période ; 16 jeux embarqués nativement contre 273 accessibles depuis le dépôt.

## 5. Technical Validation

**Contrainte impérative : cette section documente la qualité de la ressource, jamais des résultats scientifiques.** Aucune comparaison d'estimateurs, aucun verdict, aucun taux de victoire. Cinq objets de validation :

1. **Validation structurelle.** Taux de fiches franchissant le niveau 1 (frontmatter, sections obligatoires, liens internes résolus) ; le contrôle inter-blocs et son taux de détection.
2. **Complétude des métadonnées.** DOI de jeu renseigné pour 146/289, DOI de publication pour 166/289, système de coordonnées résolu pour 212/289 (77 encore en attente), formule adossée à une publication pour 182/289 et 136/155 parmi les promus, base d'éligibilité renseignée pour 139/155 des promus.
3. **Vérification de chargement.** Test de chargement réussi et ajustement de référence sans erreur pour les jeux du noyau ; c'est la validation d'exécution admissible ici, à condition de rapporter le fait que le jeu se charge et s'ajuste, pas la valeur de ses métriques.
4. **Cohérence interne.** Vérification de la concordance entre géométrie déclarée et géométrie réelle, entre profil N/T déclaré et structure observée — l'audit des 51 fiches panel en fournit le précédent, y compris les cinq reclassements qu'il a produits.
5. **Fidélité de l'implémentation.** La parité ligne à ligne entre le package et l'implémentation manuelle antérieure sur trois jeux et l'ensemble de leurs plis, écart maximal nul, ainsi que le cas d'échec reproductible documenté. C'est une propriété du logiciel, pas un résultat comparatif : admissible ici.

## 6. Usage Notes

Quatre recommandations d'usage, en prose.

1. **Ne pas traiter les sous-tâches d'une même source comme indépendantes.** Un jeu découpé en trente-deux sous-ensembles annuels ne constitue pas trente-deux observations indépendantes ; l'unité d'analyse par source, qui agrège d'abord par la médiane les écarts relatifs des tâches partageant une source, existe précisément pour cela.
2. **Choisir un schéma de validation cohérent avec l'hypothèse de dépendance.** Le schéma retenu est une hypothèse et doit être déclaré avec tout résultat.
3. **Respecter les licences.** Renvoi explicite à la limitation énoncée ci-dessous.
4. **Distinguer disponibilité et exécution.** Un jeu promu est prêt à être exécuté ; cela ne signifie pas qu'il l'ait été.

## 7. Data availability, Code availability, Limitations

Disponibilité des données, disponibilité du code (dépôt, version gelée et citable), puis un paragraphe de limitations qui reprend celles du brief wiki §12 en les actualisant : corpus provisoirement validé et non finalisé, écart entre les 16 jeux embarqués et les 155 promus, système de coordonnées non résolu pour 77 fiches, `quality_pedigree` non systématiquement renseigné, et surtout le statut des licences.

## 8. Figures (2 à 4 suffisent)

| # | Figure | Contenu |
|---|---|---|
| F0 | Déséquilibre simulation / données réelles | nuage de points par article : cellules simulées (abscisse log) contre jeux réels distincts |
| F1 | Architecture de la chaîne | sources → acquisition bibliographique → GROBID → graphe → wiki → contrôle qualité → registre → package |
| F2 | Composition de la banque | familles de sources croisées avec type spatial/spatio-temporel et statut de promotion |
| F3 | Profil du noyau | distribution de N, structure transversale/panel, typologie de la réponse |
| F4 | Dispositif de benchmark | jeu × estimateur × schéma de CV × pli × métrique, puis chaîne de décision de la comparaison |

Le brief wiki signale que des diagrammes existent déjà pour F1 et F4 dans les pages de statut : à adapter, pas à réinventer.

---

## Prérequis avant rédaction, par ordre de criticité

1. **Audit des licences — bloquant pour la soumission.** 131 des 155 jeux promus portent `license_name: unknown`, `license_verified` est faux sur les 289 fiches et `redistribution_allowed` n'est renseigné nulle part. *Scientific Data* exige une déclaration de disponibilité et de conditions de réutilisation. Sans cet audit, la section Data availability ne peut pas être écrite honnêtement.
2. **Décision sur la distribution des données.** Entrepôt public avec DOI et script de récupération, embarquement des jeux redistribuables, ou combinaison des deux. La réponse détermine la rédaction de Data Records et de Data availability.
3. **Version gelée et citable** du dépôt et du registre, à citer dans l'article.
4. **Passe d'évaluation complète et datée** pour citer des taux agrégés de contrôle qualité plutôt qu'un échantillon.
5. **Clarification du champ `formula_status`.** Il vaut `pub` pour 286 fiches sur 289 alors que `formula_pub` vaut `pending` pour 107 d'entre elles ; les deux champs ne mesurent visiblement pas la même chose et je ne veux pas construire un chiffre de Technical Validation sur une sémantique ambiguë.
6. **Écart 161/155.** 161 fiches portent `benchmark_status: ready` mais 155 seulement `package_include: yes` ; à expliquer ou à corriger avant de publier les deux chiffres.

7. **Étude bibliométrique des enjeux situés.** Le corpus actuel ne peut servir que de pilote : sur 142 références postérieures à 2015, 25 seulement relèvent d'une revue méthodologique, le reste étant applicatif — le corpus a été constitué pour trouver des jeux de données, pas pour échantillonner la littérature méthodologique. Une base stratifiée par revue doit être construite pour produire le chiffre publiable.

## Questions ouvertes

- Ordre des auteurs et affiliations.
- *Scientific Data* confirmé, ou repli *Data in Brief* / *Geoscience Data Journal* ?
- Faut-il nommer les 28 estimateurs individuellement, sachant que le package évolue ? Recommandation du brief wiki, que je partage : oui, mais en citant une version gelée.
