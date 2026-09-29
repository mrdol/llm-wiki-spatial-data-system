## Bilans du pilote (DP17, DP19, DP15) — 2026-09-28

> Bilans rédigés par Claude en **mode production de repli** à partir de `evidence.jsonl`, `manifest.tsv` et de la lecture directe des fichiers cités (cache local). **Statut : `pending`, relecture humaine requise avant tout usage dans le data paper.** Les identifiants entre crochets renvoient à `evidence.jsonl` (`evidence_id`) ou à la version examinée.

### Comment relire (tâche de l'utilisateur)

Ouvrir `revue_humaine.tsv` (Excel ou LibreOffice, séparateur tabulation). Chaque ligne correspond à un article × une dimension. Pour chacune :
1. lire `proposition_claude` et `justification_claude` ; au besoin, ouvrir les preuves de `preuves_a_lire`, dont l'identifiant se retrouve dans `evidence.jsonl` avec le chemin, les lignes et le lien permanent ;
2. écrire dans `decision` l'un des quatre statuts exacts : `confirmé dans le dépôt`, `présent mais non documenté`, `décrit dans l'article` ou `non trouvé` ;
3. facultativement, remplir `commentaire` et `relu_le`.

Le statut « confirmé dans le dépôt » n'apparaît dans la comparaison et le rapport qu'après une décision. L'outil ne réécrit jamais les colonnes `proposition_claude`, `justification_claude`, `decision`, `commentaire` ni `relu_le`.

### Mise à jour du 2026-09-28 (après les réponses de l'utilisateur)
- **DP15 :** le DOI Code Ocean est corrigé en `10.24433/CO.0837444.v1` d'après la bibliographie du PDF (GROBID avait tronqué `.v1`). Correction tracée dans `seeds.tsv` ; DataCite l'indique comme résolu (v1.0, GPL / CC-BY-SA-4.0).
- **DP19 :** l'archive `datasets.tar.gz` a été vérifiée par une sonde HTTP.
  - Elle pèse 17,1 Mo et date du 20 février 2018 (last-modified), avant l'article (2019) et avant le dernier commit GitHub (2022).
  - Son premier bloc de 4 Mo liste 74 membres, dont des fichiers macOS `._*`, et un dossier `dethlefsen` **absent du dépôt GitHub** : le corpus redistribué a changé.
  - L'archive de référence `gg97.tar.gz`, recommandée dans `add-datasets-readme.md`, est morte (HTTP 404). La copie S3 de `datasets.tar.gz` citée par GigaDB refuse l'accès (HTTP 403).
- **Classeurs `.xlsx` lus :** `web/data/dataset_metadata.xlsx` (MLRepo) contient une feuille **« excluded tasks »** avec une seule tâche exclue (Turnbaugh, jumeaux MZ), sans motif. `doc/boctor_format.xlsx` et `doc/alvarez_tamarit_format.xlsx` (CMPD) ont aussi été lus. En revanche, les classeurs que le README de CMPD décrit (`doc/datasets_info.xlsx`, « Datasets with Parameters and BKS… ») **ne sont pas dans l'arborescence**, pas plus que le dossier `tools/`.
- **DP17 :** les unités sont documentées variable par variable (`man/epi_nutr.Rd`, µg/l…). Les coordonnées sont documentées en **NAD83** (`man/locus.Rd`), mais `coordinatize()` leur attribue par défaut **EPSG:4326 (WGS84)** (`R/coordinates.R` l. 10), ce qui est une incohérence de datum.
- **Liens de 2ᵉ niveau :** conformément à ta décision, ils comptent désormais dans la comparaison, et chaque preuve concernée porte la mention « (lien depuis une ressource) ».
- **Bruit réduit :** les textes de licence ne documentent plus que la licence, les fichiers de données sous `data/` ou `datasets/` ne sont lus que pour leur en-tête, et la configuration CI ne documente que les dépendances, la version et la licence.

### DP17 — LAGOS-NE (intégration spatiale multi-source)

**Ce que les dépôts apportent au-delà du PDF**

- **Le dépôt GitHub cité dans l'article (`cont-limno/LAGOS`) ne contient pas la chaîne de constitution de la base.** Il redirige aujourd'hui vers `cont-limno/LAGOSNE`, un paquet R d'**accès** aux données (commit `dd59be8`, 2026-02-19 ; 12 tags ; licence non déclarée dans l'API GitHub). `lagosne_get()` télécharge les modules depuis le portail EDI puis les « compile » en objet R [`b3d6794cd75255da`, `R/get.R` l. 39-41].
- **Une copie datée du dépôt existe et c'est elle qui correspond à l'article.** GigaDB (`10.5524/100350`, CC0) archive le dépôt GitHub au 15 septembre 2017 (`LAGOS-master.zip`, 131 membres, lu par Range) et des copies des modules EDI au 18 septembre 2017. Son `readme.txt` précise que cette copie « will not be updated ». Le README archivé annonce la version 1.087.1 [`fb3ca5b0921bdcd5`].
- **Le versionnage réel est plus fin que les numéros de version.** Un même libellé (ex. `LIMNO v1.087.1`, `GEO v1.05`) correspond à plusieurs révisions EDI :
  - l'article cite `edi.101.2`, `edi.99.5`, `edi.100.4` et `edi.98.3` ;
  - GigaDB cite `edi.101.1`, `edi.99.3`, `edi.100.1` et `edi.98.1` ;
  - le paquet R utilise aujourd'hui LIMNO `1.087.3` (`edi.101.3`), et son `NEWS.md` documente cette mise à jour (seul le module limno est mis à jour dynamiquement).
- **Existence d'un cinquième paquet, LAGOS-NE-RAWDATA.** D'après les résumés DataCite des modules, il contient les 87 jeux originaux avant traitement, le code R de conversion au format LAGOS-NE et le journal de cette procédure. C'est là que se trouverait la chaîne de collecte et d'harmonisation.
- **Le DOI EDI tronqué par GROBID (`…/f00a245fd9461529b8cd9`) a été reconstitué** à partir du README du paquet R (`knb-lter-ntl.320.4`). Il s'agit d'un jeu dérivé de prédiction de profondeur maximale, pas d'un module LAGOS-NE.

**Preuves retrouvées**
- `manifest.tsv` : 4 modules EDI (DOI de version), GigaDB, le dépôt GitHub et la copie archivée.
- Les résumés DataCite des modules (origine : 87 jeux de qualité de l'eau, agences et universités ; modules LOCUS/GEO/LIMNO/GIS).

**Ce qui reste inconnu**
- **Listes de fichiers, formats, volumes et métadonnées EML des modules EDI.** Le 2026-09-28, l'API PASTA a refusé l'accès public à toutes ses méthodes (HTTP 403, méthodes `readMetadata`, `readDataPackage`…), et le portail EDI affiche une page de connexion. L'outil n'a pas tenté d'authentification.
- **Le DOI de LAGOS-NE-RAWDATA**, donc les règles de nettoyage, de jointure et de déduplication, les conversions d'unités et le contrôle qualité tels qu'ils sont codés.
- **Le CRS et la reprojection des couches GIS.** Aucune preuve documentaire lue ; l'EML n'est pas accessible.

**Enseignements transférables**
- Distinguer explicitement le **dépôt d'accès** (le paquet R), le **dépôt de constitution** (RAWDATA : sources brutes, code, journal) et les **modules publiés**.
- Associer chaque version sémantique à un identifiant de révision immuable (DOI de révision ou commit), et dater les copies archivées.
- Prévoir une copie d'archive au moment de la publication : GigaDB a sauvé le dépôt de 2017, que le dépôt vivant a remplacé.

### DP19 — Microbiome Learning Repo (chaîne article → données → tâches)

**Ce que les dépôts apportent au-delà du PDF**
- **Le dépôt GitHub (`knights-lab/MLRepo`, commit `4bbfee9`, 2022-01-13, MIT, aucune release ni tag) est la ressource elle-même.** Il contient 183 fichiers pour 191 Mo, dont les tables OTU et taxa par étude sous deux références (`gg`, `refseq`), les fichiers de tâche et les fichiers de correspondance (`mapping-orig.txt`), en texte brut sans Git LFS.
- **Deux registres lisibles par machine structurent la chaîne :**
  - `web/data/datasets.txt` décrit 15 études [`ef9297499ed70bc8`] : source brute (`raw_data_source`), FASTA traité, `num_samples`, `num_subjects`, `study_design`, `original_mapping_file`, etc. ;
  - `web/data/tasks.txt` décrit 33 tâches : `task_id`, `data_type`, fichiers de tâche et d'OTU et `control_vars`.
- **Une fiche par tâche** (`docs/*.md`) indique le type de réponse, le nombre d'échantillons, les règles de sélection et si un sujet a plusieurs échantillons. Exemple : sous-ensemble RISK, patients sans immunosuppression, un échantillon représentatif « chosen arbitrarily » par site et par personne [permalink `docs/gevers_pcdai_ileum.md`].
- **Le protocole d'ajout de jeux** (`add-datasets-readme.md`) comprend :
  - le dépôt public des FASTQ ou FASTA ;
  - le traitement recommandé avec SHI7 puis BURST, avec références RefSeq ou GG97 ;
  - l'ajout de lignes aux deux registres puis une revue par pull request [`8ec9cb59b862a8af`].
  
  L'exigence de « rigorous standards in filtering » n'est pas opérationnalisée [`cb86bc170156459d`].
- **Le benchmark se limite à un exemple.** `example/lib/cross.validation.caret.r` implémente une validation croisée en K folds avec random forest et SVM [`9276a5a4d5b75183`, `0827af22ace418b2`]. Aucun split figé n'est publié.

**Ce qui reste inconnu**
- **Traitement des séquences :** les paramètres réellement appliqués par SHI7 et BURST pour les jeux publiés ne sont pas trouvés dans le dépôt. `shi7` n'a été lu qu'au titre de lien depuis une ressource.
- **Archive complète :** l'archive `datasets.tar.gz` (hôte `metagenome.cs.umn.edu`) n'a pas été vérifiée, car le lien ne pointe pas vers un fournisseur reconnu.
- **README GigaDB :** le fichier `readme_100581.txt` de GigaDB a répondu HTTP 403.
- **Fuites entre tâches :** aucune protection contre les fuites entre tâches issues d'une même étude n'est documentée.

**Enseignements transférables**
- **Modèle directement réutilisable :** un registre des jeux, un registre des tâches et une fiche par tâche comportant réponse, N, règle de sélection et répétitions par sujet.
- **Formaliser la règle de sélection** au lieu de « chosen arbitrarily ».
- **Livrer les splits figés avec la tâche.**

### DP15 — CMPD (parseurs, schéma commun, original / généré)

**Ce que les dépôts apportent au-delà du PDF**
- **`novakge/project-parsers`** (commit `8788f9f`, 2025-12-16, GPL-3.0, tags `v0.2.0` à `v0.2.2`, dernière release 2023-01-25) :
  - il conserve **les bibliothèques sources dans leurs formats natifs** : `data/PSPLIB` 13 222 fichiers, `data/BY` 12 320, `data/mmlibplus` 3 240, `data/RG30` 1 800, etc. ;
  - il fournit **un parseur par format** (`parse_rangen`, `parse_protrack`, `parse_xlib`, `parse_boctor`, `parse_progen`, `parse_rcmp`), chacun avec ses tests unitaires (`*_test.m`) ;
  - son README décrit le schéma cible commun `PDM = [DSM, TD, CD, {QD, RD}]` pour trois types de problèmes (NTP, CTP, DTP) ;
  - il documente une rétro-ingénierie du format Boctor (`doc/boctor_format.xlsx`, fichier binaire non lu) ;
  - le README décrit un dossier `tools/` contenant des exécutables (Rangen.exe, PMConverter.exe) **absent de l'arborescence examinée**.
- **`novakge/project-indicators`** (commit `2adc9e1`, 2024-06-06) calcule les indicateurs et **génère des structures flexibles** (tâches supplémentaires, dépendances flexibles) à partir des instances parsées [`056051b821e1a8ff`]. C'est la frontière entre instances originales et instances générées.
- **Figshare `10.6084/m9.figshare.23937978` (v1, 2024-01-26, licence GPL 3.0+)** :
  - il contient deux archives, `CMPD_mat.zip` (7,2 Go) et `CMPD_json.zip` (9,8 Go), de **1 561 144 et 1 561 143 membres déclarés** (répertoires centraux de 222 et 172 Mo, listés par échantillon) ;
  - l'échantillon JSON est rangé par bibliothèque source (`Boctor`, `BY`…) ;
  - sa description tient en une phrase.

**Ce qui reste inconnu**
- **Répartition original / généré :** l'écart entre environ 34 000 fichiers sources et 1,56 million de membres suggère une forte part d'instances dérivées (types de problèmes × variantes flexibles). Ce n'est **qu'une hypothèse fondée sur des comptes**, à vérifier dans l'article ou dans une liste complète.
- **Code Ocean :** la capsule répond HTTP 403. Le DOI correct `10.24433/CO.0837444.v1` (voir la mise à jour) donne les métadonnées DataCite, mais pas le contenu de la capsule.
- **Version exacte du code** ayant produit le dépôt Figshare de 2024 : le commit HEAD est de 2025-12.

**Enseignements transférables**
- Conserver les sources dans leur format natif à côté du format harmonisé.
- Prévoir un parseur par format, testé unitairement sur des fichiers de test versionnés.
- Séparer le dépôt de conversion (instances originales) du dépôt de génération (instances dérivées).
- Publier le nombre d'instances par niveau : sources, harmonisées, générées.

### Enseignements communs pour notre méthode de collecte
1. **Documenter trois dépôts distincts** : accès, constitution (sources brutes, code, journal) et publication ; relier chacun à un identifiant de révision.
2. **Dater les instantanés.** Les trois cas ont un dépôt vivant qui a divergé de l'état publié : LAGOSNE en 2026, CMPD en 2025, MLRepo sans tag. Il faut donc citer un commit ou un tag, pas une branche.
3. **Les registres lisibles par machine valent mieux que la prose.** MLRepo le montre ; c'est aussi ce que visent nos fiches et notre manifeste.
4. **Accès aux métadonnées :** un portail qui passe derrière une connexion (EDI) rend invérifiables des métadonnées pourtant publiées. Il faut garder une copie publique minimale (DataCite + archive).
5. **Aucune matrice W ni structure de voisinage n'a été trouvée dans ces dépôts.** Nos matrices W restent notre contribution et ne doivent pas leur être attribuées.

### Limites de l'outil observées pendant le pilote
- **Statuts automatiques trop généreux :** les correspondances par mots-clés rendent le statut « confirmé dans le dépôt » trop facile à obtenir (ex. « unique( » dans un commentaire compté en déduplication pour MLRepo). La colonne `niveau_preuve` le signale ; seuls les éléments ci-dessus ont été relus.
- **Tableurs :** les classeurs `.xlsx` de documentation sont lus avec openpyxl, déjà présent dans le venv ; les classeurs de données ne le sont pas.
- **Archives `.tar.gz` :** seul le premier bloc de 4 Mo est listé, car un flux gzip ne se lit pas par accès aléatoire. La liste est marquée « échantillonnée ».
- **Limite GitHub :** sans `GITHUB_TOKEN`, l'API GitHub anonyme (60 requêtes/h) suffit pour le pilote. Pour les 17 autres articles, un jeton est recommandé, sinon l'outil bascule sur des clones partiels.

### Journal du mode production de repli (à relire par Codex / mainteneur avant commit)
- **Fichiers créés :**
  - `tools/audit_datapaper_repositories.py` ;
  - `tools/datapaper_repo_audit/` (`netcache.py`, `links.py`, `providers.py`, `remotezip.py`, `evidence.py`, `pipeline.py`, `report.py`, `cli.py`, `tests/test_audit.py`) ;
  - les sorties de `repo_audit/`.
- **Aucune modification** des fiches wiki, du KG, de `raw/` ni de scripts existants.
- **Sources :** TEI des trois articles, grille `grille_comparative_20_data_papers_2026-09-26.tsv`, API GitHub, DataCite, DOI handles, GigaDB, Figshare, pages web publiques. Accès refusés : PASTA/EDI, Code Ocean, SciCrunch, une page d'éditeur.
- **Hypothèses :**
  - la relation « ressource » dépend de la section de disponibilité et du propriétaire GitHub ;
  - les liens découverts à la profondeur 1 sont exclus de la comparaison.
- **À relire manuellement :** tous les statuts de `comparaison_methodes_collecte.tsv` (automatiques) et les trois bilans ci-dessus.
