# Compte rendu de cadrage du data paper

Date : 16 septembre 2026  
Sources : transcription de la discussion avec l'encadrant et photographie de la note manuscrite.

## Décisions suffisamment claires

1. Le premier manuscrit doit être centré sur **la collecte, la documentation et la mise à disposition de la banque**.
2. L'introduction doit commencer par une petite étude quantitative de la littérature méthodologique : articles proposant ou comparant un estimateur spatial, présence d'un Monte-Carlo, puis nombre de jeux réels utilisés.
3. Une seconde analyse doit situer les ressources existantes : benchmarks tabulaires, éventuellement temporels, banques spatiales de domaine et absence ou rareté d'une infrastructure transversale pour les tâches spatiales et spatio-temporelles.
4. Le manuscrit doit quantifier le caractère dispersé des sources et le travail nécessaire pour transformer ces sources en ressources documentées.
5. L'approche assistée par agents et modèles de langage doit être présentée comme une réponse aux difficultés de collecte et de curation, avec contrôle humain et traces de provenance.
6. Le manuscrit doit organiser ses méthodes en trois blocs : **collecte**, **sous-échantillonnage** et **construction semi-synthétique**.
7. Parce que la partie semi-synthétique est retenue, la partie complète consacrée au package `spatialtidymodels`, aux estimateurs et au benchmark est écartée du data paper pour l'instant.
8. Il faut réunir environ vingt data papers comparables, notamment environnementaux, spatiaux ou spatio-temporels, pour observer les conventions réelles de rédaction et de validation.
9. Une première version cohérente devra ensuite passer par plusieurs lectures de type reviewer, dont au moins une sans le contexte interne du projet.

## Petite méta-analyse demandée

La population visée est constituée d'articles méthodologiques influents en statistique spatiale et en économétrie spatiale qui proposent ou comparent un estimateur et utilisent une étude Monte-Carlo.

Pour chaque article, il faut coder au minimum :

- présence d'une étude Monte-Carlo ;
- nombre de structures de DGP et nombre de cellules paramétriques ;
- présence de données réelles ;
- nombre de sources empiriques distinctes ;
- classe `0`, `1`, `2`, `3–5` ou `>5` jeux réels ;
- rôle des données réelles : illustration, ajustement, comparaison de performance ou validation hors échantillon ;
- noms des jeux récurrents ;
- schéma de validation déclaré.

Quelques articles très cités pourront être mentionnés dans l'introduction. L'inventaire complet et les règles de codage iront en supplément. Le résultat attendu ne doit pas être présupposé : l'affirmation « les articles utilisent peu de données réelles » ne sera écrite qu'après codage.

## Point à ne pas formuler comme un fait acquis

La discussion contient l'expression « il n'y a pas de banque spatiale ». La revue déjà menée montre toutefois que CAMELS-US, LamaH-CE et Caravan sont des banques spatiales solides. La formulation défendable est plus précise : il manque encore une infrastructure **multidomaine** reliant datasets, formules publiées, objets spatiaux, tâches statistiques et conditions d'évaluation sous une interface commune.

## Articulation retenue entre les trois blocs

Le data paper présente une même banque sous trois formes complémentaires :

1. **collecte** : les données réelles rassemblées, documentées et conservées avec leur provenance ;
2. **sous-échantillonnage** : des dérivés contrôlés de la banque, reliés à leur source, destinés notamment aux contraintes de taille ou aux dessins expérimentaux ;
3. **semi-synthétique** : des jeux construits à partir des géométries et covariables réelles afin de disposer d'une vérité connue et de facteurs contrôlables.

Le package `spatialtidymodels`, son inventaire de moteurs et le benchmark comparatif complet ne font pas partie de cette première version. Ils pourront donner lieu à une extension ou à un article séparé.

## Corpus documentaire à préparer

- corpus de la petite méta-analyse spatiale ;
- revue des collections tabulaires et temporelles ;
- environ vingt data papers proches du projet ;
- articles fondateurs de statistique et d'économétrie spatiales nécessaires au cadrage ;
- références citées dans le manuscrit, disponibles localement en PDF et TEI lorsque les droits le permettent.

L'objectif proposé d'environ soixante PDF constitue une borne pratique, pas un quota scientifique.
