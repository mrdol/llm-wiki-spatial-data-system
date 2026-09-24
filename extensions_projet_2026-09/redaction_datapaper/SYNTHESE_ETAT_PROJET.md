# Synthèse consolidée de l’état du projet

Date du snapshot : **2026-09-24T10:11:49+02:00**  
Source : audit local reproductible par `tools/audit_datapaper_repo.py`.

## État mesuré

- Dépôt analysé : **9131 fichiers** hors `.git`, `.venv`, `node_modules` et `.claude`.
- Fiches datasets : **392** (`paper`: 280, `software_or_other`: 111, `warehouse`: 1).
- Registre `spatialtidymodels` : **392 enregistrements**, généré le **2026-09-24T07:43:30.107452+00:00**.
- Artifacts locaux déclarés dans le registre : **392**.
- Champs `formula_used` présents dans le registre : **392**, dont **354** différents de `pending`.
- KG : **80653 nœuds** et **108366 relations**.
- Bibliographies : **12 fichiers `.bib`**, **669 entrées**, **427 champs DOI**.
- Extension septembre : **560 fichiers**.
- Alignement fiches–registre : **392 identifiants communs**, **0 seulement dans les fiches**, **0 seulement dans le registre**, **0 désaccords de champs non vides**.

## Ventilation par typologie, panel et découpage parent/enfant

Calculée deux fois, sur des populations différentes qui ne doivent jamais être confondues : **toutes les fiches** (`ty_all`) et **seulement `package_include: yes`** (`ty_yes`, la banque réellement utilisable).

| | Toutes les fiches (392) | `package_include: yes` (278) |
|---|---|---|
| Typologie de la variable réponse | `binary`: 27, `categorical`: 8, `continuous`: 281, `count`: 56, `rate`: 13, `unknown`: 7 | `binary`: 20, `categorical`: 1, `continuous`: 236, `count`: 14, `rate`: 7 |
| Panels stricts (câblés harnais, `data_structure: spatial_panel`) | 13 | 12 |
| Panels — étiquette libre seulement (Bloc 4 `structure`) | 53 | 42 |
| Spatio-temporel au sens large (`t_periods` &gt; 1) | 58 | 45 |
| Coupe transversale stricte | 334 | 233 |
| Fiches enfants (découpage) | 151 sur 7 parents | 150 sur 7 parents |
| dont enfants orphelins (parent hors de cette population) | 0 | 3 |
| **Jeux distincts dédupliqués** | **241** | **131** |

Les panels stricts (`data_structure: spatial_panel`) ne doivent jamais être confondus avec l'étiquette libre « panel » du Bloc 4 : la plupart des candidats « panel » se sont révélés être des coupes transversales quasi fictives à l'inspection (T médian = 1). La déduplication ne soustrait un enfant que si son propre parent appartient à la même population comptée ici — un enfant dont le parent est resté `manual_review` (ex. `paper_red_deer_topdown` → `_492`) reste compté comme seul représentant `yes` de sa famille, au lieu de disparaître silencieusement (bug trouvé et corrigé le 2026-09-24 : le calcul restreint aux `yes` donnait d'abord 128 au lieu de 131).

Détail des familles avec enfants `yes` : `R_agridat_lasrosas.corn_lasrosas.corn`: 1, `paper_gwqlasso_mt`: 29, `paper_gwqlasso_pr`: 43, `paper_gwqlasso_rs`: 43, `paper_korea_hedonic_housing`: 32, `paper_red_deer_topdown`: 1, `paper_regulatory_convergence`: 1.

## Lecture éditoriale

Le dépôt contient aujourd’hui quatre niveaux qu’il faut maintenir séparés : le catalogue de fiches, les preuves structurées du KG, le registre exécutable du package et les textes destinés au data paper. Le nombre de fiches et le nombre de nœuds `Dataset` du KG ne mesurent pas la même chose. De même, une entrée du registre ne prouve ni l’exécution d’un benchmark ni son admissibilité scientifique.

Le registre exporté le **2026-09-24** marque actuellement **278 entrées `package_include: yes`**, **59 `manual_review`** et **55 `no`**. Les anciens totaux de 35 ou 155 jeux décrivaient d’autres états ou périmètres. Ils ne doivent pas être comparés directement à ces 278 décisions d’inclusion. Avant publication, le manuscrit devra nommer explicitement la population comptée : fiches cataloguées, artifacts locaux, entrées `yes` ou benchmarks réellement exécutés.

Les couches sont alignées sur les identifiants et sur les champs non vides contrôlés.

Les revues de septembre constituent la couche narrative la plus récente. Les brouillons de juillet et août restent utiles pour leur structure, mais leurs chiffres ne peuvent plus être repris. L’audit détecte **2 documents** avec un ancien nombre de fiches ou une formulation explicitement périmée.

## Sources canoniques proposées

| Information | Source canonique |
|---|---|
| Nombre et contenu des fiches | `wiki/datasets/fiches_datasets/*.md` |
| État exporté vers le package | `packages/spatialtidymodels/inst/metadata/datasets.json` |
| Relations papers–datasets–variables–formules | `.kg/graph.sqlite` |
| Positionnement face aux banques existantes | `extensions_projet_2026-09/revue_jeux_donnees_benchmark/` |
| Programme semi-synthétique | `extensions_projet_2026-09/revue_donnees_semi_synthetiques/` |
| Manuscrit final | futur dossier `extensions_projet_2026-09/redaction_datapaper/` |

## Réserves

- Les champs `package_include` et `benchmark_status` doivent être lus dans leur contexte ; une absence n’équivaut pas à `no`.
- Les doublons BibTeX entre fichiers peuvent être légitimes, mais devront être résolus dans une bibliographie maîtresse du manuscrit.
- Le KG est une couche de preuves et non la vérité narrative finale.
- Les résultats S1–S4 restent des pilotes autonomes du package.
