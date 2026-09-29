# Prompt pour Claude Code — explorateur de dépôts associés aux data papers

Travaille dans le dépôt `llm-wiki-karpathy`. Commence par lire `AGENTS.md` s'il existe, puis les scripts et conventions déjà utilisés pour les PDF, TEI, bibliographies, inventaires de données et graphe de connaissances. Ne duplique pas une fonction existante.

Construis un outil Python robuste, relançable et économe en stockage pour examiner les dépôts de code et de données associés aux 20 data papers recensés dans :

- `extensions_projet_2026-09/revue_jeux_donnees_benchmark/grille_comparative_20_data_papers_2026-09-26.tsv`
- `extensions_projet_2026-09/revue_jeux_donnees_benchmark/tei/`
- `extensions_projet_2026-09/revue_jeux_donnees_benchmark/articles_complementaires_2026-09-09/`

L'objectif n'est pas de relancer leurs benchmarks. Il faut déterminer, preuves à l'appui, comment chaque banque a été constituée, documentée, transformée, contrôlée, versionnée et publiée.

## Comportement attendu

1. Extraire des TEI et métadonnées les DOI, URL de projet, dépôts de code, dépôts de données et documentation.
2. Résoudre et dédupliquer les liens, puis reconnaître GitHub, GitLab, Zenodo, Figshare, OSF, Dryad, Dataverse, OpenML et les sites génériques.
3. Travailler en deux phases :
   - `inventory` : métadonnées et arborescences seulement, sans télécharger les gros fichiers;
   - `inspect` : lecture ciblée des fichiers textuels utiles.
4. Pour Git, utiliser d'abord l'API ou un clone partiel sans blobs (`--filter=blob:none --no-checkout`). Ne jamais récupérer Git LFS ou un jeu volumineux par défaut.
5. Relever le commit, tag ou DOI de version examiné et mettre en cache les réponses pour rendre l'analyse reproductible.
6. Examiner en priorité README, documentation, LICENSE, CITATION.cff, fichiers de métadonnées et schémas, scripts de collecte, parseurs, notebooks, workflows, manifests de dépendances, tests, fiches de données et releases.
7. Ne jamais exécuter le code tiers par défaut. L'analyse doit être statique. Toute future exécution doit être une option séparée, désactivée par défaut et conçue pour un environnement isolé.

## Informations à extraire avec preuves

Pour chaque affirmation, stocker l'URL du dépôt, le commit ou la version, le chemin du fichier et les lignes pertinentes. Utiliser `unknown` lorsque la preuve manque; ne rien déduire à partir du seul nom d'un fichier.

- origine et nombre des sources intégrées;
- critères d'inclusion et d'exclusion;
- méthode de collecte ou d'acquisition;
- scripts, API et téléchargements employés;
- règles de nettoyage, jointure et déduplication;
- transformations des réponses, prédicteurs et unités;
- conservation des identifiants parents, groupes, temps et répétitions;
- coordonnées, géométrie, CRS, reprojection, résolution et rééchantillonnage;
- valeurs manquantes, contrôles qualité et validation manuelle;
- séparation entre données originales, dérivées, augmentées et synthétiques;
- séparation entre corpus inventorié, corpus analysé et corpus redistribué;
- tâches, splits et protections contre les fuites lorsqu'ils font partie de la ressource;
- fichiers réellement téléchargeables, volume et format;
- provenance, licence, conditions de redistribution et citation;
- politique de version, maintenance et ajout de nouvelles sources;
- rôle exact du benchmark : validation légère de la ressource ou contribution centrale.

## Sorties minimales

Créer un seul répertoire de sortie, par exemple `extensions_projet_2026-09/revue_jeux_donnees_benchmark/repo_audit/`, contenant :

- `manifest.tsv` : une ligne par article et dépôt;
- `evidence.jsonl` : une observation sourcée par ligne;
- `comparaison_methodes_collecte.tsv` : synthèse comparable entre articles;
- `rapport.md` : synthèse lisible, lacunes et éléments réutilisables dans notre data paper;
- `cache/` : réponses réseau réutilisables, ignorées par Git si elles sont volumineuses.

Le tableau comparatif doit séparer explicitement `décrit dans l'article`, `confirmé dans le dépôt`, `présent mais non documenté` et `non trouvé`. Il doit également distinguer la collecte des données de la méthodologie de benchmark.

## Interface proposée

Prévoir une CLI du type :

```text
python tools/audit_datapaper_repositories.py inventory --grid <tsv> --out <dir>
python tools/audit_datapaper_repositories.py inspect --paper DP17 --out <dir>
python tools/audit_datapaper_repositories.py report --out <dir>
```

Ajouter des options `--offline`, `--refresh`, `--max-file-mb`, `--max-repo-mb`, `--provider`, `--paper` et `--workers`. Respecter les limites d'API et les temporisations; journaliser clairement les accès refusés et les liens morts.

## Qualité et intégration au dépôt

- Réutiliser les bibliothèques déjà présentes avant d'ajouter une dépendance.
- Ajouter des tests unitaires avec petites fixtures locales et réponses réseau simulées.
- Ne modifier ni les fiches datasets ni le KG pendant l'audit. Produire d'abord des propositions traçables à examiner.
- Ne pas créer une multitude de CSV intermédiaires.
- Ne pas présenter une matrice `W` construite par notre projet comme une matrice employée par les auteurs.
- Documenter la commande de reprise après interruption et la consommation disque.

## Pilote obligatoire

Valider l'outil sur trois cas contrastés avant de lancer les 20 :

1. LAGOS-NE (`DP17`) pour l'intégration spatiale multi-source;
2. Microbiome Learning Repo (`DP19`) pour la chaîne article–données–tâches;
3. CMPD (`DP15`) pour les parseurs, le schéma commun et la distinction original/généré.

Pour chaque pilote, produire un court bilan indiquant ce que le dépôt apporte au-delà du PDF, les preuves retrouvées, ce qui reste inconnu et les enseignements transférables à notre méthode de collecte. Arrête-toi après le pilote pour faire relire les résultats avant l'analyse des 17 autres articles.
