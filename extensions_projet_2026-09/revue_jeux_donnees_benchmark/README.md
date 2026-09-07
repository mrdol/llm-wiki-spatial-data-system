# Revue — jeux de données proposés pour benchmark (data paper)

**Statut : premier passage exploratoire terminé (recherche web, une session, 7 sept.).**

## Contenu

- [`revue_jeux_donnees_benchmark.html`](revue_jeux_donnees_benchmark.html) — le document complet (source de l'artefact publié).
- `revue_jeux_donnees_benchmark.bib` — à ajouter : généré via biblio from pdf à partir des PDF des articles retenus, une fois la lecture approfondie faite.

## Objectif

Recenser les articles dont l'objet était de proposer/introduire des jeux de données de référence pour du benchmark en machine learning, spatial, temporel et économétrie — format tabulaire simple (Y, X), pas de données complexes (imagerie, etc.).

## Résumé

Repérage des « incontournables » par domaine :
- **Machine learning généraliste** : UCI Machine Learning Repository, OpenML (Vanschoren et al. 2013), PMLB (Olson et al. 2017), le protocole de benchmark tabulaire de Grinsztajn et al. (2022), et *Retiring Adult* (Ding et al. 2021, NeurIPS) — une critique méthodologique fondatrice qui reconstruit un standard vieux de 30 ans depuis ses sources.
- **Spatial** : Columbus crime (Anselin 1988), Boston Housing (Harrison & Rubinfeld 1978), l'écosystème `spData`/*Applied Spatial Data Analysis with R* (Bivand et al.), et Ames Housing (De Cock 2011) — créé explicitement comme remplaçant moderne de Boston Housing.
- **Temporel** : archives UCR (Dau et al. 2019) et UEA (Bagnall et al. 2018), Monash Time Series Forecasting Archive (Godahewa et al. 2021), compétitions M4/M5 (Makridakis).
- **Économétrie** : politique de dépôt obligatoire du *Journal of Applied Econometrics* (depuis 1994), package `wooldridge` (115 jeux documentés du manuel de référence).

**Fil rouge trouvé, pas anticipé au départ** : deux cas documentés de benchmark historique retiré/remplacé une fois ses défauts révélés — Boston Housing → Ames Housing (variable encodant une hypothèse raciste, retiré de scikit-learn en 2022) et UCI Adult → `folktables` (défauts de représentativité, Ding et al. 2021). Dans les deux cas, le remplaçant gagne non pas en étant plus gros, mais en étant **mieux sourcé et documenté** — argument directement réutilisable pour justifier notre propre catalogue face aux jeux spatiaux « historiques ».

**Sur Kaggle** : oui pour les jeux généralistes/pédagogiques (Ames = compétition Kaggle parmi les plus populaires, Boston très présent malgré son retrait de scikit-learn, M4 déposé par des tiers) ; peu ou pas pour les archives spécialisées (UCR/UEA, Monash, OpenML) ni pour les jeux spatiaux avec dépendance (Columbus, Georgia, spData) — cohérent avec une audience académique plutôt que grand public pour ce dernier groupe.

## Recommandations pour le data paper

- Modèles à suivre : OpenML (suites versionnées + résultats de référence) et Monash Archive (baselines publiées avec chaque jeu).
- Argument de légitimité : le précédent Boston→Ames / Adult→folktables montre que la communauté accepte qu'un catalogue mieux documenté remplace des classiques, sans besoin d'être plus gros.
- Angle différenciant : aucun dépôt généraliste ne gère la dimension spatiale (coordonnées, W, dépendance) ; les dépôts spatiaux existants (spData) sont anciens et peu standardisés côté métadonnées/provenance — c'est l'angle vide à occuper.

## Prochaines étapes

- [ ] Lecture complète des articles clés avant citation dans le data paper (en particulier Ding et al. 2021, Grinsztajn et al. 2022, De Cock 2011).
- [ ] Générer `revue_jeux_donnees_benchmark.bib` via biblio from pdf.
- [ ] Angle non creusé : littérature « stat pure » sur les jeux canoniques (iris, mtcars, diabetes...) et suites de benchmark vision/NLP (ImageNet, GLUE) pour d'éventuelles leçons de documentation transposables.
- [ ] Vérifier si Kaggle a un jeu spatial avec dépendance qui nous aurait échappé (recherche ciblée pas encore faite).
