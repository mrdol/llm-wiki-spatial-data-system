# Plan du data paper V2 — banque de données spatiales

Date : 16 septembre 2026  
Statut : plan courant après discussion avec l'encadrant.  
Le plan V1 du 18 août est conservé comme document historique.

## 0. Périmètre du premier manuscrit

Le premier article décrit la **constitution, la documentation, le contrôle et la mise à disposition d'une banque multidomaine de données spatiales et spatio-temporelles**, ainsi que deux extensions construites à partir de cette banque : le sous-échantillonnage et les données semi-synthétiques.

Il ne présente pas de classement général des estimateurs. Puisque la partie semi-synthétique est incluse, la description des moteurs, du benchmark complet et des résultats comparatifs de `spatialtidymodels` est entièrement reportée.

Les méthodes suivent trois blocs : **collecte**, **sous-échantillonnage** et **semi-synthétique**. Les dérivés restent reliés à leur source réelle, à leur règle de construction et à leur graine.

## 1. Titre de travail

*A provenance-aware, cross-domain data bank of spatial and spatio-temporal datasets for reproducible statistical research.*

Le mot *benchmark* pourra être réintroduit dans le titre seulement si une couche de tâches gelées est effectivement décrite dans la version soumise.

## 2. Background & Summary

**Avancement au 21 septembre 2026 :** les mouvements 1 et 2 sont rédigés dans `BROUILLON_DATAPAPER_V1_2026-09-21.md`. Le mouvement 1 repose désormais sur 66 articles à DGP paramétrique et 67 textes intégraux convertis en TEI ; le mouvement 2 compare les infrastructures générales et les banques hydrologiques. Les mouvements 3 et 6 attendent la récupération différée des jeux empiriques du corpus, puis un snapshot daté de la banque.

### Mouvement 1 — Déséquilibre entre Monte-Carlo et données réelles

Présenter le rôle des simulations Monte-Carlo dans le développement des estimateurs spatiaux : vérité connue, variation contrôlée de `W`, de la dépendance, du SNR, des distributions et de la taille d'échantillon. Introduire ensuite la question empirique : combien de jeux réels distincts ces travaux utilisent-ils ?

Le paragraphe reposera sur la petite méta-analyse. Il rapportera, sans extrapolation :

- nombre d'articles inclus ;
- médiane et distribution du nombre de jeux réels ;
- part des articles dans les classes `0`, `1`, `2`, `3–5`, `>5` ;
- concentration éventuelle sur quelques jeux canoniques ;
- comparaison descriptive avec le nombre de cellules ou structures de DGP.

Deux ou trois articles influents pourront illustrer le résultat. La table complète ira en supplément.

### Mouvement 2 — Ce qui existe déjà

Comparer les fonctions remplies par :

- les collections tabulaires comme PMLB ;
- les suites de tâches comme OpenML ;
- les harnais comme AMLB ;
- les benchmarks avec shifts ou temps comme TableShift et TabReD ;
- les banques spatiales de domaine comme CAMELS-US, LamaH-CE et Caravan ;
- les éventuelles collections de séries temporelles à ajouter à la revue.

La conclusion ne sera pas « aucune banque spatiale n'existe ». Elle précisera le manque visé : une ressource multidomaine reliant provenance, variables analytiques, formules publiées, géométrie, temps, poids spatiaux et maturité d'utilisation.

### Mouvement 3 — Des sources présentes mais dispersées

Quantifier les voies d'entrée actuelles : packages R/Python, datasets liés à des articles et entrepôts. Présenter le nombre de fiches, les artifacts locaux et les statuts avec un snapshot daté. Montrer pourquoi l'existence de fichiers dispersés ne constitue pas encore une banque utilisable : documentation inégale, rôles Y/X incertains, géométrie ou CRS, temps, `W`, licences, versions et formules.

Toute affirmation sur une taille minimale nécessaire ou sur une puissance statistique insuffisante devra être étayée par un calcul ou remplacée par une formulation prudente sur la diversité et la représentativité.

### Mouvement 4 — Difficultés techniques et curation assistée

Décrire les problèmes à résoudre : découverte, téléchargement, conversion, désambiguïsation article–dataset, extraction de formules, inspection des artifacts, normalisation des métadonnées, maintien de la provenance et contrôle des contradictions.

Présenter l'approche assistée par agents et modèles de langage comme une chaîne sous contrôle humain : corpus → TEI → KG → fiches → audits → registre. Documenter les règles de non-auto-validation et les éléments laissés en révision manuelle.

### Mouvement 5 — Contribution proposée

Annoncer une banque qui :

- couvre plusieurs domaines et supports ;
- relie chaque ressource à ses sources ;
- distingue données, artifacts et éventuelles tâches ;
- documente Y, X, coordonnées, géométrie, temps et `W` ;
- conserve la formule publiée et les adaptations locales ;
- expose les limites de disponibilité, de licence et d'usage.

### Mouvement 6 — Résultats descriptifs annoncés

Résumer les résultats de construction : composition de la banque, couverture documentaire, disponibilité des artifacts, profils spatiaux et temporels, formules résolues, contrôles et cas laissés en attente. Aucun classement d'estimateurs ne figure ici.

### Mouvement 7 — Organisation de l'article

Terminer l'introduction par une phrase présentant Methods, Data Records, Technical Validation, Usage Notes et les déclarations de disponibilité.

## 3. Methods

### 3.1 Petite méta-analyse des pratiques d'évaluation

**Avancement au 21 septembre 2026 :** première rédaction et codage article par article achevés sur 66 articles. Les résultats ont été recalculés et la figure de diversité empirique a été produite. Le double codage indépendant d'un sous-échantillon reste requis avant soumission.

Décrire la population, la stratégie d'échantillonnage, les critères d'inclusion, la période, les règles de comptage et le double codage. Le protocole du 18 août doit être actualisé sur deux points : inclure explicitement les articles influents demandés et remplacer l'ancienne fenêtre arbitraire post-2015 par une stratégie compatible avec cette sélection, ou présenter deux strates séparées.

### 3.2 Périmètre et voies de collecte

Présenter les trois familles : logiciels, publications et entrepôts. Pour chacune : critères d'inclusion, exclusions, unité de catalogage et relation entre source, artifact et fiche.

### 3.3 Acquisition bibliographique et documentaire

Décrire DOI, DataCite, Crossref, OpenAlex, PDF, GROBID/TEI et bibliographies. Préciser comment titres, auteurs, années et identifiants sont vérifiés.

### 3.4 Graphe de connaissances et wiki

Présenter le KG comme couche de preuves structurées et le wiki comme couche d'interprétation validée. Décrire les identifiants et les relations article–dataset–variable–formule–méthode–artifact.

### 3.5 Schéma de métadonnées

Présenter dans un tableau les blocs couvrant identité, source, unité statistique, Y/X, formule, support spatial, temps, `W`, transformations, artifact, qualité, licence, statut et limites.

### 3.6 Curation assistée et contrôle humain

Décrire extraction automatique, contrôles structurels, comparaison aux sources, révision humaine, journalisation et traitement de `pending`, `manual_review` et `no`.

### 3.7 Fabrication des Data Records

Décrire conversion vers les formats finaux, conservation des données brutes, harmonisation minimale, liens parent–dérivé et sous-échantillonnage éventuel. Toute réduction doit conserver la source parent, la graine, la règle d'échantillonnage et la population cible.

### 3.8 Construction semi-synthétique

Présenter le principe commun : conserver des sites, supports et covariables réels, estimer ou spécifier une fonction génératrice, puis simuler une réponse dont la vérité est connue. Décrire les facteurs contrôlés, les graines, les cibles latentes, la calibration et les contrôles de fidélité. S1–S4 doivent être regroupés selon leur rôle scientifique et présentés avec leurs limites ; ils ne doivent pas devenir un classement des estimateurs.

### 3.9 Génération du registre et audit reproductible

Décrire l'export vers le registre, le KG et `audit_datapaper_repo.py`. Fixer une version et un snapshot pour les chiffres du manuscrit.

## 4. Data Records

Séparer explicitement :

1. les fiches cataloguées ;
2. les artifacts locaux ;
3. les Data Records distribuables ;
4. les sous-échantillons dérivés ;
5. les Data Records semi-synthétiques ;
6. les entrées pouvant ultérieurement alimenter une tâche de benchmark.

Les chiffres courants servent au travail, mais seront regelés pour la soumission : 381 fiches et 381 entrées de registre dans le snapshot du 16 septembre, 260 `yes`, 65 `manual_review`, 56 `no`, et 343 `formula_used` différents de `pending`. Ces nombres ne sont pas interchangeables.

### Tableaux prévus

| Tableau | Contenu |
|---|---|
| T1 | Schéma des métadonnées et valeurs autorisées |
| T2 | Composition par famille de source et domaine |
| T3 | Supports spatiaux et structures temporelles |
| T4 | Couverture de Y, X, formules, géométrie, CRS, temps et `W` |
| T5 | Artifacts, modes d'accès, licences et redistribution |
| T6 | États de maturité et raisons de non-inclusion |
| T7 | Dérivés par sous-échantillonnage et lien à la source parent |
| T8 | Scénarios semi-synthétiques, facteurs, vérités connues et limites |

## 5. Technical Validation

Valider la ressource plutôt que les performances d'estimateurs :

1. structure des fiches et du registre ;
2. alignement des identifiants fiche–registre ;
3. chargement des artifacts ;
4. cohérence entre variables déclarées et fichiers ;
5. fidélité des formules, auteurs, DOI et méthodes pour un échantillon vérifié ;
6. cohérence des profils spatial/temporel et des liens parent–dérivé ;
7. reproductibilité de la génération du registre et de l'audit ;
8. accord extraction automatique–codage humain sur un sous-échantillon.
9. reproductibilité des sous-échantillons et des constructions semi-synthétiques à partir des graines et sources déclarées.

## 6. Usage Notes

- Une fiche documentée n'est pas automatiquement un Data Record redistribuable.
- Une entrée `yes` n'est pas une exécution de benchmark.
- Les sous-échantillons et coupes ne sont pas des sources indépendantes.
- Le choix d'une formule, de `W` ou d'une cible doit rester traçable.
- Les panels parents doivent être conservés.
- Les données semi-synthétiques doivent être distinguées sans ambiguïté des observations réelles.
- Les licences et restrictions des sources prévalent sur la présence locale d'un fichier.

## 7. Data availability et Code availability

Décrire séparément :

- les données redistribuées ;
- les données récupérables par script depuis leur source ;
- les données seulement documentées ;
- le registre et les métadonnées ;
- le code de collecte, conversion et audit ;
- la version gelée du dépôt et son identifiant persistant.

## 8. Limites

- profondeur documentaire inégale ;
- formules ou `W` originaux parfois irrécupérables ;
- licences et redistribution à vérifier ;
- biais de sélection vers les ressources trouvables et accessibles ;
- curation assistée susceptible d'erreurs malgré les contrôles ;
- couverture multidomaine hétérogène ;
- absence, dans ce premier papier, d'une comparaison complète des estimateurs.
- fidélité limitée de certains générateurs semi-synthétiques et représentativité encore restreinte des sources testées.

## 9. Figures

| Figure | Contenu |
|---|---|
| F1 | Monte-Carlo versus nombre de jeux réels par article |
| F2 | Panorama : collections tabulaires, temporelles et spatiales |
| F3 | Chaîne sources → corpus → TEI → KG → fiches → Data Records |
| F4 | Composition de la banque et états de maturité |
| F5 | Exemple de provenance complète d'un dataset jusqu'à la formule |
| F6 | Relation entre donnée collectée, sous-échantillon et dérivé semi-synthétique |

## 10. Suppléments

- grille et résultats de la petite méta-analyse ;
- liste des articles inclus et raisons d'exclusion ;
- inventaire comparatif des banques ;
- schéma complet des métadonnées ;
- dictionnaire du registre ;
- liste des Data Records et licences ;
- journal des contrôles et erreurs connues.
- paramètres, graines et résultats de validation des constructions semi-synthétiques.

## 11. Travaux préalables à la première version

### Priorité A — indispensable

1. **Achevé :** corpus fixé à 66 articles quantitatifs, quatre lignes de traçabilité hors dénominateur et 67 TEI tous reliés à une décision de codage ou de criblage ;
2. auditer les licences et la stratégie de redistribution ;
3. définir ce qui constitue un Data Record de la première version ;
4. générer les tableaux descriptifs depuis un snapshot gelé ;
5. constituer une bibliographie maître ;
6. sélectionner et lire environ vingt data papers comparables.
7. décider quels résultats S1–S4 sont assez mûrs pour devenir des Data Records ou validations du manuscrit.
8. avant le snapshot final, rechercher les jeux empiriques employés dans les 67 textes intégraux, les dédupliquer au niveau de la source, vérifier leur présence dans la banque, leur version, leur licence et leur possibilité de redistribution, puis intégrer seulement les ressources dont la provenance est établie.

### Priorité B — nécessaire avant soumission

1. mesurer la fidélité de l'extraction automatique sur un échantillon humainement codé ;
2. vérifier la cohérence KG–fiches–registre ;
3. fixer le dépôt public, la version et le DOI ;
4. préparer les suppléments et manifests.

### Reporté

- classement des estimateurs ;
- description exhaustive des moteurs du package ;
- benchmark comparatif `spatialtidymodels` ;
- moteur panel spatial ;
- tableau de bord.

## 12. Points à confirmer avec l'encadrant

1. revue cible et gabarit exact ;
2. stratégie de sélection des articles « les plus cités » et période de la méta-analyse ;
3. disponibilité d'un second codeur ;
4. définition précise des familles et tailles de sous-échantillons publiées ;
5. niveau de détail et résultats S1–S4 retenus dans le data paper ;
6. seuil de maturité définissant la première version publiée ;
7. place exacte du mot *benchmark* dans le titre et les revendications.
