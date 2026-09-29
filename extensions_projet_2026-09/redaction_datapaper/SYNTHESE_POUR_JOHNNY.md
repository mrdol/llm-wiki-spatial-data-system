# Synthèse courte pour se mettre au même niveau d’information

## Ce que le projet contient maintenant

La banque compte **392 fiches datasets** et le registre du package compte **392 entrées**. Le graphe de connaissances relie les datasets, articles, variables, formules et méthodes à travers **80653 nœuds** et **108366 relations**. Ces nombres décrivent des couches différentes et ne doivent pas être additionnés.

Les identifiants des fiches et du registre sont actuellement alignés à **392/392**, sans désaccord de champ non vide détecté. Le registre marque **278 jeux `yes`**, mais ce chiffre représente une décision de registre et non le nombre de benchmarks effectivement exécutés. Les anciens chiffres doivent être associés à leur date et à leur périmètre plutôt que repris comme des totaux actuels.

Le package `spatialtidymodels` est une **extension en développement**. Son registre décrit les jeux disponibles ou évaluables ; il ne signifie pas que tous ont été exécutés. Les panels parents restent distincts de leurs coupes transversales et nécessitent des moteurs de panel spatial séparés.

Deux revues récentes orientent la rédaction :

1. la revue des banques de benchmark situe la contribution face à OpenML, PMLB, AMLB, TableShift, TabZilla, TabReD, CAMELS, LamaH-CE et Caravan ;
2. la revue semi-synthétique étudie les plasmodes et quatre expériences internes S1–S4. S4 est le plus proche de la demande consistant à faire varier `lambda`, `f`, `g` et `u`.

## Ce qui est prêt pour la rédaction

- le positionnement scientifique de la banque ;
- une proposition en anglais pour l’introduction et la discussion ;
- les exigences documentaires inspirées de Datasheets et FAIR ;
- la description des pipelines fiches–KG–wiki–package ;
- les limites des pilotes semi-synthétiques ;
- deux bibliographies thématiques.

## Ce qui n’est pas encore harmonisé

- les brouillons de juillet–août utilisent des inventaires anciens ;
- il n’existe pas encore de manuscrit maître actualisé ;
- les chiffres descriptifs doivent être générés automatiquement au moment de chaque version ;
- les deux `.bib` thématiques ne forment pas encore une bibliographie maître ;
- les affirmations du manuscrit doivent être reliées à une source canonique et à une date de snapshot.

## Décision pratique

Le prochain document de référence doit être un manuscrit maître créé dans ce dossier. Les anciens brouillons deviennent des sources historiques. Toute nouvelle statistique du data paper doit provenir de l’audit JSON, du registre ou d’une requête KG enregistrée, jamais d’un nombre recopié manuellement.
