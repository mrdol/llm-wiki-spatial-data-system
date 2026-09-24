# Revue — jeux de données proposés pour benchmark (data paper)

**Statut : premier passage exploratoire terminé, onze articles complémentaires lus intégralement et comparaison approfondie ajoutée le 14 septembre 2026.**

## Cadrage du 8 septembre

Le HTML distingue catalogue, tâches admises, expériences exécutées et extension
plasmode. Le pilote ne modifie aucune admission. La place des simulations dans
le datapaper reste à discuter. Les affirmations d’exclusivité ont été révisées le 14 septembre : CAMELS-US, LamaH-CE et Caravan documentent déjà très précisément certaines dimensions spatiales.

## Contenu

- [`revue_jeux_donnees_benchmark.html`](revue_jeux_donnees_benchmark.html) — le document complet (source de l'artefact publié).
- [`lecture_integrale_et_comparaison_2026-09-14.md`](lecture_integrale_et_comparaison_2026-09-14.md) — lecture des onze PDF, comparaison des suites, exigences documentaires et comparaison hydrologique.
- [`synthese_introduction_discussion_datapaper_2026-09-14.md`](synthese_introduction_discussion_datapaper_2026-09-14.md) — texte en anglais directement réutilisable dans l'introduction et la discussion.
- [`revue_jeux_donnees_benchmark.bib`](revue_jeux_donnees_benchmark.bib) — 11 références contrôlées, avec liens vers les PDF locaux.

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
- Angle différenciant révisé : des dépôts de domaine documentent déjà très bien les supports, variables et incertitudes spatiales. Notre apport potentiel est leur articulation, sur plusieurs domaines, avec la provenance jusqu'à la formule publiée, la représentation explicite de W et des panels, et une séparation machine-lisible entre dataset, tâche, suite et run.

## Étapes réalisées le 14 septembre 2026

- [x] Lecture intégrale des 11 articles complémentaires.
- [x] Comparaison OpenML Suites, PMLB, AMLB, TableShift, TabZilla et TabReD.
- [x] Traduction de Datasheets et FAIR en exigences documentaires pour le data paper.
- [x] Comparaison détaillée de CAMELS-US, LamaH-CE et Caravan avec la banque spatiale.
- [x] Révision de l'affirmation d'exclusivité et définition précise de la contribution.
- [x] Synthèse réutilisable pour l'introduction et la discussion du data paper.

## Prochaines étapes

- [ ] Transformer les exigences documentaires en audit machine-lisible des fiches existantes.
- [ ] Définir formellement `Dataset`, `BenchmarkTask`, `BenchmarkSuite` et `BenchmarkRun` dans le schéma du projet.
- [ ] Angle non creusé : littérature « stat pure » sur les jeux canoniques (iris, mtcars, diabetes...) et suites de benchmark vision/NLP (ImageNet, GLUE) pour d'éventuelles leçons de documentation transposables.
- [ ] Vérifier si Kaggle a un jeu spatial avec dépendance qui nous aurait échappé (recherche ciblée pas encore faite).


## Collecte complémentaire du 9 septembre 2026

- [Articles retenus, PDF disponibles et téléchargements manuels](articles_complementaires_2026-09-09/README.md).
- 11 nouveaux PDF disponibles sur 11 articles sélectionnés. Lecture intégrale et bibliographie terminées.

## Bibliographie vérifiée — 9 septembre 2026

[revue_jeux_donnees_benchmark.bib](revue_jeux_donnees_benchmark.bib) : **11 références**, produites avec Biblio_from_pdf après contrôle des premières pages et correction des métadonnées. Les liens BibDesk pointent vers les PDF conservés dans cette revue. Les prépublications sont signalées dans les notices. Compilation LaTeX/BibTeX et liens PDF validés.
