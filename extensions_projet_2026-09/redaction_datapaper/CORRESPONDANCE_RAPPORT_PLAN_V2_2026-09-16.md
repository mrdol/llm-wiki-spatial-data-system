# Correspondance entre le rapport de stage et le plan du data paper V2

Date : 16 septembre 2026  
Rapport examiné : `Mémoire/Rapport de stage/DOLIVEIRAjohnny_internshipreportM2.tex` et sa version PDF de 45 pages.  
Plan de référence : `PLAN_DATAPAPER_V2_2026-09-16.md`.

## Règle d'utilisation

Le rapport de stage est une **aide d'orientation**. Il permet de retrouver l'histoire du projet, les choix techniques déjà envisagés, le vocabulaire employé et des exemples à vérifier. Il ne constitue ni la base rédactionnelle ni la source probante du data paper.

Pour le manuscrit, l'ordre de preuve est le suivant :

1. articles et données d'origine, documentation des packages et dépôts sources ;
2. état actuel du dépôt : scripts, artifacts, fiches, registre, KG et audit gelé ;
3. revues bibliographiques de septembre et protocoles méthodologiques validés ;
4. rapport de stage, uniquement comme index vers les éléments à contrôler.

Le texte du rapport ne sera donc pas repris tel quel. Ses chiffres, formules, statuts, exemples et descriptions de pipeline devront être confirmés dans une source de rang supérieur avant toute utilisation.

## Tableau de correspondance

| Partie du plan V2 | Apport possible du rapport | Niveau d'utilisation | Source à employer dans le data paper | Travail restant |
|---|---|---|---|---|
| **0. Périmètre** | Le rapport explique l'origine de la banque et son lien initial avec un banc d'essai. | **Contexte historique seulement.** Son périmètre associe banque et `spatialtidymodels`, alors que le V2 retient collecte, sous-échantillonnage et semi-synthétique. | Décisions du point d'encadrement et plan V2. | Maintenir l'exclusion du package, du benchmark comparatif et du tableau de bord. |
| **2. Mouvement 1 — Monte-Carlo et données réelles** | L'introduction distingue théorie, simulations et cas empiriques et fournit des pistes bibliographiques. | **Repère conceptuel.** L'affirmation sur le petit nombre de jeux réels n'est pas démontrée dans le rapport. | Articles originaux et résultats de la petite méta-analyse. | Produire la méta-analyse avant de rédiger les résultats chiffrés de ce mouvement. |
| **2. Mouvement 2 — Ressources existantes** | Le rapport cite PMLB et la littérature générale sur les benchmarks. | **Très incomplet.** Il précède la comparaison avec OpenML Suites, AMLB, TableShift, TabZilla, TabReD, CAMELS, LamaH-CE et Caravan. | Revue des jeux de données de benchmark et articles originaux correspondants. | Ajouter les collections temporelles pertinentes et stabiliser la comparaison fonction par fonction. |
| **2. Mouvement 3 — Sources dispersées** | Les trois voies historiques sont décrites : packages R/Python, dépôts liés à des publications et parcours partant des articles. | **Bonne carte de lecture**, mais les effectifs et statuts sont périmés. | Scripts de collecte actuels, fiches, registre, KG et snapshot daté. | Recalculer la composition au moment du gel du manuscrit. |
| **2. Mouvement 4 — Difficultés et curation assistée** | Le rapport documente téléchargement, dédoublonnage, TEI, erreurs silencieuses, contrôles humains et limites d'accès. | **Inventaire de cas à vérifier.** Les rôles exacts des agents et les seuils de l'ancien pipeline d'évaluation peuvent avoir changé. | Code actuel, journaux d'audit, règles du dépôt et échantillon contrôlé humainement. | Décrire uniquement les contrôles effectivement reproductibles dans la version publiée. |
| **2. Mouvement 5 — Contribution** | Le rapport motive une ressource documentée reliant provenance, variables, formule et structure spatiale. | **Utile pour clarifier l'intention**, mais trop orienté vers le choix d'estimateurs. | Schéma actuel de métadonnées et comparaison avec les dépôts existants. | Formuler la contribution autour de la provenance, des supports, du temps, de `W`, des formules et des dérivés. |
| **2. Mouvement 6 — Résultats descriptifs** | Le rapport contient un ancien tableau de composition et des exemples de datasets. | **À ne pas réutiliser comme résultats.** Les valeurs 291/289, 155, 117, 16, etc. décrivent un ancien état et des catégories différentes. | Snapshot final produit par l'audit du dépôt. | Geler une version et générer automatiquement tous les tableaux descriptifs. |
| **3.1 Petite méta-analyse** | Le rapport annonce une étude bibliométrique et fournit la question générale. | **Point de départ seulement.** Aucun protocole ni résultat publiable n'y est établi. | Protocole actualisé, grille de codage et corpus de la méta-analyse. | Définir les strates, réaliser le double codage et calculer les statistiques prévues. |
| **3.2 Périmètre et voies de collecte** | C'est l'un des apports les plus utiles : description des trois voies, de leur complémentarité et de la convergence vers la curation. | **Aide méthodologique forte**, à confronter aux scripts présents. | Scripts actuels, documentation des sources et registre. | Vérifier les critères d'inclusion/exclusion et renommer les familles de façon stable. |
| **3.3 Acquisition bibliographique et documentaire** | Le chemin DOI/dépôt → PDF → BibTeX → GROBID/TEI → données est explicité. | **Trame de processus utile.** Elle ne prouve pas que chaque étape a été appliquée à chaque fiche. | Scripts, fichiers `.bib`, TEI produits et manifests. | Documenter les vérifications d'auteur, titre, DOI, version et association article–dataset. |
| **3.4 KG et wiki** | Le rapport explique le KG comme couche de relations et le wiki comme synthèse, avec l'exemple `spDataLarge::lsl`. | **Aide claire pour expliquer l'architecture.** L'exemple doit être revérifié dans les sources et l'état actuel du KG. | Schéma et contenu actuels du KG, fiches et sources originales. | Définir précisément les entités, relations, identifiants et règles de mise à jour. |
| **3.5 Schéma de métadonnées** | Six blocs sont proposés : formule/variables, provenance, modèle, structure, résolution/étendue et reproductibilité. | **Bon ancêtre du schéma**, mais incomplet pour le V2. | Champs actuels des fiches et du registre. | Ajouter explicitement unité statistique, temps, `W`, transformations, artifact, qualité, statut, limites et lien parent–dérivé. |
| **3.6 Curation assistée et contrôle humain** | Le rapport distingue contrôles structurels, contrôle sémantique et révision humaine ; il donne un exemple d'erreur de covariable. | **Cas d'étude utile.** Les scores et seuils anciens ne doivent être cités que s'ils sont encore appliqués et documentés. | Pipeline d'audit actuel et évaluation humaine à construire. | Mesurer l'accord extraction automatique–codage humain et documenter les règles de non-validation automatique. |
| **3.7 Fabrication des Data Records et sous-échantillonnage** | Le rapport évoque conservation de la géométrie et transformation de certains supports vers des points. | **Partiel.** Il ne décrit pas un protocole complet de sous-échantillonnage, de population cible ou de filiation. | Scripts actuels de préparation et futur protocole de sous-échantillonnage. | Définir formats distribués, données brutes, transformations, graines, tailles, répétitions et liens parent–dérivé. |
| **3.8 Construction semi-synthétique** | Le rapport apporte seulement la motivation générale : combiner vérité connue et structures empiriques. | **Insuffisant pour la méthode.** Il ne couvre pas S1–S4 ni les validations réalisées depuis. | Revue semi-synthétique, TEI des articles, scripts S1–S4 et résultats validés. | Choisir les scénarios mûrs, expliciter calibration, facteurs, vérités connues, graines et limites. |
| **3.9 Registre et audit reproductible** | Le rapport décrit une ancienne convergence vers le registre du package. | **Historique technique.** Le registre ne doit plus être présenté uniquement comme registre de benchmark. | `audit_datapaper_repo.py`, registre et KG actuels. | Définir le snapshot de soumission et les invariants fiche–registre–KG–artifact. |
| **4. Data Records** | Les exemples `lsl`, Airbnb et plusieurs tableaux montrent le type d'information recherché. | **Exemples candidats**, jamais preuves définitives. Les formules, auteurs, tailles et licences doivent être revérifiés. | Fiches corrigées, données locales, articles et dépôts d'origine. | Sélectionner quelques cas représentatifs après audit et distinguer catalogué, local, distribuable et dérivé. |
| **5. Technical Validation** | Le rapport recense des erreurs silencieuses, doublons, problèmes d'accès, incohérences de variables et difficultés de support spatial. | **Très utile pour concevoir les tests**, mais les résultats du benchmark d'estimateurs sont hors périmètre. | Tests/audits actuels et protocole de validation du data paper. | Transformer les cas pertinents en contrôles de ressource : chargement, variables, formules, provenance, licences, filiation et reproductibilité. |
| **6. Usage Notes** | Il rappelle qu'une fiche complète n'est pas forcément éligible et que panels, réponses binaires et comptages demandent des traitements propres. | **Principe utile**, avec vocabulaire à actualiser. | Statuts actuels, schéma de données et documentation de redistribution. | Expliquer les limites de chaque statut, la conservation des panels parents et la différence entre réel, sous-échantillonné et semi-synthétique. |
| **7. Data/Code availability** | Le rapport envisage un dépôt ouvert séparé et mentionne les contraintes de licence. | **Perspective non décidée.** Elle ne vaut pas engagement de disponibilité. | Audit des licences, choix du dépôt public et release gelée. | Décider ce qui est redistribuable, récupérable par script ou seulement documenté, puis obtenir un DOI. |
| **8. Limites** | Plusieurs limites sont bien identifiées : sources inaccessibles, biais vers les ressources ouvertes, doublons, erreurs silencieuses et forte hétérogénéité. | **Liste de risques pertinente**, à mesurer ou illustrer avec l'état final. | Audit final, journal des erreurs et analyse des cas exclus. | Quantifier autant que possible et distinguer limite de la banque, limite de la collecte et limite semi-synthétique. |
| **9. Figures** | Les schémas de pipeline, de chaîne des métadonnées et le sous-graphe `lsl` donnent des idées de représentation. | **Maquettes conceptuelles.** Les figures finales doivent refléter le périmètre V2. | Données et architecture actuelles. | Adapter le pipeline jusqu'aux Data Records, supprimer la sortie benchmark/package et ajouter sous-échantillons et semi-synthétique. |
| **10. Suppléments** | Les annexes donnent un précédent pour documenter les pipelines, le chemin d'une source et la structure d'une fiche. | **Plan documentaire utile.** Les annexes de benchmark et dashboard sont hors périmètre. | Manifests, dictionnaire, audits, protocole de méta-analyse et paramètres semi-synthétiques actuels. | Construire les suppléments à partir d'exports reproductibles. |

## Éléments du rapport à conserver comme aide

- La distinction entre fichier disponible et ressource scientifiquement documentée.
- Les trois voies de collecte et leur convergence vers une couche commune de curation.
- La nécessité de relier réponse, covariables et formule à une preuve identifiable.
- La séparation entre sources brutes, TEI, KG, wiki, fiche et artifact.
- Les exemples d'erreurs silencieuses qui montrent pourquoi une exécution réussie ne suffit pas à valider une ressource.
- La conservation de la géométrie d'origine lors d'une transformation de support.
- Les pistes bibliographiques, à retrouver ensuite dans les textes originaux.

## Éléments à ne pas transférer directement dans le data paper

- Les paragraphes du rapport, même lorsqu'ils semblent déjà rédigés comme une introduction.
- Tous les anciens effectifs, pourcentages et statuts opérationnels.
- Les résultats de performance des estimateurs et les conclusions tirées du premier benchmark.
- La description exhaustive de `spatialtidymodels`, des moteurs, de la validation croisée et du tableau de bord.
- Les formules ou listes de covariables non revérifiées dans le papier et l'artifact correspondant.
- Les seuils de score ou rôles d'agents qui ne sont plus ceux du pipeline actuel.
- La présentation de `package_include: yes` ou `benchmark_ready` comme synonyme de Data Record redistribuable.
- Le contexte institutionnel, pédagogique et personnel propre au rapport de stage.

## Ce que cette lecture ajoute au plan V2

Le plan V2 reste cohérent. La lecture ne justifie pas d'en changer l'architecture. Elle renforce toutefois quatre exigences lors de la rédaction des Methods :

1. décrire séparément **découverte**, **récupération**, **preuve bibliographique**, **transformation** et **validation** ;
2. conserver une distinction stricte entre **géométrie originale** et représentation transformée ;
3. documenter les **échecs silencieux** et pas seulement les erreurs qui interrompent un script ;
4. présenter le rapport de stage, si nécessaire, comme un document de contexte du projet, jamais comme la preuve scientifique ou la source des chiffres du manuscrit.

## Utilisation pratique pour la rédaction

Avant de rédiger une section du data paper à partir d'une piste repérée dans le rapport :

1. retrouver l'objet correspondant dans le dépôt actuel ;
2. vérifier sa source primaire ;
3. confirmer qu'il appartient toujours au périmètre V2 ;
4. remplacer tout chiffre par celui du snapshot gelé ;
5. citer la source primaire ou le dépôt, et non le rapport, sauf si le rapport lui-même fait partie des objets documentaires déposés.

