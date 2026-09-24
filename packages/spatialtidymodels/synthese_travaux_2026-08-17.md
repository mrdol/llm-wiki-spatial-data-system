# Synthèse des travaux — Pipeline datasets et package spatialtidymodels

**Période couverte :** session de travail du 17 août 2026
**Périmètre :** pipeline d'ingestion de jeux de données spatiaux (`llm-wiki-karpathy`) et package R `spatialtidymodels`

---

## 1. Contexte

Le projet vise à constituer une banque de jeux de données spatiaux et spatio-temporels documentés, validés et directement utilisables pour comparer des estimateurs de régression spatiale (SAR, SEM, GWR, boosting spatial, etc.). Chaque jeu de données est décrit par une fiche structurée (variable réponse, covariables, formule, provenance, structure spatiale) et, lorsqu'il est jugé prêt, promu dans le package R `spatialtidymodels`, qui expose les estimateurs et l'infrastructure de benchmark.

---

## 2. État actuel du catalogue

| Indicateur | Valeur |
|---|---|
| Fiches datasets totales (wiki) | 289 |
| dont fiches issues de papiers scientifiques | 153 |
| Candidats consolidés dans le pipeline papiers (curation high/medium/low) | 431 |
| Datasets `package_include = "yes"` (prêts, promus dans le package) | 155 |
| Datasets `package_include = "manual_review"` | 53 |
| Datasets `package_include = "no"` | 81 |
| Datasets à variable réponse **continue** parmi les 155 promus | 109 (70 %) |
| — dont réponse binaire | 21 |
| — dont réponse de type comptage (*count*) | 15 |
| — dont réponse de type taux (*rate*) | 6 |
| — dont réponse catégorielle | 4 |

En début de session, le catalogue comptait 123 datasets `package_include = "yes"` ; il en compte désormais 155 (+32), essentiellement du fait du cas d'étude décrit en section 4.

---

## 3. Travaux réalisés

### 3.1 Poursuite du pipeline d'ingestion de datasets papiers

- Recherche bibliographique approfondie menée sur 8 datasets dont la formule n'était pas encore confirmée par une publication (groupes B/C d'un audit antérieur), avec vérification directe des papiers sources (accès libre, PMC, arXiv, thèses avec DOI officiel) :
  - `colombia_leptospirosis_risk` : papier identifié avec un haut degré de confiance (correspondance exacte de 180 mois de données) ; ajout de covariables climatiques réelles (température et précipitations, normales climatiques CHELSA V2.1, extraites par moyenne zonale sans téléchargement du raster mondial complet).
  - `portugal_covid_municipal` : papier pertinent identifié (Barbosa et al. 2022).
  - `wildebeest_movement_env`, `antarctic_biodiversity_completeness`, `dragonfly_diversity_europe`, `spatial_confounding_diabetes`, `pollinator_urbanization_meta` : formules revues et corrigées après lecture directe des papiers.
- 14 datasets du groupe A promus directement à `package_include = "yes"` après validation.
- 22 nouvelles fiches construites lors d'un lot ultérieur, avec correction du bug de détection de dates (fiches Ethiopie), correction d'un bug de copier-coller de description (`early_season_biomass`), correction de deux formules (`maine_baseflow`, `midwest_crop_yield`), correction de la structure panel/temporelle du chargeur `elections`, et application du filtre de valeurs manquantes du papier source pour `plant_invasion_fia`.

### 3.2 Correction méthodologique — covariable non indépendante

Lors de la relecture de la fiche `colombia_leptospirosis_risk`, une covariable `p_value` (issue d'un test de Mann-Kendall) avait été incluse comme variable explicative. Or la p-value d'un test statistique mesure l'incertitude sur la statistique elle-même — ce n'est pas une variable explicative indépendante. Vérification empirique de la corrélation (r = 0,70 entre `MannKendall` et `p_value`, confirmant leur non-indépendance) avant retrait de la covariable. Une autre covariable candidate (`emerging_trend`) a en revanche été conservée après vérification qu'elle n'était pas simplement redondante avec le signe de `MannKendall` (35 % de désaccord observé sur les données réelles). Il s'agit du même type d'erreur qu'une circularité déjà corrigée antérieurement sur `antarctic_biodiversity_completeness` (une covariable mathématiquement dérivée de la variable réponse elle-même).

### 3.3 Documentation de la structure panel — distinction N_total / N_spatial

Un point méthodologique a été clarifié et documenté systématiquement : dans un jeu de données panel (plusieurs observations par unité spatiale au fil du temps), le champ « N observations » habituellement rapporté correspond au nombre total de lignes du panel, **pas** au nombre d'unités spatiales distinctes. Cette distinction est critique pour la construction d'une matrice de voisinage spatial (W) utilisée par les estimateurs SAR/GWR/BYM/CAR : construire W sur le nombre total de lignes plutôt que sur les unités spatiales distinctes produirait des coordonnées dupliquées et un calcul de voisinage dégénéré.

Un audit direct de 51 fiches structurées en panel a été effectué (lecture des `.rds` finaux, comptage des géométries distinctes et de la répartition du nombre d'observations par unité spatiale). Une note de clarification a été ajoutée à chacune de ces 51 fiches : 46 panels réels documentés avec leur N_spatial réel et leur degré d'équilibre temporel, et 5 fiches classées à tort comme panels mais dont la vérification a montré une absence totale de répétition géométrique (donc pas des panels au sens statistique).

### 3.4 Nettoyage du générateur de fiches — suppression d'une duplication de texte

Le générateur de fiches papiers (`generate_fiches_papers.R`) recopiait le même paragraphe de justification/citation (parfois plusieurs centaines de mots) jusqu'à 6 fois dans une même fiche (section « Formule niveau publication », deux notes de statut, deux entrées YAML de formules candidates, bloc YAML `modeling_evidence`). Le générateur a été corrigé pour ne conserver le texte complet qu'à deux emplacements canoniques (un emplacement en prose, un emplacement structuré en YAML), les quatre autres emplacements pointant désormais vers ces deux références plutôt que de dupliquer le texte. Une passe rétroactive purement textuelle (sans repasser par le générateur, pour ne pas perdre les notes N/T ajoutées à la main ni réinitialiser les dates de création) a nettoyé 98 des 121 fiches existantes concernées.

### 3.5 Cas d'étude — découpage temporel d'un grand dataset (`korea_hedonic_housing`)

Objectif : augmenter le nombre de jeux de données directement utilisables pour le benchmark sans fabriquer de données ni compromettre la validité spatiale ou la formule déjà validée.

Le dataset `korea_hedonic_housing` (178 719 transactions immobilières réelles, 4 villes coréennes, 1969–2019, 5 395 localisations distinctes) a été découpé en 32 sous-jeux de données : 31 sous-ensembles annuels (1989–2019, chacun conservant la totalité des localisations distinctes de son année, avec entre 57 et 372 localisations distinctes et 1 810 à 9 261 transactions) et un sous-ensemble regroupant les années clairsemées 1969–1988 (2 à 69 localisations distinctes par année, jugées individuellement trop pauvres). Chaque sous-ensemble conserve exactement la même formule que le dataset d'origine (`Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance`), aucune des covariables n'étant l'année elle-même.

Points techniques notables :
- Un bug réel du package `sf` a été identifié et contourné : le sous-échantillonnage direct de lignes sur cet objet particulier dégradait silencieusement les colonnes de géométrie en simples listes (perte de la classe `sfc`). Contournement par passage en `data.frame` intermédiaire puis reconstruction explicite via `st_as_sf()`.
- Une lacune préexistante dans le graphe de connaissances a été découverte et corrigée à la source : le papier source (Song, Ahn, An & Jang 2021, *Data in Brief*, DOI confirmé) avait été identifié et cité dans le générateur dès une session antérieure, mais jamais reporté dans l'enregistrement du graphe de connaissances correspondant — ce qui faisait échouer la vérification automatique de cohérence sur les 33 fiches concernées. Corrigé en un seul endroit plutôt que documenté comme défaut récurrent.
- Les 32 nouvelles fiches ont été promues directement à `package_include = "yes"`, en héritant de la formule et de la provenance déjà validées du dataset parent.
- Validation structurelle automatique (Tier 1) : 0 échec sur les 33 fiches concernées (parent + 32 découpes). Vérificateur de cohérence inter-blocs : 0 problème détecté.

### 3.6 Documentation

- README principal et README du package `spatialtidymodels` mis à jour avec les chiffres actuels du catalogue.
- Ajout d'une section documentant honnêtement un écart identifié : le registre JSON du package expose 155 datasets prêts, mais seuls 7 sont physiquement embarqués comme objets R natifs du package (reliquat d'un script de bootstrap non étendu depuis sa création) — les 148 autres restent utilisables uniquement depuis le dépôt source. Point identifié comme bloquant pour une éventuelle publication publique du package, volontairement non traité à ce stade (hors périmètre de cette session).

> **Mise à jour du 2026-08-18** : ce dernier point a été partiellement traité. 9 datasets papier supplémentaires (cross-sectionnels, formule confirmée) ont été embarqués selon le même mécanisme, portant le total à 16 datasets physiquement natifs sur les 155 prêts. Les candidats panel restants (`paper_gwqlasso_*`, `paper_groundfish_cpue`, `paper_hiv_southern_africa`, `paper_midwest_crop_yield`) ont été volontairement laissés de côté pour une vague ultérieure. Voir le README du package pour la liste à jour.

### 3.7 Package `spatialtidymodels` — nouvelle couche de comparaison d'estimateurs

Objectif : permettre de répondre systématiquement à la question « une nouvelle variante d'un estimateur de référence apporte-t-elle réellement une amélioration, sur un grand nombre de jeux de données ? ».

**Moteur d'orchestration** (`benchmark_spatial_suite()`) : exécute plusieurs estimateurs sur plusieurs jeux de données et plusieurs schémas de validation croisée en une seule opération, à partir de simples noms de datasets enregistrés dans le catalogue du package.

**Moteur de comparaison** (`compare_estimator_variant()` et `comparison_rules()`) : calcule, pour chaque paire (dataset, schéma de validation), l'écart relatif entre un estimateur candidat et un estimateur de référence sur une métrique principale (RMSE par défaut) et des métriques secondaires (MAE, autocorrélation résiduelle de Moran, temps de calcul). Chaque cas est classé victoire/égalité/défaite par rapport à une zone d'équivalence configurable, afin qu'une amélioration de 0,001 % ne soit pas comptée comme une victoire. Le verdict final (`SUPERIOR` / `EQUIVALENT` / `INFERIOR` / `UNSTABLE` / `INSUFFICIENT_EVIDENCE`) ne repose pas uniquement sur un seuil de taux de victoire : il exige par défaut la significativité d'un test de Wilcoxon signé sur les écarts (référence méthodologique standard pour ce type de comparaison — Demšar, 2006, *Journal of Machine Learning Research*), ainsi qu'un intervalle de confiance de Wilson sur le taux de victoire et un garde-fou dédié si le taux d'échec d'ajustement du candidat augmente trop, même lorsque celui-ci gagne en précision.

Cette couche a été délibérément conçue indépendamment de toute interface graphique : la logique de décision réside entièrement dans ces fonctions R, consultables et reproductibles en console, pour qu'un futur tableau de bord se contente d'afficher le résultat sans jamais recalculer le verdict autrement.

Validation : 24 tests unitaires (couvrant chacun des 5 verdicts possibles ainsi que la gestion des erreurs) et un test de bout en bout sur de vrais jeux de données du catalogue, qui a directement confirmé le comportement recherché : avec seulement 4 cas disponibles, le verdict est resté prudemment `EQUIVALENT` plutôt que `INFERIOR`, malgré 4 défaites sur 4, faute de significativité statistique suffisante — illustrant que le système évite de sur-interpréter un échantillon trop restreint.

### 3.8 Package `spatialtidymodels` — API d'extension pour un nouvel estimateur

Répond directement à la question initiale posée en amont de ces travaux : comment un chercheur ayant développé sa propre variante d'un estimateur peut-il la tester dans ce cadre ?

`register_spatial_estimator()` permet d'enregistrer un estimateur personnalisé en ne fournissant que deux fonctions (une fonction d'ajustement et une fonction de prédiction), sans modifier le code interne du package. L'estimateur enregistré apparaît alors automatiquement dans le catalogue des estimateurs disponibles et peut être utilisé exactement comme un estimateur intégré au package, aussi bien dans le moteur de benchmark que dans le moteur de comparaison décrit ci-dessus.

Validation : 7 tests unitaires, incluant un test de bout en bout réel où un estimateur enregistré (une régression linéaire simple encapsulée selon le contrat attendu) reproduit exactement le RMSE de la route de régression déjà intégrée au package, confirmant l'exactitude du mécanisme de délégation.

**Bilan des tests du package :** 99 tests automatisés, 0 échec, sur l'ensemble de la suite (fonctionnalités existantes comprises).

---

## 4. Corrections techniques notables

Au-delà des corrections méthodologiques déjà mentionnées, plusieurs anomalies techniques ont été identifiées et corrigées au cours de ces travaux :

- Un bug affectant le validateur structurel automatique du wiki, qui ne reconnaissait pas le libellé de champ utilisé spécifiquement par les fiches issues de papiers scientifiques (faisant échouer à tort la quasi-totalité de ces fiches sur un critère pourtant renseigné).
- Deux fiches de rapport auto-générées non conformes au schéma de métadonnées requis, faisant échouer la validation avant tout commit.
- Le bug `sf` mentionné en section 3.5.
- Une lacune de traçabilité bibliographique (section 3.5) corrigée à la source plutôt que contournée fiche par fiche.

---

## 5. Chiffres clés — synthèse

| Élément | Chiffre |
|---|---|
| Nouvelles fiches datasets créées ce jour | 32 (découpage temporel) |
| Fiches ayant reçu une note de clarification N_spatial/N_total | 51 |
| Fiches nettoyées d'une duplication de texte | 98 |
| Fiches papiers corrigées (formule, description, structure) sur des lots antérieurs | 22 + corrections ciblées sur ~8 datasets supplémentaires |
| Datasets promus `package_include = "yes"` ce jour | +32 (123 → 155) |
| Nouvelles fonctions publiques ajoutées au package R | 6 (`benchmark_spatial_suite`, `compare_estimator_variant`, `comparison_rules`, `register_spatial_estimator`, `unregister_spatial_estimator`, `registered_spatial_estimators`) |
| Nouveaux tests unitaires ajoutés au package | 31 (24 + 7) |
| Total tests du package après ces travaux | 99, 0 échec |
| Commits git réalisés | 13 |

---

## 6. Travaux restants identifiés

- **Tableau de bord Shiny** (non commencé) : visualisation des résultats de benchmark (indicateurs clés, comparaison RMSE relative entre estimateurs, résumé des échecs d'ajustement), puis une page dédiée à la comparaison référence/variante consommant directement les fonctions décrites en 3.7.
- **Analyse par sous-groupe** (non commencée) : déterminer dans quelles conditions (autocorrélation spatiale de Y, taille d'échantillon, type de géométrie) une variante l'emporte plutôt que de se limiter à un verdict global.
- **Mise en conformité CRAN** (volontairement mise de côté) : quatre appels à des fonctions internes du package `parsnip` à corriger (une API publique équivalente existe désormais), fichier `.Rbuildignore` à créer, migration de la gestion du fichier `NAMESPACE` vers une génération automatique, correction d'un avertissement lié à l'encodage d'un des jeux de données embarqués, et surtout la question de la distribution des 155 datasets prêts au-delà du dépôt source (seuls 7 sont aujourd'hui embarqués nativement dans le package).
- Poursuite de l'examen de 6 autres datasets volumineux identifiés comme candidats potentiels à un découpage similaire à celui de `korea_hedonic_housing`, non encore vérifiés.
